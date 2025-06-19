package com.tienda_Equipo4_7CV13.sistema_inventario.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "PRODUCTOS")
public class Producto {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "productos_seq")
    @SequenceGenerator(name = "productos_seq", sequenceName = "SEQ_PRODUCTOS", allocationSize = 1)
    @Column(name = "ID_PRODUCTO")
    private Long idProducto;
    
    @Column(name = "CODIGO_BARRAS", length = 50)
    private String codigoBarras;
    
    @Column(name = "CODIGO_INTERNO", length = 20)
    private String codigoInterno;
    
    @Column(name = "NOMBRE", length = 200, nullable = false)
    private String nombre;
    
    @Column(name = "DESCRIPCION", length = 500)
    private String descripcion;
    
    @Column(name = "MARCA", length = 100)
    private String marca;
    
    @Column(name = "PRESENTACION", length = 50)
    private String presentacion;
    
    @Column(name = "COSTO_BASE", precision = 10, scale = 2)
    private BigDecimal costoBase;
    
    @Column(name = "GASTOS_ADICIONALES", precision = 10, scale = 2)
    private BigDecimal gastosAdicionales;
    
    @Column(name = "COSTO_TOTAL", precision = 10, scale = 2)
    private BigDecimal costoTotal;
    
    @Column(name = "MARGEN_GANANCIA", precision = 5, scale = 2)
    private BigDecimal margenGanancia;
    
    @Column(name = "PRECIO_SUGERIDO", precision = 10, scale = 2)
    private BigDecimal precioSugerido;
    
    @Column(name = "PRECIO_VENTA", precision = 10, scale = 2)
    private BigDecimal precioVenta;
    
    @Column(name = "GANANCIA_UNITARIA", precision = 10, scale = 2)
    private BigDecimal gananciaUnitaria;
    
    @Column(name = "MARGEN_REAL", precision = 5, scale = 2)
    private BigDecimal margenReal;
    
    @Column(name = "STOCK_ACTUAL")
    private Integer stockActual;
    
    @Column(name = "STOCK_MINIMO")
    private Integer stockMinimo;
    
    @Column(name = "STOCK_MAXIMO")
    private Integer stockMaximo;
    
    @Column(name = "FECHA_CADUCIDAD")
    private LocalDate fechaCaducidad;
    
    @Column(name = "DIAS_VIDA_UTIL")
    private Integer diasVidaUtil;
    
    @Column(name = "FECHA_ULTIMA_VENTA")
    private LocalDate fechaUltimaVenta;
    
    @Column(name = "UBICACION_FISICA", length = 50)
    private String ubicacionFisica;
    
    @Column(name = "REQUIERE_REFRIGERACION")
    private Integer requiereRefrigeracion;
    
    @Column(name = "ES_PERECEDERO")
    private Integer esPerecedero;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CATEGORIA")
    private Categoria categoria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_PROVEEDOR")
    private Proveedor proveedor;
    
    @Column(name = "ACTIVO")
    private Integer activo;
    
    @Column(name = "EN_PROMOCION")
    private Integer enPromocion;
    
    @Column(name = "FECHA_REGISTRO")
    private LocalDate fechaRegistro;
    
    @Column(name = "VALOR_INVENTARIO", precision = 12, scale = 2)
    private BigDecimal valorInventario;
    
    // Constructores
    public Producto() {}
    
    public Producto(String nombre, String descripcion, BigDecimal precioVenta) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precioVenta = precioVenta;
        this.fechaRegistro = LocalDate.now();
        this.activo = 1;
    }
    
    // Getters y Setters
    public Long getIdProducto() { return idProducto; }
    public void setIdProducto(Long idProducto) { this.idProducto = idProducto; }
    
    public String getCodigoBarras() { return codigoBarras; }
    public void setCodigoBarras(String codigoBarras) { this.codigoBarras = codigoBarras; }
    
    public String getCodigoInterno() { return codigoInterno; }
    public void setCodigoInterno(String codigoInterno) { this.codigoInterno = codigoInterno; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }
    
    public String getPresentacion() { return presentacion; }
    public void setPresentacion(String presentacion) { this.presentacion = presentacion; }
    
    public BigDecimal getCostoBase() { return costoBase; }
    public void setCostoBase(BigDecimal costoBase) { this.costoBase = costoBase; }
    
    public BigDecimal getGastosAdicionales() { return gastosAdicionales; }
    public void setGastosAdicionales(BigDecimal gastosAdicionales) { this.gastosAdicionales = gastosAdicionales; }
    
    public BigDecimal getCostoTotal() { return costoTotal; }
    public void setCostoTotal(BigDecimal costoTotal) { this.costoTotal = costoTotal; }
    
    public BigDecimal getMargenGanancia() { return margenGanancia; }
    public void setMargenGanancia(BigDecimal margenGanancia) { this.margenGanancia = margenGanancia; }
    
    public BigDecimal getPrecioSugerido() { return precioSugerido; }
    public void setPrecioSugerido(BigDecimal precioSugerido) { this.precioSugerido = precioSugerido; }
    
    public BigDecimal getPrecioVenta() { return precioVenta; }
    public void setPrecioVenta(BigDecimal precioVenta) { this.precioVenta = precioVenta; }
    
    public BigDecimal getGananciaUnitaria() { return gananciaUnitaria; }
    public void setGananciaUnitaria(BigDecimal gananciaUnitaria) { this.gananciaUnitaria = gananciaUnitaria; }
    
    public BigDecimal getMargenReal() { return margenReal; }
    public void setMargenReal(BigDecimal margenReal) { this.margenReal = margenReal; }
    
    public Integer getStockActual() { return stockActual; }
    public void setStockActual(Integer stockActual) { this.stockActual = stockActual; }
    
    public Integer getStockMinimo() { return stockMinimo; }
    public void setStockMinimo(Integer stockMinimo) { this.stockMinimo = stockMinimo; }
    
    public Integer getStockMaximo() { return stockMaximo; }
    public void setStockMaximo(Integer stockMaximo) { this.stockMaximo = stockMaximo; }
    
    public LocalDate getFechaCaducidad() { return fechaCaducidad; }
    public void setFechaCaducidad(LocalDate fechaCaducidad) { this.fechaCaducidad = fechaCaducidad; }
    
    public Integer getDiasVidaUtil() { return diasVidaUtil; }
    public void setDiasVidaUtil(Integer diasVidaUtil) { this.diasVidaUtil = diasVidaUtil; }
    
    public LocalDate getFechaUltimaVenta() { return fechaUltimaVenta; }
    public void setFechaUltimaVenta(LocalDate fechaUltimaVenta) { this.fechaUltimaVenta = fechaUltimaVenta; }
    
    public String getUbicacionFisica() { return ubicacionFisica; }
    public void setUbicacionFisica(String ubicacionFisica) { this.ubicacionFisica = ubicacionFisica; }
    
    public Integer getRequiereRefrigeracion() { return requiereRefrigeracion; }
    public void setRequiereRefrigeracion(Integer requiereRefrigeracion) { this.requiereRefrigeracion = requiereRefrigeracion; }
    
    public Integer getEsPerecedero() { return esPerecedero; }
    public void setEsPerecedero(Integer esPerecedero) { this.esPerecedero = esPerecedero; }
    
    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }
    
    public Proveedor getProveedor() { return proveedor; }
    public void setProveedor(Proveedor proveedor) { this.proveedor = proveedor; }
    
    public Integer getActivo() { return activo; }
    public void setActivo(Integer activo) { this.activo = activo; }
    
    public Integer getEnPromocion() { return enPromocion; }
    public void setEnPromocion(Integer enPromocion) { this.enPromocion = enPromocion; }
    
    public LocalDate getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(LocalDate fechaRegistro) { this.fechaRegistro = fechaRegistro; }
    
    public BigDecimal getValorInventario() { return valorInventario; }
    public void setValorInventario(BigDecimal valorInventario) { this.valorInventario = valorInventario; }
    
    // Métodos de utilidad
    public boolean isActivo() {
        return activo != null && activo == 1;
    }
    
    public boolean isEnPromocion() {
        return enPromocion != null && enPromocion == 1;
    }
    
    public boolean requiereRefrigeracion() {
        return requiereRefrigeracion != null && requiereRefrigeracion == 1;
    }
    
    public boolean isPerecedero() {
        return esPerecedero != null && esPerecedero == 1;
    }
    
    @Override
    public String toString() {
        return "Producto{" +
                "idProducto=" + idProducto +
                ", nombre='" + nombre + '\'' +
                ", precioVenta=" + precioVenta +
                ", stockActual=" + stockActual +
                '}';
    }
}
