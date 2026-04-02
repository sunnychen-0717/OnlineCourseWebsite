package hkmu.wadd.controller;

import hkmu.wadd.model.User;
import hkmu.wadd.dao.UserRepository; // 確保你的 Repository 放在這個 package
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/account") // 這裡定義了所有方法的前綴都是 /account
public class AccountController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * 處理註冊提交
     * 實際路徑: POST /account/register
     */
    @PostMapping("/register")
    public String handleRegister(@RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam String fullName,
                                 @RequestParam String email,
                                 @RequestParam(required = false) String phoneNumber,
                                 @RequestParam String role) {


        if (userRepository.findByUsername(username) != null) {
            return "redirect:/register?error=exists";
        }


        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phoneNumber);


        newUser.setPassword(passwordEncoder.encode(password));


        String finalRole = role.toUpperCase().startsWith("ROLE_") ? role.toUpperCase() : "ROLE_" + role.toUpperCase();
        newUser.setRole(finalRole);


        userRepository.save(newUser);

        return "redirect:/login?success";
    }

    /**
     * 顯示帳戶管理頁面
     * 實際路徑: GET /account/manage
     */
    @GetMapping("/manage")
    public String manageAccount(Model model, Authentication authentication) {
        String username = authentication.getName();
        User user = userRepository.findByUsername(username);
        model.addAttribute("user", user);
        return "manage_account";
    }

    /**
     * 處理個人資料更新
     * 實際路徑: POST /account/update
     */
    @PostMapping("/update")
    public String updateAccount(@ModelAttribute User updatedData,
                                @RequestParam(value = "newPassword", required = false) String newPassword,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes) {

        User user = userRepository.findByUsername(authentication.getName());

        if (user != null) {
            user.setFullName(updatedData.getFullName());
            user.setEmail(updatedData.getEmail());
            user.setPhoneNumber(updatedData.getPhoneNumber());

            if (newPassword != null && !newPassword.trim().isEmpty()) {
                user.setPassword(passwordEncoder.encode(newPassword));
            }

            userRepository.save(user);
            redirectAttributes.addFlashAttribute("message", "Account updated successfully!");
        }

        return "redirect:/account/manage";
    }
}