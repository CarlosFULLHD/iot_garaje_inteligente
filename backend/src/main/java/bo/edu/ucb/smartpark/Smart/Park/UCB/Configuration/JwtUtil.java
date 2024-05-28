package bo.edu.ucb.smartpark.Smart.Park.UCB.Configuration;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.concurrent.TimeUnit;

import static org.springframework.security.config.Elements.JWT;

@Component
public class JwtUtil {
    private static String SECRET_KEY = "smartparkucb";
    private static Algorithm ALGORITHM = Algorithm.HMAC256(SECRET_KEY);

    public String create(String email, String rol, String surname, Long idUser) {
        return JWT.create()
                .withClaim("email", email)
                .withClaim("rol", rol)
                .withClaim("surname", surname)
                .withClaim("idUser", idUser)
                .withExpiresAt(new Date(System.currentTimeMillis() + 3600000))
                .sign(ALGORITHM);
    }

        public boolean isValid(String jwt){
            try{
                JWT.require(ALGORITHM)
                        .build()
                        .verify(jwt);
                return true;
            }catch (Exception e){
                return false;
            }
        }

        public String getEmail(String jwt){
            return JWT
                    .require(ALGORITHM)
                    .build()
                    .verify(jwt)
                    .getSubject();
        }
}
