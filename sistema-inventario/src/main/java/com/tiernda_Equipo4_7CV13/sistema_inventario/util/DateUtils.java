package com.tienda_Equipo4_7CV13.sistema_inventario.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class DateUtils {

    public static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    public static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    public static String formatDate(LocalDate date) {
        return date != null ? date.format(DATE_FORMATTER) : "";
    }

    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime != null ? dateTime.format(DATETIME_FORMATTER) : "";
    }

    public static boolean isProximoAVencer(LocalDate fechaCaducidad, int diasAlerta) {
        if (fechaCaducidad == null) return false;
        LocalDate fechaAlerta = LocalDate.now().plusDays(diasAlerta);
        return fechaCaducidad.isBefore(fechaAlerta) || fechaCaducidad.isEqual(fechaAlerta);
    }

    public static boolean isVencido(LocalDate fechaCaducidad) {
        if (fechaCaducidad == null) return false;
        return fechaCaducidad.isBefore(LocalDate.now());
    }

    public static long diasHastaVencimiento(LocalDate fechaCaducidad) {
        if (fechaCaducidad == null) return Long.MAX_VALUE;
        return ChronoUnit.DAYS.between(LocalDate.now(), fechaCaducidad);
    }

    public static String getEstadoVencimiento(LocalDate fechaCaducidad) {
        if (fechaCaducidad == null) return "Sin fecha";
        
        long dias = diasHastaVencimiento(fechaCaducidad);
        
        if (dias < 0) return "Vencido";
        if (dias == 0) return "Vence hoy";
        if (dias <= 7) return "Próximo a vencer";
        if (dias <= 30) return "Vence pronto";
        
        return "Vigente";
    }
}
