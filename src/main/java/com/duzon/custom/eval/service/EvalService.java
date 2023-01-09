package com.duzon.custom.eval.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.eval.vo.CommitteeVO;
import com.duzon.custom.eval.vo.EvalVO;


public interface EvalService {

	void evaluationCommitteeViweSave(EvalVO evalVo);

	Map<String, Object> evaluationCommitteeListSearch(Map<String, Object> map) throws Exception;

	void getCommittee(Map<String, Object> map, Model model);

	void evaluationCommitteeViweUpdate(EvalVO evalVo);

	void evaluationCommitteeDel(Map<String, Object> map);

	Map<String, Object> evalBizTypeListSearch(Map<String, Object> map);

	void evalBizTypeSave(Map<String, Object> map);

	void evalBizTypeDel(Map<String, Object> map);

	List<Map<String, Object>> evalTypeSearch(Map<String, Object> map);

	Map<String, Object> evalBizTypeItemListSearch(Map<String, Object> map);

	void evalBizTypeItemDel(Map<String, Object> map);

	void evalBizTypeItemSave(Map<String, Object> map);

	void evalBizTypeItemUpdate(Map<String, Object> map);

	Map<String, Object> evaluationProposalViewSave(CommitteeVO committeeVO, Map<String, Object> map);

	Map<String, Object> evaluationProposalConfigurationViewSave(CommitteeVO committeeVO, Map<String, Object> map);

	Map<String, Object> evaluationProposalListSearch(Map<String, Object> map);

	Map<String, Object> evaluationProposalConfigurationListSearch(Map<String, Object> map);

	void evaluationProposalListDel(Map<String, Object> map);

	Map<String, Object> getEvaluationProposal(Map<String, Object> map);

	Map<String, Object> getEvaluationProposal2(Map<String, Object> map);

	Map<String, Object> evaluationIdListSearch(Map<String, Object> map);

	Map<String, Object> evaluationIdViewSave(Map<String, Object> map);

	void evaluationIdViewDel(Map<String, Object> map);

	List<Map<String, Object>> getEvalItemList(Map<String, Object> map);

	Map<String, Object> getEvalCommList(Map<String, Object> map);
	
	Map<String, Object> getEvalCommListPop(Map<String, Object> map);

	void setEvalCommSave(Map<String, Object> map);
	
	void setEvalCommSave2(Map<String, Object> map);

	List<Map<String, Object>> getEvalCommUserList(Map<String, Object> map);

	List<Map<String, Object>> getEvalCommTypeList(Map<String, Object> map);

	List<Map<String, Object>> getEvalIdList(Map<String, Object> map);

	void setevalIdSave(Map<String, Object> map);

	List<Map<String, Object>> getcommItem(Map<String, Object> map);

	Map<String, Object> getEvalUserIdChk(Map<String, Object> map);

	Map<String, Object> joinOrgGridList(Map<String, Object> map);

	List<Map<String, Object>> getEvalCompany(Map<String, Object> map);

	List<Map<String, Object>> getEvalitem(Map<String, Object> map);

	List<Map<String, Object>> getEvaCommList(Map<String, Object> map);

	List<Map<String, Object>> getEvalCommItemList(Map<String, Object> map);

	Map<String, Object> evalResultList(Map<String, Object> map);

	Map<String, Object> evalCompanyListSearch(Map<String, Object> map);

	void evalCompanySave(Map<String, Object> map);

	void evalCompanyDel(Map<String, Object> map);

	void evalCommFix(Map<String, Object> map);

	void evalTransPaySave(Map<String, Object> list, MultipartHttpServletRequest multi);

	List<Map<String, Object>> purcListSearch(Map<String, Object> map);

	List<Map<String, Object>> getPurcBiddingList(Map<String, Object> map);

	void evalCommCancel(Map<String, Object> map);

	Map<String, Object> evalAnListSearch(Map<String, Object> map);

	String getEvalContents(Map<String, Object> map);

	Map<String, Object> evalAnTempSave(Map<String, Object> map);

	List<Map<String, Object>> getCommissionerAnUserList(Map<String, Object> map);

	Map<String, Object> getEvalAnData(Map<String, Object> map);

	void evalAnOutProcess(Map<String, Object> map);

	void finalApprovalActiveSave(Map<String, Object> map);

	void evalProposalModFileDownload(Map<String, Object> map, HttpServletRequest request,HttpServletResponse response);
	
	void evalProposalModFileDownload2(Map<String, Object> map, HttpServletRequest request,HttpServletResponse response);
	
	void evaluationCommitteeListUploadExcel(Map<String, Object> map,  MultipartHttpServletRequest multi, Model model) throws Exception;
	
	void evaluationCommitteeListExcelSampleDownload(HttpServletRequest request,HttpServletResponse response);

	Map<String, Object> getEvalCommOne(Map<String, Object> map);

	Map<String, Object>  getJangName(Map<String, Object> login);

}
