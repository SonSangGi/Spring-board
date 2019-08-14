package com.mqnic.board.service;

import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyPageDTO;
import com.mqnic.board.mapper.BoardMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
@Log4j
public class BoardServiceImpl implements BoardService{

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;

	@Override
	public void register(BoardVO board) {
		log.info("register...." + board);

		boardMapper.insertSelectKeyBoard(board);
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
		return boardMapper.updateBoard(board) == 1;
	}

	@Override
	public boolean removeBoard(Long bno) {
		return boardMapper.deleteBoard(bno) == 1;
	}

}
