<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:useBean id="worker" type="lk.buildsmart.model.Worker" scope="request" />
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Worker Profile Sidebar -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 text-center p-4">
            <div class="position-relative d-inline-block mx-auto mb-3">
                <c:choose>
                    <c:when test="${not empty worker.profilePhoto}">
                        <img src="${pageContext.request.contextPath}/img?type=worker&id=${worker.workerId}"
                             class="rounded-circle object-fit-cover shadow-md border border-4 border-white"
                             style="width:140px; height:140px;" alt="${worker.fullName}">
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-circle bg-primary-light text-primary d-inline-flex align-items-center justify-content-center shadow-sm" style="width:140px; height:140px; font-size:3.5rem;">
                            <i class="fa-solid fa-user-gear"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <h3 class="fw-bold font-heading mb-1">${worker.fullName}</h3>
            <div class="badge badge-amber fs-6 px-3 py-1.5 align-self-center mb-3">${worker.profession}</div>

            <div class="bg-light rounded-3 p-3 text-start mb-3">
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-briefcase text-primary me-2"></i>Experience</span>
                    <span class="fw-semibold">${worker.experience} Years</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-money-bill-wave text-success me-2"></i>Daily Rate</span>
                    <span class="fw-semibold text-success fs-6">Rs. ${worker.dailyRate}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-location-dot text-danger me-2"></i>District</span>
                    <span class="fw-semibold">${worker.district}</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted"><i class="fa-solid fa-phone text-info me-2"></i>Contact</span>
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <span class="fw-semibold text-dark">${worker.phone}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold small">Login to view</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:if test="${not empty worker.skills}">
                <div class="text-start mb-3">
                    <label class="fw-bold small text-slate-700 mb-1 d-block">Specialized Skills:</label>
                    <div class="d-flex flex-wrap gap-1">
                        <c:forEach var="skill" items="${worker.skills.split(',')}">
                            <span class="badge badge-slate px-2.5 py-1">${skill.trim()}</span>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.loggedInUser}">
                <a href="tel:${worker.phone}" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm mt-2">
                    <i class="fa-solid fa-phone me-2"></i> Contact Worker Directly
                </a>
            </c:if>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="col-lg-8">
        <!-- About Section -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4">
                <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-user-circle text-primary"></i> About Professional
                </h4>
                <p class="text-slate-700 mb-0" style="line-height: 1.7;">
                    ${not empty worker.about ? worker.about : "No detailed bio provided yet."}
                </p>
            </div>
        </div>

        <!-- Read-only Availability Calendar -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4" id="profile_cal">
                <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-3">
                    <h4 class="fw-bold font-heading text-navy-900 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-regular fa-calendar-check text-primary"></i> Live Availability Calendar
                    </h4>
                </div>

                <div class="cal-nav">
                    <button class="btn btn-sm btn-outline-secondary rounded-circle px-2" onclick="profile_cal_prev()" aria-label="Previous Month">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <h6 id="profile_cal-header" class="fw-bold mb-0">Loading…</h6>
                    <button class="btn btn-sm btn-outline-secondary rounded-circle px-2" onclick="profile_cal_next()" aria-label="Next Month">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>

                <div id="profile_cal-grid"></div>

                <div class="cal-legend">
                    <span><span class="swatch swatch-avail"></span> Available</span>
                    <span><span class="swatch swatch-unavail"></span> Booked / Unavailable</span>
                    <span><span class="swatch swatch-past"></span> Past Date</span>
                </div>
            </div>
        </div>

        <!-- Reviews Section -->
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-comments text-primary"></i> Verified Client Reviews
                </h4>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger rounded-3 py-2 px-3 mb-3">${param.error}</div>
                </c:if>
                <c:if test="${param.msg == 'review_added'}">
                    <div class="alert alert-success rounded-3 py-2 px-3 mb-3">Thank you! Your review has been submitted.</div>
                </c:if>

                <c:if test="${sessionScope.loggedInUser.role == 'homeowner'}">
                    <form action="${pageContext.request.contextPath}/worker/profile" method="post"
                          enctype="multipart/form-data"
                          class="mb-4 bg-slate-50 p-4 rounded-4 border">
                        <input type="hidden" name="targetId" value="${worker.workerId}">
                        <h6 class="fw-bold mb-3 text-navy-900"><i class="fa-solid fa-star text-primary me-2"></i> Leave a Review for ${worker.fullName}</h6>
                        <div class="row align-items-center g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-slate-700 d-block mb-1">Star Rating</label>
                                <div class="interactive-star-rating" role="radiogroup" aria-label="Select Rating">
                                    <input type="hidden" name="rating" value="5">
                                    <c:forEach var="starVal" begin="1" end="5">
                                        <div class="d-inline-block position-relative me-1">
                                            <input type="radio" class="btn-check" name="rating_radio" id="worker-star-${starVal}" value="${starVal}" ${starVal == 5 ? 'checked' : ''}>
                                            <label for="worker-star-${starVal}" class="star-select mb-0" data-rating="${starVal}" title="${starVal} Star${starVal > 1 ? 's' : ''}" aria-label="${starVal} Star${starVal > 1 ? 's' : ''}">
                                                <i class="fa-solid fa-star text-warning"></i>
                                            </label>
                                        </div>
                                    </c:forEach>
                                    <span class="ms-2 fw-semibold text-slate-500 small rating-label">5 / 5 Stars</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-slate-700 mb-1">Optional Photo Attachment</label>
                                <input type="file" name="review_photo" class="form-control form-control-sm" accept="image/*">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-slate-700">Write Your Feedback</label>
                            <textarea name="comment" class="form-control" rows="3" placeholder="Describe the quality of work, punctuality, and professionalism..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                            <i class="fa-solid fa-paper-plane me-1"></i> Submit Review
                        </button>
                    </form>
                </c:if>

                <div class="d-flex flex-column gap-3">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-fallback rounded-circle" style="width:36px; height:36px; font-size:0.9rem;">
                                        ${not empty review.reviewerName ? review.reviewerName.substring(0,1) : 'A'}
                                    </div>
                                    <strong class="text-navy-900">${not empty review.reviewerName ? review.reviewerName : 'Anonymous Client'}</strong>
                                </div>
                                <div>
                                    <c:forEach begin="1" end="${review.rating}">
                                        <i class="fa-solid fa-star text-warning" style="font-size:0.85rem;"></i>
                                    </c:forEach>
                                    <c:forEach begin="${review.rating + 1}" end="5">
                                        <i class="fa-regular fa-star text-slate-300" style="font-size:0.85rem;"></i>
                                    </c:forEach>
                                </div>
                            </div>
                            <p class="text-slate-700 mb-2">${review.comment}</p>
                            <c:if test="${not empty review.photo}">
                                <img src="${pageContext.request.contextPath}/img?type=review&id=${review.reviewId}"
                                     alt="Review photo" class="img-thumbnail rounded-3 mt-1 mb-2" style="max-height:160px;">
                            </c:if>
                            <div class="text-muted extra-small" style="font-size:0.78rem;">
                                <i class="fa-regular fa-clock me-1"></i> Posted on ${review.reviewDate}
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty reviews}">
                        <div class="p-4 text-center text-muted bg-slate-50 rounded-4">
                            <i class="fa-regular fa-comments fa-2x mb-2 text-slate-300"></i>
                            <p class="mb-0">No reviews published yet for this worker profile.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- calendar.js + initialisation -->
<script src="${pageContext.request.contextPath}/js/calendar.js"></script>
<script>
    CalendarWidget.initPublic(
        'profile_cal',
        '${worker.workerId}',
        '${pageContext.request.contextPath}'
    );
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
