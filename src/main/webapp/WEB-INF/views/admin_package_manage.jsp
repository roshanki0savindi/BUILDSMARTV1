<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <%-- Admin Sidebar --%>
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-navy text-white p-3 border-0" style="background: var(--navy-900);">
                <h6 class="fw-bold font-heading text-white mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-shield-halved text-primary"></i> Admin Control Panel
                </h6>
            </div>
            <div class="list-group list-group-flush p-2 gap-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-chart-pie me-2 text-primary"></i> Platform Analytics
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-users-gear me-2 text-primary"></i> User Management
                </a>
                <a href="${pageContext.request.contextPath}/admin/materials" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-boxes-packing me-2 text-primary"></i> Master Materials
                </a>
                <a href="${pageContext.request.contextPath}/admin/packages" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
                    <i class="fa-solid fa-cubes me-2 text-primary"></i> Package Bundles
                </a>
                <a href="${pageContext.request.contextPath}/admin/reviews" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-comment-slash me-2 text-primary"></i> Moderation Queue
                </a>
            </div>
        </div>
    </div>

    <%-- Manage Detail Panel --%>
    <div class="col-lg-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/admin/packages" class="btn btn-slate btn-sm rounded-pill mb-2 px-3 fw-semibold">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back to Package List
                </a>
                <h3 class="text-navy-900 mb-0 fw-bold font-heading">
                    <i class="fa-solid fa-cube text-primary me-2"></i> ${pkg.packageName}
                </h3>
                <span class="text-success fw-bold font-heading">Estimated Budget: Rs. ${pkg.estimatedBudget}</span>
            </div>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-4"><i class="fa-solid fa-circle-check me-2"></i> Package assignments updated successfully.</div>
        </c:if>

        <%-- Package description --%>
        <c:if test="${not empty pkg.description}">
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-slate-50">
                <label class="fw-semibold small text-slate-500 mb-1 d-block">Tier Description & Inclusions:</label>
                <p class="text-slate-700 mb-0">${pkg.description}</p>
            </div>
        </c:if>

        <%-- ===== WORKERS SECTION ===== --%>
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                <h5 class="m-0 text-navy-900 fw-bold font-heading"><i class="fa-solid fa-hard-hat text-primary me-2"></i> Suggested Workers Tier</h5>
                <form action="${pageContext.request.contextPath}/admin/packages" method="post" class="d-flex gap-2">
                    <input type="hidden" name="action" value="addWorker">
                    <input type="hidden" name="packageId" value="${pkg.packageId}">
                    <select name="workerId" class="form-select form-select-sm" required style="max-width:240px;">
                        <option value="">— Select a worker —</option>
                        <c:forEach var="w" items="${allWorkers}">
                            <option value="${w.workerId}">${w.fullName} (${w.profession})</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-sm btn-primary rounded-pill px-3 fw-semibold"><i class="fa-solid fa-plus me-1"></i> Add</button>
                </form>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty pkg.workers}">
                        <div class="list-group list-group-flush">
                            <c:forEach var="w" items="${pkg.workers}">
                                <div class="list-group-item p-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <strong class="text-navy-900 me-2">${w.fullName}</strong>
                                        <span class="badge badge-amber me-2">${w.profession}</span>
                                        <span class="text-slate-500 small">${w.district} &bull; <span class="text-success fw-semibold">Rs. ${w.dailyRate}/day</span></span>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/packages" method="post">
                                        <input type="hidden" name="action" value="removeWorker">
                                        <input type="hidden" name="packageId" value="${pkg.packageId}">
                                        <input type="hidden" name="workerId" value="${w.workerId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Remove Worker from Package">
                                            <i class="fa-solid fa-xmark"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-4 text-center text-muted bg-slate-50">
                            <p class="mb-0 small">No workers assigned to this package tier yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ===== HARDWARE SHOPS SECTION ===== --%>
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                <h5 class="m-0 text-navy-900 fw-bold font-heading"><i class="fa-solid fa-store text-primary me-2"></i> Partner Hardware Stores</h5>
                <form action="${pageContext.request.contextPath}/admin/packages" method="post" class="d-flex gap-2">
                    <input type="hidden" name="action" value="addShop">
                    <input type="hidden" name="packageId" value="${pkg.packageId}">
                    <select name="shopId" class="form-select form-select-sm" required style="max-width:240px;">
                        <option value="">— Select a hardware store —</option>
                        <c:forEach var="s" items="${allShops}">
                            <option value="${s.shopId}">${s.shopName} (${s.district})</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-sm btn-primary rounded-pill px-3 fw-semibold"><i class="fa-solid fa-plus me-1"></i> Add</button>
                </form>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty pkg.shops}">
                        <div class="list-group list-group-flush">
                            <c:forEach var="s" items="${pkg.shops}">
                                <div class="list-group-item p-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <strong class="text-navy-900 me-2">${s.shopName}</strong>
                                        <span class="text-slate-500 small me-2">${s.district}</span>
                                        <c:if test="${s.deliveryAvailable}">
                                            <span class="badge badge-emerald small"><i class="fa-solid fa-truck"></i> Delivery</span>
                                        </c:if>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/packages" method="post">
                                        <input type="hidden" name="action" value="removeShop">
                                        <input type="hidden" name="packageId" value="${pkg.packageId}">
                                        <input type="hidden" name="shopId" value="${s.shopId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Remove Shop from Package">
                                            <i class="fa-solid fa-xmark"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-4 text-center text-muted bg-slate-50">
                            <p class="mb-0 small">No hardware stores assigned to this package tier yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
