
package com.tienda_Equipo4_7CV13.sistema_inventario.entity;
import com.tienda_Equipo4_7CV13.sistema_inventario.entity.RolUsuario;


public enum RolUsuario {
    ADMIN("Administrador"),
    DUENO("Dueño"),
    EMPLEADO("Empleado"),
    CAJERO("Cajero"),
    INVENTARIO("Inventario");
    
    private final String descripcion;
    
    RolUsuario(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    @Override
    public String toString() {
        return this.name();
    }
}
