package com.duzon.custom.common.utiles;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

public class CtFileUtile {
	
	private String rootPath = CtGetProperties.getKey("fileRootPaht");
	
	/**
	 * YH 2017. 12. 11. 설명 : 파일 업로드
	 */
	public Map<String, Object> fileUpdate(MultipartFile multipartFile) {
		Map<String, Object> result = new HashMap<String, Object>();
		String subPath = subDir();
		String fileOriNm = multipartFile.getOriginalFilename();
		String encodeFileNm = fileStrEncode(fileStrRandomCd() + fileOriNm);

		File outFile = new File(rootPath + subPath + encodeFileNm);
		File dir = new File(rootPath + subPath);
		
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		
		try {
			// 서버에 저장
			multipartFile.transferTo(outFile);

			// db 저장할때 패스
			String upPath = URLEncoder.encode(subPath + encodeFileNm, "UTF-8");

			result.put("filePath", upPath);

		} catch (Exception e) {
			e.printStackTrace();
		}

		result.put("fileNm", fileOriNm);

		return result;

	}

	/**
	 * YH 2017. 12. 11. 설명 : 파일 다운로드
	 */
	public void fileDownLoad(String filePath, String fileNm, HttpServletRequest request, HttpServletResponse response) {

		String nm = null;
		String path = null;

		try {
			// 서버에서 파일 가져올 경로
			path = URLDecoder.decode(filePath, "UTF-8");

			// 파일 다운로드 할때 파일 이름 원본 최초1단계 임시 이름
			String tem = fileStrDecode(path.substring(path.lastIndexOf("/") + 1, path.length()));

			// 파일 다운로드 할때 파일 이름 원본 2단계 최종 변경할 이름명
			nm = tem.substring(6, tem.length());

			BufferedInputStream in = null;
			BufferedOutputStream out = null;
			File reFile = null;

			reFile = new File(rootPath + path);

			// 파일이름 선택
			if (StringUtils.isEmpty(fileNm) || "undefined".equals(fileNm)) {
				setDisposition(nm, request, response);
			} else {
				setDisposition(fileNm + nm.substring(nm.lastIndexOf("."), nm.length()) , request, response);
			}

			in = new BufferedInputStream(new FileInputStream(reFile));
			out = new BufferedOutputStream(response.getOutputStream());

			FileCopyUtils.copy(in, out);
			out.flush();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private String fileStrEncode(String str) {
		String cum = "";
		try {

			cum = new String(Base64.encodeBase64(str.getBytes()), "UTF-8");

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return cum;
	}

	private String fileStrDecode(String str) {
		String cum = "";
		try {
			cum = URLDecoder.decode(new String(Base64.decodeBase64(str.getBytes())), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return cum;
	}

	private String fileStrRandomCd() {
		Random r = new Random();
		return String.valueOf(r.nextInt(9)) + String.valueOf(r.nextInt(9)) + String.valueOf(r.nextInt(9))
				+ String.valueOf(r.nextInt(9)) + String.valueOf(r.nextInt(9)) + String.valueOf(r.nextInt(9));

	}

	private String subDir() {
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd/");
		Date date = new Date();
		return df.format(date);
	}

	@SuppressWarnings("unused")
	private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "ISO-8859-1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {

		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}

	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) { // IE 10 이하
			return "MSIE";
		} else if (header.indexOf("Trident") > -1) { // IE 11
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		}
		return "Firefox";
	}

}
