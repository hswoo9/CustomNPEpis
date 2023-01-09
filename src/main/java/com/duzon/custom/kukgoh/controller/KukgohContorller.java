package com.duzon.custom.kukgoh.controller;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.plaf.synth.SynthSplitPaneUI;

import org.apache.commons.collections.ListUtils;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.ParsingXML;
import com.duzon.custom.kukgoh.service.KukgohService;
import com.duzon.custom.kukgoh.util.HttpClientSample;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ibatis.sqlmap.engine.mapping.result.ResultMap;
import com.jcraft.jsch.SftpException;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class KukgohContorller {
	@Autowired
	KukgohService kukgohService;

	@Autowired
	CommonService commonService;
	
	@Autowired
	ResAlphaG20Service resAlphaG20Service;
/*	
	@Autowired
	AsyncService asyncService;*/
	
	// 파일 위치
	@Value("#{bizboxa['BizboxA.fileRootPath']}")
	private String fileRootPath;
	@Value("#{bizboxa['BizboxA.domain']}")
	private String domain;
	
	@Resource(name = "CommFileDAO")
	CommFileDAO commFileDAO;
	
	private final String boundary =  "*****";
	private static final Logger logger = (Logger) LoggerFactory.getLogger(KukgohContorller.class);
	
	final static String[] INTFCID_LIST = {"IF-EXE-EFS-0192", "IF-EXE-EFS-0196", "IF-EXE-EFS-0242"}; 
	
	@RequestMapping(value = "/kukgoh/commonCodeViewTest")
	public String commonCodeViewTest(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/commonCodeView");

		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassification()));
		//return "/kukgoh/commonCodeView";
		return "/kukgoh/commonCodeViewTest";
	}
	
	@RequestMapping(value = "/kukgoh/commCodeView")
	public String commonCodeView(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/commonCodeView");

		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs()));
		return "/kukgoh/kukgohCommCodeView";
	}	
	
	@RequestMapping(value = "/kukgoh/getMainGrid")
	@ResponseBody
	public Map<String, Object> getMainGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)  {
		logger.info("kukgoh/getMainGrid");
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", kukgohService.getMainGridMs(map)); //리스트
		resultMap.put("total", kukgohService.getMainGridTotalMs(map)); //토탈
		
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/getCommCodeClassificationMs")
	@ResponseBody
	public Map<String, Object> getCommCodeClassificationMs(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/commonCodeView");
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		map.put("EMP_IP", ip);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		//resultMap.put("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs(map)));
		resultMap.put("list", kukgohService.getCommCodeClassificationMs(map));
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs()));
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/kukgohAdmView")
	public String kukgohAdmView(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/kukgohAdmView");

		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs()));
		return "/kukgoh/kukgohAdmView";
	}	
	
	
	@RequestMapping(value = "/kukgoh/saveInterfacePage")
	public String saveInterfacePage(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/saveInterfacePage");

		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		return "/kukgoh/saveInterfacePage";
	}		
	
	@RequestMapping(value = "/kukgoh/getInterfaceGrid")
	@ResponseBody
	public Map<String, Object> getInterfaceGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest)  {
		logger.info("kukgoh/getInterfaceGrid");
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", kukgohService.getInterfaceGrid(map)); //리스트
		
		return resultMap;
	}	

	
	@RequestMapping(value = "/kukgoh/commCodeSave")
	@ResponseBody
	public Map<String, Object> commCodeSave(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException, JsonParseException, JsonMappingException, IOException {
		logger.info("kukgoh/commCodeSave");
		Map<String, Object> resultMap = new HashMap<String, Object>();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		map.put("EMP_IP", ip);
		
		System.out.println(map + "!@#$");
		
		resultMap.put("list", kukgohService.commCodeSaveMs(map)); //리스트
		return resultMap;
	}	
	
	@RequestMapping(value = "/kukgoh/getFileList")
	@ResponseBody
	public Map<String, Object> getFileList(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getAttachFile");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> result = kukgohService.getFileList(map);
		
		resultMap.put("list", result); //리스트
		return resultMap;
	}		


	
	@RequestMapping(value = "/kukgoh/getRemoteFile")
	@ResponseBody
	public  Map<String, Object> getRemoteFile(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/callServlet");
        Map<String, Object> result = new HashMap<String, Object>();
        String resultYn = "true";
		//ParseCSV.readCsv(path, "UTF-8");
        //SFTPUtil.readCsv(path, "EUC-KR");
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		//Map<String, Object> localMap = commonService.getCodeOne("ENARA", "LOCAL_RCV_DIR");
		//Map<String, Object> remoteMap  = commonService.getCodeOne("ENARA", "REMOTE_RCV_DIR");
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
        map.put("EMP_IP", ip);
        //map.put("localDir", localMap.get("code_kr"));
        //map.put("remoteDir", remoteMap.get("code_kr"));
        map.put("CODE_VAL", map.get("param"));
	    try {
	    	long start = System.currentTimeMillis();
	    	kukgohService.getRemoteFile(map);
	    	long end = System.currentTimeMillis();
	    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
		}  catch (Exception e) {
			resultYn = "false";
			e.printStackTrace();
		}
	    result.put("result", resultYn);
		return result;
	}	
	//@Scheduled(cron="0 10 18 * * *")
	public void scheduledCode() throws SftpException, IOException{
    	long start = System.currentTimeMillis();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		String empSeq = "SYSTEM";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("EMP_SEQ", empSeq);
		map.put("EMP_IP", ip);
    	kukgohService.getRemoteFile(map);
    	long end = System.currentTimeMillis();
    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
	}
	
	@RequestMapping(value = "/kukgoh/getBudgetCdGridPop")
	@ResponseBody
	public Map<String, Object> getBudgetCdGridPop(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getBudgetCdGridPop");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getBudgetCdGridPop(map);
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size());
		return resultMap;
	}		
	
	@RequestMapping(value = "/kukgoh/bgtCodeSave")
	@ResponseBody
	public Map<String, Object> bgtCodeSave(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException, JsonParseException, JsonMappingException, IOException {
		logger.info("kukgoh/bgtCodeSave");
		Map<String, Object> resultMap = new HashMap<String, Object>();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		map.put("EMP_IP", ip);
		boolean result = kukgohService.saveBgtConfig(map);
		resultMap.put("result", result ); //리스트
		return resultMap;
	}			
	
	@RequestMapping(value = "/kukgoh/budgetConfigView")
	public String budgetConfigView(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/budgetConfigView");
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs()));
		return "/kukgoh/budgetConfigView";
	}
	
	@RequestMapping(value = "/kukgoh/projectConfigView")
	public String projectConfigView(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/projectConfigView");
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs()));
		return "/kukgoh/projectConfigView";
	}
	
	@RequestMapping(value = "/kukgoh/projectConfigView2")
	public String projectConfigView2(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/projectConfigView2");
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		model.addAttribute("userSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("loginId", loginMap.get("id"));
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("userLoginId", empName.get("emp_name"));
		//model.addAttribute("commCodeClassification",new Gson().toJson(kukgohService.getCommCodeClassificationMs()));
		return "/kukgoh/projectConfigView2";
	}
	
	@RequestMapping(value = "/kukgoh/getProjectMainGrid")
	@ResponseBody
	public Map<String, Object> getProjectMainGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getProjectMainGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getProjectMainGrid(map);
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size() );
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/getProjectCdGridPop")
	@ResponseBody
	public Map<String, Object> getProjectCdGridPop(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getProjectCdGridPop");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getProjectCdGridPop(map);
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size() );
		return resultMap;
	}		
	
	@RequestMapping(value = "/kukgoh/saveProjectConfig")
	@ResponseBody
	public Map<String, Object> saveProjectConfig(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/bgtCodeSave");
		Map<String, Object> resultMap = new HashMap<String, Object>();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        } 
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		System.out.println(map + "!@#$");
		
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		map.put("EMP_IP", ip);
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
		
		resultMap.put("result", kukgohService.saveProjectConfig(map)); //리스트
		return resultMap;
	}			
	
	//지출결의서 등록
	@RequestMapping(value = "/kukgoh/insertSpendingResolution")
	public String insertSpendingResolution(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/projectConfigView");
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		String deptSeq = (String) loginMap.get("deptSeq");
		Map<String, Object> map = new HashMap<String, Object>();
		
		model.addAttribute("requestDeptSeq", deptSeq);
		model.addAttribute("empSeq", empSeq);
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("deptNm", (String) loginMap.get("orgnztNm"));
		model.addAttribute("empName", empName.get("emp_name"));
		model.addAttribute("erpEmpSeq",kukgohService.getErpEmpSeq(loginMap));
		model.addAttribute("erpDeptSeq",kukgohService.getErpDeptSeq(loginMap));
		model.addAttribute("loginMap", loginMap);
		//model.addAttribute("empEmpInfo",map);
		return "/kukgoh/insertSpendingResolution";
	}		
	
	@RequestMapping(value = "/kukgoh/insertResolutionMainGrid")
	@ResponseBody
	public Map<String, Object> insertResolutionMainGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/insertResolutionMainGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.insertResolutionMainGrid(map);
		
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size());
		return resultMap;
	}			
	
	//지출결의서 집행등록 --전송/확인
	@RequestMapping ( value = "/kukgoh/resolutionSubmitPage", method = RequestMethod.POST )
	public String purcContInspList ( @RequestParam Map<String, Object> map, HttpServletRequest request,ModelMap model ) throws Exception {
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> data = mapper.readValue(map.get("submitData").toString(), new TypeReference<Map<String, Object>>(){});
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("evidence", new Gson().toJson( kukgohService.getEvidenceMs()));
		resultMap.put("customerGb",  new Gson().toJson(kukgohService.getCustomerGbMs()));
		resultMap.put("depositGb",  new Gson().toJson(kukgohService.getDepositGbMs()));
		resultMap.put("depositGbCause",  new Gson().toJson(kukgohService.getDepositGbCauseMs()));
		
		System.out.println("!@#$" + data);
		
		model.addAttribute( "params", map );
		model.addAttribute( "data", data );
		model.addAttribute( "resultMap", resultMap );
		model.addAttribute( "empSeq", loginVO.getUniqId());
		return "/kukgoh/resolutionSubmitPage";	
	}
	
	//New 지출결의서 집행등록(일괄) --전송/확인
	@RequestMapping ( value = "/kukgoh/newResolutionSubmitPage", method = RequestMethod.POST )
	public String newResolutionSubmitPage ( @RequestParam Map<String, Object> map, HttpServletRequest request,ModelMap model ) throws Exception {
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> data = mapper.readValue(map.get("submitData").toString(), new TypeReference<Map<String, Object>>(){});
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		
		String flag = (String)data.get("flag");
		
		try {
			if ("S".equals(flag)) { // 전송일 경우
				result = kukgohService.submitPageSending(data);
			} else if ("C".equals(flag)) { // 확인일 경우
				result = kukgohService.submitPageConfirm(data);
			}
			
			String resultJsonStr = mapper.writeValueAsString(result);
			
			resultMap.put("evidence", new Gson().toJson( kukgohService.getEvidenceMs()));
			resultMap.put("customerGb",  new Gson().toJson(kukgohService.getCustomerGbMs()));
			resultMap.put("depositGb",  new Gson().toJson(kukgohService.getDepositGbMs()));
			resultMap.put("depositGbCause",  new Gson().toJson(kukgohService.getDepositGbCauseMs()));
			model.addAttribute("restradeInfo", kukgohService.getRestradeInfo(data));
			model.addAttribute("result", result);
			model.addAttribute("params", map);
			model.addAttribute("data", data);
			model.addAttribute("resultMap", resultMap);
			model.addAttribute("empSeq", loginVO.getUniqId());
			model.addAttribute("resultJsonStr", resultJsonStr);
			model.addAttribute("dataJsonStr", map.get("submitData").toString());
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		
		return "/kukgoh/newResolutionSubmitPage";	
	}
	
	//전자세금계산서 페이지 호출
	@RequestMapping ( value = "/kukgoh/requestInvoicePage")
	public String requestInvoicePage ( @RequestParam Map<String, Object> map, HttpServletRequest request,ModelMap model ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		model.addAttribute( "params", map );
		return "/kukgoh/requestInvoicePage";	
	}
	
	@RequestMapping(value = "/kukgoh/kukgohInvoiceGrid")
	@ResponseBody 
	public Map<String, Object> kukgohInvoiceGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/kukgohInvoiceGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", kukgohService.kukgohInvoiceGrid(map) ); //리스트
		//resultMap.put("total", result.size() );
		return resultMap;
	}		
	
	@RequestMapping(value = "/kukgoh/accountGrid")
	@ResponseBody
	public Map<String, Object> accountGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/accountGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		
		if (map.get("stateYn").equals("N")) {
			result =kukgohService.getUnSendData(map);
		} else if (map.get("stateYn").equals("Y")) {
			result =kukgohService.getSendData(map);
		}
		
		try {
			
			for (Map<String, Object> tmpMap : result) { // 법인 -> 개인 으로 변경 해 주는 작업
				
				logger.info("@@@@@@@@@@@@@@@@@@@@@@");
				logger.info(String.valueOf(tmpMap));
				logger.info("@@@@@@@@@@@@@@@@@@@@@@");
				
				Map<String, Object> stradeMap = kukgohService.changeAccountType(tmpMap);
				
				if (tmpMap.get("BCNC_SE_CODE") != null && stradeMap.get("TR_FG") != null) {
					
					String TR_FG = (String)stradeMap.get("TR_FG");
					
					if (TR_FG.equals("3")) {
						tmpMap.put("BCNC_SE_CODE", "003");
						
						String PPL_NB = String.valueOf(stradeMap.get("PPL_NB"));
						
						if (PPL_NB != null) {
							tmpMap.put("PIN_NO_1", PPL_NB.substring(0, 6));
							tmpMap.put("PIN_NO_2", PPL_NB.substring(6));
						}
					}
				}
			}
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size() );
		return resultMap;
	}			
	
	@RequestMapping(value = "/kukgoh/requestInvoice")
	@ResponseBody
	public Map<String, Object> requestInvoice(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException,  SftpException, IOException {
		logger.info("kukgoh/requestInvoice");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpClientSample client = new HttpClientSample();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        Map<String, Object> tmpMap = new HashMap<String, Object>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		Map<String, Object> urlMap = kukgohService.getUrlInfo();
		String url = (String)urlMap.get("code_kr");
		
        map.put("EMP_IP", ip);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		
		try {
			tmpMap =kukgohService.requestInvoice1(map);
			resultMap =kukgohService.requestInvoice2(tmpMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//세금계산서 전송이 제대로 되었으면.... 실행
		if (map.get("OUT_YN").equals("Y")) {
			Map<String, Object> clientMap = client.setClient("IF-EXE-EFR-0071", resultMap.get("TRNSC_ID").toString(), url);
			
			if (clientMap.get("rspCd").equals("SUCC")) {

			} else {
				
			}
		}
		return resultMap;
	}	

	
	@RequestMapping(value = "/kukgoh/sendInfo")
	@ResponseBody
	public Map<String, Object> sendInfo(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException, SftpException, IOException {
		logger.info("kukgoh/sendInfo");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		HttpClientSample client = new HttpClientSample();
		String erpEmpSeq = kukgohService.getErpEmpSeq(loginMap);
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        Gson gson = new Gson();
		String data = (String) map.get("param");		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		List<Map<String, Object>> listMap = gson.fromJson(data, listType);
		Map<String, Object> urlMap = kukgohService.getUrlInfo();
		
		String url = (String)urlMap.get("code_kr");
		
		try {
			resultMap  = kukgohService.sendInfo(listMap, ip, erpEmpSeq); // G20 서버에 CSV 파일 전송 (로컬[GW서버]에도 생성 )
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		} 
		
		  if(resultMap.get("OUT_YN").equals("Y")) {
			  Map<String, Object> clientMap = client.setClient(resultMap.get("intfcId").toString(), resultMap.get("trnscId").toString().toString(), url);
		  }
		return resultMap;
	}		

	@RequestMapping(value = "/kukgoh/cancelSendInfo")
	@ResponseBody
	public Map<String, Object> cancelSendInfo(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/reSendInfo");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        map.put("EMP_IP", ip);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		resultMap =kukgohService.cancelSendInfo(map);
		
		return resultMap;
	}			
	
	//전자세금계산서 체크
	@RequestMapping(value = "/kukgoh/invoiceValidation")
	@ResponseBody
	public Map<String, Object> invoiceValidation(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws Exception, NoPermissionException {
		logger.info("kukgoh/invoiceValidation");
		kukgohService.invoiceValidation(map);
		return map;
	}		
	
	//집행정보 반영 체크 체크
	@RequestMapping(value = "/kukgoh/saveCheck")
	@ResponseBody
	public Map<String, Object> saveCheck(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws Exception, NoPermissionException {
		logger.info("kukgoh/saveCheck");
		map.put("TRNSC_ID_TIME", System.currentTimeMillis());
		map.put("SUM_AMOUNT", map.get("SUM_AMOUNT").toString().replaceAll(",", ""));
		map.put("SPLPC", map.get("SPLPC").toString().replaceAll(",", ""));
		map.put("VAT", map.get("VAT").toString().replaceAll(",", ""));
		map.put("GISU_DT", map.get("GISU_DT").toString().replaceAll("-", ""));
		map.put("EXCUT_REQUST_DE", map.get("EXCUT_REQUST_DE").toString().replaceAll("-", ""));
		map.put("UNIT_AM", map.get("UNIT_AM").toString().replaceAll(",", ""));
		map.put("MD_DT", map.get("MD_DT").toString().replaceAll("-", ""));
		map.put("EXCUT_VAT", map.get("EXCUT_VAT").toString().replaceAll(",", ""));
		map.put("EXCUT_SUM_AMOUNT", map.get("EXCUT_SUM_AMOUNT").toString().replaceAll(",", ""));
		map.put("EXCUT_SPLPC", map.get("EXCUT_SPLPC").toString().replaceAll(",", ""));
		
		if(map.get("BCNC_SE_CODE").equals("003")) {
			map.put("BCNC_LSFT_NO", map.get("PIN_NO_1").toString() + map.get("PIN_NO_2").toString() + "000000");
		}else {
			map.put("BCNC_LSFT_NO", map.get("BCNC_LSFT_NO").toString().replaceAll("-", ""));
		}
		
		kukgohService.saveCheck(map);
		return map;
	}		

	
	@RequestMapping(value = "/kukgoh/test1234")
	@ResponseBody
	public Map<String, Object> test1234(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/bgtCodeSave");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		resultMap.put("result", empSeq ); //리스트
		return resultMap;
	}			
	@RequestMapping(value = "/kukgoh/transactionTest")
	@ResponseBody
	public Map<String, Object> transactionTest(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws Exception, NoPermissionException {
		logger.info("kukgoh/bgtCodeSave");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		kukgohService.transactionTest(map);
		resultMap.put("result", empSeq ); //리스트
		return resultMap;
	}		
	
	@RequestMapping(value = "/kukgoh/insertAttachFile")
	@ResponseBody
	public Map<String, Object> insertAttachFile(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest) throws Exception, NoPermissionException {
		logger.info("kukgoh/insertAttachFile");
		
		Map<String, Object> filePathMap = resAlphaG20Service.getDocOrg(map);
		
		map.put("enaraFilePath", String.valueOf(filePathMap.get("c_difilepath")));
		
		kukgohService.insertAttachFile(map, multi);
		return map;
	}	
	
	@RequestMapping(value = "/kukgoh/deleteFile")
	@ResponseBody
	public Map<String, Object> deleteFile(@RequestParam Map<String, Object> map,  HttpServletRequest servletRequest) throws Exception, NoPermissionException {
		logger.info("kukgoh/deleteFile");
		
		kukgohService.deleteFile(map);
		map.put("outYn", "Y");
		return map;
	}	
	
	@RequestMapping(value = "/kukgoh/kukgohInvoiceInsertGrid")
	@ResponseBody 
	public Map<String, Object> kukgohInvoiceInsertGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/kukgohInvoiceInsertGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", kukgohService.kukgohInvoiceInsertGrid(map)); //리스트
		//resultMap.put("total", result.size() );
		return resultMap;
	}	
	
	@RequestMapping(value = "/kukgoh/kukgohInvoiceInsertGrid2")
	@ResponseBody 
	public Map<String, Object> kukgohInvoiceInsertGrid2(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/kukgohInvoiceInsertGrid2");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", kukgohService.kukgohInvoiceInsertGrid2(map)); //리스트
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/callInterface")
	@ResponseBody 
	public Map<String, Object> callInterface(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException, SftpException, IOException {
		logger.info("kukgoh/callInterface");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        map.put("EMP_IP", ip);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		
		try {
			resultMap = kukgohService.getRemoteFile2(map); //리스트
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		//resultMap.put("total", result.size() );
		
		return resultMap;
	}			
	@RequestMapping(value = "/kukgoh/fileDownLoad")
	@ResponseBody 
	public void fileDownLoad(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws NoPermissionException, SftpException, IOException {
		logger.info("kukgoh/fileDownLoad");
		kukgohService.fileDown(map, servletRequest, servletResponse);
	}		
	
	
	//관리자 화면
	@RequestMapping(value = "/kukgoh/admResolutionView")
	public String admResolutionView(ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/admResolutionView");
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		String deptSeq = (String) loginMap.get("deptSeq");
		System.out.println(deptSeq + "!@#$");
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> allDept = commonService.getAllDept();
		model.addAttribute("requestDeptSeq", deptSeq);
		model.addAttribute("empSeq", empSeq);
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("deptNm", (String) loginMap.get("orgnztNm"));
		model.addAttribute("empName", empName.get("emp_name"));
		model.addAttribute("erpEmpSeq",kukgohService.getErpEmpSeq(loginMap));
		model.addAttribute("erpDeptSeq",kukgohService.getErpDeptSeq(loginMap));
		model.addAttribute("loginMap", loginMap);
		model.addAttribute("allDept",  new Gson().toJson(allDept));
		//model.addAttribute("empEmpInfo",map);
		return "/kukgoh/admResolutionView";
	}	
	//지출결의서 집행등록 --전송/확인
	@RequestMapping ( value = "/kukgoh/admResolutionSubmitPage" )
	public String admResolutionSubmitPage ( @RequestParam Map<String, Object> map, HttpServletRequest request,ModelMap model ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> data = mapper.readValue(map.get("submitData").toString(), new TypeReference<Map<String, Object>>(){});
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("evidence", new Gson().toJson( kukgohService.getEvidenceMs()));
		resultMap.put("customerGb",  new Gson().toJson(kukgohService.getCustomerGbMs()));
		resultMap.put("depositGb",  new Gson().toJson(kukgohService.getDepositGbMs()));
		resultMap.put("depositGbCause",  new Gson().toJson(kukgohService.getDepositGbCauseMs()));
		model.addAttribute( "data", data );
		model.addAttribute( "params", map );
		model.addAttribute( "resultMap", resultMap );
		model.addAttribute( "empSeq", loginVO.getUniqId());
		return "/kukgoh/admResolutionSubmitPage";	
	}
	
	@RequestMapping(value = "/kukgoh/admResolutionMainGrid")
	@ResponseBody
	public Map<String, Object> admResolutionMainGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/admResolutionMainGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.admResolutionMainGrid(map);
		
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size() );
		return resultMap;
	}			
	
	@RequestMapping(value = "/kukgoh/admSendGrid")
	@ResponseBody
	public Map<String, Object> admSendGrid(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException,  SftpException, IOException {
		logger.info("kukgoh/getAdmResolutionGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = kukgohService.admSendGrid(map);
		resultMap.put("list", list);
		resultMap.put("total", list.size());

		return resultMap;
	}	
	@RequestMapping(value = "/kukgoh/admAccountGrid")
	@ResponseBody
	public Map<String, Object> admAccountGrid(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException,  SftpException, IOException {
		logger.info("kukgoh/getAdmResolutionGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = kukgohService.admAccountGrid(map);
		resultMap.put("list", list);
		return resultMap;
	}		
	
	/**
	 *			열차정보서비스 (공공데이터포털)
	 * 		도시코드, 차량종류, 시/도별 기차역 목록 조회 후 테이블 적재
	 */
	@RequestMapping(value = "/trainInfoService")
	@ResponseBody
	public Map<String, Object> getCtyCodeList() throws Exception {
		logger.info("kukgoh/getCtyCodeList");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String serviceKey = "LOtQxq8GcsF9YAUjvDZAh5DzKOXmF9DUC0ARh07fzZV06PzsNJOO%2BhgjbnJHYM9MpGoDMS6v8IENJxmevcemuQ%3D%3D";
		String getCtyCodeListAddr = "http://openapi.tago.go.kr/openapi/service/TrainInfoService/getCtyCodeList?serviceKey=" + serviceKey;
		String getVhcleKndListAddr = "http://openapi.tago.go.kr/openapi/service/TrainInfoService/getVhcleKndList?serviceKey=" + serviceKey;
		String getCtyAcctoTrainSttnListAddr = "http://openapi.tago.go.kr/openapi/service/TrainInfoService/getCtyAcctoTrainSttnList?serviceKey=" + serviceKey + "&numOfRows=50&pageNo=1&cityCode=";
		
		List<Map<String, Object>> ctyCodeList = ParsingXML.getTrainInfoService(getCtyCodeListAddr); // 도시코드 조회
		List<Map<String, Object>> vhcleKndList = ParsingXML.getTrainInfoService(getVhcleKndListAddr); // 차량종류 조회
		
		try {
			
			kukgohService.deleteKorailInfoAll(); // 테이블 내용 전체 삭제
			
			for (Map<String, Object> map : ctyCodeList) { // 시/도별 기차역 목록 조회
				
				String cityCode = (String)map.get("citycode");
				
				kukgohService.saveKorailCityInfo(map);
				
				List<Map<String, Object>> list = ParsingXML.getTrainInfoService(getCtyAcctoTrainSttnListAddr + map.get("citycode").toString());
				
				for (Map<String, Object> nodeMap : list) {
					
					nodeMap.put("citycode", cityCode);
					System.out.println(nodeMap);
					kukgohService.saveKorailNodeInfo(nodeMap);
				}
			}
			
			for (Map<String, Object> map : vhcleKndList) {
				
				System.out.println(map);
				kukgohService.saveKorailVehicleKind(map);
			}
			
		} catch (Exception e) {
			
		}
		
		return resultMap; 
	}
	
	//관리자 화면
	//새벽5시 일ㄷㅁㄴㅇ
	//내역사업 등
	//@Scheduled(cron="0 10 5 * * *")
	public void run05() throws SftpException, IOException{
    	long start = System.currentTimeMillis();
        String ip = "SYSTEM";
		String empSeq = "SYSTEM";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("EMP_SEQ", empSeq);
		map.put("EMP_IP", ip);
		map.put("CODE_VAL", "5");
    	kukgohService.getRemoteFile(map);
    	long end = System.currentTimeMillis();
    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
	}
	
	// ENARA 연계 모듈 폴더 배치
	@RequestMapping("/kukgoh/sndAgentMsg")
	@ResponseBody
	public void sndAgentMsg() throws Exception, NoPermissionException {
		logger.info("kukgoh/sndAgentMsg!!! Controller");
		
		Map<String, Object> resultMap = kukgohService.watchNewFiles(INTFCID_LIST);
		
		logger.info("resultMap : " + resultMap);
		
		if (resultMap.get("flag").equals("Y")) { // 새로 추가된 파일이 있을 경우
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> resultList = (List<Map<String, Object>>) resultMap.get("resultList");
			
			logger.info(resultList.size() + " 결과 갯수 ");
			
			for (Map<String, Object> map : resultList) {
				
				map.put("EMP_SEQ", "SYSTEM");
				map.put("EMP_IP", "SYSTEM");
				map.put("CODE_VAL", "0");
				map.put("code",(String)map.get("intfcId"));
				
				if(kukgohService.ckeckTrnscIdReadStatus(map) == 0) {
					map.put("status", "Y");
					
					kukgohService.getRemoteFile2(map);
					
					map.put("status", "N");
					kukgohService.ckeckTrnscIdReadStatus(map);
				}
			}
		}
	}
	
	//오후 10시 일배치
	//공통코드 등 TODO
	@Scheduled(cron="0 10 22 * * *")
	@RequestMapping(value="/kukgoh/test2")
	@ResponseBody
	public void run10() throws SftpException, IOException{
		logger.info("kukgoh/run10 - PM 22:10 일배치");
    	long start = System.currentTimeMillis();
        String ip = "SYSTEM";
		String empSeq = "SYSTEM";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("EMP_SEQ", empSeq);
		map.put("EMP_IP", ip);
		map.put("CODE_VAL", "22");
    	kukgohService.getRemoteFile(map);
    	long end = System.currentTimeMillis();
    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
	}
	
	//일배치 매일 18시 TODO
	//집행실적 연계 카드매입내역 결과 등
	@Scheduled(cron="0 10 18 * * *")
	@RequestMapping(value="/kukgoh/test3")
	@ResponseBody
	public void run18() throws SftpException, IOException{
		logger.info("kukgoh/run18 - PM 18:10 일배치");
    	long start = System.currentTimeMillis();
        String ip = "SYSTEM";
		String empSeq = "SYSTEM";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("EMP_SEQ", empSeq);
		map.put("EMP_IP", ip);
		map.put("CODE_VAL", "18");
    	kukgohService.getRemoteFile(map);
    	long end = System.currentTimeMillis();
    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
	}
	
	// ------------------------- 국외소 ---------------------------
	
	@RequestMapping(value = "/kukgoh/getBudgetMainGrid")
	@ResponseBody
	public Map<String, Object> getBudgetMainGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getBudgetMainGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getBudgetMainGrid(map);
		
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size());
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/saveAssntInfo")
	@ResponseBody
	public Map<String, Object> saveAssntInfo(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/saveAssntInfo");
		boolean result = true;
		Map<String, Object> resultMap = new HashMap<String, Object>();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        ObjectMapper mapper = new ObjectMapper();
        
        System.out.println(map.get("data").toString() + "!@#$");
        
        try {
			Map<String, Object> jsonMap = mapper.readValue(map.get("data").toString(), new TypeReference<Map<String, Object>>() {});
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			jsonMap.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
			jsonMap.put("EMP_IP", ip);
			
			result = kukgohService.saveAssntInfo(jsonMap);
			
        } catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
        
		resultMap.put("result", result); //리스트
		
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/getAsstnGridPop")
	@ResponseBody
	public Map<String, Object> getAsstnGridPop(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getAsstnGridPop");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getAsstnGridPop(map);
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size());
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/updateCancelAssntInfo")
	@ResponseBody
	public Map<String, Object> updateCancelAssntInfo(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/updateCancelAssntInfo");
		Map<String, Object> resultMap = new HashMap<String, Object>();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		map.put("EMP_IP", ip);
		
		try {
			kukgohService.updateCancelAssntInfo(map);
		} catch (Exception e) {
			resultMap.put("result", false);
		}
		
		resultMap.put("OUT_YN", map.get("OUT_YN"));
		resultMap.put("OUT_MSG", map.get("OUT_MSG"));
		
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/getCardList")
	@ResponseBody
	public Map<String, Object> getCardList(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getCardList");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getCardList(map);
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size());
		return resultMap;
	}
	
	@RequestMapping(value = "/kukgoh/getCardNoList")
	@ResponseBody
	public Map<String, Object> getCardNoList(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getCardNoList");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		result = kukgohService.getCardNoList(map);
		resultMap.put("list", result ); //리스트
		resultMap.put("total", result.size());
		return resultMap;
	}
	
	@RequestMapping (value = "/kukgoh/cancelProject")
	@ResponseBody
	public Map<String, Object> cancelProject(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/cancelProject");
		Map<String, Object> resultMap = new HashMap<>();
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        } 
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		map.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
		map.put("EMP_IP", ip);
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
		
		kukgohService.cancelProjectConfig(map);
		
		resultMap.put("data", map);
		
		return resultMap;
	}
	
	@RequestMapping (value = "/kukgoh/submitInvoice")
	public String submitInvoice(HttpServletRequest servletRequest,Model model) throws NoPermissionException {
		logger.info("kukgoh/submitInvoice");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);		
		String deptSeq = (String) loginMap.get("deptSeq");
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		model.addAttribute("requestDeptSeq", deptSeq);
		model.addAttribute("empSeq", empSeq);
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("deptNm", (String) loginMap.get("orgnztNm"));
		model.addAttribute("empName", empName.get("emp_name"));
		model.addAttribute("erpEmpSeq",kukgohService.getErpEmpSeq(loginMap));
		model.addAttribute("erpDeptSeq",kukgohService.getErpDeptSeq(loginMap));
		model.addAttribute("loginMap", loginMap);
		model.addAttribute("allDept",  new Gson().toJson(allDept));
		
		return "/kukgoh/submitInvoice";
	}
	
	@RequestMapping (value = "/kukgoh/sendInvoiceMainGrid")
	@ResponseBody
	public Map<String, Object> sendInvoiceMainGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/sendInvoiceMainGrid");
		Map<String, Object> resultMap = new HashMap<>();
		
		map.put("OUT_YN", "");
		map.put("OUT_MSG", "");
		
		List<Map<String, Object>> invoiceList = kukgohService.sendInvoiceMainGrid(map);
		
		resultMap.put("list", invoiceList);
		resultMap.put("total",invoiceList.size());
		
		return resultMap;
	}
	
	@RequestMapping (value = "/kukgoh/saveSendingInvoice")
	@ResponseBody
	public Map<String, Object> saveSendingInvoice(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/sendInvoiceMainGrid");
		Map<String, Object> resultMap = new HashMap<>();
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        } 
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		Map<String, Object> urlMap = kukgohService.getUrlInfo();
		String url = (String)urlMap.get("code_kr");
		
		String empSeq = kukgohService.getErpEmpSeq(loginMap);
		
		Gson gson = new Gson();
		String data = (String) map.get("param");		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		List<Map<String, Object>> listMap = gson.fromJson(data, listType);
		
		try {
			resultMap = kukgohService.saveSendingInvoice(listMap, empSeq, ip, url);
		} catch (Exception e) {
			logger.info("ERROR : ", e);
			resultMap.put("OUT_YN", "N");
			resultMap.put("OUT_MSG", e.getMessage());
		} 
		
		return resultMap;
	}
	
	/**
	 *  지출결의서 집행 전송 New (일괄)
	 */
	@RequestMapping (value = "/kukgoh/sendResolution")
	public String sendResolution(HttpServletRequest servletRequest,Model model) throws NoPermissionException {
		logger.info("kukgoh/sendResolution");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);
		String deptSeq = (String) loginMap.get("deptSeq");
		List<Map<String, Object>> allDept = commonService.getAllDept();
		String erpEmpSeq = kukgohService.getErpEmpSeq(loginMap);
		Map<String, Object> tmpMap = new HashMap<>();
		tmpMap.put("erpEmpSeq", erpEmpSeq);
		
		model.addAttribute("requestDeptSeq", deptSeq);
		model.addAttribute("empSeq", empSeq);
		model.addAttribute("loginSeq", (String) loginMap.get("erpEmpSeq"));
		model.addAttribute("deptNm", (String) loginMap.get("orgnztNm"));
		model.addAttribute("empName", empName.get("emp_name"));
		model.addAttribute("erpEmpSeq",erpEmpSeq);
		model.addAttribute("erpDeptSeq", kukgohService.getErpDeptNo(tmpMap));
		model.addAttribute("loginMap", loginMap);
		model.addAttribute("allDept",  new Gson().toJson(allDept));
		
		return "/kukgoh/sendResolution";
	}
	
	@RequestMapping(value = "/kukgoh/sendResolutionGrid")
	@ResponseBody
	public Map<String, Object> sendResolutionGrid(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/sendResolutionGrid");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
		String erpDeptSeq = "";
		
		if (!String.valueOf(map.get("erpEmpSeq")).equals("")) {
			erpDeptSeq = kukgohService.getErpDeptNo(map);
		} else if (String.valueOf(map.get("erpEmpSeq")).equals("") && String.valueOf(map.get("erpDeptSeq")).equals("")) {
			
		} else {
			map.put("deptSeq", String.valueOf(map.get("erpDeptSeq")));
			Map<String, Object> deptMap = kukgohService.getErpDeptNum(map);
			Map<String, Object> tmpMap = new HashMap<String, Object>();
			tmpMap.put("erpEmpSeq", String.valueOf(deptMap.get("erp_emp_num")));
			erpDeptSeq = kukgohService.getErpDeptNo(tmpMap);
		}
		
		map.put("erpDeptSeq", erpDeptSeq);
		String status = String.valueOf(map.get("status"));
		
		try {
			
			if (status != null) {
				
				if (status.equals("0")) {
					resultList = kukgohService.sendResolutionGrid(map);
				} else if (status.equals("999")) {
					map.put("status", "0");
					List<Map<String, Object>> list1 = kukgohService.sendResolutionGrid(map);
					map.put("status", "2");
					List<Map<String, Object>> list2 = kukgohService.sendResolutionGrid2(map);
					map.put("status", "1");
					List<Map<String, Object>> list3 = kukgohService.sendResolutionGrid2(map);
					
					List<Map<String, Object>> tmp = ListUtils.union(list1, list2);
					resultList = ListUtils.union(tmp, list3);
				} else {
					resultList = kukgohService.sendResolutionGrid2(map);
				}
			}
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		resultMap.put("list", resultList ); //리스트
		resultMap.put("total", resultList.size());
		return resultMap;
	}
	
	/**
	 *		지출결의서 일괄 전송 
	 */
	@RequestMapping(value = "/kukgoh/sendResolutionList")
	@ResponseBody
	public Map<String, Object> sendResolutionList(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/sendResolutionList");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		HttpClientSample client = new HttpClientSample();
		String erpEmpSeq = kukgohService.getErpEmpSeq(loginMap);
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) paramMap.get("param");		
		List<Map<String, Object>> resolutionList = gson.fromJson(jsonData, listType);
		Map<String, Object> urlMap = kukgohService.getUrlInfo();
		
		String url = (String)urlMap.get("code_kr");
		
		try {
			resultMap  = kukgohService.sendInfo(resolutionList, ip, erpEmpSeq);
			
			if(resultMap.get("YN").equals("Y")) {
				
				Map<String, Object> clientMap = client.setClient(resultMap.get("intfcId").toString(), resultMap.get("trnscId").toString().toString(), url);
				
				logger.info("SEND ENARA RESULT : " + clientMap.get("rspCd"));
				
			}else {
				logger.info(" === SEND ENARA RESULT : N값으로 FAIL === ");
			}
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 *
	 *  G20 - DBO.FN_GET_PJT_NM('번호', '회사 코드', '프로젝트 코드') 함수 select 가능 번호
	 *
	 *	 	1 프로젝트명
	 *		2 관리계좌
	 *		3 관리계좌은행명
	 *		4 관리계좌은행코드
	 *		5 관리계좌은행코드(e나라도움기준)
	 *
	 */
	@RequestMapping(value = "/kukgoh/getPjtInfo")
	@ResponseBody
	public Map<String, Object> getPjtInfo(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/getPjtInfo");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = kukgohService.getPjtInfo(map);
		
		System.out.println("!@#$" + resultMap);
		
		return resultMap;
	}
	
	/**
	 * 
		 * @MethodName : getEnaraAttaches
		 * @author : jy
		 * @since : 2020. 5. 20.
		 * 설명 : 문서 첨부파일 -> 이나라 첨부파일로 자동 매핑
	 */
	@RequestMapping("/kukgoh/getEnaraAttaches")
	@ResponseBody
	public Map<String, Object> getEnaraAttaches ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/getEnaraAttaches");
		Map<String, Object> resultMap = new HashMap<>();
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> data = mapper.readValue(requestMap.get("data").toString(), new TypeReference<Map<String, Object>>(){});
		
		try {
			
			kukgohService.getEnaraAttaches(data);
			
			resultMap.put("flag", "SUCC");
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
			resultMap.put("flag", "FAIL");
		}
		
		return resultMap;
	}
	
	@RequestMapping("/kukgoh/getErpDeptNum")
	@ResponseBody
	public Map<String, Object> getErpDeptNum ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/getErpDeptNum");
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			Map<String, Object> map = kukgohService.getErpDeptNum(requestMap);
			
			if (map == null) {
				resultMap.put("erpDeptSeq", "");
			} else {
				requestMap.put("erpEmpSeq", String.valueOf(map.get("erp_emp_num")));
				
				resultMap.put("erpDeptSeq", kukgohService.getErpDeptNo(requestMap));
			}
			
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
	}
	
	@RequestMapping("/kukgoh/exceptEnaraDoc")
	@ResponseBody
	public Map<String, Object> exceptEnaraDoc ( @RequestParam HashMap<String, Object> map, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/exceptEnaraDoc");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
        HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) map.get("param");		
		List<Map<String, Object>> resolutionList = gson.fromJson(jsonData, listType);
        
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(request);
		
		try {
			
			for (Map<String, Object> map2 : resolutionList) {
				map2.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
				map2.put("EMP_IP", ip);
				map2.put("OUT_YN", "");
				map2.put("OUT_MSG", "");
				
				kukgohService.exceptEnaraDoc(map2);
				
				resultMap = map2;
			}
		} catch (Exception e) {
			logger.info("exceptEnaraDoc ERROR : ", e);
		}
		
		return resultMap;
	}
	
	@RequestMapping("/kukgoh/getBankcode")
	@ResponseBody
	public Map<String, Object> getBankcode ( @RequestParam HashMap<String, Object> map, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/getBankcode");
		
        Map<String, Object> resultMap = null;
        
		try {
			resultMap = kukgohService.getBankcode(map);
		} catch (Exception e) {
			logger.info("getBankcode ERROR : ", e);
		}
		
		return resultMap;
	}
	
	@RequestMapping("/kukgoh/reloadEnaraExceptDoc")
	@ResponseBody
	public Map<String, Object> reloadEnaraExceptDoc ( @RequestParam HashMap<String, Object> map, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/reloadEnaraExceptDoc");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) map.get("param");		
		List<Map<String, Object>> exceptList = gson.fromJson(jsonData, listType);
		
		try {
			
			for (Map<String, Object> param : exceptList) {
				
				param.put("OUT_YN", "");
				param.put("OUT_MSG", "");
				
				kukgohService.reloadEnaraExceptDoc(param);
			}
		} catch (Exception e) {
			logger.info("reloadEnaraExceptDoc ERROR : ", e);
		}
		
		return map;
	}
	
	@RequestMapping("/kukgoh/selectEnaraExceptList")
	@ResponseBody
	public Map<String, Object> selectEnaraExceptList ( @RequestParam HashMap<String, Object> map, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/selectEnaraExceptList");
		
        Map<String, Object> resultMap = new HashMap<>();
        List<Map<String, Object>> list = new ArrayList<>();
        
		try {
			list = kukgohService.selectEnaraExceptList(map);
			
			resultMap.put("list", list ); //리스트
			resultMap.put("total", list.size());
		} catch (Exception e) {
			logger.info("selectEnaraExceptList ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 *  지출결의서 집행 전송 New (일괄)
	 */
	@RequestMapping (value = "/kukgoh/enaraExceptList")
	public String enaraExceptList(HttpServletRequest servletRequest,Model model) throws NoPermissionException {
		logger.info("kukgoh/enaraExceptList");
		
		return "/kukgoh/EnaraExceptList";
	}
	
	@RequestMapping(value = "/kukgoh/cancelAllSendInfo")
	@ResponseBody
	public Map<String, Object> cancelAllSendInfo(@RequestParam Map<String, Object> map, ModelMap model, HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("kukgoh/reSendInfo");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		String empSeq = (String) loginMap.get("erpEmpSeq");
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        Gson gson = new Gson();
		String data = (String) map.get("param");		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		List<Map<String, Object>> listMap = gson.fromJson(data, listType);
        
		for (Map<String, Object> paramMap : listMap) {
			paramMap.put("EMP_IP", ip);
			paramMap.put("EMP_SEQ", kukgohService.getErpEmpSeq(loginMap));
			
			resultMap =kukgohService.cancelSendInfo(paramMap);
		}
		
		
		return resultMap;
	}
	
}


