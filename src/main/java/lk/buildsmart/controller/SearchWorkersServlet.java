package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.model.Worker;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/workers")
public class SearchWorkersServlet extends HttpServlet {
    private final WorkerDAO workerDAO = new WorkerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String q         = req.getParameter("q");
            String district  = req.getParameter("district");
            String sortBy    = req.getParameter("sort");
            String minPriceS = req.getParameter("minPrice");
            String maxPriceS = req.getParameter("maxPrice");

            List<Worker> workers = workerDAO.getAllActiveWorkers();

            // --- Filter by text (name or profession) ---
            if (q != null && !q.trim().isEmpty()) {
                String lower = q.trim().toLowerCase();
                workers = workers.stream()
                    .filter(w -> (w.getFullName() != null && w.getFullName().toLowerCase().contains(lower))
                              || (w.getProfession() != null && w.getProfession().toLowerCase().contains(lower))
                              || (w.getSkills() != null && w.getSkills().toLowerCase().contains(lower)))
                    .collect(Collectors.toList());
            }

            // --- Filter by district ---
            if (district != null && !district.trim().isEmpty() && !district.equalsIgnoreCase("all")) {
                String d = district.trim();
                workers = workers.stream()
                    .filter(w -> d.equalsIgnoreCase(w.getDistrict()))
                    .collect(Collectors.toList());
            }

            // --- Filter by min price ---
            if (minPriceS != null && !minPriceS.trim().isEmpty()) {
                try {
                    BigDecimal minP = new BigDecimal(minPriceS.trim());
                    workers = workers.stream()
                        .filter(w -> w.getDailyRate() != null && w.getDailyRate().compareTo(minP) >= 0)
                        .collect(Collectors.toList());
                } catch (NumberFormatException ignored) {}
            }

            // --- Filter by max price ---
            if (maxPriceS != null && !maxPriceS.trim().isEmpty()) {
                try {
                    BigDecimal maxP = new BigDecimal(maxPriceS.trim());
                    workers = workers.stream()
                        .filter(w -> w.getDailyRate() != null && w.getDailyRate().compareTo(maxP) <= 0)
                        .collect(Collectors.toList());
                } catch (NumberFormatException ignored) {}
            }

            // --- Sort ---
            if ("price_asc".equals(sortBy)) {
                workers.sort(Comparator.comparing(w -> (w.getDailyRate() != null ? w.getDailyRate() : BigDecimal.ZERO)));
            } else if ("price_desc".equals(sortBy)) {
                workers.sort((a, b) -> {
                    BigDecimal ra = a.getDailyRate() != null ? a.getDailyRate() : BigDecimal.ZERO;
                    BigDecimal rb = b.getDailyRate() != null ? b.getDailyRate() : BigDecimal.ZERO;
                    return rb.compareTo(ra);
                });
            } else if ("rating".equals(sortBy)) {
                workers.sort((a, b) -> Double.compare(b.getAverageRating(), a.getAverageRating()));
            }

            req.setAttribute("workers", workers);
            req.setAttribute("q", q);
            req.setAttribute("district", district);
            req.setAttribute("sort", sortBy);
            req.setAttribute("minPrice", minPriceS);
            req.setAttribute("maxPrice", maxPriceS);

            req.getRequestDispatcher("/WEB-INF/views/workers.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading workers: " + e.getMessage());
        }
    }
}
