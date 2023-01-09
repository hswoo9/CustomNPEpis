package com.duzon.custom.resalphag20.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import org.apache.log4j.Logger;
import org.apache.logging.log4j.LogManager;

import com.duzon.custom.kukgoh.dao.KukgohDAO;
import com.duzon.custom.kukgoh.util.EsbUtils;
import com.duzon.custom.kukgoh.util.Utils;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;

import ac.g20.app.dao.PurcReqAppDAO;
import ac.g20.app.service.impl.PurcReqThread;

public class PdfEcmThread implements Runnable {
	private static org.apache.logging.log4j.Logger logger = LogManager.getLogger( PdfEcmThread.class );
	
	private ResAlphaG20Service resAlphaG20Service;
	private KukgohDAO kukgohDAO;
	private Map<String, Object> paramMap;
	private String pdfServerRootPath;
	private String orgDocExt = "html";
	private String orgDocFileSubName = "_0000000001";
	private int count = 2;
	private int cnt = 1;
	private String prefix = "";
	private String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"};
	List<String> EXTS = Arrays.asList("pdf", "hwp", "jpg", "jpeg", "tiff", "bmp", "gif", "png", "wmf", "xls", "xlsx", "doc", "docx", "ppt", "pptx", "txt", "html", "htm");
	
	public PdfEcmThread() {}
	
	public PdfEcmThread(Map<String, Object> paramMap, ResAlphaG20Service resAlphaG20Service, String pdfServerRootPath, KukgohDAO kukgohDAO){
		this.paramMap = paramMap;
		this.resAlphaG20Service = resAlphaG20Service;
		this.pdfServerRootPath = pdfServerRootPath;
		this.kukgohDAO = kukgohDAO;
	}

	@Override
	public void run() {
		logger.info("PdfEcmThread Start");
		process();
	}
	
	private void process(){
		
		try {
			Thread.sleep(10000);
			
			Utils util = new Utils();
			String systemCode = "EPIS";
			int wasNum = 1;
			String intrfcId = "IF-EXE-EFR-0074";
			
			List<PdfEcmFileVO> pdfEcmList = new ArrayList<PdfEcmFileVO>();
			List<Map<String, Object>> orderedList =  resAlphaG20Service.getAttachInfo(paramMap);
			Map<String, Object> docOrg = resAlphaG20Service.getDocOrg(paramMap);
		  
			String c_dikeycode 	= String.valueOf(paramMap.get("C_DIKEYCODE"));
			String compSeq 		= String.valueOf(paramMap.get("compSeq"));
			String deptSeq 		= String.valueOf(paramMap.get("deptSeq"));
			String empSeq 		= String.valueOf(paramMap.get("empSeq"));
			String groupSeq 		= String.valueOf(paramMap.get("groupSeq"));
			
			String c_diFilePath 				= String.valueOf(docOrg.get("c_difilepath"));
			String orgDocFilePath 			= "";
			String attachFilePath			= "";
			String zipAttachFilePath 		= "";
			String orgDocFilePathHtml 		= "";
			
			String[] c_diFilePathArr = c_diFilePath.split("/");
			
			for (int j = 0; j < c_diFilePathArr.length; j++) {
				
				if (j > 1) {
					orgDocFilePath += c_diFilePathArr[j] + "/";
				}
			}
			
			zipAttachFilePath = "/home/" + orgDocFilePath.substring(0, orgDocFilePath.length()); // 첨부파일 경로
			attachFilePath = pdfServerRootPath + orgDocFilePath.substring(0, orgDocFilePath.length()); // 첨부파일 경로
			orgDocFilePathHtml = pdfServerRootPath + orgDocFilePath; // 원문파일 HTML 경로
			orgDocFilePath = pdfServerRootPath + orgDocFilePath + c_dikeycode; // 원문파일 경로
			
			logger.info("============ point 1 ================");
			logger.info(kukgohDAO);
			if (kukgohDAO != null) {
				prefix = "[결의서]";
			}
			//  === Enara 도움 파일 경로 ( kukgoh_attach_file ) 테이블에 INSERT ===
			String kukgohFileName = "";
			if (kukgohDAO != null) {
				logger.info("============ point 2 ================");
				Map<String, Object> kukgohAttachMap = new HashMap<String, Object>();
				
				kukgohAttachMap.put("targetTableName", "kukgoh");
				kukgohAttachMap.put("fileSeq","1");
				kukgohAttachMap.put("targetId", "MASTER");
				kukgohAttachMap.put("C_DIKEYCODE", c_dikeycode);
				kukgohDAO.insertAttachFile(kukgohAttachMap);
				
				String trnscId = EsbUtils.getTransactionId(intrfcId, systemCode, wasNum);
				kukgohFileName = util.makeFileName(trnscId, kukgohAttachMap.get("attach_file_id").toString());
				kukgohAttachMap.put("rstFileName", kukgohFileName);
				kukgohAttachMap.put("fileNm", String.valueOf(docOrg.get("c_dititle")));
				kukgohAttachMap.put("ext", "pdf");
				kukgohAttachMap.put("filePath", c_diFilePath + "/" + c_dikeycode + "/");
				kukgohAttachMap.put("fileSize", "0");
				
				kukgohDAO.commFileInfoUpdate(kukgohAttachMap);
			} else {
				logger.info("============ point 3 ================");
				String processId = String.valueOf(paramMap.get("processId"));
				logger.info("processId : " + processId);
				kukgohFileName = processId + "_" + c_dikeycode;
			}
			// === Enara 도움 파일 경로 ( kukgoh_attach_file ) 테이블에 INSERT 종료 ===
			
			if (docOrg != null) { // 원문파일
				PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
				
				pdfEcmFileVO.setRep_id(c_dikeycode);
				pdfEcmFileVO.setComp_seq(compSeq);
				pdfEcmFileVO.setDoc_id(String.valueOf(docOrg.get("c_dititle")));
				pdfEcmFileVO.setDoc_path(orgDocFilePathHtml);
				pdfEcmFileVO.setDoc_ext(orgDocExt);
				pdfEcmFileVO.setDoc_no("001");
				pdfEcmFileVO.setDoc_name(c_dikeycode + orgDocFileSubName);
				pdfEcmFileVO.setDoc_title(prefix + String.valueOf(docOrg.get("c_dititle")));
				
				pdfEcmList.add(pdfEcmFileVO);
			}
			
			for (int i = 0; i < orderedList.size(); i++) { // 원문을 제외한 파일
				PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
				
				String ext = String.valueOf(orderedList.get(i).get("c_aifiletype"));
				String fileName = String.valueOf(orderedList.get(i).get("stre_file_name"));
				String c_dititle = String.valueOf(docOrg.get("c_dititle"));
				
				logger.info("ext : "+ ext);
				logger.info("fileName : "+ fileName);
				logger.info("c_dititle : "+ c_dititle);
				
				if (ext.equals("zip")) {
					unzip(zipAttachFilePath + fileName + "." + ext, pdfEcmList, c_dikeycode, compSeq, c_dititle);
				} else if (EXTS.contains(ext.toLowerCase())){
					pdfEcmFileVO.setRep_id(c_dikeycode);
					pdfEcmFileVO.setComp_seq(compSeq);
					pdfEcmFileVO.setDoc_id(c_dititle);
					pdfEcmFileVO.setDoc_path(attachFilePath);
					pdfEcmFileVO.setDoc_ext(String.valueOf(orderedList.get(i).get("c_aifiletype")));
					pdfEcmFileVO.setDoc_no((count > 9 ? "0" : "00") + count++);
					pdfEcmFileVO.setDoc_name(fileName);
					
					String docTitle = String.valueOf(orderedList.get(i).get("c_aititle"));
					for (int j = 0; j < invalidName.length; j++) {
						docTitle = docTitle.replaceAll(invalidName[j], "_");
					}
					
					pdfEcmFileVO.setDoc_title(cnt++ + "_" + docTitle);
					
					pdfEcmList.add(pdfEcmFileVO);
				} 
			}
			
			PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();
			
			pdfEcmMainVO.setRep_id(c_dikeycode);
			pdfEcmMainVO.setComp_seq(compSeq);
			pdfEcmMainVO.setDept_seq(deptSeq);
			pdfEcmMainVO.setEmp_seq(empSeq);
			pdfEcmMainVO.setPdf_path(orgDocFilePath);
			pdfEcmMainVO.setPdf_name(kukgohFileName);
			pdfEcmMainVO.setStatus_cd("D0001");
			
			pdfEcmMainVO.setList(pdfEcmList);
			
			logger.info("pdfEcmMainVO : " + pdfEcmMainVO);
			
			for (PdfEcmFileVO vo : pdfEcmList) {
				resAlphaG20Service.savePdfEcmFile(vo);
			}
			
			resAlphaG20Service.savePdfEcmMain(pdfEcmMainVO);
				
		} catch (InterruptedException e) {
			logger.info("ERROR : ", e);
		} catch (Exception e){
			logger.info("ERROR : ", e);
		}
	}
	
	public void unzip(String file, List<PdfEcmFileVO> pdfEcmList, String c_dikeycode, String compSeq, String c_dititle) {

	    try {
	    	logger.info("Start : Unzip");
	    	logger.info("zip File Path : " + file);
	    	Charset charset = Charset.forName("EUC-KR");
	        File fSourceZip = new File(file);
	        String zipPath = file.substring(0, file.length() - 4);
	        logger.info("zipPath : " + zipPath);
	        File temp = new File(zipPath);
	        temp.mkdir();

	        ZipFile zipFile = new ZipFile(fSourceZip, charset);
	        Enumeration<? extends ZipEntry> e = zipFile.entries();
	        PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
	        
	        while (e.hasMoreElements()) {
	        	logger.info("Loop start !!");
	            ZipEntry entry = (ZipEntry) e.nextElement();
	            File destinationFilePath = new File(zipPath, entry.getName());
	            
	            logger.info("entry.getName : " + entry.getName());
	            
	            String ext = destinationFilePath.getName().substring(destinationFilePath.getName().lastIndexOf(".") + 1);
	            destinationFilePath.getParentFile().mkdirs();
	            
	            if (!EXTS.contains(ext.toLowerCase()) && !"zip".equals(ext)) {
	            	continue;
	            }
	            
	            if (entry.isDirectory()) {
	                continue;
	            } else {
	            	pdfEcmFileVO = new PdfEcmFileVO();
	                logger.info("Extracting : " + destinationFilePath.getAbsolutePath());

	                BufferedInputStream bis = new BufferedInputStream(
	                        zipFile.getInputStream(entry));

	                int b;
	                byte buffer[] = new byte[1024];


	                FileOutputStream fos = new FileOutputStream(destinationFilePath);
	                BufferedOutputStream bos = new BufferedOutputStream(fos, 1024);

	                while ((b = bis.read(buffer, 0, 1024)) != -1) {
	                    bos.write(buffer, 0, b);
	                }

	                bos.flush();
	                bos.close();
	                bis.close();
	            }
	            
	            if (ext.equals("zip")) {
	            	unzip(destinationFilePath.getAbsolutePath(), pdfEcmList, c_dikeycode, compSeq, c_dititle);
	            } else {
	            	pdfEcmFileVO.setRep_id(c_dikeycode);
	            	pdfEcmFileVO.setComp_seq(compSeq);
	            	pdfEcmFileVO.setDoc_id(c_dititle);
	            	pdfEcmFileVO.setDoc_path(destinationFilePath.getParent().replace("/home", "Z:"));
	            	pdfEcmFileVO.setDoc_ext(ext);
	            	pdfEcmFileVO.setDoc_no((count > 9 ? "0" : "00") + count++);
	            	pdfEcmFileVO.setDoc_name(destinationFilePath.getName().substring(0, destinationFilePath.getName().lastIndexOf(".")));
	            	
	            	String docTitle = String.valueOf(destinationFilePath.getName().substring(0, destinationFilePath.getName().lastIndexOf(".")));
	            	for (int j = 0; j < invalidName.length; j++) {
	            		docTitle = docTitle.replaceAll(invalidName[j], "_");
	            	}
	            	
	            	pdfEcmFileVO.setDoc_title(cnt++ + "_" + docTitle);
	            	
	            	pdfEcmList.add(pdfEcmFileVO);
	            }
	        }

	    } catch (Exception e) {
	        logger.info("ERROR : ", e);
	    }
	}
}
