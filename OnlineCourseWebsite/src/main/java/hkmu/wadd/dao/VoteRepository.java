package hkmu.wadd.dao;

import hkmu.wadd.model.Vote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Repository
public interface VoteRepository extends JpaRepository<Vote, Long> {


    @Modifying
    @Transactional
    void deleteByPollId(Long pollId);


    Vote findByPollIdAndUsername(Long pollId, String username);


    List<Vote> findByUsernameOrderByIdDesc(String username);
}