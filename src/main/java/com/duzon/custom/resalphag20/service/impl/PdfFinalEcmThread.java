package com.duzon.custom.resalphag20.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.logging.log4j.LogManager;

import com.duzon.custom.kukgoh.dao.KukgohDAO;
import com.duzon.custom.kukgoh.util.EsbUtils;
import com.duzon.custom.kukgoh.util.Utils;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;

public class PdfFinalEcmThread implements Runnable {
	private static org.apache.logging.log4j.Logger logger = LogManager.getLogger( PdfFinalEcmThread.class );
	
	private Map<String, Object> paramMap;
	private List<Map<String, Object>> fileList = new ArrayList<>();
	private List<PdfEcmFileVO> pdfEcmList = new ArrayList<>();
	private ResAlphaG20Service resAlphaG20Service = null;
	private String orgDocFileSubName = "_0000000001";
	private int count = 1;
	private int cnt = 1;
	private String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"};
	List<String> EXTS = Arrays.asList("pdf", "hwp", "jpg", "jpeg", "tiff", "bmp", "gif", "png", "wmf", "xls", "xlsx", "doc", "docx", "ppt", "pptx", "txt", "html", "htm");
	
	public PdfFinalEcmThread() {}
	
	public PdfFinalEcmThread(List<Map<String, Object>> fileList, ResAlphaG20Service resAlphaG20Service, Map<String, Object> paramMap) {
		this.fileList = fileList;
		this.resAlphaG20Service = resAlphaG20Service;
		this.paramMap = paramMap;
	}

	@Override
	public void run() {
		logger.info("PdfFinalEcmThread Start");
		process();
	}
	
	private void process(){
		
		try {
			Thread.sleep(10000);
			
			String c_dikeycode 			= String.valueOf(paramMap.get("C_DIKEYCODE"));
			String compSeq 				= String.valueOf(paramMap.get("compSeq"));
			String deptSeq 				= String.valueOf(paramMap.get("deptSeq"));
			String empSeq 				= String.valueOf(paramMap.get("empSeq"));
			String finalSavedPath		= String.valueOf(paramMap.get("finalSavedPath"));
			String finalSavedFileName	= String.valueOf(paramMap.get("finalSavedFileName"));
			String attachFilePath		= "";
			String zipAttachFilePath		= "";
			String rep_id 			= "FINAL" + c_dikeycode;
			
			logger.info("============ point 1 ================");
			
			for (int i = 0; i < fileList.size(); i++) { // 원문을 제외한 파일
				PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
				
				String ext 				= String.valueOf(fileList.get(i).get("file_extsn"));		// 확장자
				String fileName 		= String.valueOf(fileList.get(i).get("stre_file_name")); // 실제 저장 파일이름
				String docTitle 		= String.valueOf(fileList.get(i).get("c_aititle"));			// 보여질 파일 이름
				attachFilePath			= String.valueOf(fileList.get(i).get("attachFilePath"));		// Z: 파일경로
				zipAttachFilePath		= String.valueOf(fileList.get(i).get("zipAttachFilePath"));	// /home 파일경로
				
				if (ext.equals("zip")) {
//					unzip(zipAttachFilePath + fileName + "." + ext, pdfEcmList, rep_id, compSeq, docTitle);
				} else if (EXTS.contains(ext.toLowerCase())){
					pdfEcmFileVO.setRep_id(rep_id);
					pdfEcmFileVO.setComp_seq(compSeq);
					pdfEcmFileVO.setDoc_id(docTitle);
					pdfEcmFileVO.setDoc_path(attachFilePath);
					pdfEcmFileVO.setDoc_ext(ext);
					pdfEcmFileVO.setDoc_no((count > 9 ? "0" : "00") + count++);
					pdfEcmFileVO.setDoc_name(fileName);
					
					for (int j = 0; j < invalidName.length; j++) {
						docTitle = docTitle.replaceAll(invalidName[j], "_");
					}
					
					pdfEcmFileVO.setDoc_title(cnt++ + "_" + docTitle);
					
					pdfEcmList.add(pdfEcmFileVO);
				} 
			}
			
			PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();
			
			pdfEcmMainVO.setRep_id(rep_id);
			pdfEcmMainVO.setComp_seq(compSeq);
			pdfEcmMainVO.setDept_seq(deptSeq);
			pdfEcmMainVO.setEmp_seq(empSeq);
			pdfEcmMainVO.setPdf_path(finalSavedPath);
			pdfEcmMainVO.setPdf_name(finalSavedFileName);
			pdfEcmMainVO.setStatus_cd("D0001");
			
			pdfEcmMainVO.setList(pdfEcmList);
			
			logger.info("pdfEcmMainVO : " + pdfEcmMainVO);
			logger.info("pdfEcmList : " + pdfEcmList);
			
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
	
	public void unzip(String file, List<PdfEcmFileVO> pdfEcmList, String rep_id, String compSeq, String c_aititle
			) {

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
	            
	            if (ext.equals("zip") || !EXTS.contains(ext.toLowerCase())) {
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
	            
	            pdfEcmFileVO.setRep_id(rep_id);
				pdfEcmFileVO.setComp_seq(compSeq);
				pdfEcmFileVO.setDoc_id(c_aititle);
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

	    } catch (Exception e) {
	        logger.info("ERROR : ", e);
	    }
	}
}
