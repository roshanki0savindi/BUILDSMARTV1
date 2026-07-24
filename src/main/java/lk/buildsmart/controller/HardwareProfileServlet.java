package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.dao.ReviewDAO;
import lk.buildsmart.model.HardwareShop;
import lk.buildsmart.model.Review;
import lk.buildsmart.model.User;
import lk.buildsmart.util.SessionManager;
import lk.buildsmart.util.ImageUtil;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/hardware/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class HardwareProfileServlet extends HttpServlet {
    private final HardwareShopDAO shopDAO = new HardwareShopDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        HardwareShop shop = null;

        try {
            if (idParam != null && !idParam.isBlank()) {
                try {
                    int id = Integer.parseInt(idParam);
                    if (id > 0) {
                        shop = shopDAO.getByShopId(id);
                        if (shop == null) {
                            shop = shopDAO.getByUserId(id);
                        }
                    }
                } catch (NumberFormatException ignore) {}
            }

            // Fallback: If shop is still null, resolve from logged-in user if hardware_owner
            if (shop == null) {
                User user = SessionManager.getLoggedInUser(req);
                if (user != null && "hardware_owner".equals(user.getRole())) {
                    shop = shopDAO.getByUserId(user.getUserId());
                    if (shop == null) {
                        shop = new HardwareShop();
                        shop.setUserId(user.getUserId());
                        shop.setShopName(user.getFullName() + "'s Shop");
                        shop.setOwnerName(user.getFullName());
                        shop.setPhone(user.getPhone());
                        shop.setDistrict("Colombo");
                        shopDAO.insert(shop);
                    }
                }
            }

            // Fallback for Guest Mode without specific ID or invalid ID
            if (shop == null) {
                List<HardwareShop> activeShops = shopDAO.getAllActiveShops();
                if (!activeShops.isEmpty()) {
                    shop = shopDAO.getByShopId(activeShops.get(0).getShopId());
                }
            }

            if (shop == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Hardware shop profile not found");
                return;
            }

            req.setAttribute("shop", shop);
            req.setAttribute("reviews", reviewDAO.getByTarget("hardware_shop", shop.getShopId()));
            
            req.getRequestDispatcher("/WEB-INF/views/hardware_profile.jsp").forward(req, resp);
            
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading hardware shop profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = SessionManager.getLoggedInUser(req);
        if (user == null || !"homeowner".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only homeowners can leave reviews.");
            return;
        }

        try {
            int shopId = Integer.parseInt(req.getParameter("targetId"));
            int rating = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");

            Part filePart = req.getPart("review_photo");
            byte[] imageBytes = ImageUtil.validateAndReadBytes(filePart);
            String mimeType  = ImageUtil.getMimeType(filePart);

            Review review = new Review(user.getUserId(), "hardware_shop", shopId, rating, comment, imageBytes, mimeType);
            review.setReviewDate(LocalDateTime.now());
            
            reviewDAO.insert(review);
            
            resp.sendRedirect(req.getContextPath() + "/hardware/profile?id=" + shopId + "&msg=review_added");

        } catch (IllegalArgumentException e) {
            String shopId = req.getParameter("targetId");
            resp.sendRedirect(req.getContextPath() + "/hardware/profile?id=" + shopId + "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to submit review.");
        }
    }
}
