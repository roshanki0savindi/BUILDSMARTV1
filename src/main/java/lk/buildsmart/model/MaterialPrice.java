package lk.buildsmart.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * MaterialPrice ΓÇö price entry for a {@link Material} listed by a
 * specific {@link HardwareShop}.
 *
 * <p><b>OOP ΓÇö Composition</b>: a {@code MaterialPrice} <em>cannot exist</em>
 * without its owning shop. The DB enforces this with
 * {@code ON DELETE CASCADE} on {@code shop_id}. In Java the list of
 * these objects lives inside {@link HardwareShop#getMaterialPrices()}.</p>
 *
 * <p>In addition to the raw FK integers ({@code shopId}, {@code materialId}),
 * this class holds full object references to the parent {@link HardwareShop}
 * and to the associated {@link Material}. These are populated by JOIN queries
 * in {@code MaterialPriceDAO} and are {@code null} when only the flat row is loaded.</p>
 *
 * <p>Maps to the {@code material_prices} table.</p>
 */
public class MaterialPrice {

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** PK: {@code material_prices.price_id} */
    private int           priceId;

    /** FK: {@code material_prices.shop_id} */
    private int           shopId;

    /** FK: {@code material_prices.material_id} */
    private int           materialId;

    /** Brand name (nullable): {@code material_prices.brand} */
    private String        brand;

    /** Listed price: {@code material_prices.price} */
    private BigDecimal    price;

    /**
     * Stock status: {@code material_prices.availability}.
     * Valid values: {@code "In Stock"} | {@code "Out of Stock"}
     */
    private String        availability;

    /** Auto-updated timestamp: {@code material_prices.last_updated} */
    private LocalDateTime lastUpdated;

    // ----- Object references populated by JOIN queries -----

    /**
     * The {@link Material} this price belongs to.
     * Populated when the DAO joins {@code material_prices} with {@code materials}.
     * {@code null} when only the raw FK row is loaded.
     */
    private Material      material;

    /**
     * The parent {@link HardwareShop} that listed this price.
     * Populated when the DAO joins {@code material_prices} with {@code hardware_shops}.
     * {@code null} when only the raw FK row is loaded.
     */
    private HardwareShop  shop;

    // =========================================================
    // Constructors
    // =========================================================

    /** No-arg constructor ΓÇö used by the DAO when mapping a flat ResultSet row. */
    public MaterialPrice() {}

    /**
     * Flat-FK constructor ΓÇö created before persisting (no JOIN data needed yet).
     *
     * @param shopId       FK to the owning shop
     * @param materialId   FK to the material
     * @param brand        brand name (may be {@code null})
     * @param price        listed price (must not be {@code null})
     * @param availability stock status ({@code "In Stock"} or {@code "Out of Stock"})
     */
    public MaterialPrice(int shopId, int materialId, String brand,
                         BigDecimal price, String availability) {
        this.shopId       = shopId;
        this.materialId   = materialId;
        this.brand        = brand;
        this.price        = Objects.requireNonNull(price, "price must not be null");
        this.availability = availability;
    }

    // =========================================================
    // Convenience helpers
    // =========================================================

    /**
     * Returns the material name by delegating to the embedded
     * {@link Material} object, or falls back to an empty string.
     * Safe to call even when {@link #material} is {@code null}.
     */
    public String getMaterialName() {
        return (material != null) ? material.getMaterialName() : "";
    }

    /**
     * Returns the unit from the embedded {@link Material} object,
     * or an empty string if {@link #material} is {@code null}.
     */
    public String getUnit() {
        return (material != null) ? material.getUnit() : "";
    }

    /**
     * Returns the shop name by delegating to the embedded
     * {@link HardwareShop} object, or an empty string when null.
     */
    public String getShopName() {
        return (shop != null) ? shop.getShopName() : "";
    }

    /**
     * Returns {@code true} if the item is currently in stock.
     */
    public boolean isInStock() {
        return "In Stock".equalsIgnoreCase(availability);
    }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int           getPriceId()                              { return priceId; }
    public void          setPriceId(int priceId)                   { this.priceId = priceId; }

    public int           getShopId()                               { return shopId; }
    public void          setShopId(int shopId)                     { this.shopId = shopId; }

    public int           getMaterialId()                           { return materialId; }
    public void          setMaterialId(int materialId)             { this.materialId = materialId; }

    public String        getBrand()                                { return brand; }
    public void          setBrand(String brand)                    { this.brand = brand; }

    public BigDecimal    getPrice()                                { return price; }
    public void          setPrice(BigDecimal price)                { this.price = price; }

    public String        getAvailability()                         { return availability; }
    public void          setAvailability(String availability)      { this.availability = availability; }

    public LocalDateTime getLastUpdated()                          { return lastUpdated; }
    public void          setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }

    public Material      getMaterial()                             { return material; }
    public void          setMaterial(Material material)            { this.material = material; }

    public HardwareShop  getShop()                                 { return shop; }
    public void          setShop(HardwareShop shop)                { this.shop = shop; }

    // =========================================================
    // equals / hashCode ΓÇö uniqueness on (shopId, materialId)
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MaterialPrice other)) return false;
        return shopId == other.shopId && materialId == other.materialId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(shopId, materialId);
    }

    @Override
    public String toString() {
        return "MaterialPrice{priceId=" + priceId
                + ", shopId=" + shopId
                + ", materialId=" + materialId
                + ", price=" + price
                + ", availability='" + availability + '\''
                + '}';
    }
}
