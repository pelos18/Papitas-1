package com.tienda_Equipo4_7CV13.sistema_inventario.controller;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Producto;
import com.tienda_Equipo4_7CV13.sistema_inventario.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/productos")
@CrossOrigin(origins = "*")
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    // CRUD Básico
    @GetMapping
    public ResponseEntity<List<Producto>> obtenerTodos() {
        List<Producto> productos = productoService.obtenerTodos();
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/paginados")
    public ResponseEntity<Page<Producto>> obtenerTodosPaginados(Pageable pageable) {
        Page<Producto> productos = productoService.obtenerTodosPaginados(pageable);
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Producto> obtenerPorId(@PathVariable Long id) {
        Optional<Producto> producto = productoService.obtenerPorId(id);
        return producto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Producto> crear(@RequestBody Producto producto) {
        Producto productoGuardado = productoService.guardar(producto);
        return ResponseEntity.ok(productoGuardado);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Producto> actualizar(@PathVariable Long id, @RequestBody Producto producto) {
        if (!productoService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        producto.setIdProducto(id);
        Producto productoActualizado = productoService.guardar(producto);
        return ResponseEntity.ok(productoActualizado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        if (!productoService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        productoService.eliminar(id);
        return ResponseEntity.ok().build();
    }

    // Búsquedas específicas
    @GetMapping("/buscar/nombre")
    public ResponseEntity<List<Producto>> buscarPorNombre(@RequestParam String nombre) {
        List<Producto> productos = productoService.buscarPorNombre(nombre);
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/buscar/codigo")
    public ResponseEntity<List<Producto>> buscarPorCodigo(@RequestParam String codigo) {
        List<Producto> productos = productoService.buscarPorCodigoBarras(codigo);
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/categoria/{categoriaId}")
    public ResponseEntity<List<Producto>> obtenerPorCategoria(@PathVariable Long categoriaId) {
        List<Producto> productos = productoService.obtenerPorCategoria(categoriaId);
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/proveedor/{proveedorId}")
    public ResponseEntity<List<Producto>> obtenerPorProveedor(@PathVariable Long proveedorId) {
        List<Producto> productos = productoService.obtenerPorProveedor(proveedorId);
        return ResponseEntity.ok(productos);
    }

    // Control de stock
    @GetMapping("/stock-bajo")
    public ResponseEntity<List<Producto>> obtenerStockBajo() {
        List<Producto> productos = productoService.obtenerStockBajo();
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/proximos-vencer")
    public ResponseEntity<List<Producto>> obtenerProximosVencer() {
        List<Producto> productos = productoService.obtenerProximosVencer();
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/activos")
    public ResponseEntity<List<Producto>> obtenerActivos() {
        List<Producto> productos = productoService.obtenerActivos();
        return ResponseEntity.ok(productos);
    }

    @GetMapping("/promocion")
    public ResponseEntity<List<Producto>> obtenerEnPromocion() {
        List<Producto> productos = productoService.obtenerEnPromocion();
        return ResponseEntity.ok(productos);
    }

    // Actualizar stock
    @PutMapping("/{id}/stock")
    public ResponseEntity<Void> actualizarStock(@PathVariable Long id, @RequestParam Integer nuevoStock) {
        if (!productoService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        productoService.actualizarStock(id, nuevoStock);
        return ResponseEntity.ok().build();
    }

    // Cambiar estado
    @PutMapping("/{id}/estado")
    public ResponseEntity<Void> cambiarEstado(@PathVariable Long id, @RequestParam boolean activo) {
        if (!productoService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        productoService.cambiarEstado(id, activo);
        return ResponseEntity.ok().build();
    }
}
