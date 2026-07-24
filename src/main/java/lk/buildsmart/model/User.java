package lk.buildsmart.model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Abstract User ΓÇö base class for all user roles.
 *
 * <p><b>OOP Concepts demonstrated:</b>
 * <ul>
 *   <li><b>Abstraction</b>: {@link #showDashboard()} is declared {@code abstract};
 *       every concrete subclass <em>must</em> supply its own dashboard path.</li>
 *   <li><b>Encapsulation</b>: all fields are {@code private}; access is only via
 *       public getters/setters. The password field is never exposed to JSP views.</li>
 *   <li><b>Inheritance</b>: {@link Homeowner}, {@link Worker}, {@link HardwareOwner},
 *       and {@link Administrator} all extend this class.</li>
 *   <li><b>Polymorphism</b>: {@link UserFactory} uses {@code showDashboard()} via
 *       the base-class reference ΓÇö the caller never needs to know the subtype.</li>
 * </ul>
 * </p>
 *
 * <p>Maps to the {@code users} table
 * (DB snake_case columns ΓåÆ Java camelCase fields).</p>
 */
public abstract class User {

    // =========================================================
    // Encapsulation ΓÇö all fields are private
    // =========================================================

    /** Primary key: {@code users.user_id} */
    private int           userId;

    /** Display name: {@code users.full_name} */
    private String        fullName;

    /** Unique login email: {@code users.email} */
    private String        email;

    /**
     * BCrypt hash of the password: {@code users.password}.
     * <strong>Never include this in JSON responses or JSP output.</strong>
     */
    private String        password;

    /** Contact number: {@code users.phone} (nullable) */
    private String        phone;

    /**
     * Role discriminator: {@code users.role}.
     * Valid values: {@code homeowner} | {@code worker} |
     * {@code hardware_owner} | {@code admin}
     */
    private String        role;

    /**
     * Account state: {@code users.status}.
     * Valid values: {@code active} | {@code pending} | {@code rejected}
     */
    private String        status;

    /** Registration timestamp: {@code users.created_at} */
    private LocalDateTime createdAt;

    // =========================================================
    // Constructors
    // =========================================================

    /**
     * No-arg constructor ΓÇö required by DAO layer for reflective instantiation
     * and for subclass default constructors.
     */
    protected User() {}

    /**
     * Full-state constructor ΓÇö used by {@link UserFactory} and every DAO
     * that maps a {@code ResultSet} row to a {@link User} subclass.
     *
     * @param userId    primary key
     * @param fullName  user's display name
     * @param email     unique login email
     * @param password  BCrypt hash (never a plain-text password)
     * @param phone     contact number (may be {@code null})
     * @param role      role discriminator (e.g. {@code "worker"})
     * @param status    account status (e.g. {@code "active"})
     * @param createdAt registration timestamp
     */
    public User(int userId, String fullName, String email, String password,
                String phone, String role, String status, LocalDateTime createdAt) {
        this.userId    = userId;
        this.fullName  = fullName;
        this.email     = email;
        this.password  = password;
        this.phone     = phone;
        this.role      = role;
        this.status    = status;
        this.createdAt = createdAt;
    }

    // =========================================================
    // Abstraction ΓÇö each subclass MUST override this
    // =========================================================

    /**
     * Returns the servlet-path for this user's dashboard.
     * Used by {@link UserFactory} after login to redirect the browser.
     *
     * <p><b>Polymorphism</b>: the caller holds a {@code User} reference;
     * the correct subtype's path is resolved at runtime.</p>
     *
     * @return context-relative path, e.g. {@code "/homeowner/dashboard"}
     */
    public abstract String showDashboard();

    // =========================================================
    // Convenience helpers
    // =========================================================

    /**
     * Returns a human-readable role label for use in UI / JSP views.
     * Example: {@code "hardware_owner"} ΓåÆ {@code "Hardware Owner"}
     */
    public String getDisplayRole() {
        if (role == null) return "";
        return switch (role) {
            case "homeowner"      -> "Homeowner";
            case "worker"         -> "Worker";
            case "hardware_owner" -> "Hardware Owner";
            case "admin"          -> "Administrator";
            default               -> role;
        };
    }

    /**
     * Returns {@code true} if this account is active and can log in.
     */
    public boolean isActive() {
        return "active".equalsIgnoreCase(status);
    }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int           getUserId()                       { return userId; }
    public void          setUserId(int userId)              { this.userId = userId; }

    public String        getFullName()                     { return fullName; }
    public void          setFullName(String fullName)       { this.fullName = fullName; }

    public String        getEmail()                        { return email; }
    public void          setEmail(String email)             { this.email = email; }

    /** @return the BCrypt hash ΓÇö <strong>do NOT expose in JSP or JSON</strong> */
    public String        getPassword()                     { return password; }
    public void          setPassword(String password)      { this.password = password; }

    public String        getPhone()                        { return phone; }
    public void          setPhone(String phone)             { this.phone = phone; }

    public String        getRole()                         { return role; }
    public void          setRole(String role)               { this.role = role; }

    public String        getStatus()                       { return status; }
    public void          setStatus(String status)           { this.status = status; }

    public LocalDateTime getCreatedAt()                    { return createdAt; }
    public void          setCreatedAt(LocalDateTime t)      { this.createdAt = t; }

    // =========================================================
    // equals / hashCode ΓÇö identity is based on userId
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User other)) return false;
        return userId == other.userId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId);
    }

    // =========================================================
    // toString ΓÇö safe: never prints the password hash
    // =========================================================

    @Override
    public String toString() {
        return getClass().getSimpleName()
                + "{userId=" + userId
                + ", email='" + email + '\''
                + ", role='" + role + '\''
                + ", status='" + status + '\''
                + '}';
    }
}
