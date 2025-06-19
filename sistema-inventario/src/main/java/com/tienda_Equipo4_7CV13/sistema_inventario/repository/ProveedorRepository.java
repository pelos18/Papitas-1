package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Proveedor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProveedorRepository extends JpaRepository<Proveedor, Long> {
    
    List<Proveedor> findByNombreContainingIgnoreCase(String nombre);
    
    Optional<Proveedor> findByRfc(String rfc);
    
    List<Proveedor> findByActivoTrue();
    
    @Query("SELECT p FROM Proveedor p WHERE p.activo = 1")
    List<Proveedor> findProveedoresActivos();
    
    @Query("SELECT p, COUNT(pr) FROM Proveedor p LEFT JOIN Producto pr ON p.idProveedor = pr.proveedor.idProveedor GROUP BY p")
    List<Object[]> findProveedoresConConteoProductos();
    
    @Query("SELECT COUNT(p) FROM Proveedor p WHERE p.activo = 1")
    long countProveedoresActivos();
    
    boolean existsByRfc(String rfc);
    
    boolean existsByNombre(String nombre);
}
