package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.HardwareShopDAO;
import lk.buildsmart.model.HardwareShop;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/hardware-shops")
public class SearchHardwareServlet extends HttpServlet {
    private final HardwareShopDAO shopDAO = new HardwareShopDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String q        = req.getParameter("q");
            String district = req.getParameter("district");
            String delivery = req.getParameter("delivery");
            String sortBy   = req.getParameter("sort");

            List<HardwareShop> shops = shopDAO.getAllActiveShops();

            // --- Filter by text (shop name or description) ---
            if (q != null && !q.trim().isEmpty()) {
                String lower = q.trim().toLowerCase();
                shops = shops.stream()
                    .filter(s -> (s.getShopName() != null && s.getShopName().toLowerCase().contains(lower))
                              || (s.getDescription() != null && s.getDescription().toLowerCase().contains(lower))
                              || (s.getDistrict() != null && s.getDistrict().toLowerCase().contains(lower)))
                    .collect(Collectors.toList());
            }

            // --- Filter by district ---
            if (district != null && !district.trim().isEmpty() && !district.equalsIgnoreCase("all")) {
                String d = district.trim();
                shops = shops.stream()
                    .filter(s -> d.equalsIgnoreCase(s.getDistrict()))
                    .collect(Collectors.toList());
            }

            // --- Filter by delivery ---
            if ("yes".equalsIgnoreCase(delivery)) {
                shops = shops.stream()
                    .filter(HardwareShop::isDeliveryAvailable)
                    .collect(Collectors.toList());
            }

            // --- Sort by rating ---
            if ("rating".equals(sortBy)) {
                shops.sort((a, b) -> Double.compare(b.getAverageRating(), a.getAverageRating()));
            }

            req.setAttribute("shops", shops);
            req.setAttribute("q", q);
            req.setAttribute("district", district);
            req.setAttribute("delivery", delivery);
            req.setAttribute("sort", sortBy);

            req.getRequestDispatcher("/WEB-INF/views/hardware.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading hardware shops");
        }
    }
}
