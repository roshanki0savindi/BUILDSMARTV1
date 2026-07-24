package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import lk.buildsmart.dao.AdminDAO;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("verifiedWorkersCount", adminDAO.getVerifiedWorkersCount());
            req.setAttribute("verifiedShopsCount", adminDAO.getVerifiedShopsCount());
            req.setAttribute("pendingUsersCount", adminDAO.getPendingUsersCount());

            req.getRequestDispatcher("/WEB-INF/views/admin_dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading admin dashboard");
        }
    }
}
