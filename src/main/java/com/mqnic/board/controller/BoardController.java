package com.mqnic.board.controller;

import com.mqnic.board.domain.BoardAttachVO;
import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.PageDTO;
import com.mqnic.board.service.BoardService;
import lombok.extern.log4j.Log4j;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@Log4j
@RequestMapping("/board/*")
public class BoardController{

	@Autowired
	BoardService boardService;

	@GetMapping(value = {"/list","/"})
	public void list(Model model, Criteria cri) {
		log.info("list: " + cri);

		int total = boardService.getTotalCount(cri);

		log.info("total: " + total);

		model.addAttribute("list",boardService.getBoards(cri));
		model.addAttribute("pageMaker",new PageDTO(cri,total));
	}
	@GetMapping("/register")
	public void registerForm() {
	}
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : " + board);

		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.error(attach));
		}

		log.info("================================");
		boardService.register(board);

		rttr.addFlashAttribute("result",board.getBno()) ;
		return "redirect:/board/list";
	}

	@GetMapping("/get")
	public void getBoard(@RequestParam("bno") Long bno,@ModelAttribute("cri") Criteria cri, Model model ) {

		log.info("/get");
		model.addAttribute("board",boardService.getBoard(bno));
	}

	@GetMapping("/modify")
	public void modifyForm(@RequestParam("bno")Long bno, @ModelAttribute("cri")Criteria cri, Model model){
		model.addAttribute("board",boardService.getBoard(bno));
	}

	@PostMapping("/modify")
	public String modify(BoardVO board,@ModelAttribute Criteria cri, RedirectAttributes rttr) {
		log.info("modify :" + board);

		if(boardService.modifyBoard(board)) {
			rttr.addFlashAttribute("result","success");
		}
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("keyword",cri.getKeyword());
		rttr.addAttribute("type",cri.getType());
		return "redirect:/board/list";
	}

	@PostMapping("/remove")
	public String remove(@RequestParam("bno")Long bno, @ModelAttribute Criteria cri, RedirectAttributes rttr) {
		log.info("remove :" + bno);

		List<BoardAttachVO> attachList = boardService.getAttachList(bno);

		if(boardService.removeBoard(bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result","success");
		}
		return "redirect:/board/list" + cri.getListLink();
	}

	@ResponseBody
	@GetMapping(value="getAttachList",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {

		log.info("getAttachList : " + bno);

		return new ResponseEntity<>(boardService.getAttachList(bno), HttpStatus.OK);
	}

	private void deleteFiles(List<BoardAttachVO> attachList) {

		log.info("deleteFiles : "+ attachList);
		if(attachList == null || attachList.size() == 0) {
			return;
		}

		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("/Users/sanggi-son/upload/"+attach.getUploadPath()+"/"+attach.getUuid()+"_"+attach.getFileName());

				if(new Tika().detect(file).startsWith("image")) {
					Path thumbnail = Paths.get("/Users/sanggi-son/upload/"+attach.getUploadPath()+"/s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbnail);
				}

				Files.deleteIfExists(file);
			} catch (IOException e) {
				e.printStackTrace();
			}
		});
	}
}
