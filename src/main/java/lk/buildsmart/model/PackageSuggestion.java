package lk.buildsmart.model;

import java.util.Objects;

/**
 * PackageSuggestion ΓÇö a lightweight view-model that pairs a
 * {@link ConstructionPackage} with a specific suggested entity
 * (a {@link Worker}, {@link HardwareShop}, or {@link Material}).
 *
 * <p>This class acts as a <em>junction DTO</em> for the three
 * aggregation tables ({@code package_workers}, {@code package_materials},
 * {@code package_shops}). It is used in admin views where the system
 * displays which entities are currently assigned to each package,
 * and in homeowner views where the full package detail is rendered.</p>
 *
 * <p><b>OOP ΓÇö Association</b>: both the {@link ConstructionPackage} and
 * the suggested entity ({@link Worker} / {@link HardwareShop} / {@link Material})
 * exist independently. Deleting a {@code PackageSuggestion} (i.e. removing a
 * row from the junction table) does not delete either side.</p>
 *
 * <p>This is a pure in-memory object ΓÇö it has no corresponding single table;
 * it is assembled by the DAO from a JOIN query.</p>
 *
 * <h2>Usage examples</h2>
 * <pre>
 * // Suggest a worker for a package:
 * PackageSuggestion s = PackageSuggestion.forWorker(pkg, worker);
 *
 * // Suggest a material:
 * PackageSuggestion s = PackageSuggestion.forMaterial(pkg, material);
 *
 * // Suggest a shop:
 * PackageSuggestion s = PackageSuggestion.forShop(pkg, shop);
 * </pre>
 */
public class PackageSuggestion {

    // =========================================================
    // Type discriminator
    // =========================================================

    /**
     * Identifies which kind of entity is being suggested.
     */
    public enum SuggestionType {
        /** The suggested entity is a {@link Worker}. */
        WORKER,
        /** The suggested entity is a {@link Material}. */
        MATERIAL,
        /** The suggested entity is a {@link HardwareShop}. */
        SHOP
    }

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** The package this suggestion belongs to. */
    private ConstructionPackage constructionPackage;

    /** Which kind of entity is being suggested. */
    private SuggestionType      suggestionType;

    /**
     * The suggested {@link Worker}.
     * Non-null only when {@link #suggestionType} is {@link SuggestionType#WORKER}.
     */
    private Worker              worker;

    /**
     * The suggested {@link Material}.
     * Non-null only when {@link #suggestionType} is {@link SuggestionType#MATERIAL}.
     */
    private Material            material;

    /**
     * The suggested {@link HardwareShop}.
     * Non-null only when {@link #suggestionType} is {@link SuggestionType#SHOP}.
     */
    private HardwareShop        shop;

    // =========================================================
    // Private constructor ΓÇö use static factory methods
    // =========================================================

    private PackageSuggestion() {}

    // =========================================================
    // Static factory methods (Builder-style)
    // =========================================================

    /**
     * Creates a {@code PackageSuggestion} that links a package to a worker.
     *
     * @param pkg    the package (must not be {@code null})
     * @param worker the suggested worker (must not be {@code null})
     * @return a fully initialised {@code PackageSuggestion}
     */
    public static PackageSuggestion forWorker(ConstructionPackage pkg, Worker worker) {
        Objects.requireNonNull(pkg,    "ConstructionPackage must not be null");
        Objects.requireNonNull(worker, "Worker must not be null");
        PackageSuggestion s = new PackageSuggestion();
        s.constructionPackage = pkg;
        s.suggestionType      = SuggestionType.WORKER;
        s.worker              = worker;
        return s;
    }

    /**
     * Creates a {@code PackageSuggestion} that links a package to a material.
     *
     * @param pkg      the package (must not be {@code null})
     * @param material the suggested material (must not be {@code null})
     * @return a fully initialised {@code PackageSuggestion}
     */
    public static PackageSuggestion forMaterial(ConstructionPackage pkg, Material material) {
        Objects.requireNonNull(pkg,      "ConstructionPackage must not be null");
        Objects.requireNonNull(material, "Material must not be null");
        PackageSuggestion s = new PackageSuggestion();
        s.constructionPackage = pkg;
        s.suggestionType      = SuggestionType.MATERIAL;
        s.material            = material;
        return s;
    }

    /**
     * Creates a {@code PackageSuggestion} that links a package to a hardware shop.
     *
     * @param pkg  the package (must not be {@code null})
     * @param shop the suggested shop (must not be {@code null})
     * @return a fully initialised {@code PackageSuggestion}
     */
    public static PackageSuggestion forShop(ConstructionPackage pkg, HardwareShop shop) {
        Objects.requireNonNull(pkg,  "ConstructionPackage must not be null");
        Objects.requireNonNull(shop, "HardwareShop must not be null");
        PackageSuggestion s = new PackageSuggestion();
        s.constructionPackage = pkg;
        s.suggestionType      = SuggestionType.SHOP;
        s.shop                = shop;
        return s;
    }

    // =========================================================
    // Convenience helpers
    // =========================================================

    /**
     * Returns a human-readable name of the suggested entity regardless of type.
     * Useful in JSP EL: {@code ${suggestion.displayName}}
     */
    public String getDisplayName() {
        return switch (suggestionType) {
            case WORKER   -> (worker   != null) ? worker.getFullName()   : "";
            case MATERIAL -> (material != null) ? material.getMaterialName() : "";
            case SHOP     -> (shop     != null) ? shop.getShopName()     : "";
        };
    }

    /**
     * Returns the entity's ID (worker_id, material_id, or shop_id) regardless of type.
     * Useful for building links in JSP views.
     */
    public int getEntityId() {
        return switch (suggestionType) {
            case WORKER   -> (worker   != null) ? worker.getWorkerId()     : 0;
            case MATERIAL -> (material != null) ? material.getMaterialId() : 0;
            case SHOP     -> (shop     != null) ? shop.getShopId()         : 0;
        };
    }

    // =========================================================
    // Getters (Encapsulation) ΓÇö no public setters; use factory methods
    // =========================================================

    public ConstructionPackage getConstructionPackage() { return constructionPackage; }
    public SuggestionType      getSuggestionType()      { return suggestionType; }
    public Worker              getWorker()              { return worker; }
    public Material            getMaterial()            { return material; }
    public HardwareShop        getShop()                { return shop; }

    @Override
    public String toString() {
        return "PackageSuggestion{packageId=" + (constructionPackage != null ? constructionPackage.getPackageId() : "null")
                + ", type=" + suggestionType
                + ", entityId=" + getEntityId()
                + ", displayName='" + getDisplayName() + '\''
                + '}';
    }
}
