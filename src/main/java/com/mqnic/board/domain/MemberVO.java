package com.mqnic.board.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class MemberVO {

	private String userName;
	private String userid;
	private String userpw;
	private boolean enabled;

	private Date regDate;
	private Date updateDate;
	private List<AuthVO> authList;
}
