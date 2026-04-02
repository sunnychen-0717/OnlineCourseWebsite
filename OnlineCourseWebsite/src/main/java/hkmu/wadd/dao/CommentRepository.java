package hkmu.wadd.dao;

import hkmu.wadd.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {


    List<Comment> findByLectureId(Long lectureId);


    List<Comment> findByPollId(Long pollId);


    List<Comment> findByUserUsernameOrderByIdDesc(String username);

    /**
     * 修正後的歷史紀錄查詢：
     * 使用 LEFT JOIN 確保即便 poll 為空（是課程留言）或 lecture 為空（是投票留言），
     * 只要其中一個關聯存在，留言就會被顯示出來。
     */
    @Query("SELECT c FROM Comment c " +
            "LEFT JOIN c.poll p " +
            "LEFT JOIN c.lecture l " +
            "WHERE c.user.username = :username " +
            "AND (p.id IS NOT NULL OR l.id IS NOT NULL) " +
            "ORDER BY c.id DESC")
    List<Comment> findActiveCommentsByUsername(@Param("username") String username);

    @Modifying
    @Transactional
    @Query("DELETE FROM Comment c WHERE c.poll.id = :pollId")
    void deleteByPollId(@Param("pollId") Long pollId);


    @Modifying
    @Transactional
    @Query("DELETE FROM Comment c WHERE c.lecture.id = :lectureId")
    void deleteByLectureId(@Param("lectureId") Long lectureId);
}