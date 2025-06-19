package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private String tipo = "Bearer";
    private Long id;
    private String nombreUsuario;
    private String email;
    private String rol;
    private boolean success;
    private String mensaje;

    public LoginResponse(String token, Long id, String nombreUsuario, String email, String rol) {
        this.token = token;
        this.id = id;
        this.nombreUsuario = nombreUsuario;
        this.email = email;
        this.rol = rol;
        this.success = true;
        this.mensaje = "Login exitoso";
    }
}
