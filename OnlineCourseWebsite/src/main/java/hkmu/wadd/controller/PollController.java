package hkmu.wadd.controller;

import hkmu.wadd.model.*;
import hkmu.wadd.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Controller
@RequestMapping("/polls")
public class PollController {

    @Autowired
    private PollRepository pollRepository;
    @Autowired
    private VoteRepository voteRepository;
    @Autowired
    private OptionRepository optionRepository;
    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private UserRepository userRepository;



    @GetMapping("/{id}")
    public String viewPoll(@PathVariable Long id, Model model, Authentication auth) {
        Poll poll = pollRepository.findById(id).orElseThrow();
        String username = auth.getName();
        Vote existingVote = voteRepository.findByPollIdAndUsername(id, username);
        List<Comment> comments = commentRepository.findByPollId(id);
        model.addAttribute("poll", poll);
        model.addAttribute("existingVote", existingVote);
        model.addAttribute("comments", comments);
        return "poll_detail";
    }

    @PostMapping("/{id}/vote")
    @Transactional
    public String handleVote(@PathVariable Long id, @RequestParam Long optionId, Authentication auth) {
        String username = auth.getName();
        Option newOption = optionRepository.findById(optionId).orElseThrow();
        Vote existingVote = voteRepository.findByPollIdAndUsername(id, username);

        if (existingVote != null) {
            Option oldOption = existingVote.getOption();
            if (!oldOption.getId().equals(optionId)) {
                oldOption.setVoteCount(oldOption.getVoteCount() - 1);
                optionRepository.save(oldOption);
                existingVote.setOption(newOption);
                voteRepository.save(existingVote);
                newOption.setVoteCount(newOption.getVoteCount() + 1);
                optionRepository.save(newOption);
            }
        } else {
            Vote newVote = new Vote();
            newVote.setPollId(id);
            newVote.setUsername(username);
            newVote.setOption(newOption);
            voteRepository.save(newVote);
            newOption.setVoteCount(newOption.getVoteCount() + 1);
            optionRepository.save(newOption);
        }
        return "redirect:/polls/" + id;
    }

    @GetMapping("/list")
    public String listPolls(Model model) {
        List<Poll> allPolls = pollRepository.findAll();
        model.addAttribute("polls", allPolls);
        return "poll_list";
    }

    @PreAuthorize("hasRole('TEACHER')")
    @GetMapping("/create")
    public String showCreateForm() {
        return "poll_create";
    }

    @PostMapping("/save")
    @Transactional
    public String handleSave(@RequestParam String question, @RequestParam String[] optionTexts) {
        Poll newPoll = new Poll();
        newPoll.setQuestion(question);
        Poll savedPoll = pollRepository.save(newPoll);
        for (String text : optionTexts) {
            if (text != null && !text.trim().isEmpty()) {
                Option opt = new Option();
                opt.setText(text);
                opt.setVoteCount(0);
                opt.setPoll(savedPoll);
                optionRepository.save(opt);
            }
        }
        return "redirect:/polls/list?created=success";
    }

    @PostMapping("/{id}/comment")
    @Transactional
    public String handleComment(@PathVariable Long id, @RequestParam String content, Authentication auth) {
        Poll poll = pollRepository.findById(id).orElseThrow();
        User user = userRepository.findByUsername(auth.getName());
        Comment comment = new Comment();
        comment.setContent(content);
        comment.setPoll(poll);
        comment.setUser(user);
        commentRepository.save(comment);
        return "redirect:/polls/" + id + "?commented";
    }

    @PostMapping("/comment/{commentId}/delete")
    @Transactional
    public String deleteComment(@PathVariable Long commentId, @RequestParam Long pollId, Authentication auth) {
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        boolean isOwner = comment.getUser().getUsername().equals(auth.getName());
        boolean isTeacher = auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_TEACHER"));
        if (isOwner || isTeacher) {
            commentRepository.delete(comment);
        }
        return "redirect:/polls/" + pollId + "?deleted";
    }

    @PostMapping("/comment/{commentId}/edit")
    @Transactional
    public String editComment(@PathVariable Long commentId, @RequestParam Long pollId, @RequestParam String content, Authentication auth) {
        Comment comment = commentRepository.findById(commentId).orElseThrow();
        if (comment.getUser().getUsername().equals(auth.getName())) {
            comment.setContent(content);
            commentRepository.save(comment);
        }
        return "redirect:/polls/" + pollId + "?edited";
    }

    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/{id}/delete")
    @Transactional

    public String deletePoll(@PathVariable Long id) {

        voteRepository.deleteByPollId(id);


        commentRepository.deleteByPollId(id);


        pollRepository.deleteById(id);

        return "redirect:/polls/list?deleted=success";
    }

    /**
     * 這裡是合併後的編輯方法，同時處理題目與選項
     */
    @PreAuthorize("hasRole('TEACHER')")
    @PostMapping("/{id}/edit")
    @Transactional
    public String editPoll(@PathVariable Long id,
                           @RequestParam String question,
                           @RequestParam(required = false) Long[] optionIds,
                           @RequestParam(required = false) String[] optionTexts) {


        Poll poll = pollRepository.findById(id).orElseThrow();
        poll.setQuestion(question);
        pollRepository.save(poll);


        if (optionIds != null && optionTexts != null) {
            for (int i = 0; i < optionIds.length; i++) {
                Option opt = optionRepository.findById(optionIds[i]).orElseThrow();
                if (!opt.getText().equals(optionTexts[i])) {
                    opt.setText(optionTexts[i]);
                    optionRepository.save(opt);
                }
            }
        }

        return "redirect:/polls/" + id + "?edited=success";
    }

    @GetMapping("/history")
    public String viewVotingHistory(Model model, Authentication auth) {
        String username = auth.getName();

        List<Vote> userVotes = voteRepository.findByUsernameOrderByIdDesc(username);

        model.addAttribute("votes", userVotes);
        model.addAttribute("username", username);
        return "poll_history";
    }

    @GetMapping("/comments/history")
    public String viewCommentHistory(Model model, Authentication auth) {
        String username = auth.getName();

        List<Comment> userComments = commentRepository.findActiveCommentsByUsername(username);

        model.addAttribute("comments", userComments);
        model.addAttribute("username", username);
        return "comment_history";
    }
}