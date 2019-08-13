package com.mqnic.board.controller;

import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.ReplyVO;
import com.mqnic.board.service.ReplyService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reply/")
@Log4j
@AllArgsConstructor
public class ReplyController {

	private ReplyService replyService;

	@PostMapping("/new")
	public ResponseEntity<String> create(@RequestBody ReplyVO reply) {
		log.info("ReplyVo : " + reply);

		int insertCount = replyService.registerReply(reply);

		log.info("Reply INSERT COUNT : " + insertCount);

		return insertCount == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@GetMapping(value = "/pages/{bno}/{page}",produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<List<ReplyVO>> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {
		log.info("Reply get List.....");

		Criteria cri = new Criteria(page,10);
		return new ResponseEntity<>(replyService.getList(cri,bno),HttpStatus.OK);
	}

	@GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("Reply get ... " + rno);

		return new ResponseEntity<>(replyService.getReply(rno),HttpStatus.OK);
	}

	@DeleteMapping(value = "/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {
		log.info("Reply remove ... " + rno);

		return replyService.removeReply(rno) == 1
				? new ResponseEntity<>("success",HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH}, value = "/{rno}")
	public ResponseEntity<String> modify(@PathVariable("rno") Long rno,@RequestBody ReplyVO reply) {
		reply.setRno(rno);

		log.info("Reply modify ... " + rno);
		return replyService.modifyReply(reply) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

}
