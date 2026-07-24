package lk.buildsmart.dao;

import lk.buildsmart.model.WorkerAvailability;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class WorkerAvailabilityDAO {
    private static final Logger logger = LoggerFactory.getLogger(WorkerAvailabilityDAO.class);

    public List<WorkerAvailability> getByWorkerId(int workerId) {
        List<WorkerAvailability> availabilities = new ArrayList<>();
        if (workerId <= 0) return availabilities;
        
        String sql = "SELECT * FROM worker_availability WHERE worker_id = ? ORDER BY unavailable_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, workerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    availabilities.add(mapRowToAvailability(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching availability for worker ID: {}", workerId, e);
        }
        return availabilities;
    }

    public boolean insert(WorkerAvailability availability) {
        if (availability == null || availability.getWorkerId() <= 0 || availability.getUnavailableDate() == null) {
            return false;
        }
        
        String sql = "INSERT INTO worker_availability (worker_id, unavailable_date) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, availability.getWorkerId());
            stmt.setDate(2, Date.valueOf(availability.getUnavailableDate()));
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        availability.setAvailabilityId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting availability for worker ID: {}", availability.getWorkerId(), e);
        }
        return false;
    }

    public boolean delete(int workerId, LocalDate date) {
        if (workerId <= 0 || date == null) return false;
        String sql = "DELETE FROM worker_availability WHERE worker_id = ? AND unavailable_date = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, workerId);
            stmt.setDate(2, Date.valueOf(date));
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting availability for worker ID: {} on date: {}", workerId, date, e);
        }
        return false;
    }

    private WorkerAvailability mapRowToAvailability(ResultSet rs) throws SQLException {
        return new WorkerAvailability(
            rs.getInt("availability_id"),
            rs.getInt("worker_id"),
            rs.getDate("unavailable_date").toLocalDate()
        );
    }
}
