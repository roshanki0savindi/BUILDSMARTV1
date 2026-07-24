<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 border-bottom pb-3">
    <div>
        <h2 class="fw-bold font-heading mb-1"><i class="fa-solid fa-store text-primary me-2"></i> Hardware Stores Directory</h2>
        <p class="text-slate-500 small mb-0">Browse trusted building supply stores across Sri Lanka for cement, steel, tools, and finishing materials</p>
    </div>
    <span class="badge badge-amber fs-6 mt-2 mt-md-0 px-3 py-2 fw-semibold align-self-start align-self-md-center">
        ${shops.size()} Store(s) Listed
    </span>
</div>

<!-- ===== SEARCH & FILTER BAR ===== -->
<div class="card border-0 shadow-sm rounded-4 mb-4">
    <div class="card-body p-4">
        <form method="get" action="${pageContext.request.contextPath}/hardware-shops" id="shopSearchForm">
            <div class="row g-3 align-items-end">
                <!-- Text search -->
                <div class="col-md-4">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Search Store Name / Material</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-slate-500"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" name="q" id="shopSearchQ" value="${q}" class="form-control border-start-0 ps-0"
                               placeholder="e.g. Cement, Steel, PVC, Paints..." autocomplete="off">
                    </div>
                </div>

                <!-- District dropdown -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">District</label>
                    <select name="district" class="form-select">
                        <option value="all">-- All Districts --</option>
                        <c:forEach var="d" items="${['Ampara','Anuradhapura','Badulla','Batticaloa','Colombo','Galle','Gampaha','Hambantota','Jaffna','Kalutara','Kandy','Kegalle','Kilinochchi','Kurunegala','Mannar','Matale','Matara','Monaragala','Mullaitivu','Nuwara Eliya','Polonnaruwa','Puttalam','Ratnapura','Trincomalee','Vavuniya']}">
                            <option value="${d}" ${district == d ? 'selected' : ''}>${d}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Delivery filter -->
                <div class="col-md-2">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Delivery Option</label>
                    <select name="delivery" class="form-select">
                        <option value="">Any</option>
                        <option value="yes" ${delivery == 'yes' ? 'selected' : ''}>🚚 Delivery Available</option>
                    </select>
                </div>

                <!-- Sort -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Sort By</label>
                    <select name="sort" class="form-select">
                        <option value="">Default Listing</option>
                        <option value="rating" ${sort == 'rating' ? 'selected' : ''}>⭐ Highest Rated</option>
                    </select>
                </div>

                <!-- Action buttons -->
                <div class="col-12 d-flex justify-content-end gap-2 pt-2">
                    <a href="${pageContext.request.contextPath}/hardware-shops" class="btn btn-slate btn-sm rounded-pill px-3" title="Clear Filters">
                        <i class="fa-solid fa-arrow-rotate-left me-1"></i> Reset
                    </a>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold">
                        <i class="fa-solid fa-filter me-1"></i> Filter Stores
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- ===== SHOP CARDS ===== -->
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
    <c:forEach var="shop" items="${shops}">
        <div class="col">
            <div class="card h-100 border-0 card-hover overflow-hidden">
                <div class="shop-logo-box">
                    <c:choose>
                        <c:when test="${not empty shop.logo}">
                            <img src="${pageContext.request.contextPath}/img?type=shop&id=${shop.shopId}" alt="${shop.shopName}">
                        </c:when>
                        <c:otherwise>
                            <div class="text-slate-400 d-flex flex-column align-items-center">
                                <i class="fa-solid fa-store fa-3x mb-1"></i>
                                <span class="small">Hardware Store</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-body p-4 d-flex flex-column">
                    <h5 class="card-title fw-bold font-heading mb-1 text-navy-900">${shop.shopName}</h5>

                    <!-- Star rating -->
                    <div class="mb-3">
                        <c:forEach begin="1" end="${shop.averageRating}"><i class="fa-solid fa-star text-warning" style="font-size:0.85rem;"></i></c:forEach>
                        <c:forEach begin="${shop.averageRating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:0.85rem;"></i></c:forEach>
                        <span class="text-slate-500 small ms-1">(${shop.reviewCount})</span>
                    </div>

                    <div class="bg-light rounded-3 p-3 text-start small mb-3">
                        <div class="d-flex align-items-center mb-1.5 text-slate-700">
                            <i class="fa-solid fa-location-dot text-primary me-2"></i> ${shop.district}
                        </div>
                        <div class="d-flex align-items-center text-slate-700">
                            <i class="fa-solid fa-clock text-info me-2"></i> ${shop.openingHours}
                        </div>
                    </div>

                    <c:if test="${shop.deliveryAvailable}">
                        <div class="badge badge-emerald align-self-start mb-3 px-3 py-1.5">
                            <i class="fa-solid fa-truck"></i> Delivery Service Offered
                        </div>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/hardware/profile?id=${shop.shopId}"
                       class="btn btn-primary w-100 rounded-pill mt-auto fw-semibold">
                        View Store & Materials
                    </a>
                </div>
            </div>
        </div>
    </c:forEach>
    <c:if test="${empty shops}">
        <div class="col-12">
            <div class="p-5 text-center bg-white rounded-4 border">
                <i class="fa-solid fa-store-slash fa-3x mb-3 text-slate-300"></i>
                <h5 class="fw-bold">No hardware stores found</h5>
                <p class="text-muted small">Try searching for a different item or clearing district filters.</p>
                <a href="${pageContext.request.contextPath}/hardware-shops" class="btn btn-outline-primary rounded-pill px-4 mt-2 fw-semibold">Clear Search</a>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
