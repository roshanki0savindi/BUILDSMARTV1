package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.util.SessionManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LogoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processLogout(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processLogout(req, resp);
    }
    
    private void processLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        logger.info("User logging out.");
        SessionManager.logoutUser(req, resp);
        resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
    }
}
