<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 border-bottom pb-3">
    <div>
        <h2 class="fw-bold font-heading mb-1"><i class="fa-solid fa-cubes text-primary me-2"></i> Curated Building Packages</h2>
        <p class="text-slate-500 small mb-0">Pre-configured bundles pairing verified skilled labor with trusted hardware store suppliers</p>
    </div>
</div>

<c:choose>
    <c:when test="${empty packages}">
        <div class="p-5 text-center bg-white rounded-4 border">
            <i class="fa-solid fa-cubes fa-4x mb-3 text-slate-300"></i>
            <h4 class="fw-bold">No packages published yet</h4>
            <p class="text-muted small">Our administrative team is curating new construction package bundles. Check back soon!</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="row g-4 mb-5">
            <c:forEach var="pkg" items="${packages}" varStatus="loop">
                <div class="col-12">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <%-- Package Header --%>
                        <div class="card-header bg-navy text-white p-4 border-0" style="background: var(--navy-900);">
                            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                                <div>
                                    <span class="badge badge-amber px-3 py-1 mb-2 fw-semibold">Package Tier ${loop.count}</span>
                                    <h3 class="mb-0 fw-bold font-heading text-white"><i class="fa-solid fa-cube text-primary me-2"></i> ${pkg.packageName}</h3>
                                </div>
                                <div class="text-md-end">
                                    <div class="text-slate-400 small">Estimated Investment</div>
                                    <div class="fs-3 fw-bold text-primary-gradient font-heading">Rs. ${pkg.estimatedBudget}</div>
                                </div>
                            </div>
                        </div>

                        <div class="card-body p-4 p-md-5">
                            <c:if test="${not empty pkg.description}">
                                <p class="text-slate-700 lead fs-6 mb-4 pb-3 border-bottom">${pkg.description}</p>
                            </c:if>

                            <div class="row g-4">
                                <%-- ===== SUGGESTED WORKERS ===== --%>
                                <div class="col-md-6">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="fw-bold text-navy-900 mb-0"><i class="fa-solid fa-hard-hat text-primary me-2"></i> Recommended Workers</h5>
                                        <span class="badge badge-amber rounded-pill px-2.5 py-1">${pkg.workers.size()} Worker(s)</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty pkg.workers}">
                                            <div class="d-flex flex-column gap-2">
                                                <c:forEach var="w" items="${pkg.workers}">
                                                    <a href="${pageContext.request.contextPath}/worker/profile?id=${w.workerId}" class="text-decoration-none">
                                                        <div class="d-flex align-items-center gap-3 p-3 rounded-3 bg-slate-50 border hover-shadow transition-all">
                                                            <c:choose>
                                                                <c:when test="${not empty w.profilePhoto}">
                                                                    <img src="${pageContext.request.contextPath}/img?type=worker&id=${w.workerId}" class="rounded-circle object-fit-cover" style="width:44px; height:44px;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="avatar-fallback rounded-circle" style="width:44px; height:44px;">
                                                                        <i class="fa-solid fa-user-gear"></i>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div class="flex-grow-1">
                                                                <div class="fw-bold text-navy-900">${w.fullName}</div>
                                                                <div class="text-muted small">${w.profession} &bull; <span class="text-success fw-semibold">Rs. ${w.dailyRate}/day</span></div>
                                                            </div>
                                                            <i class="fa-solid fa-chevron-right text-slate-400 small"></i>
                                                        </div>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-slate-500 small bg-slate-50 p-3 rounded-3 mb-0">No specific workers assigned to this tier yet.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- ===== SUGGESTED SHOPS ===== --%>
                                <div class="col-md-6">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="fw-bold text-navy-900 mb-0"><i class="fa-solid fa-store text-primary me-2"></i> Partner Hardware Stores</h5>
                                        <span class="badge badge-amber rounded-pill px-2.5 py-1">${pkg.shops.size()} Store(s)</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty pkg.shops}">
                                            <div class="d-flex flex-column gap-2">
                                                <c:forEach var="s" items="${pkg.shops}">
                                                    <a href="${pageContext.request.contextPath}/hardware/profile?id=${s.shopId}" class="text-decoration-none">
                                                        <div class="d-flex align-items-center gap-3 p-3 rounded-3 bg-slate-50 border hover-shadow transition-all">
                                                            <c:choose>
                                                                <c:when test="${not empty s.logo}">
                                                                    <img src="${pageContext.request.contextPath}/img?type=shop&id=${s.shopId}" class="rounded-3 object-fit-contain bg-white" style="width:44px; height:44px;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="avatar-fallback rounded-3" style="width:44px; height:44px;">
                                                                        <i class="fa-solid fa-store"></i>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div class="flex-grow-1">
                                                                <div class="fw-bold text-navy-900">${s.shopName}</div>
                                                                <div class="text-muted small">${s.district} <c:if test="${s.deliveryAvailable}">&bull; <span class="text-success"><i class="fa-solid fa-truck"></i> Delivery</span></c:if></div>
                                                            </div>
                                                            <i class="fa-solid fa-chevron-right text-slate-400 small"></i>
                                                        </div>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-slate-500 small bg-slate-50 p-3 rounded-3 mb-0">No specific hardware stores assigned to this tier yet.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
