package com.duzon.custom.loginPage.service.impl;

import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.loginPage.dao.LoginPageDAO;
import com.duzon.custom.loginPage.service.LoginPageService;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

@Service
public class LoginPageServiceImpl implements LoginPageService {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginPageServiceImpl.class);

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private LoginPageDAO loginPageDAO;
	
	final static String secretKey = "1023497555960596";
	
	public String AES_Encode(String str) throws java.io.UnsupportedEncodingException,
	NoSuchAlgorithmException, NoSuchPaddingException,
	InvalidKeyException, InvalidAlgorithmParameterException,
	IllegalBlockSizeException, BadPaddingException {
		
		/*byte[] keyData = secretKey.getBytes();
		
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey,
				new IvParameterSpec(secretKey.getBytes()));
		
		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted));
		
		
		
		return enStr;*/
		String Key = secretKey;
		byte[] crypted = null;
		  try{

		    SecretKeySpec skey = new SecretKeySpec(Key.getBytes(), "AES");

		      Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");

		      cipher.init(Cipher.ENCRYPT_MODE, skey);

		      crypted = cipher.doFinal(str.getBytes());

		    }catch(Exception e){


		    }

		    return new String(Base64.encodeBase64(crypted));
		
	}
	
	
	
	public String AES_Decode(String str)
	throws java.io.UnsupportedEncodingException,
	NoSuchAlgorithmException, NoSuchPaddingException,
	InvalidKeyException, InvalidAlgorithmParameterException,
	IllegalBlockSizeException, BadPaddingException {
		byte[] keyData = secretKey.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.DECRYPT_MODE, secureKey,
				new IvParameterSpec(secretKey.getBytes("UTF-8")));
		
		byte[] byteStr = Base64.decodeBase64(str.getBytes());
		
		return new String(c.doFinal(byteStr), "UTF-8");
		
		
	}
	

	@Override
	public Map<String, Object> existUserYn(Map<String, Object> map) {
		return loginPageDAO.existUserYn(map);
	}



	@Override
	public Map<String, Object> loginAgreementPop(Map<String, Object> map) {
		return loginPageDAO.loginAgreementPop(map);
	}



	@Override
	public void updateAgreement(Map<String, Object> map) {
		loginPageDAO.updateAgreement(map);
		
	}



	@Override
	public String getCurrTime(Map<String, Object> map) {
		return loginPageDAO.getCurrTime(map);
	}

	


	

	
}
