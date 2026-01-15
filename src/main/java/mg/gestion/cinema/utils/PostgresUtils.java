package mg.gestion.cinema.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PostgresUtils {
    public static String callFunction(String funcName, Connection connection) {
        String sql = "SELECT " + funcName;
        try (PreparedStatement pstmt = connection.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getString(1);
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'appel de la fonction " + funcName + " : " + e.getMessage(), e);
        }
    }
}
