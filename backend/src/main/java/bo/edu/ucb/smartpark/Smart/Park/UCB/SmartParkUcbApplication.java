package bo.edu.ucb.smartpark.Smart.Park.UCB;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = {
		"bo.edu.ucb.smartpark.Smart.Park.UCB.Entity",
		"bo.edu.ucb.smartpark.Smart.Park.UCB.Configuration.security",
		"bo.edu.ucb.smartpark.Smart.Park.UCB.Configuration.security.Jwt",
		"bo.edu.ucb.smartpark.Smart.Park.UCB.api",
		"bo.edu.ucb.smartpark.Smart.Park.UCB.bl",
		"bo.edu.ucb.smartpark.Smart.Park.UCB.dao"
})
public class SmartParkUcbApplication {

	public static void main(String[] args) {
		SpringApplication.run(SmartParkUcbApplication.class, args);
	}

}
