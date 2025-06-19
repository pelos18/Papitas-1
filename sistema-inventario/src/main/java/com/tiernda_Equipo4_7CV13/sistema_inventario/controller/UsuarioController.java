package com.tienda_Equipo4_7CV13.sistema_inventario.controller;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Usuario;
import com.tienda_Equipo4_7CV13.sistema_inventario.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    // CRUD Básico
    @GetMapping
    public ResponseEntity<List<Usuario>> obtenerTodos() {
        List<Usuario> usuarios = usuarioService.obtenerTodos();
        // Ocultar contraseñas en la respuesta
        usuarios.forEach(usuario -> usuario.setPassword(null));
        return ResponseEntity.ok(usuarios);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> obtenerPorId(@PathVariable Long id) {
        Optional<Usuario> usuario = usuarioService.obtenerPorId(id);
        if (usuario.isPresent()) {
            usuario.get().setPassword(null); // Ocultar contraseña
            return ResponseEntity.ok(usuario.get());
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Usuario> crear(@RequestBody Usuario usuario) {
        Usuario usuarioGuardado = usuarioService.guardar(usuario);
        usuarioGuardado.setPassword(null); // Ocultar contraseña en respuesta
        return ResponseEntity.ok(usuarioGuardado);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Usuario> actualizar(@PathVariable Long id, @RequestBody Usuario usuario) {
        if (!usuarioService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        usuario.setIdUsuario(id);
        Usuario usuarioActualizado = usuarioService.guardar(usuario);
        usuarioActualizado.setPassword(null); // Ocultar contraseña
        return ResponseEntity.ok(usuarioActualizado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        if (!usuarioService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        usuarioService.eliminar(id);
        return ResponseEntity.ok().build();
    }

    // Búsquedas específicas
    @GetMapping("/buscar/usuario")
    public ResponseEntity<Usuario> buscarPorNombreUsuario(@RequestParam String nombreUsuario) {
        Optional<Usuario> usuario = usuarioService.buscarPorNombreUsuario(nombreUsuario);
        if (usuario.isPresent()) {
            usuario.get().setPassword(null);
            return ResponseEntity.ok(usuario.get());
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/rol/{rol}")
    public ResponseEntity<List<Usuario>> obtenerPorRol(@PathVariable String rol) {
        List<Usuario> usuarios = usuarioService.obtenerPorRol(rol);
        usuarios.forEach(usuario -> usuario.setPassword(null));
        return ResponseEntity.ok(usuarios);
    }

    @GetMapping("/activos")
    public ResponseEntity<List<Usuario>> obtenerActivos() {
        List<Usuario> usuarios = usuarioService.obtenerActivos();
        usuarios.forEach(usuario -> usuario.setPassword(null));
        return ResponseEntity.ok(usuarios);
    }

    // Autenticación
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> credentials) {
        String nombreUsuario = credentials.get("nombreUsuario");
        String password = credentials.get("password");
        
        boolean valido = usuarioService.validarCredenciales(nombreUsuario, password);
        
        Map<String, Object> response = new HashMap<>();
        if (valido) {
            Optional<Usuario> usuario = usuarioService.buscarPorNombreUsuario(nombreUsuario);
            if (usuario.isPresent()) {
                usuario.get().setPassword(null);
                response.put("success", true);
                response.put("usuario", usuario.get());
                response.put("mensaje", "Login exitoso");
                return ResponseEntity.ok(response);
            }
        }
        
        response.put("success", false);
        response.put("mensaje", "Credenciales inválidas");
        return ResponseEntity.badRequest().body(response);
    }

    // Cambiar contraseña
    @PostMapping("/{id}/cambiar-password")
    public ResponseEntity<Map<String, String>> cambiarPassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> passwords) {
        
        String passwordActual = passwords.get("passwordActual");
        String passwordNuevo = passwords.get("passwordNuevo");
        
        Map<String, String> response = new HashMap<>();
        boolean cambiado = usuarioService.cambiarPassword(id, passwordActual, passwordNuevo);
        
        if (cambiado) {
            response.put("mensaje", "Contraseña cambiada exitosamente");
            return ResponseEntity.ok(response);
        } else {
            response.put("mensaje", "Contraseña actual incorrecta");
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Cambiar estado
    @PutMapping("/{id}/estado")
    public ResponseEntity<Void> cambiarEstado(@PathVariable Long id, @RequestParam boolean activo) {
        if (!usuarioService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        usuarioService.cambiarEstado(id, activo);
        return ResponseEntity.ok().build();
    }

    // Verificar permisos
    @GetMapping("/{nombreUsuario}/permisos/{permiso}")
    public ResponseEntity<Map<String, Boolean>> verificarPermiso(
            @PathVariable String nombreUsuario,
            @PathVariable String permiso) {
        
        boolean tienePermiso = usuarioService.tienePermiso(nombreUsuario, permiso);
        Map<String, Boolean> response = new HashMap<>();
        response.put("tienePermiso", tienePermiso);
        return ResponseEntity.ok(response);
    }
}
