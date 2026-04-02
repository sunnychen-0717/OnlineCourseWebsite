package hkmu.wadd;

import hkmu.wadd.config.SecurityConfig; // Make sure this import is here
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

@SpringBootApplication(scanBasePackages = "hkmu.wadd")
@Import(SecurityConfig.class) // This FORCES Spring to load your security file
public class OnlineCourseApplication {
    public static void main(String[] args) {
        SpringApplication.run(OnlineCourseApplication.class, args);
    }
}