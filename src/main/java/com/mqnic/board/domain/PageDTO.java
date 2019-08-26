package com.mqnic.board.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	private int startPage;      // 시작 페이지
	private int endPage;        // 끝 페이지
	private int pageBlock = 10;
	private boolean prev,next;  //전, 후 페이지의 여부

	private int total;
	private Criteria cri;

	public PageDTO(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;

		this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * pageBlock;

		int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));

		if(realEnd < this.endPage) {
			this.endPage = realEnd;
		}

		this.startPage = this.endPage > 1 ? this.endPage - (pageBlock - 1) : 1;

		System.out.println(startPage);
		System.out.println(endPage);

		this.prev = this.startPage > 1;

		this.next = this.endPage < realEnd;
	}
}
