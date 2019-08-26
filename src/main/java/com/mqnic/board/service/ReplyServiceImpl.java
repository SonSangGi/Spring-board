package com.mqnic.board.service;

import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyPageDTO;
import com.mqnic.board.domain.ReplyVO;
import com.mqnic.board.mapper.BoardMapper;
import com.mqnic.board.mapper.ReplyMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Log4j
@Service
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_ = {@Autowired})
	ReplyMapper replyMapper;

	@Setter(onMethod_ = {@Autowired} )
	BoardMapper boardMapper;

	@Transactional
	@Override
	public int registerReply(ReplyVO reply) {
		boardMapper.updateReplyCnt(reply.getBno(),1);
		return replyMapper.insertReply(reply);
	}

	@Override
	public ReplyVO getReply(Long rno) {
		return replyMapper.readReply(rno);
	}

	@Transactional
	@Override
	public int removeReply(Long rno) {
		ReplyVO vo = replyMapper.readReply(rno);
		boardMapper.updateReplyCnt(vo.getBno(),-1);
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
