package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.MaterialDAO;
import lk.buildsmart.model.Material;

import java.io.IOException;

@WebServlet("/admin/materials")
public class AdminMaterialsServlet extends HttpServlet {
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("materials", materialDAO.getAllMaterials());
            req.getRequestDispatcher("/WEB-INF/views/admin_materials.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading materials");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                Material mat = new Material(
                    0, 
                    req.getParameter("materialName"), 
                    req.getParameter("category"), 
                    req.getParameter("unit")
                );
                materialDAO.insert(mat);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("materialId"));
                materialDAO.delete(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/materials");
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing material action");
        }
    }
}
