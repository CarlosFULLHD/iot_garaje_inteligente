//package bo.edu.ucb.smartpark.Smart.Park.UCB.bl;
//
//import grado.ucb.edu.back_end_grado.dto.SuccessfulResponse;
//import grado.ucb.edu.back_end_grado.dto.UnsuccessfulResponse;
//import grado.ucb.edu.back_end_grado.dto.request.RoleHasPersonRequest;
//import grado.ucb.edu.back_end_grado.dto.response.RoleHasPersonResponse;
//import grado.ucb.edu.back_end_grado.persistence.dao.RoleHasPersonDao;
//import grado.ucb.edu.back_end_grado.persistence.dao.RolesDao;
//import grado.ucb.edu.back_end_grado.persistence.dao.UsersDao;
//import grado.ucb.edu.back_end_grado.persistence.entity.RoleHasPersonEntity;
//import grado.ucb.edu.back_end_grado.persistence.entity.UsersEntity;
//import grado.ucb.edu.back_end_grado.util.Globals;
//import org.springframework.stereotype.Service;
//
//import java.util.Optional;
//
//@Service
//public class RolesHasPersonBl {
//    private final RoleHasPersonDao roleHasPersonDao;
//    private final UsersDao usersDao;
//    private final RolesDao rolesDao;
//    private RoleHasPersonEntity roleHasPersonEntity;
//    private RoleHasPersonResponse roleHasPersonResponse;
//
//    public RolesHasPersonBl(RoleHasPersonDao roleHasPersonDao, UsersDao usersDao, RolesDao rolesDao, RoleHasPersonEntity roleHasPersonEntity, RoleHasPersonResponse roleHasPersonResponse) {
//        this.roleHasPersonDao = roleHasPersonDao;
//        this.usersDao = usersDao;
//        this.rolesDao = rolesDao;
//        this.roleHasPersonEntity = roleHasPersonEntity;
//        this.roleHasPersonResponse = roleHasPersonResponse;
//    }
//
//    // New role to an account
//    public Object newRoleToAnAccount(RoleHasPersonRequest request){
//        roleHasPersonResponse = new RoleHasPersonResponse();
//        try {
//
//            // Checking if the account tuple is active or requires password change
//            Optional<UsersEntity> users = usersDao.findByIdUsersAndStatus(request.getUsersIdUsers().getIdUsers(), 1);
//            if (!users.isPresent()) {
//                users = usersDao.findByIdUsersAndStatus(request.getUsersIdUsers().getIdUsers(), -1);
//                if (!users.isPresent()) {
//                    return new UnsuccessfulResponse(Globals.httpNotFoundStatus[0], Globals.httpNotFoundStatus[1],"Cuenta no encontrada o inactiva");
//                }
//            }
//            roleHasPersonEntity = request.rolesHasPersonRequestToEntity(request);
//            roleHasPersonEntity.setUsersIdUsers(users.get());
//            roleHasPersonEntity = roleHasPersonDao.save(roleHasPersonEntity);
//            // Preparing response
//            roleHasPersonResponse = roleHasPersonResponse.roleHasPersonEntityToResponse(roleHasPersonEntity);
//
//        } catch(Exception e){
//            return new UnsuccessfulResponse(Globals.httpInternalServerErrorStatus[0], Globals.httpInternalServerErrorStatus[1],e.getMessage());
//        }
//        return new SuccessfulResponse(Globals.httpSuccessfulCreatedStatus[0], Globals.httpSuccessfulCreatedStatus[1], roleHasPersonResponse);
//    }
//}
