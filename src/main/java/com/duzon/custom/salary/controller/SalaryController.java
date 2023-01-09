package com.duzon.custom.salary.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;
import java.util.UUID;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.solr.common.util.Hash;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.salary.service.SalaryService;
import com.google.gson.Gson;
import com.google.gson.JsonArray;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * @author MHJ
 *
 */
@Controller
public class SalaryController {

	private static final Logger logger = (Logger) LoggerFactory.getLogger(SalaryController.class);

	@Autowired
	private SalaryService salaryService;
	
	/**
     * 급여명세서 page
     * JSY
     * 2022.09.02
     */
	@RequestMapping(value = "/salary/salaryViewDetail", method = RequestMethod.GET)
	public String salaryViewDetail(Model model, @RequestParam Map<String, Object> map,	HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("salaryViewDetail");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		Map<String, Object> requestMap = new HashMap<String, Object>();
		requestMap.put("empSeq", loginVO.getUniqId());
		
		model.addAttribute("joinDay", salaryService.getJoinDay(requestMap));
		
		return "/salary/salaryViewDetail";
		
	}

    @RequestMapping("/salary/hrPayLogin")
    public String hrPayLogin()throws Exception{

        return "/salary/hrPayLogin";
    }
	
	/**
     * 급여명세서 list
     * JSY
     * 2022.09.02
     */
    @RequestMapping("/salary/getSalaryViewDetailList.do")
    public String getSalaryViewDetailList(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model){
    	logger.info("controller getSalaryViewDetailList");
    	
    	System.out.println(params.toString());
        List<Map<String, Object>> list = salaryService.getSalaryViewDetailList(params);
        model.addAttribute("data", list);

        return "jsonView";
    }
	
	/**
     * 급여명세서 popup
     * JSY
     * 2022.09.02
     */
    @RequestMapping(value = "/salary/hrPayLipPop", method = RequestMethod.POST)
	public String hrPaysLipPop(Model model, HttpServletRequest servletRequest, @RequestParam Map<String, Object> map) throws NoPermissionException {
		logger.info("hrPaysLipPop");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
        String ym = map.get("YM").toString();
        
        String searchYear = ym.substring(0, 4);
        String searchMonth = ym.substring(4);
        
        String dtPay = map.get("DT_PAY").toString();
		model.addAttribute("YM", ym);
		model.addAttribute("DT_PAY", dtPay);
		String hrOption = "";
		
		Map<String, Object> submitMap = new HashMap<String, Object>();
		submitMap.put("groupSeq", loginVO.getGroupSeq());
		submitMap.put("compSeq", loginVO.getCompSeq());
		submitMap.put("erpNoEmp", loginVO.getErpEmpCd());
		submitMap.put("ym", ym);
		submitMap.put("dtPay", dtPay);
		submitMap.put("tpReport", map.get("TP_REPORT").toString());
		submitMap.put("tpPay", map.get("TP_PAY").toString());
		submitMap.put("noSeq", map.get("NO_SEQ").toString());
		submitMap.put("hrOption", hrOption);
				
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		Map<String, Object> requestMap = new HashMap<String, Object>();
		requestMap.put("empSeq", loginVO.getUniqId());
		requestMap.put("erpNoEmp", loginVO.getErpEmpCd());
		//requestMap.put("erpNoEmp", "181217002");
		requestMap.put("searchYear", searchYear);
		requestMap.put("searchMonth", searchMonth);
		
		model.addAttribute("joinDay", salaryService.getJoinDay(requestMap));
		
		try {
			model.addAttribute("result", salaryService.getHrPaySlipPop(submitMap));
		}
        catch (Exception e) {
        	logger.info("hrPayslipPop error : {}"+ e);
        }
		
		try {
			model.addAttribute("workingDays", salaryService.getSelectWorkingDays(requestMap));
		}
        catch (Exception e) {
        	logger.info("workingDays error : {}"+ e);
        }
		
		try {
			model.addAttribute("yetWorkingDays", salaryService.getSelectYetWorkingDays(requestMap));
		}
        catch (Exception e) {
        	logger.info("yetWorkingDays error : {}"+ e);
        }
		
		try {
			model.addAttribute("annualDays", salaryService.getSelectAnnualDays(requestMap));
		}
        catch (Exception e) {
        	logger.info("annualDays error : {}"+ e);
        }
		
		try {
			model.addAttribute("OverWork", salaryService.getSelectOverWork(requestMap));
		}
        catch (Exception e) {
        	logger.info("getSelectOverWork error : {}"+ e);
        }
		
		try {
			model.addAttribute("selectDalmMonthList", salaryService.getSelectDalmMonthList(requestMap));
		}
        catch (Exception e) {
        	logger.info("getSelectDalmMonthList error : {}"+ e);
        }
		
		
		return "/salary/hrPayLipPop";
	}
}
