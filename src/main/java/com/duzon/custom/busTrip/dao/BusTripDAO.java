package com.duzon.custom.busTrip.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class BusTripDAO extends AbstractDAO {
	
	// 직급별 출장여비 
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPositionList (){
		return selectList("busTrip.getPositionList");
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSuccessBIzInfo (Map<String, Object>map){
		return selectList("busTrip.getSuccessBIzInfo",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSuccessBIzInfo2 (Map<String, Object>map){
		return selectList("busTrip.getSuccessBIzInfo2",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getMsDataOne (Map<String, Object>map){
		return (Map<String, Object>) selectOneMs("busTrip.getMsDataOne",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getDocInfobyISUDTAndSQ (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getDocInfobyISUDTAndSQ",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardCostBySubSeq (Map<String, Object>map){
		return selectList("busTrip.getCardCostBySubSeq",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDayTransPortDetail (Map<String, Object>map){
		return selectList("busTrip.getDayTransPortDetail",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardCostByattachId (Map<String, Object>map){
		return selectList("busTrip.getCardCostByattachId",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardCostBySubSeqDetail (Map<String, Object>map){
		return selectList("busTrip.getCardCostBySubSeqDetail",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getFileUserAndBizDay (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getFileUserAndBizDay",map);
	}
	@SuppressWarnings("unchecked")
	public int getMatchBizInfo (Map<String, Object>map){
		return (int)selectOne("busTrip.getMatchBizInfo",map);
	}
	@SuppressWarnings("unchecked")
	public int getSuccessBIzInfoCount (Map<String, Object>map){
		return (int)selectOne("busTrip.getSuccessBIzInfoCount",map);
	}
	@SuppressWarnings("unchecked")
	public int getSuccessBIzInfoCount2 (Map<String, Object>map){
		return (int)selectOne("busTrip.getSuccessBIzInfoCount2",map);
	}
	@SuppressWarnings("unchecked")
	public int getMatchBizInfoCity (Map<String, Object>map){
		return (int)selectOne("busTrip.getMatchBizInfoCity",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getFileUserAndBizDay2 (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getFileUserAndBizDay2",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getFileUserAndBizDay3 (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getFileUserAndBizDay3",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getFileUserAndBizDay4 (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getFileUserAndBizDay4",map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getErpEmpNumByDept(Map<String, Object>map){
		return selectList("busTrip.getErpEmpNumByDept",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDayByDayInfo(Map<String, Object>map){
		return selectList("busTrip.getDayByDayInfo",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getLastInfoByOutTrip(Map<String, Object>map){
		return selectList("busTrip.getLastInfoByOutTrip",map);
	}
	public int getDayByDayOverlap(Map<String, Object>map){
		return (int) selectOne("busTrip.getDayByDayOverlap",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getGradeCostList(){
		return selectList("busTrip.getGradeCostList");
	}
	public int getGradeCostListTotal(){
		return (int) selectOne("busTrip.getGradeCostListTotal");
	}
	
	public void addTransportTable(Map<String, Object>map) {
		insert("busTrip.addTransportTable", map);
	}
	public void saveGradeCost(Map<String, Object>map) {
		insert("busTrip.saveGradeCost", map);
	}
	public void setAlm(Map<String, Object>map) {
		insertOr3("busTrip.setAlm", map);
	}
	public void modGradeCost(Map<String, Object>map) {
		update("busTrip.modGradeCost", map);
	}
	public void changeStatus(Map<String, Object>map) {
		update("busTrip.changeStatus", map);
	}
	public void updateTradeSeq(Map<String, Object>map) {
		update("busTrip.updateTradeSeq", map);
	}
	public void delGradeCost(Map<String, Object>map) {
		update("busTrip.delGradeCost", map);
	}
	
	public void deleteOutSubDayData(Map<String, Object>map){
		delete("busTrip.deleteOutSubDayData", map);
	}
	public void beforeDeleteCommon(Map<String, Object>map){
		delete("busTrip.beforeDeleteCommon", map);
	}
	public void beforeDeleteCity(Map<String, Object>map){
		delete("busTrip.beforeDeleteCity", map);
	}
	public void deleteRowDataA(Map<String, Object>map){
		delete("busTrip.deleteRowDataA", map);
	}
	public void deleteOutSub(Map<String, Object>map){
		delete("busTrip.deleteOutSub", map);
	}
	public void deleteRowDataB(Map<String, Object>map){
		delete("busTrip.deleteRowDataB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getToolTipFile(Map<String, Object>map){
		 return selectList("busTrip.getToolTipFile",map);
	}
	
	// 관내출장여비 
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOilTypeList (){
		return selectList("busTrip.getOilTypeList");
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCarTypeList (){
		return selectList("busTrip.getCarTypeList");
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getTimeTypeList (){
		return selectList("busTrip.getTimeTypeList");
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOilCostList(){
		return selectList("busTrip.getOilCostList");
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCityCostList(Map<String, Object>map){
		return selectList("busTrip.getCityCostList",map);
	}
	public int getOilCostListTotal(){
		return (int) selectOne("busTrip.getOilCostListTotal");
	}
	public int getCityCostListTotal(){
		return (int) selectOne("busTrip.getCityCostListTotal");
	}
	public void saveOilCost(Map<String, Object>map) {
		insert("busTrip.saveOilCost", map);
	}
	public void saveCityCost(Map<String, Object>map) {
		insert("busTrip.saveCityCost", map);
	}
	public void modOilCost(Map<String, Object>map) {
		update("busTrip.modOilCost", map);
	}
	public void modCityCost(Map<String, Object>map) {
		update("busTrip.modCityCost", map);
	}
	public void delOilCost(Map<String, Object>map) {
		update("busTrip.delOilCost", map);
	}
	public void delCityCost(Map<String, Object>map) {
		update("busTrip.delCityCost", map);
	}
	
	// 관내출장
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getonNaraBTList(Map<String, Object> map){
		return selectListOr2("busTrip.getonNaraBTList",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getonNaraBTListPaging(Map<String, Object> map){
		return selectListOr2("busTrip.getonNaraBTListPaging",map);
	}
	public int getonNaraBTListTotal(Map<String, Object> map){
		return (int) selectOneOr2("busTrip.getonNaraBTListTotal",map);
	}
	public int getonNaraBTListPagingTotal(Map<String, Object> map){
		return (int) selectOneOr2("busTrip.getonNaraBTListPagingTotal",map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> addUserInfo (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.addUserInfo",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAttachInfoByOne (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getAttachInfoByOne",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getFilePk (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getFilePk",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getFilePkVer2 (Map<String, Object>map){
		return selectList("busTrip.getFilePkVer2",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getUserInfo (Map<String, Object>map){
		return selectList("busTrip.getUserInfo",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCityCost (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getCityCost",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getClientInfo (Map<String, Object>map){
		return selectListMs("busTrip.getClientInfo",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getMsUpMooList (Map<String, Object>map){
		return selectListMs("busTrip.getMsUpMooList",map);
	}
	public void insertResTrade (Map<String, Object>map){
		insert("busTrip.insertResTrade",map);
	}
	public void deleteResTrade (Map<String, Object>map){
		delete("busTrip.deleteResTrade",map);
	}
	
	public void insertBizCommon (Map<String, Object>map){
		insert("busTrip.insertBizCommon",map);
	}
	public void insertBizSub (Map<String, Object>map){
		insert("busTrip.insertBizSub",map);
	}
	
	public int bizCommonExistCheck(Map<String, Object>map){
		
		return (int) selectOne("busTrip.bizCommonExistCheck", map);
	}
	public int bizSubExistCheck(Map<String, Object>map){
		
		return (int) selectOne("busTrip.bizSubExistCheck", map);
	}
	
	public void upDateBizCommon(Map<String, Object>map){
		update("busTrip.upDateBizCommon", map);
	}
	public void upDateBizSub(Map<String, Object>map){
		update("busTrip.upDateBizSub", map);
	}
	public void updateLastcommon(Map<String, Object>map){
		update("busTrip.updateLastcommon", map);
	}
	public void updateLastOut(Map<String, Object>map){
		update("busTrip.updateLastOut", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getRowdataNow(Map<String, Object> map){
		return selectList("busTrip.getRowdataNow", map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCardinfoByGisu(Map<String, Object> map){
		return (Map<String, Object>) selectOne("busTrip.getCardinfoByGisu", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardExistYn(Map<String, Object> map){
		return selectList("busTrip.getCardExistYn", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllCardInfoByResDocSeq(Map<String, Object> map){
		return selectList("busTrip.getAllCardInfoByResDocSeq", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardsInfo(Map<String, Object> map){
		return selectList("busTrip.getCardsInfo", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOutBtRow(Map<String, Object> map){
		return selectList("busTrip.getOutBtRow", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBtRowData(Map<String, Object> map){
		return selectList("busTrip.getBtRowData", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBtRowData2(Map<String, Object> map){
		return selectList("busTrip.getBtRowData2", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getTraficWay (){
		return selectList("busTrip.getTraficWay");
	}
	
	public void UgaBatch (List<Map<String, Object>> list){
		insert("busTrip.UgaBatch", list);
	}
	public void insertBizTemp (Map<String, Object >map){
		insert("busTrip.insertBizTemp", map);
	}
	public int getAllBizDataOutTotal (Map<String, Object >map){
		
		return (int) selectOne("busTrip.getAllBizDataOutTotal", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllBizDataOut (Map<String, Object>map){
		return selectList("busTrip.getAllBizDataOut", map);
	}
	public int getAllBizDataTotal (Map<String, Object >map){
		
		return (int) selectOne("busTrip.getAllBizDataTotal", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getWorkFeeList (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getWorkFeeList", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllBizData (Map<String, Object>map){
		return selectList("busTrip.getAllBizData", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOpnetInfo (Map<String, Object>map){
		return selectList("busTrip.getOpnetInfo", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllBizDataWithin (Map<String, Object>map){
		return selectList("busTrip.getAllBizDataWithin", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllBizDataOutside (Map<String, Object>map){
		return selectList("busTrip.getAllBizDataOutside", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBizTemp (Map<String, Object>map){
		return selectList("busTrip.getBizTemp", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getKorailNode (Map<String, Object>map){
		return selectList("busTrip.getKorailNode", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getKorailVehicle (){
		return selectList("busTrip.getKorailVehicle");
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getKorailCity (){
		return selectList("busTrip.getKorailCity");
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getUga (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getUga",map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGradeCost (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getGradeCost",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAreaCost (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getAreaCost",map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getOilTypeCost (Map<String, Object>map){
		return (Map<String, Object>) selectOne("busTrip.getOilTypeCost",map);
	}
	public void bizInsertOutSubCard (Map<String, Object>map){
		insert("busTrip.bizInsertOutSubCard",map);
	}
	public void bizInsertBody (Map<String, Object>map){
		insert("busTrip.bizInsertBody",map);
	}
	public void bizInsertFoot (Map<String, Object>map){
		insert("busTrip.bizInsertFoot",map);
	}
	public void InsertPjtAndBudget (Map<String, Object>map){
		update("busTrip.InsertPjtAndBudget",map);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object>  selectOutBizInfo (Map<String, Object>map){
		
		return (Map<String, Object>) selectOne("busTrip.selectOutBizInfo",map);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOrgCode (Map<String, Object> map){
		
		return selectListOr2("busTrip.getOrgCode",map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getalm(Map<String, Object>map) {
		
		return selectListOr3("busTrip.getalm", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getalm2(Map<String, Object>map) {
		
		return selectListOr3("busTrip.getalm2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBizTripDataByResSeq (Map<String, Object>map){
		return selectList("busTrip.getBizTripDataByResSeq",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardDataByOutSubSeq (Map<String, Object>map){
		return selectList("busTrip.getCardDataByOutSubSeq",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getTransportDataByOutSubSeq (Map<String, Object>map){
		return selectList("busTrip.getTransportDataByOutSubSeq",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCardCostBySort (Map<String, Object>map){
		return selectList("busTrip.getCardCostBySort",map);
	}
}
