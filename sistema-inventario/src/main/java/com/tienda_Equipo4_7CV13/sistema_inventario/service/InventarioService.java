package com.tienda_Equipo4_7CV13.sistema_inventario.service;


import com.tienda_Equipo4_7CV13.sistema_inventario.entity.RolUsuario;
import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Producto;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class InventarioService {

    @Autowired
    private ProductoRepository productoRepository;

    // Valor total del inventario
    public BigDecimal calcularValorTotalInventario() {
        List<Producto> productos = productoRepository.findByActivoTrue();
        return productos.stream()
            .map(Producto::getValorInventario)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Estadísticas del inventario
    public Map<String, Object> obtenerEstadisticasInventario() {
        Map<String, Object> estadisticas = new HashMap<>();
        
        List<Producto> productosActivos = productoRepository.findByActivoTrue();
        
        // Totales
        estadisticas.put("totalProductos", productosActivos.size());
        estadisticas.put("valorTotalInventario", calcularValorTotalInventario());
        
        // Stock
        long productosStockBajo = productoRepository.findStockBajo().size();
        estadisticas.put("productosStockBajo", productosStockBajo);
        
        // Próximos a vencer
        long proximosVencer = productoRepository.findProximosVencer().size();
        estadisticas.put("proximosVencer", proximosVencer);
        
        // En promoción
        long enPromocion = productoRepository.findByEnPromocionTrue().size();
        estadisticas.put("enPromocion", enPromocion);
        
        return estadisticas;
    }

    // Productos que requieren atención
    public Map<String, List<Producto>> obtenerProductosAtencion() {
        Map<String, List<Producto>> atencion = new HashMap<>();
        
        atencion.put("stockBajo", productoRepository.findStockBajo());
        atencion.put("proximosVencer", productoRepository.findProximosVencer());
        
        return atencion;
    }

    // Actualizar todos los valores de inventario
    public void recalcularValoresInventario() {
        List<Producto> productos = productoRepository.findAll();
        
        for (Producto producto : productos) {
            BigDecimal valorInventario = producto.getCostoTotal()
                .multiply(BigDecimal.valueOf(producto.getStockActual()));
            producto.setValorInventario(valorInventario);
        }
        
        productoRepository.saveAll(productos);
    }

    // Movimiento de inventario (entrada/salida)
    public void registrarMovimiento(Long productoId, Integer cantidad, String tipoMovimiento) {
        Producto producto = productoRepository.findById(productoId)
            .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        
        if ("ENTRADA".equals(tipoMovimiento)) {
            producto.setStockActual(producto.getStockActual() + cantidad);
        } else if ("SALIDA".equals(tipoMovimiento)) {
            if (producto.getStockActual() >= cantidad) {
                producto.setStockActual(producto.getStockActual() - cantidad);
            } else {
                throw new RuntimeException("Stock insuficiente");
            }
        }
        
        // Recalcular valor inventario
        BigDecimal valorInventario = producto.getCostoTotal()
            .multiply(BigDecimal.valueOf(producto.getStockActual()));
        producto.setValorInventario(valorInventario);
        
        productoRepository.save(producto);
    }
}
