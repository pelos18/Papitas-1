package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;

@Data
public class CambiarPasswordDTO {
    private String passwordActual;
    private String passwordNuevo;
    private String confirmarPassword;
}
