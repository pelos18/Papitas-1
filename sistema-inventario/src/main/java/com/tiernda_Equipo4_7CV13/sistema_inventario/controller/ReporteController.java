package com.tienda_Equipo4_7CV13.sistema_inventario.controller;

import com.tienda_Equipo4_7CV13.sistema_inventario.service.ReporteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reportes")
@CrossOrigin(origins = "*")
public class ReporteController {

    @Autowired
    private ReporteService reporteService;

    // Reporte de inventario completo
    @GetMapping("/inventario")
    public ResponseEntity<Map<String, Object>> generarReporteInventario() {
        Map<String, Object> reporte = reporteService.generarReporteInventario();
        return ResponseEntity.ok(reporte);
    }

    // Reporte por categoría
    @GetMapping("/categoria/{categoriaId}")
    public ResponseEntity<Map<String, Object>> generarReportePorCategoria(@PathVariable Long categoriaId) {
        Map<String, Object> reporte = reporteService.generarReportePorCategoria(categoriaId);
        return ResponseEntity.ok(reporte);
    }

    // Reporte de stock bajo
    @GetMapping("/stock-bajo")
    public ResponseEntity<Map<String, Object>> generarReporteStockBajo() {
        Map<String, Object> reporte = reporteService.generarReporteStockBajo();
        return ResponseEntity.ok(reporte);
    }

    // Reporte de próximos a vencer
    @GetMapping("/proximos-vencer")
    public ResponseEntity<Map<String, Object>> generarReporteProximosVencer() {
        Map<String, Object> reporte = reporteService.generarReporteProximosVencer();
        return ResponseEntity.ok(reporte);
    }

    // Datos para PDF
    @GetMapping("/pdf-data")
    public ResponseEntity<List<Map<String, Object>>> generarDatosParaPDF() {
        List<Map<String, Object>> datos = reporteService.generarDatosParaPDF();
        return ResponseEntity.ok(datos);
    }

    // Resumen ejecutivo
    @GetMapping("/resumen")
    public ResponseEntity<Map<String, Object>> generarResumenEjecutivo() {
        Map<String, Object> resumen = reporteService.generarResumenEjecutivo();
        return ResponseEntity.ok(resumen);
    }
}
