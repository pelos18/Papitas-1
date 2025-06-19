package com.tienda_Equipo4_7CV13.sistema_inventario.util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

public class ValidationUtils {

    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^[0-9]{10}$");

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }

    public static boolean isValidPrice(BigDecimal price) {
        return price != null && price.compareTo(BigDecimal.ZERO) > 0;
    }

    public static boolean isValidStock(Integer stock) {
        return stock != null && stock >= 0;
    }

    public static boolean isValidPercentage(BigDecimal percentage) {
        return percentage != null && 
               percentage.compareTo(BigDecimal.ZERO) >= 0 && 
               percentage.compareTo(BigDecimal.valueOf(100)) <= 100;
    }

    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static boolean isValidBarcode(String barcode) {
        return isNotEmpty(barcode) && barcode.length() >= 8 && barcode.length() <= 50;
    }

    public static boolean isValidRole(String role) {
        return "DUENO".equals(role) || "EMPLEADO".equals(role);
    }

    public static String sanitizeString(String input) {
        if (input == null) return null;
        return input.trim().replaceAll("[<>\"'&]", "");
    }
}
