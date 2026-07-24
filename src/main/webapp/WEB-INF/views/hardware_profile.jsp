<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="/WEB-INF/views/includes/header.jsp" />

<div class="row g-4">
    <!-- Hardware Shop Sidebar -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 text-center p-4">
            <div class="shop-logo-box mb-3 rounded-3">
                <c:choose>
                    <c:when test="${not empty shop.logo}">
                        <img src="${pageContext.request.contextPath}/img?type=shop&id=${shop.shopId}" alt="${shop.shopName}">
                    </c:when>
                    <c:otherwise>
                        <div class="text-slate-400 d-flex flex-column align-items-center">
                            <i class="fa-solid fa-store fa-4x mb-2"></i>
                            <span class="small">Hardware Store</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <h3 class="fw-bold font-heading mb-1 text-navy-900">${shop.shopName}</h3>
            
            <c:if test="${shop.deliveryAvailable}">
                <div class="badge badge-emerald align-self-center mb-3 px-3 py-1.5 fs-6">
                    <i class="fa-solid fa-truck"></i> Delivery Service Offered
                </div>
            </c:if>
            
            <div class="bg-light rounded-3 p-3 text-start small mb-3">
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-user text-primary me-2"></i>Owner:</span>
                    <span class="fw-semibold text-dark">${shop.ownerName}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-location-dot text-danger me-2"></i>District:</span>
                    <span class="fw-semibold text-dark">${shop.district}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-map-marker-alt text-slate-500 me-2"></i>Address:</span>
                    <span class="fw-semibold text-dark text-end ms-2">${shop.address}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted"><i class="fa-solid fa-clock text-info me-2"></i>Hours:</span>
                    <span class="fw-semibold text-dark">${shop.openingHours}</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted"><i class="fa-solid fa-phone text-success me-2"></i>Contact:</span>
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <span class="fw-semibold text-dark">${shop.phone}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold">Login to view</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <c:if test="${not empty sessionScope.loggedInUser}">
                <a href="tel:${shop.phone}" class="btn btn-primary w-100 py-2.5 rounded-pill fw-semibold shadow-sm mt-2">
                    <i class="fa-solid fa-phone me-2"></i> Call Store Now
                </a>
            </c:if>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="col-lg-8">
        <!-- About Section -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4">
                <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-store text-primary"></i> About Store & Services
                </h4>
                <p class="text-slate-700 mb-0" style="line-height: 1.7;">
                    ${not empty shop.description ? shop.description : "No additional store details provided."}
                </p>
            </div>
        </div>

        <!-- Materials List -->
        <div class="card border-0 shadow-sm rounded-4 mb-4">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-3">
                    <h4 class="fw-bold font-heading text-navy-900 mb-0 d-flex align-items-center gap-2">
                        <i class="fa-solid fa-tags text-primary"></i> Material Pricing Catalog
                    </h4>
                    <span class="badge badge-amber fw-semibold">${not empty shop.materialPrices ? shop.materialPrices.size() : 0} Items</span>
                </div>
                
                <c:choose>
                    <c:when test="${not empty shop.materialPrices}">
                        <div class="table-custom-wrapper">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr>
                                        <th>Material Item</th>
                                        <th>Category</th>
                                        <th>Unit Price</th>
                                        <th>Last Updated</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="mp" items="${shop.materialPrices}">
                                        <tr>
                                            <td class="fw-semibold text-navy-900">${mp.material.materialName}</td>
                                            <td><span class="badge badge-slate">${mp.material.category}</span></td>
                                            <td class="text-success fw-bold">Rs. ${mp.price} / ${mp.material.unit}</td>
                                            <td class="small text-slate-500">${mp.lastUpdated}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-4 text-center text-muted bg-slate-50 rounded-4">
                            <i class="fa-solid fa-box-open fa-2x mb-2 text-slate-300"></i>
                            <p class="mb-0">This hardware store has not published catalog prices yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Reviews Section -->
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold font-heading text-navy-900 border-bottom pb-3 mb-3 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-comments text-primary"></i> Customer Feedback & Reviews
                </h4>
                
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger rounded-3 py-2 px-3 mb-3">${param.error}</div>
                </c:if>
                <c:if test="${param.msg == 'review_added'}">
                    <div class="alert alert-success rounded-3 py-2 px-3 mb-3">Thank you! Your review has been submitted.</div>
                </c:if>

                <c:if test="${sessionScope.loggedInUser.role == 'homeowner'}">
                    <form action="${pageContext.request.contextPath}/hardware/profile" method="post" enctype="multipart/form-data" class="mb-4 bg-slate-50 p-4 rounded-4 border">
                        <input type="hidden" name="targetId" value="${shop.shopId}">
                        <h6 class="fw-bold mb-3 text-navy-900"><i class="fa-solid fa-star text-primary me-2"></i> Rate & Review ${shop.shopName}</h6>
                        <div class="row align-items-center g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-slate-700 d-block mb-1">Star Rating</label>
                                <div class="interactive-star-rating" role="radiogroup" aria-label="Select Rating">
                                    <input type="hidden" name="rating" value="5">
                                    <c:forEach var="starVal" begin="1" end="5">
                                        <div class="d-inline-block position-relative me-1">
                                            <input type="radio" class="btn-check" name="rating_radio" id="shop-star-${starVal}" value="${starVal}" ${starVal == 5 ? 'checked' : ''}>
                                            <label for="shop-star-${starVal}" class="star-select mb-0" data-rating="${starVal}" title="${starVal} Star${starVal > 1 ? 's' : ''}" aria-label="${starVal} Star${starVal > 1 ? 's' : ''}">
                                                <i class="fa-solid fa-star text-warning"></i>
                                            </label>
                                        </div>
                                    </c:forEach>
                                    <span class="ms-2 fw-semibold text-slate-500 small rating-label">5 / 5 Stars</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-slate-700 mb-1">Optional Photo Attachment</label>
                                <input type="file" name="review_photo" class="form-control form-control-sm" accept="image/*">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-slate-700">Write Your Feedback</label>
                            <textarea name="comment" class="form-control" rows="3" placeholder="Comment on stock availability, pricing fairness, delivery speed..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-semibold shadow-sm">
                            <i class="fa-solid fa-paper-plane me-1"></i> Submit Review
                        </button>
                    </form>
                </c:if>

                <div class="d-flex flex-column gap-3">
                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-fallback rounded-circle" style="width:36px; height:36px; font-size:0.9rem;">
                                        ${not empty review.reviewerName ? review.reviewerName.substring(0,1) : 'C'}
                                    </div>
                                    <strong class="text-navy-900">${not empty review.reviewerName ? review.reviewerName : 'Customer'}</strong>
                                </div>
                                <div>
                                    <c:forEach begin="1" end="${review.rating}"><i class="fa-solid fa-star text-warning" style="font-size:0.85rem;"></i></c:forEach>
                                    <c:forEach begin="${review.rating + 1}" end="5"><i class="fa-regular fa-star text-slate-300" style="font-size:0.85rem;"></i></c:forEach>
                                </div>
                            </div>
                            <p class="text-slate-700 mb-2">${review.comment}</p>
                            <c:if test="${not empty review.photo}">
                                <img src="${pageContext.request.contextPath}/img?type=review&id=${review.reviewId}" alt="Review Attachment" class="img-thumbnail rounded-3 mt-1 mb-2" style="max-height: 160px;">
                            </c:if>
                            <div class="text-muted extra-small" style="font-size:0.78rem;">
                                <i class="fa-regular fa-clock me-1"></i> Posted on ${review.reviewDate}
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty reviews}">
                        <div class="p-4 text-center text-muted bg-slate-50 rounded-4">
                            <i class="fa-regular fa-comments fa-2x mb-2 text-slate-300"></i>
                            <p class="mb-0">No customer reviews written yet for this hardware store.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp" />
