package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Producto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, Long> {
    
    Optional<Producto> findByCodigoBarras(String codigoBarras);
    
    @Query("SELECT p FROM Producto p WHERE p.categoria.idCategoria = :categoriaId")
    List<Producto> findByCategoriaId(@Param("categoriaId") Long categoriaId);
    
    @Query("SELECT p FROM Producto p WHERE p.proveedor.idProveedor = :proveedorId")
    List<Producto> findByProveedorId(@Param("proveedorId") Long proveedorId);
    
    @Query("SELECT p FROM Producto p WHERE p.stockActual <= p.stockMinimo")
    List<Producto> findStockBajo();
    
    @Query("SELECT p FROM Producto p WHERE p.fechaCaducidad <= DATE_ADD(CURRENT_DATE, 30)")
    List<Producto> findProximosVencer();
    
    @Query("SELECT p FROM Producto p WHERE p.enPromocion = true")
    List<Producto> findByEnPromocionTrue();
    
    List<Producto> findByNombreContainingIgnoreCase(String nombre);
    
    @Query("SELECT p FROM Producto p WHERE p.activo = 1")
    List<Producto> findByActivoTrue();
    
    @Query("SELECT COUNT(p) FROM Producto p WHERE p.stockActual <= p.stockMinimo")
    long countStockBajo();
    
    @Query("SELECT COUNT(p) FROM Producto p WHERE p.fechaCaducidad <= DATE_ADD(CURRENT_DATE, 30)")
    long countProximosVencer();
    
    @Query("SELECT SUM(p.stockActual * p.precioCompra) FROM Producto p WHERE p.activo = 1")
    Double calcularValorTotalInventario();
}
