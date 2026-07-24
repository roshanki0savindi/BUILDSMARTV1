package lk.buildsmart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.buildsmart.dao.WorkerDAO;
import lk.buildsmart.model.User;
import lk.buildsmart.model.Worker;
import lk.buildsmart.util.SessionManager;

import java.io.IOException;

import lk.buildsmart.dao.UserDAO;
import java.math.BigDecimal;

import java.io.IOException;

@WebServlet("/worker/dashboard")
public class WorkerDashboardServlet extends HttpServlet {
    private final WorkerDAO workerDAO = new WorkerDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            User user = SessionManager.getLoggedInUser(req);
            
            Worker workerProfile = workerDAO.getByUserId(user.getUserId());
            if (workerProfile == null) {
                workerProfile = new Worker();
                workerProfile.setUserId(user.getUserId());
                workerProfile.setFullName(user.getFullName());
                workerProfile.setPhone(user.getPhone());
                workerProfile.setEmail(user.getEmail());
                workerProfile.setStatus(user.getStatus());
                workerProfile.setProfession("Laborer");
                workerProfile.setDistrict("Colombo");
                workerDAO.insert(workerProfile);
            }
            req.setAttribute("workerProfile", workerProfile);
            
            req.getRequestDispatcher("/WEB-INF/views/worker_dashboard.jsp").forward(req, resp);
            
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = SessionManager.getLoggedInUser(req);
        if (user == null || !"worker".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized");
            return;
        }

        try {
            Worker worker = workerDAO.getByUserId(user.getUserId());
            boolean isNew = false;
            if (worker == null) {
                worker = new Worker();
                worker.setUserId(user.getUserId());
                isNew = true;
            }

            String fullName = req.getParameter("full_name");
            String phone = req.getParameter("phone");
            String profession = req.getParameter("profession");
            int experience = Integer.parseInt(req.getParameter("experience"));
            BigDecimal dailyRate = new BigDecimal(req.getParameter("daily_rate"));
            String district = req.getParameter("district");
            String skills = req.getParameter("skills");
            String about = req.getParameter("about");

            // Update user basic info
            if (fullName != null && !fullName.isBlank()) user.setFullName(fullName);
            if (phone != null) user.setPhone(phone);
            userDAO.updateBasicInfo(user);

            // Update worker profile info
            worker.setProfession(profession);
            worker.setExperience(experience);
            worker.setDailyRate(dailyRate);
            worker.setDistrict(district);
            worker.setSkills(skills);
            if (isNew) {
                workerDAO.insert(worker);
            } else {
                workerDAO.update(worker);
            }

            resp.sendRedirect(req.getContextPath() + "/worker/dashboard?msg=profile_updated");

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/worker/dashboard?error=" + java.net.URLEncoder.encode("Failed to update profile", "UTF-8"));
        }
    }
}
