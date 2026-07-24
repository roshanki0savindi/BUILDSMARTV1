<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 border-bottom pb-3">
    <div>
        <h2 class="fw-bold font-heading mb-1"><i class="fa-solid fa-users text-primary me-2"></i> Find Skilled Construction Workers</h2>
        <p class="text-slate-500 small mb-0">Browse verified trade professionals available for your project in Sri Lanka</p>
    </div>
    <span class="badge badge-amber fs-6 mt-2 mt-md-0 px-3 py-2 fw-semibold align-self-start align-self-md-center">
        ${workers.size()} Worker(s) Available
    </span>
</div>

<!-- ===== SEARCH & FILTER BAR ===== -->
<div class="card border-0 shadow-sm rounded-4 mb-4">
    <div class="card-header bg-white border-0 d-md-none p-3">
        <button class="btn btn-outline-primary btn-sm w-100 fw-bold d-flex justify-content-between align-items-center rounded-pill"
                type="button" data-bs-toggle="collapse" data-bs-target="#mobileFilterCollapse" aria-expanded="false" aria-controls="mobileFilterCollapse">
            <span><i class="fa-solid fa-filter me-1"></i> Search & Filter Workers</span>
            <i class="fa-solid fa-chevron-down"></i>
        </button>
    </div>
    <div class="card-body collapse d-md-block p-4" id="mobileFilterCollapse">
        <form method="get" action="${pageContext.request.contextPath}/workers" id="workerSearchForm">
            <div class="row g-3 align-items-end">
                <!-- Skill dropdown -->
                <div class="col-md-3">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Filter by Skill</label>
                    <select name="q" id="workerSearchQ" class="form-select">
                        <option value="">-- All Skills --</option>
                        <c:forEach var="skillOpt" items="${['Mason','Carpenter','Electrician','Plumber','Painter','Tiler','Architect','Welder','Laborer']}">
                            <option value="${skillOpt}" ${q == skillOpt ? 'selected' : ''}>${skillOpt}</option>
                        </c:forEach>
                    </select>
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

                <!-- Price range -->
                <div class="col-md-2">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Min Price (Rs.)</label>
                    <input type="number" name="minPrice" value="${minPrice}" class="form-control" placeholder="2000" min="0">
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Max Price (Rs.)</label>
                    <input type="number" name="maxPrice" value="${maxPrice}" class="form-control" placeholder="5000" min="0">
                </div>

                <!-- Sort -->
                <div class="col-md-2">
                    <label class="form-label fw-semibold small text-slate-700 mb-1">Sort By</label>
                    <select name="sort" class="form-select">
                        <option value="">Default</option>
                        <option value="rating"    ${sort == 'rating'     ? 'selected' : ''}>⭐ Top Rated</option>
                        <option value="price_asc" ${sort == 'price_asc'  ? 'selected' : ''}>💰 Price Low to High</option>
                        <option value="price_desc"${sort == 'price_desc' ? 'selected' : ''}>💰 Price High to Low</option>
                    </select>
                </div>

                <!-- Action Buttons Row -->
                <div class="col-12 d-flex justify-content-end gap-2 pt-2">
                    <a href="${pageContext.request.contextPath}/workers" class="btn btn-slate btn-sm rounded-pill px-3" title="Clear Filters">
                        <i class="fa-solid fa-arrow-rotate-left me-1"></i> Reset
                    </a>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold">
                        <i class="fa-solid fa-magnifying-glass me-1"></i> Search Workers
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- ===== WORKER CARDS ===== -->
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
    <c:forEach var="worker" items="${workers}">
        <div class="col">
            <div class="card h-100 border-0 card-hover text-center p-3">
                <div class="avatar-box mx-auto mb-3" style="width: 90px; height: 90px; border-radius: 50%;">
                    <c:choose>
                        <c:when test="${not empty worker.profilePhoto}">
                            <img src="${pageContext.request.contextPath}/img?type=worker&id=${worker.workerId}"
                                 class="w-100 h-100 rounded-circle object-fit-cover" alt="${worker.fullName}">
                        </c:when>
                        <c:otherwise>
                            <div class="w-100 h-100 rounded-circle bg-primary-light text-primary d-flex align-items-center justify-content-center fs-3 fw-bold">
                                <i class="fa-solid fa-user-gear"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="card-body p-0 d-flex flex-column">
                    <h5 class="card-title fw-bold text-dark mb-1">${worker.fullName}</h5>
                    <div class="badge badge-amber align-self-center mb-2 px-3 py-1">${worker.profession}</div>

                    <!-- Star rating -->
                    <div class="mb-3">
                        <c:forEach begin="1" end="${worker.averageRating}"><i class="fa-solid fa-star text-warning" style="font-size:.85rem;"></i></c:forEach>
                        <c:forEach begin="${worker.averageRating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:.85rem;"></i></c:forEach>
                        <span class="text-slate-500 small ms-1">(${worker.reviewCount})</span>
                    </div>

                    <div class="bg-light rounded-3 p-2 text-start small mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted"><i class="fa-solid fa-briefcase text-primary me-1"></i> Exp:</span>
                            <span class="fw-semibold text-dark">${worker.experience} Yrs</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted"><i class="fa-solid fa-money-bill-wave text-success me-1"></i> Daily:</span>
                            <span class="fw-semibold text-success">Rs. ${worker.dailyRate}</span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted"><i class="fa-solid fa-location-dot text-danger me-1"></i> Location:</span>
                            <span class="fw-semibold text-dark">${worker.district}</span>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/worker/profile?id=${worker.workerId}"
                       class="btn btn-outline-primary btn-sm w-100 rounded-pill mt-auto fw-semibold">View Profile</a>
                </div>
            </div>
        </div>
    </c:forEach>
    <c:if test="${empty workers}">
        <div class="col-12">
            <div class="p-5 text-center bg-white rounded-4 border">
                <i class="fa-solid fa-users-slash fa-3x mb-3 text-slate-300"></i>
                <h5 class="fw-bold">No workers match your filter criteria</h5>
                <p class="text-muted small">Try broadening your district or skill search terms.</p>
                <a href="${pageContext.request.contextPath}/workers" class="btn btn-outline-primary rounded-pill px-4 mt-2 fw-semibold">Reset Filters</a>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
