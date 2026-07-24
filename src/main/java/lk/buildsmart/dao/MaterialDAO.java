package lk.buildsmart.dao;

import lk.buildsmart.model.Material;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {
    private static final Logger logger = LoggerFactory.getLogger(MaterialDAO.class);

    public Material getById(int materialId) {
        if (materialId <= 0) return null;
        String sql = "SELECT * FROM materials WHERE material_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, materialId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToMaterial(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching material by ID: {}", materialId, e);
        }
        return null;
    }

    public List<Material> getAllMaterials() {
        List<Material> materials = new ArrayList<>();
        String sql = "SELECT * FROM materials ORDER BY material_name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                materials.add(mapRowToMaterial(rs));
            }
        } catch (SQLException e) {
            logger.error("Error fetching all materials", e);
        }
        return materials;
    }

    public boolean insert(Material material) {
        if (material == null) return false;
        String sql = "INSERT INTO materials (material_name, category, unit) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, material.getMaterialName());
            stmt.setString(2, material.getCategory());
            stmt.setString(3, material.getUnit());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        material.setMaterialId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting material: {}", material.getMaterialName(), e);
        }
        return false;
    }

    public boolean update(Material material) {
        if (material == null || material.getMaterialId() <= 0) return false;
        String sql = "UPDATE materials SET material_name = ?, category = ?, unit = ? WHERE material_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, material.getMaterialName());
            stmt.setString(2, material.getCategory());
            stmt.setString(3, material.getUnit());
            stmt.setInt(4, material.getMaterialId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating material ID: {}", material.getMaterialId(), e);
        }
        return false;
    }

    public boolean delete(int materialId) {
        if (materialId <= 0) return false;
        String sql = "DELETE FROM materials WHERE material_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, materialId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting material ID: {}", materialId, e);
        }
        return false;
    }

    private Material mapRowToMaterial(ResultSet rs) throws SQLException {
        return new Material(
            rs.getInt("material_id"),
            rs.getString("material_name"),
            rs.getString("category"),
            rs.getString("unit")
        );
    }
}
