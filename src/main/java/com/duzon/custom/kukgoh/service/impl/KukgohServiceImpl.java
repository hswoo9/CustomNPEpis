package com.duzon.custom.kukgoh.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.jexl2.Main;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.common.dao.CommonDAO;
import com.duzon.custom.kukgoh.controller.KukgohContorller;
import com.duzon.custom.kukgoh.dao.KukgohDAO;
import com.duzon.custom.kukgoh.service.KukgohService;
import com.duzon.custom.kukgoh.util.EsbUtils;
import com.duzon.custom.kukgoh.util.HttpClientSample;
import com.duzon.custom.kukgoh.util.KukgohCommVO;
import com.duzon.custom.kukgoh.util.SFTPUtil;
import com.duzon.custom.kukgoh.util.Utils;
import com.duzon.custom.resalphag20.dao.ResAlphaG20DAO;
import com.ibm.icu.text.SimpleDateFormat;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;

@Service("kukgohService")
public class KukgohServiceImpl implements KukgohService{
	
	private static final Logger logger = (Logger) LoggerFactory.getLogger(KukgohServiceImpl.class);
	
	@Autowired
	KukgohDAO kukgohDAO;
	
	@Autowired
	ResAlphaG20DAO resAlphaG20DAO;
	
	@Autowired
	private CommonDAO commonDAO;
	
	@Autowired
	protected DataSourceTransactionManager transactionManager;	
	
	
	@Value("#{bizboxa['BizboxA.fileRootPath']}")
	private String fileRootPath;
	
	final String  T_IF_INTRFC_FILE = "T_IF_INTRFC_FILE";
	static final  String PATHSEPARATOR = "/";
	@Override
	public boolean code01save(List<KukgohCommVO> kukgohInfoList ) {
			//return kukgohDAO.saveCommCode(kukgohInfoList);
		return true;
	}
	
	//TODO 트랜잭션 처리
	@Override
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public Map<String, Object> getRemoteFile(Map<String, Object> map4) throws SftpException, IOException {
		SFTPUtil sFTPUtil = SFTPUtil.getInstance();
		ChannelSftp channelSftp = new ChannelSftp();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> erpInfo = new HashMap<String, Object>();
		//String remoteDir = (String)map4.get("remoteDir");
		String remoteDir = "";
		String empSeq = (String)map4.get("EMP_SEQ");
		String ip = (String)map4.get("EMP_IP");
		String code_val = (String)map4.get("CODE_VAL");
		String exInterfaceId = null;
		String exTransactionId = null;
		String exTableNm = null;
		String exFileName = null;
		
		//트랜잭션 설정
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);
		Map<String, Object> result = new HashMap<String, Object>(); 
	    erpInfo =	kukgohDAO.getErpInfo(); 
	    channelSftp = sFTPUtil.connSFTP(erpInfo);
	    
	    //파일다운로드
	    List<Map<String, Object>> enaraIntrfcIdList = new ArrayList<Map<String, Object>>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("code_desc", "rcv");
		paramMap.put("code_val", code_val);
		enaraIntrfcIdList = kukgohDAO.getRcvEnaraInterfaceId(paramMap);
		
		//Vector<ChannelSftp.LsEntry> intrfcFolderList = readIntrfc(channelSftp, remoteRootPath);
		Map<String, String> tempDirPath = new HashMap<String, String>();
		tempDirPath.put("groupCode", "ENARA");
		tempDirPath.put("code", "REMOTE_RCV_DIR");
		Map<String, Object> remoteDirPath = commonDAO.getCodeOne(tempDirPath);
		tempDirPath.put("code", "LOCAL_RCV_DIR");
		Map<String, Object> localDirPath = commonDAO.getCodeOne(tempDirPath);
		String remoteRootPath = (String)remoteDirPath.get("code_kr");
		String localRootPath = (String)localDirPath.get("code_kr");
		Vector<ChannelSftp.LsEntry> fileAndFolderList;
  		fileAndFolderList = channelSftp.ls(remoteRootPath); // G20 해당 인터페이스 폴더에 목록 가져오기

  		try {
			
			for (ChannelSftp.LsEntry intrfcItem : fileAndFolderList) {
				for (Map intrfcMap : enaraIntrfcIdList) {
					String intrfcId = intrfcMap.get("code").toString();
					exInterfaceId = intrfcId;
					if(intrfcId.equals(intrfcItem.getFilename())) {
						logger.info("intrfcId : "+ intrfcId);
						//인터페이스 내 폴더로 이동
						String remoteIntrfcPath = remoteRootPath + PATHSEPARATOR + intrfcId;
						String localIntrfcPath = localRootPath + PATHSEPARATOR + intrfcId;
						
						Vector<ChannelSftp.LsEntry> trnscList = channelSftp.ls(remoteIntrfcPath);
						logger.info("인터페이스 경로 : "+remoteIntrfcPath);
						
						for (ChannelSftp.LsEntry trnscItem : trnscList) {
							 if (!(".".equals(trnscItem.getFilename()) || "..".equals(trnscItem.getFilename()) || trnscItem.getFilename().startsWith("backup_")) && trnscItem.getAttrs().isDir()) {
								 List<String> tableList = new ArrayList<String>();
								 logger.info("트랜잭션 폴더 : " + trnscItem.getFilename());
								 String remoteTrnscPath = remoteIntrfcPath + PATHSEPARATOR +  trnscItem.getFilename();
								 String localTrnscPath = localIntrfcPath + PATHSEPARATOR +  trnscItem.getFilename();
								 logger.info("트랜잭션 경로 : "+remoteTrnscPath);
								 
								 Map<String, Object> checkTrnscIdParam = new HashMap<String, Object>();
								 
								 checkTrnscIdParam.put("trnscId", trnscItem.getFilename());
								 checkTrnscIdParam.put("intfcId", intrfcId);
								 
								int checkTrnscId = kukgohDAO.ckeckTrnscIdReadStatus(checkTrnscIdParam);
								
								 if(checkTrnscId == 0) {
									 checkTrnscIdParam.put("status", "Y");
									 kukgohDAO.insertTrnscIdReadStatus(checkTrnscIdParam);
									 
									 Vector<ChannelSftp.LsEntry> dataList = channelSftp.ls(remoteTrnscPath);
									 
									 //트랜잭션 폴더 내 데이터
									 for (ChannelSftp.LsEntry trnscData : dataList) {
										 
										 if (!(new File(localTrnscPath)).exists() || (trnscData.getAttrs().getMTime() > Long.valueOf(new File(localTrnscPath).lastModified()/ (long) 1000).intValue())) { // Download only if changed later.
						                	//트랜잭션 폴더 로컬 생성
						                	 new File(localTrnscPath).mkdirs();
						                	//channelSftp.get(trnscPath, "D:\\"+trnscPath);
						                }
						                
						                exTransactionId = trnscItem.getFilename();
					                	logger.info("트랜잭션폴더 생성 :"+remoteTrnscPath);
					                	
							            if (!(".".equals(trnscData.getFilename()) || "..".equals(trnscData.getFilename()))) {
							            	String remoteTrnscFile = remoteTrnscPath+ PATHSEPARATOR+ trnscData.getFilename();
							            	String localTrnscFile = localTrnscPath+ PATHSEPARATOR+ trnscData.getFilename();
							            	
							            	if(!trnscData.getAttrs().isDir()) {
						                		new File(localTrnscFile); 
							            		channelSftp.get(remoteTrnscFile, localTrnscFile); // G20(remote) -> GW서버(local) 파일 이동
						                	}
						                	
											 if(trnscData.getFilename().endsWith("data.csv")) {
												logger.info("data CSV 파일 : " + trnscData.getFilename());
												exFileName = trnscData.getFilename();
												List<KukgohCommVO> kukgohDataList = readCsv(localTrnscFile, "EUC-KR", trnscItem.getFilename(), intrfcItem.getFilename());
												
												for (KukgohCommVO kukgohCommVO : kukgohDataList) {
													//입력
													logger.info("최종READ 들어오나");
													logger.info(kukgohCommVO.getTableName() + "@@@");
													exTableNm = kukgohCommVO.getTableName();
													tableList.add(exTableNm);
													if(!T_IF_INTRFC_FILE.equals(kukgohCommVO.getTableName())) {
														for (Map<String, Object> map2 : kukgohCommVO.getData()) {
															logger.info(kukgohCommVO.getData() + "@@@");
															map2.put("EMP_SEQ", empSeq);
															map2.put("EMP_IP", ip);
															kukgohDAO.insertTestMS(map2, kukgohCommVO.getTableName());
														}
													}
												}
												
											 }else if(trnscData.getFilename().endsWith("attach.csv")) {
												 
												 System.out.println("첨부 CSV 파일 : " + trnscData.getFilename());
												 exFileName = trnscData.getFilename();
												 List<KukgohCommVO> kukgohAttachFileList = readCsv(localTrnscFile, "EUC-KR", trnscItem.getFilename(), intrfcItem.getFilename());
												 
												 for (KukgohCommVO kukgohCommVO : kukgohAttachFileList) {
													 
													for (Map<String, Object> map2 : kukgohCommVO.getData()) {
														map2.put("EMP_SEQ",empSeq);
														map2.put("EMP_IP", ip);
														String targetId = (String)map2.get("CNTC_CREAT_DT");
														String fileNm = (String)map2.get("CNTC_FILE_NM");
														String fileExtension = fileNm.substring(fileNm.lastIndexOf(".")+1,fileNm.length());
														fileNm = fileNm.replace("."+fileExtension, "");
														map2.put("target_table_name","kukgoh");
														//TODO 파일 위치 수정
														Long time = System.currentTimeMillis();
														map2.put("target_id", time.toString().substring(0, 10));
														map2.put("file_seq",map2.get("CNTC_SN"));
														map2.put("file_name", fileNm);
														map2.put("real_file_name",map2.get("CNTC_ORG_FILE_NM").toString().replaceAll("."+fileExtension, ""));
														map2.put("file_extension", fileExtension);
														//map2.put("file_path","D:\\enara"+PATHSEPARATOR+map2.get("INTRFC_ID")+PATHSEPARATOR+map2.get("TRNSC_ID")+PATHSEPARATOR+"attach"+PATHSEPARATOR);
														String remoteAttachFilePath = remoteTrnscFile+PATHSEPARATOR+"attach"+PATHSEPARATOR;
														String localAttachFilePath = localTrnscFile+PATHSEPARATOR+"attach"+PATHSEPARATOR;
														map2.put("file_path", localAttachFilePath);
														kukgohDAO.saveFile(map2);
														kukgohDAO.kukgohAttachSave( map2);  
													}
												 }										 
											 } else if ("attach".equals(trnscData.getFilename())) {
												 String remoteAttachPath = remoteTrnscPath + PATHSEPARATOR + trnscData.getFilename();
												 String localAttachPath = localTrnscPath + PATHSEPARATOR + trnscData.getFilename();
												 
												 //첨부파일
								                 if (!(new File(localAttachPath)).exists()) {
								                	 new File(localAttachPath).mkdirs();
								                	 System.out.println("첨부파일 경로 : D:\\" + localAttachPath);
								                 }
								                 
								                 Vector<ChannelSftp.LsEntry> attachList = channelSftp.ls(remoteAttachPath);
								                 
												 for (ChannelSftp.LsEntry attachFiles : attachList) {
													 if(!(attachFiles.getAttrs().isDir() || ".".equals(attachFiles.getFilename()) || "..".equals(attachFiles.getFilename()))) {
														String remoteFileName = remoteAttachPath+ PATHSEPARATOR+ attachFiles.getFilename();
														String localFileName = localAttachPath+ PATHSEPARATOR+ attachFiles.getFilename();
														
														new File(localFileName);
														channelSftp.get(remoteFileName, localFileName);
													}
												}
											 }
										 }
									}
									 
									//trnscPath 전체 패스
									//intrfcId 인터페이스 아이디 
									//trnscItem 트랙잭션 id
									channelSftp.rename(remoteTrnscPath, remoteIntrfcPath+PATHSEPARATOR+"backup_"+exTransactionId);
							    	Map<String, Object> errMap = new HashMap<String, Object>();
							    	
							    	for (String tableNm : tableList) {
										errMap.put("exInterfaceId", exInterfaceId);
										errMap.put("exTransactionId",exTransactionId);
										errMap.put("exTableNm", tableNm);
										errMap.put("exFileName", exFileName);
										errMap.put("empSeq", empSeq);
										errMap.put("ip", ip);
										errMap.put("msg", "");
										kukgohDAO.saveLog(errMap);
									}
							    	
							    	checkTrnscIdParam.put("status", "N");
									kukgohDAO.ckeckTrnscIdReadStatus(checkTrnscIdParam);
									 
								 }else {
									 System.out.println("읽고 있음");
								 }
							 }
						}
					}
				}
			}
  		} catch (Exception e) {

  		} finally {
  			channelSftp.exit();
  			channelSftp.disconnect();
  			channelSftp = null;
  			sFTPUtil.disconnectSFTP();
		}
	    status = null;
		return map;
	}
	
	@Override
	@SuppressWarnings("unchecked")
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public Map<String, Object> getRemoteFile2(Map<String, Object> map4) throws SftpException, IOException {
		SFTPUtil sFTPUtil = SFTPUtil.getInstance();
	    ChannelSftp channelSftp = new ChannelSftp();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> erpInfo = new HashMap<String, Object>();
		
		String empSeq = (String)map4.get("EMP_SEQ");
		String ip = (String)map4.get("EMP_IP");
		String code_val = (String)map4.get("CODE_VAL");
		String code = (String)map4.get("code");

		String exInterfaceId = null;
		String exTransactionId = null;
		String exTableNm = null;
		String exFileName = null;
		
		//트랜잭션 설정
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);
		Map<String, Object> result = new HashMap<String, Object>(); 
	    erpInfo =	kukgohDAO.getErpInfo();
	    channelSftp = sFTPUtil.connSFTP(erpInfo);
	    
	    //파일다운로드
	    List<Map<String, Object>> enaraIntrfcIdList = new ArrayList<Map<String, Object>>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("code_desc", "rcv");
		paramMap.put("code_val", code_val);
		paramMap.put("code", code);
		enaraIntrfcIdList = kukgohDAO.getRcvEnaraInterfaceId2(paramMap);
		
		Map<String, String> tempDirPath = new HashMap<String, String>();
		tempDirPath.put("groupCode", "ENARA");
		tempDirPath.put("code", "REMOTE_RCV_DIR");
		Map<String, Object> remoteDirPath = commonDAO.getCodeOne(tempDirPath);
		tempDirPath.put("code", "LOCAL_RCV_DIR");
		Map<String, Object> localDirPath = commonDAO.getCodeOne(tempDirPath);
		
		String remoteRootPath = (String)remoteDirPath.get("code_kr");
		String localRootPath = (String)localDirPath.get("code_kr");
		
		Vector<ChannelSftp.LsEntry> fileAndFolderList;
  		fileAndFolderList = channelSftp.ls(remoteRootPath);
  		
  		StringBuilder sb = new StringBuilder();
  		
  		System.out.println("fileAndFolderList : " + fileAndFolderList);
  		System.out.println("enaraIntrfcIdList : " + enaraIntrfcIdList);
  		
  		try {
			
			for (ChannelSftp.LsEntry intrfcItem : fileAndFolderList) {
				
				for (Map intrfcMap : enaraIntrfcIdList) {
					
					String intrfcId = intrfcMap.get("code").toString();
					exInterfaceId = intrfcId;
					
					//인터페이스
					if(intrfcId.equals(intrfcItem.getFilename())) {
						System.out.println("intrfcId : "+ intrfcId);
						//인터페이스 내 폴더로 이동
						String remoteIntrfcPath = remoteRootPath + PATHSEPARATOR + intrfcId;
						String localIntrfcPath = localRootPath + PATHSEPARATOR + intrfcId;
						
						Vector<ChannelSftp.LsEntry> trnscList = channelSftp.ls(remoteIntrfcPath);
						System.out.println("인터페이스 경로 : "+remoteIntrfcPath);
						
						//트랜잭션
						for (ChannelSftp.LsEntry trnscItem : trnscList) {
							
							if (!(".".equals(trnscItem.getFilename()) || "..".equals(trnscItem.getFilename()) || trnscItem.getFilename().startsWith("backup_")) && trnscItem.getAttrs().isDir()) {
								 
								 List<String> tableList = new ArrayList<String>();
								 sb.append(System.lineSeparator());
								 sb.append("인터페이스 ID : " + intrfcId);
								 System.out.println("트랜잭션 폴더 : " + trnscItem.getFilename());
								 String remoteTrnscPath = remoteIntrfcPath + PATHSEPARATOR +  trnscItem.getFilename();
								 String localTrnscPath = localIntrfcPath + PATHSEPARATOR +  trnscItem.getFilename();
								 System.out.println("트랜잭션 경로 : "+remoteTrnscPath);
								 //트랜잭션 폴더 안으로 이동
								 Map<String, Object> checkTrnscIdParam = new HashMap<String, Object>();
								 
								 checkTrnscIdParam.put("trnscId", trnscItem.getFilename());
								 checkTrnscIdParam.put("intfcId", intrfcId);
								 
								 int checkTrnscId = kukgohDAO.ckeckTrnscIdReadStatus(checkTrnscIdParam);
								 
								 if(checkTrnscId == 0) {
									 checkTrnscIdParam.put("status", "Y");
									 kukgohDAO.insertTrnscIdReadStatus(checkTrnscIdParam);
									 
									 Vector<ChannelSftp.LsEntry> dataList = channelSftp.ls(remoteTrnscPath);
									 
									 //트랜잭션 폴더 내 데이터
									 for (ChannelSftp.LsEntry trnscData : dataList) {
										 
										 if (!(new File(localTrnscPath)).exists() || (trnscData.getAttrs().getMTime() > Long.valueOf(new File(localTrnscPath).lastModified()/ (long) 1000).intValue())) { // Download only if changed later.
											 System.out.println("localTrnscPath : " + localTrnscPath);
											 //트랜잭션 폴더 로컬 생성
						                	 new File(localTrnscPath).mkdirs();
						                }
						                
						                exTransactionId = trnscItem.getFilename();
					                	System.out.println("트랜잭션폴더 생성 :"+remoteTrnscPath);
					                	
							            if (!(".".equals(trnscData.getFilename()) || "..".equals(trnscData.getFilename()))) {
							            	
							            	String remoteTrnscFile = remoteTrnscPath+ PATHSEPARATOR+ trnscData.getFilename();
							            	String localTrnscFile = localTrnscPath+ PATHSEPARATOR+ trnscData.getFilename();
							            	
							            	if(!trnscData.getAttrs().isDir()) {
						                		
						                		File f = new File(localTrnscFile); 
						                		
						                		if (f.exists()) {
						                			System.out.println("존재함");
						                		}else {
						                			System.out.println("존재하지 않음");
						                			new File(localTrnscPath).mkdirs();
						                			new File(localTrnscFile);
						                		}
						                		
						                		System.out.println("remoteTrnscFile : " + remoteTrnscFile);
						                		System.out.println("localTrnscFile : " + localTrnscFile);
							            		
						                		channelSftp.get(remoteTrnscFile, localTrnscFile);
						                	}
						                	
											 if(trnscData.getFilename().endsWith("data.csv")) {
												 
												System.out.println("data CSV 파일 : " + trnscData.getFilename());
												exFileName = trnscData.getFilename();
							                	//List<KukgohCommVO> kukgohInfoList = readCsv(trnscFile, "EUC-KR", transactionNm, interfaceNm);
												List<KukgohCommVO> kukgohDataList = readCsv(localTrnscFile, "EUC-KR", trnscItem.getFilename(), intrfcItem.getFilename());
												sb.append("<br>");
												sb.append("트랜잭션 ID : " + trnscItem.getFilename());
		
												for (KukgohCommVO kukgohCommVO : kukgohDataList) {
													//입력
													System.out.println("!@#$" + kukgohCommVO.getTableName());
													exTableNm = kukgohCommVO.getTableName();
													tableList.add(exTableNm);
													if (!T_IF_INTRFC_FILE.equals(kukgohCommVO.getTableName())) {
														for (Map<String, Object> map2 : kukgohCommVO.getData()) {
															map2.put("EMP_SEQ", empSeq);
															map2.put("EMP_IP", ip);
															kukgohDAO.insertTestMS(map2, kukgohCommVO.getTableName());
														}
													}
													sb.append("<br>");
													sb.append("트랜잭션 데이터파일(CSV) 저장 완료 : " + exFileName);
												}
											 }else if(trnscData.getFilename().endsWith("attach.csv")) {
												 
												 System.out.println("첨부 CSV 파일 : " + trnscData.getFilename());
												 exFileName = trnscData.getFilename();
												 List<KukgohCommVO> kukgohAttachFileList = readCsv(localTrnscFile, "EUC-KR", trnscItem.getFilename(), intrfcItem.getFilename());
												 
												 for (KukgohCommVO kukgohCommVO : kukgohAttachFileList) {
													 
													for (Map<String, Object> map2 : kukgohCommVO.getData()) {
														
														map2.put("EMP_SEQ",empSeq);
														map2.put("EMP_IP", ip);
														String targetId = (String)map2.get("CNTC_CREAT_DT");
														String fileNm = (String)map2.get("CNTC_FILE_NM");
														String fileExtension = fileNm.substring(fileNm.lastIndexOf(".")+1,fileNm.length());
														fileNm = fileNm.replace("."+fileExtension, "");
														map2.put("target_table_name","kukgoh");
														
														//TODO 파일 위치 수정
														Long time = System.currentTimeMillis();
														map2.put("target_id", time.toString().substring(0, 10));
														map2.put("file_seq",map2.get("CNTC_SN"));
														map2.put("file_name", fileNm);
														map2.put("real_file_name",map2.get("CNTC_ORG_FILE_NM").toString().replaceAll("."+fileExtension, ""));
														map2.put("file_extension", fileExtension);
														//map2.put("file_path","D:\\enara"+PATHSEPARATOR+map2.get("INTRFC_ID")+PATHSEPARATOR+map2.get("TRNSC_ID")+PATHSEPARATOR+"attach"+PATHSEPARATOR);
														
														String remoteAttachFilePath = remoteTrnscFile+PATHSEPARATOR+"attach"+PATHSEPARATOR;
														String localAttachFilePath = localTrnscFile+PATHSEPARATOR+"attach"+PATHSEPARATOR;
														
														map2.put("file_path", localAttachFilePath);
														
														kukgohDAO.saveFile(map2);
														kukgohDAO.kukgohAttachSave( map2);  
														
														sb.append("<br>");
														sb.append("트랜잭션 첨부파일(CSV) 저장 완료 : " + exFileName);
		
													}
												 }										 
											 } else if ("attach".equals(trnscData.getFilename())) {
												 
												 String remoteAttachPath = remoteTrnscPath + PATHSEPARATOR + trnscData.getFilename();
												 String localAttachPath = localTrnscPath + PATHSEPARATOR + trnscData.getFilename();
												 
												 //첨부파일
								                 if (!(new File(localAttachPath)).exists()) {
								                	 new File(localAttachPath).mkdirs();
								                	 System.out.println("첨부파일 경로 : C:\\" + localAttachPath);
								                 }
								                 
								                 Vector<ChannelSftp.LsEntry> attachList = channelSftp.ls(remoteAttachPath);
								                 
												 for (ChannelSftp.LsEntry attachFiles : attachList) {
													 
													 if(!(attachFiles.getAttrs().isDir() || ".".equals(attachFiles.getFilename()) || "..".equals(attachFiles.getFilename()))) {
														 
														String remoteFileName = remoteAttachPath+ PATHSEPARATOR+ attachFiles.getFilename();
														String localFileName = localAttachPath+ PATHSEPARATOR+ attachFiles.getFilename();
														
														new File(localFileName); 
														channelSftp.get(remoteFileName, localFileName);
													}
												}
												 	sb.append("<br>");
													sb.append("트랜잭션 첨부파일 저장 완료 : 첨부파일 (" + attachList.size()+")개");
											 }
										 }
									}
									 
									//trnscPath 전체 패스
									//intrfcId 인터페이스 아이디 
									//trnscItem 트랙잭션 id
									 channelSftp.rename(remoteTrnscPath, remoteIntrfcPath+PATHSEPARATOR+"backup_"+exTransactionId);
							    	Map<String, Object> errMap = new HashMap<String, Object>();
							    	
							    	for (String tableNm : tableList) {
										errMap.put("exInterfaceId", exInterfaceId);
										errMap.put("exTransactionId",exTransactionId);
										errMap.put("exTableNm", tableNm);
										errMap.put("exFileName", exFileName);
										errMap.put("empSeq", empSeq);
										errMap.put("ip", ip);
										errMap.put("msg", "");
										kukgohDAO.saveLog(errMap);
									}
							    	
							    	checkTrnscIdParam.put("status", "N");
									 kukgohDAO.ckeckTrnscIdReadStatus(checkTrnscIdParam);
	
								 }else {
									 //System.out.println("읽고있음");
									 sb.append("<br>");
									 sb.append("[중복]트랜잭션 파일 존재함 ");
									 sb.append("<br>");
									 sb.append("[중복]트랜잭션 ID : " + trnscItem.getFilename());								 
								 }
							 }
						}
					}
				}
			}
  		} finally {
  			channelSftp.exit();
  			channelSftp.disconnect();
  			channelSftp = null;
  			sFTPUtil.disconnectSFTP();
		}
		
	    status = null;
	    map.put("logs", sb.toString());
		return map;
	}
	
	@Override
	public List<Map<String, Object>> getCommCodeClassificationMs(Map<String, Object> map) {
		return kukgohDAO.getCommCodeClassificationMs(map);
	}


	@Override
	public List<Map<String, Object>> getMainGridMs(Map<String, Object> map) {
		return kukgohDAO.getMainGridMs(map);
	}

	@Override
	public int getMainGridTotalMs(Map<String, Object> map) {
		return kukgohDAO.getMainGridTotalMs(map);
	}


	@Override
	public Map<String, Object> commCodeSaveMs(Map<String, Object> map) throws JsonParseException, JsonMappingException, IOException {
		ObjectMapper mapper = new ObjectMapper();
			List<Map<String, Object>> data = mapper.readValue(map.get("data").toString(), new TypeReference<List<Map<String, Object>>>(){});
			System.out.println("");
			for (Map<String, Object> map2 : data) {
				//TODO 사원번호 ip 입력하여야 함.
				map2.put("EMP_SEQ", map.get("EMP_SEQ"));
				map2.put("EMP_IP", map.get("EMP_IP"));
				map2.put("OUT_YN", "");
				map2.put("OUT_MSG", "");
				kukgohDAO.commCodeSaveMs(map2);
				System.out.println(map2.get("OUT_MSG")); 
			}
		return null;
	}


	@Override
	public List<Map<String, Object>> getAttachFileMs(Map<String, Object> map) {
		return 	kukgohDAO.getAttachFileMs(map);
	}


	@Override
	public List<Map<String, Object>> getFileList(Map<String, Object> map) {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		result = kukgohDAO.getAttachFile(map);

		return result;
	}


	@Override
	public List<Map<String, Object>> getBudgetMainGrid(Map<String, Object> map) {
		return kukgohDAO.getBudgetMainGrid(map);
	}


	@Override
	public List<Map<String, Object>> getBudgetCdGridPop(Map<String, Object> map) {
		return kukgohDAO.getBudgetCdGridPop(map);
	}


	@Override
	public boolean saveBgtConfig(Map<String, Object> map) throws JsonParseException, JsonMappingException, IOException {
		boolean result = true;
		ObjectMapper mapper = new ObjectMapper();
			//List<Map<String, Object>> data = mapper.readValue(map.get("data").toString(), new TypeReference<List<Map<String, Object>>>(){});
			//for (Map<String, Object> map2 : data) {
		map.put("EMP_SEQ", map.get("EMP_SEQ"));
		map.put("EMP_IP", map.get("EMP_IP"));
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
				kukgohDAO.saveBgtConfig(map);
			//}
		return result;
	}


	@Override
	public List<Map<String, Object>> getProjectCdGridPop(Map<String, Object> map) {
		return kukgohDAO.getProjectCdGridPop(map);
	}


	@Override
	public Map<String, Object> saveProjectConfig(Map<String, Object> map) {
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
		kukgohDAO.saveProjectConfig(map);
		return map;	
	}


	@Override
	public List<Map<String, Object>> getProjectMainGrid(Map<String, Object> map) {
		return kukgohDAO.getProjectMainGrid(map);
	}


	@Override
	public String getErpEmpSeq(Map<String, Object> map) {
		return kukgohDAO.getErpEmpSeq(map);
	}
	
	@Override
	public String getErpDeptSeq(Map<String, Object> map) {
		return kukgohDAO.getErpDeptSeq(map);
	}

	@Override
	public List<Map<String, Object>> insertResolutionMainGrid(Map<String, Object> map) {
		List<Map<String, Object>> resultList = kukgohDAO.insertResolutionMainGrid(map);
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		for (Map<String, Object> map2 : resultList) {
			
			Map<String, Object> param = new HashMap<>();
			
			param.put("coCd", map2.get("CO_CD"));
			param.put("gisuDt", map2.get("GISU_DT"));
			param.put("gisuSeq", map2.get("GISU_SQ"));
			param.put("bgSeq", map2.get("BG_SQ"));
			
			map2.put("C_DIKEYCODE", "");
			map2.put("DOC_NUMBER", "");
			map2.put("DOC_TITLE", "");
			map2.put("DOC_REGDATE", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");
			kukgohDAO.getDocInfo(map2);
			
			if (map2.get("OUT_YN") == null || "N".equals(map2.get("OUT_YN"))) {
				map2.put("OUT_YN", "N");
				map2.put("DOC_NUMBER", "-");
				map2.put("DOC_TITLE", "-");
				map2.put("DOC_REGDATE", "-");
			} else {
				param.put("DOC_TITLE", map2.get("DOC_TITLE"));
				List<Map<String, Object>> tmpList = kukgohDAO.getUnSendData(param);
				
				for (Map<String, Object> map3 : tmpList) {
					
					String PRUF_SE_NO = (String) map3.get("PRUF_SE_NO");
					
					if (PRUF_SE_NO == null || PRUF_SE_NO.startsWith("(오류)")) {
						map2.put("isSendInvoice", "N");
						break;
					}
					
					map2.put("isSendInvoice", "Y");
				}
				
				returnList.add(map2);
			}
		}
		
		return returnList;
	}


	@Override
	public List<Map<String, Object>> getUnSendData(Map<String, Object> map) {
		return kukgohDAO.getUnSendData(map);
	}


	@Override
	public List<Map<String, Object>> getSendData(Map<String, Object> map) {
		return kukgohDAO.getSendData(map);
	}


	@Override
	public List<Map<String, Object>> getEvidenceMs() {
		return kukgohDAO.getEvidenceMs();
	}


	@Override
	public List<Map<String, Object>> getCustomerGbMs() {
		return kukgohDAO.getCustomerGbMs();
	}


	@Override
	public List<Map<String, Object>> getDepositGbMs() {
		return kukgohDAO.getDepositGbMs();
	}


	@Override
	public List<Map<String, Object>> getDepositGbCauseMs() {
		return kukgohDAO.getDepositGbCauseMs();
	}


	@Override
	public Map<String, Object> requestInvoice1(Map<String, Object> map) {
		
		map.put("TRNSC_ID_TIME", System.currentTimeMillis());
		map.put("TRNSC_ID", "");
		map.put("CNTC_SN", "");
		map.put("CNTC_CREAT_DT", "");
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
		
		kukgohDAO.requestInvoice(map); 
		return map;

	}
	@Override
	public Map<String, Object> requestInvoice2(Map<String, Object> map) throws Exception {
	    Utils util = new Utils();
	    
	    Map<String, Object> erpInfo =	kukgohDAO.getErpInfo();
	    
	    SFTPUtil sFTPUtil = SFTPUtil.getInstance();
	    ChannelSftp channelSftp = new ChannelSftp();
	    
	    channelSftp = sFTPUtil.connSFTP(erpInfo);
	    
	    //원격 경로 셋팅
	    //IF-EXE-EFR-0071
	    Map<String, String> map2 = new HashMap<String, String>();
	    map2.put("groupCode", "ENARA");
	    map2.put("code", "REMOTE_SND_DIR");
	    Map<String, Object> remoteDirMap = commonDAO.getCodeOne(map2);
	    String remoteRootDirPath = (String)remoteDirMap.get("code_kr");  
	    
		//로컬 경로 셋팅
	    map2.put("groupCode", "ENARA");
	    map2.put("code", "LOCAL_SND_DIR");
		Map<String, Object> localDirMap = commonDAO.getCodeOne(map2);
		String localRootDirPath = (String)localDirMap.get("code_kr");
		
		//트랜잭션 ID
		String transctionId  = (String)map.get("TRNSC_ID");
		
		Map<String, Object> map4 = new HashMap<String, Object>();
		map4.put("TRNSC_ID", transctionId);
		
		FileInputStream csvIn = null;
		FileInputStream eofIn = null;
		
		try {
			
			List<Map<String, Object>> csvList = kukgohDAO.execCsvSearch5(map4);
			
			for (int i = 1; i < csvList.size(); i++) {
				
				if (csvList.get(i).get("FILE_ID") == null) {
					csvList.get(i).put("FILE_ID", "");
				}
			}
			
			String trnscId = (String)map.get("TRNSC_ID");
			Map<String, Object> dirMap = util.getTrnscId(trnscId);
			String intrfcId = (String)dirMap.get("intrfcId");
			String localFilePath = localRootDirPath+PATHSEPARATOR+intrfcId+PATHSEPARATOR+trnscId;
			String remoteFilePath = remoteRootDirPath+PATHSEPARATOR+intrfcId+PATHSEPARATOR+trnscId;
			String csvFilePath = util.createInvoiceCSV(csvList, trnscId , localFilePath);
			
			channelSftp.mkdir(remoteFilePath);
			csvIn = new FileInputStream(csvFilePath);
		     channelSftp.put(csvIn, remoteFilePath + PATHSEPARATOR +trnscId +"-data.csv");
			
			String eofFilePath = util.createEof(trnscId , localFilePath);
		    eofIn = new FileInputStream(eofFilePath);
		    channelSftp.put(eofIn, remoteFilePath + PATHSEPARATOR + trnscId+ ".eof");
		} catch (Exception e) {

		} finally {
			csvIn.close();
		    eofIn.close();
		    channelSftp.exit();
		    channelSftp.disconnect();
		    channelSftp = null;
		    sFTPUtil.disconnectSFTP();
		}
		return map;
	}
	
    //파일 읽기
	public List<KukgohCommVO> readCsv(String path, String encoding, String transactionNm, String interfaceNm) throws IOException {

		BufferedReader br = null;
		String line = "";
		boolean boolTF = false;
		List<KukgohCommVO> kukgohInfoList = new ArrayList<KukgohCommVO>();
		String tableName = null;
		KukgohCommVO kukgohInfo = null;
		br = new BufferedReader(new InputStreamReader(new FileInputStream(path), encoding));
		int i = 0;
		int k = 0;
		String sStr = "";
		String resultStr = "";
		String nowTable = "";
			
			while ((line = br.readLine()) != null) {
				
				if (!line.equals("") && !line.equals(" ")) {
					
					if(line.contains("TABLE_NAME:")) {
						
						if(line.contains("TABLE_NAME:T_IFS_BSRSLT_EXC_INSTT_ERP")) {
							String array[] = resultStr.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
							List<String> tmpList = new ArrayList<String>();
							Map<String, Object> map2 = new HashMap<String, Object>();
							tmpList = Arrays.asList(array);
							if (kukgohInfo.columnName.size() == tmpList.size()) {
								int j = 0;
								for (String str : tmpList) {
									map2.put(kukgohInfo.columnName.get(j), str.replace("\"", ""));
									j++;
								}
								kukgohInfo.data.add(map2);
							} else {
								
							}
							resultStr = "";
						}
						
						//테이블 입력
						
						if (k > 0) {
							kukgohInfoList.add(kukgohInfo);
						}
						
						kukgohInfo = new KukgohCommVO();
						tableName = line;
						tableName = tableName.replaceAll("\\[TABLE_NAME:", "");
						tableName = tableName.replaceAll("\\]", "");
						tableName = tableName.replaceAll("\"", "");
						nowTable = tableName;
						
						//테이블 이름 셋팅
						kukgohInfo.setTableName(tableName);
						//인터페이스 ID 셋팅
						kukgohInfo.setInterfaceNm(interfaceNm);
						//트랜잭션 ID 셋팅
						kukgohInfo.setTransactionNm(transactionNm);
						
						System.out.println(tableName);
						boolTF = true;
						k++;
					} else if (boolTF) {
						
						//칼럼명 입력
						String array[] = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
						for (String str : Arrays.asList(array)) {
							kukgohInfo.columnName.add(str.replace("\"", ""));
						}
						boolTF = false;
					} else {
						
						resultStr += line;
						
						if (!nowTable.equals("T_IFS_BSRSLT_ERP")) {
							
							//데이터 입력
							char startChar = line.charAt(0);
							char lastChar = line.charAt(line.length()-1);
							
							if(startChar == '\"' && lastChar == '\"' ) {
								String array[] = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
								List<String> tmpList = new ArrayList<String>();
								Map<String, Object> map2 = new HashMap<String, Object>();
								tmpList = Arrays.asList(array);
								
								if (kukgohInfo.columnName.size() == tmpList.size()) {
									int j = 0;
									for (String str : tmpList) {
										map2.put(kukgohInfo.columnName.get(j), str.replaceAll("[\"']", ""));
										j++;
									}
									kukgohInfo.data.add(map2);
								} 
							}else if( startChar == '\"' && lastChar != '\"'){
								//비정상 시작
								sStr += line;
							}else if( startChar != '\"' && lastChar != '\"'){
								//중간
								sStr += line;
							}else if( startChar != '\"' && lastChar == '\"'){
								//끝
								sStr += line;
								String array[] = sStr.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
								List<String> tmpList = new ArrayList<String>();
								Map<String, Object> map2 = new HashMap<String, Object>();
								tmpList = Arrays.asList(array);
								if (kukgohInfo.columnName.size() == tmpList.size()) {
									int j = 0;
									for (String str : tmpList) {
										map2.put(kukgohInfo.columnName.get(j), str.replaceAll("[\"']", ""));
										j++;
									}
									kukgohInfo.data.add(map2);
								} else {
									
								}
								sStr = "";
							}
							System.out.println("startChar : " + startChar);
							System.out.println("lastChar : " + lastChar);
						}
						
					}
				}
			}
			kukgohInfoList.add(kukgohInfo);
		return kukgohInfoList;
	}
	
    //파일 읽기
	@SuppressWarnings("resource")
	public List<KukgohCommVO> readCsv2(String path, String encoding, String transactionNm, String interfaceNm) throws IOException {

		BufferedReader br = null;
		String line = "";
		boolean boolTF = false;
		// File csv = new
		// File("D:\\IBTC00_IF-CMM-EFS-0061_T00001_1513299714273-data.csv");
		List<KukgohCommVO> kukgohInfoList = new ArrayList<KukgohCommVO>();
		String tableName = null;
		KukgohCommVO kukgohInfo = null;
			br = new BufferedReader(new InputStreamReader(new FileInputStream(path), encoding));
			// br = new BufferedReader(new FileReader(csv));
			int k = 0;

			while ((line = br.readLine()) != null) {
				// CSV 1행을 저장하는 리스트
				// String array[] = line.split(",");
				String array[] = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
				//if (array[0].trim().startsWith("[TABLE_NAME:")) {
				if (array[0].contains("TABLE_NAME:")) {
					System.out.println(array[0]);
					if (k > 0) {
						kukgohInfoList.add(kukgohInfo);
						System.out.println(kukgohInfoList);
					}
					kukgohInfo = new KukgohCommVO();
					tableName = array[0];
//					String strRe = ",(?=([^\"]*\"[^\"]*\")*[^\"]*$)";
					tableName = tableName.replaceAll("\\[TABLE_NAME:", "");
					tableName = tableName.replaceAll("\\]", "");
					tableName = tableName.replaceAll("\"", "");
					//테이블 이름 셋팅
					kukgohInfo.setTableName(tableName);
					//인터페이스 ID 셋팅
					kukgohInfo.setInterfaceNm(interfaceNm);
					//트랜잭션 ID 셋팅
					kukgohInfo.setTransactionNm(transactionNm);
					
					System.out.println(tableName);
					boolTF = true;
					k++;
				} else if (boolTF) {
					for (String str : Arrays.asList(array)) {
						kukgohInfo.columnName.add(str.replace("\"", ""));
					}
					boolTF = false;
				} else {
					Map<String, Object> map2 = new HashMap<String, Object>();
					List<String> tmpList = new ArrayList<String>();
					tmpList = Arrays.asList(array);

					if (kukgohInfo.columnName.size() == tmpList.size()) {
						int j = 0;
						for (String str : tmpList) {
							map2.put(kukgohInfo.columnName.get(j), str.replace("\"", ""));
							j++;
						}
						kukgohInfo.data.add(map2);
					} else {
					}
				}
			}
			kukgohInfoList.add(kukgohInfo);
		return kukgohInfoList;
	}

	@Override
	public Map<String, Object> getCommDir(Map<String, Object> map) {
		return kukgohDAO.getCommDir(map);
	}

	@Override
	public void transactionTest(Map<String, Object> map) throws Exception{
			map.put("name", "name10");
			kukgohDAO.transactionTest1(map);
			map.put("name", "name11");
			kukgohDAO.transactionTest2(map);
			throw new Exception();
	}
	
	/**
	 *  집행전송 일괄 전송
	 */
	@Override
	public Map<String, Object> sendResolutionList(List<Map<String, Object>> map, String ip, String empSeq) {
		
		SFTPUtil sFTPUtil = SFTPUtil.getInstance();
	    ChannelSftp channelSftp = new ChannelSftp();
		Utils util = new Utils();
		FileInputStream csvIn = null;
		FileInputStream eofIn = null;
		boolean resultYn = true;
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    Map<String, Object> param = new HashMap<String, Object>();
	    List<Map<String, Object>> fileInfoList = new ArrayList<Map<String, Object>>();
	    SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
	    String cntcCreateDt = sf.format(new Date());
	    String systemCode = "EPIS"; // 시스템 코드
	    int wasNum = 1; // 업무용 WAS 번호 ( 다중화 구성일 경우 WAS의 순번 )
	    
	    Map<String, Object> erpInfo = kukgohDAO.getErpInfo();
	    channelSftp = sFTPUtil.connSFTP(erpInfo); // SFTP 연결 객체 생성
	    
		String intrfcId = "IF-EXE-EFR-0074";
		String trnscId = EsbUtils.getTransactionId(intrfcId, systemCode, wasNum);
		
		param.put("intrfcId", intrfcId);
		resultMap.put("OUT_YN", "");
		resultMap.put("OUT_MSG", "");
		
		try {
			
	    for (Map<String, Object> map2 : map) { // 화면 딴에서 받아온 파라미터 맵 데이터
	    	resultYn = true;
	    	List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
	    	map2.put("TRNSC_ID", trnscId);
	    	map2.put("CNTC_CREAT_DT", cntcCreateDt);
	    	map2.put("TRNSC_ID_TIME", System.currentTimeMillis());
	    	fileList = kukgohDAO.getAttachFile(map2);
	    	
			if(fileList.size() > 0 ) {
				map2.put("FILE_ID", map2.get("targetId"));
			}
			
			map2.put("EMP_IP", ip);
			map2.put("EMP_SEQ", empSeq);
			kukgohDAO.sendInfo(map2); // 집행정보 G20 등록
			
			resultMap.put("OUT_YN", map2.get("OUT_YN"));
			resultMap.put("OUT_MSG", map2.get("OUT_MSG"));
			
			if(map2.get("OUT_YN").equals("Y")) {
				trnscId = (String)map2.get("OUT_TRNSC_ID");
				cntcCreateDt = (String)map2.get("OUT_CNTC_CREAT_DT");
				
				for (Map<String, Object> fileMap : fileList) {
					fileMap.put("TRNSC_ID", trnscId);
					fileMap.put("INTRFC_ID", intrfcId);
					fileMap.put("CNTC_CREAT_DT", cntcCreateDt);
					fileMap.put("CNTC_SN", fileMap.get("file_seq"));
					fileMap.put("FILE_ID", map2.get("FILE_ID"));
					fileMap.put("CNTC_FILE_NM", fileMap.get("file_name") + "." +  fileMap.get("file_extension"));
					fileMap.put("CNTC_ORG_FILE_NM", fileMap.get("real_file_name") + "." +fileMap.get("file_extension")  );
					fileMap.put("EMP_IP", ip);
					fileMap.put("EMP_SEQ", empSeq);
					kukgohDAO.kukgohAttachSave(fileMap); 
					fileInfoList.add(fileMap);
				}
				
		    }else { 
		    	resultYn = false;
		    	break;
		    }
		}
	    
	    if(resultYn) {
		    param.put("TRNSC_ID", trnscId);
	
			//원격 경로 세팅
		    Map<String, String> map2 = new HashMap<String, String>();
		    map2.put("groupCode", "ENARA");
		    map2.put("code", "REMOTE_SND_DIR");
		    Map<String, Object> remoteDirMap = commonDAO.getCodeOne(map2);
		    String remoteRootDirPath = (String)remoteDirMap.get("code_kr");  
		    
			//로컬 경로 셋팅
		    map2.put("groupCode", "ENARA");
		    map2.put("code", "LOCAL_SND_DIR");
			Map<String, Object> localDirMap = commonDAO.getCodeOne(map2);
			String localRootDirPath = (String)localDirMap.get("code_kr");
			
			String localFilePath = localRootDirPath+PATHSEPARATOR+intrfcId+PATHSEPARATOR+trnscId; // GW ?
			String remoteFilePath = remoteRootDirPath+PATHSEPARATOR+intrfcId+PATHSEPARATOR+trnscId; // G20
			
			List<Map<String, Object>> execRequestCsvList = kukgohDAO.execCsvSearch1(param);
			List<Map<String, Object>> execBimokCsvList = kukgohDAO.execCsvSearch2(param);
			List<Map<String, Object>> execBimokDataCsvList = kukgohDAO.execCsvSearch3(param);
			List<Map<String, Object>> execAttachFileCsvList = kukgohDAO.execCsvSearch4(param);
			
			String csvPath = util.createSendCSV(execRequestCsvList, execBimokCsvList, execBimokDataCsvList, trnscId, localFilePath); // -data.csv 파일 전체 경로
			String attachfileCVS = "";
			
			List<String> savedFileList = new ArrayList<String>();
			
			if(execAttachFileCsvList.size() > 1) {
				attachfileCVS =  util.createAttachFile(execAttachFileCsvList, trnscId, localFilePath);
				
				if(!"".equals(attachfileCVS)) {
					String attachFilePath = localFilePath+PATHSEPARATOR+"attach";
					
					if(util.directoryConfirmAndMake(attachFilePath)) {
						FileInputStream fis = null;
						FileOutputStream fos  = null;
						FileChannel fcin  = null;
						FileChannel fcout  = null;
						
						for (Map<String, Object> fileInfoMap : fileInfoList) {
							String sorceAttachFile = fileInfoMap.get("file_path") + PATHSEPARATOR + fileInfoMap.get("file_name") + "." +  fileInfoMap.get("file_extension");
							String destAttachFile = attachFilePath + PATHSEPARATOR + fileInfoMap.get("file_name") + "." +  fileInfoMap.get("file_extension");
							fis = new FileInputStream(new File(sorceAttachFile));
							fos = new FileOutputStream(new File(destAttachFile));
							fcin = fis.getChannel();
							fcout = fos.getChannel();
							long size = fcin.size();
							fcin.transferTo(0, size, fcout);
							savedFileList.add(destAttachFile);
						}
						
						fcout.close();
						fcin.close();
						fis.close();
						fos.close();
					}
				}
			}
			
			String eofFilePath = util.createEof(trnscId , localFilePath);
			
			if((!csvPath.equals("")) && !(eofFilePath.equals(""))) {
			    csvIn = new FileInputStream(csvPath);
				eofIn = new FileInputStream(eofFilePath);
				
				channelSftp.mkdir("."+remoteFilePath);
				
			    channelSftp.put(csvIn, remoteFilePath + PATHSEPARATOR +trnscId +"-data.csv");
			    
			    if(!"".equals(attachfileCVS)) {
			    	FileInputStream fileCsvIn = new FileInputStream(attachfileCVS);
			    	
			    	channelSftp.put(fileCsvIn, remoteFilePath + PATHSEPARATOR +trnscId +"-attach.csv");
			    	
			    	FileInputStream attachIn = null;
			    	String remoteAttachFilePath = remoteFilePath + PATHSEPARATOR + "attach";
			    	
			    	for (String savedFilePath : savedFileList) {
			    		attachIn = new FileInputStream(savedFilePath);
			    		String savedFileName[] = savedFilePath.split(PATHSEPARATOR);  
			    		String remoteFileInfo = remoteAttachFilePath+ PATHSEPARATOR + savedFileName[savedFileName.length-1];
			    		SftpATTRS attrs;
			    		
			            try {
			                attrs = channelSftp.stat(remoteAttachFilePath);
			            }catch (Exception e) {
			            	channelSftp.mkdir(remoteAttachFilePath);
			            }			  
			            
			    		channelSftp.put(attachIn, "."+remoteFileInfo);
			    	}
			    	
			    	attachIn.close();
			    	fileCsvIn.close();
			    }
			    
			    channelSftp.put(eofIn, remoteFilePath + PATHSEPARATOR + trnscId+ ".eof");
				
			    resultMap.put("trnscId", trnscId);
			    resultMap.put("intfcId", "IF-EXE-EFR-0074");

			    csvIn.close();
				eofIn.close();
			}
	    }
	    
		} catch (Exception e) {
			logger.info("SEND ERROR : ", e);
		}
		
	    return resultMap;
	}
	
	//집행정보 전송
	@Override
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public Map<String, Object> sendInfo(List<Map<String, Object>> dataList, String ip, String empSeq) throws Exception  {
			SFTPUtil sFTPUtil = SFTPUtil.getInstance();
		    ChannelSftp channelSftp = new ChannelSftp();
			Utils util = new Utils();
			FileInputStream csvIn = null;
			FileInputStream eofIn = null;
			boolean resultYn = true;
		    Map<String, Object> resultMap = new HashMap<String, Object>();
		    Map<String, Object> param = new HashMap<String, Object>();
		    List<Map<String, Object>> fileInfoList = new ArrayList<Map<String, Object>>();
		    SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
		    String cntcCreateDt = sf.format(new Date());
		    String systemCode = "EPIS"; // 시스템 코드
		    int wasNum = 1; // 업무용 WAS 번호 ( 다중화 구성일 경우 WAS의 순번 )
		    
		    Map<String, Object> erpInfo = kukgohDAO.getErpInfo();
		    channelSftp = sFTPUtil.connSFTP(erpInfo); // SFTP 연결 객체 생성
		    
			String intrfcId = "IF-EXE-EFR-0074";
			String trnscId = EsbUtils.getTransactionId(intrfcId, systemCode, wasNum);
			
			param.put("intrfcId", intrfcId);
			resultMap.put("OUT_YN", "");
			resultMap.put("OUT_MSG", "");
			
		    for (Map<String, Object> map2 : dataList) { // 화면 딴에서 받아온 파라미터 맵 데이터
		    	
		    	resultYn = true;
		    	
		    	List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();
		    	map2.put("TRNSC_ID", trnscId);
		    	map2.put("CNTC_CREAT_DT", cntcCreateDt);
		    	map2.put("TRNSC_ID_TIME", System.currentTimeMillis());
		    	fileList = kukgohDAO.getAttachFile(map2);
		    	
				if(fileList.size() > 0 ) {
					map2.put("FILE_ID", map2.get("targetId"));
				}
				
				map2.put("EMP_IP", ip);
				map2.put("EMP_SEQ", empSeq);
				kukgohDAO.sendInfo(map2); // 집행정보 G20 등록
				
				resultMap.put("OUT_YN", map2.get("OUT_YN"));
				resultMap.put("OUT_MSG", map2.get("OUT_MSG"));
				
				if(map2.get("OUT_YN").equals("Y")) {
					resultMap.put("YN", "Y");
					
					trnscId = (String)map2.get("OUT_TRNSC_ID");
					cntcCreateDt = (String)map2.get("OUT_CNTC_CREAT_DT");
					
					for (Map<String, Object> fileMap : fileList) {
						
						logger.info("fileMap@@:" + fileMap);
						
						fileMap.put("TRNSC_ID", trnscId);
						fileMap.put("INTRFC_ID", intrfcId);
						fileMap.put("CNTC_CREAT_DT", cntcCreateDt);
						fileMap.put("CNTC_SN", fileMap.get("file_seq"));
						fileMap.put("FILE_ID", map2.get("FILE_ID"));
						fileMap.put("CNTC_FILE_NM", fileMap.get("file_name") + "." +  fileMap.get("file_extension"));
						fileMap.put("CNTC_ORG_FILE_NM", fileMap.get("real_file_name") + "." +fileMap.get("file_extension")  );
						fileMap.put("EMP_IP", ip);
						fileMap.put("EMP_SEQ", empSeq);
						kukgohDAO.kukgohAttachSave(fileMap); 
						fileInfoList.add(fileMap);
					}
					
			    } else { 
			    	logger.info("OUT_YN : " +map2.get("OUT_YN"));
			    	logger.info("OUT_MSG : " +map2.get("OUT_MSG"));
			    	resultYn = false;
			    	continue;
			    }
			}
		    
		    if(resultYn) {
			    param.put("TRNSC_ID", trnscId);
		
				//원격 경로 세팅
			    Map<String, String> map2 = new HashMap<String, String>();
			    map2.put("groupCode", "ENARA");
			    map2.put("code", "REMOTE_SND_DIR");
			    Map<String, Object> remoteDirMap = commonDAO.getCodeOne(map2);
			    String remoteRootDirPath = (String)remoteDirMap.get("code_kr");  
			    
				//로컬 경로 셋팅
			    map2.put("groupCode", "ENARA");
			    map2.put("code", "LOCAL_SND_DIR");
				Map<String, Object> localDirMap = commonDAO.getCodeOne(map2);
				String localRootDirPath = (String)localDirMap.get("code_kr");
				
				String localFilePath = localRootDirPath+PATHSEPARATOR+intrfcId+PATHSEPARATOR+trnscId; // GW ?
				String remoteFilePath = remoteRootDirPath+PATHSEPARATOR+intrfcId+PATHSEPARATOR+trnscId; // G20
				
				logger.info("LOCAL ROOT DIR PATH : " + localFilePath);
				logger.info("REMOTE ROOT DIR PATH : " + remoteFilePath);
				
				List<Map<String, Object>> execRequestCsvList = kukgohDAO.execCsvSearch1(param);
				List<Map<String, Object>> execBimokCsvList = kukgohDAO.execCsvSearch2(param);
				List<Map<String, Object>> execBimokDataCsvList = kukgohDAO.execCsvSearch3(param);
				List<Map<String, Object>> execAttachFileCsvList = kukgohDAO.execCsvSearch4(param);
				
				String csvPath = util.createSendCSV(execRequestCsvList, execBimokCsvList, execBimokDataCsvList, trnscId, localFilePath); // -data.csv 파일 전체 경로
				String attachfileCVS = "";
				
				logger.info("csvPath : " + csvPath);
				
				List<String> savedFileList = new ArrayList<String>();
				
				if(execAttachFileCsvList.size() > 1) {
					logger.info("=== 파일처리 시작 ===");
					attachfileCVS =  util.createAttachFile(execAttachFileCsvList, trnscId, localFilePath);
					
					if(!"".equals(attachfileCVS)) {
						String attachFilePath = localFilePath+PATHSEPARATOR+"attach";
						
						if(util.directoryConfirmAndMake(attachFilePath)) {
							FileInputStream fis = null;
							FileOutputStream fos  = null;
							FileChannel fcin  = null;
							FileChannel fcout  = null;
							
							for (Map<String, Object> fileInfoMap : fileInfoList) {
								String sorceAttachFile = fileInfoMap.get("file_path") + PATHSEPARATOR + fileInfoMap.get("file_name") + "." +  fileInfoMap.get("file_extension");
								String destAttachFile = attachFilePath + PATHSEPARATOR + fileInfoMap.get("file_name") + "." +  fileInfoMap.get("file_extension");
								fis = new FileInputStream(new File(sorceAttachFile));
								fos = new FileOutputStream(new File(destAttachFile));
								fcin = fis.getChannel();
								fcout = fos.getChannel();
								long size = fcin.size();
								fcin.transferTo(0, size, fcout);
								savedFileList.add(destAttachFile);
							}
							
							fcout.close();
							fcin.close();
							fis.close();
							fos.close();
						}
					}
				}
				
				String eofFilePath = util.createEof(trnscId , localFilePath);
				
				if((!csvPath.equals("")) && !(eofFilePath.equals(""))) {
					logger.info("=== 마지막 파일처리 시작 ===");
				    csvIn = new FileInputStream(csvPath);
					eofIn = new FileInputStream(eofFilePath);
					
					channelSftp.mkdir("."+remoteFilePath);
					
				    channelSftp.put(csvIn, remoteFilePath + PATHSEPARATOR +trnscId +"-data.csv");
				    
				    if(!"".equals(attachfileCVS)) {
				    	FileInputStream fileCsvIn = new FileInputStream(attachfileCVS);
				    	
				    	channelSftp.put(fileCsvIn, remoteFilePath + PATHSEPARATOR +trnscId +"-attach.csv");
				    	
				    	FileInputStream attachIn = null;
				    	String remoteAttachFilePath = remoteFilePath + PATHSEPARATOR + "attach";
				    	
				    	for (String savedFilePath : savedFileList) {
				    		attachIn = new FileInputStream(savedFilePath);
				    		String savedFileName[] = savedFilePath.split(PATHSEPARATOR);  
				    		String remoteFileInfo = remoteAttachFilePath+ PATHSEPARATOR + savedFileName[savedFileName.length-1];
				    		SftpATTRS attrs;
				    		
				            try {
				                attrs = channelSftp.stat(remoteAttachFilePath);
				            }catch (Exception e) {
				            	channelSftp.mkdir(remoteAttachFilePath);
				            }			  
				            
				    		channelSftp.put(attachIn, "."+remoteFileInfo);
				    	}
				    	
				    	attachIn.close();
				    	fileCsvIn.close();
				    }
				    
				    channelSftp.put(eofIn, remoteFilePath + PATHSEPARATOR + trnscId+ ".eof");
					
				    resultMap.put("trnscId", trnscId);
				    resultMap.put("intfcId", "IF-EXE-EFR-0074"); // TODO
					csvIn.close();
					eofIn.close();
				}
		    }
		    return resultMap;
	
	}
	
	//집행정보 재전송
	@Override
	public Map<String, Object> cancelSendInfo(Map<String, Object> map) {
		return kukgohDAO.cancelSendInfo(map);
	}

	@Override
	public List<Map<String, Object>> kukgohInvoiceGrid(Map<String, Object> map) {
		return kukgohDAO.kukgohInvoiceGrid(map);
		}

	@Override
	public Map<String, Object> invoiceValidation(Map<String, Object> map) {
		return kukgohDAO.invoiceValidation(map);
	}

	@Override
	public Map<String, Object> saveCheck(Map<String, Object> map) {
		return kukgohDAO.saveCheck(map);
	}    
	
	@Override
	public Map<String, Object> insertAttachFile(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception{
		String path = "kukgoh";
		String filePath = "";
		String systemCode = "EPIS";
		int wasNum = 1;
		Utils util = new Utils();
		
		map.put("ip", com.duzon.custom.common.utiles.Utils.getIp(multi));
		map.put("outYn", "");
		map.put("outMsg", "");
		
		if("N".equals(map.get("resultYn"))) {
			
		} else {
			map.put("targetId", map.get("targetId"));
			Iterator<String> files = multi.getFileNames();
			
			 while(files.hasNext()){
				String uploadFile = files.next();                         
				MultipartFile mFile = multi.getFile(uploadFile);            
	           	String fileName = mFile.getOriginalFilename();
				String fileSize = String.valueOf(mFile.getSize());
				
				if (fileName.equals("")) { 
					
		        } else {
		        	map.put("targetTableName", "kukgoh");
		        	map.put("fileSeq",kukgohDAO.getCommFileSeq(map));
		        	kukgohDAO.insertAttachFile(map);
		        	
		        	if ("N".equals(map.get("outYn").toString())) {
		        		throw new Exception();
		        	} else {
		        		String trnscId = EsbUtils.getTransactionId((String)map.get("intrfcId"), systemCode, wasNum);
		        		String fileNm = map.get("attach_file_id") + "." + fileName.substring(fileName.lastIndexOf(".")+1);
		        		String rstFileName = util.makeFileName(trnscId, map.get("attach_file_id").toString());
			        	int Idx = fileName.lastIndexOf(".");
			        	String _fileName = fileName.substring(0, Idx);
		            	Calendar cal = Calendar.getInstance();
		            	String yyyy = String.valueOf(cal.get(Calendar.YEAR));
		            	String mm = String.valueOf(cal.get(Calendar.MONTH) + 1);
		            	//String subPath = yyyy+File.separator+mm;
		            	//filePath = fileRootPath+File.separator+path+File.separator+subPath+File.separator;
		            	filePath = String.valueOf(map.get("enaraFilePath")) + "/" + String.valueOf(map.get("C_DIKEYCODE") + "/" + path + "/");
		            	String ext = fileName.substring(fileName.lastIndexOf(".")+1);
		            	String rstFileNameWithExt = rstFileName + "." + ext;
		            	
		            	File dir = new File(filePath);
		            	
		            	System.out.println(dir.isDirectory());
		            	System.out.println(dir.getAbsolutePath());
		            	
			            if(!dir.isDirectory()){
			                dir.mkdirs();
			            }
			            
		                mFile.transferTo(new File(filePath + rstFileNameWithExt));
		                map.put("rstFileName", rstFileName);
		                map.put("filePath", filePath);
		        		map.put("fileNm", _fileName);
		        		map.put("ext", ext);
		        		map.put("fileSize", fileSize);
		        		kukgohDAO.commFileInfoUpdate(map);
			            map.put("outYn", "Y");
			            map.put("realFileNm", fileName);
		        	}
		        }
			 }
		}
		return map;
	}
	
	
	public void files(Map<String, Object> map) {
		String fileNm = (String)map.get("CNTC_FILE_NM");
		String fileExtension = fileNm.substring(fileNm.lastIndexOf(".")+1,fileNm.length());
		fileNm = fileNm.replace("."+fileExtension, "");
		map.put("target_table_name","kukgoh");
		//TODO 파일 위치 수정
		Long time = System.currentTimeMillis();
		map.put("target_id", time.toString());
		map.put("file_seq",map.get("CNTC_SN"));
		map.put("file_name", fileNm);
		map.put("real_file_name",map.get("CNTC_ORG_FILE_NM").toString().replaceAll("."+fileExtension, ""));
		map.put("file_extension", fileExtension);
	}
	@Override
	//@Async
	public void asyncGetFiles() throws SftpException, IOException {
		int i = 0;
		try {
			while (i < 5) { 
				System.out.println("스레드 슬립 : " + i++);
				Thread.sleep(5000);
		    	long start = System.currentTimeMillis();
		        String ip = "SYSTEM";
				String empSeq = "SYSTEM";
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("EMP_SEQ", empSeq);
				map.put("EMP_IP", ip);
				map.put("CODE_VAL", "0");
		    	getRemoteFile(map);
		    	long end = System.currentTimeMillis();
		    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println("end:");
	}

	@Override
	public int deleteFile(Map<String, Object> map) {
		
		//kukgohDAO.deleteFileMs(map);
		return kukgohDAO.deleteFile(map);
	}

	@Override
	public List<Map<String, Object>> kukgohInvoiceInsertGrid(Map<String, Object> map) {
		
		List<Map<String, Object>> invoiceList = kukgohDAO.kukgohInvoiceInsertGrid(map);
		
		for (Map<String, Object> vo : invoiceList) {
			
			if ("".equals(vo.get("ETXBL_CONFM_NO")) || vo.get("ETXBL_CONFM_NO") == null) {
				vo.put("C_DIKEYCODE", map.get("C_DIKEYCODE"));
				vo.put("OUT_MSG2", "");
				vo.put("sended", "N");
				kukgohDAO.getDocInvoice(vo);
			} else {
				vo.put("sended", "Y");
			}
		}
		
		return invoiceList;
	}

	@Override
	public List<Map<String, Object>> getInterfaceGrid(Map<String, Object> map) {
		return kukgohDAO.getInterfaceGrid(map);
	}

	@Override
	public int insertTrnscIdReadStatus(Map<String, Object> map) {
		return kukgohDAO.insertTrnscIdReadStatus(map);
	}

	@Override
	public int updateTrnscIdReadStatus(Map<String, Object> map) {
		return kukgohDAO.updateTrnscIdReadStatus(map);
	}

	@Override
	public int ckeckTrnscIdReadStatus(Map<String, Object> map) {
		return kukgohDAO.ckeckTrnscIdReadStatus(map);
	}

	@Override
	public Map<String, Object> getUrlInfo() {
		return kukgohDAO.getUrlInfo();
	}
	
	@Override
	public void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
			
				String path = "";		
				String fileNm = "";
				String fileExt = "";
				String fileName = "";
				Map<String, Object> result =  kukgohDAO.fileDown(map);
				
				fileNm = (String) result.get("real_file_name");
				fileNm = fileNm.replaceAll(",", "¸");
				fileExt = (String) result.get("file_extension");
				fileName = "\"" + fileNm +"\""+"."+fileExt;
				path +=  (String) result.get("file_path") + String.valueOf(result.get("file_name")) + "." + fileExt; // 저장파일명으로 변경
				
				
				try {
					fileDownLoad(fileName, path, request, response);
				} catch (Exception e) {
					e.printStackTrace();
				}
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
		}
		
	}
	private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
	public List<Map<String, Object>> admSendGrid(Map<String, Object> map) {
		return kukgohDAO.admSendGrid(map);
	}

	@Override
	public List<Map<String, Object>> admAccountGrid(Map<String, Object> map) {
		if(map.get("cntcSeq").toString() != "" ) {
			if("0".equals(map.get("cntcSeq").toString())) {
				return kukgohDAO.getUnSendData(map);
			}else {
				return kukgohDAO.admAccountGrid(map);
			}
		}else {
			return null;
		}

	}

	@Override
	public List<Map<String, Object>> admResolutionMainGrid(Map<String, Object> map) {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		resultList = kukgohDAO.insertResolutionMainGrid(map);
		List<Map<String, Object>> returnList = new ArrayList<>();
			
		for (Map<String, Object> map2 : resultList) {
			map2.put("C_DIKEYCODE", "");
			map2.put("DOC_NUMBER", "");
			map2.put("DOC_TITLE", "");
			map2.put("DOC_REGDATE", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");
			kukgohDAO.getDocInfo(map2);
			if (map2.get("OUT_YN") == null || "N".equals(map2.get("OUT_YN"))) {
				map2.put("OUT_YN", "N");
				map2.put("DOC_NUMBER", "-");
				map2.put("DOC_TITLE", "-");
				map2.put("DOC_REGDATE", "-");
			} else {
				returnList.add(map2);
			}
		}
		
		return returnList;
	}
	
	// -------------------------------- 새로 시작 -------------------------------------
	@Override
	public boolean saveAssntInfo(Map<String, Object> jsonMap) throws JsonParseException, JsonMappingException, IOException {
		boolean result = true;

			jsonMap.put("OUT_YN", "");
			jsonMap.put("OUT_MSG", "");
			
			if (jsonMap.get("BGT_NM") == null) {
				jsonMap.put("BGT_NM", "");
			}
			
			kukgohDAO.saveAssntInfo(jsonMap);
		
		return result;
	}
	
	@Override
	public List<Map<String, Object>> getCardList(Map<String, Object> map) {
		return kukgohDAO.getCardList(map);
	}
	
	@Override
	public List<Map<String, Object>> getCardNoList(Map<String, Object> map) {
		return kukgohDAO.getCardNoList(map);
	}
	
	@Override
	public List<Map<String, Object>> getAsstnGridPop(Map<String, Object> map) {
		return kukgohDAO.getAsstnGridPop(map);
	}
	
	@Override
	public void updateCancelAssntInfo(Map<String, Object> map) throws Exception{
		
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
		
		kukgohDAO.updateCancelAssntInfo(map);
	}

	
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> watchNewFiles(String[] list) {
		
		logger.info("========= watchNewFiles ============");
		
		ChannelSftp channelSftp = new ChannelSftp();
		SFTPUtil sFTPUtil = SFTPUtil.getInstance();
		Map<String, Object>erpInfo = kukgohDAO.getErpInfo();
		channelSftp = sFTPUtil.connSFTP(erpInfo);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("flag", "N");
		String checkPath = "";
		List<Map<String, Object>> resultList = new ArrayList<>();
			
		Vector<ChannelSftp.LsEntry> fileAndFolderList;
		
		try {
			
			for (String intfcId : list) {
				
				checkPath = "/mtDir/rcv/" + intfcId;
				
		  		fileAndFolderList = channelSftp.ls(checkPath);
		  		
		  		logger.info("========= fileAndFolderList ============");
		  		logger.info("fileAndFolderList : " + fileAndFolderList);
		  		
		  		for (ChannelSftp.LsEntry intrfcItem : fileAndFolderList) {
		  			
		  			if (!(intrfcItem.getFilename().startsWith("backup_") || "..".equals(intrfcItem.getFilename()) || ".".equals(intrfcItem.getFilename())) && intrfcItem.getAttrs().isDir()) {
		  				
		  				Map<String, Object> updatedMap = new HashMap<>();
		  				
						Vector<ChannelSftp.LsEntry> ffList = channelSftp.ls(checkPath + PATHSEPARATOR + intrfcItem.getFilename());
						
						for (ChannelSftp.LsEntry lsEntry : ffList) {
							
							if (lsEntry.getFilename().endsWith(".eof")) {
								
								updatedMap.put("intfcId", intfcId);
								updatedMap.put("filePath", checkPath + PATHSEPARATOR + intrfcItem.getFilename());
								updatedMap.put("trnscId", intrfcItem.getFilename());
								
								resultList.add(updatedMap);
							}
						}
		  			}
		  		}
	  		}
			
			logger.info("=== resultList Size ===" + resultList.size());
			
			if (resultList.size() > 0) {
				resultMap.put("flag", "Y");
				resultMap.put("resultList", resultList);
			}
		
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		} finally {
			channelSftp.exit();
			channelSftp.disconnect();
			channelSftp = null;
			sFTPUtil.disconnectSFTP();
			fileAndFolderList = null;
		}
		
  		return resultMap;
	}

	@Override
	public Map<String, Object> cancelProjectConfig(Map<String, Object> map) {
		
		kukgohDAO.cancelProjectConfig(map);
		
		return null;
	}

	@Override
	public List<Map<String, Object>> sendInvoiceMainGrid(Map<String, Object> map) {
		
		List<Map<String, Object>> invoiceList = kukgohDAO.getInvoice(map);
		
		for (Map<String, Object> invoiceMap : invoiceList) {
			
			kukgohDAO.sendInvoiceMainGrid(invoiceMap);
		}
		
		return invoiceList;
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public Map<String, Object> saveSendingInvoice(List<Map<String, Object>> list, String empSeq, String ip, String url) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<>();
		
		HttpClientSample client = new HttpClientSample();
		
		for (Map<String, Object> map : list) {
			
			map.put("TRNSC_ID_TIME", System.currentTimeMillis());
			map.put("TRNSC_ID", "");
			map.put("EMP_SEQ", empSeq);
			map.put("EMP_IP", ip);
			map.put("CNTC_SN", "");
			map.put("CNTC_CREAT_DT", "");
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			
			kukgohDAO.saveSendingInvoice(map);
			
			try {
				requestInvoice2(map);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			if (map.get("OUT_YN").equals("N")) { // 비정상 처리 시
				resultMap.put("OUT_MSG", map.get("OUT_MSG"));
				resultMap.put("OUT_YN", map.get("OUT_YN"));
				throw new Exception(String.valueOf(map.get("OUT_MSG")));
			} else if (map.get("OUT_YN").equals("Y")) {
				client.setClient("IF-EXE-EFR-0071", map.get("TRNSC_ID").toString(), url);
			}
		}
		
		return resultMap;
	}

	@Override
	public void saveKorailCityInfo(Map<String, Object> map) {
		kukgohDAO.saveKorailCityInfo(map);
		
	}

	@Override
	public void saveKorailNodeInfo(Map<String, Object> map) {
		kukgohDAO.saveKorailNodeInfo(map);
	}

	@Override
	public void saveKorailVehicleKind(Map<String, Object> map) {
		kukgohDAO.saveKorailVehicleKind(map);
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public void deleteKorailInfoAll() {
		kukgohDAO.deleteKorailVehicleKindInfo();
		kukgohDAO.deleteKorailNodeInfo();
		kukgohDAO.deleteKorailCityInfo();
	}

	@Override
	public String getErpDeptNo(Map<String, Object> map) {
		return kukgohDAO.getErpDeptNo(map);
	}

	@Override
	public List<Map<String, Object>> sendResolutionGrid(Map<String, Object> map) throws Exception{
		
		List<Map<String, Object>> resultList = kukgohDAO.sendResolutionGrid(map);
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		for (Map<String, Object> map2 : resultList) {
			
			map2.put("C_DIKEYCODE", "");
			map2.put("DOC_NUMBER", "");
			map2.put("DOC_TITLE", "");
			map2.put("DOC_REGDATE", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");
			kukgohDAO.getDocInfo(map2);
			
			// 문서가 존재하는 건만 리스트에 담기
			if (map2.get("OUT_YN") == null || "N".equals(map2.get("OUT_YN"))) {
				map2.put("OUT_YN", "N");
				map2.put("DOC_NUMBER", "-");
				map2.put("DOC_TITLE", "-");
				map2.put("DOC_REGDATE", "-");
			} else {
				returnList.add(map2);
			}
		}
		
		for (Map<String, Object> vo : returnList) {
			
				// 전자세금계산서 승인번호 가져오기
				vo.put("ETXBL_CONFM_NO", "");
				vo.put("OUT_MSG2", "");
				
				logger.info("ETXBL_CONFM_NO1 : " + String.valueOf(vo.get("ETXBL_CONFM_NO")));
				
				if (!vo.get("SET_FG_NM").equals("신용카드")) { // 신용카드외 증빙번호와 증빙일자 넣어주기
					
					kukgohDAO.getDocInvoice(vo);
					
					if (String.valueOf(vo.get("ETXBL_CONFM_NO")) == null || "null".equals(String.valueOf(vo.get("ETXBL_CONFM_NO")))) {
						logger.info("ETXBL_CONFM_NO4 : " + String.valueOf(vo.get("ETXBL_CONFM_NO")));
						vo.put("ETXBL_CONFM_NO", "");
					}
					
					// 증빙일자 넣어주는 작업
					if (String.valueOf(vo.get("PRUF_SE_CODE")).equals("999") && String.valueOf(vo.get("EXCUT_REQUST_DE")).equals("")) {
						vo.put("EXCUT_REQUST_DE", String.valueOf(vo.get("DOC_REGDATE")));
					}
				}
					
				//보조금 코드 작업
				Map<String, Object> bojoMap = kukgohDAO.getTradeBojoInfo(vo);
				
				if (bojoMap != null && String.valueOf(bojoMap.get("bojoCode")) != null && !String.valueOf(bojoMap.get("bojoCode")).equals("2")) {
					vo.put("TRANSFR_ACNUT_SE_CODE_NM", "보조금계좌로이체");
					vo.put("TRANSFR_ACNUT_SE_CODE", "002");
					vo.put("SBSACNT_TRFRSN_CODE_NM", String.valueOf(bojoMap.get("bojoReasonText")));
					vo.put("SBSACNT_TRFRSN_CODE", "00" + String.valueOf(bojoMap.get("bojoReasonCode")));
					vo.put("BCNC_ACNUT_NO", String.valueOf(vo.get("PJT_ACCTNB")));
					vo.put("BCNC_BANK_CODE", String.valueOf(vo.get("PJT_BANKCD2")));
					vo.put("BCNC_BANK_CODE_NM", String.valueOf(vo.get("PJT_BANKNM")));
					vo.put("TRNSC_ID_TIME", System.currentTimeMillis());
					
					vo.put("CHK_YN", kukgohDAO.checkValidYN(vo));
					vo.put("CHK_MSG", kukgohDAO.checkValidMsg(vo));
				}
				
				// 기타 + 증빙번호 존재할 경우 수정
				if (String.valueOf(vo.get("PRUF_SE_CODE")).equals("999") && !String.valueOf(vo.get("ETXBL_CONFM_NO")).equals("") && !String.valueOf("CHK_YN").equals("N")) {
					vo.put("CHK_YN", "N");
					vo.put("CHK_MSG", "세금계산서 E나라도움 전송이 필요합니다.");
				}
				
				if (Integer.parseInt(kukgohDAO.checkAttachPDF(vo)) < 1) { // 첨부파일이 없으면
					vo.put("CHK_YN", "N");
					vo.put("CHK_MSG", "첨부파일 확인이 필요합니다.");
				}
			}
		
		return returnList;
	}

	@Override
	public Map<String, Object> submitPageSending(Map<String, Object> map) {
		return kukgohDAO.submitPageSending(map);
	}

	@Override
	public Map<String, Object> submitPageConfirm(Map<String, Object> map) {
		return kukgohDAO.submitPageConfirm(map);
	}

	@Override
	public Map<String, Object> getPjtInfo(Map<String, Object> map) {
		
		Map<String, Object> resultMap = new HashMap<>();
		
		for (int i = 1; i <= 5; i++) {
			map.put("SEL", i);
			
			String value = kukgohDAO.getPjtInfo(map);
			
			switch (i) {
			case 1: // 프로젝트 명
				resultMap.put("PJT_NM", value);
				break;
			case 2:
				resultMap.put("BCNC_ACNUT_NO", value);
				break;
			case 3:
				resultMap.put("BCNC_BANK_CODE_NM", value);
				break;
			case 4:
				resultMap.put("BCNC_BANK_CODE", value);
				break;
			case 5:
				resultMap.put("BCNC_BANK_CODE_ENARA", value);
				break;				
			}
		}
		
		return resultMap;
	}

	@Override
	public Map<String, Object> changeAccountType(Map<String, Object> map) {
		return kukgohDAO.changeAccountType(map);
	}

	@Override
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public Map<String, Object> getEnaraAttaches(Map<String, Object> map) throws Exception{
		
		String systemCode = "EPIS";
		int wasNum = 1;
		Utils util = new Utils();
		String intrfcId = "IF-EXE-EFR-0074";
		String trnscId = EsbUtils.getTransactionId(intrfcId, systemCode, wasNum);
		String targetid = (String) map.get("targetId");
		
		List<Map<String, Object>> checkList = kukgohDAO.getAttachFile(map);
		
		List<Map<String, Object>> attachPathList = kukgohDAO.getDocAttachPath(map);
		
		if (attachPathList.size() == 0 || checkList.size() >= attachPathList.size()) {
			throw new Exception("DUP");
		} else {
			
			for (Map<String, Object> attach : attachPathList) {
				
				attach.put("targetTableName", "kukgoh");
				attach.put("fileSeq",kukgohDAO.getCommFileSeq(map));
				attach.put("targetId", targetid);
				
				kukgohDAO.insertAttachFile(attach);
				
				attach.put("rstFileName", util.makeFileName(trnscId, attach.get("attach_file_id").toString()));
				
				String resultFilePath = copyFileToEnara(attach);
				
				attach.put("filePath", resultFilePath);
				attach.put("fileNm", (String) attach.get("c_aititle"));
				attach.put("ext", (String) attach.get("c_aifiletype"));
				attach.put("fileSize", attach.get("c_aisize"));
				
				kukgohDAO.commFileInfoUpdate(attach);
			}
		}
		
		
		return null;
	}
	
	public String copyFileToEnara(Map<String, Object> attach) throws Exception{
		
		String MIDDLE_FOLDER = "enara";
		
		String orgFileName = (String) attach.get("c_aititle");
		String realFileName = (String) attach.get("c_aifilename");
		String extension = (String) attach.get("c_aifiletype");
		String filePath = (String) attach.get("file_stre_cours");
		String absolPath = (String) attach.get("absol_path");
		
		String resultFilePath = absolPath + filePath + "/" + MIDDLE_FOLDER + "/" + attach.get("rstFileName") + "." + extension;
		
		File fromFile = new File(absolPath + filePath + "/" + realFileName);
		File toFileDir = new File(absolPath + filePath + "/" + MIDDLE_FOLDER);
        File toFile = new File(resultFilePath);
		
        toFileDir.mkdirs();
		
        FileInputStream fis = new FileInputStream(fromFile); //읽을파일
        FileOutputStream fos = new FileOutputStream(toFile); //복사할파일
        
        int fileByte = 0; 
        // fis.read()가 -1 이면 파일을 다 읽은것
        while((fileByte = fis.read()) != -1) {
            fos.write(fileByte);
        }
        //자원사용종료
        fis.close();
        fos.close();
			
        return absolPath + filePath + "/" + MIDDLE_FOLDER + "/";
	}

	@Override
	public Map<String, Object> getErpDeptNum(Map<String, Object> map) {
		return kukgohDAO.getErpDeptNum(map);
	}

	@Override
	public List<Map<String, Object>> kukgohInvoiceInsertGrid2(Map<String, Object> map) {
		return kukgohDAO.kukgohInvoiceInsertGrid2(map);
	}

	@Override
	public List<Map<String, Object>> sendResolutionGrid2(Map<String, Object> map) {
		
		List<Map<String, Object>> resultList = kukgohDAO.sendResolutionGrid2(map);
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		for (Map<String, Object> map2 : resultList) {
			
			map2.put("C_DIKEYCODE", "");
			map2.put("DOC_NUMBER", "");
			map2.put("DOC_TITLE", "");
			map2.put("DOC_REGDATE", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");
			kukgohDAO.getDocInfo(map2);
			
			// 문서가 존재하는 건만 리스트에 담기
			if (map2.get("OUT_YN") == null || "N".equals(map2.get("OUT_YN"))) {
				map2.put("OUT_YN", "N");
				map2.put("DOC_NUMBER", "-");
				map2.put("DOC_TITLE", "-");
				map2.put("DOC_REGDATE", "-");
			} else {
				map2.put("ETXBL_CONFM_NO", "");
				returnList.add(map2);
			}
		}
		
		return returnList;
	}
	
	@Override
	public Map<String, Object> getRestradeInfo(Map<String, Object> map) {
		return kukgohDAO.getRestradeInfo(map);
	}
	
	@Override
	public Map<String, Object> getBankcode(Map<String, Object> map) {
		return kukgohDAO.getBankcode(map);
	}

	@Override
	public void exceptEnaraDoc(Map<String, Object> map) {
		kukgohDAO.exceptEnaraDoc(map);
	}

	@Override
	public void reloadEnaraExceptDoc(Map<String, Object> map) {
		kukgohDAO.reloadEnaraExceptDoc(map);
	}

	@Override
	public List<Map<String, Object>> selectEnaraExceptList(Map<String, Object> map) {
		return kukgohDAO.selectEnaraExceptList(map);
	}
}
