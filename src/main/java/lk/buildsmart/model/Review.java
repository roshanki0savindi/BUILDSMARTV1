package lk.buildsmart.model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Review ΓÇö a homeowner's rating and comment for a {@link Worker}
 * or a {@link HardwareShop}.
 *
 * <p><b>OOP ΓÇö Association</b>: a {@link Homeowner} <em>writes</em> many reviews,
 * but the homeowner exists independently of the review
 * (the homeowner is not deleted when the review is deleted).
 * The relationship is expressed via the {@code user_id} FK in the
 * {@code reviews} table.</p>
 *
 * <p>The {@code targetType} + {@code targetId} pair implements a
 * <em>polymorphic association</em>: a review can target either a worker
 * ({@code targetType = "worker"}) or a hardware shop
 * ({@code targetType = "hardware_shop"}).</p>
 *
 * <p>Maps to the {@code reviews} table.</p>
 */
public class Review {

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** PK: {@code reviews.review_id} */
    private int           reviewId;

    /**
     * FK to the homeowner who wrote this review: {@code reviews.user_id}.
     * References {@code users.user_id}.
     */
    private int           userId;

    /**
     * Discriminator for the review target: {@code reviews.target_type}.
     * Valid values: {@code "worker"} | {@code "hardware_shop"}
     */
    private String        targetType;

    /**
     * PK of the reviewed entity: {@code reviews.target_id}.
     * Refers to {@code workers.worker_id} when {@code targetType = "worker"}, or
     * {@code hardware_shops.shop_id} when {@code targetType = "hardware_shop"}.
     */
    private int           targetId;

    /**
     * Star rating: {@code reviews.rating}.
     * Constrained to 1ΓÇô5 (enforced by a DB CHECK constraint).
     */
    private int           rating;

    /** Free-text comment: {@code reviews.comment} (nullable) */
    private String        comment;

    /** Optional review photo binary: {@code reviews.photo} (MEDIUMBLOB, null = no photo) */
    private byte[]        photo;

    /** MIME type of the review photo: {@code reviews.photo_mime} (e.g. image/jpeg) */
    private String        photoType;

    public static final int PENDING  = 0;
    public static final int APPROVED = 1;
    public static final int REJECTED = 2;

    /** Moderation status: 0=PENDING, 1=APPROVED, 2=REJECTED */
    private int           status = PENDING;

    /** Submission timestamp: {@code reviews.review_date} */
    private LocalDateTime reviewDate;

    // ----- Convenience fields populated by JOIN queries -----

    /**
     * Full name of the homeowner who submitted the review.
     * Populated from {@code users.full_name} via a JOIN.
     */
    private String        reviewerName;

    /**
     * Display name of the reviewed entity.
     * Populated from {@code users.full_name} (for workers) or
     * {@code hardware_shops.shop_name} (for shops) via a JOIN.
     */
    private String        targetName;

    /**
     * Profile photo of the reviewed entity (worker photo or shop logo).
     * Populated by the DAO via a JOIN.
     */
    private String        targetPhoto;

    // =========================================================
    // Constructors
    // =========================================================

    /** No-arg constructor ΓÇö used by the DAO when mapping a ResultSet. */
    public Review() {}

    /**
     * Constructor for creating a new review before persisting.
     *
     * @param userId     FK to the submitting homeowner
     * @param targetType {@code "worker"} or {@code "hardware_shop"}
     * @param targetId   PK of the reviewed entity
     * @param rating     star rating (1ΓÇô5)
     * @param comment    review text (may be {@code null})
     * @param photo      photo filename (may be {@code null})
     */
    public Review(int userId, String targetType, int targetId,
                  int rating, String comment, byte[] photo, String photoType) {
        this.userId     = userId;
        this.targetType = targetType;
        this.targetId   = targetId;
        this.rating     = rating;
        this.comment    = comment;
        this.photo      = photo;
        this.photoType  = photoType;
    }

    // =========================================================
    // Convenience helpers
    // =========================================================

    /**
     * Returns {@code true} if this review targets a worker.
     */
    public boolean isForWorker() {
        return "worker".equalsIgnoreCase(targetType);
    }

    /**
     * Returns {@code true} if this review targets a hardware shop.
     */
    public boolean isForShop() {
        return "hardware_shop".equalsIgnoreCase(targetType);
    }

    /**
     * Validates that the rating is in the allowed range (1ΓÇô5).
     *
     * @throws IllegalArgumentException if rating is out of range
     */
    public void validateRating() {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException(
                    "Rating must be between 1 and 5, got: " + rating);
        }
    }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int           getReviewId()                          { return reviewId; }
    public void          setReviewId(int reviewId)              { this.reviewId = reviewId; }

    public int           getUserId()                            { return userId; }
    public void          setUserId(int userId)                  { this.userId = userId; }

    public String        getTargetType()                        { return targetType; }
    public void          setTargetType(String targetType)       { this.targetType = targetType; }

    public int           getTargetId()                          { return targetId; }
    public void          setTargetId(int targetId)              { this.targetId = targetId; }

    public int           getRating()                            { return rating; }
    public void          setRating(int rating)                  { this.rating = rating; }

    public String        getComment()                           { return comment; }
    public void          setComment(String comment)             { this.comment = comment; }

    public byte[]        getPhoto()                              { return photo; }
    public void          setPhoto(byte[] photo)                  { this.photo = photo; }

    public String        getPhotoType()                          { return photoType; }
    public void          setPhotoType(String photoType)          { this.photoType = photoType; }

    /** Returns {@code true} if a review photo has been attached. */
    public boolean       hasPhoto()                              { return photo != null && photo.length > 0; }
    public boolean       isHasPhoto()                            { return hasPhoto(); }

    public int           getStatus()                            { return status; }
    public void          setStatus(int status)                  { this.status = status; }

    public LocalDateTime getReviewDate()                        { return reviewDate; }
    public void          setReviewDate(LocalDateTime reviewDate){ this.reviewDate = reviewDate; }

    public String        getReviewerName()                      { return reviewerName; }
    public void          setReviewerName(String reviewerName)   { this.reviewerName = reviewerName; }

    public String        getTargetName()                        { return targetName; }
    public void          setTargetName(String targetName)       { this.targetName = targetName; }

    public String        getTargetPhoto()                       { return targetPhoto; }
    public void          setTargetPhoto(String targetPhoto)     { this.targetPhoto = targetPhoto; }

    // =========================================================
    // equals / hashCode ΓÇö identity by reviewId
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Review other)) return false;
        return reviewId == other.reviewId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(reviewId);
    }

    @Override
    public String toString() {
        return "Review{reviewId=" + reviewId
                + ", userId=" + userId
                + ", targetType='" + targetType + '\''
                + ", targetId=" + targetId
                + ", rating=" + rating
                + '}';
    }
}
