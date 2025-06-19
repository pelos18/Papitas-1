package com.tienda_Equipo4_7CV13.sistema_inventario.service;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.RolUsuario;
import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Producto;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;

@Service
public class ProductoService {

    @Autowired
    private ProductoRepository productoRepository;

    // CRUD Básico
    public List<Producto> obtenerTodos() {
        return productoRepository.findAll();
    }

    public Page<Producto> obtenerTodosPaginados(Pageable pageable) {
        return productoRepository.findAll(pageable);
    }

    public Optional<Producto> obtenerPorId(Long id) {
        return productoRepository.findById(id);
    }

    public Producto guardar(Producto producto) {
        // Calcular valores automáticamente
        calcularValores(producto);
        return productoRepository.save(producto);
    }

    public void eliminar(Long id) {
        productoRepository.deleteById(id);
    }

    // Búsquedas específicas
    public List<Producto> buscarPorNombre(String nombre) {
        return productoRepository.findByNombreContainingIgnoreCase(nombre);
    }

    public List<Producto> buscarPorCodigoBarras(String codigoBarras) {
        Optional<Producto> producto = productoRepository.findByCodigoBarras(codigoBarras);
        return producto.map(List::of).orElse(List.of());
    }

    public List<Producto> obtenerPorCategoria(Long categoriaId) {
        return productoRepository.findByCategoriaId(categoriaId);
    }

    public List<Producto> obtenerPorProveedor(Long proveedorId) {
        return productoRepository.findByProveedorId(proveedorId);
    }

    // Control de stock
    public List<Producto> obtenerStockBajo() {
        return productoRepository.findStockBajo();
    }

    public List<Producto> obtenerProximosVencer() {
        return productoRepository.findProximosVencer();
    }

    // Productos activos/inactivos
    public List<Producto> obtenerActivos() {
        return productoRepository.findByActivoTrue();
    }

    public List<Producto> obtenerEnPromocion() {
        return productoRepository.findByEnPromocionTrue();
    }

    // Cálculos automáticos
    private void calcularValores(Producto producto) {
        // Calcular costo total
        BigDecimal costoTotal = producto.getCostoBase().add(producto.getGastosAdicionales());
        producto.setCostoTotal(costoTotal);

        // Calcular precio sugerido
        BigDecimal precioSugerido = costoTotal.multiply(
            BigDecimal.ONE.add(producto.getMargenGanancia().divide(BigDecimal.valueOf(100)))
        );
        producto.setPrecioSugerido(precioSugerido);

        // Calcular ganancia unitaria
        BigDecimal gananciaUnitaria = producto.getPrecioVenta().subtract(costoTotal);
        producto.setGananciaUnitaria(gananciaUnitaria);

        // Calcular margen real
        if (producto.getPrecioVenta().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal margenReal = gananciaUnitaria.divide(producto.getPrecioVenta(), 4, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100));
            producto.setMargenReal(margenReal);
        }

        // Calcular valor inventario
        BigDecimal valorInventario = costoTotal.multiply(BigDecimal.valueOf(producto.getStockActual()));
        producto.setValorInventario(valorInventario);
    }

    // Actualizar stock
    public void actualizarStock(Long productoId, Integer nuevoStock) {
        Optional<Producto> productoOpt = productoRepository.findById(productoId);
        if (productoOpt.isPresent()) {
            Producto producto = productoOpt.get();
            producto.setStockActual(nuevoStock);
            calcularValores(producto);
            productoRepository.save(producto);
        }
    }

    // Activar/Desactivar producto
    public void cambiarEstado(Long productoId, boolean activo) {
        Optional<Producto> productoOpt = productoRepository.findById(productoId);
        if (productoOpt.isPresent()) {
            Producto producto = productoOpt.get();
            producto.setActivo(activo ? 1 : 0);
            productoRepository.save(producto);
        }
    }
}
