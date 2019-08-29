package com.mqnic.board.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
	@Override
	public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication auth) throws IOException, ServletException {

		// 로그인 유저의 권한을 담을 리스트
		List<String> roleNames = new ArrayList<>();

		// 받아온 권한 정보를 roleNames에 추가
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});

		log.warn("ROLE NAMES : " + roleNames);

		if(roleNames.contains("ROLE_ADMIN")) {
			httpServletResponse.sendRedirect("/sample/admin");
		}

		if(roleNames.contains("ROLE_MEMBER")) {
			httpServletResponse.sendRedirect("/sample/member");
		}

		httpServletResponse.sendRedirect("/sample/all");

	}
}
