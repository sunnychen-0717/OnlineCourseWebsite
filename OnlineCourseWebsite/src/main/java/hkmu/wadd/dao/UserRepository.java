package hkmu.wadd.dao;

import hkmu.wadd.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);

    @Modifying
    @Transactional
    @Query("DELETE FROM Comment c WHERE c.user.id = ?1")
    void deleteCommentsByUserId(Long userId);

    @Modifying
    @Transactional
    @Query("DELETE FROM Poll p WHERE p.user.id = ?1")
    void deletePollsByUserId(Long userId);
}
