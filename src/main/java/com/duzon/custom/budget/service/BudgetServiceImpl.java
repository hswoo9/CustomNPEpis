package com.duzon.custom.budget.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ch.qos.logback.core.net.SyslogOutputStream;
import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.budget.dao.BudgetDAO;
import com.duzon.custom.budget.dao.BudgetMariaDAO;
import com.duzon.custom.kukgoh.dao.KukgohDAO;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.duzon.custom.resalphag20.service.impl.PdfEcmThread;

import ac.cmm.vo.ConnectionVO;

@Service ("BudgetService")
public class BudgetServiceImpl implements BudgetService {
	private String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"};

	@Resource ( name = "BudgetDAO" )
	private BudgetDAO budgetDAO;

	@Resource ( name = "BudgetMariaDAO" )
	private BudgetMariaDAO budgetMariaDAO;

	@Resource ( name = "kukgohDAO" )
	private KukgohDAO kukgohDAO;

	// G20 회계단위 목록 조회
	public List<Map<String, Object>> getErpDivList(ConnectionVO conVo, Map<String, Object> map) {
		return budgetDAO.getErpDivList(conVo, map);
	}

	// G20 프로젝트 목록 조회
	public List<Map<String, Object>> getErpPjtList(ConnectionVO conVo, Map<String, Object> map) {
		return budgetDAO.getErpPjtList(conVo, map);
	}

	// G20 하위사업 목록 조회
	public List<Map<String, Object>> getErpBtmList(ConnectionVO conVo, Map<String, Object> map) {
		return budgetDAO.getErpBtmList(conVo, map);
	}

	public List<Map<String, Object>> getBudgetDataList(ConnectionVO conVo, Map<String, Object> map) {
		// 부서코드를 하위사업으로 매핑, 조회조건에 부서에 해당하는 하위사업 추가
		if (map.get("deptSeq") != null && !"".equals(map.get("deptSeq"))) {
			Map<String, Object> btmInfo = budgetMariaDAO.getBtmInfoList(map);
			String btmCd = Objects.toString(btmInfo.get("btmCd"), "") + Objects.toString(map.get("btmCd"), "");

			map.put("btmCd", btmCd);
		}

		List<Map<String, Object>> budgetMap = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> budgetList = budgetDAO.getBudgetDataList(conVo, map);

		for (int i = 0; i < budgetList.size(); i++) {
			Map<String, Object> budgetInfo = budgetList.get(i);

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("pjtCd",  budgetInfo.get("MGT_CD"));
			param.put("btmCd",  budgetInfo.get("BOTTOM_CD"));

			// 하위사업에 해당하는 부서명 읽어오기
			Map<String, Object> deptInfo = budgetMariaDAO.getBtmDeptInfo(param);

			// 결과에 부서명이 존재하면 부서명 추가
			if (deptInfo != null && deptInfo.size() > 0) {
				budgetInfo.put("deptNm", deptInfo.get("deptNm"));
			} else {
				budgetInfo.put("deptNm", "");
			}

			budgetMap.add(budgetInfo);
		}

		return budgetMap;
	}

	// 프로젝트, 하위사업 목록
	public List<Map<String, Object>> mapPjtBtmList(ConnectionVO conVo, Map<String, Object> map) {
		return budgetDAO.mapPjtBtmList(conVo, map);
	}

	// 예산과목 목록
	public List<Map<String, Object>> mapBgtInfoList(ConnectionVO conVo, Map<String, Object> map) {
		return budgetDAO.mapBgtInfoList(conVo, map);
	}

	// 프로젝트 목록
	public List<Map<String, Object>> pjtInfoList(ConnectionVO conVo, Map<String, Object> map) {
		return budgetDAO.pjtInfoList(conVo, map);
	}

	// 품의액 조회
	public Map<String, Object> getPreBudgetInfo(Map<String, Object> map) {
		return budgetMariaDAO.getPreBudgetInfo(map);
	}

	// 부서 조회
	public Map<String, Object> getDeptInfo(Map<String, Object> map) {
		return budgetMariaDAO.getDeptInfo(map);
	}

	// 프로젝트, 하위사업에 해당하는 부서정보 조회
	public Map<String, Object> getBtmDeptInfo(Map<String, Object> map) {
		return budgetMariaDAO.getBtmDeptInfo(map);
	}

	// 프로젝트, 하위사업에 해당하는 부서목록 조회
	public Map<String, Object> getBtmInfoList(Map<String, Object> map) {
		return budgetMariaDAO.getBtmInfoList(map);
	}

	// 부서정보 저장
	public void saveDept(Map<String, Object> map) {
		// 프로젝트코드_하위사업코드_부서코드로 된 구조임
		String deptArr = (String) map.get("deptSeq");
		String[] deptSeq = deptArr.split(",");

		for (int i = 0; i < deptSeq.length; i++) {
			String[] deptInfo = deptSeq[i].split("_");

			// 3개의 데이터가 있을 경우 (프로젝트 코드, 하위사업 코드, 부서 코드)
			if (deptInfo.length == 3) {
				map.put("pjtCd",   deptInfo[0]);
				map.put("btmCd",   deptInfo[1]);
				map.put("deptSeq", deptInfo[2]);

				// 부서코드가 선택된 상태의 데이터 저장함
				if (deptInfo[2] != null && !"".equals(deptInfo[2])) {
					Map<String, Object> btmDeptInfo = budgetMariaDAO.getBtmDeptInfo(map);

					if (btmDeptInfo != null && !"".equals(btmDeptInfo.get("deptSeq"))) {
						budgetMariaDAO.updateDept(map);
					} else {
						budgetMariaDAO.insertDept(map);
					}
				}
			}
		}
	}

	// 부서정보 저장
	public void setBudgetList(List<Map<String, Object>> map) {
		for (int i = 0; i < map.size(); i++) {
			Map<String, Object> budgetInfo = map.get(i);
			int cnt = budgetMariaDAO.getBudgetCnt(budgetInfo);

			if (cnt > 0) {
				budgetMariaDAO.updateBudget(budgetInfo);
			} else {
				budgetMariaDAO.insertBudget(budgetInfo);
			}
		}
	}

	@Override
	public List<Map<String, Object>> getBudgetDataList2(ConnectionVO conVo, Map<String, Object> map) {

		List<Map<String, Object>> budgetList = budgetDAO.getBudgetDataList2(conVo, map);

		return budgetList;
	}

	@Override
	public Map<String, Object> getPreBudgetInfo2(Map<String, Object> map) {
		return budgetMariaDAO.getPreBudgetInfo2(map);
	}

	@Override
	public Map<String, Object> comboList(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("accountingUnitList", budgetDAO.accountingUnitList(map));
		result.put("projectList", budgetDAO.projectList(map));
		result.put("budgetList", budgetDAO.budgetList(map));
		result.put("mokList", budgetDAO.mokList(map));

		return result;
	}

	@Override
	public Map<String, Object> caseActList(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("list", budgetDAO.caseActList(map));
//		result.put("totalCount", budgetDAO.caseActListTotal(map));
		result.put("totalCount",map.get("totalCount"));
		return result;
	}

	@Override
	public Map<String, Object> caseActDetailList(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("list", budgetDAO.caseActDetailList(map));

		return result;
	}

	@Override
	public List<Map<String, Object>> causeActDocSearch(Map<String, Object> map) {

		List<Map<String, Object>> doc = budgetDAO.causeActDocSearch(map);

		return doc;
	}

	@Override
	public Map<String, Object> ledgerComboList(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("accountingUnitList", budgetDAO.accountingUnitList(map));
		result.put("accountTitleList", budgetDAO.accountTitleList(map));
		//result.put("customerList", budgetDAO.customerList(map));

		return result;
	}

	@Override
	public Map<String, Object> ledgerComboList2(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("accountingUnitList", budgetDAO.accountingUnitList(map));
		result.put("accountTitleList", budgetDAO.accountTitleList(map));

		return result;
	}

	@Override
	public Map<String, Object> ledgerList(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("list", budgetDAO.ledgerList(map));
//		result.put("totalCount", budgetDAO.caseActListTotal(map));
//		result.put("totalCount",map.get("totalCount"));
		return result;
	}

	@Override
	public Map<String, Object> accountingComboList(Map<String, Object> map){

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("accountingUnitList", budgetDAO.accountingUnitList(map));

		return result;
	}

	@Override
	public Map<String, Object> caseActDetailList2(Map<String, Object> map){
		Map<String, Object> result = new HashMap<String,Object>();

		List<Map<String, Object>> listErp = budgetDAO.caseActDetailList(map);
		List<Map<String, Object>> listGw = budgetDAO.caseActDetailList2(map);
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();

		int wonAm = 0;
		int janAm = 0;
		if(map.get("budget_am") != null && !"".equals(map.get("budget_am"))){
			janAm = Integer.valueOf(String.valueOf(map.get("budget_am")));
		}
		for (Map<String, Object> erp : listErp) {
			erp.put("BUDGET_AM", Integer.valueOf(String.valueOf(map.get("budget_am"))));
			if("1".equals(erp.get("DIV"))){
				erp.put("TYPE", "결의서");
			}
			int order1 = Integer.valueOf(String.valueOf(erp.get("ORDER1")));
			for (Iterator<Map<String, Object>> it = listGw.iterator(); it.hasNext() ; ) {
				Map<String, Object> gw = it.next();
				gw.put("BUDGET_AM", Integer.valueOf(String.valueOf(map.get("budget_am"))));
				int gisu_dt2 = Integer.valueOf(String.valueOf(gw.get("GISU_DT2")));
				if("2".equals(erp.get("DIV")) && "2".equals(gw.get("DIV")) && order1 == gisu_dt2){
					if("2".equals(gw.get("DIV"))){
						wonAm += Integer.valueOf(String.valueOf(gw.get("WON_AM")));
						janAm -= Integer.valueOf(String.valueOf(gw.get("WON_AM")));
						gw.put("JAN_AM", janAm);
					}
					erp.put("WON_AM", Float.valueOf(String.valueOf(gw.get("WON_AM"))));
					erp.put("JAN_AM", janAm);
					it.remove();
				}else if(order1 > gisu_dt2){
					if("2".equals(gw.get("DIV"))){
						wonAm += Integer.valueOf(String.valueOf(gw.get("WON_AM")));
						janAm -= Integer.valueOf(String.valueOf(gw.get("WON_AM")));
						gw.put("JAN_AM", janAm);
					}
					resultList.add(gw);
					it.remove();
				}else{
					resultList.add(erp);
					break;
				}
			}
			if("2".equals(erp.get("DIV"))){
				erp.put("GISU_DT", "월계");
				janAm -= Float.valueOf(String.valueOf(erp.get("UNIT_AM")));
				erp.put("JAN_AM", janAm);
			}
			if("3".equals(erp.get("DIV"))){
				erp.put("GISU_DT", "누계");
				erp.put("WON_AM", wonAm);
				erp.put("JAN_AM", janAm);
			}
			if(listGw.size() == 0){
				resultList.add(erp);
			}
		}
		result.put("list", resultList);

		return result;
	}

	@Override
	public Map<String, Object> getVoucher(Map<String, Object> map) {

		Map<String, Object> paramMap = budgetDAO.getVoucher(map);

		paramMap.put("C_DIKEYCODE", "");
		paramMap.put("DOC_NUMBER", "");
		paramMap.put("DOC_TITLE", "");
		paramMap.put("DOC_REGDATE", "");
		paramMap.put("OUT_YN", "");
		paramMap.put("OUT_MSG", "");

		budgetDAO.getDocInfo(paramMap);

		return paramMap;
	}

	@Override
	public List<Map<String, Object>> getVoucherDetail(Map<String, Object> map) {
		return budgetDAO.getVoucherDetail(map);
	}

	@Override
	public Map<String, Object> getResolutionAdocm(Map<String, Object> map) {
		return budgetDAO.getResolutionAdocm(map);
	}

	@Override
	public List<Map<String, Object>> getResolutionAdocb(Map<String, Object> map) {
		return budgetDAO.getResolutionAdocb(map);
	}

	@Override
	public List<Map<String, Object>> getResolutionAdoct(Map<String, Object> map) {
		return budgetDAO.getResolutionAdoct(map);
	}

	@Override
	public List<Map<String, Object>> getAccountTitleList(Map<String, Object> map) {
		return budgetDAO.getAccountTitleList(map);
	}

	@Override
	public List<Map<String, Object>> getCustomerList(Map<String, Object> map) {
		return budgetDAO.getCustomerList(map);
	}

	@Override
	public Map<String, Object> accountLedgerList(Map<String, Object> map) {

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("list", budgetDAO.accountLedgerList(map));

		return result;
	}

	@Override
	public Map<String, Object> generalAccountLedgerList(Map<String, Object> map) {

		Map<String, Object> result = new HashMap<String,Object>();

		result.put("list", budgetDAO.generalAccountLedgerList(map));

		return result;
	}

	@Override
	public Map<String, Object> resolutionDeptComboList(Map<String, Object> map) {

		Map<String, Object> result = new HashMap<>();

		result.put("resolutionDeptList", budgetDAO.resolutionDeptComboList(map));

		return result;
	}

	@Override
	public List<Map<String, Object>> purchaseLedgerList(Map<String, Object> map) {
		return budgetDAO.purchaseLedgerList(map);
	}

	@Override
	public List<Map<String, Object>> salesLedgerList(Map<String, Object> map) {
		return budgetDAO.salesLedgerList(map);
	}

	@Override
	public List<Map<String, Object>> IndividualExpenditureResolutionList(Map<String, Object> map) {

		List<Map<String, Object>> list = budgetDAO.IndividualExpenditureResolutionList(map);

		for (Map<String, Object> map2 : list) {

			map2.put("C_DIKEYCODE", "");
			map2.put("DOC_NUMBER", "");
			map2.put("DOC_TITLE", "");
			map2.put("DOC_REGDATE", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");
			kukgohDAO.getDocInfo(map2);

			if(map2.get("OUT_YN") == null || "N".equals(map2.get("OUT_YN"))) {
				map2.put("DOC_NUMBER", "-");
				map2.put("DOC_TITLE", "-");
				map2.put("DOC_REGDATE", "-");
			}
		}

		return list;
	}

	@Override
	public List<Map<String, Object>> expenditureResolutionStatusList(Map<String, Object> map) {

		List<Map<String, Object>> list = budgetDAO.expenditureResolutionStatusList(map);

		for (Map<String, Object> map2 : list) {

			map2.put("C_DIKEYCODE", "");
			map2.put("DOC_NUMBER", "");
			map2.put("DOC_TITLE", "");
			map2.put("DOC_REGDATE", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");
			kukgohDAO.getDocInfo(map2);

			if(map2.get("OUT_YN") == null || "N".equals(map2.get("OUT_YN"))) {
				map2.put("DOC_NUMBER", "-");
				map2.put("DOC_TITLE", "-");
				map2.put("DOC_REGDATE", "-");
			}
		}

		return list;
	}

	@Override
	public String getOneErpEmpNum(Map<String, Object> map) {
		return budgetDAO.getOneErpEmpNum(map);
	}

	@Override
	public void amoutGoodsList(Map<String, Object> map) {
		budgetDAO.amountGoodsList(map);;
	}

	@Override
	public List<Map<String, Object>> projectPreparationList(Map<String, Object> map) {

		List<Map<String, Object>> list = budgetDAO.projectPreparationList(map);

		for (Map<String, Object> map2 : list) {

			map2.put("FROM_MONTH", map.get("FROM_MONTH"));
			map2.put("MONTH", map.get("MONTH"));
			map2.put("APPLY_AMT", "");
			map2.put("OUT_YN", "");
			map2.put("OUT_MSG", "");

			System.out.println("before@@" + map2);

			budgetDAO.amountGoodsList(map2);

			System.out.println("after@@" + map2);
		}

		return list;
	}

	@Override
	public List<Map<String, Object>> projectList(Map<String, Object> map) {
		return budgetDAO.projectList(map);
	}

	@Override
	public List<Map<String, Object>> projectList3(Map<String, Object> map) {
		return budgetDAO.projectList3(map);
	}

	@Override
	public List<Map<String, Object>> projectList2(Map<String, Object> map) {
		return budgetDAO.projectList2(map);
	}

	@Override
	public List<Map<String, Object>> budgetListAjax(Map<String, Object> map) {
		return budgetDAO.budgetListAjax(map);
	}

	@Override
	public List<Map<String, Object>> mokListAjax(Map<String, Object> map) {
		return budgetDAO.mokList(map);
	}

	@Override
	public List<Map<String, Object>> getResDocSubmitList(Map<String, Object> map) {
		return budgetDAO.getResDocSubmitList(map);
	}

	@Override
	public String resDocSubmit(Map<String, Object> map) {
		String[] resDocSeqArr = String.valueOf(map.get("resDocSeqArr")).split(",");

		for (String resDocSeq : resDocSeqArr) {
			map.put("resDocSeq", resDocSeq);
			budgetDAO.resDocSubmit(map);
		}
		return "Success";
	}

	@Override
	public String resDocUpdate(Map<String, Object> map) {
		String[] resDocSeqArr = String.valueOf(map.get("resDocSeqArr")).split(",");

		for (String resDocSeq : resDocSeqArr) {
			map.put("resDocSeq", resDocSeq);
			budgetDAO.resDocUpdate(map);
		}
		return "Success";
	}

	@Override
	public String updateUseYn(Map<String, Object> map) {
		String[] resDocSeqArr = String.valueOf(map.get("resDocSeqArr")).split(",");

		for (String resDocSeq : resDocSeqArr) {
			map.put("resDocSeq", resDocSeq);
			budgetDAO.updateUseYn(map);
		}
		return "Success";
	}

	@Override
	public String updateReturn(Map<String, Object> map) {
		String[] resDocSeqArr = String.valueOf(map.get("resDocSeqArr")).split(",");

		for (String resDocSeq : resDocSeqArr) {
			map.put("resDocSeq", resDocSeq);
			budgetDAO.updateReturn(map);
		}
		return "Success";
	}

	@Override
	public List<Map<String, Object>> getResDocSubmitAdminList(Map<String, Object> map) {
		List<Map<String, Object>> bgList = budgetDAO.getResDocSubmitAdminList(map);
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		String biddingYn = String.valueOf(map.get("biddingYn"));

		for (Map<String, Object> bgMap : bgList) {

			/*Map<String, Object> prufMap = budgetDAO.getPrufInfo(String.valueOf(bgMap.get("docNo")));*/

			/*if(!MapUtils.isEmpty(prufMap) && prufMap.containsKey("PRUF_SE_CODE")){*/
			/*if(prufMap != null){
				bgMap.put("PRUF_SE_CODE", prufMap.get("PRUF_SE_CODE"));
			}else{
				bgMap.put("PRUF_SE_CODE", "");
			}*/

			Map<String, Object> erpBgMap = budgetDAO.getErpBgInfo(bgMap);

			if (erpBgMap != null) {
				bgMap.putAll(erpBgMap);
			}

			if ("Y".equals(biddingYn)) {
				if (erpBgMap != null) {
					resultList.add(bgMap);
				}
			}else if("N".equals(biddingYn)) {
				if (erpBgMap == null) {
					resultList.add(bgMap);
				}
			}else {
				resultList.add(bgMap);
			}
		}
		return resultList;
	}

	@Override
	public int getResDocSubmitAdminListCnt(Map<String, Object> map) {
		return budgetDAO.getResDocSubmitAdminListCnt(map);
	}


	@Override
	public List<Map<String, Object>> getAdocuList(Map<String, Object> map) {
		map.put("field", map.get("sort[0][field]"));
		map.put("dir", map.get("sort[0][dir]"));
		List<Map<String, Object>> adocuList = budgetDAO.getAdocuList(map);
		for (Map<String, Object> adocu : adocuList) {
			Map<String, Object> resultMap = budgetDAO.getAdocuDocInfo(adocu);
			if(resultMap != null) {
				adocu.putAll(resultMap);
			}
		}
		return adocuList;
	}

	@Override
	public List<Map<String, Object>> getErpDept(String coCd) {
		return budgetDAO.getErpDept(coCd);
	}

	@Override
	public Object getErpEmpList(Map<String, Object> map) {
		return budgetDAO.getErpEmpList(map);
	}

	@Override
	public List<Map<String, Object>> getResDocFile(HashMap<String, Object> requestMap) {
		Map<String, Object> abdocuInfo = budgetDAO.getAbdocuInfo(requestMap);
		Map<String, Object> resDocInfo = budgetDAO.getResDocInfo(abdocuInfo);
		return budgetDAO.getResDocFile(resDocInfo);
	}

	@Override
	public Object getAdocuInfo(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("adocuHInfo", budgetDAO.getAdocuHInfo(map));
		resultMap.put("adocuDInfo", budgetDAO.getAdocuDInfo(map));
		return resultMap;
	}

	@Autowired
	private ResAlphaG20Service resAlphaG20Service;

	@Value("#{bizboxa['BizboxA.pdfServerRootPath']}")
	private String pdfServerRootPath;

	@Override
	public void adocuApp(Map<String, Object> bodyMap) {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		if("90".equals(docSts)) {
			bodyMap.put("C_DIKEYCODE", bodyMap.get("docId"));
			Thread t = new Thread(new PdfEcmThread(bodyMap, resAlphaG20Service, pdfServerRootPath, null));
			t.start();
		}
	}

	@Override
	public List<Map<String, Object>> getParentDept(Map<String, Object> map) {
		return budgetDAO.getParentDept(map);
	}

	@Override
	public void parentDeptCancel(Map<String, Object> map) {
		budgetDAO.parentDeptCancel(map);
	}

	@Override
	public List<Map<String, Object>> searchDeptList(Map<String, Object> map) {
		return budgetDAO.searchDeptList(map);
	}

	@Override
	public List<Map<String, Object>> searchDeptList2(Map<String, Object> map) {
		return budgetDAO.searchDeptList2(map);
	}

	@Override
	public void saveSelDept(Map<String, Object> map) {
		budgetDAO.saveSelDept(map);
	}

	@Override
	public void projectSetDeptCancel(Map<String, Object> map) {
		budgetDAO.projectSetDeptCancel(map);
	}

	@Override
	public List<Map<String, Object>> getProjectList(Map<String, Object> map) {
		return budgetDAO.getProjectList(map);
	}

	@Override
	public void saveProjectDept(Map<String, Object> map) {
		budgetDAO.saveProjectDept(map);
	}

	@Override
	public List<Map<String, Object>> getYesilDaebi(Map<String, Object> map) {
		return budgetDAO.getYesilDaebi(map);
	}

	@Override
	public List<Map<String, Object>> getBonbuYesilDaebi(Map<String, Object> map) {
		return budgetDAO.getBonbuYesilDaebi(map);
	}

	@Override
	public List<Map<String, Object>> getBonbuInfo(Map<String, Object> map) {
		return budgetDAO.getBonbuInfo(map);
	}

	@Override
	public List<Map<String, Object>> getBonbuDeptYesilDaebi(Map<String, Object> map) {
		return budgetDAO.getBonbuDeptYesilDaebi(map);
	}

	@Override
	public List<Map<String, Object>> getProjectDeptYeasilDaebi(Map<String, Object> map) {
		return budgetDAO.getProjectDeptYeasilDaebi(map);
	}

	@Override
	public List<Map<String, Object>> getBgtYeasilDaebi(Map<String, Object> map) {
		return budgetDAO.getBgtYeasilDaebi(map);
	}

	@Override
	public void saveDeptBgt(Map<String, Object> map) {
		budgetDAO.saveDeptBgt(map);
	}

	@Override
	public void cancelDeptBgt(Map<String, Object> map) {
		budgetDAO.cancelDeptBgt(map);
	}

	@Override
	public void saveDeptBgt2(Map<String, Object> map) {
		budgetDAO.saveDeptBgt2(map);
	}

	@Override
	public List<Map<String, Object>> getApplyStatus(Map<String, Object> map) {
		return budgetDAO.getApplyStatus(map);
	}

	@Override
	public List<Map<String, Object>> getDeptBgtStatus(Map<String, Object> map) {
		return budgetDAO.getDeptBgtStatus(map);
	}

	@Override
	public void saveDeptBgt3(Map<String, Object> map) {
		budgetDAO.saveDeptBgt3(map);
	}

	@Override
	public void cancelDeptBgt2(Map<String, Object> map) {
		budgetDAO.cancelDeptBgt2(map);
	}

	@Override
	public List<Map<String, Object>> getDeptPjtBgt(Map<String, Object> map) {
		return budgetDAO.getDeptPjtBgt(map);
	}

	@Override
	public void saveDeptPjtBgt(Map<String, Object> map) {
		budgetDAO.saveDeptPjtBgt(map);
	}

	@Override
	public void cancelDeptPjtBgt(Map<String, Object> map) {
		budgetDAO.cancelDeptPjtBgt(map);
	}

	@Override
	public List<Map<String, Object>> getDeptPjtBgt2(Map<String, Object> map) {
		return budgetDAO.getDeptPjtBgt2(map);
	}

	@Override
	public List<Map<String, Object>> getDeptBgt(Map<String, Object> map) {
		return budgetDAO.getDeptBgt(map);
	}

	@Override
	public List<Map<String, Object>> getProjectYesilDaebi(Map<String, Object> map) {
		return budgetDAO.getProjectYesilDaebi(map);
	}

	@Override
	public List<Map<String, Object>> getBgtPlanGrid(Map<String, Object> map) {
		return budgetDAO.getBgtPlanGrid(map);
	}

	/**
	 *  일괄 제출
	 */
	@Override
	public void saveBgtPlan(Map<String, Object> map) {
		map.put("bgtAmt", Integer.parseInt(String.valueOf(map.get("bgtAmt"))));

		budgetDAO.saveBgtPlan(map);
	}

	/**
	 *  단일 제출 및 임시저장
	 * @throws IOException
	 * @throws IllegalStateException
	 */
	@Override
	public void saveBgtPlan(Map<String, Object> map, MultipartHttpServletRequest multi, List<Map<String, Object>> delFiles) throws Exception {

		String ROOT_PATH = "";

		if (multi.getServerName().contains("localhost") || multi.getServerName().contains("127.0.0.1")) {
			ROOT_PATH = "C:/home/upload/budget";
		} else {
			ROOT_PATH = "/home/upload/budget";
		}

		String targetId = java.util.UUID.randomUUID().toString().replace("-", "");
		String orderSq = String.valueOf(map.get("orderSq"));
		String pjtCd = String.valueOf(map.get("pjtCd"));

		// 기존 저장되있던 파일 처리
		if (delFiles.size() > 0) {
			for (Map<String, Object> delFile : delFiles) {
				budgetDAO.updateFile(delFile);
			}
		}

		// 기존에 저장 된 파일중 MAX 시퀀스 번호
		String fileMaxSeq = budgetDAO.selectMaxFileSeq(map);
		int fileSeq = Integer.parseInt(fileMaxSeq) + 1;

		Iterator<String> files = multi.getFileNames();

		while (files.hasNext()) {
			Map<String, Object> param = new HashMap<String, Object>();
			MultipartFile mFile = multi.getFile(files.next());

			String orgFileName = mFile.getOriginalFilename();
			String realFileName = orderSq + fileSeq + targetId.substring(0, 10);
			String filePath = ROOT_PATH + "/" + pjtCd + "/";

			System.out.println("@@orgFileName : " + orgFileName);
			System.out.println("@@fileSize : " + mFile.getSize());

			/* 파일 이름 유효성 체크 */
			for (int j = 0; j < invalidName.length; j++) {
				orgFileName = orgFileName.replaceAll(invalidName[j], "_");
			}

			String ext = orgFileName.substring(orgFileName.lastIndexOf(".")+1);

			param.put("orgFileName", orgFileName);
			param.put("realFileName", realFileName);
			param.put("fileSize", String.valueOf(mFile.getSize()));
			param.put("fileSeq", fileSeq++);
			param.put("targetId", orderSq);
			param.put("ext", ext);
			param.put("filePath", filePath);

			budgetDAO.insertBudgetAttach(param);

			File dir = new File(filePath);

			if(!dir.isDirectory()){
                dir.mkdirs();
            }

			mFile.transferTo(new File(filePath + realFileName + "." + ext));
		}

		map.put("fileId", orderSq);
		map.put("bgtAmt", Long.parseLong(String.valueOf(map.get("bgtAmt"))));

		budgetDAO.saveBgtPlan(map);
	}

	@Override
	public void copyBgtPlan(Map<String, Object> map) {
		budgetDAO.copyBgtPlan(map);
	}

	@Override
	public void cancelBgtPlan(Map<String, Object> map) {
		budgetDAO.cancelBgtPlan(map);
	}

	@Override
	public String callGetPjtBudget(Map<String, Object> map) {
		return budgetDAO.callGetPjtBudget(map);
	}

	@Override
	public void saveEndProcess(Map<String, Object> map) {
		budgetDAO.saveEndProcess(map);
	}

	@Override
	public void cancelEndProcess(Map<String, Object> map) {
		budgetDAO.cancelEndProcess(map);
	}

	@Override
	public List<Map<String, Object>> getBudgetAttach(Map<String, Object> map) {
		return budgetDAO.getBudgetAttach(map);
	}

	@Override
	public List<Map<String, Object>> searchDeptList3(Map<String, Object> map) {
		return budgetDAO.searchDeptList3(map);
	}

	@Override
	public List<Map<String, Object>> searchDeptList6(Map<String, Object> map) {
		return budgetDAO.searchDeptList6(map);
	}

	@Override
	public List<Map<String, Object>> getPjtStatus(Map<String, Object> map) {
		return budgetDAO.getPjtStatus(map);
	}

	@Override
	public List<Map<String, Object>> getBgtConfirmGrid(Map<String, Object> map) {
		return budgetDAO.getBgtConfirmGrid(map);
	}

	@Override
	public void confirmBgtPlan(Map<String, Object> map) {
		budgetDAO.confirmBgtPlan(map);
	}

	@Override
	public void cancelConfirmBgtPlan(Map<String, Object> map) {
		budgetDAO.cancelConfirmBgtPlan(map);
	}

	@Override
	public List<Map<String, Object>> selectBudgetList(Map<String, Object> map) {
		return budgetDAO.selectBudgetList(map);
	}

	@Override
	public List<Map<String, Object>> selectDailySchedule(Map<String, Object> map) {
		return budgetDAO.selectDailySchedule(map);
	}

	@Override
	public void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {

		Map<String, Object> result =  budgetDAO.getBudgetAttachOne(map);
		String fileName = String.valueOf(result.get("file_name"));
		String fileExt = String.valueOf(result.get("file_extension"));
		String path = String.valueOf(result.get("file_path")) + String.valueOf(result.get("real_file_name")) + "." + fileExt;

		try {
			fileDownLoad(fileName, path, request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void excelDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {

		String fileName = String.valueOf(map.get("fileName"));
		String path = String.valueOf(map.get("fileFullPath"));

		try {
			fileDownLoad(fileName, path, request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void fileDownLoad(String fileNm, String path, HttpServletRequest request, HttpServletResponse response) throws Exception {
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

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

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
	public Map<String, Object> getErpGwLinkInfo(Map<String, Object> paramMap) throws Exception {
		return budgetDAO.getErpGwLinkInfo(paramMap);
	}

	public Map<String, Object> getDailyScheduleCheck(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<>();
		Map<String, Object> tmp = budgetDAO.getDailyScheduleCheck(map);
		if (tmp == null) {
			resultMap.put("check", "N");
		} else {
			resultMap.put("check", "Y");
		}
		return resultMap;
	}

	@Override
	public void saveHighDept(Map<String, Object> map) {
		budgetDAO.saveHighDept(map);
	}

	@Override
	public String selectBgtFinish(Map<String, Object> map) {
		return budgetDAO.selectBgtFinish(map);
	}

	@Override
	public void saveBgtFinish(Map<String, Object> map) {
		budgetDAO.saveBgtFinish(map);
	}

	@Override
	public void cancelBgtFinish(Map<String, Object> map) {
		budgetDAO.cancelBgtFinish(map);
	}

	@Override
	public List<Map<String, Object>> selectBgtPlanRecord(Map<String, Object> map) {
		return budgetDAO.selectBgtPlanRecord(map);
	}

	@Override
	public List<Map<String, Object>> selectBgtStatus(Map<String, Object> map) {
		return budgetDAO.selectBgtStatus(map);
	}

	@Override
	public List<Map<String, Object>> selectPjtBgtStatus(Map<String, Object> map) {
		return budgetDAO.selectPjtBgtStatus(map);
	}

	@Override
	public String getDailyScheduleStatus(Map<String, Object> paramMap) throws Exception {
		return budgetDAO.getDailyScheduleStatus(paramMap);
	}

	@Override
	public void saveDailyScheduleStatus(Map<String, Object> map) throws Exception {
		budgetDAO.saveDailyScheduleStatus(map);
	}

	@Override
	public void uploadBudgetFile(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception {
		String ROOT_PATH = "";

		if (multi.getServerName().contains("localhost") || multi.getServerName().contains("127.0.0.1")) {
			ROOT_PATH = "C:/home/upload/budget";
		} else {
			ROOT_PATH = "/home/upload/budget";
		}

		List<Map<String, Object>> list = budgetDAO.getBudgetAttach(map);

		int fileSeq = list.size() + 1;
		String targetId = String.valueOf(map.get("targetId"));
		String pjtCd = String.valueOf(map.get("pjtCd"));

		Iterator<String> files = multi.getFileNames();

		while (files.hasNext()) {
			Map<String, Object> param = new HashMap<String, Object>();
			MultipartFile mFile = multi.getFile(files.next());

			String orgFileName = mFile.getOriginalFilename();
			String realFileName = fileSeq + targetId;
			String filePath = ROOT_PATH + "/" + pjtCd + "/";

			/* 파일 이름 유효성 체크 */
			for (int j = 0; j < invalidName.length; j++) {
				orgFileName = orgFileName.replaceAll(invalidName[j], "_");
			}

			String ext = orgFileName.substring(orgFileName.lastIndexOf(".")+1);

			param.put("orgFileName", orgFileName);
			param.put("realFileName", realFileName);
			param.put("fileSize", String.valueOf(mFile.getSize()));
			param.put("fileSeq", fileSeq++);
			param.put("targetId", targetId);
			param.put("ext", ext);
			param.put("filePath", filePath);

			budgetDAO.insertBudgetAttach(param);

			File dir = new File(filePath);

			if(!dir.isDirectory()){
                dir.mkdirs();
            }

			mFile.transferTo(new File(filePath + realFileName + "." + ext));
		}

	}

	@Override
	public void updateFile(Map<String, Object> map) {
		budgetDAO.updateFile(map);
	}

	@Override
	public List<Map<String, Object>> selectMonthSaupBgt(Map<String, Object> map) {
		return budgetDAO.selectMonthSaupBgt(map);
	}

	@Override
	public String getSumAmtByDate(Map<String, Object> map) {
		return budgetDAO.getSumAmtByDate(map);
	}

	@Override
	public String getAskedEmpNm(String modifyId) {
		return budgetDAO.getAskedEmpNm(modifyId);
	}

	//applyDeptBgt 에서 사용한다!
	@Override
	public void saveBgtPlanDept(Map<String, Object> map, MultipartHttpServletRequest multi, List<Map<String, Object>> delFiles) throws Exception {

		String ROOT_PATH = "";

		if (multi.getServerName().contains("localhost") || multi.getServerName().contains("127.0.0.1")) {
			ROOT_PATH = "C:/home/upload/budget";
		} else {
			ROOT_PATH = "/home/upload/budget";
		}

		String targetId = java.util.UUID.randomUUID().toString().replace("-", "");
		String orderSq = String.valueOf(map.get("bgtMonth"));
		orderSq += String.valueOf(map.get("pjtCd")); //orderSq 는 날짜 + pjtCd
		map.put("orderSq", orderSq);
		String pjtCd = String.valueOf(map.get("pjtCd"));
		// 기존 저장되있던 파일 처리
		if (delFiles.size() > 0) {
			for (Map<String, Object> delFile : delFiles) {
				budgetDAO.updateFile(delFile);
			}
		}

		// 기존에 저장 된 파일중 MAX 시퀀스 번호
		String fileMaxSeq = budgetDAO.selectMaxFileSeq(map);
		int fileSeq = Integer.parseInt(fileMaxSeq) + 1;

		Iterator<String> files = multi.getFileNames();
		System.out.println(files + " files 안의 내용들 찍어보기 ");
		while (files.hasNext()) {
			Map<String, Object> param = new HashMap<String, Object>();
			MultipartFile mFile = multi.getFile(files.next());

			String orgFileName = mFile.getOriginalFilename();
			String realFileName = orderSq + fileSeq + targetId.substring(0, 10);
			String filePath = ROOT_PATH + "/" + pjtCd + "/";

			System.out.println("@@orgFileName : " + orgFileName);
			System.out.println("@@fileSize : " + mFile.getSize());

			/* 파일 이름 유효성 체크 */
			for (int j = 0; j < invalidName.length; j++) {
				orgFileName = orgFileName.replaceAll(invalidName[j], "_");
			}

			String ext = orgFileName.substring(orgFileName.lastIndexOf(".")+1);

			param.put("orgFileName", orgFileName);
			param.put("realFileName", realFileName);
			param.put("fileSize", String.valueOf(mFile.getSize()));
			param.put("fileSeq", fileSeq++);
			param.put("targetId", orderSq);
			param.put("ext", ext);
			param.put("filePath", filePath);

			budgetDAO.insertBudgetAttach(param);

			File dir = new File(filePath);

			if(!dir.isDirectory()){
				dir.mkdirs();
			}

			mFile.transferTo(new File(filePath + realFileName + "." + ext));
		}

		map.put("fileId", orderSq);

		budgetDAO.saveBgtPlanDept(map);
	}

	@Override
	public List<Map<String, Object>> getResDocBizFeeList(Map<String, Object> map) {
		List<Map<String, Object>> bgList = budgetDAO.getResDocBizFeeList(map);
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		String biddingYn = String.valueOf(map.get("biddingYn"));

		for (Map<String, Object> bgMap : bgList) {

			/*Map<String, Object> prufMap = budgetDAO.getPrufInfo(String.valueOf(bgMap.get("docNo")));*/

			/*if(!MapUtils.isEmpty(prufMap) && prufMap.containsKey("PRUF_SE_CODE")){*/
			/*if(prufMap != null){
				bgMap.put("PRUF_SE_CODE", prufMap.get("PRUF_SE_CODE"));
			}else{
				bgMap.put("PRUF_SE_CODE", "");
			}*/

			Map<String, Object> erpBgMap = budgetDAO.getErpBgInfo(bgMap);

			if (erpBgMap != null) {
				bgMap.putAll(erpBgMap);
			}

			if ("Y".equals(biddingYn)) {
				if (erpBgMap != null) {
					resultList.add(bgMap);
				}
			}else if("N".equals(biddingYn)) {
				if (erpBgMap == null) {
					resultList.add(bgMap);
				}
			}else {
				resultList.add(bgMap);
			}
		}
		return resultList;
	}

	@Override
	public int getResDocBizFeeListCnt(Map<String, Object> map) {
		return budgetDAO.getResDocBizFeeListCnt(map);
	}

	@Override
	public List<Map<String, Object>> getResDocDailyExpList(Map<String, Object> map) {
		List<Map<String, Object>> bgList = budgetDAO.getResDocDailyExpList(map);
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		String biddingYn = String.valueOf(map.get("biddingYn"));

		for (Map<String, Object> bgMap : bgList) {

			/*Map<String, Object> prufMap = budgetDAO.getPrufInfo(String.valueOf(bgMap.get("docNo")));*/

			/*if(!MapUtils.isEmpty(prufMap) && prufMap.containsKey("PRUF_SE_CODE")){*/
			/*if(prufMap != null){
				bgMap.put("PRUF_SE_CODE", prufMap.get("PRUF_SE_CODE"));
			}else{
				bgMap.put("PRUF_SE_CODE", "");
			}*/

			Map<String, Object> erpBgMap = budgetDAO.getErpBgInfo(bgMap);

			if (erpBgMap != null) {
				bgMap.putAll(erpBgMap);
			}

			if ("Y".equals(biddingYn)) {
				if (erpBgMap != null) {
					resultList.add(bgMap);
				}
			}else if("N".equals(biddingYn)) {
				if (erpBgMap == null) {
					resultList.add(bgMap);
				}
			}else {
				resultList.add(bgMap);
			}
		}
		return resultList;
	}
	@Override
	public int getResDocDailyExpListCnt(Map<String, Object> map) {
		return budgetDAO.getResDocSubmitAdminListCnt(map);
	}
}
