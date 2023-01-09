package com.duzon.custom.common.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.common.dao.CommonDAO;
import com.duzon.custom.common.utiles.CtFileUtile;
import com.google.gson.Gson;

import egovframework.com.cmm.util.EgovUserDetailsHelper;

import bizbox.orgchart.service.vo.LoginVO;


@Service
public class CommonServiceImpl implements CommonService {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);
	
	@Autowired
	private CommonDAO commonDAO;
	
	/**
	* YH
	* 2017. 12. 11.
	* 설명: 파일업로드
	*/
	@Override
	public void ctFileUpLoad(Map<String, Object> map, MultipartHttpServletRequest multi) {

		//파일유틸
		CtFileUtile ctFileUtile = new CtFileUtile();
		
		//멀티파트파일 확인
		Map<String, MultipartFile> files = multi.getFileMap();
		
		//파일 업로드시작
		Map<String, Object> result = ctFileUtile.fileUpdate(files.get("file1"));
		
		//TODO 디비 저장 기능 개발 필요
		logger.info((String) result.get("filePath"));
		logger.info((String) result.get("fileNm"));
		
	}


	public Map<String, Object> commonGetEmpInfo (HttpServletRequest servletRequest) throws NoPermissionException {
		 java.util.Map<String, Object> result = new java.util.HashMap<String, Object>( );
		 
//		 LoginVO loginVo = (LoginVO) servletRequest.getSession().getAttribute("loginVO");
		 //곽경훈 수정 꼮 수정!!!!!!!
		 LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 
		 if ( loginVo == null ) {
		  
		  loginVo = new bizbox.orgchart.service.vo.LoginVO( );
		  loginVo.setGroupSeq( "overseaschf" );
		  loginVo.setCompSeq( "1000" );
		  loginVo.setBizSeq( "707010002050" );
		  //loginVo.setOrgnztId( "1110" );
		  loginVo.setOrgnztId( "1327" );
		  //loginVo.setUniqId( "1" );
		  loginVo.setUniqId( "1403" );
		  loginVo.setLangCode( "kr" );
		  loginVo.setUserSe( "ADMIN" );
		  loginVo.setErpEmpCd( "2017051501" );
		  loginVo.setErpCoCd( "3585" );
		  loginVo.setEaType( "eap" );
		  loginVo.setEmail("function7");
		  loginVo.setEmailDomain("admin");
		  loginVo.setId("function7");
		  loginVo.setEmpname("관리자");
		  loginVo.setOrganNm("관리팀");
		  //loginVo.setEmpname("곽경훈");
		  //loginVo.setOrgnztNm("정보기술부");
		  //loginVo.setEmpname("노시영");
		  //loginVo.setOrgnztNm("관리팀");
		  loginVo.setPositionCode("A7"); // 직급
		  loginVo.setPositionNm("6급");
		  loginVo.setClassCode("A8"); // 직책
		  loginVo.setClassNm("주임");
		  loginVo.setDeptname("정보기술부");
		  loginVo.setDept_seq("1327");
		  loginVo.setPasswd("1111");
		 }
		 result.put("organNm", loginVo.getOrganNm()); /*부서 명*/
		 result.put("orgnztNm", loginVo.getOrgnztNm()); /*부서 명*/
		 result.put("empName", loginVo.getEmpname()); /*사원 이름*/
		 result.put( "groupSeq",  loginVo.getGroupSeq()); /* 그룹시퀀스 */
		 result.put( "compSeq",  loginVo.getCompSeq()); /* 회사시퀀스 */
		 result.put( "bizSeq",  loginVo.getBizSeq()); /* 사업장시퀀스 */
		 result.put( "deptSeq",  loginVo.getOrgnztId()); /* 부서시퀀스 */
		 result.put( "empSeq",  loginVo.getUniqId()); /* 사원시퀀스 */
		 result.put( "langCode",  loginVo.getLangCode()); /* 사용언어코드 */
		 result.put( "userSe",  loginVo.getUserSe()); /* 사용자접근권한 */
		 result.put( "erpEmpSeq",  loginVo.getUniqId()); /* ERP사원번호 */
		 result.put( "erpCompSeq", loginVo.getErpCoCd()); /* ERP회사코드 */
		 result.put( "erpDeptSeq", loginVo.getErpDeptCd()); /* ERP부서코드 */
		 result.put( "eaType",  loginVo.getEaType()); /* 연동 전자결재 구분 */
		 result.put( "eaType",  loginVo.getEaType()); /* 연동 전자결재 구분 */
		 result.put( "email",  loginVo.getEmail() + "@" + loginVo.getEmailDomain()); /* 연동 이메일 */
		 result.put( "id",  loginVo.getId()); /* 연동 id*/
		 result.put("positionCode", loginVo.getPositionCode());/*직급 번호*/
		 result.put("positionNm", loginVo.getPositionNm());/*직급 명*/
		 result.put("classCode", loginVo.getClassCode());/*직책 번호*/
		 result.put("classNm", loginVo.getClassNm());/*직책 명*/
		 result.put("deptname", loginVo.getDeptname());//부서 명*/
		 result.put("deptSeq", loginVo.getDept_seq());//부서 명*/
		 result.put("passWd", loginVo.getPassword());
		 
//		 System.out.println("=========================================================> Session Info");
//		 System.out.println( "groupSeq   : " + loginVo.getGroupSeq()); /* 그룹시퀀스 */
//		 System.out.println( "compSeq    : " + loginVo.getCompSeq()); /* 회사시퀀스 */
//		 System.out.println( "bizSeq     : " + loginVo.getBizSeq()); /* 사업장시퀀스 */
//		 System.out.println( "deptSeq    : " + loginVo.getOrgnztId()); /* 부서시퀀스 */
//		 System.out.println( "empSeq     : " + loginVo.getUniqId()); /* 사원시퀀스 */
//		 System.out.println( "langCode   : " + loginVo.getLangCode()); /* 사용언어코드 */
//		 System.out.println( "userSe     : " + loginVo.getUserSe()); /* 사용자접근권한 */
//		 System.out.println( "erpEmpSeq  : " + loginVo.getUniqId()); /* ERP사원번호 */
//		 System.out.println( "erpCompSeq : " + loginVo.getErpCoCd()); /* ERP회사코드 */
//		 System.out.println( "eaType     : " + loginVo.getEaType()); /* 연동 전자결재 구분 */
//		 System.out.println( "eaType     : " + loginVo.getEaType()); /* 연동 전자결재 구분 */
//		 System.out.println( "email      : " + loginVo.getEmail() + "@" + loginVo.getEmailDomain()); /* 연동 이메일 */
//		 System.out.println( "id         : " + loginVo.getId()); /* 연동 id*/
//		 System.out.println( "empName         : " + loginVo.getEmpname()); /*이름*/
//		 System.out.println( "erpEmpName         : " + loginVo.getErpEmpNm()); /*이름*/
		 return result;

	}

	@Override
	public List<Map<String, Object>> getCode(String code, String orderby) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("code", code);
		map.put("orderby", orderby);
		
		return commonDAO.getCode(map);
	}
	
	@Override
	public Map<String, Object> getCodeOne(String groupCode, String code) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("groupCode", groupCode);
		map.put("code", code);
		
		return commonDAO.getCodeOne(map);
	}

	@Override
	public Map<String, Object> getDept(String empSeq) {
		return commonDAO.getDept(empSeq);
	}

	@Override
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
			e.printStackTrace();
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

		response.setHeader("Content-Disposition", dispositionPrefix + "\"" + encodedFilename + "\"");

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
	public Map<String, Object> getEmpName(String empSeq) {
		return commonDAO.getEmpName(empSeq);
	}


	@Override
	public Map<String, Object> getCommNm(String code) {
		return commonDAO.getCommNm(code);
	}


	@Override
	public List<Map<String, Object>> empInformation(Map<String, Object> map) {
		return commonDAO.empInformation(map);
	}


	@Override
	public int empInformationTotal(Map<String, Object> map) {
		return commonDAO.empInformationTotal(map);
	}


	@Override
	public Map<String, Object> getHoliday() {
		return commonDAO.getHoliday();
	}


	@Override
	public List<Map<String, Object>> getAllDept() {
		return commonDAO.getAllDept();
	}


	@Override
	public List<Map<String, Object>> getUpDept(String deptSeq) {
		return commonDAO.getUpDept(deptSeq);
	}


	@Override
	public Map<String, Object> getUserInfo(String targetSeq) {
		return commonDAO.getUserInfo(targetSeq);
	}


	@Override
	public List<Map<String, Object>> getGroupCd(Map<String, Object> map) {
		return commonDAO.getGroupCd(map);
	}
	
	@Override
	public List<Map<String, Object>> selectEmp(Map<String, Object> map) {
		return commonDAO.selectEmp(map);
	}


	@Override
	public List<Map<String, Object>> getDutyPosition(String subKey) {
		return commonDAO.getDutyPosition(subKey);
	}
	
	@Override
	public List<Map<String, Object>> getDeptList(String subKey) {
		return commonDAO.getDeptList(subKey);
	}


	@Override
	public List<Map<String, Object>> getEmpDept(String deptSeq) {
		return commonDAO.getEmpDept(deptSeq);
	}
	
	@Override
	public List<Map<String, Object>> fileList(Map<String, Object> map) {
		return commonDAO.fileList(map);
	}
	
	@Override
	public void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
		String path = "";		
		String fileNm = "";
		String fileExt = "";
		String fileName = "";
		Map<String, Object> result =  commonDAO.fileDown(map);
		
		fileNm = (String) result.get("real_file_name");
		fileExt = (String) result.get("file_extension");
		fileName = fileNm+"."+fileExt;
//		path +=  (String) result.get("file_path") + String.valueOf(result.get("attach_file_id")) + "." + fileExt;
		path +=  (String) result.get("file_path") + String.valueOf(result.get("file_name")) + "." + fileExt; // 저장파일명으로 변경
		
		
		try {
			fileDownLoad(fileName, path, request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public void fileDown2(Map<String, Object> map, HttpServletRequest servletRequest,	HttpServletResponse servletResponse) {
		
		String fileName = String.valueOf(map.get("fileName"));
		String path = String.valueOf(map.get("fileFullPath"));
		
		try {
			fileDownLoad(fileName, path, servletRequest, servletResponse);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


	@Override
	public void fileDelete(Map<String, Object> map) {
		commonDAO.fileDelete(map);
		
	}


	@Override
	public Map<String, Object> getRestFund(String empSeq) {
		return commonDAO.getRestFund(empSeq);
	}


	@Override
	public Map<String, Object> getEmpInfo(String empSeq) {
		return commonDAO.getEmpInfo(empSeq);
	}
	
	@Override
	public Map<String, Object> getEmpInfoByName(Map<String, Object> empInfo) {
		return commonDAO.getEmpInfoByName(empInfo);
	}


	@Override
	public Map<String, Object> getEmpSeq(Map<String, Object> map) {
		return commonDAO.getEmpSeq(map);
		
	}


	@Override
	public Map<String, Object> getFingerBase64(String loginID) {
		return commonDAO.getFingerBase64(loginID);
	}


	@Override
	public Map<String, Object> getSignFile(Map<String, Object> signMap) {
		return commonDAO.getSignFile(signMap);
	}


	@Override
	public Map<String, Object> getCeoSignFile(Map<String, Object> signMap) {
		return commonDAO.getCeoSignFile(signMap);
	}


	@Override
	public Map<String, Object> getCompInfo() {
		return commonDAO.getCompInfo();
	}


	@Override
	public Map<String, Object> getContractDn(String empSeq) {
		return commonDAO.getContractDn(empSeq);
	}


	@Override
	public Map<String, Object> getHeader(String empSeq) {
		return commonDAO.getHeader(empSeq);
	}


	@Override
	public List<Map<String, Object>> getRecordsDept() {
		return commonDAO.getRecordsDept();
	}


	@Override
	public Map<String, Object> getTpfUserInfo(String key) {
		return commonDAO.getTpfUserInfo(key);
	}


	@Override
	public Map<String, Object> getCalendarEmpInfo(String empSeq) {
		return commonDAO.getCalendarEmpInfo(empSeq);
	}


	@Override
	public Map<String, Object> getCalendarDelEmpInfo(String userId) {
		return commonDAO.getCalendarDelEmpInfo(userId);
	}


	@Override
	public Map<String, Object> fileInfo(Map<String, Object> map) {
		return commonDAO.fileInfo(map);
	}

	@Override
	public Map<String, Object> getUserList(Map<String, Object> map) {
		
		map.put("list", commonDAO.getUserList(map));
		
		return map;
	}
	
	@Override
	public Map<String, Object> getDeptList2(Map<String, Object> map) {
		
		map.put("list", commonDAO.getDeptList2(map));
		
		return map;
	}


	@Override
	public Map<String, Object> getProjectList(Map<String, Object> map) {

		map.put("list", commonDAO.getProjectList(map));
		
		return map;
	}
	
	@Override
	public Map<String, Object> getBudgetList(Map<String, Object> map) {
		
		map.put("list", commonDAO.getBudgetList(map));
		
		return map;
	}
	
	public Map<String, Object> getBudgetList2(Map<String, Object> map) {
		
		map.put("list", commonDAO.getBudgetList2(map));
		
		return map;
	}


	@Override
	public Map<String, Object> getErpUserInfo(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
        HashMap<String, String> erpuser = commonDAO.getErpUser(map);
        HashMap<String, String> erpgisu = commonDAO.getErpGISU(map);
        erpuser.putAll(erpgisu);
        
        result.put("erpuser", erpuser);
        result.put("erpgisu", erpgisu);
        
		return result;
	}


	@Override
	public Map<String, Object> getPosition(Map<String, Object> map) {
		
		List<Map<String, Object>> list = commonDAO.getPositionList(map);
		
		map.put("list", list);
		return map;
	}


	@Override
	public void monthlyWorkPlanMake(Map<String, Object> map) {
		commonDAO.monthlyWorkPlanMake(map);
		
	}


	@Override
	public void dailyWorkAgree(Map<String, Object> map) {
		commonDAO.dailyWorkAgree(map);
		
	}


	@SuppressWarnings("unchecked")
	@Override
	public String ctDept(String deptSeq) {
		
		List<Map<String, Object>> list = commonDAO.ctDept();
		
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		
		String[] parentDeptSeq = {};
		
		for (Map<String, Object> map : list) {
			
			if(map.get("dept_seq").equals(deptSeq)){
				parentDeptSeq = ((String) map.get("path")).split("\\|");
				map.put("selected", true);
			}
			
		}

		for (Map<String, Object> map : list) {
			
			for (int i = 0; i < parentDeptSeq.length; i++) {
				if(map.get("dept_seq").equals(parentDeptSeq[i])){
					map.put("expanded", true);
				}
			}
			
		}
		
		//부모
		for (Map<String, Object> vo : list) {
			
			//자식
			for (Map<String, Object> vo2 : list) {
				
				if(vo.get("dept_seq").equals(vo2.get("parent_dept_seq"))){
					List<Map<String, Object>> sub = new ArrayList<Map<String, Object>>();
					
					if(vo.containsKey("items")){
						sub = (List<Map<String, Object>>) vo.get("items");
						sub.add(vo2);
						vo.put("items", sub);
					}else{
						sub.add(vo2);
						vo.put("items", sub);
					}
					
				}
				
			}
			
			if(vo.get("org_type").equals("C")){
				result.add(vo);
			}
			
		}
		
		return new Gson().toJson(result);
	}

	
	@Override
	public void sendSmsByBizTongAgent(String title, String contents, List<String> number) {
				
		Map<String, Object> param = new HashMap<String,Object>();
		//1 : SMS        2: MMS
		param.put("msgType", byteCheck(contents));
		//제목
		param.put("title", title);
		// 내용
		param.put("contents", contents);
		// 수신자 수
		param.put("recvCnt", number.size());
		
		//발신번호 *bill36524 사이트에 사전등록된 번호만 가능*
		param.put("sendNum", "01024724495");
		
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		
		//보내는순서
		int no=1;
		for(String num : number) {
			Map<String, Object> numParam = new HashMap<String,Object>();
			
			numParam.put("no", no);
			numParam.put("number", num);
			
			no++;
			
			list.add(numParam);
		};
		
		commonDAO.setSmsMaster(param);
		commonDAO.setSmsSub(list); 

		
		
		
		
	}
	
	
	/**
     * 바이트를 체크한다. 
     * 
     * @param txt 체크할 text
     * @return 
     */
    public String byteCheck(String txt) {
    	
    	//기준 바이트
    	int standardByte = 80;
    	
    	//Biztong Agent API 
    	// type  
    	// 1 (SMS) :  2 (MMS)
    	
    	String massageType = "2";
    	
    	//중간 공백은 ;로 치환해서 체크하기 위함
    	String testTxt =txt.replaceAll(" ", ";");
    	
        // 바이트 체크 (영문 1, 한글 3, 특문 1)
        int en = 0;
        int ko = 0;
        int etc = 0;
 
        char[] txtChar = testTxt.toCharArray();
        
        for (int j = 0; j < txtChar.length; j++) {
            if (txtChar[j] >= 'A' && txtChar[j] <= 'z') {
                en++;
            } else if (txtChar[j] >= '\uAC00' && txtChar[j] <= '\uD7A3') {
                ko++;
                ko++;
                ko++;
            } else {
                etc++;
            }
        }
 
        int txtByte = en + ko + etc;
        if (txtByte > standardByte) {
        	
        	
            return massageType;
        } else {
        	
        	massageType ="1";
            return massageType;
        }
 
    }


	@Override
	public List<Map<String, Object>> getBankCode() {
		return commonDAO.getBankCode();
	};


	
	
	
	
}
