package com.tienda_Equipo4_7CV13.sistema_inventario.service;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Categoria;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoriaService {

    @Autowired
    private CategoriaRepository categoriaRepository;

    // CRUD Básico
    public List<Categoria> obtenerTodas() {
        return categoriaRepository.findAll();
    }

    public Optional<Categoria> obtenerPorId(Long id) {
        return categoriaRepository.findById(id);
    }

    public Categoria guardar(Categoria categoria) {
        return categoriaRepository.save(categoria);
    }

    public void eliminar(Long id) {
        categoriaRepository.deleteById(id);
    }

    // Búsquedas específicas
    public List<Categoria> buscarPorNombre(String nombre) {
        return categoriaRepository.findByNombreContainingIgnoreCase(nombre);
    }

    public List<Categoria> obtenerActivas() {
        return categoriaRepository.findByActivoTrue();
    }

    // Activar/Desactivar categoría
    public void cambiarEstado(Long categoriaId, boolean activo) {
        Optional<Categoria> categoriaOpt = categoriaRepository.findById(categoriaId);
        if (categoriaOpt.isPresent()) {
            Categoria categoria = categoriaOpt.get();
            categoria.setActivo(activo);
            categoriaRepository.save(categoria);
        }
    }

    // Verificar si una categoría tiene productos
    public boolean tieneProductos(Long categoriaId) {
        return categoriaRepository.countProductosByCategoria(categoriaId) > 0;
    }

    // Obtener categorías con conteo de productos
    public List<Object[]> obtenerCategoriasConConteo() {
        return categoriaRepository.findCategoriasConConteoProductos();
    }
}
