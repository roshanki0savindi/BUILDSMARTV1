package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.ReviewDAO;

import lk.buildsmart.model.Review;

import java.io.IOException;

@WebServlet("/admin/reviews")
public class AdminReviewsServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("pendingReviews", reviewDAO.getByStatus(Review.PENDING));
            req.setAttribute("approvedReviews", reviewDAO.getByStatus(Review.APPROVED));
            req.setAttribute("rejectedReviews", reviewDAO.getByStatus(Review.REJECTED));
            req.getRequestDispatcher("/WEB-INF/views/admin_reviews.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading reviews");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String reviewIdStr = req.getParameter("reviewId");

        if (action == null || reviewIdStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            if ("approve".equals(action)) {
                reviewDAO.updateStatus(reviewId, Review.APPROVED);
            } else if ("reject".equals(action)) {
                reviewDAO.updateStatus(reviewId, Review.REJECTED);
            } else if ("delete".equals(action)) {
                reviewDAO.delete(reviewId);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?msg=moderated");
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error moderating review");
        }
    }
}
