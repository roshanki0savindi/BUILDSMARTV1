package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.model.HardwareShop;
import lk.buildsmart.model.User;
import lk.buildsmart.model.Worker;
import lk.buildsmart.util.ImageUtil;
import lk.buildsmart.util.SessionManager;

import java.io.IOException;

/**
 * Dedicated Servlet for handling profile photo and logo uploads from Dashboards.
 * Images are validated and stored directly as MEDIUMBLOB in the database.
 */
@WebServlet("/upload-photo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB threshold before writing to memory
    maxFileSize = 1024 * 1024 * 16,      // 16MB per file (matches MEDIUMBLOB limit)
    maxRequestSize = 1024 * 1024 * 20   // 20MB total request size
)
public class FileUploadServlet extends HttpServlet {

    private final WorkerDAO workerDAO = new WorkerDAO();
    private final HardwareShopDAO shopDAO = new HardwareShopDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = SessionManager.getLoggedInUser(req);
        if (loggedInUser == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "You must be logged in to upload files.");
            return;
        }

        try {
            if ("worker".equals(loggedInUser.getRole())) {
                Part filePart = req.getPart("profile_photo");
                byte[] imageBytes = ImageUtil.validateAndReadBytes(filePart);
                String mimeType  = ImageUtil.getMimeType(filePart);

                if (imageBytes != null) {
                    Worker worker = workerDAO.getByUserId(loggedInUser.getUserId());
                    if (worker != null) {
                        workerDAO.updatePhoto(worker.getWorkerId(), imageBytes, mimeType);
                    } else {
                        // Create worker record if not exists yet
                        worker = new Worker();
                        worker.setUserId(loggedInUser.getUserId());
                        worker.setFullName(loggedInUser.getFullName());
                        worker.setPhone(loggedInUser.getPhone());
                        worker.setEmail(loggedInUser.getEmail());
                        worker.setStatus(loggedInUser.getStatus());
                        worker.setProfession("Laborer");
                        worker.setDistrict("Colombo");
                        worker.setProfilePhoto(imageBytes);
                        worker.setProfilePhotoType(mimeType);
                        workerDAO.insert(worker);
                    }
                    resp.sendRedirect(req.getContextPath() + "/worker/dashboard?msg=photo_updated");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/worker/dashboard?error=no_file");
                }

            } else if ("hardware_owner".equals(loggedInUser.getRole())) {
                Part filePart = req.getPart("logo");
                byte[] imageBytes = ImageUtil.validateAndReadBytes(filePart);
                String mimeType  = ImageUtil.getMimeType(filePart);

                if (imageBytes != null) {
                    HardwareShop shop = shopDAO.getByUserId(loggedInUser.getUserId());
                    if (shop != null) {
                        shopDAO.updateLogo(shop.getShopId(), imageBytes, mimeType);
                    } else {
                        // Create shop record if not exists yet
                        shop = new HardwareShop();
                        shop.setUserId(loggedInUser.getUserId());
                        shop.setShopName(loggedInUser.getFullName() + " Hardware");
                        shop.setLogo(imageBytes);
                        shop.setLogoType(mimeType);
                        shopDAO.insert(shop);
                    }
                    resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?msg=logo_updated");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?error=no_file");
                }
            } else {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Role not permitted to upload profile photos here.");
            }

        } catch (IllegalArgumentException e) {
            // MIME or Size validation failed
            String encError = java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + loggedInUser.showDashboard() + "?error=" + encError);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "File upload failed.");
        }
    }
}
