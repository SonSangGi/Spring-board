package com.mqnic.board.service;

import com.mqnic.board.domain.*;
import com.mqnic.board.mapper.BoardAttachMapper;
import com.mqnic.board.mapper.BoardMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@AllArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService{

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;

	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;

	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register...." + board);

		boardMapper.insertSelectKeyBoard(board);

		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			log.info("============@@@@@@@@@@==========!!!!!!!!!!===========return-321-312-312");
			return;
		}

		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public List<BoardVO> getBoards(Criteria cri) {
		log.info("get List With criteria : " + cri);

		return boardMapper.getBoardsWithPaging(cri);
	}

	@Override
	public BoardVO getBoard(Long bno) {
		log.info("getBoard...." + bno);

		return boardMapper.getBoard(bno);
	}

	@Override
	public int getTotalCount(Criteria cri) {
		log.info("get total count");

		return boardMapper.getTotalCount(cri);
	}

	@Override
	public boolean modifyBoard(BoardVO board) {

		attachMapper.deleteAll(board.getBno());

		boolean modifyResult = boardMapper.updateBoard(board) == 1;

		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Override
	public boolean removeBoard(Long bno) {
		attachMapper.deleteAll(bno);
		return boardMapper.deleteBoard(bno) == 1;
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		return attachMapper.findByBno(bno);
	}

}
