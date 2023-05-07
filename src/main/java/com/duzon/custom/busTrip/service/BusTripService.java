package com.duzon.custom.busTrip.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jcraft.jsch.MAC;

public interface BusTripService {
	//직급별 출장여비
	int getDayByDayOverlap(Map<String, Object>map);
	List<Map<String, Object>> getSuccessBIzInfo(Map<String, Object>map);
	List<Map<String, Object>> getSuccessBIzInfo2(Map<String, Object>map);
	List<Map<String, Object>> getDayByDayInfo(Map<String, Object>map);
	List<Map<String, Object>> getPositionList();
	List<Map<String, Object>> getGradeCostList();
	int getGradeCostListTotal();
	int getSuccessBIzInfoCount(Map<String, Object>map);
	int getSuccessBIzInfoCount2(Map<String, Object>map);
	void saveGradeCost(Map<String, Object>map);
	void modGradeCost(Map<String, Object>map);
	void delGradeCost(Map<String, Object>map);

	//관내출장여비
	List<Map<String, Object>> getOilTypeList();
	List<Map<String, Object>> getCarTypeList();
	List<Map<String, Object>> getTimeTypeList();
	
	Map<String, Object> getAreaCost(Map<String, Object>map);
	int getMatchBizInfo(Map<String, Object>map);
	int getMatchBizInfoCity(Map<String, Object>map);
	List<Map<String, Object>> getOrgCode(Map<String, Object>map);
	List<Map<String, Object>> getLastInfoByOutTrip(Map<String, Object>map);
	List<Map<String, Object>> getOilCostList();
	List<Map<String, Object>> getCityCostList(Map<String, Object>map);
	List<Map<String, Object>> getRowdataNow(Map<String, Object>map);
	int getOilCostListTotal();
	int getCityCostListTotal();
	void saveOilCost(Map<String, Object>map);
	void modOilCost(Map<String, Object>map);
	void delOilCost(Map<String, Object>map);
	void saveCityCost(Map<String, Object>map);
	void modCityCost(Map<String, Object>map);
	void delCityCost(Map<String, Object>map);
	
	//관내출장
	List<Map<String, Object>> getonNaraBTList(Map<String, Object> map);
	int getonNaraBTListTotal(Map<String, Object> map);
	List<Map<String, Object>> getonNaraBTListPaging(Map<String, Object> map);
	int getonNaraBTListPagingTotal(Map<String, Object> map);
	List<Map<String, Object>> getUserInfo(Map<String, Object> map);
	List<Map<String, Object>> getFilePkVer2(Map<String, Object> map);
	Map<String, Object> getFilePk(Map<String, Object> map);
	Map<String, Object> getAttachInfoByOne(Map<String, Object> map);
	Map<String, Object> addUserInfo(Map<String, Object> map);
	Map<String, Object> getCityCost(Map<String, Object> map);
	List<Map<String, Object>> getClientInfo(Map<String, Object> map);
	void bizInsertOutSubCard(Map<String, Object> map);
	void insertResTrade(Map<String, Object> map);
	void deleteResTrade(Map<String, Object> map);
	void deleteOutSubDayData(Map<String, Object> map);
	void insertBizCommon(Map<String, Object> map);
	void insertBizSub(Map<String, Object> map);
	
	int bizCommonExistCheck(Map<String, Object> map);
	int bizSubExistCheck(Map<String, Object> map);
	void upDateBizCommon(Map<String, Object>map);
	void changeStatus(Map<String, Object>map);
	void upDateBizSub(Map<String, Object>map);
	void updateLastcommon(Map<String, Object>map);
	void updateLastOut(Map<String, Object>map);
	
	List<Map<String, Object>> getCardExistYn(Map<String, Object> map);
	List<Map<String, Object>> getAllCardInfoByResDocSeq(Map<String, Object> map);
	List<Map<String, Object>> getCardsInfo(Map<String, Object> map);
	List<Map<String, Object>> getOutBtRow(Map<String, Object> map);
	List<Map<String, Object>> getBtRowData(Map<String, Object> map);
	List<Map<String, Object>> getBtRowData2(Map<String, Object> map);
	List<Map<String, Object>> getTraficWay();
	void UgaBatch(List<Map<String, Object>>list);
	List<Map<String, Object>> getKorailCity();
	List<Map<String, Object>> getToolTipFile(Map<String, Object>map);
	List<Map<String, Object>> getKorailVehicle();
	List<Map<String, Object>> getBizTemp(Map<String, Object>map);
	List<Map<String, Object>> getKorailNode(Map<String, Object>map);
	List<Map<String, Object>> getCardCostBySubSeq(Map<String, Object>map);
	List<Map<String, Object>> getDayTransPortDetail(Map<String, Object>map);
	List<Map<String, Object>> getCardCostByattachId(Map<String, Object>map);
	List<Map<String, Object>> getAllBizData(Map<String, Object>map);
	Map<String, Object> getWorkFeeList(Map<String, Object>map);
	List<Map<String, Object>> getAllBizDataWithin(Map<String, Object>map);
	List<Map<String, Object>> getAllBizDataOutside(Map<String, Object>map);
	int getAllBizDataTotal(Map<String, Object>map);
	List<Map<String, Object>> getAllBizDataOut(Map<String, Object>map);
	List<Map<String, Object>> getErpEmpNumByDept(Map<String, Object>map);
	int getAllBizDataOutTotal(Map<String, Object>map);
	List<Map<String, Object>> getCardCostBySubSeqDetail(Map<String, Object>map);
	List<Map<String, Object>> getOpnetInfo(Map<String, Object>map);
	Map<String, Object> getFileUserAndBizDay(Map<String, Object>map);
	Map<String, Object> getFileUserAndBizDay2(Map<String, Object>map);
	Map<String, Object> getFileUserAndBizDay3(Map<String, Object>map);
	Map<String, Object> getFileUserAndBizDay4(Map<String, Object>map);
	Map<String, Object> getUga(Map<String, Object>map);
	Map<String, Object> getGradeCost(Map<String, Object>map);
	Map<String, Object> getOilTypeCost(Map<String, Object>map);
	Map<String, Object> selectOutBizInfo(Map<String, Object>map);
	void bizInsertBody(Map<String, Object>map);
	void insertBizTemp(Map<String, Object>map);
	void updateTradeSeq(Map<String, Object>map);
	void bizInsertFoot(Map<String, Object>map);
	void InsertPjtAndBudget(Map<String, Object>map);
	
	void deleteRowData(Map<String, Object>map);
	void beforeDeleteCommon(Map<String, Object>map);
	void beforeDeleteCity(Map<String, Object>map);
	void deleteOutSub(Map<String, Object>map);
	
	Map<String, Object> getMsDataOne(Map<String, Object> map);
	List<Map<String, Object>> getMsUpMooList(Map<String, Object> map);
	Map<String, Object> getDocInfobyISUDTAndSQ(Map<String, Object> map);
	
	
	Map<String, Object> getCardinfoByGisu(Map<String, Object>map);
	
	List<Map<String, Object>> getalm(Map<String, Object>map);
	List<Map<String, Object>> getalm2(Map<String, Object>map);
	
	
	void setAlm(Map<String, Object>map);
	void addTransportTable(Map<String, Object>map);
	
	
	public void excelDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response);
	
	
	
	//시외집계표 관련
	List<Map<String, Object>> getBizTripDataByResSeq(Map<String, Object>map);
	List<Map<String, Object>> getCardDataByOutSubSeq(Map<String, Object>map);
	List<Map<String, Object>> getTransportDataByOutSubSeq(Map<String, Object>map);
	List<Map<String, Object>> getCardCostBySort(Map<String, Object>map);

    List<Map<String, Object>> getBustripInResData(Map<String, Object> map);

    Object getBustripInResDataCnt(Map<String, Object> map);

    List<Map<String, Object>> getBustripOutResData(Map<String, Object> map);

    Object getBustripOutResDataCnt(Map<String, Object> map);

}
