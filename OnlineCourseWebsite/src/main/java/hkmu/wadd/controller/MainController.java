package hkmu.wadd.controller;

import hkmu.wadd.dao.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @Autowired
    private LectureRepository lectureRepository;

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/")
    public String index(Model model) {

        model.addAttribute("lectures", lectureRepository.findAll());
        return "index";
    }
}
