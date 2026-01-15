package mg.gestion.cinema.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DataUtil {
    private static String datePattern = "yyyy-MM-dd HH:mm:ss";
    
    public static LocalDateTime convertStringToDateTime(String dateString) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(datePattern);
        return LocalDateTime.parse(dateString, formatter);
    }

    public static LocalDateTime convertStringToDateTime(String dateString,String pattern){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
        return LocalDateTime.parse(dateString, formatter);
    }
}
