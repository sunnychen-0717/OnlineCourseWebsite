package hkmu.wadd.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final CustomUserDetailsService userDetailsService;

    public SecurityConfig(CustomUserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {

        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth

                        .requestMatchers("/register","/login","/account/register","/login?error", "/login?logout", "/h2-console/**", "/error", "/WEB-INF/jsp/**").permitAll()



                        .requestMatchers("/comments/add/**").hasAnyRole("STUDENT", "TEACHER")
                        .requestMatchers("/lectures/view/**").authenticated()
                        .requestMatchers("/lectures/add/**").hasRole("TEACHER")
                        .requestMatchers("/lectures/delete/**").hasRole("TEACHER")
                        .requestMatchers("/admin/users").hasRole("TEACHER")
                        .requestMatchers("/register").permitAll()
                        .requestMatchers("/files/**").permitAll()
                        .requestMatchers("/account/**").authenticated()
                        .requestMatchers("/polls/add/**","/polls/create/**", "/polls/save/**").hasRole("TEACHER")
                        .requestMatchers("/polls/**").authenticated()



                        .anyRequest().authenticated()
                )

                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessUrl("/login?logout")
                )
                .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()));

        return http.build();
    }
}
