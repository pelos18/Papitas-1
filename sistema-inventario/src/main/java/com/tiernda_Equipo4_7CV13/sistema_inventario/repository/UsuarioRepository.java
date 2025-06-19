package com.tienda_Equipo4_7CV13.sistema_inventario.repository;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    
    // Buscar por nombre de usuario
    Optional<Usuario> findByNombreUsuario(String nombreUsuario);
    
    // Buscar por email
    Optional<Usuario> findByEmail(String email);
    
    // Buscar usuarios activos
    List<Usuario> findByActivoTrue();
    
    // Buscar por rol
    List<Usuario> findByRolAndActivoTrue(Usuario.RolUsuario rol);
    
    // Verificar si existe usuario
    boolean existsByNombreUsuario(String nombreUsuario);
    
    // Verificar si existe email
    boolean existsByEmail(String email);
    
    // Usuarios no bloqueados
    List<Usuario> findByCuentaBloqueadaFalseAndActivoTrue();
    
    // Contar usuarios por rol
    @Query("SELECT COUNT(u) FROM Usuario u WHERE u.rol = :rol AND u.activo = true")
    long countByRolAndActivoTrue(Usuario.RolUsuario rol);
}
