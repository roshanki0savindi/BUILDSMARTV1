package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.dao.WorkerDAO;

import java.io.IOException;

@WebServlet(urlPatterns = {"", "/index", "/home"})
public class IndexServlet extends HttpServlet {
    private final WorkerDAO workerDAO = new WorkerDAO();
    private final HardwareShopDAO shopDAO = new HardwareShopDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Fetch featured/recent data for the homepage
            req.setAttribute("featuredWorkers", workerDAO.getAllActiveWorkers());
            req.setAttribute("featuredShops", shopDAO.getAllActiveShops());
            
            req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading homepage");
        }
    }
}
