import java.sql.*;

public class TestDB3 {
    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/buildsmart?user=root&password=");
            Statement stmt = conn.createStatement();
            // Try checking the admin password hash  
            ResultSet rs = stmt.executeQuery("SELECT password FROM users WHERE email='admin@buildsmart.lk'");
            while (rs.next()) {
                String hash = rs.getString("password");
                System.out.println("Admin hash: " + hash);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
