package com.tienda_Equipo4_7CV13.sistema_inventario.security;

import com.tienda_Equipo4_7CV13.sistema_inventario.entity.Usuario;
import com.tienda_Equipo4_7CV13.sistema_inventario.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByNombreUsuario(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));

        return UserPrincipal.create(usuario);
    }

    @Transactional
    public UserDetails loadUserById(Long id) {
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado con id: " + id));

        return UserPrincipal.create(usuario);
    }

    // Clase interna para UserPrincipal
    public static class UserPrincipal implements UserDetails {
        private Long id;
        private String nombreUsuario;
        private String email;
        private String password;
        private String rol;
        private Boolean activo;
        private Collection<? extends GrantedAuthority> authorities;

        public UserPrincipal(Long id, String nombreUsuario, String email, String password, 
                           String rol, Boolean activo, Collection<? extends GrantedAuthority> authorities) {
            this.id = id;
            this.nombreUsuario = nombreUsuario;
            this.email = email;
            this.password = password;
            this.rol = rol;
            this.activo = activo;
            this.authorities = authorities;
        }

        public static UserPrincipal create(Usuario usuario) {
            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority("ROLE_" + usuario.getRol().toUpperCase()));

            return new UserPrincipal(
                    usuario.getIdUsuario(),
                    usuario.getNombreUsuario(),
                    usuario.getEmail(),
                    usuario.getPassword(),
                    usuario.getRol(),
                    usuario.getActivo(),
                    authorities
            );
        }

        // Getters
        public Long getId() {
            return id;
        }

        public String getEmail() {
            return email;
        }

        public String getRol() {
            return rol;
        }

        @Override
        public String getUsername() {
            return nombreUsuario;
        }

        @Override
        public String getPassword() {
            return password;
        }

        @Override
        public Collection<? extends GrantedAuthority> getAuthorities() {
            return authorities;
        }

        @Override
        public boolean isAccountNonExpired() {
            return true;
        }

        @Override
        public boolean isAccountNonLocked() {
            return true;
        }

        @Override
        public boolean isCredentialsNonExpired() {
            return true;
        }

        @Override
        public boolean isEnabled() {
            return activo != null && activo;
        }
    }
}