package com.mqnic.board.mapper;

import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BoardMapper {

	public List<BoardVO> getBoards();

	public List<BoardVO> getBoardsWithPaging(Criteria cri);

	public BoardVO getBoard(Long bno);

	public void insertBoard(BoardVO board);

	public void insertSelectKeyBoard(BoardVO board);

	public int deleteBoard(Long bno);

	public int updateBoard(BoardVO board);

	public int getTotalCount(Criteria cri);

	public Long getFisrtBoardNo();

	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
