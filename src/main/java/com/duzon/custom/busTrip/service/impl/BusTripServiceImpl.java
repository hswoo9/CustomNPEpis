package com.duzon.custom.busTrip.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.annotations.Insert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import com.duzon.custom.bsrp.dao.BsrpDAO;
import com.duzon.custom.bsrp.service.BsrpService;
import com.duzon.custom.busTrip.dao.BusTripDAO;
import com.duzon.custom.busTrip.service.BusTripService;
import com.google.gson.Gson;

import ac.g20.ex.dao.AcG20ExGwDAO;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;

@Service
public class BusTripServiceImpl implements BusTripService {

    @Autowired
    private BusTripDAO busTripDAO;

    @Override
    public List<Map<String, Object>> getPositionList() {

        return  busTripDAO.getPositionList();
    }


    @Override
    public List<Map<String, Object>> getGradeCostList() {
        return busTripDAO.getGradeCostList();
    }

    @Override
    public int getGradeCostListTotal() {
        return busTripDAO.getGradeCostListTotal();
    }


    @Override
    public void saveGradeCost(Map<String, Object> map) {
        busTripDAO.saveGradeCost(map);
    }


    @Override
    public void modGradeCost(Map<String, Object> map) {
        busTripDAO.modGradeCost(map);
    }


    @Override
    public void delGradeCost(Map<String, Object> map) {
        busTripDAO.delGradeCost(map);
    }


    // 관내출장 여비
    @Override
    public List<Map<String, Object>> getOilTypeList() {
        return busTripDAO.getOilTypeList();
    }


    @Override
    public List<Map<String, Object>> getCarTypeList() {
        return busTripDAO.getCarTypeList();
    }


    @Override
    public List<Map<String, Object>> getTimeTypeList() {
        return busTripDAO.getTimeTypeList();
    }


    @Override
    public List<Map<String, Object>> getOilCostList() {

        return busTripDAO.getOilCostList();
    }


    @Override
    public List<Map<String, Object>> getCityCostList(Map<String, Object>map) {

        return busTripDAO.getCityCostList(map);
    }

    @Override
    public List<Map<String, Object>> getUserInfo(Map<String, Object> map) {
        return busTripDAO.getUserInfo(map);
    }


    @Override
    public int getOilCostListTotal() {

        return busTripDAO.getOilCostListTotal();

    }


    @Override
    public int getCityCostListTotal() {

        return busTripDAO.getCityCostListTotal();
    }


    @Override
    public void saveOilCost(Map<String, Object> map) {

        busTripDAO.saveOilCost(map);

    }


    @Override
    public void modOilCost(Map<String, Object> map) {

        busTripDAO.modOilCost(map);
    }


    @Override
    public void delOilCost(Map<String, Object> map) {

        busTripDAO.delOilCost(map);
    }


    @Override
    public void saveCityCost(Map<String, Object> map) {

        busTripDAO.saveCityCost(map);

    }


    @Override
    public void modCityCost(Map<String, Object> map) {

        busTripDAO.modCityCost(map);
    }


    @Override
    public void delCityCost(Map<String, Object> map) {

        busTripDAO.delCityCost(map);
    }

    @Override
    public List<Map<String, Object>> getonNaraBTList(Map<String, Object> map) {
        return busTripDAO.getonNaraBTList(map);
    }

    @Override
    public int getonNaraBTListTotal(Map<String, Object> map) {
        return busTripDAO.getonNaraBTListTotal(map);
    }

    public Map<String, Object> addUserInfo(Map<String, Object>map){
        return busTripDAO.addUserInfo(map);
    }

    public Map<String, Object> getCityCost(Map<String, Object>map){
        return busTripDAO.getCityCost(map);
    }

    @Override
    public List<Map<String, Object>> getClientInfo(Map<String, Object> map) {

        map.put("EMP_NO_JOIN", String.valueOf( map.get("EMP_NO_JOIN")).split(","));
        return busTripDAO.getClientInfo(map);
    }

    @Override
    public void bizInsertOutSubCard(Map<String, Object> map) {

        busTripDAO.bizInsertOutSubCard(map);
    }

    @Override
    public void addTransportTable(Map<String, Object> map) {

        busTripDAO.addTransportTable(map);
    }

    @Override
    public void insertResTrade(Map<String, Object> map) {

        busTripDAO.insertResTrade(map);
    }

    @Override
    public void deleteResTrade(Map<String, Object> map) {

        busTripDAO.deleteResTrade(map);
    }

    @Override
    public void insertBizTemp(Map<String, Object> map) {
        busTripDAO.insertBizTemp(map);
    }

    @Override
    public void insertBizCommon(Map<String, Object> map) {
        busTripDAO.insertBizCommon(map);

    }

    @Override
    public void insertBizSub(Map<String, Object> map) {
        busTripDAO.insertBizSub(map);

    }

    @Override
    public int bizCommonExistCheck(Map<String, Object> map) {
        return busTripDAO.bizCommonExistCheck(map);

    }

    @Override
    public int bizSubExistCheck(Map<String, Object> map) {
        return busTripDAO.bizSubExistCheck(map);

    }

    @Override
    public void upDateBizCommon(Map<String, Object> map) {
        busTripDAO.upDateBizCommon(map);

    }

    @Override
    public void upDateBizSub(Map<String, Object> map) {
        busTripDAO.upDateBizSub(map);

    }


    @Override
    public List<Map<String, Object>> getBtRowData(Map<String, Object> map) {
        return busTripDAO.getBtRowData(map);
    }

    @Override
    public List<Map<String, Object>> getBtRowData2(Map<String, Object> map) {
        return busTripDAO.getBtRowData2(map);
    }


    @Override
    public List<Map<String, Object>> getTraficWay() {

        return busTripDAO.getTraficWay();
    }

    @Override
    public void UgaBatch(List<Map<String, Object>> list) {
        busTripDAO.UgaBatch(list);
    }


    @Override
    public List<Map<String, Object>> getKorailCity() {
        return busTripDAO.getKorailCity();
    }


    @Override
    public List<Map<String, Object>> getKorailVehicle() {
        return busTripDAO.getKorailVehicle();
    }


    @Override
    public List<Map<String, Object>> getKorailNode(Map<String, Object> map) {
        return busTripDAO.getKorailNode(map);
    }

    @Override
    public Map<String, Object> getUga(Map<String, Object> map) {
        return busTripDAO.getUga(map);
    }

    @Override
    public Map<String, Object> getGradeCost(Map<String, Object> map) {
        return busTripDAO.getGradeCost(map);
    }

    @Override
    public Map<String, Object> getOilTypeCost(Map<String, Object> map) {
        return busTripDAO.getOilTypeCost(map);
    }

    @Override
    public void bizInsertBody(Map<String, Object> map) {
        busTripDAO.bizInsertBody(map);
    }

    @Override
    public Map<String, Object> selectOutBizInfo(Map<String, Object> map) {
        return busTripDAO.selectOutBizInfo(map);
    }


    @Override
    public void updateLastcommon(Map<String, Object> map) {
        busTripDAO.updateLastcommon(map);

    }


    @Override
    public void updateLastOut(Map<String, Object> map) {
        busTripDAO.updateLastOut(map);

    }

    @Override
    public void updateTradeSeq(Map<String, Object> map) {
        busTripDAO.updateTradeSeq(map);
    }

    @Override
    public void deleteRowData(Map<String, Object> map) {
        busTripDAO.deleteRowDataA(map);
        busTripDAO.deleteRowDataB(map);
    }

    @Override
    public List<Map<String, Object>> getRowdataNow(Map<String, Object> map) {
        return busTripDAO.getRowdataNow(map);
    }

    @Override
    public List<Map<String, Object>> getOrgCode(Map<String, Object> map) {

        return busTripDAO.getOrgCode(map);
    }

    @Override
    public Map<String, Object> getAreaCost(Map<String, Object> map) {

        return busTripDAO.getAreaCost(map);
    }


    @Override
    public void bizInsertFoot(Map<String, Object> map) {
        busTripDAO.bizInsertFoot(map);

    }

    @Override
    public void InsertPjtAndBudget(Map<String, Object> map) {
        busTripDAO.InsertPjtAndBudget(map);

    }


    @Override
    public List<Map<String, Object>> getDayByDayInfo(Map<String, Object>map) {


        return busTripDAO.getDayByDayInfo(map);


    }


    @Override
    public Map<String, Object> getFilePk(Map<String, Object> map) {
        return busTripDAO.getFilePk(map);
    }

    @Override
    public Map<String, Object> getAttachInfoByOne(Map<String, Object> map) {
        return busTripDAO.getAttachInfoByOne(map);
    }


    @Override
    public int getDayByDayOverlap(Map<String, Object> map) {
        return busTripDAO.getDayByDayOverlap(map);
    }


    @Override
    public void deleteOutSub(Map<String, Object> map) {
        busTripDAO.deleteOutSub(map);

    }

    @Override
    public List<Map<String, Object>> getToolTipFile(Map<String, Object> map) {
        return busTripDAO.getToolTipFile(map);
    }


    @Override
    public List<Map<String, Object>> getLastInfoByOutTrip(Map<String, Object> map) {
        return busTripDAO.getLastInfoByOutTrip(map);
    }


    @Override
    public List<Map<String, Object>> getCardCostBySubSeq(Map<String, Object> map) {
        return busTripDAO.getCardCostBySubSeq(map);
    }

    @Override
    public List<Map<String, Object>> getDayTransPortDetail(Map<String, Object> map) {
        return busTripDAO.getDayTransPortDetail(map);
    }

    @Override
    public List<Map<String, Object>> getCardCostByattachId(Map<String, Object> map) {
        return busTripDAO.getCardCostByattachId(map);
    }

    @Override
    public List<Map<String, Object>> getCardCostBySubSeqDetail(Map<String, Object> map) {
        return busTripDAO.getCardCostBySubSeqDetail(map);
    }

    @Override
    public List<Map<String, Object>> getOutBtRow(Map<String, Object> map) {
        return busTripDAO.getOutBtRow(map);
    }

    @Override
    public void deleteOutSubDayData(Map<String, Object> map) {
        busTripDAO.deleteOutSubDayData(map);
    }

    @Override
    public List<Map<String, Object>> getCardExistYn(Map<String, Object> map) {
        return busTripDAO.getCardExistYn(map);
    }

    @Override
    public List<Map<String, Object>> getCardsInfo(Map<String, Object> map) {
        return busTripDAO.getCardsInfo(map);
    }

    @Override
    public List<Map<String, Object>> getBizTemp(Map<String, Object> map) {
        return busTripDAO.getBizTemp(map);
    }

    @Override
    public List<Map<String, Object>> getAllBizData(Map<String, Object> map) {

//		busTripDAO.getonNaraBTList(map);
        return busTripDAO.getAllBizData(map);
    }

    @Override
    public List<Map<String, Object>> getAllBizDataWithin(Map<String, Object> map) {

        return busTripDAO.getAllBizDataWithin(map);
    }

    @Override
    public int getAllBizDataTotal(Map<String, Object> map) {
        return busTripDAO.getAllBizDataTotal(map);
    }

    @Override
    public List<Map<String, Object>> getAllBizDataOut(Map<String, Object> map) {
        // TODO Auto-generated method stub
        return busTripDAO.getAllBizDataOut(map);
    }

    @Override
    public int getAllBizDataOutTotal(Map<String, Object> map) {
        // TODO Auto-generated method stub
        return busTripDAO.getAllBizDataOutTotal(map);
    }

    @Override
    public List<Map<String, Object>> getonNaraBTListPaging(Map<String, Object> map) {
        return busTripDAO.getonNaraBTListPaging(map);
    }

    @Override
    public int getonNaraBTListPagingTotal(Map<String, Object> map) {
        return busTripDAO.getonNaraBTListPagingTotal(map);
    }

    @Override
    public List<Map<String, Object>> getAllCardInfoByResDocSeq(Map<String, Object> map) {
        return busTripDAO.getAllCardInfoByResDocSeq(map);
    }

    @Override
    public Map<String, Object> getFileUserAndBizDay(Map<String, Object> map) {
        return busTripDAO.getFileUserAndBizDay(map);
    }

    @Override
    public Map<String, Object> getFileUserAndBizDay2(Map<String, Object> map) {
        return busTripDAO.getFileUserAndBizDay2(map);
    }

    @Override
    public Map<String, Object> getFileUserAndBizDay3(Map<String, Object> map) {
        return busTripDAO.getFileUserAndBizDay3(map);
    }

    @Override
    public Map<String, Object> getFileUserAndBizDay4(Map<String, Object> map) {
        return busTripDAO.getFileUserAndBizDay4(map);
    }

    @Override
    public int getMatchBizInfo(Map<String, Object> map) {
        return busTripDAO.getMatchBizInfo(map);
    }

    @Override
    public int getMatchBizInfoCity(Map<String, Object> map) {
        return busTripDAO.getMatchBizInfoCity(map);
    }

    @Override
    public List<Map<String, Object>> getErpEmpNumByDept(Map<String, Object> map) {
        return busTripDAO.getErpEmpNumByDept(map);
    }

    @Override
    public List<Map<String, Object>> getFilePkVer2(Map<String, Object> map) {
        return busTripDAO.getFilePkVer2(map);
    }

    @Override
    public List<Map<String, Object>> getSuccessBIzInfo(Map<String, Object> map) {
        return busTripDAO.getSuccessBIzInfo(map);
    }

    @Override
    public List<Map<String, Object>> getSuccessBIzInfo2(Map<String, Object> map) {
        return busTripDAO.getSuccessBIzInfo2(map);
    }

    @Override
    public int getSuccessBIzInfoCount(Map<String, Object> map) {
        return busTripDAO.getSuccessBIzInfoCount(map);
    }

    @Override
    public int getSuccessBIzInfoCount2(Map<String, Object> map) {
        return busTripDAO.getSuccessBIzInfoCount2(map);
    }

    @Override
    public void changeStatus(Map<String, Object> map) {
        busTripDAO.changeStatus(map);

    }


    @Override
    public Map<String, Object> getMsDataOne(Map<String, Object> map) {
        return busTripDAO.getMsDataOne(map);
    }

    @Override
    public Map<String, Object> getDocInfobyISUDTAndSQ(Map<String, Object> map) {
        return busTripDAO.getDocInfobyISUDTAndSQ(map);
    }

    @Override
    public List<Map<String, Object>> getAllBizDataOutside(Map<String, Object> map) {
        return busTripDAO.getAllBizDataOutside(map);
    }

    @Override
    public void beforeDeleteCity(Map<String, Object> map) {
        busTripDAO.beforeDeleteCity(map);
    }

    @Override
    public void beforeDeleteCommon(Map<String, Object> map) {
        busTripDAO.beforeDeleteCommon(map);
    }

    @Override
    public Map<String, Object> getWorkFeeList(Map<String, Object> map) {
        return busTripDAO.getWorkFeeList(map);
    }

    @Override
    public List<Map<String, Object>> getalm(Map<String, Object> map) {
        return busTripDAO.getalm(map);
    }

    @Override
    public List<Map<String, Object>> getalm2(Map<String, Object> map) {
        return busTripDAO.getalm2(map);
    }

    @Override
    public void setAlm(Map<String, Object> map) {
        busTripDAO.setAlm(map);
    }

    @Override
    public List<Map<String, Object>> getMsUpMooList(Map<String, Object> map) {
        return busTripDAO.getMsUpMooList(map);
    }

    @Override
    public Map<String, Object> getCardinfoByGisu(Map<String, Object> map) {
        return busTripDAO.getCardinfoByGisu(map);
    }

    @Override
    public List<Map<String, Object>> getOpnetInfo(Map<String, Object> map) {
        return busTripDAO.getOpnetInfo(map);
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

    // 시외출장 집계표 관련
    @Override
    public List<Map<String, Object>> getBizTripDataByResSeq(Map<String, Object> map) {
        return busTripDAO.getBizTripDataByResSeq(map);
    }

    @Override
    public List<Map<String, Object>> getCardDataByOutSubSeq(Map<String, Object> map) {
        return busTripDAO.getCardDataByOutSubSeq(map);
    }

    @Override
    public List<Map<String, Object>> getTransportDataByOutSubSeq(Map<String, Object> map) {
        return busTripDAO.getTransportDataByOutSubSeq(map);
    }

    @Override
    public List<Map<String, Object>> getCardCostBySort(Map<String, Object> map) {
        return busTripDAO.getCardCostBySort(map);
    }

}

