package com.tienda_Equipo4_7CV13.sistema_inventario.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "PRODUCTOS")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Producto {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_productos")
    @SequenceGenerator(name = "seq_productos", sequenceName = "SEQ_PRODUCTOS", allocationSize = 1)
    @Column(name = "ID_PRODUCTO")
    private Long idProducto;
    
    @Column(name = "CODIGO_BARRAS", length = 50, unique = true)
    private String codigoBarras;
    
    @Column(name = "NOMBRE", length = 200, nullable = false)
    private String nombre;
    
    @Column(name = "DESCRIPCION", length = 500)
    private String descripcion;
    
    @Column(name = "MARCA", length = 100)
    private String marca;
    
    @Column(name = "PRESENTACION", length = 100)
    private String presentacion;
    
    @Column(name = "PRECIO_COMPRA", precision = 10, scale = 2)
    private BigDecimal precioCompra;
    
    @Column(name = "PRECIO_VENTA", precision = 10, scale = 2, nullable = false)
    private BigDecimal precioVenta;
    
    @Column(name = "COSTO_BASE", precision = 10, scale = 2)
    private BigDecimal costoBase;
    
    @Column(name = "GASTOS_ADICIONALES", precision = 10, scale = 2)
    private BigDecimal gastosAdicionales = BigDecimal.ZERO;
    
    @Column(name = "COSTO_TOTAL", precision = 10, scale = 2)
    private BigDecimal costoTotal;
    
    @Column(name = "MARGEN_GANANCIA", precision = 5, scale = 2)
    private BigDecimal margenGanancia;
    
    @Column(name = "PRECIO_SUGERIDO", precision = 10, scale = 2)
    private BigDecimal precioSugerido;
    
    @Column(name = "GANANCIA_UNITARIA", precision = 10, scale = 2)
    private BigDecimal gananciaUnitaria;
    
    @Column(name = "MARGEN_REAL", precision = 5, scale = 2)
    private BigDecimal margenReal;
    
    @Column(name = "STOCK_ACTUAL", nullable = false)
    private Integer stockActual = 0;
    
    @Column(name = "STOCK_MINIMO", nullable = false)
    private Integer stockMinimo = 0;
    
    @Column(name = "STOCK_MAXIMO")
    private Integer stockMaximo;
    
    @Column(name = "FECHA_CADUCIDAD")
    private LocalDate fechaCaducidad;
    
    @Column(name = "UBICACION_FISICA", length = 100)
    private String ubicacionFisica;
    
    @Column(name = "REQUIERE_REFRIGERACION")
    private Boolean requiereRefrigeracion = false;
    
    @Column(name = "ES_PERECEDERO")
    private Boolean esPerecedero = false;
    
    @Column(name = "EN_PROMOCION")
    private Boolean enPromocion = false;
    
    @Column(name = "ACTIVO", nullable = false)
    private Integer activo = 1;
    
    @Column(name = "VALOR_INVENTARIO", precision = 15, scale = 2)
    private BigDecimal valorInventario;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CATEGORIA", foreignKey = @ForeignKey(name = "FK_PRODUCTO_CATEGORIA"))
    private Categoria categoria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_PROVEEDOR", foreignKey = @ForeignKey(name = "FK_PRODUCTO_PROVEEDOR"))
    private Proveedor proveedor;
    
    @Column(name = "FECHA_CREACION", nullable = false)
    private LocalDateTime fechaCreacion = LocalDateTime.now();
    
    @Column(name = "FECHA_MODIFICACION")
    private LocalDateTime fechaModificacion;
}
