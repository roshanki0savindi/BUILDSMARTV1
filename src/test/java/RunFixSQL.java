import java.sql.*;
public class RunFixSQL {
    public static void main(String[] args) throws Exception {
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/buildsmart?user=root&password=");
        PreparedStatement ps;
        
        ps = conn.prepareStatement("UPDATE users SET password = ? WHERE email = 'admin@buildsmart.lk'");
        ps.setString(1, "$2a$10$QI9n/NClrAiDmMnrwP21l.AVHJ2H.D9AmTHKgSC/94IPmO4hSRVEa");
        System.out.println("Admin password fixed: " + ps.executeUpdate() + " row(s)");
        
        ps = conn.prepareStatement("UPDATE users SET password = ? WHERE email != 'admin@buildsmart.lk'");
        ps.setString(1, "$2a$10$YnT7Z9pfRnLHaR44leoGgOjvOo8URpB8K2sRvHM2s.DQkNqnzGGRS");
        System.out.println("Seed users password fixed: " + ps.executeUpdate() + " row(s)");
        
        Statement stmt = conn.createStatement();
        System.out.println("Dup shops removed: " + stmt.executeUpdate("DELETE FROM hardware_shops WHERE shop_id > 10"));
        System.out.println("Dup workers removed: " + stmt.executeUpdate("DELETE FROM workers WHERE worker_id > 10"));
        
        ResultSet rs = stmt.executeQuery("SELECT shop_id, shop_name FROM hardware_shops ORDER BY shop_id");
        System.out.println("--- Shops ---");
        while(rs.next()) System.out.println("  " + rs.getInt(1) + " - " + rs.getString(2));
        conn.close();
        System.out.println("All done!");
    }
}
