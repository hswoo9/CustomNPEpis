package com.duzon.custom.kukgoh.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class KukgohDAO extends AbstractDAO {

	public void insertTestMS(Map<String, Object> map, String tableNm) {
		System.out.println(tableNm + "tableName + $$$$");
		selectOneMs("kukgohMs." + tableNm, map);
	}

	public void saveFile(Map<String, Object> map) {
		insert("kukgohMaria.insertFile", map);
	}

	public void kukgohAttachSave(Map<String, Object> map) {
		selectOneMs("kukgohMs.kukgohAttachSave", map);
	}

	// 대분류 코드 호출
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommCodeClassificationMs(Map<String, Object> map) {
		return selectListMs("kukgohMs.getCommCodeClassificationMs", map);
	}

	// 메인 그리드 호출
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getMainGridMs(Map<String, Object> map) {
		return selectListMs("kukgohMs.getMainGridMs", map);
	}

	// 토탈
	public int getMainGridTotalMs(Map<String, Object> map) {
		return (int) selectOneMs("kukgohMs.getMainGridTotalMs", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> saveCustManageMs(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.saveCustManageMs", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAttachFileMs(Map<String, Object> map) {
		return selectListMs("kukgohMs.getAttachFileMs", map);
	}

	public void commCodeSaveMs(Map<String, Object> map) {
		selectOneMs("kukgohMs.commCodeSaveMs", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAttachFile(Map<String, Object> map) {
		return (List<Map<String, Object>>) selectList("kukgohMaria.getAttachFile", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBudgetMainGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.getBudgetMainGrid", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBudgetCdGridPop(Map<String, Object> map) {
		return selectListMs("kukgohMs.getBudgetCdGridPop", map);
	}

	public void saveBgtConfig(Map<String, Object> map) {
		selectOneMs("kukgohMs.saveBgtConfig", map);
	}

	public void saveProjectConfig(Map<String, Object> map) {
		selectOneMs("kukgohMs.saveProjectConfig", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getProjectCdGridPop(Map<String, Object> map) {
		return selectListMs("kukgohMs.getProjectCdGridPop", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getProjectMainGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.getProjectMainGrid", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getErpInfo() {
		return (Map<String, Object>) selectOne("kukgohMaria.getErpInfo");
	}

	public String getErpEmpSeq(Map<String, Object> map) {
		return (String) selectOne("kukgohMaria.getErpEmpSeq", map);
	}

	public String getErpDeptSeq(Map<String, Object> map) {
		return (String) selectOne("kukgohMaria.getErpDeptSeq", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> insertResolutionMainGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.insertResolutionMainGrid", map);
	}

	public void getDocInfo(Map<String, Object> map) {
		selectOne("kukgohMaria.getDocInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getUnSendData(Map<String, Object> map) {
		return selectListMs("kukgohMs.getUnSendData", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSendData(Map<String, Object> map) {
		return selectListMs("kukgohMs.getSendData", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvidenceMs() {
		return selectListMs("kukgohMs.getEvidenceMs");
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCustomerGbMs() {
		return selectListMs("kukgohMs.getCustomerGbMs");
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDepositGbMs() {
		return selectListMs("kukgohMs.getDepositGbMs");
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDepositGbCauseMs() {
		return selectListMs("kukgohMs.getDepositGbCauseMs");
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> requestInvoice(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.requestInvoice", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> execCsvSearch5(Map<String, Object> map) {
		return selectListMs("kukgohMs.execCsvSearch5", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCommDir(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("kukgohMaria.getCommDir", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getRcvEnaraInterfaceId(Map<String, Object> map) {
		return selectList("kukgohMaria.getRcvEnaraInterfaceId", map);
	}

	public void saveLog(Map<String, Object> map) {
		insert("kukgohMaria.saveLog", map);
	}

	public void transactionTest1(Map<String, Object> map) {
		insertMs("kukgohMs.transactionTest1", map);
		//insert("kukgohMaria.transactionTest1", map);
	}

	public void transactionTest2(Map<String, Object> map) {
		//insertMs("kukgohMs.transactionTest2", map);
		insert("kukgohMaria.transactionTest2", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> sendInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.sendInfo", map);
	}

	public Map<String, Object>  cancelSendInfo(Map<String, Object> map) {
		selectOneMs("kukgohMs.cancelSendInfo", map);
		 return map;
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> kukgohInvoiceGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.kukgohInvoiceGrid", map);
	}

	public Map<String, Object> invoiceValidation(Map<String, Object> map) {
		selectListMs("kukgohMs.invoiceValidation", map);
		return map;
	}

	public Map<String, Object> saveCheck(Map<String, Object> map) {
		selectListMs("kukgohMs.saveCheck", map);
		return map;
	}
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> execCsvSearch1(Map<String, Object> map) {
		return selectListMs("kukgohMs.execCsvSearch1", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> execCsvSearch2(Map<String, Object> map) {
		return selectListMs("kukgohMs.execCsvSearch2", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> execCsvSearch3(Map<String, Object> map) {
		return selectListMs("kukgohMs.execCsvSearch3", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> execCsvSearch4(Map<String, Object> map) {
		return selectListMs("kukgohMs.execCsvSearch4", map);
	}

	public void insertAttachFile(Map<String, Object> map) {
		insert("kukgohMaria.insertAttachFile", map);
	}
	public Object getCommFileSeq(Map<String, Object> map) throws Exception {
		return selectOne("kukgohMaria.getCommFileSeq", map);
	}
	public void commFileInfoUpdate(Map<String, Object> map) throws Exception {
		update("kukgohMaria.commFileInfoUpdate", map);
		
	}

	public int deleteFile(Map<String, Object> map) {
		return (int) delete("kukgohMaria.deleteFile", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> kukgohInvoiceInsertGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.kukgohInvoiceInsertGrid", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> kukgohInvoiceInsertGrid2(Map<String, Object> map) {
		return selectListMs("kukgohMs.kukgohInvoiceInsertGrid2", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getInterfaceGrid(Map<String, Object> map) {
		return selectList("kukgohMaria.getInterfaceGrid", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getRcvEnaraInterfaceId2(Map<String, Object> map) {
		return selectList("kukgohMaria.getRcvEnaraInterfaceId2", map);
	}
	public int insertTrnscIdReadStatus(Map<String, Object> map) {
		 return (int)insert("kukgohMaria.insertTrnscIdReadStatus", map);
	}
	public int updateTrnscIdReadStatus(Map<String, Object> map) {
		 return (int)update("kukgohMaria.updateTrnscIdReadStatus", map);
	}
	public int ckeckTrnscIdReadStatus(Map<String, Object> map) {
		 return (int) selectOne("kukgohMaria.ckeckTrnscIdReadStatus", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getUrlInfo() {
		return (Map<String, Object>) selectOne("kukgohMaria.getUrlInfo");
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> fileDown(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("kukgohMaria.fileDown", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> admAccountGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.admAccountGrid", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> admSendGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.admSendGrid", map);
	}

	public String getErpDeptSeq2(Map<String, Object> map) {
		 return (String) selectOne("kukgohMaria.getErpDeptSeq2", map);
	}
	
	// ----------------------------- 새로 시작 ----------------------------------
	
	public void saveAssntInfo(Map<String, Object> map) {
		selectOneMs("kukgohMs.saveAssntInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAsstnGridPop(Map<String, Object> map) {
		return selectListMs("kukgohMs.getAsstnGridPop", map);
	}
	
	public void updateCancelAssntInfo(Map<String, Object> map) throws Exception{
		selectOneMs("kukgohMs.updateCancelAssntInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardList(Map<String, Object> map) {
		return selectListMs("kukgohMs.getCardList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardNoList(Map<String, Object> map) {
		return selectListMs("kukgohMs.getCardNoList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> cancelProjectConfig(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.cancelProjectConfig", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> sendInvoiceMainGrid(Map<String, Object> map) {
		return  selectListMs("kukgohMs.sendInvoiceMainGrid", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> saveSendingInvoice(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.saveSendingInvoice", map);
	}
	
	public void getDocInvoice(Map<String, Object> map) {
		selectOne("kukgohMaria.getDocInvoice", map);
	}
	
	@SuppressWarnings("unchecked")
	public String getErpDeptNo(Map<String, Object> map) {
		return (String) selectOneMs("kukgohMs.getErpDeptNo", map);
	}
	
	public String getOneErpEmpNum(Map<String, Object> map) {
		return (String) selectOne("kukgohMaria.getOneErpEmpNum", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getInvoice(Map<String, Object> map) {
		return selectList("kukgohMaria.getInvoice", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> sendResolutionGrid(Map<String, Object> map) {
		return selectListMs("kukgohMs.sendResolutionGrid", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> sendResolutionGrid2(Map<String, Object> map) {
		return selectListMs("kukgohMs.sendResolutionGrid2", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> submitPageConfirm(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.submitPageConfirm", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> submitPageSending(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.submitPageSending", map);
	}
	
	public void saveKorailCityInfo(Map<String, Object> map) {
		insert("kukgohMaria.saveKorailCityInfo", map);
	}
	
	public void saveKorailNodeInfo(Map<String, Object> map) {
		insert("kukgohMaria.saveKorailNodeInfo", map);
	}
	
	public void saveKorailVehicleKind(Map<String, Object> map) {
		insert("kukgohMaria.saveKorailVehicleKind", map);
	}
	
	public int deleteKorailCityInfo() {
		return (int) delete("kukgohMaria.deleteKorailCityInfo", null);
	}
	
	public int deleteKorailNodeInfo() {
		return (int) delete("kukgohMaria.deleteKorailNodeInfo", null);
	}
	
	public int deleteKorailVehicleKindInfo() {
		return (int) delete("kukgohMaria.deleteKorailVehicleKindInfo", null);
	}
	
	public String getPjtInfo(Map<String, Object> map) {
		return (String) selectOneMs("kukgohMs.getPjtInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> changeAccountType(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.changeAccountType", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDocAttachPath(Map<String, Object> map) {
		return selectList("kukgohMaria.getDocAttachPath", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getDocBankInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("kukgohMaria.getDocBankInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getTradeBojoInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("kukgohMaria.getTradeBojoInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getErpDeptNum(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("kukgohMaria.getErpDeptNum", map);
	}
	
	public String checkValidYN(Map<String, Object> map) {
		return (String) selectOneMs("kukgohMs.checkValidYN", map);
	}
	
	public String checkValidMsg(Map<String, Object> map) {
		return (String) selectOneMs("kukgohMs.checkValidMsg", map);
	}
	
	@SuppressWarnings("unchecked")
	public String checkAttachPDF(Map<String, Object> map) {
		return (String) selectOne("kukgohMaria.checkAttachPDF", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getRestradeInfo(Map<String, Object> map) {
		return  (Map<String, Object>) selectOne("kukgohMaria.getRestradeInfo", map);
	}
	
	public Map<String, Object> getBankcode(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("kukgohMs.getBankcode", map);
	}
	
	public void exceptEnaraDoc(Map<String, Object> map) {
		selectOneMs("kukgohMs.exceptEnaraDoc", map);
	}
	
	public void reloadEnaraExceptDoc(Map<String, Object> map) {
		selectOneMs("kukgohMs.reloadEnaraExceptDoc", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectEnaraExceptList(Map<String, Object> map) {
		return selectListMs("kukgohMs.selectEnaraExceptList", map);
	}
	
}
