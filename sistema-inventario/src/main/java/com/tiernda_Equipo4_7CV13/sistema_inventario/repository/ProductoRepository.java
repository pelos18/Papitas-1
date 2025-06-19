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
    
    // Buscar por código de barras
    Optional<Producto> findByCodigoBarras(String codigoBarras);
    
    // Buscar por código interno
    Optional<Producto> findByCodigoInterno(String codigoInterno);
    
    // Buscar productos activos
    List<Producto> findByActivoTrue();
    
    // Buscar por nombre (contiene)
    List<Producto> findByNombreContainingIgnoreCase(String nombre);
    
    // Buscar por categoría
    List<Producto> findByCategoriaIdCategoriaAndActivoTrue(Long idCategoria);
    
    // Buscar por proveedor
    List<Producto> findByProveedorIdProveedorAndActivoTrue(Long idProveedor);
    
    // Productos con stock bajo
    @Query("SELECT p FROM Producto p WHERE p.stockActual <= p.stockMinimo AND p.activo = true")
    List<Producto> findProductosConStockBajo();
    
    // Productos próximos a caducar
    @Query("SELECT p FROM Producto p WHERE p.fechaCaducidad <= CURRENT_DATE + :dias AND p.activo = true")
    List<Producto> findProductosProximosACaducar(@Param("dias") int dias);
    
    // Productos en promoción
    List<Producto> findByEnPromocionTrueAndActivoTrue();
    
    // Buscar por marca
    List<Producto> findByMarcaContainingIgnoreCaseAndActivoTrue(String marca);
    
    // Productos perecederos
    List<Producto> findByEsPerecederoTrueAndActivoTrue();
    
    // Productos que requieren refrigeración
    List<Producto> findByRequiereRefrigeracionTrueAndActivoTrue();
    
    // Valor total del inventario
    @Query("SELECT SUM(p.valorInventario) FROM Producto p WHERE p.activo = true")
    Double calcularValorTotalInventario();
    
    // Productos más vendidos (por fecha de última venta)
    @Query("SELECT p FROM Producto p WHERE p.fechaUltimaVenta IS NOT NULL AND p.activo = true ORDER BY p.fechaUltimaVenta DESC")
    List<Producto> findProductosMasVendidos();
}
