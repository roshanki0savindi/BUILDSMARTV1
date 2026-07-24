package lk.buildsmart.model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * HardwareOwner ΓÇö a registered hardware shop owner who manages a
 * {@link HardwareShop} profile, lists material prices, and receives reviews.
 *
 * <p><b>OOP ΓÇö Inheritance</b>: extends {@link User};
 * the role is fixed to {@code "hardware_owner"} in the constructor call.</p>
 *
 * <p><b>OOP ΓÇö Composition</b>: a {@code HardwareOwner} <em>owns</em> exactly
 * one {@link HardwareShop}. The shop cannot exist without the owner ΓÇö if the
 * owner's user record is deleted, the shop row is removed by
 * {@code ON DELETE CASCADE} in the database. In Java, the shop is held as
 * a private field and exposed via {@link #getShop()} / {@link #setShop(HardwareShop)}.
 * </p>
 *
 * <p>Maps to the {@code users} table (filtered by {@code role = 'hardware_owner'})
 * with a 1-to-1 relationship to {@code hardware_shops}.</p>
 */
public class HardwareOwner extends User {

    // =========================================================
    // Composition ΓÇö the shop owned by this hardware owner
    // =========================================================

    /**
     * <b>Composition</b>: the single {@link HardwareShop} that belongs to
     * this owner. Loaded on demand by {@code HardwareShopDAO.findByUserId(userId)}.
     * {@code null} until the shop profile has been created.
     */
    private HardwareShop shop;

    // =========================================================
    // Constructors
    // =========================================================

    /**
     * No-arg constructor ΓÇö used by the DAO during reflective mapping.
     */
    public HardwareOwner() {
        super();
    }

    /**
     * User-only constructor ΓÇö used before the shop profile is loaded.
     *
     * @param userId    PK from {@code users}
     * @param fullName  display name
     * @param email     login email
     * @param password  BCrypt hash (never plain text)
     * @param phone     contact number (may be {@code null})
     * @param status    account status ({@code "active"}, {@code "pending"}, {@code "rejected"})
     * @param createdAt registration timestamp
     */
    public HardwareOwner(int userId, String fullName, String email, String password,
                         String phone, String status, LocalDateTime createdAt) {
        super(userId, fullName, email, password, phone, "hardware_owner", status, createdAt);
    }

    /**
     * Full constructor ΓÇö used when loading the owner together with their shop in a JOIN.
     *
     * @param userId    PK from {@code users}
     * @param fullName  display name
     * @param email     login email
     * @param password  BCrypt hash
     * @param phone     contact number (nullable)
     * @param status    account status
     * @param createdAt registration timestamp
     * @param shop      the composed {@link HardwareShop} (may be {@code null} if not yet created)
     */
    public HardwareOwner(int userId, String fullName, String email, String password,
                         String phone, String status, LocalDateTime createdAt,
                         HardwareShop shop) {
        super(userId, fullName, email, password, phone, "hardware_owner", status, createdAt);
        this.shop = shop;
    }

    // =========================================================
    // Abstraction / Polymorphism ΓÇö override showDashboard()
    // =========================================================

    /**
     * {@inheritDoc}
     * Hardware owners are redirected to {@code /hardware/dashboard} after login.
     */
    @Override
    public String showDashboard() {
        return "/hardware/dashboard";
    }

    // =========================================================
    // Composition helpers
    // =========================================================

    /**
     * Returns {@code true} if this owner has created their shop profile.
     */
    public boolean hasShop() {
        return shop != null;
    }

    // =========================================================
    // Getter and Setter
    // =========================================================

    /**
     * Returns the composed {@link HardwareShop}, or {@code null} if the
     * shop profile has not been created or loaded yet.
     */
    public HardwareShop getShop() {
        return shop;
    }

    /**
     * Sets the composed {@link HardwareShop}.
     * Automatically synchronises {@link HardwareShop#setUserId(int)} to keep
     * the FK consistent with this owner's {@code userId}.
     *
     * @param shop the shop to attach (may be {@code null} to detach)
     */
    public void setShop(HardwareShop shop) {
        this.shop = shop;
        if (shop != null && shop.getUserId() == 0) {
            shop.setUserId(getUserId());
        }
    }
}
