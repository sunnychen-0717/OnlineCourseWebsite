package hkmu.wadd.controller;

import hkmu.wadd.model.*;
import hkmu.wadd.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;

@Controller
@RequestMapping("/comments")
public class CommentController {

    @Autowired private CommentRepository commentRepository;
    @Autowired private LectureRepository lectureRepository;
    @Autowired private UserRepository userRepository;


    @PostMapping("/add/{lectureId}")
    @Transactional
    public String addComment(@PathVariable Long lectureId,
                             @RequestParam("content") String content,
                             Principal principal) {
        User user = userRepository.findByUsername(principal.getName());
        Lecture lecture = lectureRepository.findById(lectureId).orElse(null);

        if (user != null && lecture != null && content != null && !content.trim().isEmpty()) {
            Comment comment = new Comment();
            comment.setContent(content);
            comment.setUser(user);
            comment.setLecture(lecture);
            commentRepository.save(comment);
        }
        return "redirect:/lectures/view/" + lectureId;
    }


    @Transactional
    @PostMapping("/delete/{id}")
    public String deleteComment(@PathVariable Long id, Authentication authentication) {
        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment == null) return "redirect:/";

        String currentUsername = authentication.getName();
        boolean isTeacher = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_TEACHER") || a.getAuthority().equals("TEACHER"));
        boolean isOwner = comment.getUser().getUsername().equals(currentUsername);

        Long redirectId = null;
        String redirectPath = "/";

        if (isOwner || isTeacher) {

            if (comment.getLecture() != null) {
                redirectId = comment.getLecture().getId();
                redirectPath = "/lectures/view/";

                comment.getLecture().getComments().remove(comment);
            } else if (comment.getPoll() != null) {
                redirectId = comment.getPoll().getId();
                redirectPath = "/polls/view/";
            }

            commentRepository.delete(comment);

        }

        return (redirectId != null) ? "redirect:" + redirectPath + redirectId : "redirect:/";
    }


    @PostMapping("/edit/{id}")
    @Transactional
    public String editComment(@PathVariable Long id,
                              @RequestParam String content,
                              @RequestParam(required = false) Long lectureId,
                              @RequestParam(required = false) Long pollId,
                              Principal principal) {
        Comment comment = commentRepository.findById(id).orElseThrow();


        if (comment.getUser().getUsername().equals(principal.getName())) {
            if (content != null && !content.trim().isEmpty()) {
                comment.setContent(content);
                commentRepository.save(comment);
            }
        }


        if (lectureId != null) return "redirect:/lectures/view/" + lectureId;
        if (pollId != null) return "redirect:/polls/view/" + pollId;


        if (comment.getLecture() != null) return "redirect:/lectures/view/" + comment.getLecture().getId();
        return "redirect:/";
    }
}