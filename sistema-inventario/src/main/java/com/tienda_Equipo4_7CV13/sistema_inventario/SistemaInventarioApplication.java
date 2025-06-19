package com.tienda_Equipo4_7CV13.sistema_inventario;
import com.tienda_Equipo4_7CV13.sistema_inventario.entity.RolUsuario;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
@EnableConfigurationProperties
public class SistemaInventarioApplication {

    public static void main(String[] args) {
        System.out.println("🚀 Iniciando Sistema de Inventario La Moderna...");
        SpringApplication.run(SistemaInventarioApplication.class, args);
        System.out.println("✅ Sistema iniciado correctamente!");
        System.out.println("📋 API disponible en: http://localhost:8080/api");
        System.out.println("🔐 Endpoints de autenticación: http://localhost:8080/api/auth");
    }
}
