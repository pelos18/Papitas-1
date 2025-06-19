package com.tienda_Equipo4_7CV13.sistema_inventario.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "CATEGORIAS")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Categoria {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_categorias")
    @SequenceGenerator(name = "seq_categorias", sequenceName = "SEQ_CATEGORIAS", allocationSize = 1)
    @Column(name = "ID_CATEGORIA")
    private Long idCategoria;
    
    @Column(name = "NOMBRE", length = 100, nullable = false)
    private String nombre;
    
    @Column(name = "DESCRIPCION", length = 255)
    private String descripcion;
    
    @Column(name = "ACTIVO", nullable = false)
    private Integer activo = 1;
    
    @Column(name = "FECHA_CREACION", nullable = false)
    private LocalDateTime fechaCreacion = LocalDateTime.now();
    
    @Column(name = "FECHA_MODIFICACION")
    private LocalDateTime fechaModificacion;
}
