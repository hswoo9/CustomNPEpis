package com.duzon.custom.kukgoh.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.SocketException;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.net.ftp.FTPSClient;

public class FTPSUtil {
	private String serverIp;
	private int serverPort;
	private String user;
	private String password;

	public FTPSUtil(String serverIp, int serverPort, String user, String password) {
		this.serverIp = serverIp;
		this.serverPort = serverPort;
		this.user = user;
		this.password = password;
	}
	
	public boolean upload(File fileObj, String fileName, String fileLocation) throws SocketException, IOException, Exception {
		
	FileInputStream fis = null; // 여기까지
	FTPSClient ftpClient = new FTPSClient();
	//FTPClient ftpClient = new FTPClient();

	try {
			ftpClient.setControlEncoding("EUC-KR");
			ftpClient.connect(serverIp, serverPort); //ftp 연결
			ftpClient.setControlEncoding("EUC-KR");
			int reply = ftpClient.getReplyCode(); //응답코드받기
		
			System.out.println(FTPReply.isPositiveCompletion(reply) + "응답코드 확인!@#$");
			
		if (!FTPReply.isPositiveCompletion(reply)) { //응답이 false 라면 연결 해제 exception 발생
			ftpClient.disconnect();
			throw new Exception(serverIp+" FTP 서버 연결 실패");
		}
		
			ftpClient.setSoTimeout(1000 * 30); //timeout 설정
			ftpClient.login(user, password); //ftp 로그인
			
		try{
			ftpClient.makeDirectory(fileLocation);
		}catch(Exception e){
			e.printStackTrace();
		}
		
			ftpClient.changeWorkingDirectory(fileLocation);
			ftpClient.setFileType(FTPSClient.BINARY_FILE_TYPE); //파일타입설정
			ftpClient.enterLocalPassiveMode(); //active 모드 설정
		
			fis = new FileInputStream(fileObj);
			
			return ftpClient.storeFile(fileName, fis); //파일 업로드
		} finally {
			if (ftpClient.isConnected()) {
				ftpClient.disconnect();
			}
			if (fis != null) {
				fis.close();
			}
		}
	}

}
