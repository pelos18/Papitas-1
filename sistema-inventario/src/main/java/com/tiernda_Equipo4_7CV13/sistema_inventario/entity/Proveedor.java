package com.tienda_Equipo4_7CV13.sistema_inventario.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "PROVEEDORES")
public class Proveedor {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "proveedores_seq")
    @SequenceGenerator(name = "proveedores_seq", sequenceName = "SEQ_PROVEEDORES", allocationSize = 1)
    @Column(name = "ID_PROVEEDOR")
    private Long idProveedor;
    
    @Column(name = "NOMBRE", length = 200, nullable = false)
    private String nombre;
    
    @Column(name = "RAZON_SOCIAL", length = 200)
    private String razonSocial;
    
    @Column(name = "RFC", length = 20)
    private String rfc;
    
    @Column(name = "TELEFONO", length = 20)
    private String telefono;
    
    @Column(name = "EMAIL", length = 100)
    private String email;
    
    @Column(name = "DIRECCION", length = 500)
    private String direccion;
    
    @Column(name = "CIUDAD", length = 100)
    private String ciudad;
    
    @Column(name = "ESTADO", length = 100)
    private String estado;
    
    @Column(name = "CODIGO_POSTAL", length = 10)
    private String codigoPostal;
    
    @Column(name = "CONTACTO_PRINCIPAL", length = 200)
    private String contactoPrincipal;
    
    @Column(name = "TELEFONO_CONTACTO", length = 20)
    private String telefonoContacto;
    
    @Column(name = "DIAS_CREDITO")
    private Integer diasCredito;
    
    @Column(name = "LIMITE_CREDITO", precision = 12, scale = 2)
    private java.math.BigDecimal limiteCredito;
    
    @Column(name = "ACTIVO")
    private Integer activo;
    
    @Column(name = "FECHA_REGISTRO")
    private LocalDateTime fechaRegistro;
    
    @Column(name = "FECHA_MODIFICACION")
    private LocalDateTime fechaModificacion;
    
    @Column(name = "OBSERVACIONES", length = 1000)
    private String observaciones;
    
    // Relación con productos
    @OneToMany(mappedBy = "proveedor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Producto> productos;
    
    // Constructores
    public Proveedor() {
        this.fechaRegistro = LocalDateTime.now();
        this.activo = 1;
        this.diasCredito = 0;
    }
    
    public Proveedor(String nombre, String telefono, String email) {
        this();
        this.nombre = nombre;
        this.telefono = telefono;
        this.email = email;
    }
    
    // Getters y Setters
    public Long getIdProveedor() {
        return idProveedor;
    }
    
    public void setIdProveedor(Long idProveedor) {
        this.idProveedor = idProveedor;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getRazonSocial() {
        return razonSocial;
    }
    
    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }
    
    public String getRfc() {
        return rfc;
    }
    
    public void setRfc(String rfc) {
        this.rfc = rfc;
    }
    
    public String getTelefono() {
        return telefono;
    }
    
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getDireccion() {
        return direccion;
    }
    
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
    
    public String getCiudad() {
        return ciudad;
    }
    
    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public String getCodigoPostal() {
        return codigoPostal;
    }
    
    public void setCodigoPostal(String codigoPostal) {
        this.codigoPostal = codigoPostal;
    }
    
    public String getContactoPrincipal() {
        return contactoPrincipal;
    }
    
    public void setContactoPrincipal(String contactoPrincipal) {
        this.contactoPrincipal = contactoPrincipal;
    }
    
    public String getTelefonoContacto() {
        return telefonoContacto;
    }
    
    public void setTelefonoContacto(String telefonoContacto) {
        this.telefonoContacto = telefonoContacto;
    }
    
    public Integer getDiasCredito() {
        return diasCredito;
    }
    
    public void setDiasCredito(Integer diasCredito) {
        this.diasCredito = diasCredito;
    }
    
    public java.math.BigDecimal getLimiteCredito() {
        return limiteCredito;
    }
    
    public void setLimiteCredito(java.math.BigDecimal limiteCredito) {
        this.limiteCredito = limiteCredito;
    }
    
    public Integer getActivo() {
        return activo;
    }
    
    public void setActivo(Integer activo) {
        this.activo = activo;
    }
    
    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    public LocalDateTime getFechaModificacion() {
        return fechaModificacion;
    }
    
    public void setFechaModificacion(LocalDateTime fechaModificacion) {
        this.fechaModificacion = fechaModificacion;
    }
    
    public String getObservaciones() {
        return observaciones;
    }
    
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
    
    public List<Producto> getProductos() {
        return productos;
    }
    
    public void setProductos(List<Producto> productos) {
        this.productos = productos;
    }
    
    // Métodos de utilidad
    public boolean isActivo() {
        return activo != null && activo == 1;
    }
    
    public boolean tieneCredito() {
        return diasCredito != null && diasCredito > 0;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.fechaModificacion = LocalDateTime.now();
    }
    
    @Override
    public String toString() {
        return "Proveedor{" +
                "idProveedor=" + idProveedor +
                ", nombre='" + nombre + '\'' +
                ", telefono='" + telefono + '\'' +
                ", activo=" + activo +
                '}';
    }
}
