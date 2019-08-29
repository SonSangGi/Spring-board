package com.mqnic.board.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.crypto.password.PasswordEncoder;

@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder {
	@Override
	public String encode(CharSequence rawPassword) {

		log.info("before password : " + rawPassword);
		return rawPassword.toString();
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {

		log.info("matches : " + rawPassword + " : "+ encodedPassword);

		return rawPassword.equals(encodedPassword);
	}
}
