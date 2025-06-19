package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String nombreUsuario;
    private String password;
}
