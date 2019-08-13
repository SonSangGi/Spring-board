package com.mqnic.board.service;

import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyService {


	public int registerReply(ReplyVO reply);

	public ReplyVO getReply(Long rno);

	public int removeReply(Long rno);

	public int modifyReply(ReplyVO reply);

	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") Long bno);
}
