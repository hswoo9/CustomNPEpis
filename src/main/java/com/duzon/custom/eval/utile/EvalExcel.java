package com.duzon.custom.eval.utile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class EvalExcel{
	
	private static Connection conn = null;
	private static PreparedStatement pstmt = null;
	private static PreparedStatement pstmt2 = null;
	private static PreparedStatement pstmt3 = null;
	private static PreparedStatement pstmt4 = null;
	private static ResultSet rs = null;
	private static ResultSet rs2 = null;
	
	private static int cnt = 283;
	
	public static void main(String[] args) throws IOException {
		
		for (int i = 2; i < 29; i++) {
			excelUpload(i);
		}
		
	}
	
	
	private static void excelUpload(int ss) throws IOException{
		
		XSSFRow row; //로우값
		XSSFCell biz_type_array; //분야
		XSSFCell biz_type_detail; //세부타입
		XSSFCell major; //전공
		XSSFCell name; //이름
		XSSFCell gender; //성별
		XSSFCell degree; //학위
		XSSFCell org_name; //기관명(주소)
		XSSFCell org_dept; //부서
		XSSFCell org_rank; //직급
		XSSFCell tel; //유선전화
		XSSFCell mobile; //전화번호
		XSSFCell email; //이메일
		
		File file = new File("C:/Users/user/Desktop/21년 농정원 용역 및 공모사업 제안서 평가위원단 후보명부_시스템등록(210202) - 복사본.xlsx");
		
		FileInputStream inputStream = new FileInputStream(file);
		XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
		XSSFSheet sheet = workbook.getSheetAt(ss); //첫번째 시트
		int rows = sheet.getPhysicalNumberOfRows();
		
		
		try {
			conn = DriverManager.getConnection("jdbc:mysql://10.10.10.199:13306/cust_epis", "neos", "neos");
			
//			String select = "SELECT max(commissioner_pool_seq)+1 as cnt FROM cust_epis.dj_commissioner_pool";
			
			//번호, 이름, 성별
			String sql = "insert into dj_commissioner_pool(commissioner_pool_seq, name, gender, active) value(?,?,?,'Y')";

			//번호, 주소, 기관명, 부서, 직급, 유선전화, 휴대폰, 이메일, 세부타입 
			String sql2 = "insert into dj_commissioner_detail(commissioner_pool_seq, org_addr1, org_name, org_dept, org_rank, tel, mobile, email, biz_detail_type)values(?,?,?,?,?,?,?,?,?)";

			//번호, 분야
			String sql3 = "insert into dj_commissioner_biz_type(commissioner_pool_seq, biz_type_array, active)values(?,?,'Y')";
			
			System.out.println(sql);
			
			pstmt = conn.prepareStatement(sql);
			pstmt2 = conn.prepareStatement(sql2);
			pstmt3 = conn.prepareStatement(sql3);
			
//			pstmt4 = conn.prepareStatement(select);
			
//			rs = pstmt4.executeQuery();
			
//			while(rs.next()){
//				
//				cnt = rs.getInt(1);
//				
//			}
			
			for (int i = 3; i < rows; i++) {
				
				try {
					
					row = sheet.getRow(i);
					
					biz_type_array = row.getCell(1);
					biz_type_detail = row.getCell(2);
					major = row.getCell(3);
					name = row.getCell(4);
					gender = row.getCell(5);
					degree = row.getCell(6);
					org_name = row.getCell(7);
					org_dept = row.getCell(8);
					org_rank = row.getCell(9);
					tel = row.getCell(10);
					mobile = row.getCell(11);
					email = row.getCell(12);
					
				System.out.println(getCellString(name));
				//번호, 이름, 성별
				pstmt.setInt(1, cnt);
				pstmt.setString(2, getCellString(name));
				pstmt.setString(3, getCellString(gender));
				
				pstmt.executeUpdate();
				pstmt.clearParameters();
				
				//번호, 주소, 기관명, 부서, 직급, 유선전화, 휴대폰, 이메일, 세부타입 
				pstmt2.setInt(1, cnt);
				pstmt2.setString(2, getCellString(org_name));
				pstmt2.setString(3, getCellString(org_name));
				pstmt2.setString(4, getCellString(org_dept));
				pstmt2.setString(5, getCellString(org_rank));
				pstmt2.setString(6, getCellString(tel));
				pstmt2.setString(7, getCellString(mobile));
				pstmt2.setString(8, getCellString(email));
				pstmt2.setString(9, getCellString(biz_type_detail));
				
				pstmt2.executeUpdate();
				pstmt2.clearParameters();
				
				//번호, 분야
				pstmt3.setInt(1, cnt);
				pstmt3.setString(2, getCellString(biz_type_array));
				
				pstmt3.executeUpdate();
				pstmt3.clearParameters();
				
				cnt++;
//				
				} catch (Exception e) {
//					
					continue;
//					
				}
				
			}
		
		
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			try {
				 pstmt.close();
				 pstmt2.close();
				 pstmt3.close();
				 conn.close();
				 
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		
		
	}
	
	/**
	 * 2020. 2. 23.
	 * yh
	 * :숫자컨버터
	 */
	public static String getCellString(XSSFCell cell) {
		
		String txt = "";
		
		try {
			if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
				
				txt = cell.getStringCellValue();
				
			}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
				
				txt = String.valueOf( Math.round(cell.getNumericCellValue()) );
				
			}
		} catch (Exception e) {
	
		}
		
		return txt;
	}

}
