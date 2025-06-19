package com.tienda_Equipo4_7CV13.sistema_inventario.controller;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Producto;
import com.tienda_Equipo4_7CV13.sistema_inventario.service.InventarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/inventario")
@CrossOrigin(origins = "*")
public class InventarioController {

    @Autowired
    private InventarioService inventarioService;

    // Valor total del inventario
    @GetMapping("/valor-total")
    public ResponseEntity<BigDecimal> obtenerValorTotal() {
        BigDecimal valorTotal = inventarioService.calcularValorTotalInventario();
        return ResponseEntity.ok(valorTotal);
    }

    // Estadísticas del inventario
    @GetMapping("/estadisticas")
    public ResponseEntity<Map<String, Object>> obtenerEstadisticas() {
        Map<String, Object> estadisticas = inventarioService.obtenerEstadisticasInventario();
        return ResponseEntity.ok(estadisticas);
    }

    // Productos que requieren atención
    @GetMapping("/atencion")
    public ResponseEntity<Map<String, List<Producto>>> obtenerProductosAtencion() {
        Map<String, List<Producto>> productos = inventarioService.obtenerProductosAtencion();
        return ResponseEntity.ok(productos);
    }

    // Recalcular valores de inventario
    @PostMapping("/recalcular")
    public ResponseEntity<String> recalcularValores() {
        inventarioService.recalcularValoresInventario();
        return ResponseEntity.ok("Valores de inventario recalculados exitosamente");
    }

    // Registrar movimiento
    @PostMapping("/movimiento")
    public ResponseEntity<String> registrarMovimiento(
            @RequestParam Long productoId,
            @RequestParam Integer cantidad,
            @RequestParam String tipoMovimiento) {
        try {
            inventarioService.registrarMovimiento(productoId, cantidad, tipoMovimiento);
            return ResponseEntity.ok("Movimiento registrado exitosamente");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
