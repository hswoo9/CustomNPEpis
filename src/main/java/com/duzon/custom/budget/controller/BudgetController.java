package com.duzon.custom.budget.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLDecoder;
import java.nio.channels.FileChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

import javax.annotation.Resource;
import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
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

import com.duzon.custom.budget.service.BudgetService;
import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.kukgoh.service.KukgohService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.jcraft.jsch.SftpException;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import net.sf.jxls.transformer.XLSTransformer;

/**
 * 
 * @title 예실대비 콘트롤러
 * @author 이철중
 * @since 2018. 05. 25
 * @version 1.0
 * @dscription
 *
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용
 * -----------  -------  --------------------------------
 * 2018. 05. 25   이철중         최초 생성
 *
 */

@Controller
@EnableScheduling
public class BudgetController {

	@Autowired
	private CommonService commonService;
	@Autowired
	private BudgetService budgetService;
	@Autowired
	AcCommonService acCommonService;
	@Autowired
	KukgohService kukgohService;
	
	private ConnectionVO conVo = new ConnectionVO();
	
	private static final Logger logger = (Logger) LoggerFactory.getLogger(BudgetController.class);
	
	/**
	 * 예산 목록
	 */
	@RequestMapping(value = "/budget/budgetList", method = RequestMethod.GET)
	public String budgetList
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("budgetList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		String deptSeq = loginVO.getOrgnztId();
		String deptNm  = loginVO.getOrgnztNm();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도
		if (map.get("reqYear") != null && "".equals(map.get("reqYear"))) {
			reqYear = (String) map.get("reqYear");
		}
		
		model.addAttribute("reqYear", reqYear);
		model.addAttribute("deptSeq", deptSeq);
		model.addAttribute("deptNm",  deptNm);
		
		return "/budget/budgetList";
		
	}
	
	/**
	 * 예실대비 목록
	 */
	@RequestMapping(value = "/budget/execBudgetList", method = RequestMethod.GET)
	public String execBudgetList
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("execBudgetList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		String deptSeq = loginVO.getOrgnztId();
		String deptNm  = loginVO.getOrgnztNm();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도
		if (map.get("reqYear") != null && "".equals(map.get("reqYear"))) {
			reqYear = (String) map.get("reqYear");
		}
		
		model.addAttribute("reqYear", reqYear);
		model.addAttribute("deptSeq", deptSeq);
		model.addAttribute("deptNm",  deptNm);
		
		return "/budget/execBudgetList";
		
	}
	
	/**
	 * 하위사업, 부서 매핑 목록
	 */
	@RequestMapping(value = "/budget/mapBgtDept", method = RequestMethod.GET)
	public String mapBgtDept
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("mapBgtDept");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		String deptSeq = loginVO.getOrgnztId();
		String deptNm  = loginVO.getOrgnztNm();
		
		model.addAttribute("deptSeq", deptSeq);
		model.addAttribute("deptNm",  deptNm);
		
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",  loginVO.getErpCoCd());
		
		List<Map<String, Object>> bgtDeptMap = budgetService.mapPjtBtmList(conVo, paraMap);
		List<Map<String, Object>> resultMap = new ArrayList<Map<String, Object>>();
		
		for (int i = 0; i < bgtDeptMap.size(); i++) {
			Map<String, Object> bgtDeptMapInfo = bgtDeptMap.get(i);
			Map<String, Object> btmDeptInfo = budgetService.getBtmDeptInfo(bgtDeptMapInfo);
			
			// 프로젝트, 하위사업에 매핑된 부서코드가 있다면 적용
			if (btmDeptInfo != null && btmDeptInfo.size() > 0) {
				bgtDeptMapInfo.put("deptSeq", btmDeptInfo.get("deptSeq"));
			}
			
			resultMap.add(bgtDeptMapInfo);
		}
		
		model.addAttribute("mainList", resultMap);
		
		List<Map<String, Object>> allDept = commonService.getAllDept();
		model.addAttribute("allDept", allDept);
		
		return "/budget/mapBgtDept";
		
	}
	
	/**
	 * 하위사업, 부서 매핑
	 */
	@RequestMapping(value = "/budget/saveDept")
	@ResponseBody
	public Map<String, Object> saveDept
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("saveDept");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("deptSeq", map.get("deptSeq"));
		paraMap.put("empSeq",  loginVO.getUniqId());
		
		budgetService.saveDept(paraMap);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", "OK");
		
		return result;
		
	}
	
	/**
	 * 부서 사용자 검색
	 */
	@RequestMapping(value = "/budget/pop/cmmOrgPop", method = RequestMethod.POST)
	public String cmmOrgPop(Model model) {
		
		logger.info("cmmOrgPop");
		return "/budget/pop/cmmOrgPop";
		
	}
	
	@RequestMapping(value = "/budget/getDivList")
	@ResponseBody
	public Map<String, Object> getDivList(@RequestParam Map<String, Object> map) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		String currDate = dateFormat.format(date);
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd", loginVO.getErpCoCd());
		paraMap.put("currDate", currDate);
		
		List<Map<String, Object>> divMap = budgetService.getErpDivList(conVo, paraMap);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("divList", divMap);
		
		return result;
		
	}
	
	@RequestMapping(value = "/budget/getPjtList")
	@ResponseBody
	public Map<String, Object> getPjtList(@RequestParam Map<String, Object> map) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",  loginVO.getErpCoCd());
		paraMap.put("empCd", loginVO.getErpEmpCd());
		
		List<Map<String, Object>> pjtMap = budgetService.getErpPjtList(conVo, paraMap);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("pjtList", pjtMap);
		
		return result;
		
	}
	
	@RequestMapping(value = "/budget/getBudgetDataList")
	@ResponseBody
	public Map<String, Object> getBudgetDataList(@RequestParam Map<String, Object> map) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   map.get("divCd"));
		paraMap.put("deptSeq", map.get("deptSeq"));
		paraMap.put("ymFrom",  map.get("reqYear") + "01");
		paraMap.put("ymTo",    map.get("reqYear") + "12");
		paraMap.put("pjtCd",   map.get("pjtCd"));
		paraMap.put("btmCd",   map.get("btmCd"));
		
		List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> budgetTmp = budgetService.getBudgetDataList(conVo, paraMap);
		
		String bottomCd = "";
		String bottomNm = "";
		
		String pjtCd = "";
		String pjtNm = "";
		
		String divCd = "";
		String divNm = "";
		
		BigDecimal bottomPrc1 = new BigDecimal(0);
		BigDecimal bottomPrc2 = new BigDecimal(0);
		BigDecimal bottomPrc3 = new BigDecimal(0);
		
		BigDecimal pjtPrc1 = new BigDecimal(0);
		BigDecimal pjtPrc2 = new BigDecimal(0);
		BigDecimal pjtPrc3 = new BigDecimal(0);
		
		BigDecimal divPrc1 = new BigDecimal(0);
		BigDecimal divPrc2 = new BigDecimal(0);
		BigDecimal divPrc3 = new BigDecimal(0);
		
		BigDecimal totPrc1 = new BigDecimal(0);
		BigDecimal totPrc2 = new BigDecimal(0);
		BigDecimal totPrc3 = new BigDecimal(0);
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
			if (budgetInfo.get("BGT_NM1") == null || "".equals(budgetInfo.get("BGT_NM1"))) {
				continue;
			}
			
			// 첫번째 레코드는 무조건 합계변수에 합산
			if (i == 0) {
				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(bottomPrc1);
				bottomPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(bottomPrc2);
				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
				
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
				
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
			}
			
			// 하위사업 코드가 같을때까지 합산
			if (bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(bottomPrc1);
				bottomPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(bottomPrc2);
				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
			}
			
			// 하위사업 코드가 틀려지면 소계 필드 추가
			if (!bottomCd.equals("") && !bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    "");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    "");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", bottomNm + " 소계");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM1",   bottomPrc1);
				budgetInfoTmp.put("BGT_AM2",   bottomPrc2);
				budgetInfoTmp.put("APPLY_AM2", bottomPrc3);
				
				budgetMap.add(budgetInfoTmp);
				
				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM1");
				bottomPrc2 = (BigDecimal) budgetInfo.get("BGT_AM2");
				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			
			// 하위사업 코드가 같을때까지 합산
			if (pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
			}
			
			// 프로젝트 코드가 틀려지면 소계 필드 추가
			if (!pjtCd.equals("") && !pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
				
				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    "");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM1",   pjtPrc1);
				budgetInfoTmp.put("BGT_AM2",   pjtPrc2);
				budgetInfoTmp.put("APPLY_AM2", pjtPrc3);
				
				budgetMap.add(budgetInfoTmp);
				
				pjtPrc1 = (BigDecimal) budgetInfo.get("BGT_AM1");
				pjtPrc2 = (BigDecimal) budgetInfo.get("BGT_AM2");
				pjtPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			
			// 회계단위 코드가 같을때까지 합산
			if (divCd.equals(budgetInfo.get("DIV_CD"))) {
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
			}
			
			// 회계단위 코드가 틀려지면 소계 필드 추가
			if (!divCd.equals("") && !divCd.equals(budgetInfo.get("DIV_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    "");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM1",   divPrc1);
				budgetInfoTmp.put("BGT_AM2",   divPrc2);
				budgetInfoTmp.put("APPLY_AM2", divPrc3);
				
				budgetMap.add(budgetInfoTmp);
				
				divPrc1 = (BigDecimal) budgetInfo.get("BGT_AM1");
				divPrc2 = (BigDecimal) budgetInfo.get("BGT_AM2");
				divPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			
			budgetMap.add(budgetInfo);
			
			bottomCd = (String) budgetInfo.get("BOTTOM_CD");
			bottomNm = (String) budgetInfo.get("BOTTOM_NM");
			
			pjtCd = (String) budgetInfo.get("MGT_CD");
			pjtNm = (String) budgetInfo.get("MGT_NM");
			
			divCd = (String) budgetInfo.get("DIV_CD");
			divNm = (String) budgetInfo.get("DIV_NM");

			totPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(totPrc1);
			totPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(totPrc2);
			totPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(totPrc3);
		}
		
		// 하위사업 마지막 소계
		Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    "");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    "");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", bottomNm + " 소계");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   bottomPrc1);
		budgetInfoTmp.put("BGT_AM2",   bottomPrc2);
		budgetInfoTmp.put("APPLY_AM2", bottomPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		// 프로젝트 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();
		
		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    "");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", "");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   pjtPrc1);
		budgetInfoTmp.put("BGT_AM2",   pjtPrc2);
		budgetInfoTmp.put("APPLY_AM2", pjtPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		// 회계단위 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    "");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", "");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   divPrc1);
		budgetInfoTmp.put("BGT_AM2",   divPrc2);
		budgetInfoTmp.put("APPLY_AM2", divPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		// 총합계 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    "");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    "");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", "");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "합계");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   totPrc1);
		budgetInfoTmp.put("BGT_AM2",   totPrc2);
		budgetInfoTmp.put("APPLY_AM2", totPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("mainList", budgetMap);
		
		return result;
		
	}
	
	@RequestMapping(value = "/budget/getBudgetDataListExcel")
	public String getBudgetDataListExcel
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   map.get("divCdE"));
		paraMap.put("deptSeq", map.get("deptSeqE"));
		paraMap.put("ymFrom",  map.get("reqYearE") + "01");
		paraMap.put("ymTo",    map.get("reqYearE") + "12");
		paraMap.put("pjtCd",   map.get("pjtCdE"));
		paraMap.put("btmCd",   map.get("btmCdE"));
		
		List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> budgetTmp = budgetService.getBudgetDataList(conVo, paraMap);
		
		String bottomCd = "";
		String bottomNm = "";
		
		String pjtCd = "";
		String pjtNm = "";
		
		String divCd = "";
		String divNm = "";
		
		BigDecimal bottomPrc1 = new BigDecimal(0);
		BigDecimal bottomPrc2 = new BigDecimal(0);
		BigDecimal bottomPrc3 = new BigDecimal(0);
		
		BigDecimal pjtPrc1 = new BigDecimal(0);
		BigDecimal pjtPrc2 = new BigDecimal(0);
		BigDecimal pjtPrc3 = new BigDecimal(0);
		
		BigDecimal divPrc1 = new BigDecimal(0);
		BigDecimal divPrc2 = new BigDecimal(0);
		BigDecimal divPrc3 = new BigDecimal(0);
		
		BigDecimal totPrc1 = new BigDecimal(0);
		BigDecimal totPrc2 = new BigDecimal(0);
		BigDecimal totPrc3 = new BigDecimal(0);
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
			if (budgetInfo.get("BGT_NM1") == null || "".equals(budgetInfo.get("BGT_NM1"))) {
				continue;
			}
			
			// 첫번째 레코드는 무조건 합계변수에 합산
			if (i == 0) {
				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(bottomPrc1);
				bottomPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(bottomPrc2);
				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
				
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
				
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
			}
			
			// 하위사업 코드가 같을때까지 합산
			if (bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(bottomPrc1);
				bottomPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(bottomPrc2);
				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
			}
			
			// 하위사업 코드가 틀려지면 소계 필드 추가
			if (!bottomCd.equals("") && !bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    "");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    "");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", bottomNm + " 소계");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM1",   bottomPrc1);
				budgetInfoTmp.put("BGT_AM2",   bottomPrc2);
				budgetInfoTmp.put("APPLY_AM2", bottomPrc3);
				
				budgetMap.add(budgetInfoTmp);
				
				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM1");
				bottomPrc2 = (BigDecimal) budgetInfo.get("BGT_AM2");
				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			
			// 하위사업 코드가 같을때까지 합산
			if (pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
			}
			
			// 프로젝트 코드가 틀려지면 소계 필드 추가
			if (!pjtCd.equals("") && !pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
				
				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    "");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM1",   pjtPrc1);
				budgetInfoTmp.put("BGT_AM2",   pjtPrc2);
				budgetInfoTmp.put("APPLY_AM2", pjtPrc3);
				
				budgetMap.add(budgetInfoTmp);
				
				pjtPrc1 = (BigDecimal) budgetInfo.get("BGT_AM1");
				pjtPrc2 = (BigDecimal) budgetInfo.get("BGT_AM2");
				pjtPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			
			// 회계단위 코드가 같을때까지 합산
			if (divCd.equals(budgetInfo.get("DIV_CD"))) {
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
			}
			
			// 회계단위 코드가 틀려지면 소계 필드 추가
			if (!divCd.equals("") && !divCd.equals(budgetInfo.get("DIV_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    "");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM1",   divPrc1);
				budgetInfoTmp.put("BGT_AM2",   divPrc2);
				budgetInfoTmp.put("APPLY_AM2", divPrc3);
				
				budgetMap.add(budgetInfoTmp);
				
				divPrc1 = (BigDecimal) budgetInfo.get("BGT_AM1");
				divPrc2 = (BigDecimal) budgetInfo.get("BGT_AM2");
				divPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			
			budgetMap.add(budgetInfo);
			
			bottomCd = (String) budgetInfo.get("BOTTOM_CD");
			bottomNm = (String) budgetInfo.get("BOTTOM_NM");
			
			pjtCd = (String) budgetInfo.get("MGT_CD");
			pjtNm = (String) budgetInfo.get("MGT_NM");
			
			divCd = (String) budgetInfo.get("DIV_CD");
			divNm = (String) budgetInfo.get("DIV_NM");

			totPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM1")).add(totPrc1);
			totPrc2 = ((BigDecimal) budgetInfo.get("BGT_AM2")).add(totPrc2);
			totPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(totPrc3);
		}
		
		// 하위사업 마지막 소계
		Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    "");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    "");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", bottomNm + " 소계");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   bottomPrc1);
		budgetInfoTmp.put("BGT_AM2",   bottomPrc2);
		budgetInfoTmp.put("APPLY_AM2", bottomPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		// 프로젝트 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();
		
		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    "");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", "");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   pjtPrc1);
		budgetInfoTmp.put("BGT_AM2",   pjtPrc2);
		budgetInfoTmp.put("APPLY_AM2", pjtPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		// 회계단위 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    "");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", "");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   divPrc1);
		budgetInfoTmp.put("BGT_AM2",   divPrc2);
		budgetInfoTmp.put("APPLY_AM2", divPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		// 총합계 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",     "");
		budgetInfoTmp.put("BGT_YM",    "");
		budgetInfoTmp.put("DIV_CD",    "");
		budgetInfoTmp.put("DIV_NM",    "");
		budgetInfoTmp.put("MGT_CD",    "");
		budgetInfoTmp.put("MGT_NM",    "");
		budgetInfoTmp.put("BOTTOM_CD", "");
		budgetInfoTmp.put("BOTTOM_NM", "");
		budgetInfoTmp.put("BGT_CD",    "");
		budgetInfoTmp.put("BGT_NM",    "");
		budgetInfoTmp.put("BGT_NM1",   "합계");
		budgetInfoTmp.put("BGT_NM2",   "");
		budgetInfoTmp.put("BGT_NM3",   "");
		budgetInfoTmp.put("BGT_AM1",   totPrc1);
		budgetInfoTmp.put("BGT_AM2",   totPrc2);
		budgetInfoTmp.put("APPLY_AM2", totPrc3);
		
		budgetMap.add(budgetInfoTmp);
		
		model.addAttribute("mainList", budgetMap);
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename=BudgetStatus.xls");
		
		return "/budget/budgetListExcel";
		
	}
	
	@RequestMapping(value = "/budget/execBudgetDataList")
	@ResponseBody
	public Map<String, Object> execBudgetDataList(@RequestParam Map<String, Object> map) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   map.get("divCd"));
		paraMap.put("deptSeq", map.get("deptSeq"));
		
		/* msSql 쿼리 수정 */
		
		//paraMap.put("ymFrom",  map.get("reqYear") + "01");
		//paraMap.put("ymTo",    map.get("reqYear") + "12");
		
		paraMap.put("ymFrom",  map.get("reqMonthFr"));
		paraMap.put("ymTo",    map.get("reqMonthTo"));
		
		/* msSql 쿼리 수정 */
		
		paraMap.put("pjtCd",   map.get("pjtCd"));
//		paraMap.put("btmCd",   map.get("btmCd"));
		
		List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> budgetTmp = budgetService.getBudgetDataList(conVo, paraMap);
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
			if (budgetInfo.get("BGT_NM1") == null || "".equals(budgetInfo.get("BGT_NM1"))) {
				continue;
			}
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("coCd",   budgetInfo.get("CO_CD"));
			
			/* mariaDB 쿼리 수정 */
			
//			param.put("bgtYm", ((String) budgetInfo.get("BGT_YM")).substring(0, 4));
			param.put("reqMonthFr", map.get("reqMonthFr"));
			param.put("reqMonthTo", map.get("reqMonthTo"));
			
			/* mariaDB 쿼리 수정 */
			
			param.put("divCd",  budgetInfo.get("DIV_CD"));
			param.put("pjtCd",  budgetInfo.get("MGT_CD"));
//			param.put("btmCd",  budgetInfo.get("BOTTOM_CD"));
			param.put("bgtCd",  budgetInfo.get("BGT_CD"));
			
			Map<String, Object> preBudgetInfo = budgetService.getPreBudgetInfo(param);
			
			/*찬혁추가 From*/
			/*전표승인기준 금액 추가*/
			
			Map<String, Object> statementApprovalMoney = new HashMap<>();
			
			BigDecimal statSum = new BigDecimal(0);
			
			if (MapUtils.isEmpty(statementApprovalMoney)) {
				
			} else {
				statSum = (BigDecimal) statementApprovalMoney.get("statAppSum");
			}
			
			budgetInfo.put("STATE_SUM", statSum);
			
			/*찬혁추가 To*/
			
			// 예산금액
			BigDecimal bgtAm = ((BigDecimal) budgetInfo.get("BGT_AM1")).add((BigDecimal) budgetInfo.get("BGT_AM2"));
			budgetInfo.put("BGT_AM", bgtAm);
			
			// 품의액
			BigDecimal applyAm = new BigDecimal(0);
			// 결의액
			BigDecimal applyAm2 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			
			BigDecimal applyAm3 = (BigDecimal) budgetInfo.get("STATE_SUM");
			
			BigDecimal applyAmSum= new BigDecimal(0);
			
			if (preBudgetInfo != null) {
				applyAm = (BigDecimal) preBudgetInfo.get("applyAm");
				applyAmSum = ((BigDecimal) preBudgetInfo.get("applyAm")).add((BigDecimal) budgetInfo.get("APPLY_AM2"));
			} else {
				applyAmSum =(BigDecimal) budgetInfo.get("APPLY_AM2");
			}
			budgetInfo.put("APPLY_AM", applyAm);
			
			
			
			// 품의기준 잔액
			BigDecimal applyJan = bgtAm.subtract(applyAm).subtract(applyAm2);
			budgetInfo.put("APPLY_JAN", applyJan);
			
			// 결의기준 잔액
			BigDecimal applyJan2 = bgtAm.subtract(applyAm2);
			budgetInfo.put("APPLY_JAN2", applyJan2);
			
			// 전표기준 잔액
			BigDecimal applyJan3 = bgtAm.subtract(applyAm3);
			budgetInfo.put("APPLY_JAN3", applyJan3);
			
			// 품의기준/결의기준 잔액 %
			if ((bgtAm.compareTo(new BigDecimal(0)) == 0)) {
				budgetInfo.put("APPLY_JAN_PCT",  "0");
				budgetInfo.put("APPLY_JAN2_PCT", "0");
				budgetInfo.put("APPLY_JAN3_PCT", "0");
			}
			else {
				budgetInfo.put("APPLY_JAN_PCT",  applyAmSum.divide(bgtAm,  4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				budgetInfo.put("APPLY_JAN2_PCT", applyAm2.divide(bgtAm, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				budgetInfo.put("APPLY_JAN3_PCT", applyAm3.divide(bgtAm, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			}
			
			budgetMap.add(budgetInfo);
		}
		
		String bottomCd = "";
		String bottomNm = "";
		
		String pjtCd = "";
		String pjtNm = "";
		
		String divCd = "";
		String divNm = "";
		
//		BigDecimal bottomPrc1 = new BigDecimal(0);
//		BigDecimal bottomPrc2 = new BigDecimal(0);
//		BigDecimal bottomPrc3 = new BigDecimal(0);
//		BigDecimal bottomPrc4 = new BigDecimal(0);
//		BigDecimal bottomPrc5 = new BigDecimal(0);
//		BigDecimal bottomPrc6 = new BigDecimal(0);
//		BigDecimal bottomPrc7 = new BigDecimal(0);
				
		BigDecimal pjtPrc1 = new BigDecimal(0);
		BigDecimal pjtPrc2 = new BigDecimal(0);
		BigDecimal pjtPrc3 = new BigDecimal(0);
		BigDecimal pjtPrc4 = new BigDecimal(0);
		BigDecimal pjtPrc5 = new BigDecimal(0);
		BigDecimal pjtPrc6 = new BigDecimal(0);
		BigDecimal pjtPrc7 = new BigDecimal(0);
		
		BigDecimal divPrc1 = new BigDecimal(0);
		BigDecimal divPrc2 = new BigDecimal(0);
		BigDecimal divPrc3 = new BigDecimal(0);
		BigDecimal divPrc4 = new BigDecimal(0);
		BigDecimal divPrc5 = new BigDecimal(0);
		BigDecimal divPrc6 = new BigDecimal(0);
		BigDecimal divPrc7 = new BigDecimal(0);
		
		BigDecimal totPrc1 = new BigDecimal(0);
		BigDecimal totPrc2 = new BigDecimal(0);
		BigDecimal totPrc3 = new BigDecimal(0);
		BigDecimal totPrc4 = new BigDecimal(0);
		BigDecimal totPrc5 = new BigDecimal(0);
		BigDecimal totPrc6 = new BigDecimal(0);
		BigDecimal totPrc7 = new BigDecimal(0);
		
//		BigDecimal bottomPrcSum = new BigDecimal(0);
		BigDecimal pjtPrcSum = new BigDecimal(0);
		BigDecimal divPrcSum = new BigDecimal(0);
		BigDecimal totPrcSum = new BigDecimal(0);
		// 복사
		budgetTmp = new ArrayList<>(budgetMap);
		// 초기화
		budgetMap = new ArrayList<Map<String, Object>>();
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
			// 첫번째 레코드는 무조건 합계변수에 합산
			if (i == 0) {
//				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
//				bottomPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
//				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
//				bottomPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
//				bottomPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
//				bottomPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
//				bottomPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
				
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
				pjtPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(pjtPrc4);
				pjtPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(pjtPrc5);
				pjtPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(pjtPrc6);
				pjtPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(pjtPrc7);
				
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
				divPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(divPrc4);
				divPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(divPrc5);
				divPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(divPrc6);
				divPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(divPrc7);
			}
			
			// 하위사업 코드가 같을때까지 합산
//			if (bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
//				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(bottomPrc1);
//				bottomPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(bottomPrc2);
//				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
//				bottomPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(bottomPrc4);
//				bottomPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(bottomPrc5);
//				bottomPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(bottomPrc6);
//				bottomPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(bottomPrc7);
//			}
			
			// 하위사업 코드가 틀려지면 소계 필드 추가
//			if (!bottomCd.equals("") && !bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
//				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
//
//				budgetInfoTmp.put("CO_CD",      "");
//				budgetInfoTmp.put("BGT_YM",     "");
//				budgetInfoTmp.put("DIV_CD",     "");
//				budgetInfoTmp.put("DIV_NM",     "");
//				budgetInfoTmp.put("MGT_CD",     "");
//				budgetInfoTmp.put("MGT_NM",     "");
//				budgetInfoTmp.put("BOTTOM_CD",  "");
//				budgetInfoTmp.put("BOTTOM_NM",  bottomNm + " 소계");
//				budgetInfoTmp.put("BGT_CD",     "");
//				budgetInfoTmp.put("BGT_NM",     "");
//				budgetInfoTmp.put("BGT_NM1",    "");
//				budgetInfoTmp.put("BGT_NM2",    "");
//				budgetInfoTmp.put("BGT_NM3",    "");
//				budgetInfoTmp.put("BGT_AM",     bottomPrc1);
//				budgetInfoTmp.put("APPLY_AM",   bottomPrc2);
//				budgetInfoTmp.put("APPLY_AM2",  bottomPrc3);
//				budgetInfoTmp.put("APPLY_JAN",  bottomPrc4);
//				budgetInfoTmp.put("APPLY_JAN2", bottomPrc5);
//				budgetInfoTmp.put("STATE_SUM", bottomPrc6);
//				budgetInfoTmp.put("APPLY_JAN3", bottomPrc7);
//				
//				bottomPrcSum = bottomPrc2.add(bottomPrc3);
//				
//				if ((bottomPrc1.compareTo(new BigDecimal(0)) == 0)) {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//					budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//				}
//				else {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  bottomPrcSum.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN2_PCT", bottomPrc3.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN3_PCT", bottomPrc6.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//				}
//				
//				budgetMap.add(budgetInfoTmp);
//				
//				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
//				bottomPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
//				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
//				bottomPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
//				bottomPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
//				bottomPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
//				bottomPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
//			}
			
			// 하위사업 코드가 같을때까지 합산
			if (pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
				pjtPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(pjtPrc4);
				pjtPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(pjtPrc5);
				pjtPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(pjtPrc6);
				pjtPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(pjtPrc7);
				
				
			}
			
			
			// 프로젝트 코드가 틀려지면 소계 필드 추가
			if (!pjtCd.equals("") && !pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
				
				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    "");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM",     pjtPrc1);
				budgetInfoTmp.put("APPLY_AM",   pjtPrc2);
				budgetInfoTmp.put("APPLY_AM2",  pjtPrc3);
				budgetInfoTmp.put("APPLY_JAN",  pjtPrc4);
				budgetInfoTmp.put("APPLY_JAN2", pjtPrc5);
				budgetInfoTmp.put("STATE_SUM", pjtPrc6);
				budgetInfoTmp.put("APPLY_JAN3", pjtPrc7);
				
				pjtPrcSum = pjtPrc2.add(pjtPrc3);
				
				if ((pjtPrc1.compareTo(new BigDecimal(0)) == 0)) {
					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
					budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
				}
				else {
					budgetInfoTmp.put("APPLY_JAN_PCT",  pjtPrcSum.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN2_PCT", pjtPrc3.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN3_PCT", pjtPrc6.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				}
				
				budgetMap.add(budgetInfoTmp);
				
				pjtPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
				pjtPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
				pjtPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
				pjtPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
				pjtPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
				pjtPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
				pjtPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
			}
			
			// 회계단위 코드가 같을때까지 합산
			if (divCd.equals(budgetInfo.get("DIV_CD"))) {
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
				divPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(divPrc4);
				divPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(divPrc5);
				divPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(divPrc6);
				divPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(divPrc7);
			}
			
			// 회계단위 코드가 틀려지면 소계 필드 추가
			if (!divCd.equals("") && !divCd.equals(budgetInfo.get("DIV_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    "");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM",     divPrc1);
				budgetInfoTmp.put("APPLY_AM",   divPrc2);
				budgetInfoTmp.put("APPLY_AM2",  divPrc3);
				budgetInfoTmp.put("APPLY_JAN",  divPrc4);
				budgetInfoTmp.put("APPLY_JAN2", divPrc5);
				budgetInfoTmp.put("STATE_SUM", divPrc6);
				budgetInfoTmp.put("APPLY_JAN3", divPrc7);
				
				divPrcSum = divPrc2.add(divPrc3);
				
				if ((divPrc1.compareTo(new BigDecimal(0)) == 0)) {
					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
					budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
				}
				else {
					budgetInfoTmp.put("APPLY_JAN_PCT",  divPrcSum.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN2_PCT", divPrc3.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN3_PCT", divPrc6.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				}
				
				budgetMap.add(budgetInfoTmp);
				
				divPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
				divPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
				divPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
				divPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
				divPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
				divPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
				divPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
			}
			
			budgetMap.add(budgetInfo);
			
			bottomCd = (String) budgetInfo.get("BOTTOM_CD");
			bottomNm = (String) budgetInfo.get("BOTTOM_NM");
			
			pjtCd = (String) budgetInfo.get("MGT_CD");
			pjtNm = (String) budgetInfo.get("MGT_NM");
			
			divCd = (String) budgetInfo.get("DIV_CD");
			divNm = (String) budgetInfo.get("DIV_NM");

			totPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(totPrc1);
			totPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(totPrc2);
			totPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(totPrc3);
			totPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(totPrc4);
			totPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(totPrc5);
			totPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(totPrc6);
			totPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(totPrc7);
		}
		
		// 하위사업 마지막 소계
		Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

//		budgetInfoTmp.put("CO_CD",      "");
//		budgetInfoTmp.put("BGT_YM",     "");
//		budgetInfoTmp.put("DIV_CD",     "");
//		budgetInfoTmp.put("DIV_NM",     "");
//		budgetInfoTmp.put("MGT_CD",     "");
//		budgetInfoTmp.put("MGT_NM",     "");
//		budgetInfoTmp.put("BOTTOM_CD",  "");
//		budgetInfoTmp.put("BOTTOM_NM",  bottomNm + " 소계");
//		budgetInfoTmp.put("BGT_CD",     "");
//		budgetInfoTmp.put("BGT_NM",     "");
//		budgetInfoTmp.put("BGT_NM1",    "");
//		budgetInfoTmp.put("BGT_NM2",    "");
//		budgetInfoTmp.put("BGT_NM3",    "");
//		budgetInfoTmp.put("BGT_AM",     bottomPrc1);
//		budgetInfoTmp.put("APPLY_AM",   bottomPrc2);
//		budgetInfoTmp.put("APPLY_AM2",  bottomPrc3);
//		budgetInfoTmp.put("APPLY_JAN",  bottomPrc4);
//		budgetInfoTmp.put("APPLY_JAN2", bottomPrc5);
//		budgetInfoTmp.put("STATE_SUM", bottomPrc6);
//		budgetInfoTmp.put("APPLY_JAN3", bottomPrc7);
//		
//		bottomPrcSum = bottomPrc2.add(bottomPrc3);
//		
//		if ((bottomPrc1.compareTo(new BigDecimal(0)) == 0)) {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//		}
//		else {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  bottomPrcSum.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN2_PCT", bottomPrc3.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN3_PCT", bottomPrc6.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//		}
		
//		budgetMap.add(budgetInfoTmp);
		
		// 프로젝트 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();
		
		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     "");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     pjtNm + " 소계");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  "");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     pjtPrc1);
		budgetInfoTmp.put("APPLY_AM",   pjtPrc2);
		budgetInfoTmp.put("APPLY_AM2",  pjtPrc3);
		budgetInfoTmp.put("APPLY_JAN",  pjtPrc4);
		budgetInfoTmp.put("APPLY_JAN2", pjtPrc5);
		budgetInfoTmp.put("STATE_SUM", pjtPrc6);
		budgetInfoTmp.put("APPLY_JAN3", pjtPrc7);
		
		pjtPrcSum = pjtPrc2.add(pjtPrc3);
		
		if ((pjtPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  pjtPrcSum.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", pjtPrc3.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN3_PCT", pjtPrc6.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		// 회계단위 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     divNm + " 소계");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     "");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  "");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     divPrc1);
		budgetInfoTmp.put("APPLY_AM",   divPrc2);
		budgetInfoTmp.put("APPLY_AM2",  divPrc3);
		budgetInfoTmp.put("APPLY_JAN",  divPrc4);
		budgetInfoTmp.put("APPLY_JAN2", divPrc5);
		budgetInfoTmp.put("STATE_SUM", divPrc6);
		budgetInfoTmp.put("APPLY_JAN3", divPrc7);
		
		divPrcSum = divPrc2.add(divPrc3);
		
		if ((divPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  divPrcSum.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", divPrc3.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN3_PCT", divPrc6.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		// 총합계 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     "");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     "");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  "");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "합계");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     totPrc1);
		budgetInfoTmp.put("APPLY_AM",   totPrc2);
		budgetInfoTmp.put("APPLY_AM2",  totPrc3);
		budgetInfoTmp.put("APPLY_JAN",  totPrc4);
		budgetInfoTmp.put("APPLY_JAN2", totPrc5);
		budgetInfoTmp.put("STATE_SUM", totPrc6);
		budgetInfoTmp.put("APPLY_JAN3", totPrc7);
		
		totPrcSum = totPrc2.add(totPrc3);
		
		if ((totPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  totPrcSum.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", totPrc3.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN3_PCT", totPrc6.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("mainList", budgetMap);
		
		return result;
		
	}
	
	@RequestMapping(value = "/budget/execBudgetDataListExcel")
	public String execBudgetDataListExcel
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   map.get("divCdE"));
		paraMap.put("deptSeq", map.get("deptSeqE"));
		
		/*조건 검색 From ~ To 수정*/
		
		//paraMap.put("ymFrom",  map.get("reqYearE") + "01");
		//paraMap.put("ymTo",    map.get("reqYearE") + "12");
		
		paraMap.put("ymFrom",  map.get("reqEFr"));
		paraMap.put("ymTo",    map.get("reqETo"));
		
		/*조건 검색 From ~ To 수정*/
		
		paraMap.put("pjtCd",   map.get("pjtCdE"));
		paraMap.put("btmCd",   map.get("btmCdE"));
		
		List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> budgetTmp = budgetService.getBudgetDataList(conVo, paraMap);
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
			if (budgetInfo.get("BGT_NM1") == null || "".equals(budgetInfo.get("BGT_NM1"))) {
				continue;
			}
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("coCd",   budgetInfo.get("CO_CD"));
			param.put("bgtYm", ((String) budgetInfo.get("BGT_YM")).substring(0, 4));
			param.put("divCd",  budgetInfo.get("DIV_CD"));
			param.put("pjtCd",  budgetInfo.get("MGT_CD"));
			param.put("btmCd",  budgetInfo.get("BOTTOM_CD"));
			param.put("bgtCd",  budgetInfo.get("BGT_CD"));
			
			Map<String, Object> preBudgetInfo = budgetService.getPreBudgetInfo(param);
			
			// 예산금액
			BigDecimal bgtAm = ((BigDecimal) budgetInfo.get("BGT_AM1")).add((BigDecimal) budgetInfo.get("BGT_AM2"));
			budgetInfo.put("BGT_AM", bgtAm);
			
			// 품의액
			BigDecimal applyAm = new BigDecimal(0);
			BigDecimal applyAm2 = (BigDecimal) budgetInfo.get("APPLY_AM2");
			
			if (preBudgetInfo != null) {
				applyAm = (BigDecimal) preBudgetInfo.get("applyAm");
			}
			budgetInfo.put("APPLY_AM", applyAm);
			
			// 품의기준 잔액
			BigDecimal applyJan = bgtAm.subtract(applyAm).subtract(applyAm2);
			budgetInfo.put("APPLY_JAN", applyJan);
			
			// 결의기준 잔액
			BigDecimal applyJan2 = bgtAm.subtract(applyAm2);
			budgetInfo.put("APPLY_JAN2", applyJan2);
			
			// 품의기준/결의기준 잔액 %
			if ((bgtAm.compareTo(new BigDecimal(0)) == 0)) {
				budgetInfo.put("APPLY_JAN_PCT",  "0");
				budgetInfo.put("APPLY_JAN2_PCT", "0");
			}
			else {
				budgetInfo.put("APPLY_JAN_PCT",  applyAm.divide(bgtAm,  4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				budgetInfo.put("APPLY_JAN2_PCT", applyAm2.divide(bgtAm, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			}
			
			budgetMap.add(budgetInfo);
		}
		
		String bottomCd = "";
		String bottomNm = "";
		
		String pjtCd = "";
		String pjtNm = "";
		
		String divCd = "";
		String divNm = "";
		
		BigDecimal bottomPrc1 = new BigDecimal(0);
		BigDecimal bottomPrc2 = new BigDecimal(0);
		BigDecimal bottomPrc3 = new BigDecimal(0);
		BigDecimal bottomPrc4 = new BigDecimal(0);
		BigDecimal bottomPrc5 = new BigDecimal(0);
		
		BigDecimal pjtPrc1 = new BigDecimal(0);
		BigDecimal pjtPrc2 = new BigDecimal(0);
		BigDecimal pjtPrc3 = new BigDecimal(0);
		BigDecimal pjtPrc4 = new BigDecimal(0);
		BigDecimal pjtPrc5 = new BigDecimal(0);
		
		BigDecimal divPrc1 = new BigDecimal(0);
		BigDecimal divPrc2 = new BigDecimal(0);
		BigDecimal divPrc3 = new BigDecimal(0);
		BigDecimal divPrc4 = new BigDecimal(0);
		BigDecimal divPrc5 = new BigDecimal(0);
		
		BigDecimal totPrc1 = new BigDecimal(0);
		BigDecimal totPrc2 = new BigDecimal(0);
		BigDecimal totPrc3 = new BigDecimal(0);
		BigDecimal totPrc4 = new BigDecimal(0);
		BigDecimal totPrc5 = new BigDecimal(0);
		
		// 복사
		budgetTmp = new ArrayList<>(budgetMap);
		// 초기화
		budgetMap = new ArrayList<Map<String, Object>>();
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
			// 첫번째 레코드는 무조건 합계변수에 합산
			if (i == 0) {
				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
				bottomPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
				bottomPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
				bottomPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
				
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
				pjtPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(pjtPrc4);
				pjtPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(pjtPrc5);
				
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
				divPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(divPrc4);
				divPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(divPrc5);
			}
			
			// 하위사업 코드가 같을때까지 합산
			if (bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(bottomPrc1);
				bottomPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(bottomPrc2);
				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
				bottomPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(bottomPrc4);
				bottomPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(bottomPrc5);
			}
			
			// 하위사업 코드가 틀려지면 소계 필드 추가
			if (!bottomCd.equals("") && !bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",      "");
				budgetInfoTmp.put("BGT_YM",     "");
				budgetInfoTmp.put("DIV_CD",     "");
				budgetInfoTmp.put("DIV_NM",     "");
				budgetInfoTmp.put("MGT_CD",     "");
				budgetInfoTmp.put("MGT_NM",     "");
				budgetInfoTmp.put("BOTTOM_CD",  "");
				budgetInfoTmp.put("BOTTOM_NM",  bottomNm + " 소계");
				budgetInfoTmp.put("BGT_CD",     "");
				budgetInfoTmp.put("BGT_NM",     "");
				budgetInfoTmp.put("BGT_NM1",    "");
				budgetInfoTmp.put("BGT_NM2",    "");
				budgetInfoTmp.put("BGT_NM3",    "");
				budgetInfoTmp.put("BGT_AM",     bottomPrc1);
				budgetInfoTmp.put("APPLY_AM",   bottomPrc2);
				budgetInfoTmp.put("APPLY_AM2",  bottomPrc3);
				budgetInfoTmp.put("APPLY_JAN",  bottomPrc4);
				budgetInfoTmp.put("APPLY_JAN2", bottomPrc5);
				
				if ((bottomPrc1.compareTo(new BigDecimal(0)) == 0)) {
					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
				}
				else {
					budgetInfoTmp.put("APPLY_JAN_PCT",  bottomPrc2.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN2_PCT", bottomPrc3.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				}
				
				budgetMap.add(budgetInfoTmp);
				
				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
				bottomPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
				bottomPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
				bottomPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
			}
			
			// 하위사업 코드가 같을때까지 합산
			if (pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(pjtPrc1);
				pjtPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(pjtPrc2);
				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
				pjtPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(pjtPrc4);
				pjtPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(pjtPrc5);
			}
			
			// 프로젝트 코드가 틀려지면 소계 필드 추가
			if (!pjtCd.equals("") && !pjtCd.equals(budgetInfo.get("MGT_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
				
				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    "");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM",     pjtPrc1);
				budgetInfoTmp.put("APPLY_AM",   pjtPrc2);
				budgetInfoTmp.put("APPLY_AM2",  pjtPrc3);
				budgetInfoTmp.put("APPLY_JAN",  pjtPrc4);
				budgetInfoTmp.put("APPLY_JAN2", pjtPrc5);
				
				if ((pjtPrc1.compareTo(new BigDecimal(0)) == 0)) {
					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
				}
				else {
					budgetInfoTmp.put("APPLY_JAN_PCT",  pjtPrc2.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN2_PCT", pjtPrc3.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				}
				
				budgetMap.add(budgetInfoTmp);
				
				pjtPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
				pjtPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
				pjtPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
				pjtPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
				pjtPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
			}
			
			// 회계단위 코드가 같을때까지 합산
			if (divCd.equals(budgetInfo.get("DIV_CD"))) {
				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(divPrc1);
				divPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(divPrc2);
				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
				divPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(divPrc4);
				divPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(divPrc5);
			}
			
			// 회계단위 코드가 틀려지면 소계 필드 추가
			if (!divCd.equals("") && !divCd.equals(budgetInfo.get("DIV_CD"))) {
				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

				budgetInfoTmp.put("CO_CD",     "");
				budgetInfoTmp.put("BGT_YM",    "");
				budgetInfoTmp.put("DIV_CD",    "");
				budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
				budgetInfoTmp.put("MGT_CD",    "");
				budgetInfoTmp.put("MGT_NM",    "");
				budgetInfoTmp.put("BOTTOM_CD", "");
				budgetInfoTmp.put("BOTTOM_NM", "");
				budgetInfoTmp.put("BGT_CD",    "");
				budgetInfoTmp.put("BGT_NM",    "");
				budgetInfoTmp.put("BGT_NM1",   "");
				budgetInfoTmp.put("BGT_NM2",   "");
				budgetInfoTmp.put("BGT_NM3",   "");
				budgetInfoTmp.put("BGT_AM",     divPrc1);
				budgetInfoTmp.put("APPLY_AM",   divPrc2);
				budgetInfoTmp.put("APPLY_AM2",  divPrc3);
				budgetInfoTmp.put("APPLY_JAN",  divPrc4);
				budgetInfoTmp.put("APPLY_JAN2", divPrc5);
				
				if ((divPrc1.compareTo(new BigDecimal(0)) == 0)) {
					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
				}
				else {
					budgetInfoTmp.put("APPLY_JAN_PCT",  divPrc2.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
					budgetInfoTmp.put("APPLY_JAN2_PCT", divPrc3.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				}
				
				budgetMap.add(budgetInfoTmp);
				
				divPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
				divPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
				divPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
				divPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
				divPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
			}
			
			budgetMap.add(budgetInfo);
			
			bottomCd = (String) budgetInfo.get("BOTTOM_CD");
			bottomNm = (String) budgetInfo.get("BOTTOM_NM");
			
			pjtCd = (String) budgetInfo.get("MGT_CD");
			pjtNm = (String) budgetInfo.get("MGT_NM");
			
			divCd = (String) budgetInfo.get("DIV_CD");
			divNm = (String) budgetInfo.get("DIV_NM");

			totPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(totPrc1);
			totPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(totPrc2);
			totPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(totPrc3);
			totPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(totPrc4);
			totPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(totPrc5);
		}
		
		// 하위사업 마지막 소계
		Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     "");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     "");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  bottomNm + " 소계");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     bottomPrc1);
		budgetInfoTmp.put("APPLY_AM",   bottomPrc2);
		budgetInfoTmp.put("APPLY_AM2",  bottomPrc3);
		budgetInfoTmp.put("APPLY_JAN",  bottomPrc4);
		budgetInfoTmp.put("APPLY_JAN2", bottomPrc5);
		
		if ((bottomPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  bottomPrc2.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", bottomPrc3.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		// 프로젝트 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();
		
		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     "");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     pjtNm + " 소계");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  "");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     pjtPrc1);
		budgetInfoTmp.put("APPLY_AM",   pjtPrc2);
		budgetInfoTmp.put("APPLY_AM2",  pjtPrc3);
		budgetInfoTmp.put("APPLY_JAN",  pjtPrc4);
		budgetInfoTmp.put("APPLY_JAN2", pjtPrc5);
		
		if ((pjtPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  pjtPrc2.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", pjtPrc3.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		// 회계단위 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     divNm + " 소계");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     "");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  "");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     divPrc1);
		budgetInfoTmp.put("APPLY_AM",   divPrc2);
		budgetInfoTmp.put("APPLY_AM2",  divPrc3);
		budgetInfoTmp.put("APPLY_JAN",  divPrc4);
		budgetInfoTmp.put("APPLY_JAN2", divPrc5);
		
		if ((divPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  divPrc2.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", divPrc3.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		// 총합계 마지막 소계
		budgetInfoTmp = new HashMap<String, Object>();

		budgetInfoTmp.put("CO_CD",      "");
		budgetInfoTmp.put("BGT_YM",     "");
		budgetInfoTmp.put("DIV_CD",     "");
		budgetInfoTmp.put("DIV_NM",     "");
		budgetInfoTmp.put("MGT_CD",     "");
		budgetInfoTmp.put("MGT_NM",     "");
		budgetInfoTmp.put("BOTTOM_CD",  "");
		budgetInfoTmp.put("BOTTOM_NM",  "");
		budgetInfoTmp.put("BGT_CD",     "");
		budgetInfoTmp.put("BGT_NM",     "");
		budgetInfoTmp.put("BGT_NM1",    "합계");
		budgetInfoTmp.put("BGT_NM2",    "");
		budgetInfoTmp.put("BGT_NM3",    "");
		budgetInfoTmp.put("BGT_AM",     totPrc1);
		budgetInfoTmp.put("APPLY_AM",   totPrc2);
		budgetInfoTmp.put("APPLY_AM2",  totPrc3);
		budgetInfoTmp.put("APPLY_JAN",  totPrc4);
		budgetInfoTmp.put("APPLY_JAN2", totPrc5);
		
		if ((totPrc1.compareTo(new BigDecimal(0)) == 0)) {
			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
		}
		else {
			budgetInfoTmp.put("APPLY_JAN_PCT",  totPrc2.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			budgetInfoTmp.put("APPLY_JAN2_PCT", totPrc3.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		}
		
		budgetMap.add(budgetInfoTmp);
		
		model.addAttribute("mainList", budgetMap);
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename=BudgetStatus.xls");
		
		return "/budget/execBudgetListExcel";
		
	}
	
	@RequestMapping(value = "/budget/getBtmList")
	@ResponseBody
	public Map<String, Object> getBtmList(@RequestParam Map<String, Object> map) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		List<Map<String, Object>> btmMap = new ArrayList<Map<String, Object>>();
		String[] pjtCd = ((String) map.get("pjtCd")).split("\\|");
		
		for (int i = 0; i < pjtCd.length; i++) {
			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("coCd",  loginVO.getErpCoCd());
			paraMap.put("pjtCd", pjtCd[i]);
		
			List<Map<String, Object>> tmpBtm = budgetService.getErpBtmList(conVo, paraMap);
			
			btmMap.addAll(tmpBtm);
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("btmList", btmMap);
		
		return result;
		
	}
	
	/**
	 * 부서 사용자 callback
	 */
	@RequestMapping(value = "/budget/pop/cmmOrgPopCallback", method = RequestMethod.POST)
	public String cmmOrgPopCallback(Model model) {
		
		logger.info("cmmOrgPopCallback");
		return "/budget/pop/cmmOrgPopCallback";
		
	}
	
	private ConnectionVO GetConnection() throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginVO", loginVO);
		
		return acCommonService.acErpSystemInfo(param);
	}
	
	private ConnectionVO GetConnectionBatch(String compCd) throws Exception {
		LoginVO loginVO = new LoginVO();
		loginVO.setCompSeq(compCd);
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginVO", loginVO);
		
		return acCommonService.acErpSystemInfo(param);
	}
	
	/**
	 * 예산과목별 예산편성 현황
	 */
	@RequestMapping(value = "/budget/bgtBudgetList")
	public String bgtBudgetList
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("bgtBudgetList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도
		
		String pDivCd   = Objects.toString(map.get("divCd"),   "");
		String pDivNm   = Objects.toString(map.get("divNm"),   "");
		String pDeptSeq = Objects.toString(map.get("deptSeq"), "");
		String pDeptNm  = Objects.toString(map.get("deptNm"),  "");
		String pPjtCd   = Objects.toString(map.get("pjtCd"),   "");
		String pPjtNm   = Objects.toString(map.get("pjtNm"),   "");
		String pBtmCd   = Objects.toString(map.get("btmCd"),   "");
		String pBtmNm   = Objects.toString(map.get("btmNm"),   "");
		
		if (!"Y".equals(map.get("search"))) {
			pDeptSeq = loginVO.getOrgnztId();
			pDeptNm  = loginVO.getOrgnztNm();
		}
		
		model.addAttribute("reqYear", reqYear);
		model.addAttribute("divCd",   pDivCd);
		model.addAttribute("divNm",   pDivNm);
		model.addAttribute("deptSeq", pDeptSeq);
		model.addAttribute("deptNm",  pDeptNm);
		model.addAttribute("pjtCd",   pPjtCd);
		model.addAttribute("pjtNm",   pPjtNm);
		model.addAttribute("btmCd",   pBtmCd);
		model.addAttribute("btmNm",   pBtmNm);
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   pDivCd);
		paraMap.put("deptSeq", pDeptSeq);
		paraMap.put("ymFrom",  Objects.toString(map.get("reqYear"), reqYear) + "01");
		paraMap.put("ymTo",    Objects.toString(map.get("reqYear"), reqYear) + "12");
		paraMap.put("pjtCd",   pPjtCd);
		paraMap.put("btmCd",   pBtmCd);
		
		List<Map<String, Object>> pjtBtmList  = budgetService.mapPjtBtmList(conVo, paraMap);
		List<Map<String, Object>> bgtInfoList = budgetService.mapBgtInfoList(conVo, paraMap);
		List<Map<String, Object>> pjtInfoList = budgetService.pjtInfoList(conVo, paraMap);
		
		// 검색버튼을 눌렀을때만 동작함
		if ("Y".equals(map.get("search"))) {
			List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> budgetList = budgetService.getBudgetDataList(conVo, paraMap);
			
			String hBgtCd = "";
			String hBgtNm = "";
			String bhBgtCd = "";
			String bhBgtNm = "";
			
			// 관 소계용 변수
			BigDecimal hBgtAmt1 = new BigDecimal(0);
			BigDecimal hBgtAmt2 = new BigDecimal(0);
			BigDecimal hBgtAmt3 = new BigDecimal(0);
			
			// 관 소계용 합계
			BigDecimal thBgtAmt1 = new BigDecimal(0);
			BigDecimal thBgtAmt2 = new BigDecimal(0);
			BigDecimal thBgtAmt3 = new BigDecimal(0);
			
			// 총합계
			BigDecimal stBgtAmt1 = new BigDecimal(0);
			BigDecimal stBgtAmt2 = new BigDecimal(0);
			BigDecimal stBgtAmt3 = new BigDecimal(0);
			
			// 관 소계용 HashMap
			Map<String, Object> subAmt = new HashMap<String, Object>();
			// 합계용 HashMap
			Map<String, Object> totAmt = new HashMap<String, Object>();
			
			for (int i = 0; i < bgtInfoList.size(); i++) {
				Map<String, Object> bgtInfo = bgtInfoList.get(i);
				String bgtCd = (String) bgtInfo.get("bgtCd");
				
				// 현재 관 예산코드 및 명
				hBgtCd = (String) bgtInfo.get("hBgtCd");
				hBgtNm = (String) bgtInfo.get("hBgtNm");
				
				Map<String, Object> bodyMap = new HashMap<String, Object>();
				bodyMap.put("bgtCd",  bgtCd);
				bodyMap.put("hBgtCd", hBgtCd);
				bodyMap.put("hBgtNm", bgtInfo.get("hBgtNm"));
				bodyMap.put("bgtNm",  bgtInfo.get("bgtNm"));
				
				BigDecimal totAmt1 = new BigDecimal(0);
				BigDecimal totAmt2 = new BigDecimal(0);
				BigDecimal totAmt3 = new BigDecimal(0);
				
				// 데이터가 달라지면 소계 필드 추가
				if (!"".equals(bhBgtCd) && !hBgtCd.equals(bhBgtCd)) {
					subAmt.put("bgtCd",  "000000");
					subAmt.put("hBgtCd", bhBgtCd);
					subAmt.put("hBgtNm", bhBgtNm);
					subAmt.put("bgtNm",  "");

					// 관용 소계 합계 필드
					subAmt.put(bhBgtCd + "_1", thBgtAmt1);
					subAmt.put(bhBgtCd + "_2", thBgtAmt2);
					subAmt.put(bhBgtCd + "_3", thBgtAmt3);
					
					thBgtAmt1 = new BigDecimal(0);
					thBgtAmt2 = new BigDecimal(0);
					thBgtAmt3 = new BigDecimal(0);
					
					// 관 소계 데이터 추가 
					budgetMap.add(subAmt);
					
					// 관 소계 데이터 초기화
					subAmt = new HashMap<String, Object>();
				}
				
				for (int j = 0; j < pjtBtmList.size(); j++) {
					Map<String, Object> pjtBtm  = pjtBtmList.get(j);
					
					String pjtCd = (String) pjtBtm.get("pjtCd");
					String btmCd = (String) pjtBtm.get("btmCd");
					
					// 프로젝트, 하위사업, 예산계정에 맞는 예산액, 집행액 조회
					Map<String, Object> budgetInfo = getBudgetInfo(budgetList, pjtCd, btmCd, bgtCd);
					
					BigDecimal bgtAm1 = new BigDecimal(0);
					BigDecimal bgtAm2 = new BigDecimal(0);
					if (budgetInfo != null && budgetInfo.size() > 0) {
						bgtAm1 = (BigDecimal) budgetInfo.get("BGT_AM1");
						bgtAm2 = (BigDecimal) budgetInfo.get("BGT_AM2");
					}
					
					// 항 금액 필드
					String bgtKey = pjtCd + "_" + btmCd + "_" + bgtCd;
					bodyMap.put(bgtKey + "_1", bgtAm1);
					bodyMap.put(bgtKey + "_2", bgtAm2);
					bodyMap.put(bgtKey + "_3", bgtAm1.add(bgtAm2));
					
					// 소계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					
					// 관소계 합계 편성금액
					String hBgtKey = pjtCd + "_" + btmCd + "_" + hBgtCd;
					if (subAmt.get(hBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) subAmt.get(hBgtKey + "_1");
					}
					
					// 관소계 합계 추가금액
					if (subAmt.get(hBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) subAmt.get(hBgtKey + "_2");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) subAmt.get(hBgtKey + "_3");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1);
					hBgtAmt2 = hBgtAmt2.add(bgtAm2);
					hBgtAmt3 = hBgtAmt3.add(bgtAm1.add(bgtAm2));
					
					// 관용 소계 필드
					subAmt.put(hBgtKey + "_1", hBgtAmt1);
					subAmt.put(hBgtKey + "_2", hBgtAmt2);
					subAmt.put(hBgtKey + "_3", hBgtAmt3);
					
					// 합계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					
					// 편성금액 합계금액 (프로젝트 + 하위사업코드)
					String thBgtKey = pjtCd + "_" + btmCd;
					if (totAmt.get(thBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) totAmt.get(thBgtKey + "_1");
					}
					
					// 조정금액 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) totAmt.get(thBgtKey + "_2");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) totAmt.get(thBgtKey + "_3");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1);
					hBgtAmt2 = hBgtAmt2.add(bgtAm2);
					hBgtAmt3 = hBgtAmt3.add(bgtAm1.add(bgtAm2));
					
					// 합계 필드
					totAmt.put(thBgtKey + "_1", hBgtAmt1);
					totAmt.put(thBgtKey + "_2", hBgtAmt2);
					totAmt.put(thBgtKey + "_3", hBgtAmt3);
					
					// 총액 계산
					totAmt1 = totAmt1.add(bgtAm1);
					totAmt2 = totAmt2.add(bgtAm2);
					totAmt3 = totAmt3.add(bgtAm1.add(bgtAm2));
				}
				
				// 소계 저장
				thBgtAmt1 = thBgtAmt1.add(totAmt1);
				thBgtAmt2 = thBgtAmt2.add(totAmt2);
				thBgtAmt3 = thBgtAmt3.add(totAmt3);
				
				// 합계 저장
				stBgtAmt1 = stBgtAmt1.add(totAmt1);
				stBgtAmt2 = stBgtAmt2.add(totAmt2);
				stBgtAmt3 = stBgtAmt3.add(totAmt3);
				
				// 총액 저장
				bodyMap.put("totAmt1", totAmt1);
				bodyMap.put("totAmt2", totAmt2);
				bodyMap.put("totAmt3", totAmt3);
				
				// 총액 초기화
				totAmt1 = new BigDecimal(0);
				totAmt2 = new BigDecimal(0);
				totAmt3 = new BigDecimal(0);
				
				budgetMap.add(bodyMap);
				
				// 이전 관 예산코드 및 명
				bhBgtCd = (String) bgtInfo.get("hBgtCd");
				bhBgtNm = (String) bgtInfo.get("hBgtNm");
			}

			// 마지막 관용 소계 합계 필드
			subAmt.put(hBgtCd + "_1", thBgtAmt1);
			subAmt.put(hBgtCd + "_2", thBgtAmt2);
			subAmt.put(hBgtCd + "_3", thBgtAmt3);

			// 마지막 소계필드 추가
			subAmt.put("bgtCd",  "000000");
			subAmt.put("hBgtNm", hBgtNm);
			subAmt.put("hBgtCd", hBgtCd);
			subAmt.put("bgtNm",  "");
			
			budgetMap.add(subAmt);
			
			// 합계 필드
			totAmt.put("totAmt1", stBgtAmt1);
			totAmt.put("totAmt2", stBgtAmt2);
			totAmt.put("totAmt3", stBgtAmt3);
			
			// 합계 필드 추가
			totAmt.put("bgtCd",  "999999");
			totAmt.put("hBgtNm", "");
			totAmt.put("hBgtCd", "");
			totAmt.put("bgtNm",  "");
			
			budgetMap.add(totAmt);
			
			model.addAttribute("mainList", budgetMap);
		}

		model.addAttribute("bgtInfoList", bgtInfoList);
		model.addAttribute("pjtInfoList", pjtInfoList);
		model.addAttribute("pjtBtmList",  pjtBtmList);
		
		return "/budget/bgtBudgetList";
		
	}
	
	@RequestMapping(value = "/budget/bgtBudgetListExcel")
	public String bgtBudgetListExcel
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("bgtBudgetListExcel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도

		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   Objects.toString(map.get("divCd"), ""));
		paraMap.put("deptSeq", Objects.toString(map.get("deptSeq"), ""));
		paraMap.put("ymFrom",  Objects.toString(map.get("reqYear"), reqYear) + "01");
		paraMap.put("ymTo",    Objects.toString(map.get("reqYear"), reqYear) + "12");
		paraMap.put("pjtCd",   Objects.toString(map.get("pjtCd"), ""));
		paraMap.put("btmCd",   Objects.toString(map.get("btmCd"), ""));
		
		List<Map<String, Object>> pjtBtmList  = budgetService.mapPjtBtmList(conVo, paraMap);
		List<Map<String, Object>> bgtInfoList = budgetService.mapBgtInfoList(conVo, paraMap);
		List<Map<String, Object>> pjtInfoList = budgetService.pjtInfoList(conVo, paraMap);
		
		// 검색버튼을 눌렀을때만 동작함
		if ("Y".equals(map.get("search"))) {
			List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> budgetList = budgetService.getBudgetDataList(conVo, paraMap);
			
			String hBgtCd = "";
			String hBgtNm = "";
			String bhBgtCd = "";
			String bhBgtNm = "";
			
			// 관 소계용 변수
			BigDecimal hBgtAmt1 = new BigDecimal(0);
			BigDecimal hBgtAmt2 = new BigDecimal(0);
			BigDecimal hBgtAmt3 = new BigDecimal(0);
			
			// 관 소계용 합계
			BigDecimal thBgtAmt1 = new BigDecimal(0);
			BigDecimal thBgtAmt2 = new BigDecimal(0);
			BigDecimal thBgtAmt3 = new BigDecimal(0);
			
			// 총합계
			BigDecimal stBgtAmt1 = new BigDecimal(0);
			BigDecimal stBgtAmt2 = new BigDecimal(0);
			BigDecimal stBgtAmt3 = new BigDecimal(0);
			
			// 관 소계용 HashMap
			Map<String, Object> subAmt = new HashMap<String, Object>();
			// 합계용 HashMap
			Map<String, Object> totAmt = new HashMap<String, Object>();
			
			for (int i = 0; i < bgtInfoList.size(); i++) {
				Map<String, Object> bgtInfo = bgtInfoList.get(i);
				String bgtCd = (String) bgtInfo.get("bgtCd");
				
				// 현재 관 예산코드 및 명
				hBgtCd = (String) bgtInfo.get("hBgtCd");
				hBgtNm = (String) bgtInfo.get("hBgtNm");
				
				Map<String, Object> bodyMap = new HashMap<String, Object>();
				bodyMap.put("bgtCd",  bgtCd);
				bodyMap.put("hBgtCd", hBgtCd);
				bodyMap.put("hBgtNm", bgtInfo.get("hBgtNm"));
				bodyMap.put("bgtNm",  bgtInfo.get("bgtNm"));
				
				BigDecimal totAmt1 = new BigDecimal(0);
				BigDecimal totAmt2 = new BigDecimal(0);
				BigDecimal totAmt3 = new BigDecimal(0);
				
				// 데이터가 달라지면 소계 필드 추가
				if (!"".equals(bhBgtCd) && !hBgtCd.equals(bhBgtCd)) {
					subAmt.put("bgtCd",  "000000");
					subAmt.put("hBgtCd", bhBgtCd);
					subAmt.put("hBgtNm", bhBgtNm);
					subAmt.put("bgtNm",  "");

					// 관용 소계 합계 필드
					subAmt.put(bhBgtCd + "_1", thBgtAmt1);
					subAmt.put(bhBgtCd + "_2", thBgtAmt2);
					subAmt.put(bhBgtCd + "_3", thBgtAmt3);
					
					thBgtAmt1 = new BigDecimal(0);
					thBgtAmt2 = new BigDecimal(0);
					thBgtAmt3 = new BigDecimal(0);
					
					// 관 소계 데이터 추가 
					budgetMap.add(subAmt);
					
					// 관 소계 데이터 초기화
					subAmt = new HashMap<String, Object>();
				}
				
				for (int j = 0; j < pjtBtmList.size(); j++) {
					Map<String, Object> pjtBtm  = pjtBtmList.get(j);
					
					String pjtCd = (String) pjtBtm.get("pjtCd");
					String btmCd = (String) pjtBtm.get("btmCd");
					
					// 프로젝트, 하위사업, 예산계정에 맞는 예산액, 집행액 조회
					Map<String, Object> budgetInfo = getBudgetInfo(budgetList, pjtCd, btmCd, bgtCd);
					
					BigDecimal bgtAm1 = new BigDecimal(0);
					BigDecimal bgtAm2 = new BigDecimal(0);
					if (budgetInfo != null && budgetInfo.size() > 0) {
						bgtAm1 = (BigDecimal) budgetInfo.get("BGT_AM1");
						bgtAm2 = (BigDecimal) budgetInfo.get("BGT_AM2");
					}
					
					// 항 금액 필드
					String bgtKey = pjtCd + "_" + btmCd + "_" + bgtCd;
					bodyMap.put(bgtKey + "_1", bgtAm1);
					bodyMap.put(bgtKey + "_2", bgtAm2);
					bodyMap.put(bgtKey + "_3", bgtAm1.add(bgtAm2));
					
					// 소계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					
					// 관소계 합계 편성금액
					String hBgtKey = pjtCd + "_" + btmCd + "_" + hBgtCd;
					if (subAmt.get(hBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) subAmt.get(hBgtKey + "_1");
					}
					
					// 관소계 합계 추가금액
					if (subAmt.get(hBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) subAmt.get(hBgtKey + "_2");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) subAmt.get(hBgtKey + "_3");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1);
					hBgtAmt2 = hBgtAmt2.add(bgtAm2);
					hBgtAmt3 = hBgtAmt3.add(bgtAm1.add(bgtAm2));
					
					// 관용 소계 필드
					subAmt.put(hBgtKey + "_1", hBgtAmt1);
					subAmt.put(hBgtKey + "_2", hBgtAmt2);
					subAmt.put(hBgtKey + "_3", hBgtAmt3);
					
					// 합계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					
					// 편성금액 합계금액 (프로젝트 + 하위사업코드)
					String thBgtKey = pjtCd + "_" + btmCd;
					if (totAmt.get(thBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) totAmt.get(thBgtKey + "_1");
					}
					
					// 조정금액 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) totAmt.get(thBgtKey + "_2");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) totAmt.get(thBgtKey + "_3");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1);
					hBgtAmt2 = hBgtAmt2.add(bgtAm2);
					hBgtAmt3 = hBgtAmt3.add(bgtAm1.add(bgtAm2));
					
					// 합계 필드
					totAmt.put(thBgtKey + "_1", hBgtAmt1);
					totAmt.put(thBgtKey + "_2", hBgtAmt2);
					totAmt.put(thBgtKey + "_3", hBgtAmt3);
					
					// 총액 계산
					totAmt1 = totAmt1.add(bgtAm1);
					totAmt2 = totAmt2.add(bgtAm2);
					totAmt3 = totAmt3.add(bgtAm1.add(bgtAm2));
				}
				
				// 소계 저장
				thBgtAmt1 = thBgtAmt1.add(totAmt1);
				thBgtAmt2 = thBgtAmt2.add(totAmt2);
				thBgtAmt3 = thBgtAmt3.add(totAmt3);
				
				// 합계 저장
				stBgtAmt1 = stBgtAmt1.add(totAmt1);
				stBgtAmt2 = stBgtAmt2.add(totAmt2);
				stBgtAmt3 = stBgtAmt3.add(totAmt3);
				
				// 총액 저장
				bodyMap.put("totAmt1", totAmt1);
				bodyMap.put("totAmt2", totAmt2);
				bodyMap.put("totAmt3", totAmt3);
				
				// 총액 초기화
				totAmt1 = new BigDecimal(0);
				totAmt2 = new BigDecimal(0);
				totAmt3 = new BigDecimal(0);
				
				budgetMap.add(bodyMap);
				
				// 이전 관 예산코드 및 명
				bhBgtCd = (String) bgtInfo.get("hBgtCd");
				bhBgtNm = (String) bgtInfo.get("hBgtNm");
			}

			// 마지막 관용 소계 합계 필드
			subAmt.put(hBgtCd + "_1", thBgtAmt1);
			subAmt.put(hBgtCd + "_2", thBgtAmt2);
			subAmt.put(hBgtCd + "_3", thBgtAmt3);

			// 마지막 소계필드 추가
			subAmt.put("bgtCd",  "000000");
			subAmt.put("hBgtNm", hBgtNm);
			subAmt.put("hBgtCd", hBgtCd);
			subAmt.put("bgtNm",  "");
			
			budgetMap.add(subAmt);
			
			// 합계 필드
			totAmt.put("totAmt1", stBgtAmt1);
			totAmt.put("totAmt2", stBgtAmt2);
			totAmt.put("totAmt3", stBgtAmt3);
			
			// 합계 필드 추가
			totAmt.put("bgtCd",  "999999");
			totAmt.put("hBgtNm", "");
			totAmt.put("hBgtCd", "");
			totAmt.put("bgtNm",  "");
			
			budgetMap.add(totAmt);
			
			model.addAttribute("mainList", budgetMap);
		}

		model.addAttribute("bgtInfoList", bgtInfoList);
		model.addAttribute("pjtInfoList", pjtInfoList);
		model.addAttribute("pjtBtmList",  pjtBtmList);
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename=BudgetStatus.xls");
		
		return "/budget/bgtBudgetListExcel";
		
	}
	
	/**
	 * 예산과목별 예산편성 현황
	 */
	@RequestMapping(value = "/budget/exeBudgetList")
	public String exeBudgetList
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("bgtBudgetList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도
		
		String pDivCd   = Objects.toString(map.get("divCd"),   "");
		String pDivNm   = Objects.toString(map.get("divNm"),   "");
		String pDeptSeq = Objects.toString(map.get("deptSeq"), "");
		String pDeptNm  = Objects.toString(map.get("deptNm"),  "");
		String pPjtCd   = Objects.toString(map.get("pjtCd"),   "");
		String pPjtNm   = Objects.toString(map.get("pjtNm"),   "");
		String pBtmCd   = Objects.toString(map.get("btmCd"),   "");
		String pBtmNm   = Objects.toString(map.get("btmNm"),   "");
		
		if (!"Y".equals(map.get("search"))) {
			pDeptSeq = loginVO.getOrgnztId();
			pDeptNm  = loginVO.getOrgnztNm();
		}
		
		model.addAttribute("reqYear", reqYear);
		model.addAttribute("divCd",   pDivCd);
		model.addAttribute("divNm",   pDivNm);
		model.addAttribute("deptSeq", pDeptSeq);
		model.addAttribute("deptNm",  pDeptNm);
		model.addAttribute("pjtCd",   pPjtCd);
		model.addAttribute("pjtNm",   pPjtNm);
		model.addAttribute("btmCd",   pBtmCd);
		model.addAttribute("btmNm",   pBtmNm);
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   pDivCd);
		paraMap.put("deptSeq", pDeptSeq);
		paraMap.put("ymFrom",  Objects.toString(map.get("reqYear"), reqYear) + "01");
		paraMap.put("ymTo",    Objects.toString(map.get("reqYear"), reqYear) + "12");
		paraMap.put("pjtCd",   pPjtCd);
		paraMap.put("btmCd",   pBtmCd);
		
		List<Map<String, Object>> pjtBtmList  = budgetService.mapPjtBtmList(conVo, paraMap);
		List<Map<String, Object>> bgtInfoList = budgetService.mapBgtInfoList(conVo, paraMap);
		List<Map<String, Object>> pjtInfoList = budgetService.pjtInfoList(conVo, paraMap);
		
		// 검색버튼을 눌렀을때만 동작함
		if ("Y".equals(map.get("search"))) {
			List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> budgetList = budgetService.getBudgetDataList(conVo, paraMap);
			
			String hBgtCd = "";
			String hBgtNm = "";
			String bhBgtCd = "";
			String bhBgtNm = "";
			
			// 관 소계용 변수
			BigDecimal hBgtAmt1 = new BigDecimal(0);
			BigDecimal hBgtAmt2 = new BigDecimal(0);
			BigDecimal hBgtAmt3 = new BigDecimal(0);
			BigDecimal hBgtAmt4 = new BigDecimal(0);
			BigDecimal hBgtAmt5 = new BigDecimal(0);
			BigDecimal hBgtAmt6 = new BigDecimal(0);
			BigDecimal hBgtAmt7 = new BigDecimal(0);
			
			// 관 소계용 합계
			BigDecimal thBgtAmt1 = new BigDecimal(0);
			BigDecimal thBgtAmt2 = new BigDecimal(0);
			BigDecimal thBgtAmt3 = new BigDecimal(0);
			BigDecimal thBgtAmt4 = new BigDecimal(0);
			BigDecimal thBgtAmt5 = new BigDecimal(0);
			BigDecimal thBgtAmt6 = new BigDecimal(0);
			BigDecimal thBgtAmt7 = new BigDecimal(0);
			
			// 총합계
			BigDecimal stBgtAmt1 = new BigDecimal(0);
			BigDecimal stBgtAmt2 = new BigDecimal(0);
			BigDecimal stBgtAmt3 = new BigDecimal(0);
			BigDecimal stBgtAmt4 = new BigDecimal(0);
			BigDecimal stBgtAmt5 = new BigDecimal(0);
			BigDecimal stBgtAmt6 = new BigDecimal(0);
			BigDecimal stBgtAmt7 = new BigDecimal(0);
			
			// 관 소계용 HashMap
			Map<String, Object> subAmt = new HashMap<String, Object>();
			// 합계용 HashMap
			Map<String, Object> totAmt = new HashMap<String, Object>();
			
			for (int i = 0; i < bgtInfoList.size(); i++) {
				Map<String, Object> bgtInfo = bgtInfoList.get(i);
				String bgtCd = (String) bgtInfo.get("bgtCd");
				
				// 현재 관 예산코드 및 명
				hBgtCd = (String) bgtInfo.get("hBgtCd");
				hBgtNm = (String) bgtInfo.get("hBgtNm");
				
				Map<String, Object> bodyMap = new HashMap<String, Object>();
				bodyMap.put("bgtCd",  bgtCd);
				bodyMap.put("hBgtCd", hBgtCd);
				bodyMap.put("hBgtNm", bgtInfo.get("hBgtNm"));
				bodyMap.put("bgtNm",  bgtInfo.get("bgtNm"));
				
				BigDecimal totAmt1 = new BigDecimal(0);
				BigDecimal totAmt2 = new BigDecimal(0);
				BigDecimal totAmt3 = new BigDecimal(0);
				BigDecimal totAmt4 = new BigDecimal(0);
				BigDecimal totAmt5 = new BigDecimal(0);
				BigDecimal totAmt6 = new BigDecimal(0);
				BigDecimal totAmt7 = new BigDecimal(0);
				
				// 데이터가 달라지면 소계 필드 추가
				if (!"".equals(bhBgtCd) && !hBgtCd.equals(bhBgtCd)) {
					subAmt.put("bgtCd",  "000000");
					subAmt.put("hBgtCd", bhBgtCd);
					subAmt.put("hBgtNm", bhBgtNm);
					subAmt.put("bgtNm",  "");

					// 관용 소계 합계 필드
					subAmt.put(bhBgtCd + "_1", thBgtAmt1);
					subAmt.put(bhBgtCd + "_2", thBgtAmt2);
					subAmt.put(bhBgtCd + "_3", thBgtAmt3);
					subAmt.put(bhBgtCd + "_4", thBgtAmt4);
					subAmt.put(bhBgtCd + "_5", thBgtAmt5);
					subAmt.put(bhBgtCd + "_6", thBgtAmt6);
					subAmt.put(bhBgtCd + "_7", thBgtAmt7);
					
					thBgtAmt1 = new BigDecimal(0);
					thBgtAmt2 = new BigDecimal(0);
					thBgtAmt3 = new BigDecimal(0);
					thBgtAmt4 = new BigDecimal(0);
					thBgtAmt5 = new BigDecimal(0);
					thBgtAmt6 = new BigDecimal(0);
					thBgtAmt7 = new BigDecimal(0);
					
					// 관 소계 데이터 추가 
					budgetMap.add(subAmt);
					
					// 관 소계 데이터 초기화
					subAmt = new HashMap<String, Object>();
				}
				
				for (int j = 0; j < pjtBtmList.size(); j++) {
					Map<String, Object> pjtBtm  = pjtBtmList.get(j);
					
					String pjtCd = (String) pjtBtm.get("pjtCd");
					String btmCd = (String) pjtBtm.get("btmCd");
					
					// 프로젝트, 하위사업, 예산계정에 맞는 예산액, 집행액 조회
					Map<String, Object> budgetInfo = getBudgetInfo(budgetList, pjtCd, btmCd, bgtCd);
					
					BigDecimal bgtAm1   = new BigDecimal(0);
					BigDecimal bgtAm2   = new BigDecimal(0);
					BigDecimal applyAm1 = new BigDecimal(0);
					BigDecimal applyAm2 = new BigDecimal(0);
					BigDecimal janAm1   = new BigDecimal(0);
					BigDecimal janAm2   = new BigDecimal(0);
					BigDecimal janRate1 = new BigDecimal(0);
					BigDecimal janRate2 = new BigDecimal(0);
					
					if (budgetInfo != null && budgetInfo.size() > 0) {
						Map<String, Object> param = new HashMap<String, Object>();
						
						param.put("coCd",   budgetInfo.get("CO_CD"));
						param.put("bgtYm", ((String) budgetInfo.get("BGT_YM")).substring(0, 4));
						param.put("divCd",  budgetInfo.get("DIV_CD"));
						param.put("pjtCd",  budgetInfo.get("MGT_CD"));
						param.put("btmCd",  budgetInfo.get("BOTTOM_CD"));
						param.put("bgtCd",  budgetInfo.get("BGT_CD"));
						
						Map<String, Object> preBudgetInfo = budgetService.getPreBudgetInfo(param);
						
						// 품의액
						if (preBudgetInfo != null) {
							applyAm1 = (BigDecimal) preBudgetInfo.get("applyAm");
						}
						
						bgtAm1   = (BigDecimal) budgetInfo.get("BGT_AM1");   // 편성액
						bgtAm2   = (BigDecimal) budgetInfo.get("BGT_AM2");   // 조정액
						applyAm2 = (BigDecimal) budgetInfo.get("APPLY_AM2"); // 결의액
						janAm1   = bgtAm1.add(bgtAm2).subtract(applyAm1).subtract(applyAm2); // 품의기준 잔액
						janAm2   = bgtAm1.add(bgtAm2).subtract(applyAm2);    // 결의기준 잔액
						
						if ((bgtAm1.add(bgtAm2).compareTo(new BigDecimal(0)) == 0)) {
							janRate1 = new BigDecimal(0);
							janRate2 = new BigDecimal(0);
						}
						else {
							janRate1 = janAm1.divide(bgtAm1.add(bgtAm2), 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
							janRate2 = janAm2.divide(bgtAm1.add(bgtAm2), 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
						}
					}
					
					// 항 금액 필드
					String bgtKey = pjtCd + "_" + btmCd + "_" + bgtCd;
					bodyMap.put(bgtKey + "_1", bgtAm1.add(bgtAm2));
					bodyMap.put(bgtKey + "_2", applyAm1);
					bodyMap.put(bgtKey + "_3", applyAm2);
					bodyMap.put(bgtKey + "_4", janAm1);
					bodyMap.put(bgtKey + "_5", janRate1);
					bodyMap.put(bgtKey + "_6", janAm2);
					bodyMap.put(bgtKey + "_7", janRate2);
					
					// 소계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					hBgtAmt4 = new BigDecimal(0);
					hBgtAmt5 = new BigDecimal(0);
					hBgtAmt6 = new BigDecimal(0);
					hBgtAmt7 = new BigDecimal(0);
					
					// 관소계 합계 편성금액
					String hBgtKey = pjtCd + "_" + btmCd + "_" + hBgtCd;
					if (subAmt.get(hBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) subAmt.get(hBgtKey + "_1");
					}
					
					// 관소계 합계 추가금액
					if (subAmt.get(hBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) subAmt.get(hBgtKey + "_2");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) subAmt.get(hBgtKey + "_3");
					}
					
					if (subAmt.get(hBgtKey + "_4") != null) {
						hBgtAmt4 = (BigDecimal) subAmt.get(hBgtKey + "_4");
					}
					
					// 관소계 합계 추가금액
					if (subAmt.get(hBgtKey + "_5") != null) {
						hBgtAmt5 = (BigDecimal) subAmt.get(hBgtKey + "_5");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_6") != null) {
						hBgtAmt6 = (BigDecimal) subAmt.get(hBgtKey + "_6");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_7") != null) {
						hBgtAmt7 = (BigDecimal) subAmt.get(hBgtKey + "_7");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1.add(bgtAm2));
					hBgtAmt2 = hBgtAmt2.add(applyAm1);
					hBgtAmt3 = hBgtAmt3.add(applyAm2);
					hBgtAmt4 = hBgtAmt4.add(janAm1);
					hBgtAmt6 = hBgtAmt6.add(janAm2);
					
					if ((hBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
						hBgtAmt5 = new BigDecimal(0);
						hBgtAmt7 = new BigDecimal(0);
					}
					else {
						hBgtAmt5 = hBgtAmt4.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
						hBgtAmt7 = hBgtAmt6.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
					}
					
					// 관용 소계 필드
					subAmt.put(hBgtKey + "_1", hBgtAmt1);
					subAmt.put(hBgtKey + "_2", hBgtAmt2);
					subAmt.put(hBgtKey + "_3", hBgtAmt3);
					subAmt.put(hBgtKey + "_4", hBgtAmt4);
					subAmt.put(hBgtKey + "_5", hBgtAmt5);
					subAmt.put(hBgtKey + "_6", hBgtAmt6);
					subAmt.put(hBgtKey + "_7", hBgtAmt7);
					
					// 합계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					hBgtAmt4 = new BigDecimal(0);
					hBgtAmt5 = new BigDecimal(0);
					hBgtAmt6 = new BigDecimal(0);
					hBgtAmt7 = new BigDecimal(0);
					
					// 편성금액 합계금액 (프로젝트 + 하위사업코드)
					String thBgtKey = pjtCd + "_" + btmCd;
					if (totAmt.get(thBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) totAmt.get(thBgtKey + "_1");
					}
					
					// 조정금액 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) totAmt.get(thBgtKey + "_2");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) totAmt.get(thBgtKey + "_3");
					}
					
					if (totAmt.get(thBgtKey + "_4") != null) {
						hBgtAmt4 = (BigDecimal) totAmt.get(thBgtKey + "_4");
					}
					
					// 조정금액 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_5") != null) {
						hBgtAmt5 = (BigDecimal) totAmt.get(thBgtKey + "_5");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_6") != null) {
						hBgtAmt6 = (BigDecimal) totAmt.get(thBgtKey + "_6");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_7") != null) {
						hBgtAmt7 = (BigDecimal) totAmt.get(thBgtKey + "_7");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1.add(bgtAm2));
					hBgtAmt2 = hBgtAmt2.add(applyAm1);
					hBgtAmt3 = hBgtAmt3.add(applyAm2);
					hBgtAmt4 = hBgtAmt4.add(janAm1);
					hBgtAmt6 = hBgtAmt6.add(janAm2);
					
					if ((hBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
						hBgtAmt5 = new BigDecimal(0);
						hBgtAmt7 = new BigDecimal(0);
					}
					else {
						hBgtAmt5 = hBgtAmt4.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
						hBgtAmt7 = hBgtAmt6.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
					}
					
					// 합계 필드
					totAmt.put(thBgtKey + "_1", hBgtAmt1);
					totAmt.put(thBgtKey + "_2", hBgtAmt2);
					totAmt.put(thBgtKey + "_3", hBgtAmt3);
					totAmt.put(thBgtKey + "_4", hBgtAmt4);
					totAmt.put(thBgtKey + "_5", hBgtAmt5);
					totAmt.put(thBgtKey + "_6", hBgtAmt6);
					totAmt.put(thBgtKey + "_7", hBgtAmt7);
					
					// 총액 계산
					totAmt1 = totAmt1.add(bgtAm1.add(bgtAm2));
					totAmt2 = totAmt2.add(applyAm1);
					totAmt3 = totAmt3.add(applyAm2);
					totAmt4 = totAmt4.add(janAm1);
					totAmt6 = totAmt6.add(janAm2);
					
					if ((totAmt1.compareTo(new BigDecimal(0)) == 0)) {
						totAmt5 = new BigDecimal(0);
						totAmt7 = new BigDecimal(0);
					}
					else {
						totAmt5 = totAmt4.divide(totAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
						totAmt7 = totAmt6.divide(totAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
					}
				}
				
				// 소계 저장
				thBgtAmt1 = thBgtAmt1.add(totAmt1);
				thBgtAmt2 = thBgtAmt2.add(totAmt2);
				thBgtAmt3 = thBgtAmt3.add(totAmt3);
				thBgtAmt4 = thBgtAmt1.subtract(thBgtAmt2).subtract(thBgtAmt3);
				thBgtAmt6 = thBgtAmt1.subtract(thBgtAmt3);
				
				if ((thBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
					thBgtAmt5 = new BigDecimal(0);
					thBgtAmt7 = new BigDecimal(0);
				}
				else {
					thBgtAmt5 = thBgtAmt4.divide(thBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
					thBgtAmt7 = thBgtAmt6.divide(thBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
				}
				
				// 합계 저장
				stBgtAmt1 = stBgtAmt1.add(totAmt1);
				stBgtAmt2 = stBgtAmt2.add(totAmt2);
				stBgtAmt3 = stBgtAmt3.add(totAmt3);
				stBgtAmt4 = stBgtAmt1.subtract(stBgtAmt2).subtract(stBgtAmt3);
				stBgtAmt6 = stBgtAmt1.subtract(stBgtAmt3);
				
				if ((stBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
					stBgtAmt5 = new BigDecimal(0);
					stBgtAmt7 = new BigDecimal(0);
				}
				else {
					stBgtAmt5 = stBgtAmt4.divide(stBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
					stBgtAmt7 = stBgtAmt6.divide(stBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
				}
				
				// 총액 저장
				bodyMap.put("totAmt1", totAmt1);
				bodyMap.put("totAmt2", totAmt2);
				bodyMap.put("totAmt3", totAmt3);
				bodyMap.put("totAmt4", totAmt4);
				bodyMap.put("totAmt5", totAmt5);
				bodyMap.put("totAmt6", totAmt6);
				bodyMap.put("totAmt7", totAmt7);
				
				// 총액 초기화
				totAmt1 = new BigDecimal(0);
				totAmt2 = new BigDecimal(0);
				totAmt3 = new BigDecimal(0);
				totAmt4 = new BigDecimal(0);
				totAmt5 = new BigDecimal(0);
				totAmt6 = new BigDecimal(0);
				totAmt7 = new BigDecimal(0);
				
				budgetMap.add(bodyMap);
				
				// 이전 관 예산코드 및 명
				bhBgtCd = (String) bgtInfo.get("hBgtCd");
				bhBgtNm = (String) bgtInfo.get("hBgtNm");
			}

			// 마지막 관용 소계 합계 필드
			subAmt.put(hBgtCd + "_1", thBgtAmt1);
			subAmt.put(hBgtCd + "_2", thBgtAmt2);
			subAmt.put(hBgtCd + "_3", thBgtAmt3);
			subAmt.put(hBgtCd + "_4", thBgtAmt4);
			subAmt.put(hBgtCd + "_5", thBgtAmt5);
			subAmt.put(hBgtCd + "_6", thBgtAmt6);
			subAmt.put(hBgtCd + "_7", thBgtAmt7);

			// 마지막 소계필드 추가
			subAmt.put("bgtCd",  "000000");
			subAmt.put("hBgtNm", hBgtNm);
			subAmt.put("hBgtCd", hBgtCd);
			subAmt.put("bgtNm",  "");
			
			budgetMap.add(subAmt);
			
			// 합계 필드
			totAmt.put("totAmt1", stBgtAmt1);
			totAmt.put("totAmt2", stBgtAmt2);
			totAmt.put("totAmt3", stBgtAmt3);
			totAmt.put("totAmt4", stBgtAmt4);
			totAmt.put("totAmt5", stBgtAmt5);
			totAmt.put("totAmt6", stBgtAmt6);
			totAmt.put("totAmt7", stBgtAmt7);
			
			// 합계 필드 추가
			totAmt.put("bgtCd",  "999999");
			totAmt.put("hBgtNm", "");
			totAmt.put("hBgtCd", "");
			totAmt.put("bgtNm",  "");
			
			budgetMap.add(totAmt);
			
			model.addAttribute("mainList", budgetMap);
		}

		model.addAttribute("bgtInfoList", bgtInfoList);
		model.addAttribute("pjtInfoList", pjtInfoList);
		model.addAttribute("pjtBtmList",  pjtBtmList);
		
		return "/budget/exeBudgetList";
		
	}
	
	@RequestMapping(value = "/budget/exeBudgetListExcel")
	public String exeBudgetListExcel
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("bgtBudgetListExcel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도

		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   Objects.toString(map.get("divCd"), ""));
		paraMap.put("deptSeq", Objects.toString(map.get("deptSeq"), ""));
		paraMap.put("ymFrom",  Objects.toString(map.get("reqYear"), reqYear) + "01");
		paraMap.put("ymTo",    Objects.toString(map.get("reqYear"), reqYear) + "12");
		paraMap.put("pjtCd",   Objects.toString(map.get("pjtCd"), ""));
		paraMap.put("btmCd",   Objects.toString(map.get("btmCd"), ""));
		
		List<Map<String, Object>> pjtBtmList  = budgetService.mapPjtBtmList(conVo, paraMap);
		List<Map<String, Object>> bgtInfoList = budgetService.mapBgtInfoList(conVo, paraMap);
		List<Map<String, Object>> pjtInfoList = budgetService.pjtInfoList(conVo, paraMap);
		
		// 검색버튼을 눌렀을때만 동작함
		if ("Y".equals(map.get("search"))) {
			List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> budgetList = budgetService.getBudgetDataList(conVo, paraMap);
			
			String hBgtCd = "";
			String hBgtNm = "";
			String bhBgtCd = "";
			String bhBgtNm = "";
			
			// 관 소계용 변수
			BigDecimal hBgtAmt1 = new BigDecimal(0);
			BigDecimal hBgtAmt2 = new BigDecimal(0);
			BigDecimal hBgtAmt3 = new BigDecimal(0);
			BigDecimal hBgtAmt4 = new BigDecimal(0);
			BigDecimal hBgtAmt5 = new BigDecimal(0);
			BigDecimal hBgtAmt6 = new BigDecimal(0);
			BigDecimal hBgtAmt7 = new BigDecimal(0);
			
			// 관 소계용 합계
			BigDecimal thBgtAmt1 = new BigDecimal(0);
			BigDecimal thBgtAmt2 = new BigDecimal(0);
			BigDecimal thBgtAmt3 = new BigDecimal(0);
			BigDecimal thBgtAmt4 = new BigDecimal(0);
			BigDecimal thBgtAmt5 = new BigDecimal(0);
			BigDecimal thBgtAmt6 = new BigDecimal(0);
			BigDecimal thBgtAmt7 = new BigDecimal(0);
			
			// 총합계
			BigDecimal stBgtAmt1 = new BigDecimal(0);
			BigDecimal stBgtAmt2 = new BigDecimal(0);
			BigDecimal stBgtAmt3 = new BigDecimal(0);
			BigDecimal stBgtAmt4 = new BigDecimal(0);
			BigDecimal stBgtAmt5 = new BigDecimal(0);
			BigDecimal stBgtAmt6 = new BigDecimal(0);
			BigDecimal stBgtAmt7 = new BigDecimal(0);
			
			// 관 소계용 HashMap
			Map<String, Object> subAmt = new HashMap<String, Object>();
			// 합계용 HashMap
			Map<String, Object> totAmt = new HashMap<String, Object>();
			
			for (int i = 0; i < bgtInfoList.size(); i++) {
				Map<String, Object> bgtInfo = bgtInfoList.get(i);
				String bgtCd = (String) bgtInfo.get("bgtCd");
				
				// 현재 관 예산코드 및 명
				hBgtCd = (String) bgtInfo.get("hBgtCd");
				hBgtNm = (String) bgtInfo.get("hBgtNm");
				
				Map<String, Object> bodyMap = new HashMap<String, Object>();
				bodyMap.put("bgtCd",  bgtCd);
				bodyMap.put("hBgtCd", hBgtCd);
				bodyMap.put("hBgtNm", bgtInfo.get("hBgtNm"));
				bodyMap.put("bgtNm",  bgtInfo.get("bgtNm"));
				
				BigDecimal totAmt1 = new BigDecimal(0);
				BigDecimal totAmt2 = new BigDecimal(0);
				BigDecimal totAmt3 = new BigDecimal(0);
				BigDecimal totAmt4 = new BigDecimal(0);
				BigDecimal totAmt5 = new BigDecimal(0);
				BigDecimal totAmt6 = new BigDecimal(0);
				BigDecimal totAmt7 = new BigDecimal(0);
				
				// 데이터가 달라지면 소계 필드 추가
				if (!"".equals(bhBgtCd) && !hBgtCd.equals(bhBgtCd)) {
					subAmt.put("bgtCd",  "000000");
					subAmt.put("hBgtCd", bhBgtCd);
					subAmt.put("hBgtNm", bhBgtNm);
					subAmt.put("bgtNm",  "");

					// 관용 소계 합계 필드
					subAmt.put(bhBgtCd + "_1", thBgtAmt1);
					subAmt.put(bhBgtCd + "_2", thBgtAmt2);
					subAmt.put(bhBgtCd + "_3", thBgtAmt3);
					subAmt.put(bhBgtCd + "_4", thBgtAmt4);
					subAmt.put(bhBgtCd + "_5", thBgtAmt5);
					subAmt.put(bhBgtCd + "_6", thBgtAmt6);
					subAmt.put(bhBgtCd + "_7", thBgtAmt7);
					
					thBgtAmt1 = new BigDecimal(0);
					thBgtAmt2 = new BigDecimal(0);
					thBgtAmt3 = new BigDecimal(0);
					thBgtAmt4 = new BigDecimal(0);
					thBgtAmt5 = new BigDecimal(0);
					thBgtAmt6 = new BigDecimal(0);
					thBgtAmt7 = new BigDecimal(0);
					
					// 관 소계 데이터 추가 
					budgetMap.add(subAmt);
					
					// 관 소계 데이터 초기화
					subAmt = new HashMap<String, Object>();
				}
				
				for (int j = 0; j < pjtBtmList.size(); j++) {
					Map<String, Object> pjtBtm  = pjtBtmList.get(j);
					
					String pjtCd = (String) pjtBtm.get("pjtCd");
					String btmCd = (String) pjtBtm.get("btmCd");
					
					// 프로젝트, 하위사업, 예산계정에 맞는 예산액, 집행액 조회
					Map<String, Object> budgetInfo = getBudgetInfo(budgetList, pjtCd, btmCd, bgtCd);
					
					BigDecimal bgtAm1   = new BigDecimal(0);
					BigDecimal bgtAm2   = new BigDecimal(0);
					BigDecimal applyAm1 = new BigDecimal(0);
					BigDecimal applyAm2 = new BigDecimal(0);
					BigDecimal janAm1   = new BigDecimal(0);
					BigDecimal janAm2   = new BigDecimal(0);
					BigDecimal janRate1 = new BigDecimal(0);
					BigDecimal janRate2 = new BigDecimal(0);
					
					if (budgetInfo != null && budgetInfo.size() > 0) {
						Map<String, Object> param = new HashMap<String, Object>();
						
						param.put("coCd",   budgetInfo.get("CO_CD"));
						param.put("bgtYm", ((String) budgetInfo.get("BGT_YM")).substring(0, 4));
						param.put("divCd",  budgetInfo.get("DIV_CD"));
						param.put("pjtCd",  budgetInfo.get("MGT_CD"));
						param.put("btmCd",  budgetInfo.get("BOTTOM_CD"));
						param.put("bgtCd",  budgetInfo.get("BGT_CD"));
						
						Map<String, Object> preBudgetInfo = budgetService.getPreBudgetInfo(param);
						
						// 품의액
						if (preBudgetInfo != null) {
							applyAm1 = (BigDecimal) preBudgetInfo.get("applyAm");
						}
						
						bgtAm1   = (BigDecimal) budgetInfo.get("BGT_AM1");   // 편성액
						bgtAm2   = (BigDecimal) budgetInfo.get("BGT_AM2");   // 조정액
						applyAm2 = (BigDecimal) budgetInfo.get("APPLY_AM2"); // 결의액
						janAm1   = bgtAm1.add(bgtAm2).subtract(applyAm1).subtract(applyAm2); // 품의기준 잔액
						janAm2   = bgtAm1.add(bgtAm2).subtract(applyAm2);    // 결의기준 잔액
						
						if ((bgtAm1.add(bgtAm2).compareTo(new BigDecimal(0)) == 0)) {
							janRate1 = new BigDecimal(0);
							janRate2 = new BigDecimal(0);
						}
						else {
							janRate1 = janAm1.divide(bgtAm1.add(bgtAm2), 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
							janRate2 = janAm2.divide(bgtAm1.add(bgtAm2), 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
						}
					}
					
					// 항 금액 필드
					String bgtKey = pjtCd + "_" + btmCd + "_" + bgtCd;
					bodyMap.put(bgtKey + "_1", bgtAm1.add(bgtAm2));
					bodyMap.put(bgtKey + "_2", applyAm1);
					bodyMap.put(bgtKey + "_3", applyAm2);
					bodyMap.put(bgtKey + "_4", janAm1);
					bodyMap.put(bgtKey + "_5", janRate1);
					bodyMap.put(bgtKey + "_6", janAm2);
					bodyMap.put(bgtKey + "_7", janRate2);
					
					// 소계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					hBgtAmt4 = new BigDecimal(0);
					hBgtAmt5 = new BigDecimal(0);
					hBgtAmt6 = new BigDecimal(0);
					hBgtAmt7 = new BigDecimal(0);
					
					// 관소계 합계 편성금액
					String hBgtKey = pjtCd + "_" + btmCd + "_" + hBgtCd;
					if (subAmt.get(hBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) subAmt.get(hBgtKey + "_1");
					}
					
					// 관소계 합계 추가금액
					if (subAmt.get(hBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) subAmt.get(hBgtKey + "_2");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) subAmt.get(hBgtKey + "_3");
					}
					
					if (subAmt.get(hBgtKey + "_4") != null) {
						hBgtAmt4 = (BigDecimal) subAmt.get(hBgtKey + "_4");
					}
					
					// 관소계 합계 추가금액
					if (subAmt.get(hBgtKey + "_5") != null) {
						hBgtAmt5 = (BigDecimal) subAmt.get(hBgtKey + "_5");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_6") != null) {
						hBgtAmt6 = (BigDecimal) subAmt.get(hBgtKey + "_6");
					}
					
					// 관소계 합계 합계금액
					if (subAmt.get(hBgtKey + "_7") != null) {
						hBgtAmt7 = (BigDecimal) subAmt.get(hBgtKey + "_7");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1.add(bgtAm2));
					hBgtAmt2 = hBgtAmt2.add(applyAm1);
					hBgtAmt3 = hBgtAmt3.add(applyAm2);
					hBgtAmt4 = hBgtAmt4.add(janAm1);
					hBgtAmt6 = hBgtAmt6.add(janAm2);
					
					if ((hBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
						hBgtAmt5 = new BigDecimal(0);
						hBgtAmt7 = new BigDecimal(0);
					}
					else {
						hBgtAmt5 = hBgtAmt4.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
						hBgtAmt7 = hBgtAmt6.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
					}
					
					// 관용 소계 필드
					subAmt.put(hBgtKey + "_1", hBgtAmt1);
					subAmt.put(hBgtKey + "_2", hBgtAmt2);
					subAmt.put(hBgtKey + "_3", hBgtAmt3);
					subAmt.put(hBgtKey + "_4", hBgtAmt4);
					subAmt.put(hBgtKey + "_5", hBgtAmt5);
					subAmt.put(hBgtKey + "_6", hBgtAmt6);
					subAmt.put(hBgtKey + "_7", hBgtAmt7);
					
					// 합계 금액 변수 초기화
					hBgtAmt1 = new BigDecimal(0);
					hBgtAmt2 = new BigDecimal(0);
					hBgtAmt3 = new BigDecimal(0);
					hBgtAmt4 = new BigDecimal(0);
					hBgtAmt5 = new BigDecimal(0);
					hBgtAmt6 = new BigDecimal(0);
					hBgtAmt7 = new BigDecimal(0);
					
					// 편성금액 합계금액 (프로젝트 + 하위사업코드)
					String thBgtKey = pjtCd + "_" + btmCd;
					if (totAmt.get(thBgtKey + "_1") != null) {
						hBgtAmt1 = (BigDecimal) totAmt.get(thBgtKey + "_1");
					}
					
					// 조정금액 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_2") != null) {
						hBgtAmt2 = (BigDecimal) totAmt.get(thBgtKey + "_2");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_3") != null) {
						hBgtAmt3 = (BigDecimal) totAmt.get(thBgtKey + "_3");
					}
					
					if (totAmt.get(thBgtKey + "_4") != null) {
						hBgtAmt4 = (BigDecimal) totAmt.get(thBgtKey + "_4");
					}
					
					// 조정금액 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_5") != null) {
						hBgtAmt5 = (BigDecimal) totAmt.get(thBgtKey + "_5");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_6") != null) {
						hBgtAmt6 = (BigDecimal) totAmt.get(thBgtKey + "_6");
					}
					
					// 합계금액 (프로젝트 + 하위사업코드)
					if (totAmt.get(thBgtKey + "_7") != null) {
						hBgtAmt7 = (BigDecimal) totAmt.get(thBgtKey + "_7");
					}
					
					hBgtAmt1 = hBgtAmt1.add(bgtAm1.add(bgtAm2));
					hBgtAmt2 = hBgtAmt2.add(applyAm1);
					hBgtAmt3 = hBgtAmt3.add(applyAm2);
					hBgtAmt4 = hBgtAmt4.add(janAm1);
					hBgtAmt6 = hBgtAmt6.add(janAm2);
					
					if ((hBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
						hBgtAmt5 = new BigDecimal(0);
						hBgtAmt7 = new BigDecimal(0);
					}
					else {
						hBgtAmt5 = hBgtAmt4.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
						hBgtAmt7 = hBgtAmt6.divide(hBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
					}
					
					// 합계 필드
					totAmt.put(thBgtKey + "_1", hBgtAmt1);
					totAmt.put(thBgtKey + "_2", hBgtAmt2);
					totAmt.put(thBgtKey + "_3", hBgtAmt3);
					totAmt.put(thBgtKey + "_4", hBgtAmt4);
					totAmt.put(thBgtKey + "_5", hBgtAmt5);
					totAmt.put(thBgtKey + "_6", hBgtAmt6);
					totAmt.put(thBgtKey + "_7", hBgtAmt7);
					
					// 총액 계산
					totAmt1 = totAmt1.add(bgtAm1.add(bgtAm2));
					totAmt2 = totAmt2.add(applyAm1);
					totAmt3 = totAmt3.add(applyAm2);
					totAmt4 = totAmt4.add(janAm1);
					totAmt6 = totAmt6.add(janAm2);
					
					if ((totAmt1.compareTo(new BigDecimal(0)) == 0)) {
						totAmt5 = new BigDecimal(0);
						totAmt7 = new BigDecimal(0);
					}
					else {
						totAmt5 = totAmt4.divide(totAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
						totAmt7 = totAmt6.divide(totAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
					}
				}
				
				// 소계 저장
				thBgtAmt1 = thBgtAmt1.add(totAmt1);
				thBgtAmt2 = thBgtAmt2.add(totAmt2);
				thBgtAmt3 = thBgtAmt3.add(totAmt3);
				thBgtAmt4 = thBgtAmt1.subtract(thBgtAmt2).subtract(thBgtAmt3);
				thBgtAmt6 = thBgtAmt1.subtract(thBgtAmt3);
				
				if ((thBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
					thBgtAmt5 = new BigDecimal(0);
					thBgtAmt7 = new BigDecimal(0);
				}
				else {
					thBgtAmt5 = thBgtAmt4.divide(thBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
					thBgtAmt7 = thBgtAmt6.divide(thBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
				}
				
				// 합계 저장
				stBgtAmt1 = stBgtAmt1.add(totAmt1);
				stBgtAmt2 = stBgtAmt2.add(totAmt2);
				stBgtAmt3 = stBgtAmt3.add(totAmt3);
				stBgtAmt4 = stBgtAmt1.subtract(stBgtAmt2).subtract(stBgtAmt2);
				stBgtAmt6 = stBgtAmt1.subtract(stBgtAmt3);
				
				if ((stBgtAmt1.compareTo(new BigDecimal(0)) == 0)) {
					stBgtAmt5 = new BigDecimal(0);
					stBgtAmt7 = new BigDecimal(0);
				}
				else {
					stBgtAmt5 = stBgtAmt4.divide(stBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 품의기준 잔액 비율
					stBgtAmt7 = stBgtAmt6.divide(stBgtAmt1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)); // 결의기준 잔액 비율
				}
				
				// 총액 저장
				bodyMap.put("totAmt1", totAmt1);
				bodyMap.put("totAmt2", totAmt2);
				bodyMap.put("totAmt3", totAmt3);
				bodyMap.put("totAmt4", totAmt4);
				bodyMap.put("totAmt5", totAmt5);
				bodyMap.put("totAmt6", totAmt6);
				bodyMap.put("totAmt7", totAmt7);
				
				// 총액 초기화
				totAmt1 = new BigDecimal(0);
				totAmt2 = new BigDecimal(0);
				totAmt3 = new BigDecimal(0);
				totAmt4 = new BigDecimal(0);
				totAmt5 = new BigDecimal(0);
				totAmt6 = new BigDecimal(0);
				totAmt7 = new BigDecimal(0);
				
				budgetMap.add(bodyMap);
				
				// 이전 관 예산코드 및 명
				bhBgtCd = (String) bgtInfo.get("hBgtCd");
				bhBgtNm = (String) bgtInfo.get("hBgtNm");
			}

			// 마지막 관용 소계 합계 필드
			subAmt.put(hBgtCd + "_1", thBgtAmt1);
			subAmt.put(hBgtCd + "_2", thBgtAmt2);
			subAmt.put(hBgtCd + "_3", thBgtAmt3);
			subAmt.put(hBgtCd + "_4", thBgtAmt4);
			subAmt.put(hBgtCd + "_5", thBgtAmt5);
			subAmt.put(hBgtCd + "_6", thBgtAmt6);
			subAmt.put(hBgtCd + "_7", thBgtAmt7);

			// 마지막 소계필드 추가
			subAmt.put("bgtCd",  "000000");
			subAmt.put("hBgtNm", hBgtNm);
			subAmt.put("hBgtCd", hBgtCd);
			subAmt.put("bgtNm",  "");
			
			budgetMap.add(subAmt);
			
			// 합계 필드
			totAmt.put("totAmt1", stBgtAmt1);
			totAmt.put("totAmt2", stBgtAmt2);
			totAmt.put("totAmt3", stBgtAmt3);
			totAmt.put("totAmt4", stBgtAmt4);
			totAmt.put("totAmt5", stBgtAmt5);
			totAmt.put("totAmt6", stBgtAmt6);
			totAmt.put("totAmt7", stBgtAmt7);
			
			// 합계 필드 추가
			totAmt.put("bgtCd",  "999999");
			totAmt.put("hBgtNm", "");
			totAmt.put("hBgtCd", "");
			totAmt.put("bgtNm",  "");
			
			budgetMap.add(totAmt);
			
			model.addAttribute("mainList", budgetMap);
		}

		model.addAttribute("bgtInfoList", bgtInfoList);
		model.addAttribute("pjtInfoList", pjtInfoList);
		model.addAttribute("pjtBtmList",  pjtBtmList);
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename=BudgetStatus.xls");
		
		return "/budget/exeBudgetListExcel";
		
	}
	
	// 프로젝트, 하위사업, 예산계정에 맞는 예산액, 집행액 리턴
	private Map<String, Object> getBudgetInfo
	(
		  List<Map<String, Object>> budgetList
		, String pjtCd
		, String btmCd
		, String bgtCd
	) {
		for (int i = 0; i < budgetList.size(); i++) {
			Map<String, Object> budgetInfo = budgetList.get(i);

			// 프로젝트, 하위사업, 예산계정이 같은 경우
			if (pjtCd.equals(budgetInfo.get("MGT_CD"))
			&&  btmCd.equals(budgetInfo.get("BOTTOM_CD"))
			&&  bgtCd.equals(budgetInfo.get("BGT_CD"))) {
				return budgetInfo;
			}
		}
		
		return null;
	}
	
	/**
	 * 예실대비 목록 (사업기준)
	 */
	@RequestMapping(value = "/budget/execBudgetList2", method = RequestMethod.GET)
	public String execBudgetList2
	(
		  @RequestParam Map<String, Object> map
		, HttpServletRequest                request
		, HttpServletResponse               response
		, ModelMap                          model
	) throws Exception {
		
		logger.info("execBudgetList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		String deptSeq = loginVO.getOrgnztId();
		String deptNm  = loginVO.getOrgnztNm();
		
		String reqYear = new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()); // 예산년도
		if (map.get("reqYear") != null && "".equals(map.get("reqYear"))) {
			reqYear = (String) map.get("reqYear");
		}
		
		model.addAttribute("reqYear", reqYear);
		model.addAttribute("deptSeq", deptSeq);
		model.addAttribute("deptNm",  deptNm);
		
		return "/budget/execBudgetList2";
		
	}
	
	@RequestMapping(value = "/budget/execBudgetDataList2")
	@ResponseBody
	public Map<String, Object> execBudgetDataList2(@RequestParam Map<String, Object> map) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		conVo = GetConnection();
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("coCd",    loginVO.getErpCoCd());
		paraMap.put("divCd",   map.get("divCd"));
		
		/* msSql 쿼리 수정 */
		
		//paraMap.put("ymFrom",  map.get("reqYear") + "01");
		//paraMap.put("ymTo",    map.get("reqYear") + "12");
		
		paraMap.put("ymFrom",  map.get("reqMonthFr"));
		paraMap.put("ymTo",    map.get("reqMonthTo"));
		
		/* msSql 쿼리 수정 */
		
		paraMap.put("pjtCd",   map.get("pjtCd"));
		paraMap.put("btmCd",   map.get("btmCd"));
		
		List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> budgetTmp = budgetService.getBudgetDataList2(conVo, paraMap);
		
		for (int i = 0; i < budgetTmp.size(); i++) {
			Map<String, Object> budgetInfo = budgetTmp.get(i);
			
//			if (budgetInfo.get("BGT_NM1") == null || "".equals(budgetInfo.get("BGT_NM1"))) {
//				continue;
//			}
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("coCd",   budgetInfo.get("CO_CD"));
			
			/* mariaDB 쿼리 수정 */
			
//			param.put("bgtYm", ((String) budgetInfo.get("BGT_YM")).substring(0, 4));
			param.put("reqMonthFr", map.get("reqMonthFr"));
			param.put("reqMonthTo", map.get("reqMonthTo"));
			
			/* mariaDB 쿼리 수정 */
			
			param.put("divCd",  budgetInfo.get("DIV_CD"));
			param.put("pjtCd",  budgetInfo.get("MGT_CD"));
			param.put("bgtCd",  budgetInfo.get("BGT_CD"));
			
			Map<String, Object> preBudgetInfo = budgetService.getPreBudgetInfo2(param);
			
			
			// 예산금액
			BigDecimal bgtAm = (BigDecimal) budgetInfo.get("AMT1");
			budgetInfo.put("BGT_AM", bgtAm);
			
			// 품의액
			BigDecimal applyAm = new BigDecimal(0); 
			
			BigDecimal applyAmSum= new BigDecimal(0);
			
			if (preBudgetInfo.get("applyAm") != null) {
				applyAm = new BigDecimal( String.valueOf(preBudgetInfo.get("applyAm")));
				applyAmSum = applyAm.add((BigDecimal) budgetInfo.get("AMT2"));
			} else {
				applyAmSum =(BigDecimal) budgetInfo.get("AMT2");
			}
					
			// 결의액
			BigDecimal applyAm2 = (BigDecimal) budgetInfo.get("AMT2");
			
			BigDecimal applyAm3 = (BigDecimal) budgetInfo.get("AMT3");
			
			
			
			budgetInfo.put("APPLY_AM", applyAm);
			
			if (applyAm != null) {
				System.out.println(bgtAm+" , "+applyAm+" , "+applyAm2);
				// 품의기준 잔액
				BigDecimal applyJan = bgtAm.subtract(applyAm).subtract(applyAm2);
				budgetInfo.put("APPLY_JAN", applyJan);
			} else {
				budgetInfo.put("APPLY_JAN", "");
			}
			
			
			// 결의기준 잔액
			BigDecimal applyJan2 = bgtAm.subtract(applyAm2);
			budgetInfo.put("APPLY_JAN2", applyJan2);
			
			// 전표기준 잔액
			BigDecimal applyJan3 = bgtAm.subtract(applyAm3);
			budgetInfo.put("APPLY_JAN3", applyJan3);
			
			// 품의기준/결의기준 잔액 %
			if ((bgtAm.compareTo(new BigDecimal(0)) == 0)) {
				budgetInfo.put("APPLY_JAN_PCT",  "0");
				budgetInfo.put("APPLY_JAN2_PCT", "0");
				budgetInfo.put("APPLY_JAN3_PCT", "0");
			}
			else {
				budgetInfo.put("APPLY_JAN_PCT",  applyAmSum.divide(bgtAm,  4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				budgetInfo.put("APPLY_JAN2_PCT", applyAm2.divide(bgtAm, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
				budgetInfo.put("APPLY_JAN3_PCT", applyAm3.divide(bgtAm, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			}
			
			budgetMap.add(budgetInfo);
		}
		
//		String bottomCd = "";
//		String bottomNm = "";
//		
//		String pjtCd = "";
//		String pjtNm = "";
//		
//		String divCd = "";
//		String divNm = "";
//		
//		BigDecimal bottomPrc1 = new BigDecimal(0);
//		BigDecimal bottomPrc2 = new BigDecimal(0);
//		BigDecimal bottomPrc3 = new BigDecimal(0);
//		BigDecimal bottomPrc4 = new BigDecimal(0);
//		BigDecimal bottomPrc5 = new BigDecimal(0);
//		BigDecimal bottomPrc6 = new BigDecimal(0);
//		BigDecimal bottomPrc7 = new BigDecimal(0);
//				
//		BigDecimal pjtPrc1 = new BigDecimal(0);
//		BigDecimal pjtPrc2 = new BigDecimal(0);
//		BigDecimal pjtPrc3 = new BigDecimal(0);
//		BigDecimal pjtPrc4 = new BigDecimal(0);
//		BigDecimal pjtPrc5 = new BigDecimal(0);
//		BigDecimal pjtPrc6 = new BigDecimal(0);
//		BigDecimal pjtPrc7 = new BigDecimal(0);
//		
//		BigDecimal divPrc1 = new BigDecimal(0);
//		BigDecimal divPrc2 = new BigDecimal(0);
//		BigDecimal divPrc3 = new BigDecimal(0);
//		BigDecimal divPrc4 = new BigDecimal(0);
//		BigDecimal divPrc5 = new BigDecimal(0);
//		BigDecimal divPrc6 = new BigDecimal(0);
//		BigDecimal divPrc7 = new BigDecimal(0);
//		
//		BigDecimal totPrc1 = new BigDecimal(0);
//		BigDecimal totPrc2 = new BigDecimal(0);
//		BigDecimal totPrc3 = new BigDecimal(0);
//		BigDecimal totPrc4 = new BigDecimal(0);
//		BigDecimal totPrc5 = new BigDecimal(0);
//		BigDecimal totPrc6 = new BigDecimal(0);
//		BigDecimal totPrc7 = new BigDecimal(0);
//		
//		BigDecimal bottomPrcSum = new BigDecimal(0);
//		BigDecimal pjtPrcSum = new BigDecimal(0);
//		BigDecimal divPrcSum = new BigDecimal(0);
//		BigDecimal totPrcSum = new BigDecimal(0);
//		// 복사
//		budgetTmp = new ArrayList<>(budgetMap);
//		// 초기화
//		budgetMap = new ArrayList<Map<String, Object>>();
//		
//		for (int i = 0; i < budgetTmp.size(); i++) {
//			Map<String, Object> budgetInfo = budgetTmp.get(i);
//			
//			// 첫번째 레코드는 무조건 합계변수에 합산
//			if (i == 0) {
//				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
//				bottomPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
//				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
//				bottomPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
//				bottomPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
//				bottomPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
//				bottomPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
//				
//				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(pjtPrc1);
//				pjtPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(pjtPrc2);
//				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
//				pjtPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(pjtPrc4);
//				pjtPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(pjtPrc5);
//				pjtPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(pjtPrc6);
//				pjtPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(pjtPrc7);
//				
//				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(divPrc1);
//				divPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(divPrc2);
//				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
//				divPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(divPrc4);
//				divPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(divPrc5);
//				divPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(divPrc6);
//				divPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(divPrc7);
//			}
//			
//			// 하위사업 코드가 같을때까지 합산
//			if (bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
//				bottomPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(bottomPrc1);
//				bottomPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(bottomPrc2);
//				bottomPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(bottomPrc3);
//				bottomPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(bottomPrc4);
//				bottomPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(bottomPrc5);
//				bottomPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(bottomPrc6);
//				bottomPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(bottomPrc7);
//			}
//			
//			// 하위사업 코드가 틀려지면 소계 필드 추가
//			if (!bottomCd.equals("") && !bottomCd.equals(budgetInfo.get("BOTTOM_CD"))) {
//				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
//
//				budgetInfoTmp.put("CO_CD",      "");
//				budgetInfoTmp.put("BGT_YM",     "");
//				budgetInfoTmp.put("DIV_CD",     "");
//				budgetInfoTmp.put("DIV_NM",     "");
//				budgetInfoTmp.put("MGT_CD",     "");
//				budgetInfoTmp.put("MGT_NM",     "");
//				budgetInfoTmp.put("BOTTOM_CD",  "");
//				budgetInfoTmp.put("BOTTOM_NM",  bottomNm + " 소계");
//				budgetInfoTmp.put("BGT_CD",     "");
//				budgetInfoTmp.put("BGT_NM",     "");
//				budgetInfoTmp.put("BGT_NM1",    "");
//				budgetInfoTmp.put("BGT_NM2",    "");
//				budgetInfoTmp.put("BGT_NM3",    "");
//				budgetInfoTmp.put("BGT_AM",     bottomPrc1);
//				budgetInfoTmp.put("APPLY_AM",   bottomPrc2);
//				budgetInfoTmp.put("APPLY_AM2",  bottomPrc3);
//				budgetInfoTmp.put("APPLY_JAN",  bottomPrc4);
//				budgetInfoTmp.put("APPLY_JAN2", bottomPrc5);
//				budgetInfoTmp.put("STATE_SUM", bottomPrc6);
//				budgetInfoTmp.put("APPLY_JAN3", bottomPrc7);
//				
//				bottomPrcSum = bottomPrc2.add(bottomPrc3);
//				
//				if ((bottomPrc1.compareTo(new BigDecimal(0)) == 0)) {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//					budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//				}
//				else {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  bottomPrcSum.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN2_PCT", bottomPrc3.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN3_PCT", bottomPrc6.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//				}
//				
//				budgetMap.add(budgetInfoTmp);
//				
//				bottomPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
//				bottomPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
//				bottomPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
//				bottomPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
//				bottomPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
//				bottomPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
//				bottomPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
//			}
//			
//			// 하위사업 코드가 같을때까지 합산
//			if (pjtCd.equals(budgetInfo.get("MGT_CD"))) {
//				pjtPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(pjtPrc1);
//				pjtPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(pjtPrc2);
//				pjtPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(pjtPrc3);
//				pjtPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(pjtPrc4);
//				pjtPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(pjtPrc5);
//				pjtPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(pjtPrc6);
//				pjtPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(pjtPrc7);
//				
//				
//			}
//			
//			
//			// 프로젝트 코드가 틀려지면 소계 필드 추가
//			if (!pjtCd.equals("") && !pjtCd.equals(budgetInfo.get("MGT_CD"))) {
//				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
//				
//				budgetInfoTmp.put("CO_CD",     "");
//				budgetInfoTmp.put("BGT_YM",    "");
//				budgetInfoTmp.put("DIV_CD",    "");
//				budgetInfoTmp.put("DIV_NM",    "");
//				budgetInfoTmp.put("MGT_CD",    "");
//				budgetInfoTmp.put("MGT_NM",    pjtNm + " 소계");
//				budgetInfoTmp.put("BOTTOM_CD", "");
//				budgetInfoTmp.put("BOTTOM_NM", "");
//				budgetInfoTmp.put("BGT_CD",    "");
//				budgetInfoTmp.put("BGT_NM",    "");
//				budgetInfoTmp.put("BGT_NM1",   "");
//				budgetInfoTmp.put("BGT_NM2",   "");
//				budgetInfoTmp.put("BGT_NM3",   "");
//				budgetInfoTmp.put("BGT_AM",     pjtPrc1);
//				budgetInfoTmp.put("APPLY_AM",   pjtPrc2);
//				budgetInfoTmp.put("APPLY_AM2",  pjtPrc3);
//				budgetInfoTmp.put("APPLY_JAN",  pjtPrc4);
//				budgetInfoTmp.put("APPLY_JAN2", pjtPrc5);
//				budgetInfoTmp.put("STATE_SUM", pjtPrc6);
//				budgetInfoTmp.put("APPLY_JAN3", pjtPrc7);
//				
//				pjtPrcSum = pjtPrc2.add(pjtPrc3);
//				
//				if ((pjtPrc1.compareTo(new BigDecimal(0)) == 0)) {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//					budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//				}
//				else {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  pjtPrcSum.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN2_PCT", pjtPrc3.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN3_PCT", pjtPrc6.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//				}
//				
//				budgetMap.add(budgetInfoTmp);
//				
//				pjtPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
//				pjtPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
//				pjtPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
//				pjtPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
//				pjtPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
//				pjtPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
//				pjtPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
//			}
//			
//			// 회계단위 코드가 같을때까지 합산
//			if (divCd.equals(budgetInfo.get("DIV_CD"))) {
//				divPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(divPrc1);
//				divPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(divPrc2);
//				divPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(divPrc3);
//				divPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(divPrc4);
//				divPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(divPrc5);
//				divPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(divPrc6);
//				divPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(divPrc7);
//			}
//			
//			// 회계단위 코드가 틀려지면 소계 필드 추가
//			if (!divCd.equals("") && !divCd.equals(budgetInfo.get("DIV_CD"))) {
//				Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
//
//				budgetInfoTmp.put("CO_CD",     "");
//				budgetInfoTmp.put("BGT_YM",    "");
//				budgetInfoTmp.put("DIV_CD",    "");
//				budgetInfoTmp.put("DIV_NM",    divNm + " 소계");
//				budgetInfoTmp.put("MGT_CD",    "");
//				budgetInfoTmp.put("MGT_NM",    "");
//				budgetInfoTmp.put("BOTTOM_CD", "");
//				budgetInfoTmp.put("BOTTOM_NM", "");
//				budgetInfoTmp.put("BGT_CD",    "");
//				budgetInfoTmp.put("BGT_NM",    "");
//				budgetInfoTmp.put("BGT_NM1",   "");
//				budgetInfoTmp.put("BGT_NM2",   "");
//				budgetInfoTmp.put("BGT_NM3",   "");
//				budgetInfoTmp.put("BGT_AM",     divPrc1);
//				budgetInfoTmp.put("APPLY_AM",   divPrc2);
//				budgetInfoTmp.put("APPLY_AM2",  divPrc3);
//				budgetInfoTmp.put("APPLY_JAN",  divPrc4);
//				budgetInfoTmp.put("APPLY_JAN2", divPrc5);
//				budgetInfoTmp.put("STATE_SUM", divPrc6);
//				budgetInfoTmp.put("APPLY_JAN3", divPrc7);
//				
//				divPrcSum = divPrc2.add(divPrc3);
//				
//				if ((divPrc1.compareTo(new BigDecimal(0)) == 0)) {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//					budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//					budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//				}
//				else {
//					budgetInfoTmp.put("APPLY_JAN_PCT",  divPrcSum.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN2_PCT", divPrc3.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//					budgetInfoTmp.put("APPLY_JAN3_PCT", divPrc6.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//				}
//				
//				budgetMap.add(budgetInfoTmp);
//				
//				divPrc1 = (BigDecimal) budgetInfo.get("BGT_AM");
//				divPrc2 = (BigDecimal) budgetInfo.get("APPLY_AM");
//				divPrc3 = (BigDecimal) budgetInfo.get("APPLY_AM2");
//				divPrc4 = (BigDecimal) budgetInfo.get("APPLY_JAN");
//				divPrc5 = (BigDecimal) budgetInfo.get("APPLY_JAN2");
//				divPrc6 = (BigDecimal) budgetInfo.get("STATE_SUM");
//				divPrc7 = (BigDecimal) budgetInfo.get("APPLY_JAN3");
//			}
//			
//			budgetMap.add(budgetInfo);
//			
//			bottomCd = (String) budgetInfo.get("BOTTOM_CD");
//			bottomNm = (String) budgetInfo.get("BOTTOM_NM");
//			
//			pjtCd = (String) budgetInfo.get("MGT_CD");
//			pjtNm = (String) budgetInfo.get("MGT_NM");
//			
//			divCd = (String) budgetInfo.get("DIV_CD");
//			divNm = (String) budgetInfo.get("DIV_NM");
//
//			totPrc1 = ((BigDecimal) budgetInfo.get("BGT_AM")).add(totPrc1);
//			totPrc2 = ((BigDecimal) budgetInfo.get("APPLY_AM")).add(totPrc2);
//			totPrc3 = ((BigDecimal) budgetInfo.get("APPLY_AM2")).add(totPrc3);
//			totPrc4 = ((BigDecimal) budgetInfo.get("APPLY_JAN")).add(totPrc4);
//			totPrc5 = ((BigDecimal) budgetInfo.get("APPLY_JAN2")).add(totPrc5);
//			totPrc6 = ((BigDecimal) budgetInfo.get("STATE_SUM")).add(totPrc6);
//			totPrc7 = ((BigDecimal) budgetInfo.get("APPLY_JAN3")).add(totPrc7);
//		}
//		
//		// 하위사업 마지막 소계
//		Map<String, Object> budgetInfoTmp = new HashMap<String, Object>();
//
//		budgetInfoTmp.put("CO_CD",      "");
//		budgetInfoTmp.put("BGT_YM",     "");
//		budgetInfoTmp.put("DIV_CD",     "");
//		budgetInfoTmp.put("DIV_NM",     "");
//		budgetInfoTmp.put("MGT_CD",     "");
//		budgetInfoTmp.put("MGT_NM",     "");
//		budgetInfoTmp.put("BOTTOM_CD",  "");
//		budgetInfoTmp.put("BOTTOM_NM",  bottomNm + " 소계");
//		budgetInfoTmp.put("BGT_CD",     "");
//		budgetInfoTmp.put("BGT_NM",     "");
//		budgetInfoTmp.put("BGT_NM1",    "");
//		budgetInfoTmp.put("BGT_NM2",    "");
//		budgetInfoTmp.put("BGT_NM3",    "");
//		budgetInfoTmp.put("BGT_AM",     bottomPrc1);
//		budgetInfoTmp.put("APPLY_AM",   bottomPrc2);
//		budgetInfoTmp.put("APPLY_AM2",  bottomPrc3);
//		budgetInfoTmp.put("APPLY_JAN",  bottomPrc4);
//		budgetInfoTmp.put("APPLY_JAN2", bottomPrc5);
//		budgetInfoTmp.put("STATE_SUM", bottomPrc6);
//		budgetInfoTmp.put("APPLY_JAN3", bottomPrc7);
//		
//		bottomPrcSum = bottomPrc2.add(bottomPrc3);
//		
//		if ((bottomPrc1.compareTo(new BigDecimal(0)) == 0)) {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//		}
//		else {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  bottomPrcSum.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN2_PCT", bottomPrc3.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN3_PCT", bottomPrc6.divide(bottomPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//		}
//		
//		budgetMap.add(budgetInfoTmp);
//		
//		// 프로젝트 마지막 소계
//		budgetInfoTmp = new HashMap<String, Object>();
//		
//		budgetInfoTmp.put("CO_CD",      "");
//		budgetInfoTmp.put("BGT_YM",     "");
//		budgetInfoTmp.put("DIV_CD",     "");
//		budgetInfoTmp.put("DIV_NM",     "");
//		budgetInfoTmp.put("MGT_CD",     "");
//		budgetInfoTmp.put("MGT_NM",     pjtNm + " 소계");
//		budgetInfoTmp.put("BOTTOM_CD",  "");
//		budgetInfoTmp.put("BOTTOM_NM",  "");
//		budgetInfoTmp.put("BGT_CD",     "");
//		budgetInfoTmp.put("BGT_NM",     "");
//		budgetInfoTmp.put("BGT_NM1",    "");
//		budgetInfoTmp.put("BGT_NM2",    "");
//		budgetInfoTmp.put("BGT_NM3",    "");
//		budgetInfoTmp.put("BGT_AM",     pjtPrc1);
//		budgetInfoTmp.put("APPLY_AM",   pjtPrc2);
//		budgetInfoTmp.put("APPLY_AM2",  pjtPrc3);
//		budgetInfoTmp.put("APPLY_JAN",  pjtPrc4);
//		budgetInfoTmp.put("APPLY_JAN2", pjtPrc5);
//		budgetInfoTmp.put("STATE_SUM", pjtPrc6);
//		budgetInfoTmp.put("APPLY_JAN3", pjtPrc7);
//		
//		pjtPrcSum = pjtPrc2.add(pjtPrc3);
//		
//		if ((pjtPrc1.compareTo(new BigDecimal(0)) == 0)) {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//		}
//		else {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  pjtPrcSum.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN2_PCT", pjtPrc3.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN3_PCT", pjtPrc6.divide(pjtPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//		}
//		
//		budgetMap.add(budgetInfoTmp);
//		
//		// 회계단위 마지막 소계
//		budgetInfoTmp = new HashMap<String, Object>();
//
//		budgetInfoTmp.put("CO_CD",      "");
//		budgetInfoTmp.put("BGT_YM",     "");
//		budgetInfoTmp.put("DIV_CD",     "");
//		budgetInfoTmp.put("DIV_NM",     divNm + " 소계");
//		budgetInfoTmp.put("MGT_CD",     "");
//		budgetInfoTmp.put("MGT_NM",     "");
//		budgetInfoTmp.put("BOTTOM_CD",  "");
//		budgetInfoTmp.put("BOTTOM_NM",  "");
//		budgetInfoTmp.put("BGT_CD",     "");
//		budgetInfoTmp.put("BGT_NM",     "");
//		budgetInfoTmp.put("BGT_NM1",    "");
//		budgetInfoTmp.put("BGT_NM2",    "");
//		budgetInfoTmp.put("BGT_NM3",    "");
//		budgetInfoTmp.put("BGT_AM",     divPrc1);
//		budgetInfoTmp.put("APPLY_AM",   divPrc2);
//		budgetInfoTmp.put("APPLY_AM2",  divPrc3);
//		budgetInfoTmp.put("APPLY_JAN",  divPrc4);
//		budgetInfoTmp.put("APPLY_JAN2", divPrc5);
//		budgetInfoTmp.put("STATE_SUM", divPrc6);
//		budgetInfoTmp.put("APPLY_JAN3", divPrc7);
//		
//		divPrcSum = divPrc2.add(divPrc3);
//		
//		if ((divPrc1.compareTo(new BigDecimal(0)) == 0)) {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//		}
//		else {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  divPrcSum.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN2_PCT", divPrc3.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN3_PCT", divPrc6.divide(divPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//		}
//		
//		budgetMap.add(budgetInfoTmp);
//		
//		// 총합계 마지막 소계
//		budgetInfoTmp = new HashMap<String, Object>();
//
//		budgetInfoTmp.put("CO_CD",      "");
//		budgetInfoTmp.put("BGT_YM",     "");
//		budgetInfoTmp.put("DIV_CD",     "");
//		budgetInfoTmp.put("DIV_NM",     "");
//		budgetInfoTmp.put("MGT_CD",     "");
//		budgetInfoTmp.put("MGT_NM",     "");
//		budgetInfoTmp.put("BOTTOM_CD",  "");
//		budgetInfoTmp.put("BOTTOM_NM",  "");
//		budgetInfoTmp.put("BGT_CD",     "");
//		budgetInfoTmp.put("BGT_NM",     "");
//		budgetInfoTmp.put("BGT_NM1",    "합계");
//		budgetInfoTmp.put("BGT_NM2",    "");
//		budgetInfoTmp.put("BGT_NM3",    "");
//		budgetInfoTmp.put("BGT_AM",     totPrc1);
//		budgetInfoTmp.put("APPLY_AM",   totPrc2);
//		budgetInfoTmp.put("APPLY_AM2",  totPrc3);
//		budgetInfoTmp.put("APPLY_JAN",  totPrc4);
//		budgetInfoTmp.put("APPLY_JAN2", totPrc5);
//		budgetInfoTmp.put("STATE_SUM", totPrc6);
//		budgetInfoTmp.put("APPLY_JAN3", totPrc7);
//		
//		totPrcSum = totPrc2.add(totPrc3);
//		
//		if ((totPrc1.compareTo(new BigDecimal(0)) == 0)) {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  "0");
//			budgetInfoTmp.put("APPLY_JAN2_PCT", "0");
//			budgetInfoTmp.put("APPLY_JAN3_PCT", "0");
//		}
//		else {
//			budgetInfoTmp.put("APPLY_JAN_PCT",  totPrcSum.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN2_PCT", totPrc3.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//			budgetInfoTmp.put("APPLY_JAN3_PCT", totPrc6.divide(totPrc1, 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
//		}
//		
//		budgetMap.add(budgetInfoTmp);
//		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("mainList", budgetMap);
		System.out.println(budgetMap);
		return result;
		
	}
	
	//예산관리 원인행위부
	/**
	 * @MethodName : causeActView
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2019. 8. 21 
	 * 설명 : 원인행위부 매핑
	 */
	@RequestMapping(value="/budget/causeActView")
	public String causeActView(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("causeActView");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		model.addAttribute("userInfo", loginMap);

		return "/budget/causeActView";
	}
	
	/**
	 * @MethodName : comboList
	 * @author : doxx
	 * @since : 2019. 8. 21
	 * 설명 : 원인행위부 콤보리스트
	 */
	@RequestMapping(value="/budget/comboList")
	@ResponseBody
	public Map<String, Object> comboList(@RequestParam Map<String, Object> map){
		
		logger.info("comboList");

		return budgetService.comboList(map);
	}

	/**
	 * @MethodName : caseActList
	 * @author : doxx
	 * @since : 2019. 8. 21
	 * 설명 : 원인행위부 리스트
	 */
	@RequestMapping(value="/budget/caseActList")
	@ResponseBody
	public Map<String, Object> caseActList(@RequestParam Map<String, Object> map){
		
		logger.info("caseActList");

		return budgetService.caseActList(map);
	}
	/**
	 * @MethodName : caseActDetailList
	 * @author : doxx
	 * @since : 2019. 8. 21
	 * 설명 : 원인행위부 상세리스트
	 */
	@RequestMapping(value="/budget/caseActDetailList")
	@ResponseBody
	public Map<String, Object> caseActDetailList(@RequestParam Map<String, Object> map){
		
		logger.info("caseActDetailList");

		return budgetService.caseActDetailList(map);
	}
	
	/**
	 * @MethodName : causeActDocSearch
	 * @author : doxx
	 * @since : 2019. 8. 21
	 * 설명 : 원인행위부 상세리스트
	 */
	@RequestMapping(value="/budget/causeActDocSearch")
	@ResponseBody
	public List<Map<String, Object>> causeActDocSearch(@RequestParam Map<String, Object> map){
		
		logger.info("causeActDocSearch");

		return budgetService.causeActDocSearch(map);
	}
	
	//예산관리 거래처원장
	/**
	 * @MethodName : customerLedger
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2019. 9. 9 
	 * 설명 : 거래처원장 매핑
	 */
	@RequestMapping(value="/budget/customerLedger")
	public String customerLedger(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("customerLedger");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		model.addAttribute("userInfo", loginMap);

		return "/budget/customerLedger";
	}
	
	/**
	 * @MethodName : ledgerComboList
	 * @author : doxx
	 * @since : 2019. 9. 9
	 * 설명 : 거래처원장 콤보리스트
	 */
	@RequestMapping(value="/budget/ledgerComboList")
	@ResponseBody
	public Map<String, Object> ledgerComboList(@RequestParam Map<String, Object> map){
		
		logger.info("ledgerComboList");

		return budgetService.ledgerComboList(map);
	}
	
	/**
	 * @MethodName : ledgerComboList2
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 거래처원장 콤보리스트2
	 */
	@RequestMapping(value="/budget/ledgerComboList2")
	@ResponseBody
	public Map<String, Object> ledgerComboList2(@RequestParam Map<String, Object> map){
		
		logger.info("ledgerComboList2");
		
		return budgetService.ledgerComboList2(map);
	}
	
	/**
	 * @MethodName : resolutionDeptComboList
	 * @author : doxx
	 * @since : 2020. 4. 20
	 * 설명 : 결의부서 콤보리스트
	 */
	@RequestMapping(value="/budget/resolutionDeptComboList")
	@ResponseBody
	public Map<String, Object> resolutionDeptComboList(@RequestParam Map<String, Object> map){
		
		logger.info("resolutionDeptComboList");

		return budgetService.resolutionDeptComboList(map);
	}
	
	/**
	 * @MethodName : ledgerList
	 * @author : doxx
	 * @since : 2019. 9. 9
	 * 설명 : 거래처원장 리스트
	 */
	@RequestMapping(value="/budget/ledgerList")
	@ResponseBody
	public Map<String, Object> ledgerList(@RequestParam Map<String, Object> map){
		
		logger.info("ledgerList");

		return budgetService.ledgerList(map);
	}
	
	//예산관리 원인행위부
	/**
	 * @MethodName : causeActView
	 * @author : doxx
	 * @throws NoPermissionException 
	 * @since : 2019. 8. 21 
	 * 설명 : 원인행위부 매핑
	 */
	@RequestMapping(value="/budget/causeActView2")
	public String causeActView2(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("causeActView2");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		model.addAttribute("userInfo", loginMap);

		return "/budget/causeActView2";
	}

	/**
	 * @MethodName : caseActDetailList
	 * @author : doxx
	 * @since : 2019. 8. 21
	 * 설명 : 원인행위부 상세리스트
	 */
	@RequestMapping(value="/budget/caseActDetailList2")
	@ResponseBody
	public Map<String, Object> caseActDetailList2(@RequestParam Map<String, Object> map){
		
		logger.info("caseActDetailList2");

		return budgetService.caseActDetailList2(map);
	}
	
	/**
	 * @MethodName : getVoucherDetail
	 * @author : jy
	 * @since : 2020. 4. 14
	 * 설명 : 거래처원장 전표 상세리스트
	 */
	@RequestMapping(value="/budget/getVoucherDetail")
	@ResponseBody
	public Map<String, Object> getVoucherDetail(@RequestParam Map<String, Object> map){
		
		Map<String, Object> resultMap = new HashMap<>();
		logger.info("getVoucherDetail");

		resultMap.put("list", budgetService.getVoucherDetail(map));
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getVoucher
	 * @author : jy
	 * @throws NoPermissionException 
	 * @since : 2020. 4. 14
	 * 설명 : 거래처원장 전표 정보
	 */
	@RequestMapping(value="/budget/getVoucher")
	@ResponseBody
	public Map<String, Object> getVoucher(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException{
		logger.info("/budget/getVoucher");
		
		Map<String, Object> resultMap = new HashMap<>();
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		Map<String, Object> data = new HashMap<>();
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			data = mapper.readValue(map.get("data").toString(), new TypeReference<Map<String, Object>>(){});
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		data.put("CO_CD", loginMap.get("erpCompSeq"));
		
		resultMap.put("list", budgetService.getVoucher(data));
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getResolutionAdoct
	 * @author : jy
	 * @throws NoPermissionException 
	 * @since : 2020. 4. 16
	 * 설명 : 지출결의 조회(코드~신고기준일)
	 */
	@RequestMapping(value="/budget/getResolutionAdoct")
	@ResponseBody
	public Map<String, Object> getResolutionAdoct(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException{
		logger.info("/budget/getResolutionAdoct");
		
		Map<String, Object> resultMap = new HashMap<>();

		resultMap.put("list", budgetService.getResolutionAdoct(map));
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getResolutionAdocb
	 * @author : jy
	 * @throws NoPermissionException 
	 * @since : 2020. 4. 16
	 * 설명 : 지출결의 조회 (예산과목 ~ 비고)
	 */
	@RequestMapping(value="/budget/getResolutionAdocb")
	@ResponseBody
	public Map<String, Object> getResolutionAdocb(@RequestParam Map<String, Object> map) throws NoPermissionException{
		logger.info("/budget/getResolutionAdocb");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		System.out.println("@@@@" + map);
		
		resultMap.put("list", budgetService.getResolutionAdocb(map));
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getResolutionAdocm
	 * @author : jy
	 * @throws NoPermissionException 
	 * @since : 2020. 4. 16
	 * 설명 : 지출결의 조회 (발의일자 ~ 입출금계좌)
	 */
	@RequestMapping(value="/budget/getResolutionAdocm")
	@ResponseBody
	public Map<String, Object> getResolutionAdocm(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException{
		logger.info("/budget/getResolutionAdocm");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("list", budgetService.getResolutionAdocm(map));
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getAccountTitleList
	 * @author : jy
	 * @since : 2020. 4. 16
	 * 설명 : 계정과목 팝업
	 */
	@RequestMapping(value="/budget/getAccountTitleList")
	@ResponseBody
	public Map<String, Object> getAccountTitleList(@RequestParam Map<String, Object> map){
		logger.info("/budget/getAccountTitleList");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		List<Map<String, Object>> list = budgetService.getAccountTitleList(map);
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getCustomerList
	 * @author : jy
	 * @since : 2020. 4. 16
	 * 설명 : 거래처 팝업
	 */
	@RequestMapping(value="/budget/getCustomerList")
	@ResponseBody
	public Map<String, Object> getCustomerList(@RequestParam Map<String, Object> map){
		logger.info("/budget/getCustomerList");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		List<Map<String, Object>> list = budgetService.getCustomerList(map);
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : accountLedger
	 * @author : jy
	 * @throws NoPermissionException 
	 * @since : 2020. 4. 16 
	 * 설명 : 계정별 원장
	 */
	@RequestMapping(value="/budget/accountLedger")
	public String accountLedger(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("/budget/accountLedger");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		model.addAttribute("userInfo", loginMap);

		return "/budget/accountLedger";
	}
	
	/**
	 * @MethodName : resolutionPopup
	 * @author : jy
	 * @since : 2020. 4. 20 
	 * 설명 : 지출결의 보기 팝업
	 */
	@RequestMapping(value="/budget/resolutionPopup")
	public String resolutionPopup(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/resolutionPopup");
		
		return "/budget/pop/viewResolutionPop";
	}
	
	/**
	 * @MethodName : accountLedgerList
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 계정별원장 리스트
	 */
	@RequestMapping(value="/budget/accountLedgerList")
	@ResponseBody
	public Map<String, Object> accountLedgerList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/accountLedgerList");

		return budgetService.accountLedgerList(map);
	}
	
	/**
	 * @MethodName : generalAccountLedger
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 총계정별원장
	 */
	@RequestMapping(value="/budget/generalAccountLedger")
	public String generalAccountLedger(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/generalAccountLedger");

		return "/budget/generalAccountLedger";
	}
	
	/**
	 * @MethodName : generalAccountLedgerList
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 총계정별원장 리스트
	 */
	@RequestMapping(value="/budget/generalAccountLedgerList")
	@ResponseBody
	public Map<String, Object> generalAccountLedgerList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/generalAccountLedgerList");

		return budgetService.generalAccountLedgerList(map);
	}
	
	/**
	 * @MethodName : purchaseLedger
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 매입장
	 */
	@RequestMapping(value="/budget/purchaseLedger")
	public String purchaseLedger(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/purchaseLedger");

		return "/budget/purchaseLedger";
	}
	
	/**
	 * @MethodName : purchaseLedgerList
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 매입장 리스트
	 */
	@RequestMapping(value="/budget/purchaseLedgerList")
	@ResponseBody
	public Map<String, Object> purchaseLedgerList(@RequestParam Map<String, Object> map){
		
		Map<String, Object> resultMap = new HashMap<>();
		
		logger.info("/budget/purchaseLedgerList");
		
		resultMap.put("list", budgetService.purchaseLedgerList(map));

		return resultMap;
	}
	
	/**
	 * @MethodName : salesLedger
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 매출장
	 */
	@RequestMapping(value="/budget/salesLedger")
	public String salesLedger(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/salesLedger");

		return "/budget/salesLedger";
	}
	
	/**
	 * @MethodName : salesLedgerList
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 매출장 리스트
	 */
	@RequestMapping(value="/budget/salesLedgerList")
	@ResponseBody
	public Map<String, Object> salesLedgerList(@RequestParam Map<String, Object> map){
		
		Map<String, Object> resultMap = new HashMap<>();
		
		logger.info("/budget/salesLedgerList");
		
		resultMap.put("list", budgetService.salesLedgerList(map));

		return resultMap;
	}
	
	/**
	 * @MethodName : purchaseLedger
	 * @author : jy
	 * @throws NoPermissionException 
	 * @since : 2020. 4. 20
	 * 설명 : 나의 지출결의서
	 */
	@RequestMapping(value="/budget/myExpenditureResolution")
	public String myExpenditureResolution(HttpServletRequest servletRequest, Model model) throws NoPermissionException{
		
		logger.info("/budget/myExpenditureResolution");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		
		String empSeq = (String) loginMap.get("erpEmpSeq");
		Map<String, Object> empName = commonService.getEmpName(empSeq);
		
		String erpEmpSeq = kukgohService.getErpEmpSeq(loginMap);
		
		model.addAttribute("erpEmpSeq", erpEmpSeq);
		model.addAttribute("userName", empName.get("emp_name"));
		model.addAttribute("deptNm", loginMap.get("orgnztNm"));
		model.addAttribute("deptSeq", loginMap.get("deptSeq"));
		
		return "/budget/myExpenditureResolution";
	}
	
	/**
	 * @MethodName : IndividualExpenditureResolutionList
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 나의 지출결의서 리스트
	 */
	@RequestMapping(value="/budget/IndividualExpenditureResolutionList")
	@ResponseBody
	public Map<String, Object> IndividualExpenditureResolutionList(@RequestParam Map<String, Object> map){
		
		Map<String, Object> resultMap = new HashMap<>();
		
		logger.info("/budget/IndividualExpenditureResolutionList");
		
		resultMap.put("list", budgetService.IndividualExpenditureResolutionList(map));

		return resultMap;
	}
	
	/**
	 * @MethodName : expenditureResolutionStatus
	 * @author : jy
	 * @since : 2020. 4. 20
	 * 설명 : 지출결의서 현황
	 */
	@RequestMapping(value="/budget/expenditureResolutionStatus")
	public String expenditureResolutionStatus(HttpServletRequest servletRequest, Model model){
		
		logger.info("/budget/expenditureResolutionStatus");
		
		model.addAttribute("allDept", new Gson().toJson(commonService.getAllDept()));
		
		return "/budget/expenditureResolutionStatus";
	}
	
	/**
	 * @MethodName : expenditureResolutionStatusList
	 * @author : jy
	 * @since : 2020. 4. 21
	 * 설명 : 지출결의서 현황 리스트
	 */
	@RequestMapping(value="/budget/expenditureResolutionStatusList")
	@ResponseBody
	public Map<String, Object> expenditureResolutionStatusList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/expenditureResolutionStatusList");

		Map<String, Object> resultMap = new HashMap<>();
		String erpDeptSeq = kukgohService.getErpDeptNo(map);
		
		if (erpDeptSeq != null) {
			map.put("erpDeptSeq", erpDeptSeq);
		} else {
			map.put("erpEmpSeq", budgetService.getOneErpEmpNum(map));
			erpDeptSeq = kukgohService.getErpDeptNo(map);
			map.put("erpDeptSeq", erpDeptSeq);
			map.put("erpEmpSeq", "");
		}
		
		map.put("erpDeptSeq", erpDeptSeq == null ? "" : erpDeptSeq); 
		
		resultMap.put("list", budgetService.expenditureResolutionStatusList(map));

		return resultMap;
	}
	
	/**
	 * @MethodName : projectPreparation
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 사업별 예실대비 현황
	 */
	@RequestMapping(value="/budget/projectPreparation")
	public String projectPreparation(HttpServletRequest servletRequest, Model model){
		
		logger.info("/budget/projectPreparation");
		
		return "/budget/projectPreparation";
	}
	
	/**
	 * @MethodName : ledgerComboList
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 회계단위 콤보리스트
	 */
	@RequestMapping(value="/budget/accountingComboList")
	@ResponseBody
	public Map<String, Object> accountingComboList(@RequestParam Map<String, Object> map){
		
		logger.info("accountingComboList");

		return budgetService.accountingComboList(map);
	}
	
	/**
	 * @MethodName : projectPreparationList
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 사업별 예실대비 리스트
	 */
	@RequestMapping(value="/budget/projectPreparationList")
	@ResponseBody
	public Map<String, Object> projectPreparationList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/projectPreparationList");

		Map<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("list", budgetService.projectPreparationList(map));
		
		return resultMap;
	}
	
	/**
	 * @MethodName : projectList
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 프로젝트 리스트
	 */
	@RequestMapping(value="/budget/projectList")
	@ResponseBody
	public Map<String, Object> projectList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/projectList");

		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> list = budgetService.projectList(map);
		
		resultMap.put("list", budgetService.projectList(map));
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : projectList3
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 프로젝트 리스트
	 */
	@RequestMapping(value="/budget/projectList3")
	@ResponseBody
	public Map<String, Object> projectList3(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/projectList3");
		
		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> list = budgetService.projectList3(map);
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : budgetListAjax
	 * @author : jy
	 * @since : 2020. 4. 22
	 * 설명 : 예산 팝업 리스트
	 */
	@RequestMapping(value="/budget/budgetListAjax")
	@ResponseBody
	public Map<String, Object> budgetListAjax(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/budgetListAjax");

		Map<String, Object> resultMap = new HashMap<>();
		
		List<Map<String, Object>> list = budgetService.budgetListAjax(map);
		
		resultMap.put("list", list);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : mokListAjax
	 * @author : jy
	 * @since : 2020. 4. 23
	 * 설명 : 목 리스트
	 */
	@RequestMapping(value="/budget/mokListAjax")
	@ResponseBody
	public Map<String, Object> mokListAjax(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/mokListAjax");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		List<Map<String, Object>> list = budgetService.mokListAjax(map);
		
		resultMap.put("list", list);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : 최초 화면
	 * @author : jy
	 * @since : 2020. 6. 16
	 * 설명 : 최초 실행되는 Grid URL
	 */
	@RequestMapping(value="/budget/initGrid")
	@ResponseBody
	public Map<String, Object> initGrid(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/initGrid");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		
		resultMap.put("list", list);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : resDocSubmitList
	 * @author : jm
	 * @throws NoPermissionException 
	 * @since : 2020. 6. 22 
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/resDocSubmitList")
	public String resDocSubmitList(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("resDocSubmitList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("allDept", new Gson().toJson(commonService.getAllDept()));

		return "/budget/resDocSubmitList";
	}
	
	/**
	 * @MethodName : resDocSubmitList2
	 * @author : jm
	 * @throws NoPermissionException 
	 * @since : 2020. 9. 24 
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/resDocSubmitList2")
	public String resDocSubmitList2(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("resDocSubmitList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("allDept", new Gson().toJson(commonService.getAllDept()));

		return "/budget/resDocSubmitList2";
	}
	
	/**
	 * @MethodName : resDocSubmitAdminList
	 * @author : jm
	 * @throws NoPermissionException 
	 * @since : 2020. 6. 23 
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/resDocSubmitAdminList")
	public String resDocSubmitAdminList(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("resDocSubmitAdminList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("allDept", new Gson().toJson(commonService.getAllDept()));

		return "/budget/resDocSubmitAdminList";
	}
	
	/**
	 * @MethodName : resDocSubmitAdminList2
	 * @author : jm
	 * @throws NoPermissionException 
	 * @since : 2020. 6. 23 
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/resDocSubmitAdminList2")
	public String resDocSubmitAdminList2(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("resDocSubmitAdminList2");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("allDept", new Gson().toJson(commonService.getAllDept()));
		
		return "/budget/resDocSubmitAdminList2";
	}
	
	/**
	 * @MethodName : getResDocSubmitList
	 * @author : jm
	 * @since : 2020. 6. 22
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/getResDocSubmitList")
	@ResponseBody
	public Map<String, Object> getResDocSubmitList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getResDocSubmitList");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = budgetService.getResDocSubmitList(map);
		
		resultMap.put("list", list);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : resDocSubmit
	 * @author : jm
	 * @since : 2020. 6. 22
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/resDocSubmit")
	@ResponseBody
	public Map<String, Object> resDocSubmit(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/resDocSubmit");
		
		String result = "Failed";
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		result = budgetService.resDocSubmit(map);
		
		resultMap.put("result", result);
		
		return resultMap;
	}

	/**
	 * @MethodName : resDocSubmit
	 * @author : jm
	 * @since : 2020. 6. 22
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/resDocUpdate")
	@ResponseBody
	public Map<String, Object> resDocUpdate(@RequestParam Map<String, Object> map){

		logger.info("/budget/resDocUpdate");

		String result = "Failed";

		Map<String, Object> resultMap = new HashMap<String, Object>();

		result = budgetService.resDocUpdate(map);

		resultMap.put("result", result);

		return resultMap;
	}
	
	/**
	 * @MethodName : updateUseYn
	 * @author : jm
	 * @since : 2020. 7. 15
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/updateUseYn")
	@ResponseBody
	public Map<String, Object> updateUseYn(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/updateUseYn");
		
		String result = "Failed";
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		result = budgetService.updateUseYn(map);
		
		resultMap.put("result", result);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : updateUseYn
	 * @author : jm
	 * @since : 2020. 7. 15
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/updateReturn")
	@ResponseBody
	public Map<String, Object> updateReturn(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/updateReturn");
		
		String result = "Failed";
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		result = budgetService.updateReturn(map);
		
		resultMap.put("result", result);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getResDocSubmitAdminList
	 * @author : jm
	 * @since : 2020. 6. 29
	 * 설명 : 지출결의서 제출
	 */
	@RequestMapping(value="/budget/getResDocSubmitAdminList")
	@ResponseBody
	public Map<String, Object> getResDocSubmitAdminList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getResDocSubmitAdminList");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = budgetService.getResDocSubmitAdminList(map);

		resultMap.put("list", list);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : adocuList
	 * @author : jm
	 * @throws NoPermissionException 
	 * @since : 2020. 7. 1 
	 * 설명 : 전표연동
	 */
	@RequestMapping(value="/budget/adocuList")
	public String adocuList(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("adocuList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("allDept", new Gson().toJson(budgetService.getErpDept(loginVO.getErpCoCd())));

		return "/budget/adocuList";
	}
	
	/**
	 * @MethodName : getAdocuList
	 * @author : jm
	 * @since : 2020. 7. 1.
	 * 설명 : 전표연동 제출
	 */
	@RequestMapping(value="/budget/getAdocuList")
	@ResponseBody
	public Map<String, Object> getAdocuList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getAdocuList");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = budgetService.getAdocuList(map);
		
		resultMap.put("list", list);
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getErpEmpList
	 * @author : jm
	 * @since : 2020. 7. 1.
	 * 설명 : 사원팝업
	 */
	@RequestMapping(value = "/budget/getErpEmpList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getErpEmpList(@RequestParam Map<String, Object> map){
		logger.info("getErpEmpList");
		
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("list", budgetService.getErpEmpList(map)); //리스트
		
		return resultMap;
	}
	
	/**
	 * @MethodName : adocuViewPop
	 * @author : jm
	 * @since : 2020. 7. 1.
	 * 설명 : 전표팝업
	 */
	@RequestMapping(value = "/budget/pop/adocuViewPop")
	public String adocuViewPop(Model model, @RequestParam Map<String, Object> map) {
		logger.info("adocuViewPop");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAllAttributes(map);
		return "/budget/pop/adocuViewPop";
	}
	
	@Resource(name = "CommFileDAO")
	CommFileDAO commFileDAO;
	
	/**
	 * 첨부파일 키 생성
	 * makeFileKey parkjm 2018. 4. 11.
	 * 
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping ( value = "/budget/makeFileKey")
	public ModelAndView makeFileKey ( @RequestParam HashMap<String, Object> requestMap) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String result = null;
		try {
			String fileKey = "Y" + java.util.UUID.randomUUID().toString();
			List<Map<String, Object>> tempSaveFileList = budgetService.getResDocFile(requestMap);
			for (Map<String, Object> fileMap : tempSaveFileList) {
				String filePath = String.valueOf(fileMap.get("pdf_path")).replace("Z:/", "/home/") + "/";
//				String filePath = String.valueOf(fileMap.get("pdf_path")).replace("Z:/", "D:/") + "/";
				String fileName = String.valueOf(fileMap.get("pdf_name"));
//				String realFileName = "[" + String.valueOf(fileMap.get("docNum")) + "] " + String.valueOf(requestMap.get("isu_doc"));
				String realFileName = String.valueOf(requestMap.get("isu_doc"));
				String fileExtension = "pdf";
				String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
				
				FileInputStream fis = new FileInputStream(filePath + fileName + "." + fileExtension);
				CommFileUtil.makeDir(tempPath + fileKey);
				FileOutputStream fos = new FileOutputStream(tempPath + fileKey + File.separator + realFileName + "." + fileExtension);
				
				FileChannel fcin = fis.getChannel();
				FileChannel fcout = fos.getChannel();
				
				long size = fcin.size();
				fcin.transferTo(0, size, fcout);
				
				fcout.close();
				fcin.close();
				
				fis.close();
				fos.close();
			}
			result = fileKey;
			
		}
		catch ( Exception e ) {
			result = "Failed";
			e.printStackTrace( );
			logger.error( e.toString() );
		}
		mv.addObject( "fileKey", result );
		mv.addObject( "params", requestMap );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	/**
	 * @MethodName : getAdocuInfo
	 * @author : jm
	 * @since : 2020. 7. 1.
	 * 설명 : 사원팝업
	 */
	@RequestMapping(value = "/budget/getAdocuInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getAdocuInfo(@RequestParam Map<String, Object> map){
		logger.info("getAdocuInfo");
		
		//리턴용 map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("adocuInfo", budgetService.getAdocuInfo(map)); //리스트
		
		return resultMap;
	}
	
	@RequestMapping(value = "/budget/adocuApp")
	public ModelAndView adocuApp(@RequestBody Map<String, Object> bodyMap, ModelAndView mv) {
		System.out.println(bodyMap);
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		try{
			budgetService.adocuApp(bodyMap);
		}catch(Exception e){
			logger.error(e.getMessage());
			resultCode = "FAIL";
			resultMessage = "연계 정보 갱신 오류 발생("+e.getMessage()+")";
		}
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * @MethodName : getParentDept
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 상위부서 조회
	 */
	@RequestMapping(value="/budget/getParentDept")
	@ResponseBody
	public Map<String, Object> getParentDept(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getParentDept");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.getParentDept(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : parentDeptCancel
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 상위부서 설정 취소
	 */
	@RequestMapping(value="/budget/parentDeptCancel")
	@ResponseBody
	public Map<String, Object> parentDeptCancel(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/parentDeptCancel");
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			budgetService.parentDeptCancel(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : searchDeptList
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 부서 검색
	 */
	@RequestMapping(value="/budget/searchDeptList")
	@ResponseBody
	public Map<String, Object> searchDeptList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/searchDeptList");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.searchDeptList(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : searchDeptList2
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 부서 검색2
	 */
	@RequestMapping(value="/budget/searchDeptList2")
	@ResponseBody
	public Map<String, Object> searchDeptList2(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/searchDeptList2");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.searchDeptList2(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : searchDeptList6
	 * @author : jy
	 * @since : 2020. 9. 7
	 * 설명 : 부서 검색6
	 */
	@RequestMapping(value="/budget/searchDeptList6")
	@ResponseBody
	public Map<String, Object> searchDeptList6(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/searchDeptList6");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.searchDeptList6(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}	
	
	/**
	 * @MethodName : saveSelDept
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 상위 부서 설정
	 */
	@RequestMapping(value="/budget/saveSelDept")
	@ResponseBody
	public Map<String, Object> saveSelDept(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/saveSelDept");
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			
			budgetService.saveSelDept(map);
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}

		return map;
	}
	
	/**
	 * @MethodName : projectSetDeptCancel
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 프로젝트 예산 부서 설정 취소
	 */
	@RequestMapping(value="/budget/projectSetDeptCancel")
	@ResponseBody
	public Map<String, Object> projectSetDeptCancel(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/projectSetDeptCancel");
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			budgetService.projectSetDeptCancel(map);
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}

		return map;
	}
	
	/**
	 * @MethodName : getProjectList
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 프로젝트예산 부서 리스트 조회
	 */
	@RequestMapping(value="/budget/getProjectList")
	@ResponseBody
	public Map<String, Object> getProjectList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getProjectList");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getProjectList(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : saveProjectDept
	 * @author : jy
	 * @throws UnsupportedEncodingException 
	 * @since : 2020. 7. 2
	 * 설명 : 프로젝트예산 부서 설정
	 */
	@RequestMapping(value="/budget/saveProjectDept")
	@ResponseBody
	public Map<String, Object> saveProjectDept(@RequestParam Map<String, Object> map) throws UnsupportedEncodingException{
		
		logger.info("/budget/saveProjectDept");
		
		map.put("bgtNm", URLDecoder.decode(String.valueOf(map.get("bgtNm")), "UTF-8"));
		map.put("parentBgtNm", URLDecoder.decode(String.valueOf(map.get("parentBgtNm")), "UTF-8"));
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			budgetService.saveProjectDept(map);
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}

		return map;
	}
	
	/**
	 * @MethodName : getYesilDaebi
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 전체 예실대비현황 조회(상단그리드)
	 */
	@RequestMapping(value="/budget/getYesilDaebi")
	@ResponseBody
	public Map<String, Object> getYesilDaebi(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getYesilDaebi");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getYesilDaebi(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getBonbuYesilDaebi
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 본부별 예실대비현황 조회(하단그리드)
	 */
	@RequestMapping(value="/budget/getBonbuYesilDaebi")
	@ResponseBody
	public Map<String, Object> getBonbuYesilDaebi(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBonbuYesilDaebi");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getBonbuYesilDaebi(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getBonbuInfo
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 본부정보 가져오기
	 */
	@RequestMapping(value="/budget/getBonbuInfo")
	@ResponseBody
	public Map<String, Object> getBonbuInfo(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBonbuInfo");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getBonbuInfo(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getBonbuDeptYesilDaebi
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 본부 부서별 예실대비현황 조회
	 */
	@RequestMapping(value="/budget/getBonbuDeptYesilDaebi")
	@ResponseBody
	public Map<String, Object> getBonbuDeptYesilDaebi(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBonbuDeptYesilDaebi");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getBonbuDeptYesilDaebi(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getProjectDeptYeasilDaebi
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 부서 프로젝트별 예실대비현황 조회
	 */
	@RequestMapping(value="/budget/getProjectDeptYeasilDaebi")
	@ResponseBody
	public Map<String, Object> getProjectDeptYeasilDaebi(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getProjectDeptYeasilDaebi");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getProjectDeptYeasilDaebi(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getBgtYeasilDaebi
	 * @author : jy
	 * @since : 2020. 7. 2
	 * 설명 : 부서 예산과목별 예실대비현황 조회
	 */
	@RequestMapping(value="/budget/getBgtYeasilDaebi")
	@ResponseBody
	public Map<String, Object> getBgtYeasilDaebi(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBgtYeasilDaebi");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		  
		try {
			
			List<Map<String, Object>> list = budgetService.getBgtYeasilDaebi(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	@RequestMapping(value = "/budget/highDeptSetting")
	public String  highDeptSetting(Model model) {
		
		logger.info("/budget/highDeptSetting");
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			model.addAttribute("erpEmpSeq", loginVO.getErpEmpCd());
			model.addAttribute("userInfo", loginVO);
			model.addAttribute("allDept", new Gson().toJson(budgetService.getErpDept(loginVO.getErpCoCd())));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/highDeptSetting";
	}
	
	@RequestMapping(value = "/budget/bonbuYesilDeabi")
	public String  bonbuYesilDeabi(Model model) {
		
		logger.info("/budget/bonbuYesilDeabi");
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			model.addAttribute("userInfo", loginVO);
			model.addAttribute("allDept", new Gson().toJson(budgetService.getErpDept(loginVO.getErpCoCd())));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/bonbuYesilDeabi";
	}
	
	@RequestMapping(value = "/budget/projectBgtDeptSetting")
	public String  projectBgtDeptSetting( Model model) {
		
		logger.info("/budget/projectBgtDeptSetting");
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			model.addAttribute("userInfo", loginVO);
			model.addAttribute("allDept", new Gson().toJson(budgetService.getErpDept(loginVO.getErpCoCd())));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/projectBgtDeptSetting";
	}
	
	/**
	 * @MethodName : bonbuDeptYesilDaebiPopup
	 * @author : jy
	 * @since : 2020. 7. 7 
	 * 설명 : 본부 부서별  예실대비 현황 팝업 호출
	 */
	@RequestMapping(value="/budget/bonbuDeptYesilDaebiPopup")
	public String bonbuDeptYesilDaebiPopup(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/bonbuDeptYesilDaebiPopup");
		
		return "/budget/add/bonbuDeptYesilDaebi";
	}
	
	/**
	 * @MethodName : bonbuProjectYesilDaebiPopup
	 * @author : jy
	 * @since : 2020. 7. 7 
	 * 설명 : 본부별 프로젝트 예실 대비 현황 팝업 호출
	 */
	@RequestMapping(value="/budget/bonbuProjectYesilDaebiPopup")
	public String bonbuProjectYesilDaebiPopup(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/bonbuProjectYesilDaebiPopup");
		
		return "/budget/add/bonbuProjectYesilDaebi";
	}
	
	/**
	 * @MethodName : bonbuBgtYesilDaebiPopup
	 * @author : jy
	 * @since : 2020. 7. 7 
	 * 설명 : 본부별 예산과목별 예실 대비 현황 팝업 호출
	 */
	@RequestMapping(value="/budget/bonbuBgtYesilDaebiPopup")
	public String bonbuBgtYesilDaebiPopup(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/bonbuBgtYesilDaebiPopup");
		
		return "/budget/add/bonbuBgtYesilDaebi";
	}
	
	/**
	 * @MethodName : applyDeptBgtPopup
	 * @author : jy
	 * @since : 2020. 9. 7
	 * 설명 : 부서 예산 신청 화면 (팝업)
	 */
	@RequestMapping(value="/budget/applyDeptBgtPopup")
	public String applyDeptBgtPopup(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/applyDeptBgtPopup");
		
		return "/budget/add/applyDeptBgtPopup";
	}
	
	/**
	 * @MethodName : applyDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 신청 화면
	 */
	@RequestMapping(value="/budget/applyDeptBgt")
	public String applyDeptBgt(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/applyDeptBgt");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/applyDeptBgt";
	}
	
	/**
	 * @MethodName : getDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 신청 화면 조회
	 */
	@RequestMapping(value="/budget/getDeptBgt")
	@ResponseBody
	public Map<String, Object> getDeptBgt(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getDeptBgt");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.getDeptBgt(map);
			
			for(int i=0;i<list.size();i++) {
				String modifyId = (String) list.get(i).get("MODIFY_ID");
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm"); //java.sql.Timestamp 이기때문에 sdf로 변환
				list.get(i).put("empName", budgetService.getAskedEmpNm(modifyId));
				list.get(i).put("MODIFY_DTT", sdf.format(list.get(i).get("MODIFY_DT")));
			}
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			System.out.println(list + " 컨트롤러에서 리스트 찍어보기 ");
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : saveDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 신청
	 */
	@RequestMapping(value="/budget/saveDeptBgt")
	@ResponseBody
	public Map<String, Object> saveDeptBgt(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/saveDeptBgt");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			Gson gson = new Gson();
			String jsonData = (String) map.get("param");		
			List<Map<String, Object>> list = gson.fromJson(jsonData, listType);
			
			for (Map<String, Object> row : list) {
				row.put("OUT_YN", "");
				row.put("OUT_MSG", "");
				row.put("ip", ip);
				row.put("empSeq", loginMap.get("empSeq"));
				
				budgetService.saveDeptBgt(row);
				resultMap = row;
			}
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : cancelDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 신청 취소
	 */
	@RequestMapping(value="/budget/cancelDeptBgt")
	@ResponseBody
	public Map<String, Object> cancelDeptBgt(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/cancelDeptBgt");
		
		try {
			
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			
	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        map.put("ip", ip);
	        map.put("empSeq", loginMap.get("empSeq"));
	        
			budgetService.cancelDeptBgt(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : saveDeptBgt2
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 전월복사
	 */
	@RequestMapping(value="/budget/saveDeptBgt2")
	@ResponseBody
	public Map<String, Object> saveDeptBgt2(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/saveDeptBgt2");
		
		try {
			
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			
	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        map.put("ip", ip);
	        map.put("empSeq", loginMap.get("empSeq"));
			
			budgetService.saveDeptBgt2(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : deptBgtStatus
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 현황
	 */
	@RequestMapping(value="/budget/deptBgtStatus")
	public String deptBgtStatus(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/deptBgtStatus");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/deptBgtStatus";
	}
	
	/**
	 * @MethodName : getApplyStatus
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예선 신청 상태 조회
	 */
	@RequestMapping(value="/budget/getApplyStatus")
	@ResponseBody
	public Map<String, Object> getApplyStatus(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getApplyStatus");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.getApplyStatus(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getDeptBgtStatus
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예선 현황 조회
	 */
	@RequestMapping(value="/budget/getDeptBgtStatus")
	@ResponseBody
	public Map<String, Object> getDeptBgtStatus(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getDeptBgtStatus");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.getDeptBgtStatus(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : saveDeptBgt3
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 승인
	 */
	@RequestMapping(value="/budget/saveDeptBgt3")
	@ResponseBody
	public Map<String, Object> saveDeptBgt3(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/saveDeptBgt3");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }

	        Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			Gson gson = new Gson();
			String jsonData = (String) map.get("param");		
			List<Map<String, Object>> list = gson.fromJson(jsonData, listType);
			
			for (Map<String, Object> row : list) {
				row.put("OUT_YN", "");
				row.put("OUT_MSG", "");
				row.put("ip", ip);
				row.put("empSeq", loginMap.get("empSeq"));
				
				budgetService.saveDeptBgt3(row);
				resultMap = row;
			}
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : cancelDeptBgt2
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 승인 취소
	 */
	@RequestMapping(value="/budget/cancelDeptBgt2")
	@ResponseBody
	public Map<String, Object> cancelDeptBgt2(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/cancelDeptBgt2");
		
		try {
			
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }

	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        map.put("ip", ip);
	        map.put("empSeq", loginMap.get("empSeq"));
			
			budgetService.cancelDeptBgt2(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : inputDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산현황 입력
	 */
	@RequestMapping(value="/budget/inputDeptBgt")
	public String inputDeptBgt(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/inputDeptBgt");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/inputDeptBgt";
	}
	
	/**
	 * @MethodName : getDeptPjtBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예선 현황 입력 조회
	 */
	@RequestMapping(value="/budget/getDeptPjtBgt")
	@ResponseBody
	public Map<String, Object> getDeptPjtBgt(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getDeptPjtBgt");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.getDeptPjtBgt(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : saveDeptPjtBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 현황 입력화면 저장
	 */
	@RequestMapping(value="/budget/saveDeptPjtBgt")
	@ResponseBody
	public Map<String, Object> saveDeptPjtBgt(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/saveDeptPjtBgt");
		
		try {
			
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        
	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        map.put("ip", ip);
	        map.put("empSeq", loginMap.get("empSeq"));
			
			budgetService.saveDeptPjtBgt(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : cancelDeptPjtBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 현황 입력화면 저장 취소
	 */
	@RequestMapping(value="/budget/cancelDeptPjtBgt")
	@ResponseBody
	public Map<String, Object> cancelDeptPjtBgt(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/cancelDeptPjtBgt");
		
		try {
			
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }

	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        map.put("ip", ip);
	        map.put("empSeq", loginMap.get("empSeq"));
			
			budgetService.cancelDeptPjtBgt(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : viewDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산현황 입력
	 */
	@RequestMapping(value="/budget/viewDeptBgt")
	public String viewDeptBgt(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/viewDeptBgt");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/viewDeptBgt";
	}
	
	/**
	 * @MethodName : getDeptPjtBgt2
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산 현황 조회
	 */
	@RequestMapping(value="/budget/getDeptPjtBgt2")
	@ResponseBody
	public Map<String, Object> getDeptPjtBgt2(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getDeptPjtBgt2");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.getDeptPjtBgt2(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getProjectYesilDaebi
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 프로젝트별 예실대비 현황 조회
	 */
	@RequestMapping(value="/budget/getProjectYesilDaebi")
	@ResponseBody
	public Map<String, Object> getProjectYesilDaebi(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getProjectYesilDaebi");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.getProjectYesilDaebi(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : viewDeptBgt
	 * @author : jy
	 * @since : 2020. 7. 8
	 * 설명 : 부서 예산현황 입력
	 */
	@RequestMapping(value="/budget/projectYesilDaebi")
	public String projectYesilDaebi(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/projectYesilDaebi");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/projectYesilDaebi";
	}
	
	/**
	 * @MethodName : applyBgtPlan
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산 기본계획 신청 페이지
	 */
	@RequestMapping(value="/budget/applyBgtPlan")
	public String applyBgtPlan(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/applyBgtPlan");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/applyBgtPlan";
	}
	
	/**
	 * @MethodName : getBgtPlanGrid
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산 기본계획 신청 조회
	 */
	@RequestMapping(value="/budget/getBgtPlanGrid")
	@ResponseBody
	public Map<String, Object> getBgtPlanGrid(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBgtPlanGrid");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.getBgtPlanGrid(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : saveBgtPlan
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산 기본계획 신청
	 */
	@RequestMapping(value="/budget/saveBgtPlan")
	@ResponseBody
	public Map<String, Object> saveBgtPlan(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest){
		logger.info("/budget/saveBgtPlan");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) map.get("delFiles");		
		List<Map<String, Object>> list = gson.fromJson(jsonData, listType);
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        map.put("empSeq", loginMap.get("empSeq"));
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			
			if (String.valueOf(map.get("flag")).equals("single")) { // 단일 전송
				budgetService.saveBgtPlan(map, multi, list);
			}
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	//applyDeptBgt 에서 사용한다!
	
	@RequestMapping(value="/budget/saveBgtPlanDept")
	@ResponseBody
	public Map<String, Object> saveBgtPlanDept(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest){
		logger.info("/budget/saveBgtPlanDept");
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) map.get("delFiles");		
		
		List<Map<String, Object>> list = gson.fromJson(jsonData, listType);
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
			String ip = req.getHeader("X-FORWARDED-FOR");
			if (ip == null) {
				ip = req.getRemoteAddr();
			
			}
			map.put("empSeq", loginMap.get("empSeq"));
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			if (String.valueOf(map.get("flag")).equals("single")) { // 단일 전송
				budgetService.saveBgtPlanDept(map, multi, list);
			}
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : getFileList
	 * @author : jy
	 * @since : 2020. 9. 07
	 * 설명 : getFileList
	 */
	@RequestMapping(value="/budget/getFileList")
	@ResponseBody
	public Map<String, Object> getFileList(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		logger.info("/budget/getFileList");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        map.put("empSeq", loginMap.get("empSeq"));
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			
			List<Map<String, Object>> list = budgetService.getBudgetAttach(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : uploadFile
	 * @author : jy
	 * @since : 2020. 9. 07
	 * 설명 : Budget File Upload
	 */
	@RequestMapping(value="/budget/uploadBudgetFile")
	@ResponseBody
	public Map<String, Object> uploadBudgetFile(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest){
		logger.info("/budget/uploadBudgetFile");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        map.put("empSeq", loginMap.get("empSeq"));
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			
			budgetService.uploadBudgetFile(map, multi);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : updateFile
	 * @author : jy
	 * @since : 2020. 9. 07
	 * 설명 : updateFile
	 */
	@RequestMapping(value="/budget/updateFile")
	@ResponseBody
	public Map<String, Object> updateFile(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		logger.info("/budget/updateFile");
		
		try {
			
			System.out.println("!!!" + map);
			
			budgetService.updateFile(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : cancelBgtPlan
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산기본 계획 취소
	 */
	@RequestMapping(value="/budget/cancelBgtPlan")
	@ResponseBody
	public Map<String, Object> cancelBgtPlan(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/cancelBgtPlan");
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			budgetService.cancelBgtPlan(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : copyBgtPlan
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산 기본계획 전월복사
	 */
	@RequestMapping(value="/budget/copyBgtPlan")
	@ResponseBody
	public Map<String, Object> copyBgtPlan(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/copyBgtPlan");
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			budgetService.copyBgtPlan(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : 종료처리
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산 기본계획 종료처리
	 */
	@RequestMapping(value="/budget/saveEndProcess")
	@ResponseBody
	public Map<String, Object> saveEndProcess(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/saveEndProcess");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        map.put("empSeq", loginMap.get("empSeq"));
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			map.put("reAmt", Long.parseLong(String.valueOf(map.get("reAmt"))));
			map.put("bfAmt", Long.parseLong(String.valueOf(map.get("bfAmt"))));
			
			budgetService.saveEndProcess(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : 집행금액 Fn
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 집행금액 FN (1.예산편성금액, 2.수입집행금액, 3.지출집행금액)
	 */
	@RequestMapping(value="/budget/callGetPjtBudget")
	@ResponseBody
	public Map<String, Object> callGetPjtBudget(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/callGetPjtBudget");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			resultMap.put("endAmt", budgetService.callGetPjtBudget(map));
			
			resultMap.put("BGT_AMT1", budgetService.callGetPjtBudget(map));
			map.put("div", "2");
			resultMap.put("BGT_AMT3", budgetService.callGetPjtBudget(map));
			map.put("div", "3");
			resultMap.put("BGT_AMT10", budgetService.callGetPjtBudget(map));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : 종료처리 취소
	 * @author : jy
	 * @since : 2020. 7. 20
	 * 설명 : 예산 기본계획 종료처리 취소
	 */
	@RequestMapping(value="/budget/cancelEndProcess")
	@ResponseBody
	public Map<String, Object> cancelEndProcess(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/cancelEndProcess");
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			budgetService.cancelEndProcess(map);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : 파일리스트 조회
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 첨부파일 조회
	 */ 
	@RequestMapping(value="/budget/getBudgetAttach")
	@ResponseBody
	public Map<String, Object> getBudgetAttach(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBudgetAttach");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
		
			List<Map<String, Object>> list = budgetService.getBudgetAttach(map);
			 
			resultMap.put("isSucc", "SUCC");
			resultMap.put("list", list);
			
		} catch (Exception e) {
			resultMap.put("isSucc", "FAIL");
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : searchDeptList3
	 * @author : jy
	 * @since : 2020. 7. 26
	 * 설명 : 부서조회3
	 */
	@RequestMapping(value="/budget/searchDeptList3")
	@ResponseBody
	public Map<String, Object> searchDeptList3(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/searchDeptList3");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.searchDeptList3(map);
			
			resultMap.put("resolutionDeptList", list);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getPjtStatus
	 * @author : jy
	 * @since : 2020. 7. 26
	 * 설명 : 상태 가져오기2
	 */
	@RequestMapping(value="/budget/getPjtStatus")
	@ResponseBody
	public Map<String, Object> getPjtStatus(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getPjtStatus");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.getPjtStatus(map);
			
			resultMap.put("list", list);
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : getBgtConfirmGrid
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 예산 기본계획 확정 리스트 조회
	 */
	@RequestMapping(value="/budget/getBgtConfirmGrid")
	@ResponseBody
	public Map<String, Object> getBgtConfirmGrid(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/getBgtConfirmGrid");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.getBgtConfirmGrid(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : confirmBgtPlan
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 확정
	 */ 
	@RequestMapping(value="/budget/confirmBgtPlan")
	@ResponseBody
	public Map<String, Object> confirmBgtPlan(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/confirmBgtPlan");
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			Gson gson = new Gson();
			String jsonData = (String) map.get("param");		
			List<Map<String, Object>> list = gson.fromJson(jsonData, listType);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			
			for (Map<String, Object> map2 : list) {
				map2.put("ip", ip);
				map2.put("OUT_YN", "");
				map2.put("OUT_MSG", "");
				map2.put("empSeq", loginMap.get("empSeq"));
				
				budgetService.confirmBgtPlan(map2);
				
				resultMap = map2;
			}
			 
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : cancelConfirmBgtPlan
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 확정 취소
	 */ 
	@RequestMapping(value="/budget/cancelConfirmBgtPlan")
	@ResponseBody
	public Map<String, Object> cancelConfirmBgtPlan(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest){
		
		logger.info("/budget/cancelConfirmBgtPlan");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
			map.put("ip", ip);
			map.put("OUT_YN", "");
			map.put("OUT_MSG", "");
			map.put("empSeq", loginMap.get("empSeq"));
			
			budgetService.cancelConfirmBgtPlan(map);
			 
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : confirmBgtPlanPage
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 예산 기본계획 확정 페이지
	 */
	@RequestMapping(value="/budget/confirmBgtPlanPage")
	public String confirmBgtPlan(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/confirmBgtPlan");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/confirmBgtPlan";
	}
	
	/**
	 * @MethodName : projectList2
	 * @author : jy
	 * @since : 2020. 7. 27
	 * 설명 : 프로젝트 리스트2
	 */
	@RequestMapping(value="/budget/projectList2")
	@ResponseBody
	public Map<String, Object> projectList2(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/projectList2");
		
		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> list = budgetService.projectList2(map);
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : selectBudgetList
	 * @author : jy
	 * @since : 2020. 7. 28
	 * 설명 : 예산 리스트
	 */
	@RequestMapping(value="/budget/selectBudgetList")
	@ResponseBody
	public Map<String, Object> selectBudgetList(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectBudgetList");
		
		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> list = budgetService.selectBudgetList(map);
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : dailySchdule
	 * @author : hy
	 * @throws NoPermissionException 
	 * @since : 2020. 7. 29 
	 * 설명 : 일계표연동
	 */
	@RequestMapping(value="/budget/dailySchedule")
	public String dailySchdule(Locale locale, Model model, HttpServletRequest servletRequest) throws NoPermissionException {
		
		logger.info("dailySchdule");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("allDept", new Gson().toJson(budgetService.getErpDept(loginVO.getErpCoCd())));

		return "/budget/add/dailySchedule";
	}
	
	/**
	 * @MethodName : selectDailySchedule
	 * @author : jy
	 * @since : 2020. 7. 29
	 * 설명 : 
	 */
	@RequestMapping(value="/budget/selectDailySchedule")
	@ResponseBody
	public Map<String, Object> selectDailySchedule(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectDailySchedule");
		
		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String baseDate = String.valueOf(map.get("baseDate"));
		
		try {
			Calendar cal = Calendar.getInstance();
			cal.set(Integer.parseInt(baseDate.substring(0, 4)), (Integer.parseInt(baseDate.substring(4)) - 1), 1);
			int lastDate = cal.getActualMaximum(cal.DAY_OF_MONTH);
			
			for (int i = 1; i <= lastDate; i++) {
				Map<String, Object> rowMap = new HashMap<String, Object>();
				
				rowMap.put("approKey", "DAILYSCD" + (baseDate + ((i < 10) ? "0" + i : i)));
				rowMap.put("standardDate", (baseDate + ((i < 10) ? "0" + i : i)));
				
				Map<String, Object> returnMap = budgetService.getErpGwLinkInfo(rowMap); // baseDate, status 만들어서 리턴
				
				if (returnMap == null) {
					returnMap = new HashMap<String, Object>();
					returnMap.put("appr_seqn", "");
					returnMap.put("docx_numb", "");
					returnMap.put("appr_dikey", "");
				}
				
				returnMap.put("amt", budgetService.getSumAmtByDate(rowMap)); // 날짜 별 합계금액
				
				int count = Integer.parseInt(budgetService.getDailyScheduleStatus(returnMap));
				
				if (count > 0 && !"".equals(String.valueOf(returnMap.get("appr_seqn")))) {
					returnMap.put("status", "C"); // 취소
				} else if (!"".equals(String.valueOf(returnMap.get("appr_seqn")))) {
					returnMap.put("status", "D"); // 기안
				} else {
					returnMap.put("status", "N"); // 기안건 없음
				}
				
				returnMap.put("baseDate", (baseDate + ((i < 10) ? "0" + i : i)));
				list.add(returnMap);
			}
			
		} catch (Exception e) {
			logger.info("Budget DailySchedule : ", e);
		} 
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	/**
	 * @MethodName : selectDailyScheduleInfo
	 * @author : jy
	 * @since : 2020. 08. 05
	 * 설명 : 
	 */
	@RequestMapping(value="/budget/selectDailyScheduleInfo")
	@ResponseBody
	public Map<String, Object> selectDailyScheduleInfo(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectDailyScheduleInfo");
		
		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> list = null;
		
		try {
			
			list = budgetService.selectDailySchedule(map);
			
		} catch (Exception e) {
			logger.info("Budget DailySchedule : ", e);
		} 
		
		resultMap.put("list", list);
		resultMap.put("total", list.size());
		
		return resultMap;
	}
	
	@RequestMapping(value = "/budget/fileDownLoad")
	@ResponseBody 
	public void fileDownLoad(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws NoPermissionException, SftpException, IOException {
		logger.info("budget/fileDownLoad");
		budgetService.fileDown(map, servletRequest, servletResponse);
	}
	
	@RequestMapping(value = "/budget/excelDownLoad")
	@ResponseBody 
	public void excelDownLoad(@RequestParam Map<String, Object> map,
			HttpServletRequest servletRequest, HttpServletResponse servletResponse,
			@RequestParam String fileName, @RequestParam String fileFullPath) throws NoPermissionException, SftpException, IOException {
		logger.info("budget/excelDownLoad");
		
		map.put("fileName", URLDecoder.decode(fileName, "UTF-8"));
		map.put("fileFullPath", URLDecoder.decode(fileFullPath, "UTF-8"));
		
		budgetService.excelDown(map, servletRequest, servletResponse);
	}
	
	/**
	 * @MethodName : budgetExcel
	 * @author : jy
	 * @since : 2020. 7. 31
	 * 설명 : 
	 */
	@RequestMapping(value="/budget/budgetExcel")
	@ResponseBody
	public Map<String, String> budgetExcel(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response){
		
		logger.info("/budget/budgetExcel");
		
		Map<String, String> returnMap = new HashMap<String, String>();
		String path = "";
		
		try {
			
			Gson gson = new Gson();
			String upperParam = (String) map.get("upperParam");		
			String lowerParam = (String) map.get("lowerParam");
			String title = String.valueOf(map.get("title"));
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			List<Map<String, Object>> upperList = gson.fromJson(upperParam, listType);
			List<Map<String, Object>> lowerList = gson.fromJson(lowerParam, listType);
			
			Map<String, Object> beans  = new HashMap<String, Object>();
			
			for (Map<String, Object> lowerMap : lowerList) {
				lowerMap.put("AMT1", Long.parseLong(String.valueOf(lowerMap.get("AMT1"))));
				lowerMap.put("AMT2", Long.parseLong(String.valueOf(lowerMap.get("AMT2"))));
				lowerMap.put("AMT3", Long.parseLong(String.valueOf(lowerMap.get("AMT3"))));
				lowerMap.put("AMT4", Long.parseLong(String.valueOf(lowerMap.get("AMT4"))));
				lowerMap.put("AMT6", Long.parseLong(String.valueOf(lowerMap.get("AMT6"))));
			}
			
			for (Map<String, Object> upperMap : upperList) {
				upperMap.put("AMT1", Long.parseLong(String.valueOf(upperMap.get("AMT1"))));
				upperMap.put("AMT2", Long.parseLong(String.valueOf(upperMap.get("AMT2"))));
				upperMap.put("AMT3", Long.parseLong(String.valueOf(upperMap.get("AMT3"))));
				upperMap.put("AMT4", Long.parseLong(String.valueOf(upperMap.get("AMT4"))));
				upperMap.put("AMT6", Long.parseLong(String.valueOf(upperMap.get("AMT6"))));
			}
			
			beans.put("list", upperList);
			beans.put("list2", lowerList);
			
			//템플릿 엑셀파일 위치
			if (request.getServerName().contains("localhost") || request.getServerName().contains("127.0.0.1")) {
				path = "C:/seezen/bonbuYesilDeabiExcelTemplate.xlsx";
			} else {
				path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + "bonbuYesilDeabiExcelTemplate.xlsx");
			}
			
        	returnMap = makeExcelFile(path, beans, title, request);
        	
		} catch (Exception e) {
			logger.info("Budget Excel Error : ", e);
		}
		
		return returnMap;
	}
	
	public Map<String, String> makeExcelFile(String path, Map<String, Object> beans, String title, HttpServletRequest request) throws Exception{
		Map<String, String> resultMap = new HashMap<String, String>();
		InputStream is = new BufferedInputStream(new FileInputStream(path));
		String temp = "";
    	XLSTransformer transformer = new XLSTransformer();
        Workbook resultWorkbook = transformer.transformXLS(is, beans);
        
        String uuid = UUID.randomUUID().toString();
        
        if (request.getServerName().contains("localhost") || request.getServerName().contains("127.0.0.1")) {
        	temp = "C:/seezen/" + uuid;
		} else {
			temp = "/home/upload/budgetExcel/" + uuid;
		}
        
    	File dir = new File(temp);
        
        if(!dir.isDirectory()){
        	CommFileUtil.makeDir(temp);
        }
        
        String fileFullPath = temp + File.separator + title + ".xlsx";
        // 저장경로 : 템프파일 경로/파일키/매입세금계산서_승인키.xlsx 으로 저장
        OutputStream os = new FileOutputStream(new File(fileFullPath));
        
        resultMap.put("fileFullPath", fileFullPath);
        resultMap.put("fileName", title + ".xlsx");
        
        resultWorkbook.write(os);
        os.close();
        
        return resultMap;
	}
	
	/**
	 * @MethodName : budgetExcel2
	 * @author : jy
	 * @since : 2020. 8. 3
	 * 설명 : 
	 */
	@RequestMapping(value="/budget/budgetExcel2")
	@ResponseBody
	public Map<String, String> budgetExcel2(@RequestParam Map<String, Object> map, HttpServletRequest request){
		
		logger.info("/budget/budgetExcel2");
		
		String path = "";
		Map<String, String> resultMap = new HashMap<String, String>();
		
		try {
			
			Gson gson = new Gson();
			String param = (String) map.get("param");
			String title = String.valueOf(map.get("title"));
			String templateName = String.valueOf(map.get("templateName"));
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			List<Map<String, Object>> paramList = gson.fromJson(param, listType);
			
			Map<String, Object> beans  = new HashMap<String, Object>();
			int a  = 1;
			
			for (Map<String, Object> paramMap : paramList) {
				System.out.println(a++);
				for (int i = 1; i <= 18; i++) {
					if (paramMap.get("AMT" + i) != null) {
						paramMap.put("AMT" + i, Math.round(Double.parseDouble(String.valueOf(paramMap.get("AMT" + i)))));
					} else if (paramMap.get("BGT_AMT" + i) != null) {
						paramMap.put("BGT_AMT" + i, Double.parseDouble(String.valueOf(paramMap.get("BGT_AMT" + i))));
					}
				}
				
				if (paramMap.get("APPLY_AMT") != null) {
					paramMap.put("APPLY_AMT", Math.round(Double.parseDouble(String.valueOf(paramMap.get("APPLY_AMT")))));
				}
				
				if (paramMap.get("BF_AMT") != null) {
					paramMap.put("BF_AMT", Math.round(Double.parseDouble(String.valueOf(paramMap.get("BF_AMT")))));
				}
				
				if (paramMap.get("RE_AMT") != null) {
					paramMap.put("RE_AMT", Math.round(Double.parseDouble(String.valueOf(paramMap.get("RE_AMT")))));
				}
				
				if (paramMap.get("EXE_AMT") != null) {
					paramMap.put("EXE_AMT", Math.round(Double.parseDouble(String.valueOf(paramMap.get("EXE_AMT")))));
				}
			}
			
			beans.put("list", paramList);
			
			System.out.println("@@@@");
			
			//템플릿 엑셀파일 위치
			if (request.getServerName().contains("localhost") || request.getServerName().contains("127.0.0.1")) {
				path = "C:/seezen/" + templateName + ".xlsx";
			} else {
				path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + templateName + ".xlsx");
			}
        											
			System.out.println("####");
			
        	resultMap = makeExcelFile(path, beans, title, request);
        	
        	
		} catch (Exception e) {
			logger.info("Budget Excel Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : saveHighDept
	 * @author : jy
	 * @since : 2020. 8. 24
	 * 설명 : 상위 부서 설정 (정렬)
	 */
	@RequestMapping(value="/budget/saveHighDept")
	@ResponseBody
	public Map<String, Object> saveHighDept(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/saveHighDept");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) map.get("param");		
		List<Map<String, Object>> list = gson.fromJson(jsonData, listType);
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        
	        resultMap.put("OUT_YN", "Y");
			
			for (Map<String, Object> map2 : list) {
				map2.put("empSeq",  loginVO.getUniqId());
				map2.put("ip", ip);
				map2.put("OUT_YN", "");
				map2.put("OUT_MSG", "");
				
				budgetService.saveHighDept(map2);
				
				if ("N".equals(String.valueOf(map2.get("OUT_YN")))) {
					resultMap = map2;
					break;
				}
			}
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}

		return resultMap;
	}
	
	/**
	 * @MethodName : finishApplyBgt
	 * @author : jy
	 * @since : 2020. 8. 24
	 * 설명 : 예산신청마감
	 */
	@RequestMapping(value="/budget/finishApplyBgt")
	public String finishApplyBgt(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/finishApplyBgt");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/finishApplyBgt";
	}
	
	/**
	 * @MethodName : selectBgtFinish
	 * @author : jy
	 * @since : 2020. 8. 24
	 * 설명 : 마감상태 가져오기
	 */
	@RequestMapping(value="/budget/selectBgtFinish")
	@ResponseBody
	public Map<String, Object> selectBgtFinish(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectBgtFinish");
		
		try {
	        
	        map.put("status", budgetService.selectBgtFinish(map));
	        
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return map;
	}
	
	/**
	 * @MethodName : saveBgtFinish
	 * @author : jy
	 * @since : 2020. 8. 24
	 * 설명 : 예산마감신청
	 */
	@RequestMapping(value="/budget/saveBgtFinish")
	@ResponseBody
	public Map<String, Object> saveBgtFinish(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/saveBgtFinish");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        
	        map.put("empSeq",  loginVO.getUniqId());
	        map.put("ip", ip);
	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        
	        budgetService.saveBgtFinish(map);
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}

		return map;
	}
	
	/**
	 * @MethodName : cancelBgtFinish
	 * @author : jy
	 * @since : 2020. 8. 24
	 * 설명 : 예산마감 취소
	 */
	@RequestMapping(value="/budget/cancelBgtFinish")
	@ResponseBody
	public Map<String, Object> cancelBgtFinish(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/cancelBgtFinish");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
	        String ip = req.getHeader("X-FORWARDED-FOR");
	        if (ip == null) {
	            ip = req.getRemoteAddr();
	        }
	        
	        map.put("empSeq",  loginVO.getUniqId());
	        map.put("ip", ip);
	        map.put("OUT_YN", "");
	        map.put("OUT_MSG", "");
	        
	        budgetService.cancelBgtFinish(map);
		
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}

		return map;
	}
	
	/**
	 * @MethodName : selectBgtPlanRecord
	 * @author : jy
	 * @since : 2020. 8. 24
	 * 설명 : 예산 계획 이력
	 */
	@RequestMapping(value="/budget/selectBgtPlanRecord")
	@ResponseBody
	public Map<String, Object> selectBgtPlanRecord(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectBgtPlanRecord");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.selectBgtPlanRecord(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		} catch (Exception e) {
			logger.info("BUDGET ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : selectBgtStatus
	 * @author : jy
	 * @since : 2020. 8. 25
	 * 설명 : 예산 현황
	 */
	@RequestMapping(value="/budget/selectBgtStatus")
	@ResponseBody
	public Map<String, Object> selectBgtStatus(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectBgtStatus");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.selectBgtStatus(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		} catch (Exception e) {
			logger.info("BUDGET ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : selectPjtBgtStatus
	 * @author : jy
	 * @since : 2020. 8. 25
	 * 설명 : 사업 예산현황 조회
	 */
	@RequestMapping(value="/budget/selectPjtBgtStatus")
	@ResponseBody
	public Map<String, Object> selectPjtBgtStatus(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectPjtBgtStatus");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Map<String, Object>> list = budgetService.selectPjtBgtStatus(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
		} catch (Exception e) {
			logger.info("BUDGET ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : lookupProjectRecord
	 * @author : jy
	 * @since : 2020. 8. 25
	 * 설명 : 프로젝트 이력 조회
	 */
	@RequestMapping(value="/budget/lookupProjectRecord")
	public String lookupProjectRecord(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/lookupProjectRecord");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/lookupProjectRecord";
	}
	
	/**
	 * @MethodName : lookupSaupBgtStatus
	 * @author : jy
	 * @since : 2020. 8. 26
	 * 설명 : 사업 예산 현황 조회
	 */
	@RequestMapping(value="/budget/lookupSaupBgtStatus")
	public String lookupSaupBgtStatus(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/lookupSaupBgtStatus");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/lookupSaupBgtStatus";
	}
	
	/**
	 * @MethodName : saveDailyScheduleStatus
	 * @author : jy
	 * @since : 2020. 8. 26
	 * 설명 : 일계표 취소 상태 저장
	 */
	@RequestMapping(value="/budget/saveDailyScheduleStatus")
	@ResponseBody
	public Map<String, Object> saveDailyScheduleStatus(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/saveDailyScheduleStatus");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("isSucc", true);
		
		try {
			budgetService.saveDailyScheduleStatus(map);
		} catch (Exception e) {
			resultMap.put("isSucc", false);
			logger.info("BUDGET ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : selectMonthSaupBgt
	 * @author : jy
	 * @since : 2020. 9. 7
	 * 설명 : 월별 사업예산 조회
	 */
	@RequestMapping(value="/budget/selectMonthSaupBgt")
	@ResponseBody
	public Map<String, Object> selectMonthSaupBgt(@RequestParam Map<String, Object> map){
		
		logger.info("/budget/selectMonthSaupBgt");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = budgetService.selectMonthSaupBgt(map);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : monthSaupBgt
	 * @author : jy
	 * @since : 2020. 9. 7
	 * 설명 : 사업 예산 현황 화면
	 */
	@RequestMapping(value="/budget/monthSaupBgt")
	public String monthSaupBgt(Locale locale, Model model, HttpServletRequest servletRequest) {
		
		logger.info("/budget/monthSaupBgt");
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("compSeq", loginMap.get("erpCompSeq"));
			model.addAttribute("deptSeq", loginMap.get("deptSeq"));
			model.addAttribute("deptName", loginMap.get("orgnztNm"));
			
		} catch (Exception e) {
			logger.info("Budget Error : ", e);
		}
		
		return "/budget/add/monthSaupBgt";
	}
}