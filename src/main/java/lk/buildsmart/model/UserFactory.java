package lk.buildsmart.model;

import java.time.LocalDateTime;

/**
 * UserFactory ΓÇö constructs the correct {@link User} subclass from raw DB values.
 *
 * <p><b>OOP ΓÇö Factory Method pattern</b>: the caller works only with the
 * abstract {@link User} reference. The concrete subclass ({@link Homeowner},
 * {@link Worker}, {@link HardwareOwner}, {@link Administrator}) is chosen
 * at runtime based on the {@code role} column value.</p>
 *
 * <p><b>OOP ΓÇö Polymorphism</b>: after calling {@code UserFactory.create()},
 * invoking {@code user.showDashboard()} automatically dispatches to the
 * correct override without any {@code instanceof} checks.</p>
 *
 * <h2>Usage</h2>
 * <pre>
 * User user = UserFactory.create(
 *     rs.getInt("user_id"),
 *     rs.getString("full_name"),
 *     rs.getString("email"),
 *     rs.getString("password"),
 *     rs.getString("phone"),
 *     rs.getString("role"),
 *     rs.getString("status"),
 *     rs.getObject("created_at", LocalDateTime.class)
 * );
 * response.sendRedirect(request.getContextPath() + user.showDashboard());
 * </pre>
 */
public final class UserFactory {

    /** Utility class ΓÇö prevent instantiation. */
    private UserFactory() {}

    /**
     * Builds the appropriate {@link User} subclass from the raw DB column values.
     *
     * @param userId    PK from {@code users.user_id}
     * @param fullName  display name from {@code users.full_name}
     * @param email     login email from {@code users.email}
     * @param password  BCrypt hash from {@code users.password} (never plain text)
     * @param phone     contact number from {@code users.phone} (may be {@code null})
     * @param role      role discriminator from {@code users.role}:
     *                  {@code "homeowner"} | {@code "worker"} |
     *                  {@code "hardware_owner"} | {@code "admin"}
     * @param status    account state from {@code users.status}:
     *                  {@code "active"} | {@code "pending"} | {@code "rejected"}
     * @param createdAt registration timestamp from {@code users.created_at}
     * @return the correct concrete {@link User} subclass, never {@code null}
     * @throws IllegalArgumentException if {@code role} is not a recognised value
     */
    public static User create(int userId, String fullName, String email,
                              String password, String phone,
                              String role, String status,
                              LocalDateTime createdAt) {

        if (role == null || role.isBlank()) {
            throw new IllegalArgumentException("User role must not be null or blank");
        }

        return switch (role.trim().toLowerCase()) {
            case "homeowner"      -> new Homeowner(
                                         userId, fullName, email, password,
                                         phone, status, createdAt);

            case "worker"         -> new Worker(
                                         userId, fullName, email, password,
                                         phone, status, createdAt);

            case "hardware_owner" -> new HardwareOwner(
                                         userId, fullName, email, password,
                                         phone, status, createdAt);

            case "admin"          -> new Administrator(
                                         userId, fullName, email, password,
                                         phone, status, createdAt);

            default               -> throw new IllegalArgumentException(
                                         "Unrecognised user role: '" + role + "'");
        };
    }
}
