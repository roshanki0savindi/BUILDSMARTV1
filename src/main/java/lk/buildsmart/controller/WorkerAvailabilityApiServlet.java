package lk.buildsmart.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.WorkerAvailabilityDAO;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.model.User;
import lk.buildsmart.model.Worker;
import lk.buildsmart.model.WorkerAvailability;
import lk.buildsmart.util.SessionManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * REST-style AJAX API for the worker availability calendar.
 *
 * Endpoints (all under /api/availability):
 *
 *   GET  ?workerId={id}&year={yyyy}&month={mm}
 *        ΓåÆ Returns a JSON array of unavailable date strings ("YYYY-MM-DD") for that month.
 *        ΓåÆ Public ΓÇö any visitor can call this.
 *
 *   POST action=toggle&date={YYYY-MM-DD}
 *        ΓåÆ Marks or unmarks the given date for the logged-in worker.
 *        ΓåÆ Protected ΓÇö only the owning worker may toggle their own dates.
 *        ΓåÆ Returns JSON: { "status": "added"|"removed", "date": "YYYY-MM-DD" }
 */
@WebServlet("/api/availability")
public class WorkerAvailabilityApiServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(WorkerAvailabilityApiServlet.class);
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ISO_LOCAL_DATE; // YYYY-MM-DD
    private static final Gson gson = new Gson();

    private final WorkerAvailabilityDAO availabilityDAO = new WorkerAvailabilityDAO();
    private final WorkerDAO workerDAO = new WorkerDAO();

    // =========================================================================
    // GET ΓÇö public read (fetch unavailable dates for a worker in a given month)
    // =========================================================================

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            // --- Parameter validation ---
            int workerId = parsePositiveInt(req.getParameter("workerId"), "workerId");

            String yearParam  = req.getParameter("year");
            String monthParam = req.getParameter("month");

            // If year/month not supplied, default to current month
            YearMonth ym;
            if (yearParam == null || monthParam == null) {
                ym = YearMonth.now();
            } else {
                int year  = parsePositiveInt(yearParam, "year");
                int month = parsePositiveInt(monthParam, "month");
                if (month < 1 || month > 12) {
                    sendError(resp, out, HttpServletResponse.SC_BAD_REQUEST, "month must be 1-12");
                    return;
                }
                ym = YearMonth.of(year, month);
            }

            LocalDate firstOfMonth = ym.atDay(1);
            LocalDate lastOfMonth  = ym.atEndOfMonth();

            // --- Fetch all unavailable dates for the worker, filter to this month ---
            List<WorkerAvailability> all = availabilityDAO.getByWorkerId(workerId);
            List<String> unavailableDates = all.stream()
                    .map(WorkerAvailability::getUnavailableDate)
                    .filter(d -> !d.isBefore(firstOfMonth) && !d.isAfter(lastOfMonth))
                    .map(d -> d.format(DATE_FMT))
                    .collect(Collectors.toList());

            out.print(gson.toJson(unavailableDates));

        } catch (IllegalArgumentException e) {
            sendError(resp, out, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            logger.error("Unexpected error in GET /api/availability", e);
            sendError(resp, out, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    // =========================================================================
    // POST ΓÇö protected toggle (only the owning worker can modify their dates)
    // =========================================================================

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // 1. Auth check
        User loggedInUser = SessionManager.getLoggedInUser(req);
        if (loggedInUser == null || !"worker".equals(loggedInUser.getRole())) {
            sendError(resp, out, HttpServletResponse.SC_UNAUTHORIZED,
                      "You must be logged in as a worker to manage availability.");
            return;
        }

        try {
            // 2. Date parameter
            String dateParam = req.getParameter("date");
            if (dateParam == null || dateParam.isBlank()) {
                sendError(resp, out, HttpServletResponse.SC_BAD_REQUEST, "Missing required parameter: date");
                return;
            }

            LocalDate date;
            try {
                date = LocalDate.parse(dateParam.trim(), DATE_FMT);
            } catch (DateTimeParseException e) {
                sendError(resp, out, HttpServletResponse.SC_BAD_REQUEST,
                          "Invalid date format. Expected YYYY-MM-DD, got: " + dateParam);
                return;
            }

            // 3. Don't allow marking dates in the past
            if (date.isBefore(LocalDate.now())) {
                sendError(resp, out, HttpServletResponse.SC_BAD_REQUEST,
                          "Cannot modify availability for past dates.");
                return;
            }

            // 4. Look up the worker profile for the logged-in user
            Worker worker = workerDAO.getByUserId(loggedInUser.getUserId());
            if (worker == null) {
                sendError(resp, out, HttpServletResponse.SC_NOT_FOUND,
                          "Worker profile not found for the current user.");
                return;
            }

            int workerId = worker.getWorkerId();

            // 5. Fetch existing unavailable dates and check if this date exists
            List<WorkerAvailability> existing = availabilityDAO.getByWorkerId(workerId);
            boolean alreadyUnavailable = existing.stream()
                    .anyMatch(a -> date.equals(a.getUnavailableDate()));

            JsonObject responseObj = new JsonObject();
            responseObj.addProperty("date", date.format(DATE_FMT));

            if (alreadyUnavailable) {
                // Toggle OFF ΓåÆ delete
                boolean deleted = availabilityDAO.delete(workerId, date);
                if (!deleted) {
                    sendError(resp, out, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                              "Failed to remove the unavailability entry.");
                    return;
                }
                responseObj.addProperty("status", "removed");
                logger.info("Worker {} marked {} as AVAILABLE again", workerId, date);
            } else {
                // Toggle ON ΓåÆ insert
                WorkerAvailability entry = new WorkerAvailability(workerId, date);
                boolean inserted = availabilityDAO.insert(entry);
                if (!inserted) {
                    sendError(resp, out, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                              "Failed to save the unavailability entry.");
                    return;
                }
                responseObj.addProperty("status", "added");
                logger.info("Worker {} marked {} as UNAVAILABLE", workerId, date);
            }

            out.print(gson.toJson(responseObj));

        } catch (IllegalArgumentException e) {
            sendError(resp, out, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            logger.error("Unexpected error in POST /api/availability", e);
            sendError(resp, out, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    // =========================================================================
    // Helpers
    // =========================================================================

    private int parsePositiveInt(String value, String paramName) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Missing required parameter: " + paramName);
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            if (parsed <= 0) throw new IllegalArgumentException(paramName + " must be a positive integer.");
            return parsed;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid value for " + paramName + ": " + value);
        }
    }

    private void sendError(HttpServletResponse resp, PrintWriter out, int statusCode, String message) {
        resp.setStatus(statusCode);
        JsonObject err = new JsonObject();
        err.addProperty("error", message);
        out.print(gson.toJson(err));
    }
}
