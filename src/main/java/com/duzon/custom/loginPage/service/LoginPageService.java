package com.duzon.custom.loginPage.service;

import bizbox.orgchart.service.vo.LoginVO;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

public interface LoginPageService {

	String AES_Encode(String str) throws UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException;

	Map<String, Object> existUserYn(Map<String, Object> map);

	Map<String, Object> loginAgreementPop(Map<String, Object> map);

	void updateAgreement(Map<String, Object> map);
	
	String getCurrTime(Map<String, Object> map);

	public LoginVO actionLogin(Map<String, Object> params);

	public Map<String, Object> selectOptionSet(Map<String, Object> mp);

}
