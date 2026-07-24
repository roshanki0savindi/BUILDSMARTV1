package lk.buildsmart.model;

import java.time.LocalDate;
import java.util.Objects;

/**
 * WorkerAvailability ΓÇö a single <em>unavailable</em> date for a {@link Worker}.
 *
 * <p><b>OOP ΓÇö Composition</b>: a {@code WorkerAvailability} entry
 * <em>cannot exist</em> without its owning worker. When a worker is deleted
 * the database cascades and removes all their availability rows
 * ({@code ON DELETE CASCADE} on the FK). In Java, the list of these
 * objects lives inside {@link Worker#getAvailabilityList()}.</p>
 *
 * <p>Maps to the {@code worker_availability} table
 * (DB: {@code availability_id}, {@code worker_id}, {@code unavailable_date}).</p>
 *
 * <p><b>Design note</b>: only <em>unavailable</em> dates are stored.
 * Any date not present in the list is implicitly available.</p>
 */
public class WorkerAvailability {

    // =========================================================
    // Encapsulation ΓÇö all fields private
    // =========================================================

    /** PK: {@code worker_availability.availability_id} */
    private int       availabilityId;

    /**
     * FK back to the owning worker: {@code worker_availability.worker_id}.
     * Mirrors the parent {@link Worker#getWorkerId()}.
     */
    private int       workerId;

    /** The date on which the worker is NOT available: {@code worker_availability.unavailable_date} */
    private LocalDate unavailableDate;

    // =========================================================
    // Constructors
    // =========================================================

    /** No-arg constructor ΓÇö used by the DAO when mapping a ResultSet. */
    public WorkerAvailability() {}

    /**
     * Convenience constructor for creating a new availability entry before persisting.
     *
     * @param workerId        FK to the owning worker
     * @param unavailableDate the date the worker is not available
     */
    public WorkerAvailability(int workerId, LocalDate unavailableDate) {
        this.workerId        = workerId;
        this.unavailableDate = unavailableDate;
    }

    /**
     * Full constructor ΓÇö used when loading from the database (all columns present).
     *
     * @param availabilityId  PK from the {@code worker_availability} table
     * @param workerId        FK to the owning worker
     * @param unavailableDate the date the worker is not available
     */
    public WorkerAvailability(int availabilityId, int workerId, LocalDate unavailableDate) {
        this.availabilityId  = availabilityId;
        this.workerId        = workerId;
        this.unavailableDate = unavailableDate;
    }

    // =========================================================
    // Getters and Setters (Encapsulation)
    // =========================================================

    public int       getAvailabilityId()                          { return availabilityId; }
    public void      setAvailabilityId(int availabilityId)         { this.availabilityId = availabilityId; }

    public int       getWorkerId()                                { return workerId; }
    public void      setWorkerId(int workerId)                     { this.workerId = workerId; }

    public LocalDate getUnavailableDate()                         { return unavailableDate; }
    public void      setUnavailableDate(LocalDate unavailableDate) { this.unavailableDate = unavailableDate; }

    // =========================================================
    // equals / hashCode ΓÇö uniqueness is (workerId, unavailableDate)
    // mirrors the DB UNIQUE KEY uq_worker_date
    // =========================================================

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof WorkerAvailability other)) return false;
        return workerId == other.workerId
                && Objects.equals(unavailableDate, other.unavailableDate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(workerId, unavailableDate);
    }

    @Override
    public String toString() {
        return "WorkerAvailability{workerId=" + workerId
                + ", unavailableDate=" + unavailableDate + '}';
    }
}
