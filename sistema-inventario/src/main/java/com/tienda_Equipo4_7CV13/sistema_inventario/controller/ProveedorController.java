package com.tienda_Equipo4_7CV13.sistema_inventario.controller;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Proveedor;
import com.tienda_Equipo4_7CV13.sistema_inventario.service.ProveedorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/proveedores")
@CrossOrigin(origins = "*")
public class ProveedorController {

    @Autowired
    private ProveedorService proveedorService;

    // CRUD Básico
    @GetMapping
    public ResponseEntity<List<Proveedor>> obtenerTodos() {
        List<Proveedor> proveedores = proveedorService.obtenerTodos();
        return ResponseEntity.ok(proveedores);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Proveedor> obtenerPorId(@PathVariable Long id) {
        Optional<Proveedor> proveedor = proveedorService.obtenerPorId(id);
        return proveedor.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Proveedor> crear(@RequestBody Proveedor proveedor) {
        Proveedor proveedorGuardado = proveedorService.guardar(proveedor);
        return ResponseEntity.ok(proveedorGuardado);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Proveedor> actualizar(@PathVariable Long id, @RequestBody Proveedor proveedor) {
        if (!proveedorService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        proveedor.setIdProveedor(id);
        Proveedor proveedorActualizado = proveedorService.guardar(proveedor);
        return ResponseEntity.ok(proveedorActualizado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> eliminar(@PathVariable Long id) {
        if (!proveedorService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        
        // Verificar si tiene productos
        if (proveedorService.tieneProductos(id)) {
            return ResponseEntity.badRequest().body("No se puede eliminar: el proveedor tiene productos asociados");
        }
        
        proveedorService.eliminar(id);
        return ResponseEntity.ok("Proveedor eliminado exitosamente");
    }

    // Búsquedas específicas
    @GetMapping("/buscar")
    public ResponseEntity<List<Proveedor>> buscarPorNombre(@RequestParam String nombre) {
        List<Proveedor> proveedores = proveedorService.buscarPorNombre(nombre);
        return ResponseEntity.ok(proveedores);
    }

    @GetMapping("/rfc/{rfc}")
    public ResponseEntity<Proveedor> buscarPorRfc(@PathVariable String rfc) {
        Optional<Proveedor> proveedor = proveedorService.buscarPorRfc(rfc);
        return proveedor.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/activos")
    public ResponseEntity<List<Proveedor>> obtenerActivos() {
        List<Proveedor> proveedores = proveedorService.obtenerActivos();
        return ResponseEntity.ok(proveedores);
    }

    // Cambiar estado
    @PutMapping("/{id}/estado")
    public ResponseEntity<Void> cambiarEstado(@PathVariable Long id, @RequestParam boolean activo) {
        if (!proveedorService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        proveedorService.cambiarEstado(id, activo);
        return ResponseEntity.ok().build();
    }

    // Proveedores con conteo de productos
    @GetMapping("/con-conteo")
    public ResponseEntity<List<Object[]>> obtenerProveedoresConConteo() {
        List<Object[]> proveedores = proveedorService.obtenerProveedoresConConteo();
        return ResponseEntity.ok(proveedores);
    }
}
