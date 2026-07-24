package lk.buildsmart.dao;

import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AdminDAO {
    private static final Logger logger = LoggerFactory.getLogger(AdminDAO.class);

    /**
     * Approves or rejects a user (worker or hardware owner) account.
     * 
     * @param userId the user to update
     * @param status the new status ("active" or "rejected")
     * @return true if successful
     */
    public boolean updateUserStatus(int userId, String status) {
        if (userId <= 0 || status == null || (!status.equals("active") && !status.equals("rejected") && !status.equals("pending"))) {
            return false;
        }
        
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating status for user ID: {} to {}", userId, status, e);
        }
        return false;
    }

    /**
     * Deletes any user (homeowner, worker, hardware owner) except admins, along with associated profile data.
     */
    public boolean deleteUser(int userId) {
        if (userId <= 0) return false;
        
        String sqlReviews = "DELETE FROM reviews WHERE user_id = ?";
        String sqlWorker = "DELETE FROM workers WHERE user_id = ?";
        String sqlShop = "DELETE FROM hardware_shops WHERE user_id = ?";
        String sqlUser = "DELETE FROM users WHERE user_id = ? AND role != 'admin'";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement stmt = conn.prepareStatement(sqlReviews)) {
                    stmt.setInt(1, userId);
                    stmt.executeUpdate();
                }
                try (PreparedStatement stmt = conn.prepareStatement(sqlWorker)) {
                    stmt.setInt(1, userId);
                    stmt.executeUpdate();
                }
                try (PreparedStatement stmt = conn.prepareStatement(sqlShop)) {
                    stmt.setInt(1, userId);
                    stmt.executeUpdate();
                }
                int deletedRows;
                try (PreparedStatement stmt = conn.prepareStatement(sqlUser)) {
                    stmt.setInt(1, userId);
                    deletedRows = stmt.executeUpdate();
                }
                conn.commit();
                return deletedRows > 0;
            } catch (SQLException e) {
                conn.rollback();
                logger.error("Error executing delete for user ID: {}", userId, e);
            }
        } catch (SQLException e) {
            logger.error("Database error deleting user ID: {}", userId, e);
        }
        return false;
    }

    public int getVerifiedWorkersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'worker' AND status = 'active'";
        return getCount(sql);
    }

    public int getVerifiedShopsCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'hardware_owner' AND status = 'active'";
        return getCount(sql);
    }

    public int getPendingUsersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'pending'";
        return getCount(sql);
    }

    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             java.sql.ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error("Error executing count query: {}", sql, e);
        }
        return 0;
    }
}
