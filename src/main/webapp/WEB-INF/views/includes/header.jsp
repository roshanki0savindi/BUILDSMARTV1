<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BuildSmart - Construction Resource Platform</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Custom Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <nav class="navbar navbar-expand-lg sticky-top navbar-custom shadow-sm mb-4">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
                <span class="brand-icon-wrapper bg-primary text-white rounded-3 d-inline-flex align-items-center justify-content-center" style="width:36px; height:36px;">
                    <i class="fa-solid fa-helmet-safety"></i>
                </span>
                <span class="brand-text">Build<span class="text-primary-gradient">Smart</span></span>
            </a>
            
            <button class="navbar-toggler border-0 shadow-none text-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <i class="fa-solid fa-bars fa-lg"></i>
            </button>
            
            <div class="collapse navbar-collapse mt-2 mt-lg-0" id="navbarNav">
                <c:set var="currentUri" value="${pageContext.request.requestURI}" />
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link ${currentUri.endsWith('/workers') || currentUri.contains('/worker/') ? 'active' : ''}" href="${pageContext.request.contextPath}/workers">
                            <i class="fa-solid fa-users opacity-75 me-1"></i> Find Workers
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentUri.endsWith('/hardware-shops') || currentUri.contains('/hardware/') ? 'active' : ''}" href="${pageContext.request.contextPath}/hardware-shops">
                            <i class="fa-solid fa-store opacity-75 me-1"></i> Hardware Shops
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${currentUri.endsWith('/packages') ? 'active' : ''}" href="${pageContext.request.contextPath}/packages">
                            <i class="fa-solid fa-cubes opacity-75 me-1"></i> Packages
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav align-items-lg-center gap-2">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle btn btn-user-menu d-inline-flex align-items-center gap-2 px-3 py-2 rounded-pill text-white" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <span class="user-avatar-circle bg-primary-subtle text-primary fw-bold rounded-circle d-inline-flex align-items-center justify-content-center" style="width:28px; height:28px; font-size: 0.85rem;">
                                        <i class="fa-solid fa-user"></i>
                                    </span>
                                    <span>${sessionScope.loggedInUser.fullName}</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="userDropdown">
                                    <li class="px-3 py-2 border-bottom bg-light rounded-top">
                                        <div class="small text-muted">Logged in as</div>
                                        <div class="fw-semibold text-capitalize text-dark">${sessionScope.loggedInUser.role.replace('_', ' ')}</div>
                                    </li>
                                    <c:choose>
                                        <c:when test="${sessionScope.loggedInUser.role == 'homeowner'}">
                                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/homeowner/dashboard"><i class="fa-solid fa-gauge me-2 text-primary"></i> Dashboard</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.loggedInUser.role == 'worker'}">
                                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/worker/dashboard"><i class="fa-solid fa-gauge me-2 text-primary"></i> Dashboard</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.loggedInUser.role == 'hardware_owner'}">
                                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/hardware/dashboard"><i class="fa-solid fa-gauge me-2 text-primary"></i> Dashboard</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.loggedInUser.role == 'admin'}">
                                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-shield-halved me-2 text-primary"></i> Admin Panel</a></li>
                                        </c:when>
                                    </c:choose>
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Logout</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link ${currentUri.endsWith('/login') ? 'active' : ''}" href="${pageContext.request.contextPath}/login">
                                    <i class="fa-solid fa-right-to-bracket me-1 opacity-75"></i> Login
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary btn-signup px-3 py-2 rounded-pill fw-semibold" href="${pageContext.request.contextPath}/register">
                                    <i class="fa-solid fa-user-plus me-1"></i> Sign Up
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
    
    <main class="container pb-5 flex-grow-1">
