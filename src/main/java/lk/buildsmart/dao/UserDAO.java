package lk.buildsmart.dao;

import lk.buildsmart.model.User;
import lk.buildsmart.model.UserFactory;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

    public User getById(int userId) {
        if (userId <= 0) return null;
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching user by ID: {}", userId, e);
        }
        return null;
    }

    public User getByEmail(String email) {
        if (email == null || email.isBlank()) return null;
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching user by email: {}", email, e);
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY CASE WHEN status = 'pending' THEN 0 WHEN status = 'active' THEN 1 ELSE 2 END, created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            logger.error("Error fetching all users", e);
        }
        return users;
    }

    public boolean insert(User user) {
        if (user == null) return false;
        String sql = "INSERT INTO users (full_name, email, password, phone, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting user: {}", user.getEmail(), e);
        }
        return false;
    }

    public boolean update(User user) {
        if (user == null || user.getUserId() <= 0) return false;
        String sql = "UPDATE users SET full_name = ?, phone = ?, status = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getStatus());
            stmt.setInt(4, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating user ID: {}", user.getUserId(), e);
        }
        return false;
    }

    public boolean updateBasicInfo(User user) {
        if (user == null || user.getUserId() <= 0) return false;
        String sql = "UPDATE users SET full_name = ?, phone = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setInt(3, user.getUserId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating basic info for user ID: {}", user.getUserId(), e);
        }
        return false;
    }

    public boolean updatePassword(int userId, String newPasswordHash) {
        if (userId <= 0 || newPasswordHash == null || newPasswordHash.isBlank()) return false;
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPasswordHash);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating password for user ID: {}", userId, e);
        }
        return false;
    }

    public boolean delete(int userId) {
        if (userId <= 0) return false;
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting user ID: {}", userId, e);
        }
        return false;
    }

    /** Helper method to map a ResultSet row to a User subclass using UserFactory */
    protected User mapRowToUser(ResultSet rs) throws SQLException {
        LocalDateTime createdAt = rs.getTimestamp("created_at") != null ? 
                                 rs.getTimestamp("created_at").toLocalDateTime() : null;
        return UserFactory.create(
            rs.getInt("user_id"),
            rs.getString("full_name"),
            rs.getString("email"),
            rs.getString("password"),
            rs.getString("phone"),
            rs.getString("role"),
            rs.getString("status"),
            createdAt
        );
    }
}
