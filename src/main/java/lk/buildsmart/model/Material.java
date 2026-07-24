package lk.buildsmart.model;

import java.util.Objects;

/**
 * Material ΓÇö a single entry in the admin-managed master list of
 * construction materials.
 *
 * <p>This is a lightweight value object. It does not extend {@link User}
 * and holds no mutable relationships. All fields are {@code private}
 * (Encapsulation) with standard getters/setters.</p>
 *
 * <p>Maps to the {@code materials} table.</p>
 */
public class Material {

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** PK: {@code materials.material_id} */
    private int    materialId;

    /** Display name: {@code materials.material_name} */
    private String materialName;

    /**
     * Grouping category: {@code materials.category}
     * (e.g. {@code "Structural"}, {@code "Finishing"}, {@code "Plumbing"}).
     */
    private String category;

    /**
     * Unit of measure: {@code materials.unit}
     * (e.g. {@code "Bag"}, {@code "Kg"}, {@code "Piece"}, {@code "Litre"}).
     */
    private String unit;

    // =========================================================
    // Constructors
    // =========================================================

    /** No-arg constructor ΓÇö used by the DAO and JSP frameworks. */
    public Material() {}

    /**
     * Full constructor ΓÇö used when loading a row from the {@code materials} table.
     *
     * @param materialId   PK
     * @param materialName display name (must not be {@code null})
     * @param category     grouping category (nullable)
     * @param unit         unit of measure (nullable)
     */
    public Material(int materialId, String materialName, String category, String unit) {
        this.materialId   = materialId;
        this.materialName = Objects.requireNonNull(materialName, "materialName must not be null");
        this.category     = category;
        this.unit         = unit;
    }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int    getMaterialId()                       { return materialId; }
    public void   setMaterialId(int materialId)         { this.materialId = materialId; }

    public String getMaterialName()                     { return materialName; }
    public void   setMaterialName(String materialName)  { this.materialName = materialName; }

    public String getCategory()                         { return category; }
    public void   setCategory(String category)          { this.category = category; }

    public String getUnit()                             { return unit; }
    public void   setUnit(String unit)                  { this.unit = unit; }

    // =========================================================
    // equals / hashCode ΓÇö identity by materialId
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Material other)) return false;
        return materialId == other.materialId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(materialId);
    }

    @Override
    public String toString() {
        return "Material{materialId=" + materialId
                + ", materialName='" + materialName + '\''
                + ", category='" + category + '\''
                + ", unit='" + unit + '\''
                + '}';
    }
}
