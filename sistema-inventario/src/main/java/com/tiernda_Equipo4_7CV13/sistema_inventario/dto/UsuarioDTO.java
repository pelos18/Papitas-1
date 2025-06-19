package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UsuarioDTO {
    private Long idUsuario;
    private String nombreUsuario;
    private String nombreCompleto;
    private String email;
    private String telefono;
    private String rol;
    private Boolean activo;
    private LocalDateTime ultimoAcceso;
    private LocalDateTime fechaCreacion;
    
    // Sin password ni datos sensibles
}
