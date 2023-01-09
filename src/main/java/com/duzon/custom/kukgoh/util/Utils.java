package com.duzon.custom.kukgoh.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Utils {
	public String createInvoiceCSV(List<Map<String, Object>> list, String title, String filepath) {
		String fileName = "";
		try {
			if (directoryConfirmAndMake(filepath)) {
				fileName = filepath + "/" + title + "-data.csv";
				BufferedWriter fw = new BufferedWriter(new FileWriter(fileName, true));

				Map<String, Object> map2 = new HashMap<String, Object>();
				int i = 0;

				fw.write("\"[TABLE_NAME:T_IFR_ETXBL_REQUST_ERP]\"");
				fw.newLine();
				
				for (Map<String, Object> dom : list) {

					if (dom.get("DIV").toString().equals("0") || Integer.parseInt(dom.get("DIV").toString()) == 0) {
						
						for (int j = 0; j < (dom.size() - 1); j++) {
							
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_ETXBL_REQUEST_ERP[j]) + "\"");
							
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					} else {
						
						for (int j = 0; j < (dom.size() - 1); j++) {
							
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_ETXBL_REQUEST_ERP[j]) + "\"");
							
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					}
					fw.newLine();
				}
				fw.flush();
				fw.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fileName;
	}

	
	public String createSendCSV(List<Map<String, Object>> execRequestCsvList, List<Map<String, Object>> execBimokCsvList, List<Map<String, Object>> execBimokDataCsvList,  String title, String filepath) {
		String fileName = "";
		
		try {
			if (directoryConfirmAndMake(filepath)) { // 로컬경로 폴더 없으면 생성 ( 로컬에 csv파일 생성 로직 )
				fileName = filepath + "/" + title + "-data.csv";
				BufferedWriter fw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileName), "EUC-KR"));
				Map<String, Object> map2 = new HashMap<String, Object>();
				int i = 0;
				
				fw.write("\"[TABLE_NAME:T_IFR_EXCUT_REQUST_ERP]\"");
				fw.newLine();
				
				for (Map<String, Object> dom : execRequestCsvList) {

					if (dom.get("DIV").toString().equals("0") || Integer.parseInt(dom.get("DIV").toString()) == 0) {
						
						for (int j = 0; j < (dom.size() - 1); j++) {
							
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_EXCUT_REQUST_ERP[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					} else {
						
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_EXCUT_REQUST_ERP[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					}
					
					fw.newLine();
				}
				
				fw.write("\"[TABLE_NAME:T_IFR_EXCUT_EXPITM_ERP]\"");
				fw.newLine();
				
				for (Map<String, Object> dom : execBimokCsvList) {

					if (dom.get("DIV").toString().equals("0") || Integer.parseInt(dom.get("DIV").toString()) == 0) {
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_EXCUT_EXPRITM_ERP[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					} else {
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_EXCUT_EXPRITM_ERP[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					}
					fw.newLine();
				}		
				
				fw.write("\"[TABLE_NAME:T_IFR_EXCUT_FNRSC_ERP]\"");
				fw.newLine();
				
				for (Map<String, Object> dom : execBimokDataCsvList) {

					if (dom.get("DIV").toString().equals("0") || Integer.parseInt(dom.get("DIV").toString()) == 0) {
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_EXCUT_FNRSC_ERP[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					} else {
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.T_IFR_EXCUT_FNRSC_ERP[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					}
					fw.newLine();
				}				
				
				fw.flush();
				fw.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fileName;
	}
	
	public String createEof(String title, String filepath) {
		String fileName = "";
		try {
			if (directoryConfirmAndMake(filepath)) {
				fileName = filepath + "/" + title + ".eof";
				BufferedWriter fw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileName), "EUC-KR"));

				fw.flush();
				fw.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fileName;
	}

	public boolean directoryConfirmAndMake(String targetDir) {
		boolean result = true;
		File d = new File(targetDir);
		if (!d.isDirectory()) {
			if (!d.mkdirs()) {
				System.out.println("생성 실패");
				result = false;
			}
		}
		return result;
	}

	public Map<String, Object> getTrnscId(String trnscId) {
		Map<String, Object> result = new HashMap<String, Object>();
		String str[] = trnscId.split("_");
		result.put("trnscId", trnscId);
		result.put("intrfcId", str[1]);
		return result;
	}
	public Map<String, Object> getTrnscId2(String trnscId) {
		Map<String, Object> result = new HashMap<String, Object>();
		String str[] = trnscId.split("_");
		result.put("TRNSC_ID", trnscId);
		result.put("INTFC_ID", str[1]);
		return result;
	}
	public String createAttachFile(List<Map<String, Object>> list, String title, String filepath) {
		String fileName = "";
		try {
			if (directoryConfirmAndMake(filepath)) {
				// new File(filepath+"/"+title+"-data.csv");
				fileName = filepath + "/" + title + "-attach.csv";
				BufferedWriter fw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileName), "EUC-KR"));


				Map<String, Object> map2 = new HashMap<String, Object>();
				int i = 0;

				fw.write("\"[TABLE_NAME:T_IF_INTRFC_FILE]\"");
				fw.newLine();
				for (Map<String, Object> dom : list) {

					if (dom.get("DIV").toString().equals("0") || Integer.parseInt(dom.get("DIV").toString()) == 0) {
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.TPF_KUKGOH_ATTACH_SELECT2[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					} else {
						for (int j = 0; j < (dom.size() - 1); j++) {
							fw.write("\"" + (String) dom.get(CSVKeyUtil.TPF_KUKGOH_ATTACH_SELECT2[j]) + "\"");
							if (!(j == (dom.size() - 2))) {
								fw.write(",");
							}
						}
					}
					fw.newLine();
				}
				fw.flush();
				fw.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fileName;
	}
	
	public String makeFileName(String trnscId, String fileNm, String fileExtension) {
		
		return trnscId + "-" + fileNm + "." + fileExtension;
	}

	public String makeFileName(String trnscId, String fileNm) {
		
		return trnscId + "-" + fileNm;
	}	
}
