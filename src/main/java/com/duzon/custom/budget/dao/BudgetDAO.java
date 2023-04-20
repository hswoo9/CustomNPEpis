package com.duzon.custom.budget.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

import ac.cmm.vo.ConnectionVO;

@Repository("BudgetDAO")
public class BudgetDAO extends AbstractDAO{
	/* 변수정의 */
	private SqlSessionFactory sqlSessionFactory;

	/* 변수정의 - 로그 */
	private org.apache.logging.log4j.Logger	LOG	= LogManager.getLogger(this.getClass());

	/* 공통사용 - 커넥션 */
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		
		try {
			String resource = "config/mybatis/context-mapper-g20-config.xml";

			Properties props = new Properties();
			props.put("databaseType", conVo.getDatabaseType());
			props.put("driver",       conVo.getDriver());
			props.put("url",          conVo.getUrl());
			props.put("username",     conVo.getUserId());
			props.put("password",     conVo.getPassWord());
			props.put("erpTypeCode",  conVo.getSystemType());
			
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);

			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			}
			else {
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			}
			
			result = true;
		}
		catch (Exception e) {
//			System.out.println("세션 팩토리 생성 실패:" + e.getMessage());
		}

		return result;
	}

	private List<Map<String, Object>> list(String queryID, ConnectionVO conVo, Map<String, Object> paraMap) {
		LOG.debug("+ [G20] BudgetDAO - list");
		LOG.debug("! [G20] String queryID >> " + queryID);
		LOG.debug("! [G20] Map<String, String> paraMap >> " + paraMap.toString());

		connect(conVo);
		SqlSession session = sqlSessionFactory.openSession();
		List<Map<String, Object>> result = null;
		
		try {
			result = session.selectList(queryID, paraMap);
		}
		catch (Exception e) {
//			System.out.println(e);
		}
		finally {
			session.close();
		}

		LOG.debug("- [G20] BudgetDAO - list");
		return result;
	}
	
	private Map<String, Object> select(String queryID, ConnectionVO conVo, Map<String, Object> paraMap) {
		connect(conVo);
		
		SqlSession session = sqlSessionFactory.openSession();
		Map<String, Object> result = null;
		
		try {
			result = session.selectOne(queryID, paraMap);
		}
		catch (Exception e) {
//			System.out.println(e);
		}
		finally {
			session.close();
		}

		String resultString = "";
		if (result == null) {
			resultString = "result is null.";
		}
		else {
			resultString  = result.toString();
		}
		
		LOG.debug("! [G20] HashMap<String, String> result >> " + resultString);
		LOG.debug("- [G20] BudgetDAO - select");

		return result;
	}

	public List<Map<String, Object>> getErpDivList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.divList", conVo, paraMap);
	}

	public List<Map<String, Object>> getErpPjtList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.pjtList", conVo, paraMap);
	}

	public List<Map<String, Object>> getErpBtmList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.btmList", conVo, paraMap);
	}

	public List<Map<String, Object>> getBudgetDataList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.budgetDataList", conVo, paraMap);
	}

	public List<Map<String, Object>> mapPjtBtmList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.mapPjtBtmList", conVo, paraMap);
	}

	public List<Map<String, Object>> mapBgtInfoList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.mapBgtInfoList", conVo, paraMap);
	}

	public List<Map<String, Object>> pjtInfoList(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.pjtInfoList", conVo, paraMap);
	}

	public Map<String, Object> statementApprovalMoney(ConnectionVO conVo, Map<String, Object> paraMap) {
		return select("BudgetList.statementApprovalMoney", conVo, paraMap);
	}

	public List<Map<String, Object>> getBudgetDataList2(ConnectionVO conVo, Map<String, Object> paraMap) {
		return list("BudgetList.getBudgetDataList2", conVo, paraMap);
	}
	
	public List<Map<String, Object>> accountingUnitList(Map<String, Object> map) {
		return selectListMs("budgetMs.accountingUnitList", map);
	}
	
	public List<Map<String, Object>> projectList(Map<String, Object> map) {
		return selectListMs("budgetMs.projectList", map);
	}
	
	public List<Map<String, Object>> budgetList(Map<String, Object> map) {
		return selectListMs("budgetMs.budgetList", map);
	}
	
	public List<Map<String, Object>> mokList(Map<String, Object> map) {
		return selectListMs("budgetMs.mokList", map);
	}
	
	public List<Map<String, Object>> resolutionDeptComboList(Map<String, Object> map) {
		return selectListMs("budgetMs.resolutionDeptComboList", map);
	}
	
	public List<Map<String, Object>> accountTitleList(Map<String, Object> map) {
		return selectListMs("budgetMs.accountTitleList", map);
	}
	
	public List<Map<String, Object>> customerList(Map<String, Object> map) {
		return selectListMs("budgetMs.customerList", map);
	}
	
	public int customerListTotal(Map<String, Object> map) {
		return (int)selectOneMs("budgetMs.customerListTotal", map);
	}
	
	public List<Map<String, Object>> caseActList(Map<String, Object> map){
		
		return selectListMs("budgetMs.caseActList", map);
	}
	
	public List<Map<String, Object>> caseActDetailList(Map<String, Object> map){
		
		return selectListMs("budgetMs.caseActDetailList", map);
	}
	
	public List<Map<String, Object>> causeActDocSearch(Map<String, Object> map){
		selectList("BudgetMaria.causeActDocSearch", map);
		return selectList("BudgetMaria.causeActDocSearch1", map);
	}
	
	public List<Map<String, Object>> ledgerList(Map<String, Object> map){
		
		return selectListMs("budgetMs.ledgerList", map);
	}

	public List<Map<String, Object>> accountLedgerList(Map<String, Object> map){
		
		return selectListMs("budgetMs.accountLedgerList", map);
	}
	
	public List<Map<String, Object>> generalAccountLedgerList(Map<String, Object> map){
		
		return selectListMs("budgetMs.generalAccountLedgerList", map);
	}

	public List<Map<String, Object>> caseActDetailList2(Map<String, Object> map) {
		return selectList("BudgetMaria.caseActDetailList2", map);
	}
	
	public Map<String, Object> getVoucher(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("budgetMs.getVoucher", map);
	}
	
	public List<Map<String, Object>> getVoucherDetail(Map<String, Object> map) {
		return selectListMs("budgetMs.getVoucherDetail", map);
	}
	
	public void getDocInfo(Map<String, Object> map) {
		selectOne("BudgetMaria.getDocInfo", map);
	}
	
	public Map<String, Object> getResolutionAdocm(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("budgetMs.getResolutionAdocm", map);
	}
	
	public List<Map<String, Object>> getResolutionAdocb(Map<String, Object> map) {
		return selectListMs("budgetMs.getResolutionAdocb", map);
	}
	
	public List<Map<String, Object>> getResolutionAdoct(Map<String, Object> map) {
		return selectListMs("budgetMs.getResolutionAdoct", map);
	}
	
	public List<Map<String, Object>> getAccountTitleList(Map<String, Object> map) {
		return selectListMs("budgetMs.getAccountTitleList", map);
	}
	
	public List<Map<String, Object>> getCustomerList(Map<String, Object> map) {
		return selectListMs("budgetMs.getCustomerList", map);
	}
	
	public List<Map<String, Object>> purchaseLedgerList(Map<String, Object> map) {
		return selectListMs("budgetMs.purchaseLedgerList", map);
	}
	
	public List<Map<String, Object>> salesLedgerList(Map<String, Object> map) {
		return selectListMs("budgetMs.salesLedgerList", map);
	}
	
	public List<Map<String, Object>> IndividualExpenditureResolutionList(Map<String, Object> map) {
		return selectListMs("budgetMs.IndividualExpenditureResolutionList", map);
	}
	
	public List<Map<String, Object>> expenditureResolutionStatusList(Map<String, Object> map) {
		return selectListMs("budgetMs.expenditureResolutionStatusList", map);
	}
	
	public String getOneErpEmpNum(Map<String, Object> map) {
		return (String) selectOne("BudgetMaria.getOneErpEmpNum", map);
	}
	
	public void amountGoodsList(Map<String, Object> map) {
		selectOne("BudgetMaria.amountGoodsList", map);
	}
	
	public List<Map<String, Object>> projectPreparationList(Map<String, Object> map) {
		return selectListMs("budgetMs.projectPreparationList", map);
	}
	
	public List<Map<String, Object>> budgetListAjax(Map<String, Object> map) {
		return selectListMs("budgetMs.budgetListAjax", map);
	}

	public List<Map<String, Object>> getResDocSubmitList(Map<String, Object> map) {
		return selectList("BudgetMaria.getResDocSubmitList", map);
	}

	public void resDocSubmit(Map<String, Object> map) {
		insert("BudgetMaria.resDocSubmit", map);
	}

	public void resDocUpdate(Map<String, Object> map) {
		update("BudgetMaria.resDocUpdate", map);
	}
	
	public void updateUseYn(Map<String, Object> map) {
		update("BudgetMaria.updateUseYn", map);
	}

	public List<Map<String, Object>> getResDocSubmitAdminList(Map<String, Object> map) {
		return selectList("BudgetMaria.getResDocSubmitAdminList", map);
	}

	public Map<String, Object> getErpBgInfo(Map<String, Object> bgMap) {
		return (Map<String, Object>)selectOneMs("budgetMs.getErpBgInfo", bgMap);
	}

	public Map<String, Object> getPrufInfo(String map) {
		return (Map<String, Object>) selectOneMs("budgetMs.getPrufInfo", map);
	}

	public List<Map<String, Object>> getAdocuList(Map<String, Object> map) {
		return selectListMs("budgetMs.getAdocuList", map);
	}

	public List<Map<String, Object>> getErpDept(String coCd) {
		return selectListMs("budgetMs.getErpDept", coCd);
	}

	public Object getErpEmpList(Map<String, Object> map) {
		return selectListMs("budgetMs.getErpEmpList", map);
	}

	public Map<String, Object> getAbdocuInfo(HashMap<String, Object> requestMap) {
		return (Map<String, Object>)selectOneMs("budgetMs.getAbdocuInfo", requestMap);
	}
	

	public Map<String, Object> getResDocInfo(Map<String, Object> abdocuInfo) {
		return (Map<String, Object>)selectOne("BudgetMaria.getResDocInfo", abdocuInfo);
	}
	
	public List<Map<String, Object>> getResDocFile(Map<String, Object> resDocInfo) {
		return selectList("BudgetMaria.getResDocFile", resDocInfo);
	}

	public Object getAdocuHInfo(Map<String, Object> map) {
		return selectOneMs("budgetMs.getAdocuHInfo", map);
	}

	public Object getAdocuDInfo(Map<String, Object> map) {
		return selectListMs("budgetMs.getAdocuDInfo", map);
	}
	
	public List<Map<String, Object>> getParentDept(Map<String, Object> map) {
		return selectListMs("budgetMs.getParentDept", map);
	}
	
	public void parentDeptCancel(Map<String, Object> paramMap) {
		selectOneMs("budgetMs.parentDeptCancel", paramMap);
	}
	
	public List<Map<String, Object>> searchDeptList(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.searchDeptList", paramMap);
	}
	
	public List<Map<String, Object>> searchDeptList2(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.searchDeptList2", paramMap);
	}
	
	public void saveSelDept(Map<String, Object> paramMap) {
		selectOneMs("budgetMs.saveSelDept", paramMap);
	}
	
	public void projectSetDeptCancel(Map<String, Object> paramMap) {
		selectOneMs("budgetMs.projectSetDeptCancel", paramMap);
	}
	
	public List<Map<String, Object>> getProjectList(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getProjectList", paramMap);
	}
	
	public List<Map<String, Object>> projectList3(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.projectList3", paramMap);
	}
	
	public List<Map<String, Object>> projectList2(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.projectList2", paramMap);
	}
	
	public void saveProjectDept(Map<String, Object> paramMap) {
		selectOneMs("budgetMs.saveProjectDept", paramMap);
	}
	
	public List<Map<String, Object>> getYesilDaebi(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getYesilDaebi", paramMap);
	}
	
	public List<Map<String, Object>> getBonbuYesilDaebi(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getBonbuYesilDaebi", paramMap);
	}
	
	public List<Map<String, Object>> getBonbuInfo(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getBonbuInfo", paramMap);
	}
	
	public List<Map<String, Object>> getBonbuDeptYesilDaebi(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getBonbuDeptYesilDaebi", paramMap);
	}
	
	public List<Map<String, Object>> getProjectDeptYeasilDaebi(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getProjectDeptYeasilDaebi", paramMap);
	}
	
	public List<Map<String, Object>> getBgtYeasilDaebi(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.getBgtYeasilDaebi", paramMap);
	}

	public Map<String, Object> getAdocuDocInfo(Map<String, Object> adocu) {
		return (Map<String, Object>)selectOne("BudgetMaria.getAdocuDocInfo", adocu);
	}

	public void saveDeptBgt(Map<String, Object> map) {
		selectOneMs("budgetMs.saveDeptBgt", map);
	}

	public void cancelDeptBgt(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelDeptBgt", map);
	}

	public void saveDeptBgt2(Map<String, Object> map) {
		selectOneMs("budgetMs.saveDeptBgt2", map);
	}

	public List<Map<String, Object>> getApplyStatus(Map<String, Object> map) {
		return selectListMs("budgetMs.getApplyStatus", map);
	}

	public List<Map<String, Object>> getDeptBgtStatus(Map<String, Object> map) {
		return selectListMs("budgetMs.getDeptBgtStatus", map);
	}

	public void saveDeptBgt3(Map<String, Object> map) {
		selectOneMs("budgetMs.saveDeptBgt3", map);
	}

	public List<Map<String, Object>> getDeptPjtBgt(Map<String, Object> map) {
		return selectListMs("budgetMs.getDeptPjtBgt", map);
	}

	public void cancelDeptBgt2(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelDeptBgt2", map);
	}

	public void saveDeptPjtBgt(Map<String, Object> map) {
		selectOneMs("budgetMs.saveDeptPjtBgt", map);
	}

	public void cancelDeptPjtBgt(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelDeptPjtBgt", map);
	}

	public List<Map<String, Object>> getDeptPjtBgt2(Map<String, Object> map) {
		return selectListMs("budgetMs.getDeptPjtBgt2", map);
	}

	public List<Map<String, Object>> getDeptBgt(Map<String, Object> map) {
		return selectListMs("budgetMs.getDeptBgt", map);
	}
	
	public List<Map<String, Object>> getProjectYesilDaebi(Map<String, Object> map) {
		return selectListMs("budgetMs.getProjectYesilDaebi", map);
	}

	public List<Map<String, Object>> getBgtPlanGrid(Map<String, Object> map) {
		return selectListMs("budgetMs.getBgtPlanGrid", map);
	}

	public void saveBgtPlan(Map<String, Object> map) {
		selectOneMs("budgetMs.saveBgtPlan", map);
	}

	public void copyBgtPlan(Map<String, Object> map) {
		selectOneMs("budgetMs.copyBgtPlan", map);
	}

	public void cancelBgtPlan(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelBgtPlan", map);
	}
	
	public String callGetPjtBudget(Map<String, Object> map) {
		return (String) selectOneMs("budgetMs.callGetPjtBudget", map);
	}
	
	public void saveEndProcess(Map<String, Object> map) {
		selectOneMs("budgetMs.saveEndProcess", map);
	}
	
	public void cancelEndProcess(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelEndProcess", map);
	}
	
	public void insertBudgetAttach(Map<String, Object> map) {
		insert("BudgetMaria.insertBudgetAttach", map);
	}
	
	public List<Map<String, Object>> getBudgetAttach(Map<String, Object> map) {
		return selectList("BudgetMaria.getBudgetAttach", map);
	}
	
	public Map<String, Object> getBudgetAttachOne(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("BudgetMaria.getBudgetAttachOne", map);
	}
	
	public List<Map<String, Object>> searchDeptList3(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.searchDeptList3", paramMap);
	}
	
	public List<Map<String, Object>> searchDeptList6(Map<String, Object> paramMap) {
		return selectListMs("budgetMs.searchDeptList6", paramMap);
	}
	
	public List<Map<String, Object>> getPjtStatus(Map<String, Object> map) {
		return selectListMs("budgetMs.getPjtStatus", map);
	}
	
	public List<Map<String, Object>> getBgtConfirmGrid(Map<String, Object> map) {
		return selectListMs("budgetMs.getBgtConfirmGrid", map);
	}
	
	public void confirmBgtPlan(Map<String, Object> map) {
		selectOneMs("budgetMs.confirmBgtPlan", map);
	}
	
	public void cancelConfirmBgtPlan(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelConfirmBgtPlan", map);
	}
	
	public List<Map<String, Object>> selectBudgetList(Map<String, Object> map) {
		return selectListMs("budgetMs.selectBudgetList", map);
	}
	
	public List<Map<String, Object>> selectDailySchedule(Map<String, Object> map) {
		return selectListMs("budgetMs.selectDailySchedule", map);
	}
	
	public Map<String, Object> getErpGwLinkInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("BudgetMaria.getErpGwLinkInfo", map);
	}
	
	public void saveHighDept(Map<String, Object> map) {
		selectOneMs("budgetMs.saveHighDept", map);
	}
	
	public String selectBgtFinish(Map<String, Object> map) {
		return (String)selectOneMs("budgetMs.selectBgtFinish", map);
	}
	
	public void saveBgtFinish(Map<String, Object> map) {
		selectOneMs("budgetMs.saveBgtFinish", map);
	}
	
	public void cancelBgtFinish(Map<String, Object> map) {
		selectOneMs("budgetMs.cancelBgtFinish", map);
	}
	
	public List<Map<String, Object>> selectBgtPlanRecord(Map<String, Object> map) {
		return selectListMs("budgetMs.selectBgtPlanRecord", map);
	}
	
	public List<Map<String, Object>> selectBgtStatus(Map<String, Object> map) {
		return selectListMs("budgetMs.selectBgtStatus", map);
	}
	
	public List<Map<String, Object>> selectPjtBgtStatus(Map<String, Object> map) {
		return selectListMs("budgetMs.selectPjtBgtStatus", map);
	}
	
	public String getDailyScheduleStatus(Map<String, Object> map) {
		return (String) selectOne("BudgetMaria.getDailyScheduleStatus", map);
	}
	
	public void saveDailyScheduleStatus(Map<String, Object> map) {
		insert("BudgetMaria.saveDailyScheduleStatus", map);
	}

	public void updateFile(Map<String, Object> map) {
		update("BudgetMaria.updateFile", map);
	}

	public List<Map<String, Object>> selectMonthSaupBgt(Map<String, Object> map) {
		return selectListMs("budgetMs.selectMonthSaupBgt", map);
	}
	
	public String selectMaxFileSeq(Map<String, Object> map) {
		return (String) selectOne("BudgetMaria.selectMaxFileSeq", map);
	}
	
	public String getSumAmtByDate(Map<String, Object> map) {
		return (String)selectOneMs("budgetMs.getSumAmtByDate", map);
	}

	public void updateReturn(Map<String, Object> map) {
		update("BudgetMaria.updateReturn", map);
	}
	public String getAskedEmpNm(String modifyId) {
		return (String) selectOne("BudgetMaria.getAskedEmpNm",modifyId);
	}

	public void saveBgtPlanDept(Map<String, Object> map) {
		selectOneMs("budgetMs.saveBgtPlanDept", map);
	}
	
}
