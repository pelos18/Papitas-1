package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    
    // Buscar por nombre
    Optional<Categoria> findByNombre(String nombre);
    
    // Buscar categorías activas
    List<Categoria> findByActivoTrue();
    
    // Buscar por nombre (contiene)
    List<Categoria> findByNombreContainingIgnoreCaseAndActivoTrue(String nombre);
    
    // Verificar si existe
    boolean existsByNombre(String nombre);
    
    // Contar productos por categoría
    @Query("SELECT COUNT(p) FROM Producto p WHERE p.categoria.idCategoria = :idCategoria AND p.activo = true")
    long countProductosByCategoria(Long idCategoria);
}
