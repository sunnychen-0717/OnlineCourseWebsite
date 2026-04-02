package hkmu.wadd.controller;

import hkmu.wadd.model.*;
import hkmu.wadd.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.Authentication;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/lectures")
public class LectureController {

    @Autowired
    private LectureRepository lectureRepository;
    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private MaterialRepository materialRepository;


    @GetMapping("/view/{id}")
    public String viewLecture(@PathVariable Long id, Model model) {

        Lecture lecture = lectureRepository.findById(id).orElse(null);
        if (lecture == null) return "redirect:/";


        List<Comment> lectureComments = commentRepository.findByLectureId(id);

        model.addAttribute("lecture", lecture);
        model.addAttribute("comments", lectureComments);

        return "lecture_detail";
    }




    @PostMapping("/{id}/comment")
    @Transactional // 建議加上事務處理
    public String addComment(@PathVariable("id") Long id,
                             @RequestParam("content") String content,
                             Principal principal) {


        Lecture lecture = lectureRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid lecture Id:" + id));


        User user = userRepository.findByUsername(principal.getName());


        Comment comment = new Comment();
        comment.setContent(content);
        comment.setUser(user);


        comment.setLecture(lecture);


        comment.setPoll(null);


        commentRepository.save(comment);

        System.out.println("成功儲存課程留言！課程 ID: " + id + ", 留言內容: " + content);

        return "redirect:/lectures/view/" + id;
    }


    @GetMapping("/add")
    public String addPage(Model model) {
        model.addAttribute("lecture", new Lecture());
        return "add_lecture";
    }


    @PostMapping("/add")
    public String handleAddLecture(@ModelAttribute Lecture lecture,
                                   @RequestParam("files") MultipartFile[] files,
                                   @RequestParam(value = "fileSummaries", required = false) String[] fileSummaries) throws IOException {


        Lecture savedLecture = lectureRepository.save(lecture);


        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "files" + File.separator;
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        List<Material> materialList = new ArrayList<>();


        if (files != null) {
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                if (!file.isEmpty()) {

                    String originalName = file.getOriginalFilename();
                    String savedName = UUID.randomUUID().toString() + "_" + originalName;


                    File saveFile = new File(uploadDir + savedName);
                    file.transferTo(saveFile);


                    Material material = new Material();
                    material.setFileName(originalName);
                    material.setFilePath(savedName);
                    material.setLecture(savedLecture);


                    if (fileSummaries != null && i < fileSummaries.length) {
                        material.setFileSummary(fileSummaries[i]);
                    }

                    materialList.add(material);
                }
            }
        }


        if (!materialList.isEmpty()) {
            materialRepository.saveAll(materialList);
        }

        return "redirect:/";
    }


    @GetMapping("/delete/{id}")
    @Transactional
    public String deleteLecture(@PathVariable("id") Long id) {
        System.out.println("=== 收到刪除請求，ID: " + id + " ===");
        lectureRepository.deleteById(id);
        return "redirect:/";
    }

    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model) {
        Lecture lecture = lectureRepository.findById(id).orElse(null);
        if (lecture == null) return "redirect:/";

        model.addAttribute("lecture", lecture);
        return "edit_lecture";
    }


    @PostMapping("/edit/{id}")
    @Transactional
    public String handleEditLecture(@PathVariable Long id,
                                    @ModelAttribute Lecture updatedLecture,
                                    @RequestParam(value = "files", required = false) MultipartFile[] files,
                                    @RequestParam(value = "fileSummaries", required = false) String[] fileSummaries) throws IOException {


        Lecture existingLecture = lectureRepository.findById(id).orElseThrow();


        existingLecture.setTitle(updatedLecture.getTitle());
        existingLecture.setDescription(updatedLecture.getDescription());
        existingLecture.setSummary(updatedLecture.getSummary());


        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "files" + File.separator;

        if (files != null) {
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                if (!file.isEmpty()) {
                    String originalName = file.getOriginalFilename();
                    String savedName = UUID.randomUUID().toString() + "_" + originalName;

                    file.transferTo(new File(uploadDir + savedName));

                    Material material = new Material();
                    material.setFileName(originalName);
                    material.setFilePath(savedName);
                    material.setLecture(existingLecture);


                    if (fileSummaries != null && i < fileSummaries.length) {
                        material.setFileSummary(fileSummaries[i]);
                    }


                    existingLecture.getMaterials().add(material);
                }
            }
        }


        lectureRepository.save(existingLecture);

        return "redirect:/lectures/view/" + id;
    }



    @GetMapping("/material/delete/{materialId}")
    @Transactional
    public String deleteMaterial(@PathVariable("materialId") Long materialId) {

        Material m = materialRepository.findById(materialId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid material Id:" + materialId));


        Long lectureId = m.getLecture().getId();


        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "files" + File.separator;
        File file = new File(uploadDir + m.getFilePath());

        if (file.exists()) {
            boolean deleted = file.delete();
            System.out.println("實體檔案刪除狀態: " + deleted);
        }




        materialRepository.delete(m);


        return "redirect:/lectures/edit/" + lectureId;
    }

}
