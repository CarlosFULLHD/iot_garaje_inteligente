package ucb.edu.bo.garajeiot.persistence.dao;

import grado.ucb.edu.back_end_grado.persistence.entity.PersonEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PersonDao extends JpaRepository<PersonEntity,Long> {
    Optional<PersonEntity> findByIdPersonAndStatus(Long idPerson, int status);


    Optional<PersonEntity> findByEmail(String email); // Replace if it's necesary BY CRIS

    @Query("SELECT p FROM person p LEFT JOIN users u ON p.idPerson = u.personIdPerson.idPerson WHERE p.status = :status AND u.personIdPerson IS NULL")
    Page<PersonEntity> getPersonWithoutUser(int status, Pageable pageable);

    @Query("SELECT p FROM person p LEFT JOIN users u ON p.idPerson = u.personIdPerson.idPerson LEFT JOIN roles r ON u.roleHasPersonEntity.rolesIdRole.idRole = r.idRole WHERE u.status = :status AND r.userRole = 'ESTUDIANTE'")
    List<PersonEntity> getActiveStudents(int status, Pageable pageable);


    //Filtrado
    @Query("SELECT p FROM person p LEFT JOIN users u ON p.idPerson = u.personIdPerson.idPerson " +
            "WHERE p.status = :status AND u.personIdPerson IS NULL AND " +
            "(p.name ILIKE %:filter% OR p.fatherLastName ILIKE %:filter% OR p.motherLastName ILIKE %:filter%)")
    Page<PersonEntity> findFilteredPersons(@Param("filter") String filter, @Param("status") int status, Pageable pageable);

    @Query("SELECT p FROM person p LEFT JOIN users u ON p.idPerson = u.personIdPerson.idPerson " +
            "LEFT JOIN roles r ON u.roleHasPersonEntity.rolesIdRole.idRole = r.idRole " +
            "WHERE p.status = :status AND r.userRole = 'ESTUDIANTE' AND " +
            "(:filter IS NULL OR p.name ILIKE %:filter% OR p.fatherLastName ILIKE %:filter% OR p.motherLastName ILIKE %:filter%)")
    Page<PersonEntity> findFilteredActiveStudents(@Param("filter") String filter, @Param("status") int status, Pageable pageable);

    @Query("SELECT rhp.idRolePer AS idRolePer, " +
            "p.name AS name, " +
            "p.fatherLastName AS fatherLastName, " +
            "p.motherLastName AS motherLastName, " +
            "COUNT(la.idTutorApplication) AS assignedStudents " +
            "FROM role_has_person rhp " +
            "LEFT JOIN person p ON rhp.usersIdUsers.personIdPerson.idPerson = p.idPerson " +
            "LEFT JOIN lecturer_application la ON rhp.idRolePer = la.roleHasPersonIdRolePer.idRolePer " +
            "AND la.tutorLecturer = 0 " +
            "AND la.status = :status " +
            "WHERE rhp.rolesIdRole.userRole = 'DOCENTE'" +
            "AND rhp.status = :status " +
            "GROUP BY rhp.idRolePer, p.name, p.fatherLastName, p.motherLastName")
    List<Object[]> findActiveTutors(@Param("status") int status);


    @Query("SELECT rhp.idRolePer AS idRolePer, " +
            "p.name AS name, " +
            "p.fatherLastName AS fatherLastName, " +
            "p.motherLastName AS motherLastName, " +
            "COUNT(la.idTutorApplication) AS assignedStudents " +
            "FROM role_has_person rhp " +
            "LEFT JOIN person p ON rhp.usersIdUsers.personIdPerson.idPerson = p.idPerson " +
            "LEFT JOIN lecturer_application la ON rhp.idRolePer = la.roleHasPersonIdRolePer.idRolePer " +
            "AND la.tutorLecturer = 1 " +
            "AND la.status = :status " +
            "WHERE rhp.rolesIdRole.userRole = 'DOCENTE'" +
            "AND rhp.status = :status " +
            "GROUP BY rhp.idRolePer, p.name, p.fatherLastName, p.motherLastName")
    List<Object[]> findActiveLecturers(@Param("status") int status);

}
