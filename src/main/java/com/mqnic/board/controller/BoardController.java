package com.mqnic.board.controller;

import com.mqnic.board.domain.BoardVO;
import com.mqnic.board.domain.Criteria;
import com.mqnic.board.domain.PageDTO;
import com.mqnic.board.service.BoardService;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	public void modifyForm(@RequestParam("bno") Long bno,@ModelAttribute("cri") Criteria cri, Model model ) {
		log.info("/modify");
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

		if(boardService.removeBoard(bno)) {
			rttr.addFlashAttribute("result","success");
		}
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("keyword",cri.getKeyword());
		rttr.addAttribute("type",cri.getType());
		return "redirect:/board/list";
	}

}
