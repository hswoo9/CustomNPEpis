package com.duzon.custom.eval.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.common.utiles.CtPostUrl;
import com.duzon.custom.eval.dao.EvalDAO;
import com.duzon.custom.eval.service.EvalService;
import com.duzon.custom.eval.vo.CareerVO;
import com.duzon.custom.eval.vo.CommitteeVO;
import com.duzon.custom.eval.vo.DegreeVO;
import com.duzon.custom.eval.vo.EvalVO;
import com.duzon.custom.eval.vo.LicenseVO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Service
public class EvalServiceImpl implements EvalService {
	
	
	@Autowired
	private EvalDAO evalDAO;
	
	@Autowired
	private CommFileDAO commFileDAO;
	

	@Override
	public void evaluationCommitteeViweSave(EvalVO evalVo) {
			
		//평가위원마스터 등록
		evalDAO.setCommissionerPoolInsert(evalVo);
		
		//평가위원상세 등록
		evalDAO.setCommissionerDetailInsert(evalVo);
		
		String[] bizCode = evalVo.getBiz_type_code_id().split(",");
		
		//전문분야 등록
		for (String code : bizCode) {
			evalVo.setBiz_type_code_id(code);
			evalDAO.setBizTypeCodeInsert(evalVo);
			
		}
		
		//평가위원학력 등록
		for (DegreeVO dv : evalVo.getDegreeList()) {
			dv.setCommissioner_pool_seq(evalVo.getCommissioner_pool_seq());
			
			evalDAO.setEvalDegreeInsert(dv);
		}
		
		//평가위원경력사항 등록
		for (CareerVO cv : evalVo.getCareerList()) {
			cv.setCommissioner_pool_seq(evalVo.getCommissioner_pool_seq());
			evalDAO.setEvalCareerInsert(cv);
		}
		
		//평가위원자격증 등록
		for (LicenseVO lv : evalVo.getLicenseList()) {
			lv.setCommissioner_pool_seq(evalVo.getCommissioner_pool_seq());
			evalDAO.setEvalLicenseInsert(lv);
		}
		
	}


	@Override
	public Map<String, Object> evaluationCommitteeListSearch(Map<String, Object> map) throws Exception{
		
		map.put("list", evalDAO.getEvaluationCommitteeListSearch(map));
		map.put("totalCount", evalDAO.getEvaluationCommitteeListSearchTotal(map));
		
		return map;
	}


	@Override
	public void getCommittee(Map<String, Object> map, Model model) {
		
		Map<String, Object> pool = evalDAO.getCommitteePool(map);
		Map<String, Object> detail = evalDAO.getCommitteeDetail(map);
		List<Map<String, Object>> degree = evalDAO.getEvalDegree(map);
		List<Map<String, Object>> career = evalDAO.getEvalCareer(map);
		List<Map<String, Object>> license = evalDAO.getEvalLicense(map);
		List<Map<String, Object>> bizTypeList = evalDAO.getCommitteeBizTypeList(map);
		
		model.addAttribute("pool", pool);
		model.addAttribute("detail", detail);
		model.addAttribute("degree", degree);
		model.addAttribute("career", career);
		model.addAttribute("license", license);
		model.addAttribute("bizTypeList", bizTypeList);
		
	}


	@Override
	public void evaluationCommitteeViweUpdate(EvalVO evalVo) {

		//평가위원마스터 수정
		evalDAO.setCommissionerPoolUpdate(evalVo);
		
		//평가위원상세 수정
		evalDAO.setCommissionerDetailUpdate(evalVo);
		
		//전문분야 수정
		evalDAO.setCommissionerBizTypeDel(evalVo);
		String[] bizCode = evalVo.getBiz_type_code_id().split(",");
		
		//전문분야 등록
		for (String code : bizCode) {
			evalVo.setBiz_type_code_id(code);
			evalDAO.setBizTypeCodeInsert(evalVo);
		}
		
		//평가위원학력 수정
		for (DegreeVO dv : evalVo.getDegreeList()) {
			dv.setCommissioner_pool_seq(evalVo.getCommissioner_pool_seq());
			
//			if(StringUtils.isEmpty(dv.getDegree_seq())){
				evalDAO.setEvalDegreeInsert(dv);
//			}else{
//				evalDAO.setEvalDegreeUpdate(dv);
//			}
		}
		
		//평가위원경력사항 수정
		for (CareerVO cv : evalVo.getCareerList()) {
			cv.setCommissioner_pool_seq(evalVo.getCommissioner_pool_seq());
	
//			if(StringUtils.isEmpty(cv.getCareer_seq())){
				evalDAO.setEvalCareerInsert(cv);
//			}else{
//				evalDAO.setEvalCareerUpdate(cv);
//			}
		}
		
		//평가위원자격증 수정
		for (LicenseVO lv : evalVo.getLicenseList()) {
			lv.setCommissioner_pool_seq(evalVo.getCommissioner_pool_seq());
			
//			if(StringUtils.isEmpty(lv.getLicense_seq())){
				evalDAO.setEvalLicenseInsert(lv);
//			}else{
//				evalDAO.setEvalLicenseUpdate(lv);
//			}

		}
		
	}


	@Override
	public void evaluationCommitteeDel(Map<String, Object> map) {
		evalDAO.evaluationCommitteeDel(map);
	}


	@Override
	public Map<String, Object> evalBizTypeListSearch(Map<String, Object> map) {
	
		map.put("list", evalDAO.evalBizTypeListSearch(map));
		map.put("totalCount", evalDAO.evalBizTypeListSearchTotal(map));
		
		return map;
	}

	@Override
	public void evalBizTypeSave(Map<String, Object> map) {
		
		if(StringUtils.isEmpty( (String) map.get("eval_type_seq")) ){
			evalDAO.setEvalBizTypeSave(map);
		}else{
			evalDAO.setEvalBizTypeUpdate(map);
		}
	}


	@Override
	public void evalBizTypeDel(Map<String, Object> map) {
		evalDAO.setEvalBizTypeDel(map);
	}


	@Override
	public List<Map<String, Object>> evalTypeSearch(Map<String, Object> map) {
		return evalDAO.evalTypeSearch(map);
	}


	@Override
	public Map<String, Object> evalBizTypeItemListSearch(Map<String, Object> map) {

		map.put("list", evalDAO.evalBizTypeItemListSearch(map));
		map.put("totalCount", evalDAO.evalBizTypeItemListSearchTotal(map));
		
		return map;
	}


	@Override
	public void evalBizTypeItemDel(Map<String, Object> map) {
		evalDAO.evalBizTypeItemDel(map);		
	}


	@Override
	public void evalBizTypeItemSave(Map<String, Object> map) {
		
		if(StringUtils.isEmpty((String) map.get("eval_item_seq"))){
			//등록
			evalDAO.evalBizTypeItemSave(map);		
			
		}else{
			//수정
			evalDAO.evalBizTypeItemUpdate(map);		
			
		}
	}


	@Override
	public void evalBizTypeItemUpdate(Map<String, Object> map) {
		evalDAO.evalBizTypeItemUpdate(map);		
	}


	@Override
	public Map<String, Object> evaluationProposalViewSave(CommitteeVO committeeVO, Map<String,Object> map) {
		
		//userList select
		Map<String,Object> coSeq = new HashMap<>();
		coSeq.put("code", map.get("committee_seq"));
		map.put("tabNum", 1);
		List<Map<String, Object>> userList = getEvalCommUserList(coSeq);
		if(userList != null || !userList.isEmpty()){
			committeeVO.setCommissioner_cnt(Integer.toString(userList.size()));
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> joinList = gson.fromJson((String) committeeVO.getJoinOrgList() ,new TypeToken<List<Map<String, Object>>>(){}.getType() );
		
		//dj_purc_req 테이블 req_state 상태값 업데이트
		String regState = committeeVO.getReq_state();
		if(regState.equals("141")){
			//제안평가 141 -> 142
			committeeVO.setReq_state("142");
		}else if(regState.equals("151")){
			//적격평가 151 -> 152
			committeeVO.setReq_state("152");
		}

		//구매로온 평가등록일 경우 상태값 업데이트
		if(committeeVO.getBidding_type().equals("Y") && StringUtils.isNotEmpty(regState)){
			evalDAO.regStateUpdate(committeeVO);
		}

		//step I 임시저장이면 문서번호 없이
		if(committeeVO.getStep().equals("I")){
			committeeVO.setEval_doc_num("-");
		}else{
			committeeVO.setEval_doc_num(evalDAO.getEvalDocNum());
		}
		
		if(StringUtils.isEmpty(committeeVO.getCommittee_seq())){
			//평가위원회 등록
			evalDAO.evaluationProposalViewSave(committeeVO);
			
		}else{
			//평가위원회 수정
			evalDAO.evaluationProposalViewUpdate(committeeVO);
		}
		
		//평가업체 등록 
		evalDAO.evalCompanyDelete(committeeVO);
		for (Map<String, Object> join : joinList) {
			
			join.put("committee_seq", committeeVO.getCommittee_seq());
			evalDAO.evalCompanyInsert(join);
			
		}
		
		
		//평가항목 등록
		evalDAO.setEvalItemDel(committeeVO);
		
		List<Map<String, Object>> evalItem = gson.fromJson((String) committeeVO.getEvalItemList() ,new TypeToken<List<Map<String, Object>>>(){}.getType() );
		
		for (Map<String, Object> item : evalItem) {
			item.put("committee_seq", committeeVO.getCommittee_seq());
			evalDAO.setEvalItemSave(item);
		}
		
		result.put("committee_seq", committeeVO.getCommittee_seq());
		
		
		if(userList != null || !userList.isEmpty()) {
			
			evalDAO.setEmptyEvalItemResult(map);
			evalDAO.setEmptyEvalCompanyRemark(map);
			
			for(int i = 0; i < userList.size(); i++) {
				Map<String,Object> newParam = new HashMap<>();
				newParam.put("committee_seq", map.get("committee_seq"));
				newParam.put("commissioner_seq", userList.get(i).get("commissioner_seq"));
				newParam.put("tabNum", 1);
				//평가결과
				//평가결과 미리등록 평가항목 * 평가업체 * 평가위원
				evalDAO.setEvalItemResult(newParam);
				
				//업체평가의견 미리등록
				evalDAO.setEvalCompanyRemark(newParam);
				
			}
		}
		
		return result;
		
	}

	@Override
	public Map<String, Object> evaluationProposalConfigurationViewSave(CommitteeVO committeeVO, Map<String,Object> map) {


		committeeVO.setCommittee_Guest(map.get("committee_guest").toString());
		committeeVO.setIn_mb_cnt(map.get("in_mb_cnt").toString());

		//userList select
		Map<String,Object> coSeq = new HashMap<>();
		coSeq.put("code", map.get("committee_seq"));
		map.put("tabNum", 1);
		List<Map<String, Object>> userList = getEvalCommUserList(coSeq);
		if(userList != null || !userList.isEmpty()){
			committeeVO.setCommissioner_cnt(Integer.toString(userList.size()));
		}

		Map<String, Object> result = new HashMap<String, Object>();

		Gson gson = new Gson();
		List<Map<String, Object>> joinList = gson.fromJson((String) committeeVO.getJoinOrgList() ,new TypeToken<List<Map<String, Object>>>(){}.getType() );

		//dj_purc_req 테이블 req_state 상태값 업데이트
		String regState = committeeVO.getReq_state();
		if(regState.equals("141")){
			//제안평가 141 -> 142
			committeeVO.setReq_state("142");
		}else if(regState.equals("151")){
			//적격평가 151 -> 152
			committeeVO.setReq_state("152");
		}

		//구매로온 평가등록일 경우 상태값 업데이트
		if(committeeVO.getBidding_type().equals("Y") && StringUtils.isNotEmpty(regState)){
			evalDAO.regStateUpdate(committeeVO);
		}

		//step I 임시저장이면 문서번호 없이
		if(committeeVO.getStep().equals("I")){
			committeeVO.setEval_doc_num("-");
		}else{
			committeeVO.setEval_doc_num(evalDAO.getEvalDocNum());
		}

		if(StringUtils.isEmpty(committeeVO.getCommittee_seq())){
			//평가위원회 등록
			evalDAO.evaluationProposalViewSave(committeeVO);

		}else{
			//평가위원회 수정
			evalDAO.evaluationProposalViewUpdate(committeeVO);
		}

		//평가업체 등록
		evalDAO.evalCompanyDelete(committeeVO);
		for (Map<String, Object> join : joinList) {

			join.put("committee_seq", committeeVO.getCommittee_seq());
			evalDAO.evalCompanyInsert(join);

		}

		result.put("committe_seq", committeeVO.getCommittee_seq());

		return result;

	}

	@Override
	public Map<String, Object> evaluationProposalListSearch(Map<String, Object> map) {
		
		map.put("list", evalDAO.evaluationProposalListSearch(map));
		map.put("totalCount", evalDAO.evaluationProposalListSearchTotal(map));
		
		return map;
	}


	@Override
	public Map<String, Object> evaluationProposalConfigurationListSearch(Map<String, Object> map) {

		map.put("list", evalDAO.evaluationProposalConfigurationListSearch(map));
		map.put("totalCount", evalDAO.evaluationProposalConfigurationListSearchTotal(map));

		return map;
	}
	

	@Override
	public void evaluationProposalListDel(Map<String, Object> map) {
		map.put("committee_seq", map.get("code"));
		evalDAO.evaluationProposalListDel(map);
		evalDAO.setEmptyEvalCommissioner(map);
		evalDAO.setDjPurcReqDel(map);
		
	}


	@Override
	public Map<String, Object> getEvaluationProposal(Map<String, Object> map) {
		
		Map<String, Object> one = evalDAO.getEvaluationProposal(map);
		
		List<Map<String, Object>> orpList = new ArrayList<Map<String, Object>>();
		
		for (int i = 1; i <= 5; i++) {
			if(!StringUtils.isEmpty((String) one.get("opr_emp_name_"+i))){
				Map<String, Object> vo = new HashMap<>();
				vo.put("opr_emp_name", one.get("opr_emp_name_"+i));
				vo.put("opr_dept", one.get("opr_dept_"+i));
				orpList.add(vo);
			}
		}
		
		one.put("orpList", orpList);
		
		return one;
	}


	@Override
	public Map<String, Object> getEvaluationProposal2(Map<String, Object> map) {

		Map<String, Object> one = evalDAO.getEvaluationProposal(map);

		return one;
	}


	@Override
	public Map<String, Object> evaluationIdListSearch(Map<String, Object> map) {
		
		//pw가 필요하면 변환하자 cast(AES_DECRYPT(UNHEX(eval_user_pw), 'EVAL')as char)
		
		map.put("list", evalDAO.getEvaluationIdListSearch(map));
		map.put("totalCount", evalDAO.getEvaluationIdListSearchTotal(map));
		
		return map;
	}


	@Override
	public Map<String, Object> evaluationIdViewSave(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		if(StringUtils.isEmpty((String) map.get("eval_id_seq"))){
			result = evalDAO.getEvalUserIdChk(map);
			
			if(result == null){
				//등록
				evalDAO.evaluationIdViewSave(map);		
				map.put("CODE", "SUCCESS");
			}else{
				map.put("CODE", "FAIL");
			}
		}else{
			//수정
			evalDAO.evaluationIdViewUpdate(map);	
			map.put("CODE", "SUCCESS");
		}
		
		return map;
	}


	@Override
	public void evaluationIdViewDel(Map<String, Object> map) {
		evalDAO.evaluationIdViewDel(map);
	}


	@Override
	public List<Map<String, Object>> getEvalItemList(Map<String, Object> map) {
		return evalDAO.getEvalItemList(map);
	}


	@Override
	public Map<String, Object> getEvalCommList(Map<String, Object> map) {
		//평가위원을 가져와 보자
		
		Map<String, Object> result = new HashMap<String, Object>();
		List<Map<String, Object>> getList = new ArrayList<Map<String,Object>>();
		
		Gson gson = new Gson(); 
		List<Map<String, String>> codeList = gson.fromJson((String) map.get("code"),new TypeToken<List<Map<String, String>>>(){}.getType() );
		
		for (Map<String, String> codeMap : codeList) {
			
			codeMap.put("eval_s_date", (String) map.get("eval_s_date"));
			codeMap.put("eval_e_date", (String) map.get("eval_e_date"));
			codeMap.put("committee_seq", (String) map.get("committee_seq"));
			codeMap.put("cdList", (String) map.get("cdList"));
			codeMap.put("userCnt", (String) map.get("userCnt"));
			
			getList.addAll( evalDAO.getEvalCommList(codeMap) );
			
		}
		
		//리스트 랜덤정렬 주석
//		Collections.shuffle(getList);
		
		result.put("getList", getList);
		result.put("data", codeList);
		
		return result;
	}
	
	@Override
	public Map<String, Object> getEvalCommListPop(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", evalDAO.getEvalCommListPop(map));
		result.put("totalCount", evalDAO.getEvalCommListPopTotal(map));
		
		return result;
	}

	
	@Override
	public void setEvalCommSave(Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> codeList = gson.fromJson((String) map.get("code"),new TypeToken<List<Map<String, Object>>>(){}.getType() );
		String finalParamCommissioner = "";
		
		//무조건 초기화 시킨후 다시 가져오자
		//평가위원
		evalDAO.setEmptyEvalCommissioner(map);
		//평가결과
		evalDAO.setEmptyEvalItemResult(map);
		//평가의견
		evalDAO.setEmptyEvalCompanyRemark(map);
		
		int orderNo = 1;
		for (Map<String, Object> comm : codeList) {
			
			comm.put("committee_seq", map.get("committee_seq"));
			comm.put("create_date", map.get("create_date"));
			comm.put("create_emp_seq", map.get("create_emp_seq"));
			comm.put("create_dept_seq", map.get("create_dept_seq"));
			comm.put("order_no", orderNo);
			comm.put("tabNum", map.get("tabNum"));
			
			//평가위원 등록
			evalDAO.setEvalCommSave(comm);
			
			//평가결과 미리등록 평가항목 * 평가업체 * 평가위원
			evalDAO.setEvalItemResult(comm);

			//업체평가의견 미리등록
			evalDAO.setEvalCompanyRemark(comm);
			
			finalParamCommissioner += String.valueOf(comm.get("commissioner_seq")) + ",";
			
			orderNo++;
			
		}
		
		//tab1일 때만 등록, 수정
		if(map.get("tabNum").equals("1")){
			
			//전문분야를 알기위해 등록
			evalDAO.setEvalCommitteeTypeDel(map);
			
			evalDAO.setEvalCommissionerCnt(map);
		}
		
		Map<String, Object> finalParam = new HashMap<String, Object>();
		finalParam.put("committee_seq", map.get("committee_seq"));
		finalParam.put("commissioner_seq", finalParamCommissioner.substring(0, finalParamCommissioner.length() - 1));
		
		// 기존 확정 로직
		evalDAO.evalCommFixUpdate(finalParam);
		
		evalDAO.evalCommFix(finalParam);
	}
	
	@Override
	public void setEvalCommSave2(Map<String, Object> map) { // 이후 추가 확정
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> codeList = gson.fromJson((String) map.get("code"),new TypeToken<List<Map<String, Object>>>(){}.getType() );
		String finalParamCommissioner = "";
		
		int orderNo = Integer.parseInt(String.valueOf(map.get("orderNo")) + 1);
		for (Map<String, Object> comm : codeList) {
			
			comm.put("committee_seq", map.get("committee_seq"));
			comm.put("create_date", map.get("create_date"));
			comm.put("create_emp_seq", map.get("create_emp_seq"));
			comm.put("create_dept_seq", map.get("create_dept_seq"));
			comm.put("order_no", orderNo);
			comm.put("tabNum", map.get("tabNum"));
			
			//평가위원 등록
			evalDAO.setEvalCommSave(comm);
			
			//평가결과 미리등록 평가항목 * 평가업체 * 평가위원
			evalDAO.setEvalItemResult(comm);

			//업체평가의견 미리등록
			evalDAO.setEvalCompanyRemark(comm);
			
			finalParamCommissioner += String.valueOf(comm.get("commissioner_seq")) + ",";
			
			orderNo++;
			
		}
		
		//tab1일 때만 등록, 수정
		if(map.get("tabNum").equals("1")){
			
			evalDAO.setEvalCommissionerCnt(map);
		}
		
		Map<String, Object> finalParam = new HashMap<String, Object>();
		finalParam.put("committee_seq", map.get("committee_seq"));
		finalParam.put("commissioner_seq", finalParamCommissioner.substring(0, finalParamCommissioner.length() - 1));
		
		// 기존 확정 로직
		evalDAO.evalCommFix(finalParam);
	}


	@Override
	public List<Map<String, Object>> getEvalCommUserList(Map<String, Object> map) {
		return evalDAO.getEvalCommUserList(map);
	}


	@Override
	public List<Map<String, Object>> getEvalCommTypeList(Map<String, Object> map) {
		return evalDAO.getEvalCommTypeList(map);
	}


	@Override
	public List<Map<String, Object>> getEvalIdList(Map<String, Object> map) {
		return evalDAO.getEvalIdList(map);
	}


	@Override
	public void setevalIdSave(Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> list = gson.fromJson((String) map.get("list"),new TypeToken<List<Map<String, Object>>>(){}.getType() );
		
		evalDAO.setevalIdDel(map);
		for (Map<String, Object> vo : list) {
			evalDAO.setevalIdSave(vo);
		}
	}


	@Override
	public List<Map<String, Object>> getcommItem(Map<String, Object> map) {
		return evalDAO.getcommItem(map);
	}


	@Override
	public Map<String, Object> getEvalUserIdChk(Map<String, Object> map) {
		return evalDAO.getEvalUserIdChk(map);
	}


	@Override
	public Map<String, Object> joinOrgGridList(Map<String, Object> map) {
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		//erp 업체
		list = evalDAO.evalStradeListSearch(map);
			
		//신규등록 업체
		list.addAll(evalDAO.evalCompanyListSearch(map));
		
		map.put("list", list);
		map.put("totalCount", list.size());
		
		return map;
	}


	@Override
	public List<Map<String, Object>> getEvalCompany(Map<String, Object> map) {
		return evalDAO.getEvalCompany(map);
	}


	@Override
	public List<Map<String, Object>> getEvalitem(Map<String, Object> map) {
		return evalDAO.getEvalitem(map);
	}


	@Override
	public List<Map<String, Object>> getEvaCommList(Map<String, Object> map) {
		return evalDAO.getEvaCommList(map);
	}


	@Override
	public List<Map<String, Object>> getEvalCommItemList(Map<String, Object> map) {
		return evalDAO.getcommItem(map);
	}


	@Override
	public Map<String, Object> evalResultList(Map<String, Object> map) {

		List<Map<String, Object>> userList = evalDAO.getCommissionerList(map);
        int userCnt = 0;
        //실제 평가위원 수
        for (Map<String, Object> map2 : userList) {
            if(map2.get("contact").equals("N") && map2.get("eval_avoid").equals("N")){
                userCnt++;
            }
        }
		
		map.put("userCnt", userCnt);
		
		//평점구하기 위한 평가위원 수 
		//5명 이하일 경우 모두 
		//그외 최상 최하 빼기 위해 두명 제외
		if(userCnt > 4){
			map.put("userCntTotal", userCnt-2);
		}else{
			map.put("userCntTotal", userCnt);
		}
		
		//평가항목 조회
		List<Map<String, Object>> col = evalDAO.getItemColList(map);
		map.put("colList", col);
		
		//평가 조회
		List<Map<String, Object>> list = evalDAO.getEvalResultList(map);
		map.put("list", list);

		//평가 합계
		Map<String, Object> total = evalDAO.getEvalResultTotal(map);
		map.put("total", total);
		
		//총괄 점수
		List<Map<String, Object>> sumList = evalDAO.getEvalConfirmData(map);
		map.put("sumList", sumList);
		
		return map;
	}


	@Override
	public Map<String, Object> evalCompanyListSearch(Map<String, Object> map) {
		map.put("list", evalDAO.evalCompanyListSearch(map));
		map.put("totalCount", evalDAO.evalCompanyListSearchTotal(map));
		
		return map;
	}


	@Override
	public void evalCompanySave(Map<String, Object> map) {
		
		if(StringUtils.isEmpty((String) map.get("company_seq"))){
			evalDAO.evalCompanySave(map);
		}else{
			evalDAO.evalCompanyUpdate(map);
		}
		
	}


	@Override
	public void evalCompanyDel(Map<String, Object> map) {
		evalDAO.evalCompanyDel(map);
	}


	@Override
	public void evalCommFix(Map<String, Object> map) {
		evalDAO.evalCommFixUpdate(map);
		evalDAO.evalCommFix(map);
	}


	@Override
	public void evalTransPaySave(Map<String, Object> map, MultipartHttpServletRequest multi) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> list = gson.fromJson((String) map.get("list"),new TypeToken<List<Map<String, Object>>>(){}.getType() );
		
		Map<String, Object> fileuploadMap = new HashMap<String, Object>();
		fileuploadMap.put("path", "eval");
		fileuploadMap.put("targetTableName", "dj_eval_commissioner");
		
		
		//평가수당 업로드
		for (Map<String, Object> vo : list) {
			evalDAO.evalTransPaySave(vo);
			
			String inputFileNm = "transFile_" + vo.get("commissioner_seq");
			fileuploadMap.put("targetId", vo.get("commissioner_seq"));
			
			//평가수당 첨부파일 업로드
			try {
				evalFileUpload(fileuploadMap, multi, inputFileNm);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
	}


	@Override
	public List<Map<String, Object>> purcListSearch(Map<String, Object> map) {
		return evalDAO.purcListSearch(map);
	}


	@Override
	public List<Map<String, Object>> getPurcBiddingList(Map<String, Object> map) {
		return evalDAO.getPurcBiddingList(map);
	}

	@Override
	public void evalCommCancel(Map<String, Object> map) {
		evalDAO.evalCommCancel(map);
	}
	
	
	
	
	
	
	//평가수당 첨부파일 업로드
	private void evalFileUpload(Map<String, Object> map, MultipartHttpServletRequest multi, String inputFileNm) throws Exception{
		
		// 파일 저장 경로
		String path = String.valueOf(map.get("path"));
       	String subPathYn = "Y";
       	String filePath = CommFileUtil.getFilePath(commFileDAO, path, subPathYn);

//	       	String filePath = "C:\\upload\\";

       	// 파일 저장 경로
       	List<MultipartFile> a = multi.getFiles(inputFileNm);
       	for (MultipartFile mFile : a) {
       		String fileName = mFile.getOriginalFilename();
			String fileSize = String.valueOf(mFile.getSize());
			if(fileName.equals("")) { 
//						System.out.println(uploadFile+" is Empty");
			}else{
				
				//기존 파일 지워버리기~
				
				commFileDAO.setCommFileDelete(map);
				
				map.put("fileSeq", commFileDAO.getCommFileSeq(map));
				commFileDAO.commFileInfoInsert(map);
				
	           	String fileNm = map.get("attach_file_id") +"."+ fileName.substring(fileName.lastIndexOf(".")+1);
	           	int Idx = fileName.lastIndexOf(".");
	           	String _fileName = fileName.substring(0, Idx);
	           	String ext = fileName.substring(fileName.lastIndexOf(".")+1);
//			           	System.out.println(filePath+_fileName+ext);
	           	
	           	// 파일저장
	           	CommFileUtil.makeDir(filePath);	           	
	           	File saveFile = new File(filePath + fileNm);
	           	CommFileUtil.fileWrite(mFile, saveFile);
	           	// 파일저장
	           	
	           	Map<String,Object> returnMap =new HashMap<String, Object>();
	           	
	           	returnMap.put("filePath", filePath);
	           	returnMap.put("fileNm", _fileName);
	           	returnMap.put("ext", ext);
	           	returnMap.put("fileSize", fileSize);
	           	returnMap.put("attach_file_id", map.get("attach_file_id"));
	           	returnMap.put("fileSeq", map.get("fileSeq"));
	           	returnMap.put("path", map.get("path"));
	           	returnMap.put("targetId", map.get("targetId"));
	           	returnMap.put("targetTableName", map.get("targetTableName"));
	           	
	            commFileDAO.commFileInfoUpdate(returnMap);
	            
           }
		}
		
	}


	@Override
	public Map<String, Object> evalAnListSearch(Map<String, Object> map) {
		
		map.put("list", evalDAO.evalAnListSearch(map));
		map.put("totalCount", evalDAO.evalAnListSearchTotal(map));
		
		return map;
	}


	@Override
	public String getEvalContents(Map<String, Object> map) {

		Map<String, Object> item = evalDAO.getEvaluationProposal(map);
		
		String br = "\n";
		String no = (String) item.get("eval_doc_num");
		String notxt = no.split("-")[1] + "-" + map.get("tabNum");
		String day = item.get("eval_s_date3") + "(" + item.get("EVAL_S_DATE_WK") + ")" + "~" + item.get("eval_e_date3") + "(" + item.get("EVAL_S_DATE_WK") + "),   " + item.get("eval_s_time") + "~" + item.get("eval_e_time");
		
		String contents = item.get("title") + br;
		contents += "" + br;
		contents += "[평가위원 섭외 안내]" + br;
		contents += "안녕하세요!" + br;
		contents += "농림수산식품교육문화정보원 제안서 평가위원 섭외 안내입니다." + br;
		contents += "참여가 가능하신 분만 숫자 '" + notxt + "'를 입력해 문자로 보내주세요." + br;
		contents += "" + br;
		contents += "[평가안내]" + br;
		contents += "- 평가일시 : " + day + br;
		contents += "- 평가장소 : " + item.get("eval_place") + br;
		contents += "- 사 업 명 : " + item.get("title") + br;
		contents += "" + br;
		contents += "[참여방법]" + br;
		contents += "- 신청방법 : 숫자 '" + notxt + "' 입력 --> 문자보내기" + br;
		contents += "- 신청기간 : " + br;
		contents += "- 선정통보 : \"위원으로 선정되셨으며, 평가 당일날 됩겠습니다\" 문자 자동발송" + br;
		contents += "(공정한 섭외를 위해 자동으로 선착순 마감되며, '" + notxt + "' 외의 다른 숫자 또는" + br;
		contents += "단어를 입력하시면 불참처리 됩니다. 본 수신번호는 문자 전용으로 통화는" + br;
		contents += "불가능합니다. 또한, 설정시간 종료 이전 조기에 평가위원 섭외 마감시 문자" + br;
		contents += "답변이 통보되지 않을 수 있습니다.)" + br;
		
		return contents;
	}


	@Override
	public Map<String, Object> evalAnTempSave(Map<String, Object> map) {

		//평가위원 erp 연동 조회
		List<Map<String, Object>> list = evalDAO.getCommissionerAnUserListTemp(map);

		List<Map<String, Object>> userList = new ArrayList<Map<String, Object>>();
		
		for (Map<String, Object> vo : list) {
			
			//erp에서 주민등록번호로 매칭을 조회한다
			Map<String, Object> user = evalDAO.getErpUserInfo(vo);
			
			//erp에 등록 안된 사람이 있을경우
			if(user == null){
				userList.add(vo);
			}
			
		}
		
		//erp에 등록 안된 사람이 한명이라도 있으면 에러로 처리 
		if(userList.size() == 0){
			
			//첨부파일 업로드가 필요
			//commissioner_seq 폴더경로
			//sign_1_file_seq 평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서.pdf
			//sign_2_file_seq 평가위원 사전의결사항.pdf
			//sign_3_file_seq 사전접촉여부 확인(신고)서1.pdf
			//sign_4_file_seq 평가수당 지급 확인서.pdf
			//sign_5_file_seq 평가위원 개인정보 수집·이용 동의서.pdf
			//sign_6_file_seq 위원별 제안서 평가표.pdf
			//sign_7_file_seq 업체별 제안서 평가집계표.pdf
			//sign_8_file_seq 제안서 평가 총괄표.pdf
			//sign_9_file_seq 사전접촉여부 확인(신고)서2.pdf
			//sign_10_file_seq 평가위원장 가산금 지급 확인서.pdf
			
			List<Map<String, Object>> userFileList = evalDAO.getEvalCommissionerList(map);
			CtPostUrl fileUpload = new CtPostUrl();
			
			fileUpload.urlTxt("deleteYN", "Y");
			fileUpload.urlTxt("compSeq", (String) map.get("compSeq"));
			fileUpload.urlTxt("empSeq", (String) map.get("empSeq"));
			
			for (Map<String, Object> file : userFileList) {
				//파일 경로
				String path = "/home/upload/cust_eval/" + file.get("commissioner_seq") + "/";
				String name = (String) file.get("EVAL_DOC_NUM") + "_" + (String) file.get("NAME");
				
				String sign_1 = (String) file.get("sign_1");
				String sign_2 = (String) file.get("sign_2");
				String sign_3 = (String) file.get("sign_3");
				String sign_4 = (String) file.get("sign_4");
				String sign_5 = (String) file.get("sign_5");
				String sign_6 = (String) file.get("sign_6");
				String sign_7 = (String) file.get("sign_7");
				String sign_8 = (String) file.get("sign_8");
				String sign_9 = (String) file.get("sign_9");
				String sign_10 = (String) file.get("sign_10");
				
				if(sign_1.equals("Y")){
					File file1 = new File(path + (String) file.get("sign_1_file_seq"));
					fileUpload.urlFile(name + "_평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서.pdf", file1);
				}
				if(sign_2.equals("Y")){
					File file2 = new File(path + (String) file.get("sign_2_file_seq"));
					fileUpload.urlFile(name + "_평가위원 사전의결사항.pdf", file2);
				}
				if(sign_3.equals("Y")){
					File file3 = new File(path + (String) file.get("sign_3_file_seq"));
					fileUpload.urlFile(name + "_사전접촉여부 확인(신고)서1.pdf", file3);
				}
				if(sign_4.equals("Y")){
					File file4 = new File(path + (String) file.get("sign_4_file_seq"));
					fileUpload.urlFile(name + "_평가수당 지급 확인서.pdf", file4);
				}
				if(sign_5.equals("Y")){
					File file5 = new File(path + (String) file.get("sign_5_file_seq"));
					fileUpload.urlFile(name + "_평가위원 개인정보 수집·이용 동의서.pdf", file5);
				}
				if(sign_6.equals("Y")){
					File file6 = new File(path + (String) file.get("sign_6_file_seq"));
					fileUpload.urlFile(name + "_위원별 제안서 평가표.pdf", file6);
				}
				if(sign_7.equals("Y")){
					File file7 = new File(path + (String) file.get("sign_7_file_seq"));
					fileUpload.urlFile(name + "_업체별 제안서 평가집계표.pdf", file7);
				}
				if(sign_8.equals("Y")){
					File file8 = new File(path + (String) file.get("sign_8_file_seq"));
					fileUpload.urlFile(name + "_제안서 평가 총괄표.pdf", file8);
				}
				if(sign_9.equals("Y")){
					File file9 = new File(path + (String) file.get("sign_9_file_seq"));
					fileUpload.urlFile(name + "_사전접촉여부 확인(신고)서2.pdf", file9);
				}
				if(sign_10.equals("Y")){
					File file10 = new File(path + (String) file.get("sign_10_file_seq"));
					fileUpload.urlFile(name + "_평가위원장 가산금 지급 확인서.pdf", file10);
				}
					
			}
			
			//파일 키 생성 소스가.. 못났네
			String fileKey = fileUpload.finish();
			
			map.put("fileKey", fileKey);
			
			//평가 결의 정보 등록
			evalDAO.setEvalAnInsert(map);
			
			//평가위원 코드 업데이트
			evalDAO.setEvalAnUpdate(map);
			
			map.put("code", "success");
			
		}else{
			map.put("code", "fail");
		}
		
		map.put("errorList", userList);
		
		
		return map;
	}


	@Override
	public List<Map<String, Object>> getCommissionerAnUserList(Map<String, Object> map) {
		
		List<Map<String, Object>> list = evalDAO.getCommissionerAnUserList(map);
		
		//erp에서 주민등록번호로 매칭을 조회한다
		for (Map<String, Object> vo : list) {
			Map<String, Object> user = evalDAO.getErpUserInfo(vo);
			vo.putAll(user);
		}
		
		return list; 
	}


	@Override
	public Map<String, Object> getEvalAnData(Map<String, Object> map) {
		return evalDAO.getEvalAnData(map);
	}


	@Override
	public void evalAnOutProcess(Map<String, Object> map) {
		/*외부 연동 파라미터 예시
		outProcessInterfaceId=eval_an
		outProcessInterfaceMId=31
		outProcessInterfaceDId=
		consDocSeq=
		resDocSeq=6616
		docSts=20
		docSeq=407
		docNo=
		groupSeq=epis
		compSeq=1000
		bizSeq=1000
		deptSeq=1010
		empSeq=1*/
		
		evalDAO.evalAnOutProcess(map);
	}


	@Override
	public void finalApprovalActiveSave(Map<String, Object> map) {
		map.put("committee_seq", map.get("code"));
		evalDAO.finalApprovalActiveSave(map);
	}
	
	/*
	 * 2021.08.27
	 * 평가수당 파일 다운로드
	 * phj
	 */
	@Override
	public void evalProposalModFileDownload(Map<String, Object> map, HttpServletRequest request,HttpServletResponse response) {

		Map<String, Object> fileList = evalDAO.evalProposalModFileDownload(map);
		Map<String, Object> fileName = new HashMap<>();
		
		List<String> fileNameList = new ArrayList<String>();
		
		String serverFilePath = "/home/upload/cust_eval/" + fileList.get("commissioner_seq") + "/";
		String fileZipName = fileList.get("commissioner_seq") + ".zip"; //저장할 압축파일명
		
		String sign_1 = (String) fileList.get("sign_1");
		String sign_2 = (String) fileList.get("sign_2");
		String sign_3 = (String) fileList.get("sign_3");
		String sign_4 = (String) fileList.get("sign_4");
		String sign_5 = (String) fileList.get("sign_5");
		String sign_6 = (String) fileList.get("sign_6");
		String sign_7 = (String) fileList.get("sign_7");
		String sign_8 = (String) fileList.get("sign_8");
		String sign_9 = (String) fileList.get("sign_9");
		String sign_10 = (String) fileList.get("sign_10");
		
		for(int i = 1; i < 10; i++) {
			fileName.put("sign_"+i+"_file_seq", fileList.get("sign_"+i+"_file_seq"));		
			fileNameList.add((String)fileList.get("sign_"+i+"_file_seq"));		
		}
		
		// ZipOutputStream을 FileOutputStream 으로 감쌈
		// 파일압축 시작
		FileOutputStream fout = null;
		ZipOutputStream zout = null;
		try{
			fout = new FileOutputStream(serverFilePath + fileZipName); //지정경로에 + 지정이름으로
			zout = new ZipOutputStream(fout);

		    if(sign_1.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_1_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_2.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_2_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원 사전의결사항.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_3.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_3_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_사전접촉여부 확인(신고)서1.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_4.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_4_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가수당 지급 확인서.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_5.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_5_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원 개인정보 수집·이용 동의서.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_6.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_6_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_위원별 제안서 평가표.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_7.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_7_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_업체별 제안서 평가집계표.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_8.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_8_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_제안서 평가 총괄표.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_9.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_9_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_사전접촉여부 확인(신고)서2.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_10.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_10_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원장 가산금 지급 확인서.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }

	    }catch(Exception ioe){ 
	    	ioe.printStackTrace();
		}finally {
			try {
				zout.close();
				fout.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		File downFile = new File(serverFilePath + fileZipName);
		FileInputStream in = null;
		String downFileName = fileList.get("TITLE") +"_"+ fileList.get("NAME") + ".zip";
		try {
			try {
				in = new FileInputStream(downFile);
			} catch ( Exception e ) {
				e.printStackTrace();
			}

			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(downFileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(downFile != null)
				response.setHeader( "Content-Length", downFile.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			CommFileUtil.outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}

	}
	
	/*
	 * 2022.03.04
	 * 평가수당 평가위원장 업체별 제안서 평가집계표 및 제안서 평가 총괄표 파일 다운로드
	 * 김혜린
	 */
	@Override
	public void evalProposalModFileDownload2(Map<String, Object> map, HttpServletRequest request,HttpServletResponse response) {

		Map<String, Object> fileList = evalDAO.evalProposalModFileDownload2(map);
		Map<String, Object> fileName = new HashMap<>();
		
		List<String> fileNameList = new ArrayList<String>();
		
		String serverFilePath = "/home/upload/cust_eval/" + fileList.get("commissioner_seq") + "/";
		String fileZipName = fileList.get("commissioner_seq") + ".zip"; //저장할 압축파일명
		
		String sign_7 = (String) fileList.get("sign_7");
		String sign_8 = (String) fileList.get("sign_8");
		
		for(int i = 1; i < 10; i++) {
			fileName.put("sign_"+i+"_file_seq", fileList.get("sign_"+i+"_file_seq"));		
			fileNameList.add((String)fileList.get("sign_"+i+"_file_seq"));		
		}
		
		// ZipOutputStream을 FileOutputStream 으로 감쌈
		// 파일압축 시작
		FileOutputStream fout = null;
		ZipOutputStream zout = null;
		try{
			fout = new FileOutputStream(serverFilePath + fileZipName); //지정경로에 + 지정이름으로
			zout = new ZipOutputStream(fout);

		    if(sign_7.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_7_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry("업체별 제안서 평가집계표.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }
		    if(sign_8.equals("Y")) {
		    	
		    	FileInputStream fin = new FileInputStream(new File(serverFilePath +fileList.get("sign_8_file_seq"))); // 압축대상 파일
		    	zout.putNextEntry(new ZipEntry("제안서 평가 총괄표.pdf")); // 압축파일에 저장될 파일명
		    	int length;
		        int size = fin.available();
		        byte[] buffer = new byte[size];
		        // input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
		        while((length = fin.read(buffer)) > 0){ 
		            zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
		        }

		        zout.closeEntry();
		        fin.close();
		    }

	    }catch(Exception ioe){ 
	    	ioe.printStackTrace();
		}finally {
			try {
				zout.close();
				fout.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		File downFile = new File(serverFilePath + fileZipName);
		FileInputStream in = null;
		String downFileName = fileList.get("TITLE") + "_평가보기.zip";
		try {
			try {
				in = new FileInputStream(downFile);
			} catch ( Exception e ) {
				e.printStackTrace();
			}

			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(downFileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(downFile != null)
				response.setHeader( "Content-Length", downFile.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			CommFileUtil.outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}

	}
	
	@Override
	public void evaluationCommitteeListUploadExcel(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception {
		
		MultipartFile fileNm = multi.getFile("excelfile");
		File dest = new File(fileNm.getOriginalFilename());
		fileNm.transferTo(dest);

		XSSFRow row; // 로우값
		XSSFCell col1;// 서고

		FileInputStream inputStream = new FileInputStream(dest);

		XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
		XSSFSheet sheet = workbook.getSheetAt(0); // 첫번째 시트
		int rows = sheet.getPhysicalNumberOfRows();

		String sheetNm = workbook.getSheetName(0);
		System.out.println(sheetNm);

		List<Map<String, Object>> dataList = new ArrayList<>();
		
		Map<String, Object> bizMap = null;
		Map<String, Object> commiMap = null;
		for (int i = 3; i < rows; i++) {
			List<Map<String, Object>> spList = new ArrayList<>();
			commiMap = new HashMap<String, Object>();
			Map<String, Object> bizListMap = new HashMap<String, Object>();
			row = sheet.getRow(i);
			if (row != null) {
				int cells = sheet.getRow(i).getPhysicalNumberOfCells();
				
				//String birth_num = cellValueToString(row.getCell(1));//주민번호 DJ_COMMISSIONER_POOL
				/*
				if(birth_num.contains("-")) {
					commiMap.put("birth_date", birth_num.replace("-", "")); 
				}else {
					commiMap.put("birth_date", birth_num);									
				}
				*/
				
				//commiMap.put("birth_date", i);	
				commiMap.put("job_type", cellValueToString(row.getCell(1)));//분야 DJ_COMMISSIONER_DETAIL
				String sp = cellValueToString(row.getCell(2)); //전문분야 DJ_COMMISSIONER_BIZ_TYPE				
				commiMap.put("eval_name", cellValueToString(row.getCell(3))); //이름 DJ_COMMISSIONER_POOL
				commiMap.put("gender", cellValueToString(row.getCell(4)));//성별 DJ_COMMISSIONER_POOL
				commiMap.put("org_name", cellValueToString(row.getCell(6))); //기관명 DJ_COMMISSIONER_DETAIL
				commiMap.put("org_dept", cellValueToString(row.getCell(7)));//부서 DJ_COMMISSIONER_DETAIL
				commiMap.put("org_grade", cellValueToString(row.getCell(8)));//직위(직급) DJ_COMMISSIONER_DETAIL
				commiMap.put("org_tel", cellValueToString(row.getCell(9)));//유선전화 DJ_COMMISSIONER_DETAIL
				commiMap.put("mobile", cellValueToString(row.getCell(10))); //핸드폰 DJ_COMMISSIONER_DETAIL
				commiMap.put("email", cellValueToString(row.getCell(11))); //이메일 DJ_COMMISSIONER_DETAIL
				//commiMap.put("addr1", cellValueToString(row.getCell(7))); //주소 DJ_COMMISSIONER_DETAIL
							
				//Map<String,Object> birth = evalDAO.selectBirthDateYN(commiMap); //주민번호 중복 체크
				
				//if(birth == null || birth.isEmpty() || birth_num == null || birth_num == " " || birth_num.equals(" ")){ //주민번호 없으면
					evalDAO.insertCommissionerPoolExcel(commiMap);
					evalDAO.insertCommissionerDetailExcel(commiMap);
				/*
				}else{ //주민번호 있으면
					commiMap.put("commissioner_pool_seq", birth.get("commissioner_pool_seq"));
					evalDAO.updateCommissionerPoolExcel(commiMap);
					evalDAO.updateCommissionerDetailExcel(commiMap);
					evalDAO.deleteBizTypeCodeExcel(commiMap);			
				}
				*/
				if(sp.contains(",")) { // 전문분야 여러개
					String[] splist = sp.split(",");
					for(int j = 0; j < splist.length; j ++) {
						bizMap = new HashMap<String, Object>();
						bizMap.put( "biz_type_array", splist[j].replace(" ", "").trim());
						bizMap.put( "commissioner_pool_seq", commiMap.get("commissioner_pool_seq"));
						spList.add(bizMap);
					}
				}else { //전문분야 한개
					bizMap = new HashMap<String, Object>();
					bizMap.put("biz_type_array", cellValueToString(row.getCell(2)).replace(" ", "").trim());
					bizMap.put( "commissioner_pool_seq", commiMap.get("commissioner_pool_seq"));
					spList.add(bizMap);
				}
				evalDAO.insertBizTypeCodeExcel(spList);
			}
		}
		
		try {
			
		} catch (Exception e) {
			e.getStackTrace();
			System.out.println(e);
		}
		dest.delete();
		inputStream.close();

	}
	
	public String cellValueToString(XSSFCell cell){
        String txt = "";
       
        try {
            if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
                txt = cell.getStringCellValue();
            }else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
                txt = String.valueOf( Math.round(cell.getNumericCellValue()) );
            }else if(cell.getCellType() == XSSFCell.CELL_TYPE_FORMULA){
                txt = cell.getRawValue();
            }
        } catch (Exception e) {
   
        }
        return txt;
    }

	@Override
	public void evaluationCommitteeListExcelSampleDownload(HttpServletRequest request, HttpServletResponse response) {
		
		//String serverPath = "/home/upload/cust_eval/";
		//String localPath = "C:\\Users\\nnaangee\\Desktop\\농정원\\";
		String serverPath = request.getSession().getServletContext().getRealPath("/exceltemplate/");
		String localPath = "C:/workspace/CustomNPEPIS/src/main/webapp/resources/exceltemplate/";
		String fileName = "평가위원_등록_샘플.xlsx";
		String viewFileNm = "평가위원_등록_샘플.xlsx";
		//File reFile = new File(serverPath + fileName);
		
		File reFile = new File(serverPath + "/" + fileName);
		
		try {
			if (reFile.exists() && reFile.isFile()) {
				response.setContentType("application/octet-stream; charset=utf-8");
				response.setContentLength((int) reFile.length());
				String browser = getBrowser(request);
				String disposition = getDisposition(viewFileNm, browser);
				response.setHeader("Content-Disposition", disposition);
				response.setHeader("Content-Transfer-Encoding", "binary");
				OutputStream out = response.getOutputStream();
				FileInputStream fis = null;
				fis = new FileInputStream(reFile);
				FileCopyUtils.copy(fis, out);
				if (fis != null)
					fis.close();
				out.flush();
				out.close();
				
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public String getDisposition(String filename, String browser) throws Exception {
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
		return dispositionPrefix + encodedFilename;
	}
	
	public static String getBrowser(HttpServletRequest request) {
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
	public Map<String, Object> getEvalCommOne(Map<String, Object> map) {
		return evalDAO.getEvalCommOne(map);
	}

	@Override
	public Map<String, Object> getJangName(Map<String, Object> login) {
		return evalDAO.getJangName(login);
	}
}
