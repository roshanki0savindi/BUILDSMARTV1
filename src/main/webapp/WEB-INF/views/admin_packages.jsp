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

    <%-- Main Content --%>
    <div class="col-lg-9">
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-xmark me-2"></i> ${param.error}</div>
        </c:if>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                <div>
                    <h4 class="fw-bold font-heading mb-0 text-navy-900"><i class="fa-solid fa-cubes text-primary me-2"></i> Construction Package Tiers</h4>
                    <p class="text-slate-500 small mb-0">Manage bundled worker and hardware store suggestions for homeowners</p>
                </div>
                <button class="btn btn-primary btn-sm rounded-pill px-3 py-2 fw-semibold shadow-sm align-self-start align-self-sm-center" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                    <i class="fa-solid fa-plus me-1"></i> Create Package
                </button>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty packages}">
                        <div class="table-custom-wrapper border-0 rounded-0">
                            <table class="table table-custom align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Package Name</th>
                                        <th>Estimated Budget</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="pkg" items="${packages}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-navy-900">${pkg.packageName}</div>
                                                <span class="text-slate-500 small">${pkg.description}</span>
                                            </td>
                                            <td class="text-success fw-bold font-heading fs-6">Rs. ${pkg.estimatedBudget}</td>
                                            <td class="text-end action-cell">
                                                <div class="d-inline-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/admin/packages?manage=${pkg.packageId}"
                                                       class="btn btn-sm btn-outline-primary rounded-3 py-1 px-2.5 fw-semibold" title="Manage Workers & Shops">
                                                        <i class="fa-solid fa-sliders me-1"></i> Manage Assignees
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/admin/packages"
                                                          method="post" class="d-inline"
                                                          onsubmit="return confirm('Delete this package and all associated suggestions?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="packageId" value="${pkg.packageId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Delete Package">
                                                            <i class="fa-solid fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-5 text-center bg-slate-50">
                            <i class="fa-solid fa-cubes fa-3x text-slate-300 mb-3"></i>
                            <h5 class="fw-bold text-navy-900">No packages created yet</h5>
                            <p class="text-muted small">Click <strong>Create Package</strong> to assemble your first package bundle.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%-- Create Package Modal --%>
<div class="modal fade" id="addPackageModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-navy text-white p-4 border-0" style="background: var(--navy-900);">
                <h5 class="modal-title fw-bold font-heading text-white"><i class="fa-solid fa-plus-circle text-primary me-2"></i> Create Package Tier</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/packages" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Package Tier Name</label>
                        <input type="text" name="packageName" class="form-control" required
                               placeholder="e.g. Basic Residential, Premium Villa">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Estimated Budget (LKR)</label>
                        <input type="number" step="0.01" min="0" name="estimatedBudget"
                               class="form-control" required placeholder="e.g. 3500000">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Package Summary & Inclusions</label>
                        <textarea name="description" class="form-control" rows="3"
                                  placeholder="Describe the scope, materials, and worker trades included in this tier..."></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light p-3">
                    <button type="button" class="btn btn-slate btn-sm rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-1"></i> Save Package Tier
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
