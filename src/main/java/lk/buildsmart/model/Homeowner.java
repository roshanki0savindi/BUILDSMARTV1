package lk.buildsmart.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Homeowner ΓÇö a registered homeowner who can search for workers,
 * browse hardware shops, view construction packages, and submit reviews.
 *
 * <p><b>OOP ΓÇö Inheritance</b>: extends {@link User};
 * the role is fixed to {@code "homeowner"} in the constructor call.</p>
 *
 * <p><b>OOP ΓÇö Association</b>: a Homeowner can submit many {@link Review}s,
 * but those reviews also exist independently in the database (they belong
 * to the {@code reviews} table, not to this object).
 * The list is an in-memory association ΓÇö populated on demand by the DAO ΓÇö
 * not a composition (reviews are not deleted simply because the homeowner
 * object is garbage-collected).</p>
 *
 * <p>Maps to the {@code users} table filtered by {@code role = 'homeowner'}.</p>
 */
public class Homeowner extends User {

    // =========================================================
    // Association ΓÇö reviews written by this homeowner
    // =========================================================

    /**
     * <b>Association</b>: the list of {@link Review}s this homeowner has submitted.
     * A review exists independently (in the DB it references the homeowner's
     * {@code user_id}; the homeowner is not the owner in the Composition sense).
     *
     * <p>Loaded on demand by {@code ReviewDAO.findByUserId(userId)}.</p>
     */
    private List<Review> reviews = new ArrayList<>();

    // =========================================================
    // Constructors
    // =========================================================

    /**
     * No-arg constructor ΓÇö used by the DAO during reflective mapping.
     */
    public Homeowner() {
        super();
    }

    /**
     * Full constructor ΓÇö used when loading a homeowner row from the database.
     *
     * @param userId    PK from {@code users}
     * @param fullName  display name
     * @param email     login email
     * @param password  BCrypt hash (never plain text)
     * @param phone     contact number (may be {@code null})
     * @param status    account status ({@code "active"}, {@code "pending"}, {@code "rejected"})
     * @param createdAt registration timestamp
     */
    public Homeowner(int userId, String fullName, String email, String password,
                     String phone, String status, LocalDateTime createdAt) {
        super(userId, fullName, email, password, phone, "homeowner", status, createdAt);
    }

    // =========================================================
    // Abstraction / Polymorphism ΓÇö override showDashboard()
    // =========================================================

    /**
     * {@inheritDoc}
     * Homeowners are redirected to {@code /homeowner/dashboard} after login.
     */
    @Override
    public String showDashboard() {
        return "/homeowner/dashboard";
    }

    // =========================================================
    // Association helpers ΓÇö reviews
    // =========================================================

    /**
     * Adds a {@link Review} to this homeowner's association list.
     * Duplicate review IDs are ignored.
     *
     * @param review the review to associate (must not be {@code null})
     */
    public void addReview(Review review) {
        Objects.requireNonNull(review, "Review must not be null");
        if (!reviews.contains(review)) {
            reviews.add(review);
        }
    }

    /**
     * Returns an <em>unmodifiable view</em> of the reviews associated
     * with this homeowner. Use {@link #setReviews(List)} to replace the list.
     */
    public List<Review> getReviews() {
        return Collections.unmodifiableList(reviews);
    }

    /**
     * Replaces the entire review list (typically called by the DAO
     * after {@code ReviewDAO.findByUserId(userId)}).
     * A defensive copy is stored internally.
     *
     * @param reviews the new list (may be {@code null}, treated as empty)
     */
    public void setReviews(List<Review> reviews) {
        this.reviews = (reviews != null)
                ? new ArrayList<>(reviews)
                : new ArrayList<>();
    }
}
