package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse {
    private Boolean success;
    private String mensaje;
    private Object data;

    public ApiResponse(Boolean success, String mensaje) {
        this.success = success;
        this.mensaje = mensaje;
    }

    public static ApiResponse success(String mensaje) {
        return new ApiResponse(true, mensaje);
    }

    public static ApiResponse success(String mensaje, Object data) {
        return new ApiResponse(true, mensaje, data);
    }

    public static ApiResponse error(String mensaje) {
        return new ApiResponse(false, mensaje);
    }
}
