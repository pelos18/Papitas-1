package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ProductoDTO {
    private Long idProducto;
    private String codigoBarras;
    private String codigoInterno;
    private String nombre;
    private String descripcion;
    private String marca;
    private String presentacion;
    
    // Solo para DUEÑO (costos)
    private BigDecimal costoBase;
    private BigDecimal gastosAdicionales;
    private BigDecimal costoTotal;
    private BigDecimal margenGanancia;
    private BigDecimal gananciaUnitaria;
    private BigDecimal margenReal;
    
    // Para todos los roles
    private BigDecimal precioVenta;
    private Integer stockActual;
    private Integer stockMinimo;
    private Integer stockMaximo;
    private LocalDate fechaCaducidad;
    private String ubicacionFisica;
    private Boolean requiereRefrigeracion;
    private Boolean esPerecedero;
    private Boolean activo;
    private Boolean enPromocion;
    
    // Información de relaciones
    private String nombreCategoria;
    private String nombreProveedor;
    
    // Solo para DUEÑO
    private BigDecimal valorInventario;
}
