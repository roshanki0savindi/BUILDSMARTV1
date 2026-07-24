package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.UserDAO;
import lk.buildsmart.model.User;
import lk.buildsmart.util.SessionManager;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect to respective dashboard
        User user = SessionManager.getLoggedInUser(req);
        if (user != null) {
            resp.sendRedirect(req.getContextPath() + user.showDashboard());
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        boolean rememberMe = "on".equals(req.getParameter("remember"));

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.getByEmail(email);

        // Verify password using BCrypt
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {

            // Check account status
            if (!user.isActive()) {
                req.setAttribute("error", "Your account is pending approval or has been rejected.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            // Establish session
            SessionManager.loginUser(req, user);

            // Handle remember me
            if (rememberMe) {
                SessionManager.setRememberMeCookie(resp, user);
            }

            logger.info("User logged in successfully: {}", email);

            // Polymorphic redirect based on role
            // Homeowners land on the main site index; others go to their dashboard
            String redirectPath;
            if ("homeowner".equals(user.getRole())) {
                redirectPath = "/";
            } else {
                redirectPath = user.showDashboard();
            }
            resp.sendRedirect(req.getContextPath() + redirectPath);

        } else {
            logger.warn("Failed login attempt for email: {}", email);
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
