package com.duzon.custom.resalphag20.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.kukgoh.util.SFTPUtil;
import com.duzon.custom.kukgoh.util.SFTPUtil2;
import com.duzon.custom.resalphag20.dao.ResAlphaG20DAO;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;
import com.jcraft.jsch.ChannelSftp;

@Service("ResAlphaG20Service")
public class ResAlphaG20ServiceImpl implements ResAlphaG20Service {
	
	private static final Logger logger = LoggerFactory.getLogger(ResAlphaG20Service.class);
	private String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"};
	
	@Resource(name = "ResAlphaG20DAO")
	private ResAlphaG20DAO resAlphaG20DAO;

	@Autowired
	private CommFileDAO commFileDAO;
	
	@Value("#{bizboxa['BizboxA.fileRootPath']}")
	private String fileRootPath;
	
	@Value("#{bizboxa['BizboxA.onnaraFilePath']}")
	private String onnaraFilePath;
	
	@Value("#{bizboxa['BizboxA.onnaraFileSubPath']}")
	private String onnaraSubFilePath;
	
	@Value("#{bizboxa['BizboxA.finalPdfServerPath']}")
	private String finalPdfServerPath;
	
	@Value("#{bizboxa['BizboxA.addFinalServerPath']}")
	private String addFinalServerPath;
	
	@Override
	public Object getFormInfo(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getFormInfo(paramMap);
	}

	@Override
	public String getIframeUrl(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getIframeUrl(paramMap);
	}

	@Override
	public Object getCustIframeHeight(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getCustIframeHeight(paramMap);
	}

	@Override
	public Object getInterfaceIds(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getInterfaceIds(paramMap);
	}

	@Override
	public List<Map<String, Object>> getOnnaraDocs(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> resultList = resAlphaG20DAO.getOnnaraDocs(paramMap);
		
		for (Map<String, Object> map : resultList) {
			
			int check = resAlphaG20DAO.checkUsedOnnaraDoc(map);
			
			map.put("usedGubun", (check > 0) ? "1" : "2"); // 1 : 사용중, 2 : 사용안함
			
			List<Map<String, Object>> attachList = resAlphaG20DAO.getOnnaraDocAllFiles(map);
			
			map.put("attachVo", attachList);
		}
		
		return resultList;
	}

	/**
	 * @MethodName : getOnnaraDocFile
	 * @author : jy
	 * @since :
	 * 설명 : onnara 파일 서버 - > groupware 파일 서버 이관
	 */
	@Override
	public Map<String, Object> getOnnaraDocFile(Map<String, Object> paramMap) {
		
		SFTPUtil2 sFTPUtil2 = new SFTPUtil2();
		ChannelSftp channelSftp = null;
		
		Map<String, Object> hwpMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = resAlphaG20DAO.getOnnaraDocAllFiles(paramMap);
		Map<String, Object> onnaraInfo = resAlphaG20DAO.getOnnaraServerInfo();
		Map<String, Object> checkMap = resAlphaG20DAO.checkAttachFile(paramMap);
		Map<String, Object> onnaraDocInfo = resAlphaG20DAO.getOnnaraDocInfo(paramMap);
		
		try {
		
			if (checkMap != null) { // 이미 알파서버에 있는 경우
				
				hwpMap.put("SFILENAME", (String) checkMap.get("o_real_file_name"));
				hwpMap.put("FLETTL", (String) checkMap.get("o_org_file_name"));
				hwpMap.put("FILEID", (String) checkMap.get("o_file_id"));
				hwpMap.put("INDT", (String) checkMap.get("o_indt"));
				hwpMap.put("yyyyMM", (String) checkMap.get("yyyyMM"));
				
			} else {
				
				int num = 1;
				
				for (Map<String, Object> map : resultList) {
					
					String gubun = (String) map.get("GUBUN");
					
					String realFileName = (String) map.get("SFILENAME");
					String inDt = (String) map.get("INDT");
					String yyyyMM = inDt.substring(0,  6);
					map.put("yyyyMM", yyyyMM);
					
					logger.info("realFileName : " + realFileName);
					
					if (gubun.equals("DFT01")) { // 결재 원문일 경우
						logger.info("==== 결재원문 ====");
						map.put("FLETTL", "[" + String.valueOf(onnaraDocInfo.get("AUTHORDEPTNAME")) + "-" + String.valueOf(onnaraDocInfo.get("DOCNOSEQ")) + "]" + String.valueOf(map.get("FLETTL")));
						hwpMap.put("SFILENAME", (String) map.get("SFILENAME"));
						hwpMap.put("FLETTL", (String) map.get("FLETTL"));
						hwpMap.put("FILEID", (String) map.get("FILEID"));
						hwpMap.put("INDT", (String) map.get("INDT"));
						hwpMap.put("yyyyMM", yyyyMM);
					} else {
						map.put("FLETTL", "[붙임."+ num++ +"]" + String.valueOf(map.get("FLETTL")));
					}
					
					String savedPath =  onnaraSubFilePath + "/" + yyyyMM; // 알파 저장 경로
					String downloadPath = onnaraFilePath + "/" + yyyyMM + "/"; // 온나라 파일 서버 경로
					
					map.put("gwFilePath", savedPath + "/" + realFileName);
					map.put("oFilePath", downloadPath + realFileName);
					map.put("extension", "");
					
					logger.info("alphafilePath ===" + savedPath + "/" + realFileName);
					
					File alphaFile = new File(savedPath + "/" + realFileName);
					
					if (!alphaFile.exists()) { // 로컬에 파일이 없을 시에만 실행
						
						if (channelSftp == null) {
							channelSftp = sFTPUtil2.connSFTP(onnaraInfo);
						}
						
						File f =new File(savedPath);
						
						if (!f.exists()) { // 저장할 경로 폴더가 존재하지 않을 시 생성
							logger.info("mkdir");
							f.mkdirs();
						} else {
							logger.info("not mkdir");
						}
						
						logger.info("saved : " + savedPath + "/" + realFileName);
						logger.info("downloadPath : " + downloadPath);
						
						sFTPUtil2.download(downloadPath, realFileName, savedPath + "/" + realFileName, channelSftp);
						
						// GW if_onnara_moved_file INSERT
						resAlphaG20DAO.saveFileInfo(map);
					}
				}
			}
		} catch (Exception e) {
			logger.info("Error : ", e);
		} finally {
			channelSftp.quit();
			try {
				channelSftp.disconnect();
				channelSftp = null;
			} catch (Exception e2) {
				logger.info("SFTP ERROR : ", e2);
			}
			sFTPUtil2.disconnectSFTP();
		}
		
		return hwpMap;
	}

	@Override
	public List<Map<String, Object>> getOnnaraDocAllFiles(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getOnnaraDocAllFiles(paramMap);
	}
	
	@Override
	public void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
			
				logger.info("fileId : " + request.getParameter("fileId"));
				map.put("fileId", (String)request.getParameter("fileId"));
		
				Map<String, Object> result =  resAlphaG20DAO.downloadFileInfo(map);
				
				String fileName = (String) result.get("o_org_file_name");
				String path =  (String) result.get("gw_file_path");
				
				logger.info("fileName : " + fileName);
				logger.info("path : " + path);
				
				try {
					fileDownLoad(fileName, path, request, response);
				} catch (Exception e) {
					logger.info("ERROR : ", e);
					e.printStackTrace();
				}
		
	}
	
	@Override
	public void downloadFile(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
		
		String fileName = (String) map.get("fileName");
		String path =  (String) map.get("path");
		
		try {
			fileDownLoad(fileName, path, request, response);
		} catch (Exception e) {
			logger.info("ERROR : ", e);
			e.printStackTrace();
		}
		
	}
	
	@Override
	public String makeZipFile(List<Map<String, Object>> fileList, HttpServletRequest request, HttpServletResponse response) {
			
		String zipFile = "/home/upload/ea/cust/zips";
		
		try {
			String uuid = UUID.randomUUID().toString();
			uuid = uuid.replace("-", "");
			
			zipFile += "/" + fileList.get(0).get("fillDate") + uuid + ".zip";
			
			File f = new File(zipFile);
			
			if (!f.exists()) {
				f.createNewFile();
			}
			
		    FileOutputStream fout = new FileOutputStream(zipFile);
		    ZipOutputStream zout = new ZipOutputStream(fout);

		    for (Map<String, Object> map : fileList) {
				
		    	String koFileName = String.valueOf(map.get("fileName"));
		    	
		    	for (int j = 0; j < invalidName.length; j++) {
		    		koFileName = koFileName.replaceAll(invalidName[j], "_");
				}
		    	
		    	//본래 파일명 유지, 경로제외 파일압축을 위해 new File로 
		    	ZipEntry zipEntry = new ZipEntry(new File(String.valueOf(map.get("fileFullPath")), koFileName).getName());
		    	
		    	zout.putNextEntry(zipEntry);
		    	
		    	//경로포함 압축
		    	//zout.putNextEntry(new ZipEntry(sourceFiles.get(i)));
		    	
		    	FileInputStream fin = new FileInputStream(String.valueOf(map.get("fileFullPath")));
		    	byte[] buffer = new byte[1024];
		    	int length;
		    	
		    	while((length = fin.read(buffer)) > 0){
		    		zout.write(buffer, 0, length);
		    	}
		    	
		    	zout.closeEntry();
		    	fin.close();
			}
		    

		    zout.close();

		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return zipFile;
	}
	
	public void fileDownLoad(String fileNm, String path, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		File reFile = null;

		reFile = new File(path);
		setDisposition(fileNm, request, response);
		
		try {
			in = new BufferedInputStream(new FileInputStream(reFile));
			out = new BufferedOutputStream(response.getOutputStream());
			
			FileCopyUtils.copy(in, out);
			out.flush();
		}catch (Exception e) {
			logger.info("ERROR : ", e);
		}
	}
	
	private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=\"";
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

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename + "\"");

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}
	
	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) { // IE 10 �씠�븯
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

	@Override
	public void saveOnnaraMapping(List<Map<String, Object>> list) {
		
		for (Map<String, Object> map : list) {
			resAlphaG20DAO.saveOnnaraMapping(map);
		}
	}

	@Override
	public List<Map<String, Object>> getDocMappingOnnaraDocId(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getDocMappingOnnaraDocId(paramMap);
	}

	@Override
	public Map<String, Object> getOnnaraDocInfo(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getOnnaraDocInfo(paramMap);
	}

	@Override
	public void saveToAttachInfo(List<Map<String, Object>> list, Map<String, Object> requestMap) {
		
		FileInputStream fis = null;
		FileOutputStream fos = null;
		String masterFileId = "";
		boolean flag = true;
		int chk = 0;
		
		try {
			
			for (int i = 1; i <= list.size(); i++) {
				
				Map<String, Object> resultMap = new HashMap<>();
				
				Map<String, Object> map = new HashMap<>();
				map = list.get(i-1);;

				String fileId = (String)map.get("o_file_id");
				String realFileName = (String)map.get("o_real_file_name"); // 실제 파일명
				int pos = realFileName.lastIndexOf( "." );
				
				String c_dikeycode = (String)requestMap.get("docSeq"); 	// DIKEYCODE 번호
				String orgFileName = (String)map.get("o_org_file_name"); // 기존 파일명
				String fileSize = (String)map.get("file_size");
				String extsn = realFileName.substring(pos + 1);
				String gwFilePath = (String)map.get("gw_file_path");
				
				if ("".equals(masterFileId)) { // 공통 사용할 파일 ID 생성 ( "onr" + 기존 onnara 파일ID )
					masterFileId = "onr" + fileId.substring(3);
				}
				
				//neos.a_attachinfo
				resultMap.put("c_dikeycode", c_dikeycode);	
				resultMap.put("c_aiseqnum", i);
				resultMap.put("c_aititle", orgFileName);
				resultMap.put("c_aifilename", realFileName);
				resultMap.put("c_aifiletype", extsn);
				resultMap.put("c_aisize", fileSize);
				resultMap.put("file_id", masterFileId);
				
				//neos.t_co_atch_file
				resultMap.put("create_seq", requestMap.get("empSeq"));
				
				//neos.t_co_atch_file_detail
				resultMap.put("file_sn", i);
				resultMap.put("file_stre_cours", gwFilePath.substring(0, gwFilePath.lastIndexOf("/")));
				resultMap.put("stre_file_name", realFileName.substring(0, realFileName.lastIndexOf(".")));
				resultMap.put("orignl_file_name", orgFileName);
				resultMap.put("file_extsn", extsn);
				resultMap.put("file_size", fileSize);
				
				logger.info("resultMap : " + resultMap);
				
				if (i == 1) {
					// 중복체크
					chk = resAlphaG20DAO.checkDupliOnnaraFileId(resultMap);
					
					if (chk > 0) {
						flag = false;
					} else {
						resAlphaG20DAO.saveToAttachFile(resultMap);
					}
				}
				
				if (flag) {
					resAlphaG20DAO.saveToAttachFileDetail(resultMap);
				}
				
				logger.info(" === @@@@@@@@@@@@@ === ");
				
				resAlphaG20DAO.saveToAttachInfo(resultMap);
			}
			
			logger.info("=== FINAL LOOP ===");
			
		} catch (Exception e) {
			logger.info("ERROR SERVICE : ", e);
		}
	}

	@Override
	public List<Map<String, Object>> getFileList(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getFileList(paramMap);
	}

	@Override
	public Map<String, Object> getRiOrgCode(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getRiOrgCode(paramMap);
	}

	@Override
	public List<Map<String, Object>> getOnnaraMovedFile(Map<String, Object> paramMap) {
		
		String fileKey = String.valueOf(paramMap.get("fileKey"));
		List<Map<String, Object>> tempSaveFileList = null;
		
		FileChannel fcin = null;
		FileChannel fcout = null;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		
		try {
			
			tempSaveFileList = resAlphaG20DAO.getOnnaraMovedFile(paramMap);
			Map<String, Object> onnaraDocInfo = resAlphaG20DAO.getOnnaraDocInfo(paramMap);
			
			for (Map<String, Object> fileMap : tempSaveFileList) {
				
				String realFileName = "";
				String gwFilePath = String.valueOf(fileMap.get("gw_file_path"));
				String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");

				if ("DFT01".equals(String.valueOf(fileMap.get("gubun")))) {
					Map<String, Object> onnaraFileMap = resAlphaG20DAO.getOnnaraFile(fileMap);
					realFileName = "[" + String.valueOf(onnaraDocInfo.get("AUTHORDEPTNAME")) + "-" + String.valueOf(onnaraDocInfo.get("DOCNOSEQ")) + "]" + String.valueOf(onnaraFileMap.get("FLETTL"));
				} else {
					realFileName = String.valueOf(fileMap.get("o_org_file_name"));
				}
				
				fis = new FileInputStream(gwFilePath);
				CommFileUtil.makeDir(tempPath + fileKey);
				fos = new FileOutputStream(tempPath + fileKey + File.separator + realFileName);
				
				fcin = fis.getChannel();
				fcout = fos.getChannel();
				
				long size = fcin.size();
				fcin.transferTo(0, size, fcout);
				
			}
				
		} catch (Exception e) {
			logger.info("ERROR : " , e);
		} finally {
			try {
				fcout.close();
				fcin.close();
				
				fis.close();
				fos.close();
			} catch (IOException e) {
				logger.info("ERROR : ", e);
			}
		} 
		
		
		return tempSaveFileList;
	}

	@Override
	public void updateOnnaraUsedStatus(Map<String, Object> paramMap) {
		resAlphaG20DAO.updateOnnaraUsedStatus(paramMap);
	}

	@Override
	public void saveUseOnnaraDocs(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> list = resAlphaG20DAO.getDocMappingOnnaraDocId(paramMap);
		
		for (Map<String, Object> map : list) {
			paramMap.put("o_docid", map.get("o_docid"));
			
			resAlphaG20DAO.saveUseOnnaraDocs(paramMap);
		}
	}

	@Override
	public List<Map<String, Object>> getAttachInfo(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>(); 
		List<Map<String, Object>> allList = null;
		
		try {
		
			//List<Map<String, Object>> orderOnnaraList = resAlphaG20DAO.getOrderedOnnnaraDocAttach(paramMap);
			allList = resAlphaG20DAO.getAttachInfo(paramMap);
			
			/*
			 * for (int i = orderOnnaraList.size(); i < allList.size(); i++) { // 순서1)
			 * 온나라문서를 제외한 증빙 이미지
			 * 
			 * resultList.add(allList.get(i)); }
			 * 
			 * for (int i = 0; i < orderOnnaraList.size(); i++) {
			 * 
			 * String orgFileName =
			 * String.valueOf(orderOnnaraList.get(i).get("o_org_file_name"));
			 * 
			 * for (Map<String, Object> map : allList) {
			 * 
			 * String tmpOrgFileName = String.valueOf(map.get("c_aititle")) + "." +
			 * String.valueOf(map.get("c_aifiletype"));
			 * 
			 * if (orgFileName.equals(tmpOrgFileName)) { resultList.add(map); } } }
			 */		
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		} 
		
		return allList;
	}
	
	@Override
	public List<Map<String, Object>> getAttachInfo2(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>(); 
		List<Map<String, Object>> allList = null;
		
		try {
		
			allList = resAlphaG20DAO.getAttachInfo2(paramMap);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		} 
		
		return allList;
	}

	@Override
	public void saveTradeBojo(HashMap<String, Object> requestMap) {
		resAlphaG20DAO.saveTradeBojo(requestMap);
	}

	@Override
	public List<Map<String, Object>> getTradeBojo(List<Map<String, Object>> param) {
		
		for (Map<String, Object> map : param) {
			Map<String, Object> resultMap = resAlphaG20DAO.getTradeBojo(map);
			
			map.put("bojoCode", String.valueOf(resultMap.get("bojoCode")));
			map.put("bojoUse", String.valueOf(resultMap.get("bojoUse")));
			map.put("bojoReasonCode", String.valueOf(resultMap.get("bojoReasonCode")));
			map.put("bojoReasonText", String.valueOf(resultMap.get("bojoReasonText")));
		}
		
		return param;
	}

	@Override
	public void updateTradeBojo(HashMap<String, Object> requestMap) {
		resAlphaG20DAO.updateTradeBojo(requestMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object getResTrade(HashMap<String, Object> requestMap) {
		Map<String, Object> resultMap = (Map<String, Object>)resAlphaG20DAO.getResTrade(requestMap);
		String interface_type = String.valueOf(resultMap.get("interface_type"));
		if(interface_type != null && "etax".equals(interface_type)) {
			String tax_ty = resAlphaG20DAO.getTaxTy(resultMap);
			if("3".equals(tax_ty) || "4".equals(tax_ty)) {
				interface_type = "notax";
				resultMap.put("interface_type", interface_type);
			}
		}
		return resultMap;
	}

	@Override
	public void savePdfEcmMain(PdfEcmMainVO vo) {
		resAlphaG20DAO.savePdfEcmMain(vo);
	}

	@Override
	public void updatePdfStatus(PdfEcmMainVO vo) {
		resAlphaG20DAO.updatePdfStatus(vo);
	}

	@Override
	public void savePdfEcmFile(PdfEcmFileVO vo) {
		resAlphaG20DAO.savePdfEcmFile(vo);
	}

	@Override
	public Map<String, Object> getDocOrg(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getDocOrg(paramMap);
	}

	@Override
	public Map<String, Object> userCardDetailInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> map = resAlphaG20DAO.userCardDetailInfo(paramMap);
		map.put("CO_CD", String.valueOf(paramMap.get("CO_CD")));
		
		//Map<String, Object> stradeMap = resAlphaG20DAO.selectErpTradeInfo(map);
		Map<String, Object> stradeMap = resAlphaG20DAO.selectTradeAddrInfo(map);
		
		String mercAddr = "";
		String mercTel = "";
		if (stradeMap != null) {
			
			if (stradeMap.get("CHAIN_ADDR1") != null && !String.valueOf(stradeMap.get("CHAIN_ADDR1")).equals("")) {
				mercAddr += String.valueOf(stradeMap.get("CHAIN_ADDR1"));
			}
			
			if (stradeMap.get("CHAIN_ADDR2") != null && !String.valueOf(stradeMap.get("CHAIN_ADDR2")).equals("")) {
				mercAddr += " " + String.valueOf(stradeMap.get("CHAIN_ADDR2"));
			}
			
			mercTel = stradeMap.get("CHAIN_TEL") != null ?  String.valueOf(stradeMap.get("CHAIN_TEL")) : "";
		}
		map.put("mercAddr", mercAddr);
		map.put("mercTel", mercTel);
		
		return map;
	}
	
	@Override
	public Map<String, Object> selectETaxDetailInfo(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectETaxDetailInfo(paramMap);
	}

	@Override
	public List<Map<String, Object>> getAllTradeInfo(Map<String, Object> param) {
		return resAlphaG20DAO.getAllTradeInfo(param);
	}

	@Override
	public Map<String, Object> getIssNo(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getIssNo(paramMap);
	}
	
	@Override
	public Map<String, Object> getEtaxSyncId(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getEtaxSyncId(paramMap);
	}

	@Override
	public void saveWorkFee(HashMap<String, Object> params) {
		resAlphaG20DAO.saveWorkFee(params);
	}

	@Override
	public Object getWorkFee(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getWorkFee(paramMap);
	}
	@Override
	public void saveDailyExp(Map<String, Object> params) {
		resAlphaG20DAO.saveDailyExp(params);
	}
	
	@Override
	public Object getDailyExp(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getDailyExp(paramMap);
	}

	@Override
	public List<Map<String, Object>> getErpEmpSeqInDept(Map<String, Object> param) {
		return resAlphaG20DAO.getErpEmpSeqInDept(param);
	}

	@Override
	public Map<String, Object> getCardInfoG20(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getCardInfoG20(paramMap);
	}

	@Override
	public List<Map<String, Object>> getUnRegisteredSaupList(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getUnRegisteredSaupList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> selectCardSeunginList(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectCardSeunginList(paramMap);
	}

	@Override
	public void updateCardAqTmp(Map<String, Object> params) throws Exception {
		resAlphaG20DAO.updateCardAqTmp(params);
	}

	@Override
	public void updateRestradeTbl(Map<String, Object> params) throws Exception {
		resAlphaG20DAO.updateRestradeTbl(params);
	}

	@Override
	public int checkUnRegister(Map<String, Object> params) throws Exception {
		return Integer.parseInt(resAlphaG20DAO.checkUnRegister(params));
	}

	@Override
	public void updateEtaxAqTmp(Map<String, Object> paramMap) throws Exception {
		resAlphaG20DAO.updateEtaxAqTmp(paramMap);
	}

	@Override
	public Map<String, Object> getBranchTradeInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> stradeMap = resAlphaG20DAO.selectTradeAddrInfo(paramMap);
		
		String mercAddr = "";
		String mercTel = "";
		if (stradeMap != null) {
			
			if (stradeMap.get("CHAIN_ADDR1") != null && !String.valueOf(stradeMap.get("CHAIN_ADDR1")).equals("")) {
				mercAddr += String.valueOf(stradeMap.get("CHAIN_ADDR1"));
			}
			
			if (stradeMap.get("CHAIN_ADDR2") != null && !String.valueOf(stradeMap.get("CHAIN_ADDR2")).equals("")) {
				mercAddr += " " + String.valueOf(stradeMap.get("CHAIN_ADDR2"));
			}
			
			mercTel = stradeMap.get("CHAIN_TEL") != null ?  String.valueOf(stradeMap.get("CHAIN_TEL")) : "";
		}
		stradeMap.put("mercAddr", mercAddr);
		stradeMap.put("mercTel", mercTel);
		
		return stradeMap;
	}

	@Override
	public List<Map<String, Object>> selectPdfErrorDocs(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectPdfErrorDocs(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectAdocuListByFillDt(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> resultList = new ArrayList<>();
		List<Map<String, Object>> msList = resAlphaG20DAO.selectAdocuListByFillDt(paramMap);
		
		// 회계전표 리스트 호출
		for (Map<String, Object> map : msList) { 
			Map<String, Object> returnMap = resAlphaG20DAO.selectAdocuAndDailyDocs(map);
			
			Map<String, Object> tmpMap = new HashMap<>();
			
			tmpMap.put("rep_id", "FINAL" + String.valueOf(returnMap.get("c_dikeycode")));
			
			Map<String, Object> checkMap = resAlphaG20DAO.checkFinalPDF(tmpMap);
			
			if (checkMap != null) {
				map.put("final_pdf_path", String.valueOf(checkMap.get("pdf_path")));
				map.put("final_pdf_name", String.valueOf(checkMap.get("pdf_name")));
			} else {
				map.put("final_pdf_path", "");
				map.put("final_pdf_name", "");
			}
			
			map.putAll(returnMap);
		}
		
		// 일계표 리스트 호출
		Map<String, Object> dailyInfo = resAlphaG20DAO.selectAdocuAndDailyDocs(paramMap);
		
		Map<String, Object> tmpMap = new HashMap<>();
		
		tmpMap.put("rep_id", "FINAL" + String.valueOf(dailyInfo.get("c_dikeycode")));
		
		Map<String, Object> checkMap = resAlphaG20DAO.checkFinalPDF(tmpMap);
		
		if (checkMap != null) {
			dailyInfo.put("final_pdf_path", String.valueOf(checkMap.get("pdf_path")));
			dailyInfo.put("final_pdf_name", String.valueOf(checkMap.get("pdf_name")));
		} else {
			dailyInfo.put("final_pdf_path", "");
			dailyInfo.put("final_pdf_name", "");
		}
		
		// 일계표 -> 회계전표 순으로 데이터셋
		resultList.add(dailyInfo);
		resultList.addAll(msList);
		
		return resultList;
	}
	
	@Override
	public Map<String, Object> selectAdocuAndDailyDocs(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectAdocuAndDailyDocs(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectCardFullList(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> list = resAlphaG20DAO.selectCardFullList(paramMap);
		
		for (Map<String, Object> map : list) {
			List<Map<String, Object>> returnMap = resAlphaG20DAO.selectReturnCardLog(map);

			map.put("totalAmt", map.get("tradeAmt"));
			
			if (returnMap != null) {
				
				int totalAmt = Integer.parseInt(String.valueOf(map.get("totalAmt")));
				for (int i = 0; i < returnMap.size(); i++) {
					totalAmt += Integer.parseInt(String.valueOf(returnMap.get(i).get("trade_amt")));
				}
				map.put("totalAmt", totalAmt);
			}
		}
		
		return list;
	}

	@Override
	public void saveReturnCardLog(Map<String, Object> params) {
		resAlphaG20DAO.saveReturnCardLog(params);
	}
	
	@Override
	public void saveSelfPayCard(Map<String, Object> params) {
		resAlphaG20DAO.saveSelfPayCard(params);
	}
	
	@Override
	public void updateSelfPayCard(Map<String, Object> paramMap) {
		resAlphaG20DAO.updateSelfPayCard(paramMap);
	}
	
	@Override
	public void saveAdjustPayCard(Map<String, Object> params) {
		resAlphaG20DAO.saveAdjustPayCard(params);
	}
	
	@Override
	public void updateAdjustPayCard(Map<String, Object> paramMap) {
		resAlphaG20DAO.updateAdjustPayCard(paramMap);
	}
	
	@Override
	public Map<String, Object> selectReturnCardLogInfo(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectReturnCardLogInfo(paramMap);
	}
	
	@Override
	public int selectCardFullListTotal(Map<String, Object> paramMap) {
		int i = resAlphaG20DAO.selectCardFullListTotal(paramMap);
		return i;
	}
	

	@Override
	public void saveCardNotionInfo(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveCardNotionInfo(paramMap);		
	}

	@Override
	public void deleteCardNotionInfo(Map<String, Object> paramMap) {
		resAlphaG20DAO.deleteCardNotionInfo(paramMap);		
	}

	@Override
	public List<Map<String, Object>> selectCardNotionInfoList(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectCardNotionInfoList(paramMap);
	}

	@Override
	public Map<String, Object> selectCardNotionCycle(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectCardNotionCycle(paramMap);
	}

	@Override
	public void saveCardNotionCycle(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveCardNotionCycle(paramMap);
	}

	@Override
	public void updateCardNotionCycle(Map<String, Object> paramMap) {
		resAlphaG20DAO.updateCardNotionCycle(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectCardInfoList(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectCardInfoList(paramMap);
	}

	@Override
	public Map<String, Object> selectReturnEtaxLogInfo(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectReturnEtaxLogInfo(paramMap);
	}

	@Override
	public void saveReturnEtaxLog(Map<String, Object> params) {
		resAlphaG20DAO.saveReturnEtaxLog(params);
	}

	@Override
	public List<Map<String, Object>> getMoniteringEtaxList(Map<String, Object> paramMap) {
		
		List<Map<String, Object>> list = resAlphaG20DAO.getMoniteringEtaxList(paramMap);
		
		for (Map<String, Object> map : list) {
			
			Map<String, Object> tmp = resAlphaG20DAO.selectMoniteringDetails(map);
			List<Map<String, Object>> logList = resAlphaG20DAO.selectReturnEtaxLog(tmp);
			
			if (tmp != null) {
				map.put("totalAmt", tmp.get("totalAmt"));
				map.put("sendYn", tmp.get("sendYn"));
			} else {
				map.put("totalAmt", 0);
				map.put("sendYn", "N");
			}
			
			if (logList != null) {
				
				int totalAmt = Integer.parseInt(String.valueOf(map.get("totalAmt")));
				for (int i = 0; i < logList.size(); i++) {
					totalAmt += Integer.parseInt(String.valueOf(logList.get(i).get("trade_amt")));
				}
				
				map.put("totalAmt", totalAmt);
			}
		}
		
		return list;
	}
	
	@Override
	public void saveResalphaAttach(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveResalphaAttach(paramMap);		
	}
	
	@Override
	public void deleteResalphaAttach(Map<String, Object> paramMap) {
		resAlphaG20DAO.deleteResalphaAttach(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectResalphaAttachList(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectResalphaAttachList(paramMap);
	}

	@Override
	public Map<String, Object> insertAttachFile(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception {
		
		Iterator<String> files = multi.getFileNames();
		
		Map<String, Object> docInfo = resAlphaG20DAO.getDocOrg(map);
		
		String c_difilepath = String.valueOf(docInfo.get("c_difilepath"));
		
		if (c_difilepath != null) {
			c_difilepath = c_difilepath.split("documentDir")[1];
		}
		
		while(files.hasNext()){
			
			String uploadFile 		= files.next();                         
			MultipartFile mFile 	= multi.getFile(uploadFile);            
           	String fileName 		= mFile.getOriginalFilename();
           	String ext 				= fileName.substring(fileName.lastIndexOf(".")+1);
           	         fileName		= fileName.substring(0, fileName.lastIndexOf("."));
			String fileSize 			= String.valueOf(mFile.getSize());
			
			String filePath = addFinalServerPath + c_difilepath + "/"; // [ ex) /home/upload/finalPd/1208/2020/07/13/ ]
			
			map.put("file_seq", resAlphaG20DAO.getCommFileSeq(map));
			map.put("file_name", fileName);
			map.put("file_size", fileSize);
			map.put("status", "ADD");
			map.put("file_extension", ext);
			map.put("file_path", addFinalServerPath + c_difilepath);
			map.put("real_file_name", String.valueOf(map.get("C_DIKEYCODE")) + "_" + String.valueOf(map.get("file_seq")));
			
			String rstFileNameWithExt = String.valueOf(map.get("C_DIKEYCODE")) + "_" + String.valueOf(map.get("file_seq")) + "." + ext;
			
			resAlphaG20DAO.saveResalphaAttach(map);
			
			File dir = new File(filePath);
        	
            if(!dir.isDirectory()){
                dir.mkdirs();
            }
            
            mFile.transferTo(new File(filePath + rstFileNameWithExt));
		}
		
		return map;
		
	}

	@Override
	public Map<String, Object> checkFinalPDF(Map<String, Object> paramMap) {
		return resAlphaG20DAO.checkFinalPDF(paramMap);
	}
	
	@Override
	public String getAdocuTradeListCnt(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getAdocuTradeListCnt(paramMap);
	}
	
	@Override
	public String getAdocuTradeInfoTotal(Map<String, Object> paramMap) {
		return resAlphaG20DAO.getAdocuTradeInfoTotal(paramMap);
	}

	@Override
	public List<Map<String, Object>> getAdocuTradeList(Map<String, Object> paramMap) {
		
		Map<String, Object> param = new HashMap<>();
		
		List<Map<String, Object>> tradeList = resAlphaG20DAO.getAdocuTradeList(paramMap); // MSSQL 기준 전표확정 거래처 리스트
		
		param.put("list", tradeList);
		
		resAlphaG20DAO.saveAdocuTmp(param);
		
		return resAlphaG20DAO.getAdocuTradeInfo(paramMap);
	}

	@Override
	public void saveInfoAboutSms(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveInfoAboutSms(paramMap);
		
	}

	@Override
	public List<Map<String, Object>> notionNotSettleCard() {
		
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("interfaceType", "card");
		paramMap.put("skip", 1);
		paramMap.put("pageSize", 1000);
		
		Map<String, Object> cycleMap = resAlphaG20DAO.selectCardNotionCycle(paramMap);
		int cycle = Integer.valueOf(String.valueOf(cycleMap.get("cycle")));
		
		/**
		 *  알림 기한 계산
		 */
		Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        
        cal.add(Calendar.DATE, -(cycle + 1));
        
        paramMap.put("fromDate", df.format(cal.getTime()));
        paramMap.put("toDate", df.format(cal.getTime()));
        
        List<Map<String, Object>> list = resAlphaG20DAO.selectCardFullList(paramMap);
		
		for (Map<String, Object> map : list) {
			List<Map<String, Object>> returnMap = resAlphaG20DAO.selectReturnCardLog(map);

			map.put("totalAmt", map.get("tradeAmt"));
			
			if (returnMap != null) {
				
				int totalAmt = Integer.parseInt(String.valueOf(map.get("totalAmt")));
				for (int i = 0; i < returnMap.size(); i++) {
					totalAmt += Integer.parseInt(String.valueOf(returnMap.get(i).get("trade_amt")));
				}
				map.put("totalAmt", totalAmt);
			}
		}
		
		/**
		 *  카드 미정산 데이터들 처리 후 테이블 INSERT
		 */
		for (Map<String, Object> map : list) {
			int remainingAmt 	= Integer.parseInt(String.valueOf(map.get("reqAmt"))) 
									- Integer.parseInt(String.valueOf(map.get("totalAmt")))
									+ Integer.parseInt(String.valueOf(map.get("selfAmt")))
									+ Integer.parseInt(String.valueOf(map.get("adjustAmt")));
			
			if (remainingAmt != 0) { // 미정산 데이터들
				System.out.println("@@ map : " + map);
				resAlphaG20DAO.saveCardAlamBatch(map);
			}
		}
		
		return list;		
	}

	@Override
	public List<Map<String, Object>> selectCardAlamBatchLog(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectCardAlamBatchLog(paramMap);
	}

	@Override
	public void saveCardAlamBatch(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveCardAlamBatch(paramMap);
	}

	@Override
	public void sendCardAlamBatch() {
		
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("sendYN", "N");
		
		List<Map<String, Object>> notSettleCardList = resAlphaG20DAO.selectCardAlamBatchLog(paramMap);
		
		for (Map<String, Object> map : notSettleCardList) {
			resAlphaG20DAO.selectCardNotionInfoList(map);
		}
	}

	@Override
	public void saveSmsMessage(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveSmsMessage(paramMap);
	}

	@Override
	public void updateSmsMessage(Map<String, Object> paramMap) {
		resAlphaG20DAO.updateSmsMessage(paramMap);
	}

	@Override
	public String selectSmsMessage(Map<String, Object> paramMap) {
		return resAlphaG20DAO.selectSmsMessage(paramMap);
	}

	@Override
	public void saveSmsLog(Map<String, Object> paramMap) {
		resAlphaG20DAO.saveSmsLog(paramMap);
	}
	
	@Override
	public void deleteAdocuTmp(Map<String, Object> paramMap) {
		resAlphaG20DAO.deleteAdocuTmp(paramMap);		
	}
}















