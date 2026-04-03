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

    // --- 修正後的查看課程詳細頁 (合併了評論抓取) ---
    @GetMapping("/view/{id}")
    public String viewLecture(@PathVariable Long id, Model model) {
        // 1. 抓取課程資訊
        Lecture lecture = lectureRepository.findById(id).orElse(null);
        if (lecture == null) return "redirect:/";

        // 2. 抓取該課程下的所有評論 (這是你剛才要求新增的)
        List<Comment> lectureComments = commentRepository.findByLectureId(id);

        model.addAttribute("lecture", lecture);
        model.addAttribute("comments", lectureComments);

        return "lecture_detail";
    }

    // ❌ 請刪除類別最下方那個重複的 @GetMapping("/lectures/{id}") 方法

    // 處理課程留言
    @PostMapping("/{id}/comment")
    @Transactional // 建議加上事務處理
    public String addComment(@PathVariable("id") Long id,
                             @RequestParam("content") String content,
                             Principal principal) {

        // 1. 找到對應的課程
        Lecture lecture = lectureRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid lecture Id:" + id));

        // 2. 找到當前登入的使用者
        User user = userRepository.findByUsername(principal.getName());

        // 3. 建立評論並「手動」建立雙向關聯
        Comment comment = new Comment();
        comment.setContent(content);
        comment.setUser(user);

        // 🌟 最重要的一行：必須把這筆評論指派給該課程
        comment.setLecture(lecture);

        // 確保 poll 是空的（如果是從課程頁面留言）
        comment.setPoll(null);

        // 4. 儲存評論
        commentRepository.save(comment);

        System.out.println("成功儲存課程留言！課程 ID: " + id + ", 留言內容: " + content);

        return "redirect:/lectures/view/" + id;
    }

    // 新增課程頁面
    @GetMapping("/add")
    public String addPage(Model model) {
        model.addAttribute("lecture", new Lecture());
        return "add_lecture";
    }

    // 處理多檔案上傳及其個別摘要
    @PostMapping("/add")
    public String handleAddLecture(@ModelAttribute Lecture lecture,
                                   @RequestParam("files") MultipartFile[] files,
                                   @RequestParam(value = "fileSummaries", required = false) String[] fileSummaries) throws IOException {

        // 1. 先儲存 Lecture 以獲得資料庫 ID
        Lecture savedLecture = lectureRepository.save(lecture);

        // 2. 確保儲存路徑存在 (修正：將註解改為實際程式碼)
        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "files" + File.separator;
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        List<Material> materialList = new ArrayList<>();

        // 3. 遍歷檔案，同時對應摘要
        if (files != null) {
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                if (!file.isEmpty()) {
                    // 防止重複檔名
                    String originalName = file.getOriginalFilename();
                    String savedName = UUID.randomUUID().toString() + "_" + originalName;

                    // 存檔至實體硬碟
                    File saveFile = new File(uploadDir + savedName);
                    file.transferTo(saveFile);

                    // 建立 Material 關聯
                    Material material = new Material();
                    material.setFileName(originalName);
                    material.setFilePath(savedName);
                    material.setLecture(savedLecture);

                    // 依照 index 對應摘要 (加上長度檢查防止 ArrayIndexOutOfBounds)
                    if (fileSummaries != null && i < fileSummaries.length) {
                        material.setFileSummary(fileSummaries[i]);
                    }

                    materialList.add(material);
                }
            }
        }

        // 4. 批次存入資料庫
        if (!materialList.isEmpty()) {
            materialRepository.saveAll(materialList);
        }

        return "redirect:/";
    }

    // 刪除課程
    @GetMapping("/delete/{id}")
    @Transactional
    public String deleteLecture(@PathVariable("id") Long id) { // 👈 明確加上 ("id")
        System.out.println("=== 收到刪除請求，ID: " + id + " ===");
        lectureRepository.deleteById(id);
        return "redirect:/";
    }
    // 顯示編輯頁面
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model) {
        Lecture lecture = lectureRepository.findById(id).orElse(null);
        if (lecture == null) return "redirect:/";

        model.addAttribute("lecture", lecture);
        return "edit_lecture"; // 需要建立這個 JSP
    }

    @PostMapping("/edit/{id}")
    @Transactional
    public String handleEditLecture(@PathVariable Long id,
                                    @ModelAttribute Lecture updatedLecture,
                                    @RequestParam(value = "existingMaterialIds", required = false) Long[] existingIds,
                                    @RequestParam(value = "existingSummaries", required = false) String[] existingSummaries,
                                    @RequestParam(value = "files", required = false) MultipartFile[] files,
                                    @RequestParam(value = "fileSummaries", required = false) String[] fileSummaries) throws IOException {

        Lecture existingLecture = lectureRepository.findById(id).orElseThrow();

        // 1. 更新課程基本資訊
        existingLecture.setTitle(updatedLecture.getTitle());
        existingLecture.setDescription(updatedLecture.getDescription());
        existingLecture.setSummary(updatedLecture.getSummary());

        // 2. 更新「現有」教材的 Summary (解決編輯舊資料的問題)
        if (existingIds != null && existingSummaries != null) {
            for (int i = 0; i < existingIds.length; i++) {
                Long mid = existingIds[i];
                String newSummary = existingSummaries[i];
                existingLecture.getMaterials().stream()
                        .filter(m -> m.getId().equals(mid))
                        .findFirst()
                        .ifPresent(m -> m.setFileSummary(newSummary));
            }
        }

        // 3. 處理「新上傳」的檔案 (補完邏輯)
        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "files" + File.separator;
        if (files != null) {
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                if (!file.isEmpty()) {
                    String originalName = file.getOriginalFilename();
                    String savedName = UUID.randomUUID().toString() + "_" + originalName;

                    // 儲存實體檔案
                    file.transferTo(new File(uploadDir + savedName));

                    // 建立新的 Material 物件並建立關聯
                    Material material = new Material();
                    material.setFileName(originalName);
                    material.setFilePath(savedName);
                    material.setLecture(existingLecture);

                    if (fileSummaries != null && i < fileSummaries.length) {
                        material.setFileSummary(fileSummaries[i]);
                    }

                    // 加入到課程的教材清單中
                    existingLecture.getMaterials().add(material);
                }
            }
        }

        // 4. 儲存變更
        lectureRepository.save(existingLecture);
        return "redirect:/lectures/view/" + id;
    }
    // ... 之前的 handleEditLecture 方法 ...

    // 刪除特定教材檔案
    @GetMapping("/material/delete/{materialId}")
    @Transactional
    public String deleteMaterial(@PathVariable("materialId") Long materialId) {
        // 1. 查找該教材紀錄
        Material m = materialRepository.findById(materialId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid material Id:" + materialId));

        // 紀錄所屬的課程 ID，以便刪除後跳轉回正確的編輯頁面
        Long lectureId = m.getLecture().getId();

        // 2. 刪除實體硬碟中的檔案
        String uploadDir = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "files" + File.separator;
        File file = new File(uploadDir + m.getFilePath());

        if (file.exists()) {
            boolean deleted = file.delete();
            System.out.println("實體檔案刪除狀態: " + deleted);
        }

        // 3. 從資料庫中移除紀錄
        // 注意：這會解除與 Lecture 的關聯
        materialRepository.delete(m);

        // 4. 跳轉回該課程的編輯頁面
        return "redirect:/lectures/edit/" + lectureId;
    }

} // Controller 的結束括號
