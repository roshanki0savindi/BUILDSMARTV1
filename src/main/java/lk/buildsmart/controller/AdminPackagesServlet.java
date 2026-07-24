package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.MaterialDAO;
import lk.buildsmart.dao.PackageDAO;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.model.ConstructionPackage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * Admin servlet for full package management including
 * creating packages and assigning / removing suggestions.
 *
 * Actions (POST parameter "action"):
 *   add          ΓÇô Create a new package
 *   delete       ΓÇô Delete a package (cascade removes junction rows)
 *   addWorker    ΓÇô Assign a worker to a package
 *   removeWorker ΓÇô Remove a worker from a package
 *   addMaterial  ΓÇô Assign a material to a package
 *   removeMaterial ΓÇô Remove a material from a package
 *   addShop      ΓÇô Assign a hardware shop to a package
 *   removeShop   ΓÇô Remove a hardware shop from a package
 *
 * GET ?manage=packageId shows the detail/assignment page for that package.
 */
@WebServlet("/admin/packages")
public class AdminPackagesServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AdminPackagesServlet.class);

    private final PackageDAO     packageDAO  = new PackageDAO();
    private final WorkerDAO      workerDAO   = new WorkerDAO();
    private final MaterialDAO    materialDAO = new MaterialDAO();
    private final HardwareShopDAO shopDAO    = new HardwareShopDAO();

    // =========================================================================
    // GET ΓÇö list all packages  OR  show management detail for one package
    // =========================================================================

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String manageParam = req.getParameter("manage");

        if (manageParam != null) {
            // --- Detail / assignment view for a single package ---
            try {
                int packageId = Integer.parseInt(manageParam);
                ConstructionPackage pkg = packageDAO.getById(packageId);
                if (pkg == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Package not found");
                    return;
                }
                req.setAttribute("pkg",       pkg);
                req.setAttribute("allWorkers",   workerDAO.getAllActiveWorkers());
                req.setAttribute("allMaterials", materialDAO.getAllMaterials());
                req.setAttribute("allShops",     shopDAO.getAllActiveShops());
                req.getRequestDispatcher("/WEB-INF/views/admin_package_manage.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid package ID");
            }
        } else {
            // --- List view ---
            req.setAttribute("packages", packageDAO.getAllPackages());
            req.getRequestDispatcher("/WEB-INF/views/admin_packages.jsp").forward(req, resp);
        }
    }

    // =========================================================================
    // POST ΓÇö handle all actions
    // =========================================================================

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        try {
            switch (action) {

                // ----- Package CRUD -----
                case "add" -> {
                    String name   = req.getParameter("packageName");
                    String budget = req.getParameter("estimatedBudget");
                    String desc   = req.getParameter("description");
                    if (name == null || name.isBlank() || budget == null || budget.isBlank()) {
                        req.setAttribute("error", "Package name and budget are required.");
                        req.setAttribute("packages", packageDAO.getAllPackages());
                        req.getRequestDispatcher("/WEB-INF/views/admin_packages.jsp").forward(req, resp);
                        return;
                    }
                    ConstructionPackage pkg = new ConstructionPackage(0, name.trim(),
                            new BigDecimal(budget.trim()), desc);
                    packageDAO.insert(pkg);
                    logger.info("Admin created package: {}", name);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages");
                }

                case "delete" -> {
                    int pkgId = parseId(req, "packageId");
                    packageDAO.delete(pkgId);
                    logger.info("Admin deleted package ID: {}", pkgId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages");
                }

                // ----- Worker assignments -----
                case "addWorker" -> {
                    int pkgId    = parseId(req, "packageId");
                    int workerId = parseId(req, "workerId");
                    packageDAO.addWorkerToPackage(pkgId, workerId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages?manage=" + pkgId + "&msg=worker_added");
                }

                case "removeWorker" -> {
                    int pkgId    = parseId(req, "packageId");
                    int workerId = parseId(req, "workerId");
                    packageDAO.removeWorkerFromPackage(pkgId, workerId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages?manage=" + pkgId + "&msg=worker_removed");
                }

                // ----- Material assignments -----
                case "addMaterial" -> {
                    int pkgId      = parseId(req, "packageId");
                    int materialId = parseId(req, "materialId");
                    packageDAO.addMaterialToPackage(pkgId, materialId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages?manage=" + pkgId + "&msg=material_added");
                }

                case "removeMaterial" -> {
                    int pkgId      = parseId(req, "packageId");
                    int materialId = parseId(req, "materialId");
                    packageDAO.removeMaterialFromPackage(pkgId, materialId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages?manage=" + pkgId + "&msg=material_removed");
                }

                // ----- Shop assignments -----
                case "addShop" -> {
                    int pkgId  = parseId(req, "packageId");
                    int shopId = parseId(req, "shopId");
                    packageDAO.addShopToPackage(pkgId, shopId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages?manage=" + pkgId + "&msg=shop_added");
                }

                case "removeShop" -> {
                    int pkgId  = parseId(req, "packageId");
                    int shopId = parseId(req, "shopId");
                    packageDAO.removeShopFromPackage(pkgId, shopId);
                    resp.sendRedirect(req.getContextPath() + "/admin/packages?manage=" + pkgId + "&msg=shop_removed");
                }

                default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric parameter: " + e.getMessage());
        } catch (Exception e) {
            logger.error("Error processing admin packages action: {}", action, e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error processing request");
        }
    }

    // =========================================================================
    // Helper
    // =========================================================================
    private int parseId(HttpServletRequest req, String param) {
        String val = req.getParameter(param);
        if (val == null || val.isBlank()) throw new NumberFormatException("Missing param: " + param);
        return Integer.parseInt(val.trim());
    }
}
