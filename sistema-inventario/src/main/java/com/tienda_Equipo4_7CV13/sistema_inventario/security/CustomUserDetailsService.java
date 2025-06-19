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

import java.util.ArrayList;
import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByNombreUsuario(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));

        if (usuario.getActivo() == 0) {
            throw new UsernameNotFoundException("Usuario inactivo: " + username);
        }

        List<GrantedAuthority> authorities = new ArrayList<>();
        // Corregir: usar .name() para obtener el String del enum
        authorities.add(new SimpleGrantedAuthority("ROLE_" + usuario.getRol().name()));

        return new org.springframework.security.core.userdetails.User(
                usuario.getNombreUsuario(),
                usuario.getPassword(),
                authorities
        );
    }

    public UserDetails createUserDetails(Usuario usuario) {
        List<GrantedAuthority> authorities = new ArrayList<>();
        // Corregir: usar .name() para obtener el String del enum
        authorities.add(new SimpleGrantedAuthority("ROLE_" + usuario.getRol().name()));

        return new org.springframework.security.core.userdetails.User(
                usuario.getNombreUsuario(),
                usuario.getPassword(),
                authorities
        );
    }
}
