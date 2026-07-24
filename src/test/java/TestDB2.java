import java.sql.*;

public class TestDB2 {
    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/buildsmart?user=root&password=");
            Statement stmt = conn.createStatement();
            // Check users table
            ResultSet rs = stmt.executeQuery("SELECT user_id, email, role, status FROM users ORDER BY user_id LIMIT 10");
            System.out.println("--- USERS ---");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("user_id") + " | " + rs.getString("email") + " | " + rs.getString("role") + " | " + rs.getString("status"));
            }
            // Check admin
            rs = stmt.executeQuery("SELECT * FROM users WHERE role='admin'");
            System.out.println("--- ADMIN ---");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("user_id") + " | email: " + rs.getString("email") + " | hash: " + rs.getString("password").substring(0,10) + "...");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
