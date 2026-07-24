package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.PackageDAO;
import lk.buildsmart.model.ConstructionPackage;

import java.io.IOException;
import java.util.List;

@WebServlet("/packages")
public class PackagesServlet extends HttpServlet {
    private final PackageDAO packageDAO = new PackageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<ConstructionPackage> packages = packageDAO.getAllPackages();
            req.setAttribute("packages", packages);
            
            req.getRequestDispatcher("/WEB-INF/views/packages.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading construction packages");
        }
    }
}
