package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.dao.MaterialDAO;
import lk.buildsmart.dao.MaterialPriceDAO;
import lk.buildsmart.model.HardwareShop;
import lk.buildsmart.model.MaterialPrice;
import lk.buildsmart.model.User;
import lk.buildsmart.util.SessionManager;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/hardware/dashboard")
public class HardwareDashboardServlet extends HttpServlet {
    private final HardwareShopDAO shopDAO = new HardwareShopDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();
    private final MaterialPriceDAO materialPriceDAO = new MaterialPriceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            User user = SessionManager.getLoggedInUser(req);
            
            HardwareShop shop = shopDAO.getByUserId(user.getUserId());
            if (shop == null) {
                shop = new HardwareShop();
                shop.setUserId(user.getUserId());
                shop.setShopName(user.getFullName() + "'s Shop");
                shop.setOwnerName(user.getFullName());
                shop.setPhone(user.getPhone());
                shop.setDistrict("Colombo");
                shopDAO.insert(shop);
            }
            req.setAttribute("shopProfile", shop);
            req.setAttribute("allMaterials", materialDAO.getAllMaterials());
            
            req.getRequestDispatcher("/WEB-INF/views/hardware_dashboard.jsp").forward(req, resp);
            
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = SessionManager.getLoggedInUser(req);
        if (user == null || !"hardware_owner".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized");
            return;
        }

        try {
            HardwareShop shop = shopDAO.getByUserId(user.getUserId());
            if (shop == null) {
                shop = new HardwareShop();
                shop.setUserId(user.getUserId());
                shop.setShopName(user.getFullName() + "'s Shop");
                shop.setOwnerName(user.getFullName());
                shop.setPhone(user.getPhone());
                shop.setDistrict("Colombo");
                shopDAO.insert(shop);
            }

            String action = req.getParameter("action");
            if ("updateShopDetails".equals(action)) {
                String shopName = req.getParameter("shop_name");
                String ownerName = req.getParameter("owner_name");
                String brn = req.getParameter("business_registration_number");
                String address = req.getParameter("address");
                String district = req.getParameter("district");
                String phone = req.getParameter("phone");
                String openingHours = req.getParameter("opening_hours");
                boolean deliveryAvailable = "on".equals(req.getParameter("delivery_available")) || "true".equalsIgnoreCase(req.getParameter("delivery_available"));
                String description = req.getParameter("description");

                shop.setShopName(shopName);
                shop.setOwnerName(ownerName);
                shop.setBusinessRegistrationNumber(brn);
                shop.setAddress(address);
                shop.setDistrict(district);
                shop.setPhone(phone);
                shop.setOpeningHours(openingHours);
                shop.setDeliveryAvailable(deliveryAvailable);
                shop.setDescription(description);

                shopDAO.update(shop);
                resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?msg=shop_updated");

            } else if ("addMaterialPrice".equals(action)) {
                int materialId = Integer.parseInt(req.getParameter("material_id"));
                String brand = req.getParameter("brand");
                BigDecimal price = new BigDecimal(req.getParameter("price"));
                String availability = req.getParameter("availability");

                MaterialPrice mp = new MaterialPrice();
                mp.setShopId(shop.getShopId());
                mp.setMaterialId(materialId);
                mp.setBrand(brand);
                mp.setPrice(price);
                mp.setAvailability(availability != null ? availability : "In Stock");

                materialPriceDAO.insert(mp);
                resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?msg=material_added");

            } else if ("updateMaterialPrice".equals(action)) {
                int priceId = Integer.parseInt(req.getParameter("price_id"));
                String brand = req.getParameter("brand");
                BigDecimal price = new BigDecimal(req.getParameter("price"));
                String availability = req.getParameter("availability");

                MaterialPrice mp = materialPriceDAO.getById(priceId);
                if (mp != null && mp.getShopId() == shop.getShopId()) {
                    mp.setBrand(brand);
                    mp.setPrice(price);
                    mp.setAvailability(availability);
                    materialPriceDAO.update(mp);
                }
                resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?msg=material_updated");

            } else if ("deleteMaterialPrice".equals(action)) {
                int priceId = Integer.parseInt(req.getParameter("price_id"));
                MaterialPrice mp = materialPriceDAO.getById(priceId);
                if (mp != null && mp.getShopId() == shop.getShopId()) {
                    materialPriceDAO.delete(priceId);
                }
                resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?msg=material_deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/hardware/dashboard");
            }

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/hardware/dashboard?error=" + java.net.URLEncoder.encode("Action failed: " + e.getMessage(), "UTF-8"));
        }
    }
}
