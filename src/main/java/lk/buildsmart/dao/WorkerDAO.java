package lk.buildsmart.dao;

import lk.buildsmart.model.Worker;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class WorkerDAO {
    private static final Logger logger = LoggerFactory.getLogger(WorkerDAO.class);
    private final WorkerAvailabilityDAO availabilityDAO = new WorkerAvailabilityDAO();

    public Worker getByWorkerId(int workerId) {
        if (workerId <= 0) return null;
        String sql = "SELECT w.*, u.*, " +
                     "(SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'worker' AND r.target_id = w.worker_id) as avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'worker' AND r.target_id = w.worker_id) as review_count " +
                     "FROM workers w " +
                     "JOIN users u ON w.user_id = u.user_id " +
                     "WHERE w.worker_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, workerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Worker worker = mapRowToWorker(rs);
                    worker.setAvailabilityList(availabilityDAO.getByWorkerId(workerId));
                    return worker;
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching worker by ID: {}", workerId, e);
        }
        return null;
    }

    public Worker getByUserId(int userId) {
        if (userId <= 0) return null;
        String sql = "SELECT w.*, u.*, " +
                     "(SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'worker' AND r.target_id = w.worker_id) as avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'worker' AND r.target_id = w.worker_id) as review_count " +
                     "FROM workers w " +
                     "JOIN users u ON w.user_id = u.user_id " +
                     "WHERE w.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Worker worker = mapRowToWorker(rs);
                    worker.setAvailabilityList(availabilityDAO.getByWorkerId(worker.getWorkerId()));
                    return worker;
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching worker by User ID: {}", userId, e);
        }
        return null;
    }

    public List<Worker> getAllActiveWorkers() {
        List<Worker> workers = new ArrayList<>();
        String sql = "SELECT w.*, u.*, " +
                     "(SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'worker' AND r.target_id = w.worker_id) as avg_rating, " +
                     "(SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'worker' AND r.target_id = w.worker_id) as review_count " +
                     "FROM workers w " +
                     "JOIN users u ON w.user_id = u.user_id " +
                     "WHERE u.status = 'active'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Worker worker = mapRowToWorker(rs);
                workers.add(worker);
            }
        } catch (SQLException e) {
            logger.error("Error fetching all active workers", e);
        }
        return workers;
    }

    public boolean insert(Worker worker) {
        if (worker == null || worker.getUserId() <= 0) return false;
        String sql = "INSERT INTO workers (user_id, nic, profession, experience, skills, daily_rate, district, profile_photo, photo_mime, about) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, worker.getUserId());
            stmt.setString(2, worker.getNic());
            stmt.setString(3, worker.getProfession());
            stmt.setInt(4, worker.getExperience());
            stmt.setString(5, worker.getSkills());
            stmt.setBigDecimal(6, worker.getDailyRate());
            stmt.setString(7, worker.getDistrict());
            stmt.setBytes(8, worker.getProfilePhoto());
            stmt.setString(9, worker.getProfilePhotoType());
            stmt.setString(10, worker.getAbout());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        worker.setWorkerId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting worker profile for user ID: {}", worker.getUserId(), e);
        }
        return false;
    }

    public boolean update(Worker worker) {
        if (worker == null || worker.getWorkerId() <= 0) return false;

        boolean hasNewPhoto = worker.getProfilePhoto() != null && worker.getProfilePhoto().length > 0;
        String sql;

        if (hasNewPhoto) {
            sql = "UPDATE workers SET nic = ?, profession = ?, experience = ?, skills = ?, " +
                  "daily_rate = ?, district = ?, profile_photo = ?, photo_mime = ?, about = ? WHERE worker_id = ?";
        } else {
            sql = "UPDATE workers SET nic = ?, profession = ?, experience = ?, skills = ?, " +
                  "daily_rate = ?, district = ?, about = ? WHERE worker_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, worker.getNic());
            stmt.setString(2, worker.getProfession());
            stmt.setInt(3, worker.getExperience());
            stmt.setString(4, worker.getSkills());
            stmt.setBigDecimal(5, worker.getDailyRate());
            stmt.setString(6, worker.getDistrict());

            if (hasNewPhoto) {
                stmt.setBytes(7, worker.getProfilePhoto());
                stmt.setString(8, worker.getProfilePhotoType());
                stmt.setString(9, worker.getAbout());
                stmt.setInt(10, worker.getWorkerId());
            } else {
                stmt.setString(7, worker.getAbout());
                stmt.setInt(8, worker.getWorkerId());
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating worker ID: {}", worker.getWorkerId(), e);
        }
        return false;
    }

    /**
     * Updates only the profile photo binary for a worker ΓÇö lightweight update
     * used by {@link lk.buildsmart.controller.FileUploadServlet}.
     */
    public boolean updatePhoto(int workerId, byte[] photoBytes, String mimeType) {
        if (workerId <= 0) return false;
        String sql = "UPDATE workers SET profile_photo = ?, photo_mime = ? WHERE worker_id = ? OR user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBytes(1, photoBytes);
            stmt.setString(2, mimeType);
            stmt.setInt(3, workerId);
            stmt.setInt(4, workerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating photo for worker ID: {}", workerId, e);
        }
        return false;
    }

    private Worker mapRowToWorker(ResultSet rs) throws SQLException {
        LocalDateTime createdAt = rs.getTimestamp("created_at") != null ?
                                 rs.getTimestamp("created_at").toLocalDateTime() : null;
        LocalDateTime lastUpdated = rs.getTimestamp("last_updated") != null ?
                                   rs.getTimestamp("last_updated").toLocalDateTime() : null;

        Worker worker = new Worker(
            rs.getInt("user_id"),
            rs.getString("full_name"),
            rs.getString("email"),
            rs.getString("password"),
            rs.getString("phone"),
            rs.getString("status"),
            createdAt,
            rs.getInt("worker_id"),
            rs.getString("nic"),
            rs.getString("profession"),
            rs.getInt("experience"),
            rs.getString("skills"),
            rs.getBigDecimal("daily_rate"),
            rs.getString("district"),
            rs.getBytes("profile_photo"),
            rs.getString("photo_mime"),
            rs.getString("about"),
            lastUpdated
        );
        worker.setAverageRating(rs.getDouble("avg_rating"));
        worker.setReviewCount(rs.getInt("review_count"));
        return worker;
    }
}
