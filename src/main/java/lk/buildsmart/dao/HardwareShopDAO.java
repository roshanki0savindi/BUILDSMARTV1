package lk.buildsmart.dao;

import lk.buildsmart.model.HardwareShop;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class HardwareShopDAO {
    private static final Logger logger = LoggerFactory.getLogger(HardwareShopDAO.class);
    private final MaterialPriceDAO materialPriceDAO = new MaterialPriceDAO();

    public HardwareShop getByShopId(int shopId) {
        if (shopId <= 0) return null;
        String sql = "SELECT s.*, " +
                     "(SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as review_count " +
                     "FROM hardware_shops s WHERE s.shop_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, shopId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    HardwareShop shop = mapRowToShop(rs);
                    shop.setMaterialPrices(materialPriceDAO.getByShopId(shopId));
                    return shop;
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching hardware shop by ID: {}", shopId, e);
        }
        return null;
    }

    public HardwareShop getByUserId(int userId) {
        if (userId <= 0) return null;
        String sql = "SELECT s.*, " +
                     "(SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as review_count " +
                     "FROM hardware_shops s WHERE s.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    HardwareShop shop = mapRowToShop(rs);
                    shop.setMaterialPrices(materialPriceDAO.getByShopId(shop.getShopId()));
                    return shop;
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching hardware shop by User ID: {}", userId, e);
        }
        return null;
    }

    public List<HardwareShop> getAllActiveShops() {
        List<HardwareShop> shops = new ArrayList<>();
        String sql = "SELECT s.*, " +
                     "(SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as review_count " +
                     "FROM hardware_shops s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE u.status = 'active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                shops.add(mapRowToShop(rs));
            }
        } catch (SQLException e) {
            logger.error("Error fetching all active hardware shops", e);
        }
        return shops;
    }

    public boolean insert(HardwareShop shop) {
        if (shop == null || shop.getUserId() <= 0) return false;
        String sql = "INSERT INTO hardware_shops (user_id, shop_name, owner_name, business_registration_number, " +
                     "address, district, phone, logo, logo_mime, opening_hours, delivery_available, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, shop.getUserId());
            stmt.setString(2, shop.getShopName());
            stmt.setString(3, shop.getOwnerName());
            stmt.setString(4, shop.getBusinessRegistrationNumber());
            stmt.setString(5, shop.getAddress());
            stmt.setString(6, shop.getDistrict());
            stmt.setString(7, shop.getPhone());
            stmt.setBytes(8, shop.getLogo());
            stmt.setString(9, shop.getLogoType());
            stmt.setString(10, shop.getOpeningHours());
            stmt.setBoolean(11, shop.isDeliveryAvailable());
            stmt.setString(12, shop.getDescription());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        shop.setShopId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting hardware shop for user ID: {}", shop.getUserId(), e);
        }
        return false;
    }

    public boolean update(HardwareShop shop) {
        if (shop == null || shop.getShopId() <= 0) return false;

        boolean hasNewLogo = shop.getLogo() != null && shop.getLogo().length > 0;
        String sql;

        if (hasNewLogo) {
            sql = "UPDATE hardware_shops SET shop_name = ?, owner_name = ?, business_registration_number = ?, " +
                  "address = ?, district = ?, phone = ?, logo = ?, logo_mime = ?, opening_hours = ?, delivery_available = ?, " +
                  "description = ? WHERE shop_id = ?";
        } else {
            sql = "UPDATE hardware_shops SET shop_name = ?, owner_name = ?, business_registration_number = ?, " +
                  "address = ?, district = ?, phone = ?, opening_hours = ?, delivery_available = ?, " +
                  "description = ? WHERE shop_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, shop.getShopName());
            stmt.setString(2, shop.getOwnerName());
            stmt.setString(3, shop.getBusinessRegistrationNumber());
            stmt.setString(4, shop.getAddress());
            stmt.setString(5, shop.getDistrict());
            stmt.setString(6, shop.getPhone());

            if (hasNewLogo) {
                stmt.setBytes(7, shop.getLogo());
                stmt.setString(8, shop.getLogoType());
                stmt.setString(9, shop.getOpeningHours());
                stmt.setBoolean(10, shop.isDeliveryAvailable());
                stmt.setString(11, shop.getDescription());
                stmt.setInt(12, shop.getShopId());
            } else {
                stmt.setString(7, shop.getOpeningHours());
                stmt.setBoolean(8, shop.isDeliveryAvailable());
                stmt.setString(9, shop.getDescription());
                stmt.setInt(10, shop.getShopId());
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating hardware shop ID: {}", shop.getShopId(), e);
        }
        return false;
    }

    /**
     * Updates only the logo binary for a shop ΓÇö lightweight update used by
     * {@link lk.buildsmart.controller.FileUploadServlet}.
     */
    public boolean updateLogo(int shopId, byte[] logoBytes, String mimeType) {
        if (shopId <= 0) return false;
        String sql = "UPDATE hardware_shops SET logo = ?, logo_mime = ? WHERE shop_id = ? OR user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBytes(1, logoBytes);
            stmt.setString(2, mimeType);
            stmt.setInt(3, shopId);
            stmt.setInt(4, shopId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating logo for shop ID: {}", shopId, e);
        }
        return false;
    }

    private HardwareShop mapRowToShop(ResultSet rs) throws SQLException {
        HardwareShop shop = new HardwareShop();
        shop.setShopId(rs.getInt("shop_id"));
        shop.setUserId(rs.getInt("user_id"));
        shop.setShopName(rs.getString("shop_name"));
        shop.setOwnerName(rs.getString("owner_name"));
        shop.setBusinessRegistrationNumber(rs.getString("business_registration_number"));
        shop.setAddress(rs.getString("address"));
        shop.setDistrict(rs.getString("district"));
        shop.setPhone(rs.getString("phone"));
        shop.setLogo(rs.getBytes("logo"));
        shop.setLogoType(rs.getString("logo_mime"));
        shop.setOpeningHours(rs.getString("opening_hours"));
        shop.setDeliveryAvailable(rs.getBoolean("delivery_available"));
        shop.setDescription(rs.getString("description"));

        if (rs.getTimestamp("last_updated") != null) {
            shop.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());
        }
        shop.setAverageRating(rs.getDouble("avg_rating"));
        shop.setReviewCount(rs.getInt("review_count"));

        return shop;
    }
}
