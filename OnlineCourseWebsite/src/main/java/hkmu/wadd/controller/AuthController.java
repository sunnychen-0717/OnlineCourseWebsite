package hkmu.wadd.controller;

import hkmu.wadd.model.User;
import hkmu.wadd.dao.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.Authentication;

import java.util.List;

@Controller
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;


    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }


    @PostMapping("/register")
    public String handleRegister(@RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam String role,
                                 @RequestParam String fullName,
                                 @RequestParam(required = false) String email) { // <--- 2. 接收 Email (可選)


        if (userRepository.findByUsername(username) != null) {
            return "redirect:/register?error=exists";
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setEmail(email); // 如果 User Model 有 email 欄位的話


        newUser.setPassword(passwordEncoder.encode(password));


        newUser.setRole("ROLE_" + role.toUpperCase());

        userRepository.save(newUser);
        return "redirect:/login?success";
    }


    @GetMapping("/admin/users")
    public String listUsers(Model model) {

        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "user_list";
    }


    @GetMapping("/admin/users/delete/{id}")
    public String deleteUser(@PathVariable Long id) {


        String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();

        User userToDelete = userRepository.findById(id).orElse(null);

        if (userToDelete != null && userToDelete.getUsername().equals(currentUsername)) {

            return "redirect:/admin/users?error=selfdelete";

        }

        userRepository.deleteById(id);


        return "redirect:/admin/users?deleted";
    }

}