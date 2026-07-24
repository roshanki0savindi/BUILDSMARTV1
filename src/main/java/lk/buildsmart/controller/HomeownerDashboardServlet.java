package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.ReviewDAO;
import lk.buildsmart.dao.UserDAO;
import lk.buildsmart.model.User;
import lk.buildsmart.util.SessionManager;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/homeowner/dashboard")
public class HomeownerDashboardServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            User user = SessionManager.getLoggedInUser(req);
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            req.setAttribute("myReviews", reviewDAO.getByUserId(user.getUserId()));
            req.getRequestDispatcher("/WEB-INF/views/homeowner_dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle profile update or password change
        User user = SessionManager.getLoggedInUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("update_profile".equals(action)) {
                String fullName = req.getParameter("fullName");
                String phone = req.getParameter("phone");

                if (fullName != null && !fullName.trim().isEmpty()) {
                    user.setFullName(fullName.trim());
                    user.setPhone(phone != null ? phone.trim() : user.getPhone());
                    userDAO.updateBasicInfo(user);
                    // Refresh session with new data
                    User freshUser = userDAO.getByEmail(user.getEmail());
                    if (freshUser != null) SessionManager.loginUser(req, freshUser);
                    req.getSession().setAttribute("successMsg", "Profile updated successfully!");
                }
            } else if ("change_password".equals(action)) {
                String currentPw = req.getParameter("currentPassword");
                String newPw     = req.getParameter("newPassword");
                String confirmPw = req.getParameter("confirmPassword");

                if (!BCrypt.checkpw(currentPw, user.getPassword())) {
                    req.getSession().setAttribute("errorMsg", "Current password is incorrect.");
                } else if (!newPw.equals(confirmPw)) {
                    req.getSession().setAttribute("errorMsg", "New passwords do not match.");
                } else if (newPw.length() < 6) {
                    req.getSession().setAttribute("errorMsg", "Password must be at least 6 characters.");
                } else {
                    String newHash = BCrypt.hashpw(newPw, BCrypt.gensalt(10));
                    userDAO.updatePassword(user.getUserId(), newHash);
                    req.getSession().setAttribute("successMsg", "Password changed successfully!");
                }
            }
        } catch (Exception e) {
            req.getSession().setAttribute("errorMsg", "An error occurred: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/homeowner/dashboard");
    }
}
