package com.mqnic.persistence;

import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyVO;
import com.mqnic.board.mapper.ReplyMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.List;
import java.util.stream.IntStream;

@Log4j
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
		"file:src/main/resources/META-INF/spring/applicationContext.xml",
		"file:src/main/resources/META-INF/spring/dispatcher-servlet.xml"})
public class ReplyMapperTests {

	@Setter(onMethod_=@Autowired)
	private ReplyMapper mapper;

	private Long[] bnoArr = {2097184L,2097183L,2097182L,2097181L,2097180L};
	@Test
	public void testMapper() {
		log.info(mapper);
	}

	@Test
	public void testCreate() {

		IntStream.rangeClosed(1,10).forEach(i->{
			ReplyVO reply = new ReplyVO();

			reply.setBno(bnoArr[i%5]);
			reply.setReply("댓글 테스트 " + 1);
			reply.setReplyer("replyer"+ i);

			mapper.insertReply(reply);
		});

	}

	@Test
	public void testRead() {

		Long targetRno = 5L;

		ReplyVO vo = mapper.readReply(targetRno);

		log.info(vo);
	}

	@Test
	public void testDelete() {
		int result = mapper.deleteReply(1L);

		log.info("delete : 1L : "+ (result == 1 ? "OK" : "FAIL"));
	}

	@Test
	public void testUpdate() {
		ReplyVO vo = new ReplyVO();

		vo.setReply("업데이트된 내용");
		vo.setRno(5L);
		int result = mapper.updateReply(vo);

		log.info("update : " +vo.getRno() + " : "+ (result == 1 ? "OK" : "FAIL"));
	}

	@Test
	public void testList() {
		Criteria cri = new Criteria();

		List<ReplyVO> list = mapper.getListWithPaging(cri,bnoArr[0]);
		list.forEach(reply -> log.info(reply));
	}

}
