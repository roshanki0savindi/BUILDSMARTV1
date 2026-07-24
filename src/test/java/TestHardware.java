import java.sql.*;
public class TestHardware {
    public static void main(String[] args) throws Exception {
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/buildsmart?user=root&password=&serverTimezone=Asia/Colombo&characterEncoding=UTF-8");
        PreparedStatement ps = conn.prepareStatement("SELECT s.*, (SELECT COALESCE(AVG(rating), 0) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as avg_rating, (SELECT COUNT(*) FROM reviews r WHERE r.target_type = 'hardware_shop' AND r.target_id = s.shop_id) as review_count FROM hardware_shops s WHERE s.shop_id = ?");
        ps.setInt(1, 1);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            System.out.println("Found shop: " + rs.getString("shop_name"));
        } else {
            System.out.println("NO SHOP FOUND for id=1!");
        }
        conn.close();
    }
}
