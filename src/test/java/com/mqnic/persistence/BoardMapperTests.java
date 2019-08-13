package com.mqnic.persistence;


import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import com.mqnic.board.mapper.BoardMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/resources/META-INF/spring/applicationContext.xml")
@Log4j
public class BoardMapperTests {
	@Setter(onMethod_ = {@Autowired})
	private BoardMapper boardMapper;

	@Test
	public void testInsert() {
		int key = (int)(Math.random()*100)+1;
		BoardVO board = new BoardVO();
		board.setTitle("title"+ key);
		board.setContent("content");
		board.setWriter("user_"+key);

		boardMapper.insertBoard(board);

		log.info("insert" + board);
	}

	@Test
	public void testInsertSelectKey() {
		BoardVO board = new BoardVO();
		int key = (int)(Math.random()*100)+1;
		board.setTitle("title"+key);
		board.setContent("content");
		board.setWriter("newbie"+key);

		boardMapper.insertSelectKeyBoard(board);

		log.info("insertSelectKey: " + board);
	}

	@Test
	public void testGetBoard() {
		BoardVO board = boardMapper.getBoard(boardMapper.getFisrtBoardNo());

		log.info("getBoard: " + board);
	}

	@Test
	public void deleteBoard() {
		int result = boardMapper.deleteBoard(boardMapper.getFisrtBoardNo());

		log.info("DELETE COUNT: " + result);
	}

	@Test
	public void updateBoard() {
		Long bno = boardMapper.getFisrtBoardNo();
		BoardVO originBoard = boardMapper.getBoard(bno);

		log.info("원본 게시글 : " + originBoard);

		BoardVO board = new BoardVO();
		board.setBno(bno);
		board.setTitle("update Board Title");
		board.setContent("update Board Content");

		log.info("수정 게시글 : " + board);

		int result = boardMapper.updateBoard(board);
		log.info("UPDATE COUNT: " + result);
	}

	@Test
	public void testPaging() {

		Criteria criteria = new Criteria();
		criteria.setAmount(20);
		List<BoardVO> boards = boardMapper.getBoardsWithPaging(criteria);

		boards.forEach(board -> log.info(board));
	}

	@Test
	public void testSearch() {
		Criteria cri = new Criteria();
		cri.setKeyword("새로");
		cri.setType("TC");

		List<BoardVO> boards = boardMapper.getBoardsWithPaging(cri);

		boards.forEach(board -> log.info(board));
	}
}
