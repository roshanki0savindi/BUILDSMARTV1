package lk.buildsmart.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Worker ΓÇö a construction professional who can be hired by homeowners.
 *
 * <p><b>OOP ΓÇö Inheritance</b>: extends {@link User}; the {@code worker}
 * role is hardcoded in the superclass constructor call.</p>
 *
 * <p><b>OOP ΓÇö Composition</b>: a {@code Worker} <em>owns</em> its
 * {@link WorkerAvailability} list. The entries belong to and are deleted
 * with the worker ({@code ON DELETE CASCADE} in the DB). The list is
 * never {@code null} ΓÇö it defaults to an empty {@link ArrayList}.</p>
 *
 * <p>Maps to the {@code workers} table joined with {@code users}
 * (snake_case DB columns ΓåÆ camelCase Java fields).</p>
 */
public class Worker extends User {

    // =========================================================
    // Encapsulation ΓÇö worker-specific fields are private
    // =========================================================

    /** PK: {@code workers.worker_id} */
    private int           workerId;

    /** National ID card: {@code workers.nic} (nullable) */
    private String        nic;

    /** Trade / profession: {@code workers.profession} (nullable) */
    private String        profession;

    /** Years of experience: {@code workers.experience} */
    private int           experience;

    /** Comma-separated skill tags: {@code workers.skills} (nullable) */
    private String        skills;

    /** Daily charge rate: {@code workers.daily_rate} */
    private BigDecimal    dailyRate;

    /** Administrative district: {@code workers.district} (nullable) */
    private String        district;

    /** Profile photo binary: {@code workers.profile_photo} (MEDIUMBLOB, null = no photo) */
    private byte[]        profilePhoto;

    /** MIME type of the profile photo: {@code workers.photo_mime} (e.g. image/jpeg) */
    private String        profilePhotoType;

    /** Free-text bio: {@code workers.about} (nullable) */
    private String        about;

    /** Last-profile-update timestamp: {@code workers.last_updated} */
    private LocalDateTime lastUpdated;

    /**
     * <b>Composition</b> ΓÇö each entry is a date on which this worker
     * is <em>unavailable</em>. The list is initialised eagerly so callers
     * never receive {@code null}.
     *
     * <p>Loaded on demand by {@code WorkerDAO.findAvailability(workerId)}.</p>
     */
    private List<WorkerAvailability> availabilityList = new ArrayList<>();

    /** Computed field from JOIN ΓÇö average review rating (1.0ΓÇô5.0). */
    private double averageRating;

    /** Computed field from JOIN ΓÇö total number of reviews. */
    private int    reviewCount;

    // =========================================================
    // Constructors
    // =========================================================

    /**
     * No-arg constructor ΓÇö used by DAO reflective mapping.
     * Role is set by {@code setRole("worker")} after construction.
     */
    public Worker() {
        super();
    }

    /**
     * User-only constructor ΓÇö used in list views where the worker
     * profile columns have not been joined.
     */
    public Worker(int userId, String fullName, String email, String password,
                  String phone, String status, LocalDateTime createdAt) {
        super(userId, fullName, email, password, phone, "worker", status, createdAt);
    }

    /**
     * Full constructor ΓÇö used when loading the complete worker profile
     * from a JOIN of {@code users} and {@code workers}.
     */
    public Worker(int userId, String fullName, String email, String password,
                  String phone, String status, LocalDateTime createdAt,
                  int workerId, String nic, String profession,
                  int experience, String skills, BigDecimal dailyRate,
                  String district, byte[] profilePhoto, String profilePhotoType,
                  String about, LocalDateTime lastUpdated) {
        super(userId, fullName, email, password, phone, "worker", status, createdAt);
        this.workerId          = workerId;
        this.nic               = nic;
        this.profession        = profession;
        this.experience        = experience;
        this.skills            = skills;
        this.dailyRate         = dailyRate;
        this.district          = district;
        this.profilePhoto      = profilePhoto;
        this.profilePhotoType  = profilePhotoType;
        this.about             = about;
        this.lastUpdated       = lastUpdated;
    }

    // =========================================================
    // Abstraction / Polymorphism ΓÇö override showDashboard()
    // =========================================================

    /**
     * {@inheritDoc}
     * Workers are redirected to {@code /worker/dashboard} after login.
     */
    @Override
    public String showDashboard() {
        return "/worker/dashboard";
    }

    // =========================================================
    // Availability helpers (Composition)
    // =========================================================

    /**
     * Adds a single {@link WorkerAvailability} entry to the composition list.
     * Duplicate entries are ignored (matches DB unique constraint).
     *
     * @param entry the availability entry to add (must not be {@code null})
     */
    public void addAvailability(WorkerAvailability entry) {
        Objects.requireNonNull(entry, "WorkerAvailability entry must not be null");
        if (!availabilityList.contains(entry)) {
            availabilityList.add(entry);
        }
    }

    /**
     * Removes a {@link WorkerAvailability} entry from the composition list.
     *
     * @param entry the entry to remove
     * @return {@code true} if the entry was present and removed
     */
    public boolean removeAvailability(WorkerAvailability entry) {
        return availabilityList.remove(entry);
    }

    /**
     * Returns an <em>unmodifiable view</em> of the availability list.
     * Use {@link #setAvailabilityList(List)} or {@link #addAvailability(WorkerAvailability)}
     * to mutate the list.
     */
    public List<WorkerAvailability> getAvailabilityList() {
        return Collections.unmodifiableList(availabilityList);
    }

    /**
     * Replaces the entire availability list (used by the DAO after a bulk load).
     *
     * @param availabilityList the new list (a defensive copy is stored)
     */
    public void setAvailabilityList(List<WorkerAvailability> availabilityList) {
        this.availabilityList = (availabilityList != null)
                ? new ArrayList<>(availabilityList)
                : new ArrayList<>();
    }

    // =========================================================
    // Getters and Setters
    // =========================================================

    public int           getWorkerId()                              { return workerId; }
    public void          setWorkerId(int workerId)                  { this.workerId = workerId; }

    public String        getNic()                                   { return nic; }
    public void          setNic(String nic)                        { this.nic = nic; }

    public String        getProfession()                            { return profession; }
    public void          setProfession(String profession)           { this.profession = profession; }

    public int           getExperience()                            { return experience; }
    public void          setExperience(int experience)              { this.experience = experience; }

    public String        getSkills()                                { return skills; }
    public void          setSkills(String skills)                   { this.skills = skills; }

    public BigDecimal    getDailyRate()                             { return dailyRate; }
    public void          setDailyRate(BigDecimal dailyRate)         { this.dailyRate = dailyRate; }

    public String        getDistrict()                              { return district; }
    public void          setDistrict(String district)               { this.district = district; }

    public byte[]        getProfilePhoto()                               { return profilePhoto; }
    public void          setProfilePhoto(byte[] profilePhoto)             { this.profilePhoto = profilePhoto; }

    public String        getProfilePhotoType()                            { return profilePhotoType; }
    public void          setProfilePhotoType(String profilePhotoType)     { this.profilePhotoType = profilePhotoType; }

    /** Returns {@code true} if a profile photo has been uploaded. */
    public boolean       hasProfilePhoto()                                { return profilePhoto != null && profilePhoto.length > 0; }
    public boolean       isHasProfilePhoto()                              { return hasProfilePhoto(); }

    public String        getAbout()                                 { return about; }
    public void          setAbout(String about)                     { this.about = about; }

    public LocalDateTime getLastUpdated()                           { return lastUpdated; }
    public void          setLastUpdated(LocalDateTime lastUpdated)  { this.lastUpdated = lastUpdated; }

    public double        getAverageRating()                         { return averageRating; }
    public void          setAverageRating(double averageRating)     { this.averageRating = averageRating; }

    public int           getReviewCount()                           { return reviewCount; }
    public void          setReviewCount(int reviewCount)            { this.reviewCount = reviewCount; }
}
