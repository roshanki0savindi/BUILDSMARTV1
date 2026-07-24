<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<!-- Hero Section -->
<div class="position-relative overflow-hidden p-4 p-md-5 mb-5 rounded-4 text-white shadow-lg" style="background: linear-gradient(135deg, var(--navy-900) 0%, var(--navy-800) 50%, #1e1b4b 100%);">
    <div class="position-absolute top-0 end-0 p-5 opacity-10 d-none d-lg-block pointer-events-none">
        <i class="fa-solid fa-helmet-safety text-white" style="font-size: 15rem;"></i>
    </div>
    <div class="row align-items-center py-4 position-relative z-1">
        <div class="col-lg-8 text-center text-lg-start">
            <span class="badge bg-primary text-white rounded-pill px-3 py-2 fw-semibold mb-3">
                <i class="fa-solid fa-bolt me-1"></i> Sri Lanka's #1 Construction Marketplace
            </span>
            <h1 class="display-4 fw-extrabold text-white mb-3 font-heading" style="line-height: 1.15;">
                Build Your Dream Project With <span class="text-primary-gradient">Verified Experts</span>
            </h1>
            <p class="lead text-slate-300 mb-4 me-lg-5" style="font-size: 1.15rem;">
                Connect with skilled carpenters, masons, electricians, explore trusted hardware store inventories, and request all-in-one building packages.
            </p>
            <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center justify-content-lg-start">
                <a href="${pageContext.request.contextPath}/workers" class="btn btn-primary btn-lg px-4 py-3 rounded-pill fw-semibold d-inline-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-hard-hat"></i> Find Verified Workers
                </a>
                <a href="${pageContext.request.contextPath}/hardware-shops" class="btn btn-outline-light btn-lg px-4 py-3 rounded-pill fw-semibold d-inline-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-store"></i> Browse Hardware Shops
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Value Proposition Highlights -->
<div class="row g-4 mb-5">
    <div class="col-md-4">
        <div class="card h-100 p-4 border-0 bg-white shadow-sm rounded-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="bg-primary-light text-primary rounded-3 p-3 d-inline-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">
                    <i class="fa-solid fa-user-check fa-xl"></i>
                </div>
                <h5 class="fw-bold mb-0">Verified Skilled Workers</h5>
            </div>
            <p class="text-muted small mb-0">Browse real profiles, work history, client ratings, and live calendar availability before booking.</p>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card h-100 p-4 border-0 bg-white shadow-sm rounded-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="bg-primary-light text-primary rounded-3 p-3 d-inline-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">
                    <i class="fa-solid fa-boxes-packing fa-xl"></i>
                </div>
                <h5 class="fw-bold mb-0">Direct Shop Catalogs</h5>
            </div>
            <p class="text-muted small mb-0">Discover hardware stores across Sri Lanka with transparent unit pricing and real-time stock status.</p>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card h-100 p-4 border-0 bg-white shadow-sm rounded-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="bg-primary-light text-primary rounded-3 p-3 d-inline-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">
                    <i class="fa-solid fa-layer-group fa-xl"></i>
                </div>
                <h5 class="fw-bold mb-0">Curated Bundles</h5>
            </div>
            <p class="text-muted small mb-0">Save time and budget with pre-configured materials & labor packages designed for every construction phase.</p>
        </div>
    </div>
</div>

<!-- Featured Workers -->
<div class="mb-5">
    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-star text-primary me-2"></i> Top Rated Workers</h3>
            <p class="text-muted small mb-0">Hand-picked professionals ready for your next project</p>
        </div>
        <a href="${pageContext.request.contextPath}/workers" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">View All Workers <i class="fa-solid fa-arrow-right ms-1"></i></a>
    </div>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
        <c:forEach var="worker" items="${featuredWorkers}">
            <div class="col">
                <div class="card h-100 border-0 card-hover text-center p-3">
                    <div class="avatar-box mx-auto mb-3" style="width: 100px; height: 100px; border-radius: 50%;">
                        <c:choose>
                            <c:when test="${not empty worker.profilePhoto}">
                                <img src="${pageContext.request.contextPath}/img?type=worker&id=${worker.workerId}" class="w-100 h-100 rounded-circle object-fit-cover" alt="${worker.fullName}">
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
                        <p class="small text-muted mb-3"><i class="fa-solid fa-location-dot text-primary me-1"></i> ${worker.district}</p>
                        <a href="${pageContext.request.contextPath}/worker/profile?id=${worker.userId}" class="btn btn-outline-primary btn-sm w-100 rounded-pill mt-auto fw-semibold">View Full Profile</a>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty featuredWorkers}">
            <div class="col-12">
                <div class="p-4 text-center text-muted bg-white rounded-4 border">
                    <i class="fa-solid fa-users-slash fa-2x mb-2 text-slate-300"></i>
                    <p class="mb-0">No featured workers available at the moment.</p>
                </div>
            </div>
        </c:if>
    </div>
</div>

<!-- Featured Hardware Shops -->
<div class="mb-5">
    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-shop text-primary me-2"></i> Recommended Hardware Shops</h3>
            <p class="text-muted small mb-0">Verified suppliers for quality tools, cement, steel, and timber</p>
        </div>
        <a href="${pageContext.request.contextPath}/hardware-shops" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">View All Shops <i class="fa-solid fa-arrow-right ms-1"></i></a>
    </div>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach var="shop" items="${featuredShops}">
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
                        <h5 class="card-title fw-bold mb-2">${shop.shopName}</h5>
                        <p class="small text-muted mb-2"><i class="fa-solid fa-location-dot text-primary me-1"></i> ${shop.district}</p>
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser}">
                                <p class="small text-slate-700 mb-3"><i class="fa-solid fa-phone text-primary me-1"></i> ${shop.phone}</p>
                            </c:when>
                            <c:otherwise>
                                <p class="small text-muted mb-3"><i class="fa-solid fa-phone text-primary me-1"></i> <a href="${pageContext.request.contextPath}/login" class="text-primary text-decoration-underline">Login to view contact</a></p>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/hardware/profile?id=${shop.shopId}" class="btn btn-primary w-100 rounded-pill mt-auto fw-semibold">
                            Browse Materials Catalog
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty featuredShops}">
            <div class="col-12">
                <div class="p-4 text-center text-muted bg-white rounded-4 border">
                    <i class="fa-solid fa-store-slash fa-2x mb-2 text-slate-300"></i>
                    <p class="mb-0">No hardware shops available at the moment.</p>
                </div>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />

<!-- Optimized landing page meta tags -->

