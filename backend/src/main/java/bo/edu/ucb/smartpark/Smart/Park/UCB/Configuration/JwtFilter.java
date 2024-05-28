package bo.edu.ucb.smartpark.Smart.Park.UCB.Configuration;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    @Autowired
    public JwtFilter(JwtUtil jwtUtil, UserDetailsService userDetailsService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException, ServletException, IOException {

        // 1. Validar que sea un header Authorization valido
        String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        if(authHeader == null  || !authHeader.startsWith("Bearer")){
            filterChain.doFilter(request, response);
            return;
        }

        // 2. Validar que el token sea valido
        String jwt = authHeader.split(" ")[1].trim();
        if(!this.jwtUtil.isValid(jwt)){
            filterChain.doFilter(request, response);
            return;
        }

        // 3. Cargar el usuario del UserDetailsService
        String email = this.jwtUtil.getEmail(jwt);
        User user = (User) this.userDetailsService.loadUserByUsername(email);

        // 4. Cargar al usuario en el contexto de Spring Security
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                user.getUsername(),
                user.getPassword(),
                user.getAuthorities()
        );
        // 5. Cargar el usuario en el contexto de Spring Security
        authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(authenticationToken);
        System.out.println(authenticationToken);
        filterChain.doFilter(request, response);
    }

}
