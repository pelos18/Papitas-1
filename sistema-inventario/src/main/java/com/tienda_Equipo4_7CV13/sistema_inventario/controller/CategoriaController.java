package com.tienda_Equipo4_7CV13.sistema_inventario.controller;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Categoria;
import com.tienda_Equipo4_7CV13.sistema_inventario.service.CategoriaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/categorias")
@CrossOrigin(origins = "*")
public class CategoriaController {

    @Autowired
    private CategoriaService categoriaService;

    // CRUD Básico
    @GetMapping
    public ResponseEntity<List<Categoria>> obtenerTodas() {
        List<Categoria> categorias = categoriaService.obtenerTodas();
        return ResponseEntity.ok(categorias);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Categoria> obtenerPorId(@PathVariable Long id) {
        Optional<Categoria> categoria = categoriaService.obtenerPorId(id);
        return categoria.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Categoria> crear(@RequestBody Categoria categoria) {
        Categoria categoriaGuardada = categoriaService.guardar(categoria);
        return ResponseEntity.ok(categoriaGuardada);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Categoria> actualizar(@PathVariable Long id, @RequestBody Categoria categoria) {
        if (!categoriaService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        categoria.setIdCategoria(id);
        Categoria categoriaActualizada = categoriaService.guardar(categoria);
        return ResponseEntity.ok(categoriaActualizada);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> eliminar(@PathVariable Long id) {
        if (!categoriaService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        
        // Verificar si tiene productos
        if (categoriaService.tieneProductos(id)) {
            return ResponseEntity.badRequest().body("No se puede eliminar: la categoría tiene productos asociados");
        }
        
        categoriaService.eliminar(id);
        return ResponseEntity.ok("Categoría eliminada exitosamente");
    }

    // Búsquedas específicas
    @GetMapping("/buscar")
    public ResponseEntity<List<Categoria>> buscarPorNombre(@RequestParam String nombre) {
        List<Categoria> categorias = categoriaService.buscarPorNombre(nombre);
        return ResponseEntity.ok(categorias);
    }

    @GetMapping("/activas")
    public ResponseEntity<List<Categoria>> obtenerActivas() {
        List<Categoria> categorias = categoriaService.obtenerActivas();
        return ResponseEntity.ok(categorias);
    }

    // Cambiar estado
    @PutMapping("/{id}/estado")
    public ResponseEntity<Void> cambiarEstado(@PathVariable Long id, @RequestParam boolean activo) {
        if (!categoriaService.obtenerPorId(id).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        categoriaService.cambiarEstado(id, activo);
        return ResponseEntity.ok().build();
    }

    // Categorías con conteo de productos
    @GetMapping("/con-conteo")
    public ResponseEntity<List<Object[]>> obtenerCategoriasConConteo() {
        List<Object[]> categorias = categoriaService.obtenerCategoriasConConteo();
        return ResponseEntity.ok(categorias);
    }
}
