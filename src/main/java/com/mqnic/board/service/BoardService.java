package com.mqnic.board.service;

import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyPageDTO;

import java.util.List;

public interface BoardService {

	public void register(BoardVO board);

	public List<BoardVO> getBoards(Criteria cri);

	public BoardVO getBoard(Long bno);

	public int getTotalCount(Criteria cri);

	public boolean modifyBoard(BoardVO board);

	public boolean removeBoard(Long bno);


}
