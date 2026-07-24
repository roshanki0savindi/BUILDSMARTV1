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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-chart-pie me-2 text-primary"></i> Platform Analytics
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold">
                    <i class="fa-solid fa-users-gear me-2 text-primary"></i> User Management
                </a>
                <a href="${pageContext.request.contextPath}/admin/materials" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
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
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                <div>
                    <h4 class="fw-bold font-heading mb-0 text-navy-900"><i class="fa-solid fa-boxes-packing text-primary me-2"></i> Master Material Items Directory</h4>
                    <p class="text-slate-500 small mb-0">Platform-wide materials list available for hardware shops to price</p>
                </div>
                <button class="btn btn-primary btn-sm rounded-pill px-3 py-2 fw-semibold shadow-sm align-self-start align-self-sm-center" data-bs-toggle="modal" data-bs-target="#addMaterialModal">
                    <i class="fa-solid fa-plus me-1"></i> Add Material
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-custom-wrapper border-0 rounded-0">
                    <table class="table table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Material Name</th>
                                <th>Category</th>
                                <th>Standard Unit</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mat" items="${materials}">
                                <tr>
                                    <td class="fw-bold text-navy-900">${mat.materialName}</td>
                                    <td><span class="badge badge-amber">${mat.category}</span></td>
                                    <td><span class="text-slate-700 small">${mat.unit}</span></td>
                                    <td class="text-end action-cell">
                                        <form action="${pageContext.request.contextPath}/admin/materials" method="post" class="d-inline" onsubmit="return confirm('Delete this material from master directory?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="materialId" value="${mat.materialId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2.5 fw-semibold" title="Delete Material">
                                                <i class="fa-solid fa-trash me-1"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Material Modal -->
<div class="modal fade" id="addMaterialModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-navy text-white p-4 border-0" style="background: var(--navy-900);">
                <h5 class="modal-title fw-bold font-heading text-white"><i class="fa-solid fa-plus-circle text-primary me-2"></i> Add Master Material</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/materials" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Material Item Name</label>
                        <input type="text" name="materialName" class="form-control" placeholder="e.g. Portland Cement" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Category</label>
                        <input type="text" name="category" class="form-control" required placeholder="e.g. Cement, Steel, Sand, Plumbing">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Unit Type</label>
                        <input type="text" name="unit" class="form-control" required placeholder="e.g. 50kg Bag, Cube, SqFt, Meter">
                    </div>
                </div>
                <div class="modal-footer bg-light p-3">
                    <button type="button" class="btn btn-slate btn-sm rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-1"></i> Save Material
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
