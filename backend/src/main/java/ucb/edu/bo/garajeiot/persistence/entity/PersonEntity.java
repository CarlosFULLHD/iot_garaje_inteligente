package ucb.edu.bo.garajeiot.persistence.entity;

import jakarta.persistence.*;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@Entity(name = "person")
@Table(name ="person")
public class PersonEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_person", nullable = false)
    private Long idPerson;
    @Column(name = "ci", nullable = false, length = 75)
    private String ci;
    @Column (name = "name", nullable = false, length = 75)
    private String name;
    @Column(name = "father_last_name", nullable = false, length = 75)
    private String fatherLastName;
    @Column(name = "mother_last_name", nullable = false, length = 75)
    private String motherLastName;
    @Column(name = "description", nullable = false, length = 2000)
    private String description;
    @Column(name = "email", nullable = false, length = 150)
    private String email;
    @Column(name ="cellphone", nullable = false, length = 75)
    private String cellPhone;
    @Column(name = "status", nullable = false)
    private int status;
    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
//    @OneToMany(mappedBy = "personIdPerson",orphanRemoval = true, cascade = CascadeType.ALL)
//    List<RoleHasPersonEntity> roleHasPersonEntityList;
    @OneToOne(mappedBy = "personIdPerson")
    private UsersEntity usersEntity;


    @PrePersist
    protected void onCreate(){
        name = this.name.trim();
        fatherLastName = this.fatherLastName.trim();
        motherLastName = this.motherLastName.trim();
        description = this.description.trim();
        email = this.email.trim();
        cellPhone = this.cellPhone.trim();
        status = 1;
        imageUrl = imageUrl != null ? imageUrl.trim() : null;
        createdAt = LocalDateTime.now();
    }

    public Long getIdPerson() {
        return idPerson;
    }

    public void setIdPerson(Long idPerson) {
        this.idPerson = idPerson;
    }

    public String getCi() {
        return ci;
    }

    public void setCi(String ci) {
        this.ci = ci;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFatherLastName() {
        return fatherLastName;
    }

    public void setFatherLastName(String fatherLastName) {
        this.fatherLastName = fatherLastName;
    }

    public String getMotherLastName() {
        return motherLastName;
    }

    public void setMotherLastName(String motherLastName) {
        this.motherLastName = motherLastName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCellPhone() {
        return cellPhone;
    }

    public void setCellPhone(String cellPhone) {
        this.cellPhone = cellPhone;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public UsersEntity getUsersEntity() {
        return usersEntity;
    }

    public void setUsersEntity(UsersEntity usersEntity) {
        this.usersEntity = usersEntity;
    }

}
