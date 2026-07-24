<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Sidebar -->
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-body text-center p-4">
                <div class="avatar-fallback rounded-circle mx-auto mb-3 shadow-sm" style="width:72px; height:72px; font-size:1.75rem;">
                    <i class="fa-solid fa-user"></i>
                </div>
                <h5 class="fw-bold font-heading mb-1 text-navy-900">${sessionScope.loggedInUser.fullName}</h5>
                <p class="text-slate-500 small mb-2">${sessionScope.loggedInUser.email}</p>
                <span class="badge badge-emerald px-3 py-1 fw-semibold">Verified Homeowner</span>
            </div>
            
            <div class="list-group list-group-flush border-top p-2 gap-1">
                <a href="#section-overview" id="nav-overview" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold" onclick="showSection('overview')">
                    <i class="fa-solid fa-chart-pie me-2 text-primary"></i> Dashboard Overview
                </a>
                <a href="#section-profile" id="nav-profile" class="list-group-item list-group-item-action rounded-3 border-0 fw-semibold" onclick="showSection('profile')">
                    <i class="fa-solid fa-user-pen me-2 text-primary"></i> Edit Profile
                </a>
                <a href="#section-password" id="nav-password" class="list-group-item list-group-item-action rounded-3 border-0 fw-semibold" onclick="showSection('password')">
                    <i class="fa-solid fa-lock me-2 text-primary"></i> Change Password
                </a>
                <a href="#section-reviews" id="nav-reviews" class="list-group-item list-group-item-action rounded-3 border-0 fw-semibold" onclick="showSection('reviews')">
                    <i class="fa-solid fa-star me-2 text-primary"></i> My Submitted Reviews
                </a>
                <hr class="my-2">
                <a href="${pageContext.request.contextPath}/workers" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700">
                    <i class="fa-solid fa-users me-2"></i> Find Workers
                </a>
                <a href="${pageContext.request.contextPath}/hardware-shops" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700">
                    <i class="fa-solid fa-store me-2"></i> Hardware Shops
                </a>
                <a href="${pageContext.request.contextPath}/packages" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700">
                    <i class="fa-solid fa-cubes me-2"></i> Packages
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="col-lg-9">

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 py-2.5 px-3 mb-4">
                <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 py-2.5 px-3 mb-4">
                <i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>

        <!-- ===== OVERVIEW ===== -->
        <div id="section-overview" class="dashboard-section">
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-4 p-md-5">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="bg-primary-light text-primary rounded-circle p-3 d-inline-flex align-items-center justify-content-center" style="width:52px; height:52px;">
                            <i class="fa-solid fa-house-chimney fa-xl"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold font-heading mb-0 text-navy-900">Welcome Back, ${sessionScope.loggedInUser.fullName}!</h3>
                            <p class="text-slate-500 mb-0 small">Manage your profile, view submitted feedback, or explore Sri Lanka's top construction resources.</p>
                        </div>
                    </div>

                    <div class="row g-4 mt-2">
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/workers" class="text-decoration-none">
                                <div class="card border-0 card-hover bg-slate-900 text-white p-4 rounded-4 h-100">
                                    <i class="fa-solid fa-users fa-2x text-primary mb-3"></i>
                                    <h5 class="fw-bold text-white mb-1 font-heading">Find Skilled Workers</h5>
                                    <p class="text-slate-400 small mb-0">Browse carpenters, masons, electricians by district & rate.</p>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/hardware-shops" class="text-decoration-none">
                                <div class="card border-0 card-hover bg-slate-900 text-white p-4 rounded-4 h-100">
                                    <i class="fa-solid fa-store fa-2x text-primary mb-3"></i>
                                    <h5 class="fw-bold text-white mb-1 font-heading">Explore Hardware Stores</h5>
                                    <p class="text-slate-400 small mb-0">Compare cement, steel, and tool prices across Sri Lanka.</p>
                                </div>
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/packages" class="text-decoration-none">
                                <div class="card border-0 card-hover bg-slate-900 text-white p-4 rounded-4 h-100">
                                    <i class="fa-solid fa-cubes fa-2x text-primary mb-3"></i>
                                    <h5 class="fw-bold text-white mb-1 font-heading">Building Packages</h5>
                                    <p class="text-slate-400 small mb-0">Explore pre-configured labor and hardware bundles.</p>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ===== EDIT PROFILE ===== -->
        <div id="section-profile" class="dashboard-section d-none">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">
                    <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-4"><i class="fa-solid fa-user-pen text-primary me-2"></i> Edit Account Details</h4>
                    <form method="post" action="${pageContext.request.contextPath}/homeowner/dashboard">
                        <input type="hidden" name="action" value="update_profile">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-slate-700">Full Name</label>
                            <input type="text" name="fullName" class="form-control"
                                   value="${sessionScope.loggedInUser.fullName}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-slate-700">Phone Number</label>
                            <input type="text" name="phone" class="form-control"
                                   value="${sessionScope.loggedInUser.phone}">
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-slate-400">Email Address (Immutable)</label>
                            <input type="email" class="form-control bg-light text-muted"
                                   value="${sessionScope.loggedInUser.email}" disabled>
                        </div>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Save Changes
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- ===== CHANGE PASSWORD ===== -->
        <div id="section-password" class="dashboard-section d-none">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">
                    <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-4"><i class="fa-solid fa-lock text-primary me-2"></i> Change Password</h4>
                    <form method="post" action="${pageContext.request.contextPath}/homeowner/dashboard">
                        <input type="hidden" name="action" value="change_password">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-slate-700">Current Password</label>
                            <input type="password" name="currentPassword" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-slate-700">New Password</label>
                            <input type="password" name="newPassword" class="form-control" minlength="6" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-slate-700">Confirm New Password</label>
                            <input type="password" name="confirmPassword" class="form-control" minlength="6" required>
                        </div>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm">
                            <i class="fa-solid fa-key me-1"></i> Update Password
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- ===== MY REVIEWS ===== -->
        <div id="section-reviews" class="dashboard-section d-none">
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">
                    <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-4"><i class="fa-solid fa-star text-warning me-2"></i> My Submitted Reviews</h4>
                    <c:choose>
                        <c:when test="${not empty myReviews}">
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="review" items="${myReviews}">
                                    <div class="review-card">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h6 class="mb-0 text-navy-900 fw-bold">
                                                <c:choose>
                                                    <c:when test="${review.targetType == 'worker'}">
                                                        <span class="badge badge-amber me-2"><i class="fa-solid fa-hard-hat"></i> Worker Review</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-slate me-2"><i class="fa-solid fa-store"></i> Hardware Shop Review</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </h6>
                                            <small class="text-muted"><i class="fa-regular fa-clock me-1"></i> ${review.reviewDate}</small>
                                        </div>
                                        <p class="text-slate-700 mb-2">${review.comment}</p>
                                        <div>
                                            <c:forEach begin="1" end="${review.rating}"><i class="fa-solid fa-star text-warning" style="font-size:0.85rem;"></i></c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:0.85rem;"></i></c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-5 text-center bg-slate-50 rounded-4">
                                <i class="fa-regular fa-comment-dots fa-3x text-slate-300 mb-3"></i>
                                <h5 class="fw-bold text-navy-900">No reviews published yet</h5>
                                <p class="text-muted small mb-0">Visit worker or hardware store profiles to leave ratings and feedback.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function showSection(name) {
    document.querySelectorAll('.dashboard-section').forEach(el => el.classList.add('d-none'));
    const targetSection = document.getElementById('section-' + name);
    if (targetSection) targetSection.classList.remove('d-none');
    
    document.querySelectorAll('.list-group-item-action').forEach(el => el.classList.remove('active', 'bg-primary', 'text-white'));
    const navItem = document.getElementById('nav-' + name);
    if (navItem) navItem.classList.add('active');
    
    history.replaceState(null, '', '#section-' + name);
    return false;
}

// Auto-open section from URL hash or default to overview
window.addEventListener('DOMContentLoaded', function() {
    const hash = window.location.hash;
    if (hash === '#section-profile') showSection('profile');
    else if (hash === '#section-password') showSection('password');
    else if (hash === '#section-reviews') showSection('reviews');
    else showSection('overview');
});
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
