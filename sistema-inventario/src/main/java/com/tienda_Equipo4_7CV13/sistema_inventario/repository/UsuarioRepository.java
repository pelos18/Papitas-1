package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Usuario;
import com.tienda_Equipo4_7CV13.sistema_inventario.entity.RolUsuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    
    Optional<Usuario> findByNombreUsuario(String nombreUsuario);
    
    Optional<Usuario> findByEmail(String email);
    
    List<Usuario> findByRol(RolUsuario rol);
    
    List<Usuario> findByActivoTrue();
    
    List<Usuario> findByActivoFalse();
    
    @Query("SELECT u FROM Usuario u WHERE u.nombreCompleto LIKE %:nombre%")
    List<Usuario> findByNombreCompletoContaining(String nombre);
    
    @Query("SELECT COUNT(u) FROM Usuario u WHERE u.activo = true")
    long countUsuariosActivos();
    
    @Query("SELECT COUNT(u) FROM Usuario u WHERE u.rol = :rol")
    long countByRol(RolUsuario rol);
    
    boolean existsByNombreUsuario(String nombreUsuario);
    
    boolean existsByEmail(String email);
}
