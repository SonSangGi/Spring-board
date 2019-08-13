package com.mqnic.persistence;

import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import com.mqnic.board.mapper.BoardMapper;
import com.mqnic.board.service.BoardService;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/resources/META-INF/spring/applicationContext.xml")
@Log4j
public class BoardServiceTests {

	@Setter(onMethod_= {@Autowired})
	private BoardService boardService;
	@Setter(onMethod_= {@Autowired})
	private BoardMapper boardMapper;

	@Test
	public void testExist() {
		log.info(boardService);
		assertNotNull(boardService);
	}

	@Test
	public void testRegister() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글");
		board.setContent("새로 작성하는 내용");
		board.setWriter("유저");

		boardService.register(board);

		log.info("생성된 게시물의 번호 : " + board.getBno());
	}

	@Test
	public void testGetBoards() {
		boardService.getBoards(new Criteria(2,10)).forEach(board ->  log.info(board));
	}

	@Test
	public void testGetBoard() {
		boardService.getBoard(1000L);
	}

	@Test
	public void testModifyBoard() {
		Long bno = boardMapper.getFisrtBoardNo();

		BoardVO board = boardService.getBoard(bno);
		board.setTitle("수정된 게시글");

		log.info("MODIFY RESULT : " + boardService.modifyBoard(board));
	}

	@Test
	public void removeBoard() {
		Long bno = boardMapper.getFisrtBoardNo();

		log.info("REMOVE RESULT : " + boardService.removeBoard(bno));
	}
}
