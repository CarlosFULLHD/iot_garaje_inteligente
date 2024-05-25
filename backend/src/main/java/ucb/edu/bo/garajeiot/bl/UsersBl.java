package ucb.edu.bo.garajeiot.bl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import ucb.edu.bo.garajeiot.persistence.dao.UsersDao;
import ucb.edu.bo.garajeiot.persistence.dto.SuccessfulResponse;
import ucb.edu.bo.garajeiot.persistence.dto.UnsuccessfulResponse;
import ucb.edu.bo.garajeiot.util.Globals;

@Service
public class UsersBl {
    private final UsersDao usersDao;

    private static final Logger LOG = LoggerFactory.getLogger(UsersBl.class);

    @Autowired
    public UsersBl(UsersDao usersDao) {
        this.usersDao = usersDao;
    }


    public Object listUsers() {
        try {


            return new SuccessfulResponse(Globals.httpOkStatus[0], Globals.httpOkStatus[1], response);
        } catch (Exception e) {
            LOG.error("Error al listar usuarios", e);
            return new UnsuccessfulResponse(Globals.httpInternalServerErrorStatus[0], Globals.httpInternalServerErrorStatus[1], e.getMessage());
        }
    }


}
