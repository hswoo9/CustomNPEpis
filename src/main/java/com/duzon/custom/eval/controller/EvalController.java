package com.duzon.custom.eval.controller;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.duzon.custom.common.utiles.DateUtil;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.busTrip.service.BusTripService;
import com.duzon.custom.commcode.service.CListService;
import com.duzon.custom.common.excel.ExcelCreate;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.eval.service.EvalService;
import com.duzon.custom.eval.vo.CommitteeVO;
import com.duzon.custom.eval.vo.EvalVO;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.google.gson.Gson;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import ac.g20.code.sercive.AcG20CodeService;
import ac.g20.ex.service.AcG20ExService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;

/**
 * 제안평가
 * yh
 */
@Controller
public class EvalController {

	private static final Logger logger = LoggerFactory.getLogger(EvalController.class);
	
	@Autowired
	private EvalService evalService;
	
	@Autowired
	private CListService cListService;

	@Autowired
	private BusTripService busTripService;
	
	@Autowired
	CommonService commonService;
	
	@Resource(name ="AcCommonService")
	AcCommonService acCommonService;
	
	@Resource(name ="AcG20CodeService")
	AcG20CodeService acG20CodeService;
	
	@Resource(name = "AcG20ExService")
	AcG20ExService acG20ExService;
	
	@Autowired
	private ResAlphaG20Service resAlphaG20Service;
	
	private ConnectionVO conVo	= new ConnectionVO();


	/**
	 * 2020. 5. 7.
	 * yh
	 * :평가위원 등록화면
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeViwe", method = RequestMethod.GET)
	public String evaluationCommitteeViwe(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationCommitteeViwe");
		
		List<Map<String, Object>> list = commonService.getBankCode();
		model.addAttribute("bankList", list);
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		map.put("group_code", "EVAL_JOB_TYPE"); 
		model.addAttribute("jobList", cListService.getCommCodeList(map));
		
		return "/eval/evaluationCommitteeViwe";
	}

	/**
	 * 2020. 5. 7.
	 * yh
	 * :평가위원 수정화면
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeMod", method = RequestMethod.GET)
	public String evaluationCommitteeMod(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationCommitteeMod");
		
		evalService.getCommittee(map, model);
		
		List<Map<String, Object>> list = commonService.getBankCode();
		model.addAttribute("bankList", list);
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		map.put("group_code", "EVAL_JOB_TYPE"); 
		model.addAttribute("jobList", cListService.getCommCodeList(map));
		
		return "/eval/evaluationCommitteeMod";
	}
	
	@RequestMapping(value = "/eval/evaluationCommitteeDetail", method = RequestMethod.POST)
	public String evaluationCommitteeDetail(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationCommitteeDetail");
		
		evalService.getCommittee(map, model);
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		return "/eval/evaluationCommitteeDetail";
	}
	
	/**
	 * 2020. 5. 7.
	 * yh
	 * :평가위원 목록
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeList", method = RequestMethod.GET)
	public String evaluationCommitteeList(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationCommitteeList");
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		return "/eval/evaluationCommitteeList";
	}
	
	
	
	/**
	 * 2020. 5. 7.
	 * yh
	 * :평가위원 등록
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeViweSave", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evaluationCommitteeViweSave(@RequestParam Map<String, Object> map, EvalVO evalVo) {
		logger.debug("evaluationCommitteeViweSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		evalVo.setCreate_emp_seq(loginVO.getUniqId());
		
		evalService.evaluationCommitteeViweSave(evalVo);
		
		return map;
		
	}

	/**
	 * 2020. 5. 8.
	 * yh
	 * :평가위원 수정
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeViweUpdate", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evaluationCommitteeViweUpdate(@RequestParam Map<String, Object> map, EvalVO evalVo) {
		logger.debug("evaluationCommitteeViweUpdate");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		evalVo.setCreate_emp_seq(loginVO.getUniqId());
		
		evalService.evaluationCommitteeViweUpdate(evalVo);
		
		return map;
		
	}

	/**
	 * 2020. 5. 8.
	 * yh
	 * :평가위원 그리드 검색
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeListSearch") 
	@ResponseBody
	public Map<String, Object> evaluationCommitteeListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationCommitteeListSearch");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			resultMap = evalService.evaluationCommitteeListSearch(map);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
		
	}
	
	/**
	 * :평가위원 팝업 검색
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeListSearchPop") 
	@ResponseBody
	public Map<String, Object> evaluationCommitteeListSearchPop(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationCommitteeListSearchPop");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			resultMap = evalService.getEvalCommListPop(map);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
		
	}

	/**
	 * 2020. 5. 8.
	 * yh
	 * :평가위원 삭제
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeDel", method = RequestMethod.POST) 
	@ResponseBody
	public void evaluationCommitteeDel(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationCommitteeDel");
		
		evalService.evaluationCommitteeDel(map);
		
	}
	
	/**
	 * 2020. 5. 8.
	 * yh
	 * :평가부문 리스트 화면
	 */
	@RequestMapping(value = "/eval/evalBizTypeList", method = RequestMethod.GET)
	public String evalBizTypeList(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evalBizTypeList");
		
		map.put("group_code", "EVAL_BIZ_TYPE");
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		return "/eval/evalBizTypeList";
	}
	
	/**
	 * 2020. 5. 8.
	 * yh
	 * :평가부문 등록조회
	 */
	@RequestMapping(value = "/eval/evalBizTypeListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeListSearch");
		
		return evalService.evalBizTypeListSearch(map);
		
	}
	
	@RequestMapping(value = "/eval/evalBizTypeSave", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeSave(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evalBizTypeSave(map);
		
		return map;
		
	}
	
	@RequestMapping(value = "/eval/evalBizTypeDel", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeDel(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeDel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evalBizTypeDel(map);
		
		return map;
		
	}
	
	@RequestMapping(value = "/eval/evalBizTypeItemList", method = RequestMethod.GET)
	public String evalBizTypeItemList(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evalBizTypeItemList");
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		return "/eval/evalBizTypeItemList";
	}
	
	@RequestMapping(value = "/eval/evalTypeSearch", method = RequestMethod.POST) 
	@ResponseBody
	public List<Map<String, Object>> evalTypeSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evalTypeSearch");
		
		return evalService.evalTypeSearch(map);
		
	}

	@RequestMapping(value = "/eval/evalBizTypeItemListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeItemListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeItemListSearch");
		
		return evalService.evalBizTypeItemListSearch(map);
		
	}
	
	@RequestMapping(value = "/eval/evalBizTypeItemDel", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeItemDel(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeItemDel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evalBizTypeItemDel(map);
		
		return map;
		
	}
	
	@RequestMapping(value = "/eval/evalBizTypeItemSave", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeItemSave(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeItemSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evalBizTypeItemSave(map);
		
		return map;
		
	}
	
	@RequestMapping(value = "/eval/evalBizTypeItemUpdate", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalBizTypeItemUpdate(@RequestParam Map<String, Object> map) {
		logger.debug("evalBizTypeItemUpdate");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evalBizTypeItemUpdate(map);
		
		return map;
		
	}
	
	//제안평가 목록
	@RequestMapping(value = "/eval/evaluationProposalList", method = RequestMethod.GET)
	public String evaluationProposalList(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalList");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		
		return "/eval/evaluationProposalList";
	}

	//제안평가 목록 관리자
	@RequestMapping(value = "/eval/evaluationProposalListAdmin", method = RequestMethod.GET)
	public String evaluationProposalListAdmin(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalListAdmin");

		return "/eval/evaluationProposalListAdmin";
	}
	
	/**
	 * 2020. 11. 23
	 * HEEJIN
	 * : 제안평가 메뉴 분리
	 */
	//제안평가 등록
	@RequestMapping(value = "/eval/evaluationProposalEnroll", method = RequestMethod.GET)
	public String evaluationProposalEnroll(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalEnroll");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		
		return "/eval/evaluationProposalEnroll";
	}

	/**
	 * 2022. 10. 20
	 * JSY
	 * : 제안평가 메뉴 분리2, 구성요청서 등록 페이지
	 */
	@RequestMapping(value = "/eval/evaluationProposalConfiguration", method = RequestMethod.GET)
	public String evaluationProposalConfiguration(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalConfiguration");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);

		model.addAttribute("btcList", cListService.getCommCodeList(map));


		List<Map<String, Object>> list = commonService.getBankCode();
		model.addAttribute("bankList", list);

		map.put("group_code", "EVAL_BIZ_TYPE");
		model.addAttribute("btcList", cListService.getCommCodeList(map));

		map.put("group_code", "EVAL_JOB_TYPE");
		model.addAttribute("jobList", cListService.getCommCodeList(map));

		return "/eval/evaluationProposalConfiguration";
	}

	/**
	 * 2022. 10. 20
	 * JSY
	 * : 구성요청서 리스트 페이지
	 */
	@RequestMapping(value = "/eval/evaluationProposalConfigurationView", method = RequestMethod.GET)
	public String evaluationProposalConfigurationView(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalConfigurationView");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);

		return "/eval/evaluationProposalConfigurationView";
	}

	/**
	 * 2022. 10. 21
	 * JSY
	 * : 구성요청서 기안 팝업
	 */
	@RequestMapping(value = "/eval/evalApprovalPop", method = RequestMethod.GET)
	public String evalApprovalPop(@RequestParam Map<String, Object>params, Model model) {
		logger.debug("evalApprovalPop");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("params", params);
		model.addAttribute("loginVO", loginVO);

		params.put("code", params.get("evalReqId"));

		//DATA
		Map<String, Object> commDetail = evalService.getEvaluationProposal2(params);
		//List<Map<String, Object>> commUserList = evalService.getEvalCommUserList(params);

		//로그인 한 사용자의 장
		Map<String, Object> login = new HashMap<>();
		login.put("loginVO", loginVO);

		model.addAttribute("getJangName", evalService.getJangName(login));

		//기본정보
		model.addAttribute("commDetail", commDetail);

		//평가업체
		//model.addAttribute("company", evalService.getEvalCompany(params));

		//평가분야
		//model.addAttribute("item", evalService.getcommItem(params));

		//평가위원
		//model.addAttribute("commUserList", commUserList);

		//전문분야
		//model.addAttribute("commTypeList", evalService.getEvalCommTypeList(params));

		//model.addAttribute("toDate", DateUtil.getToday(""));

		logger.info("return ********** /eval/evalApprovalPop");
		logger.info("return ********** /eval/evalApprovalPop");
		logger.info("return ********** /eval/evalApprovalPop");

		return "/eval/evalApprovalPop";
	}


	
	/**
	 * 2022. 03. 04
	 * 김혜린
	 * : 제안평가 보기
	 */
	//제안평가 등록
	@RequestMapping(value = "/eval/evaluationProposalViewDetail", method = RequestMethod.GET)
	public String evaluationProposalViewDetail(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalViewDetail");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);

		return "/eval/evaluationProposalViewDetail";
	}
	
	//제안평가 평가위원 생성
	@RequestMapping(value = "/eval/evaluationProposalCommissioner", method = RequestMethod.GET)
	public String evaluationProposalCommissioner(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalCommissioner");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		
		return "/eval/evaluationProposalCommissioner";
	}
	
	//제안평가 ID 발급
	@RequestMapping(value = "/eval/evaluationProposalIDIssue", method = RequestMethod.GET)
	public String evaluationProposalIDIssue(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalIDIssue");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		
		return "/eval/evaluationProposalIDIssue";
	}
	
	//제안평가 평가수당
	@RequestMapping(value = "/eval/evaluationProposalExtraPay", method = RequestMethod.GET)
	public String evaluationProposalExtraPay(@RequestParam Map<String, Object>map, Model model) {
		logger.debug("evaluationProposalExtraPay");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		
		return "/eval/evaluationProposalExtraPay";
	}

	@RequestMapping(value = "/eval/evaluationProposalView", method = RequestMethod.GET)
	public String evaluationProposalView(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalView");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		if(map.get("pageCode").equals("1")){
			//구매 업체 평가
			return "/eval/evaluationProposalViewPage1";
		}else{
			//신규 업체 평가
			return "/eval/evaluationProposalViewPage2";
		}
		
	}

	/**
	 * 2020. 5. 30.
	 * yh
	 * :제안평가 상세
	 */
	@RequestMapping(value = "/eval/evaluationProposalMod", method = RequestMethod.GET)
	public String evaluationProposalMod(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalMod");
		
		map.put("pageType", "confirm");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		Map<String, Object> commDetail = evalService.getEvaluationProposal(map);
		List<Map<String, Object>> commUserList = evalService.getEvalCommUserList(map);
		
		//기본정보
		model.addAttribute("commDetail", commDetail);
		
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		//평가분야
		model.addAttribute("item", evalService.getcommItem(map));
		
		//평가위원
		model.addAttribute("commUserList", commUserList);
		
		//전문분야
		model.addAttribute("commTypeList", evalService.getEvalCommTypeList(map));
		
		
		if(commDetail.get("final_active").equals("N")){
			
			map.put("group_code", "EVAL_BIZ_TYPE"); 
			model.addAttribute("btcList", cListService.getCommCodeList(map));
			
			if(commDetail.get("join_select_type").equals("Y")){
				//구매
				return "/eval/evaluationProposalViewPage1";
			}else{
				//신규
				return "/eval/evaluationProposalViewPage2";
			}
		}else{
			return "/eval/evaluationProposalMod";
		}
		
	}
	
	@RequestMapping(value = "/eval/evaluationProposalViewSave", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evaluationProposalViewSave(@RequestParam Map<String, Object> map, CommitteeVO committeeVO) {
		logger.debug("evaluationProposalViewSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		committeeVO.setCreate_emp_seq(loginVO.getUniqId());
		
		return evalService.evaluationProposalViewSave(committeeVO, map);
		
	}

	/**
	 * 2022. 10. 25.
	 * jsy
	 * : 구성요청서 저장
	 */
	@RequestMapping(value = "/eval/evaluationProposalConfigurationViewSave", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> evaluationProposalConfigurationViewSave(@RequestParam Map<String, Object> map, CommitteeVO committeeVO) {
		logger.debug("evaluationProposalConfigurationViewSave");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		committeeVO.setCreate_emp_seq(loginVO.getUniqId());

		return evalService.evaluationProposalConfigurationViewSave(committeeVO, map);

	}

	@RequestMapping(value = "/eval/evaluationProposalListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evaluationProposalListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationProposalListSearch");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		return evalService.evaluationProposalListSearch(map);
		
	}

	@RequestMapping(value = "/eval/evaluationProposalConfigurationListSearch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> evaluationProposalConfigurationListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationProposalConfigurationListSearch");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		map.put("empSeq", loginVO.getUniqId());

		return evalService.evaluationProposalConfigurationListSearch(map);

	}

	/**
	 * 2020. 7. 21.
	 * yh
	 * :평가삭제
	 */
	@RequestMapping(value = "/eval/evaluationProposalListDel", method = RequestMethod.POST) 
	@ResponseBody
	public void evaluationProposalListDel(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationProposalListDel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evaluationProposalListDel(map);
	}
	
	/**
	 * 2020. 11. 23.
	 * HEEJIN
	 * : 최종승인 변경
	 */
	@RequestMapping(value = "/eval/finalApprovalActiveSave", method = RequestMethod.POST)
	@ResponseBody
	public void finalApprovalActiveSave(@RequestParam Map<String, Object> map) {
		logger.debug("finalApprovalActiveSave");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		map.put("empSeq", loginVO.getUniqId());
		evalService.finalApprovalActiveSave(map);
	}
	
	/**
	 * 2020. 5. 29.
	 * yh
	 * :평가위원 등록화면
	 */
	@RequestMapping(value = "/eval/evaluationProposalDetail", method = RequestMethod.GET)
	public String evaluationProposalDetail(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalDetail");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		List<Map<String, Object>> commUserList = evalService.getEvalCommUserList(map);
		
		model.addAttribute("commDetail", evalService.getEvaluationProposal(map));
		model.addAttribute("commUserList", commUserList);
		model.addAttribute("commUserListJson", new Gson().toJson(commUserList));
		model.addAttribute("commTypeList", new Gson().toJson(evalService.getEvalCommTypeList(map)));
		
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		//평가분야
		model.addAttribute("item", evalService.getcommItem(map));
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		model.addAttribute("tabN", map.get("tabN"));
		
		return "/eval/evaluationProposalDetail";
	}
	
	/**
	 * 2020. 5. 29.
	 * yh
	 * :평가위원 등록화면 임시
	 */
	@RequestMapping(value = "/eval/evaluationProposalDetailtmp", method = RequestMethod.GET)
	public String evaluationProposalDetailtmp(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalDetail");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		model.addAttribute("commDetail", evalService.getEvaluationProposal(map));
		model.addAttribute("commUserList", evalService.getEvalCommUserList(map));
		model.addAttribute("commTypeList", new Gson().toJson(evalService.getEvalCommTypeList(map)));
		
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		//평가분야
		model.addAttribute("item", evalService.getcommItem(map));
		
		map.put("group_code", "EVAL_BIZ_TYPE"); 
		model.addAttribute("btcList", cListService.getCommCodeList(map));
		
		model.addAttribute("tabN", map.get("tabN"));
		
		return "/eval/evaluationProposalDetail_210824";
	}
	
	/**
	 * 2020. 5. 29.
	 * yh
	 * :평가위원 ID발급
	 */
	@RequestMapping(value = "/eval/evaluationIdView", method = RequestMethod.GET)
	public String evaluationIdView(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationIdView");
		map.put("pageType", "confirm");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		Map<String, Object> commDetail = evalService.getEvaluationProposal(map);
		List<Map<String, Object>> commUserList = evalService.getEvalCommUserList(map);
		
		model.addAttribute("commDetail", commDetail);
		model.addAttribute("commUserList", commUserList);
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		//평가분야
		model.addAttribute("item", evalService.getcommItem(map));
		
		model.addAttribute("evalIdList", evalService.getEvalIdList(map));
		
		return "/eval/evaluationIdView";
	}
	
	@RequestMapping(value = "/eval/evaluationIdListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evaluationIdListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationIdListSearch");
		
		return evalService.evaluationIdListSearch(map);
	}
	
	@RequestMapping(value = "/eval/evaluationIdViewSave", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evaluationIdViewSave(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationIdViewSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		map.put("empSeq", loginVO.getUniqId());
		
		return evalService.evaluationIdViewSave(map);
	}
	
	@RequestMapping(value = "/eval/evaluationIdViewDel", method = RequestMethod.POST) 
	@ResponseBody
	public void evaluationIdViewDel(@RequestParam Map<String, Object> map) {
		logger.debug("evaluationIdViewDel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		map.put("empSeq", loginVO.getUniqId());
		
		evalService.evaluationIdViewDel(map);
	}

	@RequestMapping(value = "/eval/getEvalItemList", method = RequestMethod.POST) 
	@ResponseBody
	public List<Map<String, Object>> getEvalItemList(@RequestParam Map<String, Object> map) {
		logger.debug("getEvalItemList");
		
		return evalService.getEvalItemList(map);
	}

	/**
	 * 2020. 5. 28.
	 * yh
	 * :평가위원 조회
	 */
	@RequestMapping(value = "/eval/getEvalCommList", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> getEvalCommList(@RequestParam Map<String, Object> map) {
		logger.debug("getEvalCommList");
		
		return evalService.getEvalCommList(map);
	}
	
	/**
	 * 2020. 5. 28.
	 * yh
	 * :평가위원 등록
	 */
	@RequestMapping(value = "/eval/setEvalCommSave", method = RequestMethod.POST) 
	@ResponseBody
	public void setEvalCommSave(@RequestParam Map<String, Object> map) {
		logger.debug("setEvalCommSave");
		
		evalService.setEvalCommSave(map);
	}
	
	/**
	 * 2020. 5. 28.
	 * yh
	 * :평가위원 등록 ( 이후 추가 확정 )
	 */
	@RequestMapping(value = "/eval/setEvalCommSave2", method = RequestMethod.POST) 
	@ResponseBody
	public void setEvalCommSave2(@RequestParam Map<String, Object> map) {
		logger.debug("setEvalCommSave2");
		
		evalService.setEvalCommSave2(map);
	}

	@RequestMapping(value = "/eval/setevalIdSave", method = RequestMethod.POST) 
	@ResponseBody
	public void setevalIdSave(@RequestParam Map<String, Object> map) {
		logger.debug("setevalIdSave");
		
		evalService.setevalIdSave(map);
	}
	
	@RequestMapping(value = "/eval/evaluationIdCrtView", method = RequestMethod.GET)
	public String evaluationIdCrtView(@RequestParam Map<String, Object> map, Model model, HttpServletRequest request) {
		logger.debug("evaluationIdCrtView");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		return "/eval/evaluationIdCrtView";
	}
	
	@RequestMapping(value = "/eval/getEvalUserIdChk", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> getEvalUserIdChk(@RequestParam Map<String, Object> map) {
		logger.debug("getEvalUserIdChk");
		
		return evalService.getEvalUserIdChk(map);
		
	}

	/**
	 * 2020. 6. 24.
	 * yh
	 * :참여기관 그리드 조회
	 */
	@RequestMapping(value = "/eval/joinOrgGridList", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> joinOrgGridList(@RequestParam Map<String, Object> map) {
		logger.debug("joinOrgGridList");
		
		return evalService.joinOrgGridList(map);
		
	}

	/**
	 * 2020. 7. 10.
	 * yh
	 * :평가분야 불러오기
	 */
	@RequestMapping(value = "/eval/getEvaCommListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public List<Map<String, Object>> getEvaCommListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("getEvaCommListSearch");
		
		return evalService.getEvaCommList(map);
		
	}

	/**
	 * 2020. 7. 10.
	 * yh
	 * :아이템 조회
	 */
	@RequestMapping(value = "/eval/getEvalCommItemList", method = RequestMethod.POST) 
	@ResponseBody
	public List<Map<String, Object>> getEvalCommItemList(@RequestParam Map<String, Object> map) {
		logger.debug("getEvalCommItemList");
		
		return evalService.getEvalCommItemList(map);
		
	}
	
	/**
	 * 2020. 8. 15.
	 * yh
	 * :평가 결과 팝업
	 */
	@RequestMapping(value = "/eval/evalResult", method = RequestMethod.POST)
	public String evalResult(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evalResult");
		
		//기본정보
		model.addAttribute("commDetail", evalService.getEvaluationProposal(map));
		
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		return "/eval/evalResult";
	}
	
	@RequestMapping(value = "/eval/evalResultList", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalResultList(@RequestParam Map<String, Object> map) {
		logger.debug("evalResultList");
		
		return evalService.evalResultList(map);
		
	}

	@RequestMapping(value = "/eval/evalCompanyList", method = RequestMethod.GET)
	public String evalCompanyList(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evalCompanyList");
		
		return "/eval/evalCompanyList";
	}

	@RequestMapping(value = "/evaluation/evalCompanyListSearch.do", method = RequestMethod.POST)
	public String evalCompanyListSearch(@RequestParam Map<String, Object> map, Model model) {

		model.addAttribute("rs", evalService.evalCompanyListSearch(map));
		return "jsonView";
	}

	@RequestMapping(value = "/eval/evalCompanySave", method = RequestMethod.POST) 
	@ResponseBody
	public void evalCompanySave(@RequestParam Map<String, Object> map) {
		logger.debug("evalCompanySave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("emp_seq", loginVO.getUniqId());
		
		evalService.evalCompanySave(map);
		
	}

	@RequestMapping(value = "/eval/evalCompanyDel", method = RequestMethod.POST) 
	@ResponseBody
	public void evalCompanyDel(@RequestParam Map<String, Object> map) {
		logger.debug("evalCompanyDel");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("emp_seq", loginVO.getUniqId());
		
		evalService.evalCompanyDel(map);
		
	}

	@RequestMapping(value = "/eval/evalCommFix", method = RequestMethod.POST) 
	@ResponseBody
	public void evalCommFix(@RequestParam Map<String, Object> map) {
		logger.debug("evalCommFix");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("emp_seq", loginVO.getUniqId());
		
		evalService.evalCommFix(map);
		
	}

	@RequestMapping(value = "/eval/evaluationProposalTransExp", method = RequestMethod.GET) 
	public String evaluationProposalTransExp(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evaluationProposalTransExp");
		
		map.put("pageType", "confirm");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		
		//기본정보
		model.addAttribute("commDetail", evalService.getEvaluationProposal(map));
		
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		//평가분야
		model.addAttribute("item", evalService.getcommItem(map));
		
		//평가위원
		model.addAttribute("commUserList", evalService.getEvalCommUserList(map));
		
		//전문분야
		model.addAttribute("commTypeList", evalService.getEvalCommTypeList(map));

		//광역지역별 교통비용
//		model.addAttribute("orailCityList", busTripService.getKorailCity());
//		model.addAttribute("orailCityList", commonService.getCode("TR_PLACE", ""));
		model.addAttribute("orailCityList", commonService.getCode("TR_PLACE_COST", ""));
		 
		return "/eval/evaluationProposalTransExp";		
	}
	
	@RequestMapping(value = "/eval/evalTransPaySave", method = RequestMethod.POST) 
	@ResponseBody
	public void evalTransPaySave(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi) {
		logger.debug("evalTransPaySave");
		
		evalService.evalTransPaySave(map, multi);
		
	}

	@RequestMapping(value = "/eval/purcListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public List<Map<String, Object>> purcListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("purcListSearch");
		
		return evalService.purcListSearch(map);
		
	}

	/**
	 * 2020. 7. 23.
	 * yh
	 * :거래입찰 업체 리스트
	 */
	@RequestMapping(value = "/eval/getPurcBiddingList", method = RequestMethod.POST) 
	@ResponseBody
	public List<Map<String, Object>> getPurcBiddingList(@RequestParam Map<String, Object> map) {
		logger.debug("getPurcBiddingList");
		
		return evalService.getPurcBiddingList(map);
		
	}

	/**
	 * 2020. 7. 23.
	 * yh
	 * :평가위원 불참 저장
	 */
	@RequestMapping(value = "/eval/evalCommCancel", method = RequestMethod.POST) 
	@ResponseBody
	public void evalCommCancel(@RequestParam Map<String, Object> map) {
		logger.debug("evalCommCancel");
		
		evalService.evalCommCancel(map);
		
	}

	/**
	 * 2020. 7. 23.
	 * yh
	 * :평가위원 랜덤생성 리스트 엑셀출력
	 */
	@RequestMapping(value = "/eval/evalGetUserList", method = RequestMethod.GET) 
	@ResponseBody
	public void evalGetUserList(@RequestParam Map<String, Object> map, HttpServletResponse response, HttpServletRequest request) {
		logger.debug("evalGetUserList");
		
		List<Map<String, Object>> list = evalService.getEvalCommUserList(map);
		
		String contents = evalService.getEvalContents(map);
		
		String tempPath = request.getSession().getServletContext().getRealPath("/resources/exceltemplate/evalCommList.xlsx");
		
		ExcelCreate excel = new ExcelCreate();
		
		String version = "xlsx";
		Workbook resultWorkbook = excel.createWorkbook(version);
		
		String fileNm = "평가위원목록_" + String.valueOf(map.get("tabNum")) + "차." + version;
		
		try {
			fileNm = URLEncoder.encode(fileNm, "UTF-8");
			fileNm = fileNm.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		map.put("list", list);
		map.put("contents", contents);
	       
        try {
            InputStream is = new BufferedInputStream(new FileInputStream(tempPath));
            XLSTransformer transformer = new XLSTransformer();
            resultWorkbook = transformer.transformXLS(is, map);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileNm + "\"");
            OutputStream os = response.getOutputStream();
            resultWorkbook.write(os);
           
        } catch (ParsePropertyException | InvalidFormatException | IOException ex) {
        	logger.error("MakeExcel");
        }

	}
	
	/**
	 * 2020. 7. 23.
	 * yh
	 * :평가 종료 리스트
	 * @throws Exception 
	 */
	@RequestMapping(value = "/eval/evalAnList", method = RequestMethod.GET) 
	public String evalAnList(@RequestParam HashMap<String, String> paraMap, Model model, HttpServletRequest request) throws Exception {
		logger.debug("evalAnList");
		
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put( "requestUrl", request.getRequestURI( ) );
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		conVo = GetConnection();
		//회계단위 목록
		if(paraMap.get("CO_CD") == null || paraMap.get("CO_CD").equals("")){
			paraMap.put("CO_CD", loginVO.getErpCoCd());
		}

		if(paraMap.get("BASE_DT") == null || paraMap.get("BASE_DT").equals("")){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String BASE_DT = sdf.format(new Date());
			paraMap.put("BASE_DT", BASE_DT);
		}
		
		paraMap.put("LANGKIND", loginVO.getLangCode());
		List<HashMap<String, String>> selectList = acG20CodeService.getErpDIVList(conVo, paraMap);


		//기수정보
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		paraMap.put("GISU_DT", dateFormat.format(cal.getTime()));
		
		HashMap<String, String> gisuInfo = acG20ExService.getErpGisuInfo(conVo, paraMap);
		
		model.addAttribute("gisuInfo", gisuInfo);
		model.addAttribute("erpDivSeq", selectList.get(0));
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("allDept", allDept);
		model.addAttribute( "params", paraMap );
		
		return "/eval/evalAnList";		
	}
	
	/**
	 * 2020. 7. 23.
	 * yh
	 * :평가 종료 리스트 조회
	 */
	@RequestMapping(value = "/eval/evalAnListSearch", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalAnListSearch(@RequestParam Map<String, Object> map) {
		logger.debug("evalAnListSearch");
		
		return evalService.evalAnListSearch(map);
		
	}
	
	/**
	 * 2020. 7. 31.
	 * yh
	 * :평가위원 인쇄
	 */
	@RequestMapping(value = "/eval/evalPrintView", method = RequestMethod.POST) 
	public String evalPrintView(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("evalPrintView");
		
		map.put("pass", "all");
		map.put("pageType", "confirm");
		
		//기본정보
		model.addAttribute("commDetail", evalService.getEvaluationProposal(map));
		
		//평가업체
		model.addAttribute("company", evalService.getEvalCompany(map));
		
		//평가분야
		model.addAttribute("item", evalService.getcommItem(map));
		
		//평가위원
		model.addAttribute("commUserList", evalService.getEvalCommUserList(map));
		
		//전문분야
		model.addAttribute("commTypeList", evalService.getEvalCommTypeList(map));
		
		return "/eval/evalPrintView" + map.get("print_code");		
	}
	
	/**
	 * 2020. 7. 31.
	 * yh
	 * :평가위원 결의
	 */
	@RequestMapping(value = "/eval/eval_out_process", method = RequestMethod.GET) 
	public String eval_out_process(@RequestParam Map<String, Object> map, Model model) {
		logger.debug("eval_out_process");
		
		Gson g = new Gson();
		
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		
		//결의유저 (거래처) g20 주민번호 비교 필요
		List<Map<String, Object>> anList = evalService.getCommissionerAnUserList(map);
		
		//결의서 작성정보
		Map<String, Object> anData = evalService.getEvalAnData(map);
		
		model.addAttribute("anList", g.toJson(anList));
		model.addAttribute("anData", g.toJson(anData));

		model.addAttribute("userInfo", loginVO);
		
		return "/eval/eval_out_process";
	}
	
	/**
	 * 2020. 7. 31.
	 * yh
	 * :평가위원 결의 임시저장
	 */
	@RequestMapping(value = "/eval/evalAnTempSave", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalAnTempSave(@RequestParam Map<String, Object> map) {
		logger.debug("evalAnTempSave");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		map.put("compSeq", loginVO.getCompSeq());
		map.put("empSeq", loginVO.getUniqId());
		
		return evalService.evalAnTempSave(map);
		
	}
	
	@RequestMapping(value = "/dclz/evalAnOutProcess")
	public ModelAndView evalAnOutProcess(@RequestBody Map<String, Object> requestMap) {
		logger.debug("evalAnOutProcess");
		
		ModelAndView mav = new ModelAndView();
		
		evalService.evalAnOutProcess(requestMap);
		
		try {
			
			logger.info("============ approvalProcessCustom ================");
			
			logger.info("requestMap : " + requestMap);
			if (requestMap.get("resDocSeq") != null && !"".equals(requestMap.get("resDocSeq"))) {
				requestMap.put("targetType", "resDocSeq");
				requestMap.put("targetSeq", requestMap.get("resDocSeq"));
			} else if (requestMap.get("consDocSeq") != null && !"".equals(requestMap.get("consDocSeq"))) {
				requestMap.put("targetType", "consDocSeq");
				requestMap.put("targetSeq", requestMap.get("consDocSeq"));
			}
			logger.info("requestMap : " + requestMap);
			
			resAlphaG20Service.saveUseOnnaraDocs(requestMap);
			
			requestMap.put("C_DIKEYCODE", requestMap.get("docSeq"));
			
			logger.info("============ approvalProcessCustom ================");
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		mav.addObject("resultCode", "SUCCESS");
		mav.addObject("resultMessage", "성공하였습니다.");
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	
	
	/**
	 * 2020. 9. 3.
	 * yh
	 * :erp연동
	 */
	private ConnectionVO GetConnection() throws Exception{
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginVO", loginVO);
		return acCommonService.acErpSystemInfo(param);
	}
	
	
	
	/**
	 * 2021. 8. 27.
	 * phj
	 * :평가위원 서명파일 다운로드
	 * @throws Exception 
	 */
	@RequestMapping(value = "/eval/evalProposalModFileDownload") 
	@ResponseBody
	public void evalProposalModFileDownload(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("evalProposalModFileDownload");
		evalService.evalProposalModFileDownload(map, request, response);
		
	}
	
	/**
	 * 2022. 03. 04.
	 * 김혜린
	 * :평가위원 평가위원장 업체별 제안서 평가집계표 및 제안서 평가 총괄표 파일 다운로드
	 * @throws Exception 
	 */
	@RequestMapping(value = "/eval/evalProposalModFileDownload2") 
	@ResponseBody
	public void evalProposalModFileDownload2(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("evalProposalModFileDownload2");
		evalService.evalProposalModFileDownload2(map, request, response);
		
	}
	
	/**
	 * 2021. 8. 31.
	 * phj
	 * :평가위원 엑셀 업로드
	 * @throws Exception 
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeListUploadExcel", method = RequestMethod.POST)
	@ResponseBody
	public void evaluationCommitteeListUploadExcel(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception {
		logger.debug("evaluationCommitteeListUploadExcel");
		evalService.evaluationCommitteeListUploadExcel(map, multi, model);
	}
	/**
	 * 2021. 8. 31.
	 * phj
	 * :평가위원 엑셀 샘플 다운로드
	 * @throws Exception 
	 */
	@RequestMapping(value = "/eval/evaluationCommitteeListExcelSampleDownload" , method = RequestMethod.GET)
	@ResponseBody
	public void evaluationCommitteeListExcelSampleDownload(HttpServletRequest request, HttpServletResponse response)throws Exception {
		logger.debug("evaluationCommitteeListExcelSampleDownload");
		evalService.evaluationCommitteeListExcelSampleDownload(request, response);
	}

	@RequestMapping(value = "/eval/getEvalCommUserList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getEvalCommUserList(@RequestParam Map<String, Object> map) {
		logger.debug("getEvalCommUserList");
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("list", evalService.getEvalCommUserList(map));

		return result;

	}
	
}
