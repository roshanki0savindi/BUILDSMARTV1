package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.buildsmart.dao.ReviewDAO;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.model.Review;
import lk.buildsmart.model.User;
import lk.buildsmart.model.Worker;
import lk.buildsmart.util.SessionManager;
import lk.buildsmart.util.ImageUtil;

import java.io.IOException;
import java.time.LocalDateTime;

import java.util.List;

@WebServlet("/worker/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class WorkerProfileServlet extends HttpServlet {
    private final WorkerDAO workerDAO = new WorkerDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        Worker worker = null;

        try {
            if (idParam != null && !idParam.isBlank()) {
                try {
                    int id = Integer.parseInt(idParam);
                    worker = workerDAO.getByWorkerId(id);
                    if (worker == null) {
                        worker = workerDAO.getByUserId(id);
                    }
                } catch (NumberFormatException ignore) {}
            }

            // Fallback for logged in worker user
            if (worker == null) {
                User loggedInUser = SessionManager.getLoggedInUser(req);
                if (loggedInUser != null && "worker".equals(loggedInUser.getRole())) {
                    worker = workerDAO.getByUserId(loggedInUser.getUserId());
                }
            }

            // Fallback for Guest Mode without specific ID or invalid ID
            if (worker == null) {
                List<Worker> activeWorkers = workerDAO.getAllActiveWorkers();
                if (!activeWorkers.isEmpty()) {
                    worker = workerDAO.getByWorkerId(activeWorkers.get(0).getWorkerId());
                }
            }

            if (worker == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Worker profile not found");
                return;
            }

            req.setAttribute("worker", worker);
            req.setAttribute("reviews", reviewDAO.getByTarget("worker", worker.getWorkerId()));

            req.getRequestDispatcher("/WEB-INF/views/worker_profile.jsp").forward(req, resp);

        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading worker profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = SessionManager.getLoggedInUser(req);
        if (user == null || !"homeowner".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only homeowners can leave reviews.");
            return;
        }

        try {
            int workerId = Integer.parseInt(req.getParameter("targetId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");

            Part filePart = req.getPart("review_photo");
            byte[] imageBytes = ImageUtil.validateAndReadBytes(filePart);
            String mimeType  = ImageUtil.getMimeType(filePart);

            Review review = new Review(user.getUserId(), "worker", workerId, rating, comment, imageBytes, mimeType);
            review.setReviewDate(LocalDateTime.now());
            
            reviewDAO.insert(review);
            
            resp.sendRedirect(req.getContextPath() + "/worker/profile?id=" + workerId + "&msg=review_added");

        } catch (IllegalArgumentException e) {
            // Catch Upload validation errors
            String workerId = req.getParameter("targetId");
            resp.sendRedirect(req.getContextPath() + "/worker/profile?id=" + workerId + "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to submit review.");
        }
    }
}
