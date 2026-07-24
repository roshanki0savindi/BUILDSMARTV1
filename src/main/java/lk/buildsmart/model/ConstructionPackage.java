package lk.buildsmart.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * ConstructionPackage ΓÇö one of the preset bundles (Basic / Standard / Premium)
 * that aggregate suggested workers, materials, and hardware shops for a homeowner.
 *
 * <p><b>OOP ΓÇö Aggregation</b>: the package <em>references</em> workers, materials,
 * and shops that exist independently. Deleting a package removes only the
 * junction-table rows ({@code package_workers}, {@code package_materials},
 * {@code package_shops}) ΓÇö the referenced entities are unaffected.
 * This is the key distinction from Composition.</p>
 *
 * <p>Maps to the {@code construction_packages} table with the
 * junction tables represented as {@link List}s loaded by the DAO.</p>
 */
public class ConstructionPackage {

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** PK: {@code construction_packages.package_id} */
    private int          packageId;

    /**
     * Tier name: {@code construction_packages.package_name}.
     * Expected values: {@code "Basic"} | {@code "Standard"} | {@code "Premium"}
     */
    private String       packageName;

    /**
     * Estimated total construction cost: {@code construction_packages.estimated_budget}.
     * Stored as {@link BigDecimal} to preserve financial precision.
     */
    private BigDecimal   estimatedBudget;

    /** Free-text description: {@code construction_packages.description} (nullable) */
    private String       description;

    // ----- Aggregation lists ΓÇö loaded on demand by PackageDAO -----

    /**
     * <b>Aggregation</b>: suggested {@link Worker}s for this package tier.
     * Backed by {@code package_workers} junction table.
     * Workers exist independently; they are not deleted with the package.
     */
    private List<Worker>       workers   = new ArrayList<>();

    /**
     * <b>Aggregation</b>: suggested {@link Material}s for this package tier.
     * Backed by {@code package_materials} junction table.
     */
    private List<Material>     materials = new ArrayList<>();

    /**
     * <b>Aggregation</b>: suggested {@link HardwareShop}s for this package tier.
     * Backed by {@code package_shops} junction table.
     */
    private List<HardwareShop> shops     = new ArrayList<>();

    // =========================================================
    // Constructors
    // =========================================================

    /** No-arg constructor ΓÇö used by the DAO and JSP frameworks. */
    public ConstructionPackage() {}

    /**
     * Full constructor ΓÇö used when loading a row from the
     * {@code construction_packages} table (without the aggregated lists).
     *
     * @param packageId       PK
     * @param packageName     tier label ({@code "Basic"}, {@code "Standard"}, {@code "Premium"})
     * @param estimatedBudget total budget estimate (must not be {@code null})
     * @param description     free-text description (nullable)
     */
    public ConstructionPackage(int packageId, String packageName,
                               BigDecimal estimatedBudget, String description) {
        this.packageId       = packageId;
        this.packageName     = Objects.requireNonNull(packageName, "packageName must not be null");
        this.estimatedBudget = Objects.requireNonNull(estimatedBudget, "estimatedBudget must not be null");
        this.description     = description;
    }

    // =========================================================
    // Aggregation helpers
    // =========================================================

    /**
     * Adds a {@link Worker} to the aggregated suggestion list if not already present.
     *
     * @param worker the worker to add (must not be {@code null})
     */
    public void addWorker(Worker worker) {
        Objects.requireNonNull(worker, "Worker must not be null");
        if (!workers.contains(worker)) workers.add(worker);
    }

    /**
     * Removes a {@link Worker} from the aggregated suggestion list.
     *
     * @param worker the worker to remove
     * @return {@code true} if the worker was present and removed
     */
    public boolean removeWorker(Worker worker) { return workers.remove(worker); }

    /**
     * Adds a {@link Material} to the aggregated suggestion list if not already present.
     *
     * @param material the material to add (must not be {@code null})
     */
    public void addMaterial(Material material) {
        Objects.requireNonNull(material, "Material must not be null");
        if (!materials.contains(material)) materials.add(material);
    }

    /**
     * Removes a {@link Material} from the aggregated suggestion list.
     */
    public boolean removeMaterial(Material material) { return materials.remove(material); }

    /**
     * Adds a {@link HardwareShop} to the aggregated suggestion list if not already present.
     *
     * @param shop the shop to add (must not be {@code null})
     */
    public void addShop(HardwareShop shop) {
        Objects.requireNonNull(shop, "HardwareShop must not be null");
        if (!shops.contains(shop)) shops.add(shop);
    }

    /**
     * Removes a {@link HardwareShop} from the aggregated suggestion list.
     */
    public boolean removeShop(HardwareShop shop) { return shops.remove(shop); }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int          getPackageId()                              { return packageId; }
    public void         setPackageId(int packageId)                 { this.packageId = packageId; }

    public String       getPackageName()                            { return packageName; }
    public void         setPackageName(String packageName)          { this.packageName = packageName; }

    public BigDecimal   getEstimatedBudget()                        { return estimatedBudget; }
    public void         setEstimatedBudget(BigDecimal estimatedBudget) { this.estimatedBudget = estimatedBudget; }

    public String       getDescription()                            { return description; }
    public void         setDescription(String description)          { this.description = description; }

    /** Returns an unmodifiable view of the aggregated workers list. */
    public List<Worker>       getWorkers()   { return Collections.unmodifiableList(workers); }
    public void               setWorkers(List<Worker> workers) {
        this.workers = (workers != null) ? new ArrayList<>(workers) : new ArrayList<>();
    }

    /** Returns an unmodifiable view of the aggregated materials list. */
    public List<Material>     getMaterials() { return Collections.unmodifiableList(materials); }
    public void               setMaterials(List<Material> materials) {
        this.materials = (materials != null) ? new ArrayList<>(materials) : new ArrayList<>();
    }

    /** Returns an unmodifiable view of the aggregated shops list. */
    public List<HardwareShop> getShops()     { return Collections.unmodifiableList(shops); }
    public void               setShops(List<HardwareShop> shops) {
        this.shops = (shops != null) ? new ArrayList<>(shops) : new ArrayList<>();
    }

    // =========================================================
    // equals / hashCode ΓÇö identity by packageId
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ConstructionPackage other)) return false;
        return packageId == other.packageId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(packageId);
    }

    @Override
    public String toString() {
        return "ConstructionPackage{packageId=" + packageId
                + ", packageName='" + packageName + '\''
                + ", estimatedBudget=" + estimatedBudget
                + '}';
    }
}
