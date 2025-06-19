package com.tienda_Equipo4_7CV13.sistema_inventario.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "USUARIOS")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_usuarios")
    @SequenceGenerator(name = "seq_usuarios", sequenceName = "SEQ_USUARIOS", allocationSize = 1)
    @Column(name = "ID_USUARIO")
    private Long idUsuario;
    
    @Column(name = "NOMBRE_USUARIO", length = 50, nullable = false, unique = true)
    private String nombreUsuario;
    
    @Column(name = "PASSWORD_HASH", length = 255, nullable = false)
    private String passwordHash;
    
    @Column(name = "NOMBRE_COMPLETO", length = 100, nullable = false)
    private String nombreCompleto;
    
    @Column(name = "EMAIL", length = 100, unique = true)
    private String email;
    
    @Column(name = "TELEFONO", length = 20)
    private String telefono;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "ROL", length = 20, nullable = false)
    private RolUsuario rol;
    
    @Column(name = "ACTIVO", nullable = false)
    private Boolean activo = true;
    
    @Column(name = "ULTIMO_ACCESO")
    private LocalDateTime ultimoAcceso;
    
    @Column(name = "FECHA_CREACION", nullable = false)
    private LocalDateTime fechaCreacion = LocalDateTime.now();
    
    @Column(name = "INTENTOS_FALLIDOS")
    private Integer intentosFallidos = 0;
    
    @Column(name = "CUENTA_BLOQUEADA")
    private Boolean cuentaBloqueada = false;
    
    // Enum para roles
    public enum RolUsuario {
        ADMIN,
        DUENO,
        EMPLEADO,
        CAJERO,
        INVENTARIO
    }
}
