package com.duzon.custom.kukgoh.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

public class SFTPUtil {

	private static SFTPUtil sftpUtil;
	static final  String PATHSEPARATOR = "/";
	private Session session = null;
	private Channel channel = null;
	
	public static SFTPUtil getInstance() {
		
		if (sftpUtil == null) {
			sftpUtil = new SFTPUtil();
			return sftpUtil;
		} else {
			return sftpUtil;
		}
	}
	
	public void disconnectSFTP() {
		
		if (this.channel != null) {
			
			System.out.println("channel connect true");
			this.channel.disconnect();
			this.channel = null;
		}
		
		if (this.session != null) {
			
			System.out.println("session connect disconnect !");
			this.session.disconnect();
			this.session = null;
		}
		
	}
	
	public ChannelSftp connSFTP(Map<String, Object> erpInfo) {
		ChannelSftp channelSftp = new ChannelSftp();
		JSch jsch = new JSch();
		
		try {
			this.session = jsch.getSession(erpInfo.get("id").toString(), erpInfo.get("ip").toString(), Integer.parseInt(erpInfo.get("port").toString())); // getSession(userName[접속에 사용될 아이디], host[서버 주소], port[포트번호])
			this.session.setPassword(erpInfo.get("pw").toString());
			java.util.Properties config = new java.util.Properties();
			config.put("StrictHostKeyChecking", "no");
			this.session.setConfig(config);
			this.session.connect(); // Create SFTP Session
			this.channel = this.session.openChannel("sftp"); // Open SFTP Channel
			this.channel.connect();
			channelSftp = (ChannelSftp) this.channel;
			//channelSftp.cd(remoteDir); // Change Directory on SFTP Server
			
		} catch (JSchException e) {
			e.printStackTrace();
		} 
		return channelSftp;
	}
	
	public List<KukgohCommVO> readCsv(String path, String encoding) {

		BufferedReader br = null;
		String line = "";
		boolean boolTF = false;
		List<List<String>> ret = new ArrayList<List<String>>();
		// File csv = new
		// File("D:\\IBTC00_IF-CMM-EFS-0061_T00001_1513299714273-data.csv");
		List<KukgohCommVO> kukgohInfoList = new ArrayList<KukgohCommVO>();
		String tableName = null;
		KukgohCommVO kukgohInfo = null;
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(path), encoding));
			// br = new BufferedReader(new FileReader(csv));
			int i = 0;
			int k = 0;

			while ((line = br.readLine()) != null) {
				// CSV 1행을 저장하는 리스트
				Map<String, Object> map = new HashMap<String, Object>();
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

					kukgohInfo.setTableName(tableName);
					System.out.println(tableName);
					boolTF = true;
					k++;
				} else if (boolTF) {
					// 쌍따옴표 뺴기
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
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		return kukgohInfoList;
		}
	}
    /**
     * This method is called recursively to download the folder content from SFTP server
     * 
     * @param sourcePath
     * @param destinationPath
     * @throws SftpException
     */
	public List<String> dirList = new ArrayList<String>(); 
	@SuppressWarnings("unchecked")
    public boolean recursiveFolderDownload(ChannelSftp channelSftp,  String sourcePath, String destinationPath) {
        Vector<ChannelSftp.LsEntry> fileAndFolderList;
        boolean result = false;
		try {
			fileAndFolderList = channelSftp.ls(sourcePath);
	        for (ChannelSftp.LsEntry item : fileAndFolderList) {
	            
	            if (!item.getAttrs().isDir()) { // Check if it is a file (not a directory).
	                if (!(new File(destinationPath + PATHSEPARATOR + item.getFilename())).exists() || (item.getAttrs().getMTime() > Long.valueOf(new File(destinationPath + PATHSEPARATOR + item.getFilename()).lastModified()/ (long) 1000).intValue())) { // Download only if changed later.
	                    new File(destinationPath + PATHSEPARATOR + item.getFilename()); 
	                    channelSftp.get(sourcePath + PATHSEPARATOR + item.getFilename(), destinationPath + PATHSEPARATOR + item.getFilename()); // Download file from source (source filename, destination filename).
	                    String fileNm =item.getFilename(); 
	                    int pos = fileNm.lastIndexOf( "." );
	                    String ext = fileNm.substring(pos+1);
	                   if(ext.equals("scv")) {
	                	   String filePath =sourcePath+PATHSEPARATOR+fileNm; 
	                	   List<KukgohCommVO> kukgohInfoList = readCsv(filePath, "EUC-KR");
	                	   
	                    	// sourcePath로 파일 읽기
	                    	//destinationPath 파일이름 변경
	                   }
	                }
	            } else if (!(".".equals(item.getFilename()) || "..".equals(item.getFilename()) || item.getFilename().startsWith("backup_"))) {
	            	String dirPath = destinationPath + PATHSEPARATOR + item.getFilename();
	                new File(dirPath).mkdirs(); // Empty folder copy.
	            	dirList.add(dirPath);
	                if(recursiveFolderDownload(channelSftp, sourcePath + PATHSEPARATOR + item.getFilename(), destinationPath + PATHSEPARATOR + item.getFilename())) {
	                	
	                }else {
	                	result = false;
	                }
	                	
	            }
	        }
	        result = true;
		} catch (SftpException e) {
			result = false;
			e.printStackTrace();
		}  
		return result;
    }
    public void getSFTPConnection(ChannelSftp channelSftp, Channel channel, Session session, String host, int port, String userId, String passwd, String remoteDir, String localDir) {
        try {
            JSch jsch = new JSch();
            session = jsch.getSession(userId, host, port);
            session.setPassword(passwd);
            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.connect(); // Create SFTP Session
            channel = session.openChannel("sftp"); // Open SFTP Channel
            channel.connect();
            channelSftp = (ChannelSftp) channel;
            channelSftp.cd(remoteDir); // Change Directory on SFTP Server

            recursiveFolderDownload(channelSftp, remoteDir, localDir); // Recursive folder content download from SFTP server
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (channelSftp != null)
                channelSftp.disconnect();
            if (channel != null)
                channel.disconnect();
            if (session != null)
                session.disconnect();

        }
    }
	public List<String> getTrFolder(ChannelSftp channelSftp, List<String> interfaceIdFolder, String remoteDir, String localDir) throws SftpException {
		List<String> transactionFolder = new ArrayList<String>();
		for (String folderName : interfaceIdFolder) {
			String path  = remoteDir+PATHSEPARATOR+folderName+PATHSEPARATOR;
			Vector<ChannelSftp.LsEntry> fileAndFolderList = channelSftp.ls(path); // Let list of folder content
			for (ChannelSftp.LsEntry item : fileAndFolderList) {
				if(item.getAttrs().isDir() && !(".".equals(item.getFilename()) || "..".equals(item.getFilename()) || item.getFilename().startsWith("backup_"))) {
					String transactionIdFolderName = item.getFilename();
					String transactionFolderPath = path + transactionIdFolderName+PATHSEPARATOR;;
					transactionFolder.add(transactionFolderPath);
					//TODO 중복검사 필요
					//TODO 다운받은 파일 DB 등록...
					
					channelSftp.rename(path + transactionIdFolderName,path + "backup_"+ transactionIdFolderName);
				}
			}
		}
		return transactionFolder;
	}
	public boolean remoteDirRename(ChannelSftp channelSftp, List<String> interfaceIdFolder, String remoteDir, String localDir) throws SftpException {
		boolean result = true; 
		try {
			for (String folderName : interfaceIdFolder) {
				String path  = remoteDir+PATHSEPARATOR+folderName+PATHSEPARATOR;
				Vector<ChannelSftp.LsEntry> fileAndFolderList = channelSftp.ls(path); // Let list of folder content
				for (ChannelSftp.LsEntry item : fileAndFolderList) {
					if(item.getAttrs().isDir() && !(".".equals(item.getFilename()) || "..".equals(item.getFilename()) || item.getFilename().startsWith("backup_"))) {
						System.out.println("트랜잭션아이디 이름 : " + item.getFilename());
						String transactionIdFolderName = item.getFilename();
						String transactionFolderPath = path + transactionIdFolderName+PATHSEPARATOR;;
						//TODO 중복검사 필요
						//TODO 다운받은 파일 DB 등록...
						
						channelSftp.rename(path + transactionIdFolderName,path + "backup_"+ transactionIdFolderName);
					}
				}
			}
		}catch (Exception e) {
			result = false;
			e.printStackTrace();
		}
		return result;
	}	
	public boolean dirRename(ChannelSftp channelSftp, String folderName, String remoteDir, String localDir) throws SftpException {
		boolean result = true; 
		try {
				String path  = folderName+PATHSEPARATOR;
				Vector<ChannelSftp.LsEntry> fileAndFolderList = channelSftp.ls(path); // Let list of folder content
				for (ChannelSftp.LsEntry item : fileAndFolderList) {
					if(item.getAttrs().isDir() && !(".".equals(item.getFilename()) || "..".equals(item.getFilename()) || item.getFilename().startsWith("backup_"))) {
						System.out.println("트랜잭션아이디 이름 : " + item.getFilename());
						String transactionIdFolderName = item.getFilename();
						String transactionFolderPath = path + transactionIdFolderName+PATHSEPARATOR;;
						//TODO 중복검사 필요
						//TODO 다운받은 파일 DB 등록...
						
						channelSftp.rename(path + transactionIdFolderName,path + "backup_"+ transactionIdFolderName);
					}
				}
		}catch (Exception e) {
			result = false;
			e.printStackTrace();
		}
		return result;
	}		
	public List<String> getInterfaceFolderName(ChannelSftp channelSftp, String sourcePath, String destinationPath) throws SftpException {
		Vector<ChannelSftp.LsEntry> fileAndFolderList = channelSftp.ls(sourcePath); // Let list of folder content
		List<String> interfaceIdFolder = new ArrayList<String>();

		// Iterate through list of folder content
		for (ChannelSftp.LsEntry item : fileAndFolderList) {
			if (!item.getAttrs().isDir()) { // Check if it is a file (not a directory).
			} else if (!(".".equals(item.getFilename()) || "..".equals(item.getFilename()) || item.getFilename().startsWith("backup_"))) {
				interfaceIdFolder.add(item.getFilename());
				
			}
		}
		return interfaceIdFolder;
	}
	
	public boolean download(String dir, String downloadFileName, String path, ChannelSftp channelSftp) throws Exception {

    	boolean result = true;

        InputStream in = null;
        FileOutputStream out = null;

        channelSftp.cd(dir); 
        in = channelSftp.get(downloadFileName);

        out = new FileOutputStream(new File(path));
        int data; 
		byte b[] = new byte[2048];
		
		while((data = in.read(b, 0, 2048)) != -1) { 
			out.write(b, 0, data); 
			out.flush();
		}

        try {
        	
        	
            out.close();
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
}
