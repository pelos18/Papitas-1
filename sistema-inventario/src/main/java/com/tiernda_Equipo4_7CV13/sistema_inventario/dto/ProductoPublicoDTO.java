package com.tienda_Equipo4_7CV13.sistema_inventario.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ProductoPublicoDTO {
    private Long idProducto;
    private String codigoBarras;
    private String nombre;
    private String descripcion;
    private String marca;
    private String presentacion;
    private BigDecimal precioVenta;
    private Integer stockActual;
    private LocalDate fechaCaducidad;
    private String ubicacionFisica;
    private Boolean requiereRefrigeracion;
    private Boolean esPerecedero;
    private Boolean enPromocion;
    private String nombreCategoria;
    private String nombreProveedor;
    
    // Sin costos, ganancias ni valor inventario
}
