package com.tienda_Equipo4_7CV13.sistema_inventario.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.tienda_Equipo4_7CV13.sistema_inventario.dto.ProductoDTO;
import com.tienda_Equipo4_7CV13.sistema_inventario.dto.ProductoPublicoDTO;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Component
public class PdfGenerator {

    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
    private static final Font HEADER_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
    private static final Font NORMAL_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);

    public byte[] generarReporteProductosCompleto(List<ProductoDTO> productos, String usuarioRol) throws DocumentException, IOException {
        Document document = new Document(PageSize.A4.rotate()); // Horizontal para más columnas
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        
        PdfWriter.getInstance(document, out);
        document.open();

        // Título
        Paragraph title = new Paragraph("REPORTE COMPLETO DE PRODUCTOS - LA MODERNA", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Información del reporte
        Paragraph info = new Paragraph();
        info.add(new Chunk("Fecha de generación: ", HEADER_FONT));
        info.add(new Chunk(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")), NORMAL_FONT));
        info.add(Chunk.NEWLINE);
        info.add(new Chunk("Total de productos: ", HEADER_FONT));
        info.add(new Chunk(String.valueOf(productos.size()), NORMAL_FONT));
        info.add(Chunk.NEWLINE);
        info.add(new Chunk("Generado por rol: ", HEADER_FONT));
        info.add(new Chunk(usuarioRol.toUpperCase(), NORMAL_FONT));
        info.setSpacingAfter(20);
        document.add(info);

        // Tabla de productos
        PdfPTable table;
        if ("DUENO".equals(usuarioRol)) {
            table = crearTablaProductosCompleta(productos);
        } else {
            table = crearTablaProductosPublica(convertirAPublico(productos));
        }
        
        document.add(table);

        // Resumen final
        if ("DUENO".equals(usuarioRol)) {
            document.add(crearResumenFinanciero(productos));
        }

        document.close();
        return out.toByteArray();
    }

    public byte[] generarReporteProductosPublico(List<ProductoPublicoDTO> productos) throws DocumentException, IOException {
        Document document = new Document(PageSize.A4);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        
        PdfWriter.getInstance(document, out);
        document.open();

        // Título
        Paragraph title = new Paragraph("CATÁLOGO DE PRODUCTOS - LA MODERNA", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Información del reporte
        Paragraph info = new Paragraph();
        info.add(new Chunk("Fecha: ", HEADER_FONT));
        info.add(new Chunk(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")), NORMAL_FONT));
        info.add(Chunk.NEWLINE);
        info.add(new Chunk("Total de productos: ", HEADER_FONT));
        info.add(new Chunk(String.valueOf(productos.size()), NORMAL_FONT));
        info.setSpacingAfter(20);
        document.add(info);

        // Tabla de productos públicos
        PdfPTable table = crearTablaProductosPublica(productos);
        document.add(table);

        document.close();
        return out.toByteArray();
    }

    private PdfPTable crearTablaProductosCompleta(List<ProductoDTO> productos) throws DocumentException {
        PdfPTable table = new PdfPTable(12); // 12 columnas para datos completos
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        // Headers
        String[] headers = {"Código", "Nombre", "Marca", "Stock", "Precio Venta", 
                           "Costo Base", "Costo Total", "Ganancia", "Margen %", 
                           "Valor Inv.", "Categoría", "Estado"};
        
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, HEADER_FONT));
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        // Datos
        for (ProductoDTO producto : productos) {
            table.addCell(new Phrase(producto.getCodigoBarras() != null ? producto.getCodigoBarras() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getNombre() != null ? producto.getNombre() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getMarca() != null ? producto.getMarca() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getStockActual() != null ? producto.getStockActual().toString() : "0", NORMAL_FONT));
            table.addCell(new Phrase(formatearMoneda(producto.getPrecioVenta()), NORMAL_FONT));
            table.addCell(new Phrase(formatearMoneda(producto.getCostoBase()), NORMAL_FONT));
            table.addCell(new Phrase(formatearMoneda(producto.getCostoTotal()), NORMAL_FONT));
            table.addCell(new Phrase(formatearMoneda(producto.getGananciaUnitaria()), NORMAL_FONT));
            table.addCell(new Phrase(formatearPorcentaje(producto.getMargenReal()), NORMAL_FONT));
            table.addCell(new Phrase(formatearMoneda(producto.getValorInventario()), NORMAL_FONT));
            table.addCell(new Phrase(producto.getNombreCategoria() != null ? producto.getNombreCategoria() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getActivo() != null && producto.getActivo() ? "Activo" : "Inactivo", NORMAL_FONT));
        }

        return table;
    }

    private PdfPTable crearTablaProductosPublica(List<ProductoPublicoDTO> productos) throws DocumentException {
        PdfPTable table = new PdfPTable(7); // 7 columnas para datos públicos
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        // Headers
        String[] headers = {"Código", "Nombre", "Marca", "Stock", "Precio", "Categoría", "Ubicación"};
        
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, HEADER_FONT));
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        // Datos
        for (ProductoPublicoDTO producto : productos) {
            table.addCell(new Phrase(producto.getCodigoBarras() != null ? producto.getCodigoBarras() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getNombre() != null ? producto.getNombre() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getMarca() != null ? producto.getMarca() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getStockActual() != null ? producto.getStockActual().toString() : "0", NORMAL_FONT));
            table.addCell(new Phrase(formatearMoneda(producto.getPrecioVenta()), NORMAL_FONT));
            table.addCell(new Phrase(producto.getNombreCategoria() != null ? producto.getNombreCategoria() : "", NORMAL_FONT));
            table.addCell(new Phrase(producto.getUbicacionFisica() != null ? producto.getUbicacionFisica() : "", NORMAL_FONT));
        }

        return table;
    }

    private Paragraph crearResumenFinanciero(List<ProductoDTO> productos) {
        Paragraph resumen = new Paragraph();
        resumen.setSpacingBefore(20);
        resumen.add(new Chunk("RESUMEN FINANCIERO", HEADER_FONT));
        resumen.add(Chunk.NEWLINE);
        resumen.add(Chunk.NEWLINE);

        BigDecimal valorTotalInventario = productos.stream()
                .filter(p -> p.getValorInventario() != null)
                .map(ProductoDTO::getValorInventario)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal costoTotalInventario = productos.stream()
                .filter(p -> p.getCostoTotal() != null && p.getStockActual() != null)
                .map(p -> p.getCostoTotal().multiply(BigDecimal.valueOf(p.getStockActual())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        resumen.add(new Chunk("Valor total del inventario: ", NORMAL_FONT));
        resumen.add(new Chunk(formatearMoneda(valorTotalInventario), HEADER_FONT));
        resumen.add(Chunk.NEWLINE);
        resumen.add(new Chunk("Costo total del inventario: ", NORMAL_FONT));
        resumen.add(new Chunk(formatearMoneda(costoTotalInventario), HEADER_FONT));
        resumen.add(Chunk.NEWLINE);
        resumen.add(new Chunk("Ganancia potencial: ", NORMAL_FONT));
        resumen.add(new Chunk(formatearMoneda(valorTotalInventario.subtract(costoTotalInventario)), HEADER_FONT));

        return resumen;
    }

    private List<ProductoPublicoDTO> convertirAPublico(List<ProductoDTO> productos) {
        return productos.stream().map(this::convertirAPublico).toList();
    }

    private ProductoPublicoDTO convertirAPublico(ProductoDTO producto) {
        ProductoPublicoDTO publico = new ProductoPublicoDTO();
        publico.setIdProducto(producto.getIdProducto());
        publico.setCodigoBarras(producto.getCodigoBarras());
        publico.setNombre(producto.getNombre());
        publico.setDescripcion(producto.getDescripcion());
        publico.setMarca(producto.getMarca());
        publico.setPresentacion(producto.getPresentacion());
        publico.setPrecioVenta(producto.getPrecioVenta());
        publico.setStockActual(producto.getStockActual());
        publico.setFechaCaducidad(producto.getFechaCaducidad());
        publico.setUbicacionFisica(producto.getUbicacionFisica());
        publico.setRequiereRefrigeracion(producto.getRequiereRefrigeracion());
        publico.setEsPerecedero(producto.getEsPerecedero());
        publico.setEnPromocion(producto.getEnPromocion());
        publico.setNombreCategoria(producto.getNombreCategoria());
        publico.setNombreProveedor(producto.getNombreProveedor());
        return publico;
    }

    private String formatearMoneda(BigDecimal valor) {
        if (valor == null) return "$0.00";
        return String.format("$%.2f", valor);
    }

    private String formatearPorcentaje(BigDecimal valor) {
        if (valor == null) return "0%";
        return String.format("%.1f%%", valor);
    }
}
