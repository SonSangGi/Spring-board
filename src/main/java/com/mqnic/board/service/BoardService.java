package com.mqnic.board.service;

import com.mqnic.board.domain.*;

import java.util.List;

public interface BoardService {

	public void register(BoardVO board);

	public List<BoardVO> getBoards(Criteria cri);

	public BoardVO getBoard(Long bno);

	public int getTotalCount(Criteria cri);

	public boolean modifyBoard(BoardVO board);

	public boolean removeBoard(Long bno);

	public List<BoardAttachVO> getAttachList(Long bno);


}
