package com.tienda_Equipo4_7CV13.sistema_inventario.service;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Proveedor;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.ProveedorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProveedorService {

    @Autowired
    private ProveedorRepository proveedorRepository;

    // CRUD Básico
    public List<Proveedor> obtenerTodos() {
        return proveedorRepository.findAll();
    }

    public Optional<Proveedor> obtenerPorId(Long id) {
        return proveedorRepository.findById(id);
    }

    public Proveedor guardar(Proveedor proveedor) {
        return proveedorRepository.save(proveedor);
    }

    public void eliminar(Long id) {
        proveedorRepository.deleteById(id);
    }

    // Búsquedas específicas
    public List<Proveedor> buscarPorNombre(String nombre) {
        return proveedorRepository.findByNombreContainingIgnoreCase(nombre);
    }

    public Optional<Proveedor> buscarPorRfc(String rfc) {
        return proveedorRepository.findByRfc(rfc);
    }

    public List<Proveedor> obtenerActivos() {
        return proveedorRepository.findByActivoTrue();
    }

    // Activar/Desactivar proveedor
    public void cambiarEstado(Long proveedorId, boolean activo) {
        Optional<Proveedor> proveedorOpt = proveedorRepository.findById(proveedorId);
        if (proveedorOpt.isPresent()) {
            Proveedor proveedor = proveedorOpt.get();
            proveedor.setActivo(activo);
            proveedorRepository.save(proveedor);
        }
    }

    // Verificar si un proveedor tiene productos
    public boolean tieneProductos(Long proveedorId) {
        return proveedorRepository.countProductosByProveedor(proveedorId) > 0;
    }

    // Obtener proveedores con conteo de productos
    public List<Object[]> obtenerProveedoresConConteo() {
        return proveedorRepository.findProveedoresConConteoProductos();
    }
}
