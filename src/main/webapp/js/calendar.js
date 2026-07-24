/**
 * BuildSmart - Worker Availability Calendar
 *
 * Shared JS module used by both:
 *   - worker_profile.jsp  (read-only public view)
 *   - worker_dashboard.jsp (interactive management view for the owning worker)
 *
 * API:
 *   CalendarWidget.initPublic(containerId, workerId)
 *     → Renders a read-only calendar that loads unavailable dates from the server.
 *
 *   CalendarWidget.initManage(containerId, workerId, contextPath)
 *     → Renders a click-to-toggle calendar. Workers can mark/unmark dates.
 *       Past dates are greyed out and unclickable.
 */
const CalendarWidget = (() => {

    const MONTHS = [
        'January','February','March','April','May','June',
        'July','August','September','October','November','December'
    ];
    const DAYS = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    // In-memory cache: key = "YYYY-MM", value = Set of unavailable date strings
    const cache = {};

    // Pad a number to 2 digits
    const pad = n => String(n).padStart(2, '0');

    // Format a Date object as "YYYY-MM-DD"
    const toIso = d => `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;

    // Today's date string (YYYY-MM-DD) for disabling past dates
    const TODAY = toIso(new Date());

    // =========================================================================
    // Core fetch — hits GET /api/availability?workerId=&year=&month=
    // =========================================================================
    async function fetchUnavailable(contextPath, workerId, year, month) {
        const cacheKey = `${year}-${pad(month)}`;
        if (cache[cacheKey]) return cache[cacheKey];

        try {
            const url = `${contextPath}/api/availability?workerId=${workerId}&year=${year}&month=${month}`;
            const res = await fetch(url);
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            const dates = await res.json();
            cache[cacheKey] = new Set(dates);
        } catch (e) {
            console.error('CalendarWidget: failed to fetch unavailable dates', e);
            cache[cacheKey] = new Set(); // fallback to empty so calendar still renders
        }
        return cache[cacheKey];
    }

    // =========================================================================
    // Render the calendar grid into a container element
    // =========================================================================
    function buildGrid(container, year, month, unavailableSet, interactive, contextPath, workerId) {
        // Header row
        let html = `<div class="cal-grid">`;
        DAYS.forEach(d => { html += `<div class="cal-cell cal-header">${d}</div>`; });

        const firstDow = new Date(year, month - 1, 1).getDay(); // 0=Sun
        const daysInMonth = new Date(year, month, 0).getDate();

        // Empty offset cells
        for (let i = 0; i < firstDow; i++) {
            html += `<div class="cal-cell cal-empty"></div>`;
        }

        for (let day = 1; day <= daysInMonth; day++) {
            const dateStr = `${year}-${pad(month)}-${pad(day)}`;
            const isPast  = dateStr < TODAY;
            const isUnavail = unavailableSet.has(dateStr);

            let classes = 'cal-cell cal-day';
            if (isPast)      classes += ' cal-past';
            if (isUnavail)   classes += ' cal-unavail';
            if (interactive && !isPast) classes += ' cal-clickable';

            let attrs = '';
            if (interactive && !isPast) {
                const statusText = isUnavail ? 'Unavailable' : 'Available';
                attrs = `data-date="${dateStr}" tabindex="0" role="button" aria-pressed="${isUnavail}" aria-label="${dateStr} - ${statusText}"`;
            } else {
                const statusText = isPast ? 'Past date' : (isUnavail ? 'Unavailable' : 'Available');
                attrs = `aria-label="${dateStr} - ${statusText}"`;
            }

            html += `<div class="${classes}" ${attrs}>${day}</div>`;
        }

        html += `</div>`;
        container.innerHTML = html;

        // Attach click & keyboard handlers only in interactive/manage mode
        if (interactive) {
            container.querySelectorAll('.cal-clickable').forEach(cell => {
                const handler = () => toggleDate(cell, contextPath, workerId);
                cell.addEventListener('click', handler);
                cell.addEventListener('keydown', (e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        handler();
                    }
                });
            });
        }
    }

    // Helper to keep aria attributes in sync
    function updateCellAria(cell, isUnavail) {
        const date = cell.dataset.date;
        cell.setAttribute('aria-pressed', isUnavail ? 'true' : 'false');
        if (date) {
            cell.setAttribute('aria-label', `${date} - ${isUnavail ? 'Unavailable' : 'Available'}`);
        }
    }

    // =========================================================================
    // Toggle a date via AJAX POST (management mode only)
    // =========================================================================
    async function toggleDate(cell, contextPath, workerId) {
        const date = cell.dataset.date;
        if (!date) return;

        // Optimistic UI: flip the class immediately, revert on error
        const wasUnavail = cell.classList.contains('cal-unavail');
        const nowUnavail = !wasUnavail;
        cell.classList.toggle('cal-unavail');
        updateCellAria(cell, nowUnavail);
        cell.classList.add('cal-loading');

        try {
            const res = await fetch(`${contextPath}/api/availability`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `date=${encodeURIComponent(date)}`
            });

            const data = await res.json();

            if (!res.ok) {
                // Server rejected — revert optimistic flip
                if (wasUnavail) { cell.classList.add('cal-unavail'); updateCellAria(cell, true); }
                else            { cell.classList.remove('cal-unavail'); updateCellAria(cell, false); }

                showToast(data.error || 'Failed to update availability.', 'danger');
                return;
            }

            // Sync the cache
            const cacheKey = date.substring(0, 7); // YYYY-MM
            if (!cache[cacheKey]) cache[cacheKey] = new Set();

            if (data.status === 'added') {
                cache[cacheKey].add(date);
                updateCellAria(cell, true);
                showToast(`Marked as unavailable: ${date}`, 'warning');
            } else {
                cache[cacheKey].delete(date);
                updateCellAria(cell, false);
                showToast(`Marked as available: ${date}`, 'success');
            }

        } catch (e) {
            console.error('CalendarWidget: toggle failed', e);
            // Revert on network error
            if (wasUnavail) { cell.classList.add('cal-unavail'); updateCellAria(cell, true); }
            else            { cell.classList.remove('cal-unavail'); updateCellAria(cell, false); }
            showToast('Network error. Please try again.', 'danger');
        } finally {
            cell.classList.remove('cal-loading');
        }
    }

    // =========================================================================
    // Toast notification helper
    // =========================================================================
    function showToast(message, type = 'info') {
        let toastContainer = document.getElementById('cal-toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.id = 'cal-toast-container';
            toastContainer.style.cssText = 'position:fixed;bottom:1.5rem;right:1.5rem;z-index:9999;';
            document.body.appendChild(toastContainer);
        }

        const toast = document.createElement('div');
        toast.className = `alert alert-${type} shadow py-2 px-3 mb-2 small`;
        toast.style.cssText = 'min-width:220px;animation:fadeInUp .3s ease;';
        toast.textContent = message;
        toastContainer.appendChild(toast);

        setTimeout(() => toast.remove(), 3500);
    }

    // =========================================================================
    // Widget factory — shared wiring for both public and manage modes
    // =========================================================================
    function createWidget(containerId, workerId, interactive, contextPath) {
        const container = document.getElementById(containerId);
        if (!container) {
            console.warn(`CalendarWidget: container #${containerId} not found`);
            return;
        }

        // Build the outer chrome (nav + grid placeholder)
        const now = new Date();
        let currentYear  = now.getFullYear();
        let currentMonth = now.getMonth() + 1; // 1-12

        function updateHeader() {
            const header = document.getElementById(`${containerId}-header`);
            if (header) header.textContent = `${MONTHS[currentMonth - 1]} ${currentYear}`;
        }

        async function render() {
            const grid = document.getElementById(`${containerId}-grid`);
            if (!grid) return;
            grid.innerHTML = '<div class="text-center text-muted py-3"><span class="spinner-border spinner-border-sm"></span> Loading…</div>';
            const unavailable = await fetchUnavailable(contextPath, workerId, currentYear, currentMonth);
            buildGrid(grid, currentYear, currentMonth, unavailable, interactive, contextPath, workerId);
            updateHeader();
        }

        // Expose prev/next handlers globally so onclick= works in JSP
        window[`${containerId}_prev`] = async () => {
            if (currentMonth === 1) { currentMonth = 12; currentYear--; }
            else currentMonth--;
            await render();
        };

        window[`${containerId}_next`] = async () => {
            if (currentMonth === 12) { currentMonth = 1; currentYear++; }
            else currentMonth++;
            await render();
        };

        render();
    }

    // =========================================================================
    // Public API
    // =========================================================================
    return {
        /**
         * Read-only calendar for public profile pages.
         * @param {string} containerId  - ID of an element that already has .cal-nav and #containerId-grid inside
         * @param {number} workerId
         * @param {string} contextPath  - e.g. "/buildsmart"
         */
        initPublic(containerId, workerId, contextPath) {
            createWidget(containerId, workerId, false, contextPath);
        },

        /**
         * Interactive (toggle) calendar for the worker's own dashboard.
         * @param {string} containerId
         * @param {number} workerId
         * @param {string} contextPath
         */
        initManage(containerId, workerId, contextPath) {
            createWidget(containerId, workerId, true, contextPath);
        }
    };
})();
