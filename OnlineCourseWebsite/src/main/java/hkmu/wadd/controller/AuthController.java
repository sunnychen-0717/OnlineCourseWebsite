package hkmu.wadd.controller;

import hkmu.wadd.model.User;
import hkmu.wadd.dao.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.context.SecurityContextHolder; // 👈 補上這個
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional; // 👈 補上這個

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
                                 @RequestParam(required = false) String email) {
        if (userRepository.findByUsername(username) != null) {
            return "redirect:/register?error=exists";
        }
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
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
    @Transactional
    public String deleteUser(@PathVariable Long id) {
        try {
            String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();
            User userToDelete = userRepository.findById(id).orElse(null);

            if (userToDelete == null) return "redirect:/admin/users?error=notfound";
            if (userToDelete.getUsername().equals(currentUsername)) return "redirect:/admin/users?error=selfdelete";

            // 🔥 強力手動清理：直接從資料庫刪除所有關聯資料
            userRepository.deleteCommentsByUserId(id);
            userRepository.deletePollsByUserId(id);

            // 最後才刪除用戶
            userRepository.delete(userToDelete);
            userRepository.flush(); // 立即同步到資料庫
            
            return "redirect:/admin/users?deleted";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/users?error=database_error";
        }
    }

}