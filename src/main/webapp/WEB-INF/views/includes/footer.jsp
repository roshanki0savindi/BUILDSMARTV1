    </main>

    <footer class="py-5 mt-auto bg-dark text-light border-top">
        <div class="container">
            <div class="row g-4 mb-4">
                <!-- Brand / Information Column -->
                <div class="col-lg-4 col-md-6">
                    <h5 class="fw-bold text-white mb-3">
                        <i class="fa-solid fa-helmet-safety text-primary"></i> BuildSmart
                    </h5>
                    <p class="text-muted small mb-3">
                        Sri Lanka's premier construction resource matching platform. Connecting homeowners with verified skilled workers, hardware shops, and curated building packages.
                    </p>
                    <div class="d-flex gap-3 text-muted">
                        <a href="#" class="text-muted text-decoration-none" aria-label="Facebook"><i class="fa-brands fa-facebook fa-lg"></i></a>
                        <a href="#" class="text-muted text-decoration-none" aria-label="Twitter"><i class="fa-brands fa-twitter fa-lg"></i></a>
                        <a href="#" class="text-muted text-decoration-none" aria-label="LinkedIn"><i class="fa-brands fa-linkedin fa-lg"></i></a>
                    </div>
                </div>

                <!-- Navigation Links -->
                <div class="col-lg-2 col-md-6">
                    <h6 class="fw-bold text-white mb-3">Navigation</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Home</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/workers" class="text-muted text-decoration-none">Find Workers</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/hardware-shops" class="text-muted text-decoration-none">Hardware Shops</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/packages" class="text-muted text-decoration-none">Packages</a></li>
                    </ul>
                </div>

                <!-- Services Column -->
                <div class="col-lg-3 col-md-6">
                    <h6 class="fw-bold text-white mb-3">Services</h6>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2"><span class="text-muted"><i class="fa-solid fa-check text-primary me-1"></i> Worker Availability</span></li>
                        <li class="mb-2"><span class="text-muted"><i class="fa-solid fa-check text-primary me-1"></i> Hardware Catalog</span></li>
                        <li class="mb-2"><span class="text-muted"><i class="fa-solid fa-check text-primary me-1"></i> Tier Packages</span></li>
                        <li class="mb-2"><span class="text-muted"><i class="fa-solid fa-check text-primary me-1"></i> Transparent Reviews</span></li>
                    </ul>
                </div>

                <!-- Contact & Legal -->
                <div class="col-lg-3 col-md-6">
                    <h6 class="fw-bold text-white mb-3">Contact & Support</h6>
                    <ul class="list-unstyled small text-muted mb-0">
                        <li class="mb-2"><i class="fa-solid fa-location-dot me-2 text-primary"></i> Colombo, Sri Lanka</li>
                        <li class="mb-2"><i class="fa-solid fa-envelope me-2 text-primary"></i> support@buildsmart.lk</li>
                        <li class="mb-2"><i class="fa-solid fa-phone me-2 text-primary"></i> +94 11 234 5678</li>
                    </ul>
                </div>
            </div>

            <hr class="border-secondary my-4">

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small text-muted">
                <p class="mb-2 mb-md-0">&copy; <%= java.time.Year.now().getValue() %> BuildSmart. All rights reserved.</p>
                <div>
                    <a href="#" class="text-muted text-decoration-none me-3">Privacy Policy</a>
                    <a href="#" class="text-muted text-decoration-none me-3">Terms of Service</a>
                    <a href="#" class="text-muted text-decoration-none">Help & FAQ</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle (Includes Popper for dropdowns) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password toggle behavior
        document.addEventListener('click', function(e) {
            const btn = e.target.closest('.toggle-password-btn');
            if (!btn) return;
            const targetId = btn.getAttribute('data-target');
            let input = targetId ? document.getElementById(targetId) : btn.parentElement.querySelector('input');
            if (input) {
                const isPwd = input.type === 'password';
                input.type = isPwd ? 'text' : 'password';
                const icon = btn.querySelector('i');
                if (icon) {
                    icon.className = isPwd ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
                }
            }
        });

        // Global double form submission prevention
        document.addEventListener('submit', function(e) {
            const form = e.target;
            if (form.getAttribute('data-submitting') === 'true') {
                e.preventDefault();
                return;
            }
            form.setAttribute('data-submitting', 'true');
            const submitBtns = form.querySelectorAll('button[type="submit"], input[type="submit"]');
            submitBtns.forEach(function(btn) {
                btn.disabled = true;
                if (btn.tagName === 'BUTTON') {
                    btn.dataset.originalHtml = btn.innerHTML;
                    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span> Processing...';
                }
            });
        });

        // Global Interactive Star Rating Selector (Radio-input & keyboard accessible)
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.interactive-star-rating').forEach(function(container) {
                const radios = container.querySelectorAll('input[type="radio"]');
                const hiddenInput = container.querySelector('input[type="hidden"][name="rating"]');
                const stars = container.querySelectorAll('.star-select');
                const label = container.querySelector('.rating-label');

                function getSelectedValue() {
                    const checkedRadio = container.querySelector('input[type="radio"]:checked');
                    if (checkedRadio) return parseInt(checkedRadio.value);
                    if (hiddenInput && hiddenInput.value) return parseInt(hiddenInput.value);
                    return 5;
                }

                function setStars(val) {
                    stars.forEach(function(star) {
                        const r = parseInt(star.getAttribute('data-rating') || star.dataset.rating);
                        const icon = star.querySelector('i');
                        if (icon) {
                            if (r <= val) {
                                icon.className = 'fa-solid fa-star text-warning';
                            } else {
                                icon.className = 'fa-regular fa-star text-muted';
                            }
                        }
                    });
                    if (label) label.textContent = val + ' / 5 Stars';
                }

                radios.forEach(function(radio) {
                    radio.addEventListener('change', function() {
                        if (hiddenInput) hiddenInput.value = this.value;
                        setStars(parseInt(this.value));
                    });
                    radio.addEventListener('focus', function() {
                        setStars(parseInt(this.value));
                    });
                });

                stars.forEach(function(star) {
                    star.addEventListener('click', function() {
                        const val = parseInt(this.getAttribute('data-rating'));
                        if (hiddenInput) hiddenInput.value = val;
                        const matchingRadio = container.querySelector('input[type="radio"][value="' + val + '"]');
                        if (matchingRadio) {
                            matchingRadio.checked = true;
                        }
                        setStars(val);
                    });
                    star.addEventListener('mouseenter', function() {
                        const val = parseInt(this.getAttribute('data-rating'));
                        setStars(val);
                    });
                });

                container.addEventListener('mouseleave', function() {
                    setStars(getSelectedValue());
                });

                setStars(getSelectedValue());
            });

            // Strip persistent alert query parameters (msg, error) from URL bar after load
            const url = new URL(window.location.href);
            if (url.searchParams.has('msg') || url.searchParams.has('error')) {
                url.searchParams.delete('msg');
                url.searchParams.delete('error');
                const newUrl = url.pathname + (url.searchParams.toString() ? '?' + url.searchParams.toString() : '') + url.hash;
                window.history.replaceState(null, '', newUrl);
            }
        });
    </script>
</body>
</html>
