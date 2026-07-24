<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Sidebar -->
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-body text-center p-4">
                <div class="shop-logo-box mx-auto mb-3 rounded-3" style="height:120px;">
                    <c:choose>
                        <c:when test="${not empty shopProfile.logo}">
                            <img src="${pageContext.request.contextPath}/img?type=shop&id=${shopProfile.shopId}" alt="${shopProfile.shopName}">
                        </c:when>
                        <c:otherwise>
                            <div class="text-slate-400 d-flex flex-column align-items-center">
                                <i class="fa-solid fa-store fa-3x mb-1"></i>
                                <span class="small">Hardware Store</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h5 class="fw-bold font-heading mb-1 text-navy-900">${shopProfile.shopName}</h5>
                <div class="mb-3">
                    <c:choose>
                        <c:when test="${sessionScope.loggedInUser.status == 'active'}">
                            <span class="badge badge-emerald px-3 py-1 fw-semibold"><i class="fa-solid fa-circle-check me-1"></i> Verified Store</span>
                        </c:when>
                        <c:when test="${sessionScope.loggedInUser.status == 'pending'}">
                            <span class="badge badge-amber px-3 py-1 fw-semibold"><i class="fa-solid fa-hourglass-half me-1"></i> Pending Verification</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-crimson px-3 py-1 fw-semibold"><i class="fa-solid fa-circle-xmark me-1"></i> Store Suspended</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <a href="${pageContext.request.contextPath}/hardware/profile?id=${shopProfile.shopId}" class="btn btn-outline-primary btn-sm w-100 rounded-pill mb-3 fw-semibold">
                    <i class="fa-solid fa-eye me-1"></i> View Public Store
                </a>
                
                <form action="${pageContext.request.contextPath}/upload-photo" method="post" enctype="multipart/form-data" class="text-start bg-slate-50 p-3 rounded-3 border">
                    <label class="small fw-semibold text-slate-700 mb-1 d-block">Update Store Logo</label>
                    <div class="input-group input-group-sm">
                        <input type="file" name="logo" class="form-control form-control-sm" accept="image/*" required>
                        <button class="btn btn-primary btn-sm" type="submit" aria-label="Upload Logo"><i class="fa-solid fa-upload"></i></button>
                    </div>
                </form>
            </div>
            
            <div class="list-group list-group-flush border-top p-2 gap-1">
                <a href="#" class="list-group-item list-group-item-action rounded-3 border-0 active fw-semibold">
                    <i class="fa-solid fa-boxes-stacked me-2 text-primary"></i> Inventory & Material Prices
                </a>
                <button type="button" class="list-group-item list-group-item-action rounded-3 border-0 text-slate-700 fw-semibold text-start" data-bs-toggle="modal" data-bs-target="#editShopModal">
                    <i class="fa-solid fa-pen-to-square me-2 text-primary"></i> Edit Shop Details
                </button>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="col-lg-9">
        <!-- Flash messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-xmark me-2"></i> ${param.error}</div>
        </c:if>
        <c:if test="${param.msg == 'logo_updated'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Shop logo updated successfully!</div>
        </c:if>
        <c:if test="${param.msg == 'shop_updated'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Shop details updated successfully!</div>
        </c:if>
        <c:if test="${param.msg == 'material_added'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> New material added to shop catalog!</div>
        </c:if>
        <c:if test="${param.msg == 'material_updated'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Material price and availability updated!</div>
        </c:if>
        <c:if test="${param.msg == 'material_deleted'}">
            <div class="alert alert-success rounded-3 py-2.5 px-3 mb-3"><i class="fa-solid fa-circle-check me-2"></i> Material item removed from catalog.</div>
        </c:if>

        <c:if test="${sessionScope.loggedInUser.status != 'active'}">
            <div class="alert alert-warning rounded-3 py-2.5 px-3 mb-3">
                <i class="fa-solid fa-circle-exclamation me-2"></i> <strong>Account Pending Verification:</strong> Your shop profile is currently under review.
            </div>
        </c:if>

        <!-- KPI Summary Cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-slate-500 small font-heading fw-semibold">Catalog Items</div>
                            <div class="fs-3 fw-bold text-navy-900">${not empty shopProfile.materialPrices ? shopProfile.materialPrices.size() : 0}</div>
                        </div>
                        <div class="kpi-icon-box bg-primary-light text-primary">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-slate-500 small font-heading fw-semibold">Delivery Status</div>
                            <div class="fs-6 fw-bold ${shopProfile.deliveryAvailable ? 'text-success' : 'text-slate-500'}">
                                ${shopProfile.deliveryAvailable ? 'Active Delivery' : 'No Delivery'}
                            </div>
                        </div>
                        <div class="kpi-icon-box bg-success-light text-success">
                            <i class="fa-solid fa-truck"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-slate-500 small font-heading fw-semibold">Store Location</div>
                            <div class="fs-6 fw-bold text-navy-900">${shopProfile.district}</div>
                        </div>
                        <div class="kpi-icon-box bg-info-light text-info">
                            <i class="fa-solid fa-location-dot"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Inventory Management Table -->
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-white p-4 border-bottom d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                <div>
                    <h4 class="fw-bold font-heading mb-0 text-navy-900"><i class="fa-solid fa-boxes-stacked text-primary me-2"></i> Inventory & Material Prices</h4>
                    <p class="text-slate-500 small mb-0">Update unit rates, stock availability, and brands in real-time</p>
                </div>
                <button class="btn btn-primary btn-sm rounded-pill px-3 py-2 fw-semibold shadow-sm align-self-start align-self-sm-center" data-bs-toggle="modal" data-bs-target="#addMaterialPriceModal">
                    <i class="fa-solid fa-plus me-1"></i> Add Material
                </button>
            </div>
            
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty shopProfile.materialPrices}">
                        <div class="table-custom-wrapper border-0 rounded-0">
                            <table class="table table-custom align-middle mb-0" id="materialPricesTable">
                                <thead>
                                    <tr>
                                        <th>Material & Unit</th>
                                        <th>Brand</th>
                                        <th>Price (LKR)</th>
                                        <th>Stock Status</th>
                                        <th>Last Updated</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="mp" items="${shopProfile.materialPrices}">
                                        <tr id="row-material-${mp.priceId}">
                                            <td>
                                                <div class="fw-bold text-navy-900">${mp.material.materialName}</div>
                                                <span class="badge badge-slate small">${mp.material.category} / ${mp.material.unit}</span>
                                            </td>
                                            <td>
                                                <form id="form-update-${mp.priceId}" action="${pageContext.request.contextPath}/hardware/dashboard" method="post" class="d-inline hardware-inline-form">
                                                    <input type="hidden" name="action" value="updateMaterialPrice">
                                                    <input type="hidden" name="price_id" value="${mp.priceId}">
                                                    <input type="text" name="brand" class="form-control form-control-sm input-width-sm" value="${mp.brand}" placeholder="Brand name">
                                                </form>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-sm input-width-md">
                                                    <span class="input-group-text bg-light">Rs.</span>
                                                    <input type="number" step="0.01" name="price" form="form-update-${mp.priceId}" class="form-control" value="${mp.price}" required>
                                                </div>
                                            </td>
                                            <td>
                                                <select name="availability" form="form-update-${mp.priceId}" class="form-select form-select-sm input-width-sm">
                                                    <option value="In Stock" ${mp.availability == 'In Stock' ? 'selected' : ''}>In Stock</option>
                                                    <option value="Out of Stock" ${mp.availability == 'Out of Stock' ? 'selected' : ''}>Out of Stock</option>
                                                </select>
                                            </td>
                                            <td class="small text-slate-500">
                                                <i class="fa-regular fa-clock me-1"></i> ${not empty mp.lastUpdated ? mp.lastUpdated : 'Recently'}
                                            </td>
                                            <td class="text-end action-cell">
                                                <div class="d-inline-flex gap-1">
                                                    <button type="submit" form="form-update-${mp.priceId}" class="btn btn-sm btn-success rounded-3 inline-save-btn py-1 px-2.5 fw-semibold" title="Save Changes">
                                                        <i class="fa-solid fa-floppy-disk me-1"></i> Save
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/hardware/dashboard" method="post" class="d-inline" onsubmit="return confirm('Remove this material item from your shop catalog?');">
                                                        <input type="hidden" name="action" value="deleteMaterialPrice">
                                                        <input type="hidden" name="price_id" value="${mp.priceId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 py-1 px-2" title="Remove Material">
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
                        <div class="p-5 text-center bg-slate-50 m-3 rounded-4">
                            <i class="fa-solid fa-box-open text-slate-300 fa-3x mb-3 d-block"></i>
                            <h5 class="fw-bold text-navy-900">Your catalog is currently empty</h5>
                            <p class="text-muted small">Click <strong>Add Material</strong> to publish inventory items and unit prices for clients.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Edit Shop Details -->
<div class="modal fade" id="editShopModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-navy text-white p-4 border-0" style="background: var(--navy-900);">
                <h5 class="modal-title fw-bold font-heading text-white"><i class="fa-solid fa-pen-to-square text-primary me-2"></i> Edit Shop Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/hardware/dashboard" method="post">
                <input type="hidden" name="action" value="updateShopDetails">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Shop Display Name</label>
                            <input type="text" name="shop_name" class="form-control" value="${shopProfile.shopName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Owner Full Name</label>
                            <input type="text" name="owner_name" class="form-control" value="${shopProfile.ownerName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Business Registration Number (BRN)</label>
                            <input type="text" name="business_registration_number" class="form-control" value="${shopProfile.businessRegistrationNumber}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Contact Phone Number</label>
                            <input type="text" name="phone" class="form-control" value="${shopProfile.phone}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">District</label>
                            <input type="text" name="district" class="form-control" value="${shopProfile.district}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small text-slate-700">Opening Hours</label>
                            <input type="text" name="opening_hours" class="form-control" value="${shopProfile.openingHours}">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small text-slate-700">Street Address</label>
                            <input type="text" name="address" class="form-control" value="${shopProfile.address}">
                        </div>
                        <div class="col-12">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="delivery_available" id="deliveryCheck" ${shopProfile.deliveryAvailable ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold text-slate-700" for="deliveryCheck">
                                    Offers Material Delivery Services
                                </label>
                            </div>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold small text-slate-700">Shop Description & Specializations</label>
                            <textarea name="description" class="form-control" rows="3">${shopProfile.description}</textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light p-3">
                    <button type="button" class="btn btn-slate btn-sm rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-1"></i> Save Store Details
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Add New Material -->
<div class="modal fade" id="addMaterialPriceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header bg-navy text-white p-4 border-0" style="background: var(--navy-900);">
                <h5 class="modal-title fw-bold font-heading text-white"><i class="fa-solid fa-boxes-stacked text-primary me-2"></i> Add Material to Inventory</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/hardware/dashboard" method="post">
                <input type="hidden" name="action" value="addMaterialPrice">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Select Material Item</label>
                        <select name="material_id" class="form-select" required>
                            <option value="">— Choose catalog item —</option>
                            <c:forEach var="m" items="${allMaterials}">
                                <option value="${m.materialId}">${m.materialName} (${m.category}) - per ${m.unit}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Brand Name</label>
                        <input type="text" name="brand" class="form-control" placeholder="e.g. Sanstha, Tokyo Super, Melwa">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Unit Price (LKR)</label>
                        <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-slate-700">Stock Availability</label>
                        <select name="availability" class="form-select" required>
                            <option value="In Stock" selected>In Stock</option>
                            <option value="Out of Stock">Out of Stock</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer bg-light p-3">
                    <button type="button" class="btn btn-slate btn-sm rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                        <i class="fa-solid fa-plus me-1"></i> Add Material
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.inline-save-btn').forEach(function(btn) {
            btn.addEventListener('click', function() {
                const formId = btn.getAttribute('form');
                const row = btn.closest('tr');
                if (row) {
                    row.classList.add('table-warning', 'opacity-75');
                }
                btn.disabled = true;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Saving...';
                if (formId) {
                    const form = document.getElementById(formId);
                    if (form) form.submit();
                }
            });
        });
    });
</script>
<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
