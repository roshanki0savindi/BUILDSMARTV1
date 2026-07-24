package lk.buildsmart.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * HardwareShop ΓÇö the shop profile that belongs to a {@link HardwareOwner}.
 *
 * <p><b>OOP ΓÇö Composition</b>: a {@code HardwareShop} <em>owns</em> its
 * {@link MaterialPrice} list. If the shop (or its owner) is deleted, all
 * price entries are removed by the database ({@code ON DELETE CASCADE}).</p>
 *
 * <p>Maps to the {@code hardware_shops} table (snake_case ΓåÆ camelCase).</p>
 */
public class HardwareShop {

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** PK: {@code hardware_shops.shop_id} */
    private int           shopId;

    /** FK to owner: {@code hardware_shops.user_id} */
    private int           userId;

    /** Shop display name: {@code hardware_shops.shop_name} */
    private String        shopName;

    /** Owner's full name (denormalised for display): {@code hardware_shops.owner_name} */
    private String        ownerName;

    /** Business reg. number: {@code hardware_shops.business_registration_number} */
    private String        businessRegistrationNumber;

    /** Street address: {@code hardware_shops.address} */
    private String        address;

    /** Administrative district: {@code hardware_shops.district} */
    private String        district;

    /** Contact phone: {@code hardware_shops.phone} */
    private String        phone;

    /** Logo binary: {@code hardware_shops.logo} (MEDIUMBLOB, null = no logo) */
    private byte[]        logo;

    /** MIME type of the logo: {@code hardware_shops.logo_mime} (e.g. image/png) */
    private String        logoType;

    /** Display string for opening hours: {@code hardware_shops.opening_hours} */
    private String        openingHours = "8:00 AM - 6:00 PM";

    /** Whether the shop offers delivery: {@code hardware_shops.delivery_available} (0/1) */
    private boolean       deliveryAvailable;

    /** Free-text shop description: {@code hardware_shops.description} */
    private String        description;

    /** Profile-update timestamp: {@code hardware_shops.last_updated} */
    private LocalDateTime lastUpdated;

    // ----- Computed fields from JOIN / aggregate queries -----

    /** Average rating computed from the {@code reviews} table (0.0 if none). */
    private double        averageRating;

    /** Total number of reviews for this shop. */
    private int           reviewCount;

    /**
     * <b>Composition</b> ΓÇö the list of {@link MaterialPrice} entries this shop
     * has listed. Entries cannot exist without this shop. Loaded on demand by the DAO.
     */
    private List<MaterialPrice> materialPrices = new ArrayList<>();

    // =========================================================
    // Constructors
    // =========================================================

    /** No-arg constructor ΓÇö used by the DAO. */
    public HardwareShop() {}

    /**
     * Core constructor ΓÇö all mandatory columns from the {@code hardware_shops} table.
     *
     * @param shopId   PK
     * @param userId   FK to the owning user
     * @param shopName display name of the shop
     */
    public HardwareShop(int shopId, int userId, String shopName) {
        this.shopId   = shopId;
        this.userId   = userId;
        this.shopName = Objects.requireNonNull(shopName, "shopName must not be null");
    }

    // =========================================================
    // Material-price composition helpers
    // =========================================================

    /**
     * Adds a {@link MaterialPrice} to this shop's composed list.
     * Duplicate entries (same shopId+materialId) are ignored.
     *
     * @param price the price entry to add (must not be {@code null})
     */
    public void addMaterialPrice(MaterialPrice price) {
        Objects.requireNonNull(price, "MaterialPrice must not be null");
        price.setShopId(this.shopId);  // ensure FK consistency
        if (!materialPrices.contains(price)) {
            materialPrices.add(price);
        }
    }

    /**
     * Removes a {@link MaterialPrice} from this shop's composed list.
     *
     * @param price the entry to remove
     * @return {@code true} if the entry was present and removed
     */
    public boolean removeMaterialPrice(MaterialPrice price) {
        return materialPrices.remove(price);
    }

    /**
     * Returns an <em>unmodifiable view</em> of the material-prices list.
     * Use {@link #setMaterialPrices(List)} or {@link #addMaterialPrice(MaterialPrice)}
     * to mutate.
     */
    public List<MaterialPrice> getMaterialPrices() {
        return Collections.unmodifiableList(materialPrices);
    }

    /**
     * Replaces the entire material-prices list (used by the DAO after a bulk load).
     * A defensive copy is stored internally.
     *
     * @param materialPrices the new list (may be {@code null}, treated as empty)
     */
    public void setMaterialPrices(List<MaterialPrice> materialPrices) {
        this.materialPrices = (materialPrices != null)
                ? new ArrayList<>(materialPrices)
                : new ArrayList<>();
    }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int           getShopId()                                    { return shopId; }
    public void          setShopId(int shopId)                          { this.shopId = shopId; }

    public int           getUserId()                                    { return userId; }
    public void          setUserId(int userId)                          { this.userId = userId; }

    public String        getShopName()                                  { return shopName; }
    public void          setShopName(String shopName)                   { this.shopName = shopName; }

    public String        getOwnerName()                                 { return ownerName; }
    public void          setOwnerName(String ownerName)                 { this.ownerName = ownerName; }

    public String        getBusinessRegistrationNumber()                { return businessRegistrationNumber; }
    public void          setBusinessRegistrationNumber(String brn)      { this.businessRegistrationNumber = brn; }

    public String        getAddress()                                   { return address; }
    public void          setAddress(String address)                     { this.address = address; }

    public String        getDistrict()                                  { return district; }
    public void          setDistrict(String district)                   { this.district = district; }

    public String        getPhone()                                     { return phone; }
    public void          setPhone(String phone)                         { this.phone = phone; }

    public byte[]        getLogo()                                       { return logo; }
    public void          setLogo(byte[] logo)                            { this.logo = logo; }

    public String        getLogoType()                                   { return logoType; }
    public void          setLogoType(String logoType)                    { this.logoType = logoType; }

    /** Returns {@code true} if a logo has been uploaded. */
    public boolean       hasLogo()                                       { return logo != null && logo.length > 0; }
    public boolean       isHasLogo()                                     { return hasLogo(); }

    public String        getOpeningHours()                              { return openingHours; }
    public void          setOpeningHours(String openingHours)           { this.openingHours = openingHours; }

    public boolean       isDeliveryAvailable()                          { return deliveryAvailable; }
    public void          setDeliveryAvailable(boolean deliveryAvailable){ this.deliveryAvailable = deliveryAvailable; }

    public String        getDescription()                               { return description; }
    public void          setDescription(String description)             { this.description = description; }

    public LocalDateTime getLastUpdated()                               { return lastUpdated; }
    public void          setLastUpdated(LocalDateTime lastUpdated)      { this.lastUpdated = lastUpdated; }

    public double        getAverageRating()                             { return averageRating; }
    public void          setAverageRating(double averageRating)         { this.averageRating = averageRating; }

    public int           getReviewCount()                               { return reviewCount; }
    public void          setReviewCount(int reviewCount)                { this.reviewCount = reviewCount; }

    // =========================================================
    // equals / hashCode ΓÇö identity by shopId
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof HardwareShop other)) return false;
        return shopId == other.shopId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(shopId);
    }

    @Override
    public String toString() {
        return "HardwareShop{shopId=" + shopId
                + ", shopName='" + shopName + '\''
                + ", district='" + district + '\''
                + '}';
    }
}
