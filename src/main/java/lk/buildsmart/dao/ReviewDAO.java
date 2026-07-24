package lk.buildsmart.dao;

import lk.buildsmart.model.Review;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    private static final Logger logger = LoggerFactory.getLogger(ReviewDAO.class);

    public List<Review> getAll() {
        List<Review> reviews = new ArrayList<>();
        // NOTE: target_photo is intentionally omitted from the admin list query ΓÇö
        // pulling BLOB data from worker/shop tables on every row would be very expensive.
        // The admin view uses /img?type=... endpoints to load images on demand.
        String sql = "SELECT r.*, u.full_name as reviewer_name, " +
                     "CASE WHEN r.target_type = 'worker' THEN (SELECT u2.full_name FROM workers w JOIN users u2 ON w.user_id = u2.user_id WHERE w.worker_id = r.target_id) " +
                     "     WHEN r.target_type = 'hardware_shop' THEN (SELECT s.shop_name FROM hardware_shops s WHERE s.shop_id = r.target_id) END as target_name " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                reviews.add(mapRowToReview(rs));
            }
        } catch (SQLException e) {
            logger.error("Error fetching all reviews for moderation", e);
        }
        return reviews;
    }

    public List<Review> getByStatus(int status) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as reviewer_name, " +
                     "CASE WHEN r.target_type = 'worker' THEN (SELECT u2.full_name FROM workers w JOIN users u2 ON w.user_id = u2.user_id WHERE w.worker_id = r.target_id) " +
                     "     WHEN r.target_type = 'hardware_shop' THEN (SELECT s.shop_name FROM hardware_shops s WHERE s.shop_id = r.target_id) END as target_name " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id WHERE r.status = ? ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapRowToReview(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching reviews by status: {}", status, e);
        }
        return reviews;
    }

    public List<Review> getByUserId(int userId) {
        List<Review> reviews = new ArrayList<>();
        if (userId <= 0) return reviews;

        String sql = "SELECT r.*, u.full_name as reviewer_name, " +
                     "CASE WHEN r.target_type = 'worker' THEN (SELECT u2.full_name FROM workers w JOIN users u2 ON w.user_id = u2.user_id WHERE w.worker_id = r.target_id) " +
                     "     WHEN r.target_type = 'hardware_shop' THEN (SELECT s.shop_name FROM hardware_shops s WHERE s.shop_id = r.target_id) END as target_name " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id WHERE r.user_id = ? ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapRowToReview(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching reviews for user ID: {}", userId, e);
        }
        return reviews;
    }

    /**
     * Public page review query ΓÇö ONLY fetches APPROVED (status = 1) reviews.
     * Includes the review's own photo BLOB for display on profile pages.
     */
    public List<Review> getByTarget(String targetType, int targetId) {
        List<Review> reviews = new ArrayList<>();
        if (targetType == null || targetId <= 0) return reviews;

        String sql = "SELECT r.*, u.full_name as reviewer_name " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.target_type = ? AND r.target_id = ? AND r.status = 1 ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, targetType);
            stmt.setInt(2, targetId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapRowToReview(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching reviews for target {} ID: {}", targetType, targetId, e);
        }
        return reviews;
    }

    public boolean insert(Review review) {
        if (review == null || review.getUserId() <= 0 || review.getTargetId() <= 0) return false;

        try {
            review.validateRating();
        } catch (IllegalArgumentException e) {
            logger.warn("Invalid review rating: {}", review.getRating());
            return false;
        }

        String sql = "INSERT INTO reviews (user_id, target_type, target_id, rating, comment, photo, photo_mime, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, review.getUserId());
            stmt.setString(2, review.getTargetType());
            stmt.setInt(3, review.getTargetId());
            stmt.setInt(4, review.getRating());
            stmt.setString(5, review.getComment());
            stmt.setBytes(6, review.getPhoto());
            stmt.setString(7, review.getPhotoType());
            stmt.setInt(8, review.getStatus());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        review.setReviewId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting review for user ID: {}", review.getUserId(), e);
        }
        return false;
    }

    public boolean updateStatus(int reviewId, int status) {
        if (reviewId <= 0) return false;
        String sql = "UPDATE reviews SET status = ? WHERE review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, status);
            stmt.setInt(2, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating review status for ID: {}", reviewId, e);
        }
        return false;
    }

    public boolean delete(int reviewId) {
        if (reviewId <= 0) return false;
        String sql = "DELETE FROM reviews WHERE review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting review ID: {}", reviewId, e);
        }
        return false;
    }

    private Review mapRowToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setTargetType(rs.getString("target_type"));
        review.setTargetId(rs.getInt("target_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setPhoto(rs.getBytes("photo"));
        review.setPhotoType(rs.getString("photo_mime"));

        try {
            review.setStatus(rs.getInt("status"));
        } catch (SQLException ignore) {
            review.setStatus(Review.PENDING);
        }

        if (rs.getTimestamp("review_date") != null) {
            review.setReviewDate(rs.getTimestamp("review_date").toLocalDateTime());
        }

        try {
            review.setReviewerName(rs.getString("reviewer_name"));
        } catch (SQLException ignore) {}

        try {
            review.setTargetName(rs.getString("target_name"));
        } catch (SQLException ignore) {}

        return review;
    }
}
