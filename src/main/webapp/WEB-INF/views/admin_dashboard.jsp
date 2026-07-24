<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Admin Sidebar -->
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-navy text-white p-3 border-0" style="background: var(--navy-900);">
                <h6 class="fw-bold font-heading text-white mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-shield-halved text-primary"></i> Admin Control Panel
                </h6>
            </div>
            <div class="list-group list-group-flush p-2 gap-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
                    <i class="fa-solid fa-chart-pie me-2 text-primary"></i> Platform Analytics
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-users-gear me-2 text-primary"></i> User Management
                </a>
                <a href="${pageContext.request.contextPath}/admin/materials" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-boxes-packing me-2 text-primary"></i> Master Materials
                </a>
                <a href="${pageContext.request.contextPath}/admin/packages" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-cubes me-2 text-primary"></i> Package Bundles
                </a>
                <a href="${pageContext.request.contextPath}/admin/reviews" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-comment-slash me-2 text-primary"></i> Moderation Queue
                </a>
            </div>
        </div>
    </div>

    <!-- Admin Main Content -->
    <div class="col-lg-9">
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4 p-md-5">
                <div class="d-flex align-items-center gap-3 mb-2">
                    <div class="bg-primary-light text-primary rounded-circle p-3 d-inline-flex align-items-center justify-content-center" style="width:52px; height:52px;">
                        <i class="fa-solid fa-gauge-high fa-xl"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold font-heading mb-0 text-navy-900">Administrator Console</h3>
                        <p class="text-slate-500 mb-0 small">Welcome back, ${sessionScope.loggedInUser.fullName}. System overview & platform metrics</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- KPI Metrics -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-slate-500 small font-heading fw-semibold">Verified Workers</div>
                            <div class="fs-2 fw-bold text-success font-heading">${verifiedWorkersCount}</div>
                        </div>
                        <div class="kpi-icon-box bg-success-light text-success">
                            <i class="fa-solid fa-user-check"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-slate-500 small font-heading fw-semibold">Verified Hardware Stores</div>
                            <div class="fs-2 fw-bold text-primary font-heading">${verifiedShopsCount}</div>
                        </div>
                        <div class="kpi-icon-box bg-primary-light text-primary">
                            <i class="fa-solid fa-store"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-slate-500 small font-heading fw-semibold">Pending Approvals</div>
                            <div class="fs-2 fw-bold text-amber font-heading" style="color:var(--primary);">${pendingUsersCount}</div>
                        </div>
                        <div class="kpi-icon-box bg-primary-light text-primary">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Access Management Cards -->
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card border-0 card-hover text-center p-4 h-100">
                    <div class="avatar-fallback rounded-circle mx-auto mb-3" style="width:60px; height:60px; font-size:1.5rem;">
                        <i class="fa-solid fa-users-gear text-primary"></i>
                    </div>
                    <h5 class="fw-bold font-heading mb-2">User Accounts</h5>
                    <p class="text-slate-500 small mb-3">Review worker & shop applications, toggle status, or manage accounts.</p>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary btn-sm w-100 rounded-pill mt-auto fw-semibold">Manage Users</a>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 card-hover text-center p-4 h-100">
                    <div class="avatar-fallback rounded-circle mx-auto mb-3" style="width:60px; height:60px; font-size:1.5rem;">
                        <i class="fa-solid fa-boxes-packing text-primary"></i>
                    </div>
                    <h5 class="fw-bold font-heading mb-2">Master Materials</h5>
                    <p class="text-slate-500 small mb-3">Add and maintain platform-wide material definitions and unit categories.</p>
                    <a href="${pageContext.request.contextPath}/admin/materials" class="btn btn-outline-primary btn-sm w-100 rounded-pill mt-auto fw-semibold">Manage Materials</a>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card border-0 card-hover text-center p-4 h-100">
                    <div class="avatar-fallback rounded-circle mx-auto mb-3" style="width:60px; height:60px; font-size:1.5rem;">
                        <i class="fa-solid fa-cubes text-primary"></i>
                    </div>
                    <h5 class="fw-bold font-heading mb-2">Package Tiers</h5>
                    <p class="text-slate-500 small mb-3">Assemble curated labor + material bundles for residential projects.</p>
                    <a href="${pageContext.request.contextPath}/admin/packages" class="btn btn-outline-primary btn-sm w-100 rounded-pill mt-auto fw-semibold">Manage Packages</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
