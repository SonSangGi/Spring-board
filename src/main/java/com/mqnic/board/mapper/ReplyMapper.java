package com.mqnic.board.mapper;

import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyPageDTO;
import com.mqnic.board.domain.ReplyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyMapper {

	public int insertReply(ReplyVO reply);

	public ReplyVO readReply(Long bno);

	public int deleteReply(Long rno);

	public int updateReply(ReplyVO reply);

	public List<ReplyVO> getListWithPaging(@Param("cri")Criteria cri, @Param("bno") Long bno);

	public int getCountByBno(Long rno);

	public ReplyPageDTO getListPage(Criteria cri, Long bno);
}
