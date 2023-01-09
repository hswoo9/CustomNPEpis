package com.duzon.custom.bsrp.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.bsrp.dao.BsrpDAO;
import com.duzon.custom.bsrp.service.BsrpService;
import com.google.gson.Gson;

import ac.g20.ex.dao.AcG20ExGwDAO;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;

@Service
public class BsrpServiceImpl implements BsrpService {
	
	@Autowired
	private BsrpDAO bsrpDAO;
	
	@Resource ( name = "AcG20ExGwDAO" )
	private AcG20ExGwDAO acG20ExGwDAO;

	@Override
	public Map<String, Object> bsrpAdminListSerch(Map<String, Object> map) {

		map.put("list", bsrpDAO.bsrpAdminListSerch(map)); //리스트
		map.put("totalCount", bsrpDAO.bsrpAdminListSerchTotal(map)); //토탈
		
		return map;
	}


	@Override
	public void bsrpAdminSave(Map<String, Object> map) {
		
		if(StringUtils.isEmpty((String) map.get("ba_seq"))) {
			bsrpDAO.bsrpAdminSave(map);;
		}else{
			bsrpDAO.bsrpAdminUpdate(map);;
		}
	}


	@Override
	public void bsrpAdminDel(Map<String, Object> map) {
		bsrpDAO.bsrpAdminDel(map);;
	}


	@Override
	public Map<String, Object> getFareListSearch(Map<String, Object> map) {
		
		map.put("list", bsrpDAO.bsrpAdminListSerch(map)); //리스트
		
		return map;
	}


	@Override
	public void whthrcTrvctSave(Map<String, Object> map) {
		
		if( StringUtils.isEmpty((String) map.get("bs_seq")) ){
			//등록
			bsrpDAO.whthrcTrvctSave(map);
			
			
		}else{
			//수정
			bsrpDAO.whthrcTrvctUpdate(map);
			
		}
		
		
	}

	@Override
	public Map<String, Object> whthrcTrvctListSerch(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", bsrpDAO.whthrcTrvctListSerch(map)); //리스트
		result.put("totalCount", bsrpDAO.whthrcTrvctListSerchTotal(map)); //토탈
		
		return result;
	}


	@Override
	public void bsrpAdminPositionSave(Map<String, Object> map) {
		
		if(StringUtils.isEmpty((String) map.get("bspd_seq"))){
			bsrpDAO.bsrpAdminPositionSave(map);
			
		}else{
			bsrpDAO.bsrpAdminPositionUpdate(map);
			
			//수정일 경우 직급테이블 삭제후 다시 등록
			bsrpDAO.positionDel(map);
		}
		
		//직급을 등록
		String position = (String) map.get("position_seq");
		String positionList[] = position.split(",");
		
		for (int i = 0; i < positionList.length; i++) {
			map.put("dp_seq", positionList[i]);
			
			bsrpDAO.positionSave(map);
		} 

	}


	@Override
	public Map<String, Object> bsrpAdminPositionListSerch(Map<String, Object> map) {
		
		map.put("list", bsrpDAO.bsrpAdminPositionListSerch(map)); //리스트

		return map;
	}


	@Override
	public void bsrpAdminPositionDel(Map<String, Object> map) {
		bsrpDAO.bsrpAdminPositionDel1(map); //메인
		bsrpDAO.bsrpAdminPositionDel2(map); //서브
	}


	@Override
	public void whthrcTrvctApp(Map<String, Object> map) {
		bsrpDAO.whthrcTrvctApp(map); //승인
	}


	@Override
	public void whthrcTrvctAppCancel(Map<String, Object> map) {
		bsrpDAO.whthrcTrvctAppCancel(map); //승인취소
	}


	@Override
	public void whthrcTrvctCancel(Map<String, Object> map) {
		bsrpDAO.whthrcTrvctCancel(map); 
	}


	@Override
	public Map<String, Object> getUserPosition(Map<String, Object> map) {
		return bsrpDAO.getUserPosition(map);
	}


	@Override
	public Map<String, Object> getErpToEmpInfo(Map<String, Object> map) {

		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			result = bsrpDAO.getUserPositionEmp(map);
		} catch (Exception e) {
			result = null;
		}
		
		return result;
	}


	@Override
	public void bsrpSave(Map<String, Object> map) {
		
		//neos.g20_abdocu_h, abdocu_no 값 리턴
		Abdocu_H abdocu_H = (Abdocu_H)map.get("abdocu_H");
		String abdocuNo = String.valueOf(acG20ExGwDAO.insertAbdocu_H(abdocu_H));
		
		//neos.g20_abdocu_b
		Abdocu_B abdocu_B = (Abdocu_B)map.get("abdocu_B");
		abdocu_B.setAbdocu_no(abdocuNo);
		String abdocuBNo = String.valueOf(acG20ExGwDAO.insertAbdocu_B(abdocu_B));
		
		//neos.g20_abdocu_t
		Abdocu_T abdocu_T = (Abdocu_T)map.get("abdocu_T");
		abdocu_T.setAbdocu_no(abdocuNo);
		abdocu_T.setAbdocu_b_no(abdocuBNo);
		acG20ExGwDAO.insertAbdocu_T(abdocu_T);
		
		//dj_bsrp_list 테이블 등록 abdocu_no
		map.put("abdocu_no", abdocuNo);
		bsrpDAO.bsrpSave(map);
		if(map.get("tfcmn") != null && "006".equals(map.get("tfcmn"))){
			bsrpDAO.bsrpMileageSave(map);
		}
	}


	@SuppressWarnings("unchecked")
	@Override
	public void bsrpApp(Map<String, Object> bodyMap) {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		if("20".equals(docSts)) {
			String approKey = String.valueOf(bodyMap.get("approKey"));
			String bs_seq = approKey.replace("bsrp_", "");
			bodyMap.put("bs_seq", bs_seq);
			Map<String, Object> result = (Map<String, Object>)bsrpDAO.getBsrpInfo(bodyMap);
			bodyMap.put("abdocu_no", result.get("abdocu_no"));
			bsrpDAO.docIdUpdate(bodyMap);
		}
		bsrpDAO.bsrpApp(bodyMap);
	}
	
	@Override
	public Map<String, Object> bsrpReqstListSerch(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", bsrpDAO.bsrpReqstListSerch(map)); //리스트
		result.put("totalCount", bsrpDAO.bsrpReqstListSerchTotal(map)); //토탈
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBsrpInfo(Map<String, Object> map) {
		Map<String, Object> result = (Map<String, Object>)bsrpDAO.getBsrpInfo(map);
		result.put("mileage", bsrpDAO.getBsrpMileageInfo(map));
		try {
			result.put("mgt_nm", URLDecoder.decode(String.valueOf(result.get("mgt_nm")), "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void bsrpReportSave(Map<String, Object> map) {
		bsrpDAO.bsrpReportSave(map);
		bsrpDAO.bsrpMileageDel(map);
		if(map.get("tfcmn") != null && "006".equals(map.get("tfcmn"))){
			bsrpDAO.bsrpMileageSave(map);
		}
	}
	
	@Override
	public void bsrpMileageUpdate(Map<String, Object> map) {
//		bsrpDAO.bsrpMileageUpdate(map);
		bsrpDAO.bsrpMileageDel(map);
		bsrpDAO.bsrpMileageSave(map);
		bsrpDAO.bsrpMileageActive(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void bsrpRApp(Map<String, Object> bodyMap) {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		if("90".equals(docSts)) {
			String approKey = String.valueOf(bodyMap.get("approKey"));
			bodyMap.put("abdocu_no", approKey);
			bsrpDAO.docIdUpdate(bodyMap);
			Map<String, Object> result = (Map<String, Object>)bsrpDAO.getBsrpInfo(bodyMap);
			Gson gson = new Gson();
			Map<String, Object> report_json = gson.fromJson(String.valueOf(result.get("report_json")), Map.class);
			report_json.put("abdocu_no", approKey);
			bsrpDAO.abdocu_b_update(report_json);
			bsrpDAO.abdocu_t_update(report_json);
			if(result.get("tfcmn") != null && "006".equals(result.get("tfcmn"))){
				result.put("active", "Y");
				bsrpDAO.bsrpMileageActive(result);
			}
		}
		bsrpDAO.bsrpRApp(bodyMap);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> bsrpStatementListSerch(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = (List<Map<String, Object>>)bsrpDAO.bsrpStatementListSerch(map);
		
		Gson gson = new Gson();
		for (Map<String, Object> bsrpInfo : list) {
			Map<String, Object> tempObj = gson.fromJson((String)bsrpInfo.get("report_json"), Map.class);
			if(tempObj != null && "90".equals(bsrpInfo.get("report_st") + "")){
				if(tempObj.get("daily") != null && !"".equals(tempObj.get("daily"))){
					bsrpInfo.put("daily", Integer.valueOf(tempObj.get("daily") + ""));
				}
				int fare = 0;
				if(tempObj.get("fare") != null && !"".equals(tempObj.get("fare"))){
					fare += Integer.valueOf(tempObj.get("fare") + "");
				}
				if(tempObj.get("toll") != null && !"".equals(tempObj.get("toll"))){
					fare += Integer.valueOf(tempObj.get("toll") + "");
				}
				bsrpInfo.put("fare", fare);
				if(tempObj.get("room") != null && !"".equals(tempObj.get("room"))){
					bsrpInfo.put("room", Integer.valueOf(tempObj.get("room") + ""));
				}
				if(tempObj.get("food") != null && !"".equals(tempObj.get("food"))){
					bsrpInfo.put("food", Integer.valueOf(tempObj.get("food") + ""));
				}
				if(tempObj.get("total") != null && !"".equals(tempObj.get("total"))){
					bsrpInfo.put("total", Integer.valueOf(tempObj.get("total") + ""));
				}
			}
			bsrpInfo.put("report_info", tempObj);
		}
		
		result.put("list", list); //리스트
		result.put("totalCount", bsrpDAO.bsrpStatementListSerchTotal(map)); //토탈
		
		return result;
	}

	@Override
	public void paymentDtSave(Map<String, Object> map) {
		for (String key : map.keySet()) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("bs_seq", key);
			paramMap.put("payment_dt", map.get(key));
			bsrpDAO.paymentDtSave(paramMap);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void bsrpReturn(Map<String, Object> map) {
		Gson gson = new Gson();
		map.put("docx_numb", map.get("abdocu_no"));
		Map<String, Object> tempObj = bsrpDAO.getErpGwLink(map);
		String tempJson = gson.toJson(tempObj);
		map.put("return_doc_id", tempObj.get("appr_dikey"));
		map.put("return_json", tempJson);
		
		// 마일리지 추가
		Map<String, Object> mileage = (Map<String, Object>)bsrpDAO.getBsrpMileageInfo(map);
		if(mileage != null){
			String mileageJson = gson.toJson(mileage);
			map.put("mileage_json", mileageJson);
			bsrpDAO.bsrpMileageDel(map);
		}
		
		bsrpDAO.bsrpReturn(map);
		bsrpDAO.erpgwlinkDel(tempObj);
		
		map.put("docx_numb", "bsrp_" + map.get("bs_seq"));
		tempObj = bsrpDAO.getErpGwLink(map);
		map.put("docId", tempObj.get("appr_dikey"));
		bsrpDAO.docIdUpdate(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void bsrpReturnCancel(Map<String, Object> map) {
		Gson gson = new Gson();
		// 마일리지 추가
		Map<String, Object> mileage = gson.fromJson(bsrpDAO.getMileageJson(map), Map.class);
		if(mileage != null){
			mileage.put("userSeq", mileage.get("write_emp_seq"));
			bsrpDAO.bsrpMileageSave(mileage);
			bsrpDAO.bsrpMileageActive(mileage);
		}
		Map<String, Object> tempObj = gson.fromJson(bsrpDAO.getReturnJson(map), Map.class);
		bsrpDAO.bsrpReturnCancel(map);
		bsrpDAO.erpgwlinkInsert(tempObj);
		map.put("docId", tempObj.get("appr_dikey"));
		bsrpDAO.docIdUpdate(map);
	}


	@Override
	public Map<String, Object> getBsrpMileage(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("savedMileage", bsrpDAO.getBsrpMileage(map));
		return resultMap;
	}


	@Override
	public Map<String, Object> bsrpMileageListSerch(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", bsrpDAO.bsrpMileageListSerch(map)); //리스트
		result.put("totalCount", bsrpDAO.bsrpMileageListSerchTotal(map)); //토탈
		
		return result;
	}
}
