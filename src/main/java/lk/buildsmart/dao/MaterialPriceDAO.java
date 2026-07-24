package lk.buildsmart.dao;

import lk.buildsmart.model.MaterialPrice;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterialPriceDAO {
    private static final Logger logger = LoggerFactory.getLogger(MaterialPriceDAO.class);
    private final MaterialDAO materialDAO = new MaterialDAO();

    public List<MaterialPrice> getByShopId(int shopId) {
        List<MaterialPrice> prices = new ArrayList<>();
        if (shopId <= 0) return prices;
        
        String sql = "SELECT * FROM material_prices WHERE shop_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, shopId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MaterialPrice price = mapRowToPrice(rs);
                    // Fetch full Material object for the composition view
                    price.setMaterial(materialDAO.getById(price.getMaterialId()));
                    prices.add(price);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching material prices for shop ID: {}", shopId, e);
        }
        return prices;
    }

    public MaterialPrice getById(int priceId) {
        if (priceId <= 0) return null;
        String sql = "SELECT * FROM material_prices WHERE price_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, priceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    MaterialPrice price = mapRowToPrice(rs);
                    price.setMaterial(materialDAO.getById(price.getMaterialId()));
                    return price;
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching material price by ID: {}", priceId, e);
        }
        return null;
    }

    public boolean insert(MaterialPrice price) {
        if (price == null || price.getShopId() <= 0 || price.getMaterialId() <= 0) return false;
        String sql = "INSERT INTO material_prices (shop_id, material_id, brand, price, availability) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, price.getShopId());
            stmt.setInt(2, price.getMaterialId());
            stmt.setString(3, price.getBrand());
            stmt.setBigDecimal(4, price.getPrice());
            stmt.setString(5, price.getAvailability());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        price.setPriceId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting material price for shop ID: {}", price.getShopId(), e);
        }
        return false;
    }

    public boolean update(MaterialPrice price) {
        if (price == null || price.getPriceId() <= 0) return false;
        String sql = "UPDATE material_prices SET brand = ?, price = ?, availability = ? WHERE price_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, price.getBrand());
            stmt.setBigDecimal(2, price.getPrice());
            stmt.setString(3, price.getAvailability());
            stmt.setInt(4, price.getPriceId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating material price ID: {}", price.getPriceId(), e);
        }
        return false;
    }

    public boolean delete(int priceId) {
        if (priceId <= 0) return false;
        String sql = "DELETE FROM material_prices WHERE price_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, priceId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting material price ID: {}", priceId, e);
        }
        return false;
    }

    private MaterialPrice mapRowToPrice(ResultSet rs) throws SQLException {
        MaterialPrice price = new MaterialPrice();
        price.setPriceId(rs.getInt("price_id"));
        price.setShopId(rs.getInt("shop_id"));
        price.setMaterialId(rs.getInt("material_id"));
        price.setBrand(rs.getString("brand"));
        price.setPrice(rs.getBigDecimal("price"));
        price.setAvailability(rs.getString("availability"));
        
        if (rs.getTimestamp("last_updated") != null) {
            price.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());
        }
        return price;
    }
}
