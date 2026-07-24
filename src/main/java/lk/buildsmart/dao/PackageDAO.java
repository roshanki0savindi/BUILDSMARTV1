package lk.buildsmart.dao;

import lk.buildsmart.model.ConstructionPackage;
import lk.buildsmart.model.HardwareShop;
import lk.buildsmart.model.Material;
import lk.buildsmart.model.Worker;
import lk.buildsmart.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for {@link ConstructionPackage} and its aggregated junction tables.
 *
 * <p>All aggregated lists (workers, materials, shops) are loaded using
 * single JOINed queries per package to avoid the N+1 select problem.</p>
 */
public class PackageDAO {
    private static final Logger logger = LoggerFactory.getLogger(PackageDAO.class);

    // =========================================================================
    // Read
    // =========================================================================

    public ConstructionPackage getById(int packageId) {
        if (packageId <= 0) return null;
        String sql = "SELECT * FROM construction_packages WHERE package_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, packageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ConstructionPackage pkg = mapRow(rs);
                    loadSuggestions(conn, pkg);
                    return pkg;
                }
            }
        } catch (SQLException e) {
            logger.error("Error fetching package by ID: {}", packageId, e);
        }
        return null;
    }

    /** Returns all packages, each with its full aggregated suggestion lists. */
    public List<ConstructionPackage> getAllPackages() {
        List<ConstructionPackage> packages = new ArrayList<>();
        String sql = "SELECT * FROM construction_packages ORDER BY estimated_budget ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ConstructionPackage pkg = mapRow(rs);
                loadSuggestions(conn, pkg);
                packages.add(pkg);
            }
        } catch (SQLException e) {
            logger.error("Error fetching all packages", e);
        }
        return packages;
    }

    /**
     * Returns all packages without loading aggregated lists.
     * Suitable for lightweight listing in admin dropdowns.
     */
    public List<ConstructionPackage> getAllPackagesShallow() {
        List<ConstructionPackage> packages = new ArrayList<>();
        String sql = "SELECT * FROM construction_packages ORDER BY package_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) packages.add(mapRow(rs));
        } catch (SQLException e) {
            logger.error("Error fetching packages (shallow)", e);
        }
        return packages;
    }

    // =========================================================================
    // Write ΓÇö package CRUD
    // =========================================================================

    public boolean insert(ConstructionPackage pkg) {
        if (pkg == null || pkg.getPackageName() == null || pkg.getEstimatedBudget() == null) return false;
        String sql = "INSERT INTO construction_packages (package_name, estimated_budget, description) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, pkg.getPackageName());
            stmt.setBigDecimal(2, pkg.getEstimatedBudget());
            stmt.setString(3, pkg.getDescription());

            if (stmt.executeUpdate() > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) pkg.setPackageId(keys.getInt(1));
                }
                logger.info("Inserted package: {}", pkg.getPackageName());
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error inserting package: {}", pkg.getPackageName(), e);
        }
        return false;
    }

    public boolean update(ConstructionPackage pkg) {
        if (pkg == null || pkg.getPackageId() <= 0) return false;
        String sql = "UPDATE construction_packages SET package_name=?, estimated_budget=?, description=? WHERE package_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, pkg.getPackageName());
            stmt.setBigDecimal(2, pkg.getEstimatedBudget());
            stmt.setString(3, pkg.getDescription());
            stmt.setInt(4, pkg.getPackageId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error updating package ID: {}", pkg.getPackageId(), e);
        }
        return false;
    }

    public boolean delete(int packageId) {
        if (packageId <= 0) return false;
        // Junction rows are CASCADE deleted by the DB schema
        String sql = "DELETE FROM construction_packages WHERE package_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, packageId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error deleting package ID: {}", packageId, e);
        }
        return false;
    }

    // =========================================================================
    // Write ΓÇö suggestion assignment (add / remove)
    // =========================================================================

    public boolean addWorkerToPackage(int packageId, int workerId) {
        return addSuggestion(packageId, workerId, "package_workers", "worker_id");
    }

    public boolean removeWorkerFromPackage(int packageId, int workerId) {
        return removeSuggestion(packageId, workerId, "package_workers", "worker_id");
    }

    public boolean addMaterialToPackage(int packageId, int materialId) {
        return addSuggestion(packageId, materialId, "package_materials", "material_id");
    }

    public boolean removeMaterialFromPackage(int packageId, int materialId) {
        return removeSuggestion(packageId, materialId, "package_materials", "material_id");
    }

    public boolean addShopToPackage(int packageId, int shopId) {
        return addSuggestion(packageId, shopId, "package_shops", "shop_id");
    }

    public boolean removeShopFromPackage(int packageId, int shopId) {
        return removeSuggestion(packageId, shopId, "package_shops", "shop_id");
    }

    private boolean addSuggestion(int packageId, int entityId, String table, String col) {
        if (packageId <= 0 || entityId <= 0) return false;
        // INSERT IGNORE respects the UNIQUE KEY ΓÇö safe to call repeatedly
        String sql = "INSERT IGNORE INTO " + table + " (package_id, " + col + ") VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, packageId);
            stmt.setInt(2, entityId);
            stmt.executeUpdate(); // 0 rows = already existed; that's fine
            return true;
        } catch (SQLException e) {
            logger.error("Error adding suggestion to {}: pkg={}, entity={}", table, packageId, entityId, e);
        }
        return false;
    }

    private boolean removeSuggestion(int packageId, int entityId, String table, String col) {
        if (packageId <= 0 || entityId <= 0) return false;
        String sql = "DELETE FROM " + table + " WHERE package_id = ? AND " + col + " = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, packageId);
            stmt.setInt(2, entityId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Error removing suggestion from {}: pkg={}, entity={}", table, packageId, entityId, e);
        }
        return false;
    }

    // =========================================================================
    // Private helpers
    // =========================================================================

    /**
     * Loads all three aggregated lists for a package using single JOINs
     * per list rather than per-row DAO calls, avoiding the N+1 problem.
     */
    private void loadSuggestions(Connection conn, ConstructionPackage pkg) throws SQLException {
        loadWorkers(conn, pkg);
        loadMaterials(conn, pkg);
        loadShops(conn, pkg);
    }

    private void loadWorkers(Connection conn, ConstructionPackage pkg) throws SQLException {
        String sql =
            "SELECT u.user_id, u.full_name, u.email, u.phone, u.status, u.created_at, " +
            "       w.worker_id, w.profession, w.experience, w.daily_rate, w.district, w.profile_photo, w.photo_mime " +
            "FROM   package_workers pw " +
            "JOIN   workers w ON w.worker_id = pw.worker_id " +
            "JOIN   users   u ON u.user_id   = w.user_id " +
            "WHERE  pw.package_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pkg.getPackageId());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Worker w = new Worker();
                    w.setUserId(rs.getInt("user_id"));
                    w.setFullName(rs.getString("full_name"));
                    w.setEmail(rs.getString("email"));
                    w.setPhone(rs.getString("phone"));
                    w.setStatus(rs.getString("status"));
                    w.setWorkerId(rs.getInt("worker_id"));
                    w.setProfession(rs.getString("profession"));
                    w.setExperience(rs.getInt("experience"));
                    w.setDailyRate(rs.getBigDecimal("daily_rate"));
                    w.setDistrict(rs.getString("district"));
                    w.setProfilePhoto(rs.getBytes("profile_photo"));
                    w.setProfilePhotoType(rs.getString("photo_mime"));
                    pkg.addWorker(w);
                }
            }
        }
    }

    private void loadMaterials(Connection conn, ConstructionPackage pkg) throws SQLException {
        String sql =
            "SELECT m.material_id, m.material_name, m.category, m.unit " +
            "FROM   package_materials pm " +
            "JOIN   materials m ON m.material_id = pm.material_id " +
            "WHERE  pm.package_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pkg.getPackageId());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Material m = new Material(
                        rs.getInt("material_id"),
                        rs.getString("material_name"),
                        rs.getString("category"),
                        rs.getString("unit")
                    );
                    pkg.addMaterial(m);
                }
            }
        }
    }

    private void loadShops(Connection conn, ConstructionPackage pkg) throws SQLException {
        String sql =
            "SELECT hs.shop_id, hs.shop_name, hs.owner_name, hs.district, hs.phone, hs.delivery_available " +
            "FROM   package_shops ps " +
            "JOIN   hardware_shops hs ON hs.shop_id = ps.shop_id " +
            "WHERE  ps.package_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pkg.getPackageId());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HardwareShop s = new HardwareShop();
                    s.setShopId(rs.getInt("shop_id"));
                    s.setShopName(rs.getString("shop_name"));
                    s.setOwnerName(rs.getString("owner_name"));
                    s.setDistrict(rs.getString("district"));
                    s.setPhone(rs.getString("phone"));
                    // logo BLOB is not fetched here ΓÇö use /img?type=shop&id=N endpoint
                    s.setDeliveryAvailable(rs.getBoolean("delivery_available"));
                    pkg.addShop(s);
                }
            }
        }
    }

    private ConstructionPackage mapRow(ResultSet rs) throws SQLException {
        return new ConstructionPackage(
            rs.getInt("package_id"),
            rs.getString("package_name"),
            rs.getBigDecimal("estimated_budget"),
            rs.getString("description")
        );
    }
}
