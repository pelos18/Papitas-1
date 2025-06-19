package com.tienda_Equipo4_7CV13.sistema_inventario.config;

import com.tienda_Equipo4_7CV13.sistema_inventario.security.JwtAuthenticationEntryPoint;
import com.tienda_Equipo4_7CV13.sistema_inventario.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authz -> authz
                // Endpoints públicos
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/public/**").permitAll()
                
                // Endpoints solo para DUEÑO
                .requestMatchers("/api/productos/costos/**").hasRole("DUENO")
                .requestMatchers("/api/productos/ganancias/**").hasRole("DUENO")
                .requestMatchers("/api/reportes/financieros/**").hasRole("DUENO")
                .requestMatchers("/api/usuarios/**").hasRole("DUENO")
                
                // Endpoints para DUEÑO y EMPLEADO
                .requestMatchers("/api/productos/consultar/**").hasAnyRole("DUENO", "EMPLEADO")
                .requestMatchers("/api/productos/actualizar-stock/**").hasAnyRole("DUENO", "EMPLEADO")
                .requestMatchers("/api/inventario/**").hasAnyRole("DUENO", "EMPLEADO")
                .requestMatchers("/api/categorias/**").hasAnyRole("DUENO", "EMPLEADO")
                .requestMatchers("/api/proveedores/**").hasAnyRole("DUENO", "EMPLEADO")
                
                // Endpoints de reportes básicos
                .requestMatchers("/api/reportes/productos/**").hasAnyRole("DUENO", "EMPLEADO")
                .requestMatchers("/api/reportes/inventario/**").hasAnyRole("DUENO", "EMPLEADO")
                
                // Cualquier otra petición requiere autenticación
                .anyRequest().authenticated()
            )
            .exceptionHandling(ex -> ex.authenticationEntryPoint(jwtAuthenticationEntryPoint))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}