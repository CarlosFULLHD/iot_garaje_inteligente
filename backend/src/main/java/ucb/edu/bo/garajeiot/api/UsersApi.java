package ucb.edu.bo.garajeiot.api;




import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import ucb.edu.bo.garajeiot.bl.UsersBl;
import ucb.edu.bo.garajeiot.persistence.dto.SuccessfulResponse;
import ucb.edu.bo.garajeiot.persistence.dto.UnsuccessfulResponse;
import ucb.edu.bo.garajeiot.util.Globals;

@RestController
@RequestMapping(Globals.apiVersion+"users")

public class UsersApi {


    private final UsersBl usersBl;
    private static final Logger LOG = LoggerFactory.getLogger(UsersApi.class);

    public UsersApi(UsersBl usersBl) {
        this.usersBl = usersBl;
    }



    @GetMapping
    public ResponseEntity<Object> listUsers( ) {
        LOG.info("Listando todos los usuarios");
        Object response = usersBl.listUsers();
        return ResponseEntity.ok(response);
    }

    private ResponseEntity<Object> generateResponse(Object response) {
        if (response instanceof SuccessfulResponse) {
            return ResponseEntity.ok(response);
        } else if (response instanceof UnsuccessfulResponse) {
            return ResponseEntity.status(Integer.parseInt(((UnsuccessfulResponse) response).getStatus()))
                    .body(response);
        } else {
            return ResponseEntity.status(Integer.parseInt(Globals.httpInternalServerErrorStatus[0])).body(response);
        }
    }

}
