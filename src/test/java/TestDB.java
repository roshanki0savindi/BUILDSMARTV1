import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/buildsmart?user=root&password=");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT shop_id, shop_name FROM hardware_shops");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("shop_id") + " - " + rs.getString("shop_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
