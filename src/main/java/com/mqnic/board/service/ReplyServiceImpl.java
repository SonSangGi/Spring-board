package com.mqnic.board.service;

import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyPageDTO;
import com.mqnic.board.domain.ReplyVO;
import com.mqnic.board.mapper.ReplyMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Log4j
@Service
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_ = {@Autowired})
	ReplyMapper replyMapper;
	@Override
	public int registerReply(ReplyVO reply) {
		return replyMapper.insertReply(reply);
	}

	@Override
	public ReplyVO getReply(Long rno) {
		return replyMapper.readReply(rno);
	}

	@Override
	public int removeReply(Long rno) {
		return replyMapper.deleteReply(rno);
	}

	@Override
	public int modifyReply(ReplyVO reply) {
		return replyMapper.updateReply(reply);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		return replyMapper.getListWithPaging(cri,bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(
				replyMapper.getCountByBno(bno),
				replyMapper.getListWithPaging(cri,bno)
		);
	}
}
