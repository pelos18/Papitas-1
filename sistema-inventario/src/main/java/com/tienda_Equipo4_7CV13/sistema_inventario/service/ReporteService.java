package com.tienda_Equipo4_7CV13.sistema_inventario.service;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Producto;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class ReporteService {

    @Autowired
    private ProductoRepository productoRepository;

    // Generar reporte de inventario completo
    public Map<String, Object> generarReporteInventario() {
        Map<String, Object> reporte = new HashMap<>();
        
        List<Producto> productos = productoRepository.findByActivoTrue();
        
        // Información general
        reporte.put("fechaGeneracion", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        reporte.put("totalProductos", productos.size());
        
        // Calcular valor total
        BigDecimal valorTotal = productos.stream()
            .map(Producto::getValorInventario)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        reporte.put("valorTotalInventario", valorTotal);
        
        // Productos
        reporte.put("productos", productos);
        
        // Estadísticas adicionales
        long stockBajo = productoRepository.findStockBajo().size();
        long proximosVencer = productoRepository.findProximosVencer().size();
        long enPromocion = productoRepository.findByEnPromocionTrue().size();
        
        reporte.put("productosStockBajo", stockBajo);
        reporte.put("productosProximosVencer", proximosVencer);
        reporte.put("productosEnPromocion", enPromocion);
        
        return reporte;
    }

    // Generar reporte por categoría
    public Map<String, Object> generarReportePorCategoria(Long categoriaId) {
        Map<String, Object> reporte = new HashMap<>();
        
        List<Producto> productos = productoRepository.findByCategoriaId(categoriaId);
        
        reporte.put("fechaGeneracion", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        reporte.put("categoriaId", categoriaId);
        reporte.put("totalProductos", productos.size());
        
        BigDecimal valorTotal = productos.stream()
            .map(Producto::getValorInventario)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        reporte.put("valorTotalCategoria", valorTotal);
        
        reporte.put("productos", productos);
        
        return reporte;
    }

    // Generar reporte de productos con stock bajo
    public Map<String, Object> generarReporteStockBajo() {
        Map<String, Object> reporte = new HashMap<>();
        
        List<Producto> productos = productoRepository.findStockBajo();
        
        reporte.put("fechaGeneracion", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        reporte.put("tipoReporte", "Stock Bajo");
        reporte.put("totalProductos", productos.size());
        reporte.put("productos", productos);
        
        return reporte;
    }

    // Generar reporte de productos próximos a vencer
    public Map<String, Object> generarReporteProximosVencer() {
        Map<String, Object> reporte = new HashMap<>();
        
        List<Producto> productos = productoRepository.findProximosVencer();
        
        reporte.put("fechaGeneracion", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        reporte.put("tipoReporte", "Próximos a Vencer");
        reporte.put("totalProductos", productos.size());
        reporte.put("productos", productos);
        
        return reporte;
    }

    // Generar datos para PDF (formato simplificado)
    public List<Map<String, Object>> generarDatosParaPDF() {
        List<Producto> productos = productoRepository.findByActivoTrue();
        
        return productos.stream()
            .map(producto -> {
                Map<String, Object> item = new HashMap<>();
                item.put("codigo", producto.getCodigoBarras());
                item.put("nombre", producto.getNombre());
                item.put("categoria", producto.getCategoria() != null ? producto.getCategoria().getNombre() : "Sin categoría");
                item.put("stock", producto.getStockActual());
                item.put("precioVenta", producto.getPrecioVenta());
                item.put("valorInventario", producto.getValorInventario());
                return item;
            })
            .toList();
    }

    // Generar resumen ejecutivo
    public Map<String, Object> generarResumenEjecutivo() {
        Map<String, Object> resumen = new HashMap<>();
        
        List<Producto> todosProductos = productoRepository.findAll();
        List<Producto> productosActivos = productoRepository.findByActivoTrue();
        
        // Totales
        resumen.put("totalProductosRegistrados", todosProductos.size());
        resumen.put("totalProductosActivos", productosActivos.size());
        
        // Valor inventario
        BigDecimal valorTotal = productosActivos.stream()
            .map(Producto::getValorInventario)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        resumen.put("valorTotalInventario", valorTotal);
        
        // Alertas
        resumen.put("productosStockBajo", productoRepository.findStockBajo().size());
        resumen.put("productosProximosVencer", productoRepository.findProximosVencer().size());
        resumen.put("productosEnPromocion", productoRepository.findByEnPromocionTrue().size());
        
        // Fecha
        resumen.put("fechaGeneracion", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        
        return resumen;
    }
}
