package com.tienda_Equipo4_7CV13.sistema_inventario.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "jwt")
public class JwtConfig {

    private String secret = "laModernaSecretKey2024SistemaInventario";
    private long expiration = 86400000; // 24 horas en milisegundos
    private String tokenPrefix = "Bearer ";
    private String headerString = "Authorization";

    // Getters y Setters
    public String getSecret() {
        return secret;
    }

    public void setSecret(String secret) {
        this.secret = secret;
    }

    public long getExpiration() {
        return expiration;
    }

    public void setExpiration(long expiration) {
        this.expiration = expiration;
    }

    public String getTokenPrefix() {
        return tokenPrefix;
    }

    public void setTokenPrefix(String tokenPrefix) {
        this.tokenPrefix = tokenPrefix;
    }

    public String getHeaderString() {
        return headerString;
    }

    public void setHeaderString(String headerString) {
        this.headerString = headerString;
    }

    // Métodos de utilidad
    public String getSecretKey() {
        return secret;
    }

    public long getExpirationTime() {
        return expiration;
    }

    public String getAuthorizationHeader() {
        return headerString;
    }

    public String getBearerPrefix() {
        return tokenPrefix;
    }
}