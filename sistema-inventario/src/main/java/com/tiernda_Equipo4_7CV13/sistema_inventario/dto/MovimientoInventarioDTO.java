package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class MovimientoInventarioDTO {
    private Long productoId;
    private String nombreProducto;
    private String tipoMovimiento; // ENTRADA, SALIDA
    private Integer cantidad;
    private Integer stockAnterior;
    private Integer stockNuevo;
    private String motivo;
    private String usuarioResponsable;
    private LocalDateTime fechaMovimiento;
}
