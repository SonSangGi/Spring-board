package com.mqnic.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CommonController {

	@RequestMapping(value = {"/list","/"})
	public String home() {

		return "redirect:/board/list";
	}
}
