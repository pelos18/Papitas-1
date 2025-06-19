package com.tienda_Equipo4_7CV13.sistema_inventario.service;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Usuario;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // CRUD Básico
    public List<Usuario> obtenerTodos() {
        return usuarioRepository.findAll();
    }

    public Optional<Usuario> obtenerPorId(Long id) {
        return usuarioRepository.findById(id);
    }

    public Usuario guardar(Usuario usuario) {
        // Encriptar contraseña si es nueva
        if (usuario.getPassword() != null && !usuario.getPassword().isEmpty()) {
            usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        }
        return usuarioRepository.save(usuario);
    }

    public void eliminar(Long id) {
        usuarioRepository.deleteById(id);
    }

    // Búsquedas específicas
    public Optional<Usuario> buscarPorNombreUsuario(String nombreUsuario) {
        return usuarioRepository.findByNombreUsuario(nombreUsuario);
    }

    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioRepository.findByEmail(email);
    }

    public List<Usuario> obtenerPorRol(String rol) {
        // Convertir String a RolUsuario enum
        try {
            RolUsuario rolEnum = RolUsuario.valueOf(rol.toUpperCase());
            return usuarioRepository.findByRol(rolEnum);
        } catch (IllegalArgumentException e) {
            return List.of(); // Retornar lista vacía si el rol no existe
        }
    }

    public List<Usuario> obtenerActivos() {
        return usuarioRepository.findByActivoTrue();
    }

    // Autenticación
    public boolean validarCredenciales(String nombreUsuario, String password) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByNombreUsuario(nombreUsuario);
        
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            return usuario.getActivo() && passwordEncoder.matches(password, usuario.getPassword());
        }
        
        return false;
    }

    // Cambiar contraseña
    public boolean cambiarPassword(Long usuarioId, String passwordActual, String passwordNuevo) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findById(usuarioId);
        
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            
            if (passwordEncoder.matches(passwordActual, usuario.getPassword())) {
                usuario.setPassword(passwordEncoder.encode(passwordNuevo));
                usuarioRepository.save(usuario);
                return true;
            }
        }
        
        return false;
    }

    // Activar/Desactivar usuario
    public void cambiarEstado(Long usuarioId, boolean activo) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findById(usuarioId);
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            usuario.setActivo(activo);
            usuarioRepository.save(usuario);
        }
    }

    // Verificar permisos por rol
    public boolean tienePermiso(String nombreUsuario, String permiso) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByNombreUsuario(nombreUsuario);
        
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            String rol = usuario.getRol().name();
            
            // Lógica de permisos por rol
            switch (rol) {
                case "DUEÑO":
                    return true; // El dueño tiene todos los permisos
                case "ADMINISTRADOR":
                    return !permiso.equals("ELIMINAR_USUARIOS"); // Admin no puede eliminar usuarios
                case "EMPLEADO":
                    return permiso.equals("VER_PRODUCTOS") || permiso.equals("VENDER");
                case "CAJERO":
                    return permiso.equals("VER_PRODUCTOS") || permiso.equals("VENDER") || permiso.equals("CAJA");
                default:
                    return false;
            }
        }
        
        return false;
    }
}
