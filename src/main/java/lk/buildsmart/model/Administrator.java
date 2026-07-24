package lk.buildsmart.model;

import java.time.LocalDateTime;

/**
 * Administrator ΓÇö a system admin with full access to manage users,
 * materials, construction packages, and reviews.
 *
 * <p><b>OOP ΓÇö Inheritance</b>: extends {@link User};
 * the role is fixed to {@code "admin"} in the constructor call.</p>
 *
 * <p><b>OOP ΓÇö Polymorphism</b>: overrides {@link #showDashboard()} to
 * return the admin-specific dashboard path. The {@link UserFactory}
 * resolves this at runtime via a {@code User} reference.</p>
 *
 * <p>Maps to the {@code users} table filtered by {@code role = 'admin'}.</p>
 */
public class Administrator extends User {

    // =========================================================
    // Constructors
    // =========================================================

    /**
     * No-arg constructor ΓÇö used by the DAO during reflective mapping.
     */
    public Administrator() {
        super();
    }

    /**
     * Full constructor ΓÇö used when loading an admin row from the database.
     *
     * @param userId    PK from {@code users}
     * @param fullName  display name
     * @param email     login email
     * @param password  BCrypt hash (never plain text)
     * @param phone     contact number (may be {@code null})
     * @param status    account status (typically {@code "active"})
     * @param createdAt registration timestamp
     */
    public Administrator(int userId, String fullName, String email, String password,
                         String phone, String status, LocalDateTime createdAt) {
        super(userId, fullName, email, password, phone, "admin", status, createdAt);
    }

    // =========================================================
    // Abstraction / Polymorphism ΓÇö override showDashboard()
    // =========================================================

    /**
     * {@inheritDoc}
     * Administrators are redirected to {@code /admin/dashboard} after login.
     */
    @Override
    public String showDashboard() {
        return "/admin/dashboard";
    }
}
