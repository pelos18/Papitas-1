package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    
    List<Categoria> findByNombreContainingIgnoreCase(String nombre);
    
    List<Categoria> findByActivoTrue();
    
    @Query("SELECT c FROM Categoria c WHERE c.activo = 1")
    List<Categoria> findCategoriasActivas();
    
    @Query("SELECT c, COUNT(p) FROM Categoria c LEFT JOIN Producto p ON c.idCategoria = p.categoria.idCategoria GROUP BY c")
    List<Object[]> findCategoriasConConteoProductos();
    
    @Query("SELECT COUNT(c) FROM Categoria c WHERE c.activo = 1")
    long countCategoriasActivas();
    
    boolean existsByNombre(String nombre);
}
