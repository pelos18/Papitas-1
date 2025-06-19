package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class InventarioResumenDTO {
    private Integer totalProductos;
    private Integer productosActivos;
    private Integer productosStockBajo;
    private Integer productosProximosVencer;
    private Integer productosEnPromocion;
    
    // Solo para DUEÑO
    private BigDecimal valorTotalInventario;
    private BigDecimal valorPromedioPorProducto;
    
    // Para todos
    private String fechaGeneracion;
}
