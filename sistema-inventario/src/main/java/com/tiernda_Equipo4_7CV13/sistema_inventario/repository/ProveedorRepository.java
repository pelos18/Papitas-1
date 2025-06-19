package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Proveedor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProveedorRepository extends JpaRepository<Proveedor, Long> {
    
    // Buscar por nombre
    Optional<Proveedor> findByNombre(String nombre);
    
    // Buscar proveedores activos
    List<Proveedor> findByActivoTrue();
    
    // Buscar por nombre (contiene)
    List<Proveedor> findByNombreContainingIgnoreCaseAndActivoTrue(String nombre);
    
    // Buscar por teléfono
    Optional<Proveedor> findByTelefono(String telefono);
    
    // Buscar por email
    Optional<Proveedor> findByEmail(String email);
    
    // Verificar si existe
    boolean existsByNombre(String nombre);
    
    // Contar productos por proveedor
    @Query("SELECT COUNT(p) FROM Producto p WHERE p.proveedor.idProveedor = :idProveedor AND p.activo = true")
    long countProductosByProveedor(Long idProveedor);
}
