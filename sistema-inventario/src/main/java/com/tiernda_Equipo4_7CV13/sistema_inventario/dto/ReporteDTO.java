package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
public class ReporteDTO {
    private String tipoReporte;
    private String fechaGeneracion;
    private String generadoPor;
    
    // Datos generales
    private Integer totalProductos;
    private Map<String, Object> estadisticas;
    
    // Solo para DUEÑO
    private BigDecimal valorTotal;
    private List<Map<String, Object>> datosFinancieros;
    
    // Para todos
    private List<Map<String, Object>> datosProductos;
    private Map<String, Integer> resumenCategorias;
}
