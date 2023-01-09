package com.duzon.custom.outprocess.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.outprocess.dao.OutProcessDAO;
import com.duzon.custom.outprocess.service.OutProcessService;

@Service("OutProcessService")
public class OutProcessServiceImpl implements OutProcessService {

	@Resource(name = "OutProcessDAO")
	OutProcessDAO outProcessDAO;

	@Resource(name = "CommFileDAO")
	CommFileDAO commFileDAO;

	/**
	 * Method : POST params : processId 프로세스 id approKey 외부시스템 연동키 docId 전자결재 id
	 * docSts 전자결재 상태(임시보관:10, 상신결재:20, 반려:100, 종결:90, 삭제:999) userId 로그인 사용자 키
	 */
	@Override
	public void outProcessApp(Map<String, Object> bodyMap) throws Exception {
		outProcessDAO.outProcessApp(bodyMap);
	}

	@Override
	public Object outProcessDocSts(Map<String, Object> map) throws Exception {
		return outProcessDAO.outProcessDocSts(map);
	}

	@Override
	public void outProcessTempInsert(Map<String, Object> map) throws Exception {
		outProcessDAO.outProcessTempInsert(map);
	}

	@Override
	public Map<String, Object> outProcessSel(Map<String, Object> map) throws Exception {
		return outProcessDAO.outProcessSel(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String makeFileKey(Map<String, Object> map) throws Exception {
		String fileKey = "Y" + java.util.UUID.randomUUID().toString();
		List<Map<String, Object>> tempSaveFileList = (List<Map<String, Object>>) commFileDAO.getCommFileList(map);
		for (Map<String, Object> fileMap : tempSaveFileList) {
			String filePath = String.valueOf(fileMap.get("file_path"));
			String fileName = String.valueOf(fileMap.get("file_name"));
			String realFileName = String.valueOf(fileMap.get("real_file_name"));
			String fileExtension = String.valueOf(fileMap.get("file_extension"));
			String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");

			FileInputStream fis = new FileInputStream(filePath + fileName + "." + fileExtension);
			CommFileUtil.makeDir(tempPath + fileKey);
			FileOutputStream fos = new FileOutputStream(tempPath + fileKey + File.separator + realFileName + "." + fileExtension);

			FileChannel fcin = fis.getChannel();
			FileChannel fcout = fos.getChannel();

			long size = fcin.size();
			fcin.transferTo(0, size, fcout);

			fcout.close();
			fcin.close();

			fis.close();
			fos.close();
		}
		return fileKey;
	}

	@Override
	public Object makeEncFileKey(Map<String, Object> paramMap) throws Exception {

		LinkedMultiValueMap<String, Object> map = new LinkedMultiValueMap<>();
		// 정상 업로드시 리턴될 파일키
		String fileKey = null;
		String compSeq = "1";// 그룹웨어 회사시퀀스-> 암호화 할것
		String loginId = "admin";// 그룹웨어 로그인아이디 -> 암호화 할것
		String empSeq = "1";// 그룹웨어 사용자시퀀스String serverUrl = "http://bizboxa.duzonnext.com";// 그룹웨어 url. api
//		String compSeq = AES128_Encode("1", "1023497555960596");// 그룹웨어 회사시퀀스-> 암호화 할것
//		String loginId = AES128_Encode("admin", "1023497555960596");// 그룹웨어 로그인아이디 -> 암호화 할것
//		String empSeq = AES128_Encode("1", "1023497555960596");// 그룹웨어 사용자시퀀스String serverUrl = "http://bizboxa.duzonnext.com";// 그룹웨어 url. api
		String serverUrl = "https://gw.hdcnr.co.kr";// 호출시 필요.
		try {

			fileKey = "Y" + java.util.UUID.randomUUID().toString();
			List<Map<String, Object>> tempSaveFileList = (List<Map<String, Object>>) commFileDAO.getCommFileList(paramMap);
			for (Map<String, Object> fileMap : tempSaveFileList) {
				String filePath = String.valueOf(fileMap.get("file_path"));
				String fileName = String.valueOf(fileMap.get("file_name"));
				String realFileName = String.valueOf(fileMap.get("real_file_name"));
				String fileExtension = String.valueOf(fileMap.get("file_extension"));
				String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");

				FileInputStream fis = new FileInputStream(filePath + fileName + "." + fileExtension);
				CommFileUtil.makeDir(tempPath + fileKey);
				FileOutputStream fos = new FileOutputStream(tempPath + fileKey + File.separator + URLEncoder.encode(realFileName + "." + fileExtension, "UTF-8"));
//				URLEncoder.encode(file.getOriginalFilename(), "UTF-8");// 
				FileChannel fcin = fis.getChannel();
				FileChannel fcout = fos.getChannel();

				long size = fcin.size();
				fcin.transferTo(0, size, fcout);

				fcout.close();
				fcin.close();

				fis.close();
				fos.close();
				map.add(realFileName, new FileSystemResource(tempPath + fileKey + File.separator + URLEncoder.encode(realFileName + "." + fileExtension, "UTF-8")));
			}

			// 아래 필수
			map.add("deleteYN", "Y");// 삭제가능여부
			map.add("compSeq", compSeq);// 그룹웨어 회사코드
			// 아래 셋중 하나 필수
			map.add("loginId", loginId);// 그룹웨어 로그인 id
			map.add("empSeq", empSeq);// 그룹웨어 사번
			map.add("erpSeq", "");// ERP 사번

			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.MULTIPART_FORM_DATA);
			HttpEntity<LinkedMultiValueMap<String, Object>> requestEntity = new HttpEntity<>(map, headers);
			RestTemplate restTemplate = new RestTemplate();
			String response = restTemplate.postForObject(serverUrl + "/gw/outProcessEncUpload.do", requestEntity, String.class);
			if (response != null) { // 결과 처리
				ObjectMapper mapper = new ObjectMapper();
				Map<String, Object> resultMap = mapper.readValue(response, Map.class);
				// 결과코드
				if (resultMap.get("resultCode") != null) {
					String resultCode = resultMap.get("resultCode") + "";
					String resultMessage = resultMap.get("resultMessage") + "";
					if (resultCode.equals("1") && resultMap.get("fileKey") != null) {// 결과 성공이고, fileKey 있다면..
						fileKey = resultMap.get("fileKey") + "";
//						fileKey = AES128_Encode(fileKey, "1023497555960596");
						System.out.println("fileKey : " + fileKey);
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		//		for (String fileName : tempFileNames) { // 임시 저장파일 삭제
		//			File f = new File(fileName);
		//			f.delete();
		//		}
		return fileKey;
	}

	public static String AES128_Encode(String str, String Key) throws java.io.UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		byte[] keyData = Key.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey, new IvParameterSpec(Key.getBytes()));
		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted));
		return enStr;
	}
	
	@Override
	public void outProcessDocInterlockInsert(Map<String, Object> map) throws Exception {
		outProcessDAO.outProcessDocInterlockInsert(map);
	}
}
