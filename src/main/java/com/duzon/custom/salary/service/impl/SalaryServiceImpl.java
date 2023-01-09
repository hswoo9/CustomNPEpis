package com.duzon.custom.salary.service.impl;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.duzon.custom.salary.vo.TempVO;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.salary.controller.SalaryController;
import com.duzon.custom.salary.dao.SalaryDAO;
import com.duzon.custom.salary.service.SalaryService;
import com.google.gson.Gson;

@Service
public class SalaryServiceImpl implements SalaryService {
	
	private static final Logger logger = (Logger) LoggerFactory.getLogger(SalaryController.class);
	
	@Autowired
	private SalaryDAO salaryDAO;
	
	@Override
    public List<Map<String, Object>> getSalaryViewDetailList(Map<String, Object> params) {
        return salaryDAO.getSalaryViewDetailList(params);
    }
	
	@Override
	public Map<String, Object> getHrPaySlipPop(Map<String, Object> params) throws Exception {
		
        Map<String, Object> result = salaryDAO.selectErpConnection(params);
        
        try {
        	String erpType = result.get("erp_type_code").toString();
            params.put("erpCompSeq", result.get("erp_comp_seq"));
            
            List<List<Map<String, Object>>> hrPaySlipPop = salaryDAO.selectHrPaySlipPop(params);
            System.out.println("===========hrPaySlipPop" + hrPaySlipPop);
            
            List<Map<String, Object>> payrpta = new ArrayList<Map<String, Object>>();
            List<Map<String, Object>> payrptb = new ArrayList<Map<String, Object>>();
            List<Map<String, Object>> payrptc = new ArrayList<Map<String, Object>>();
            Map<String, Object> payrptd = new HashMap<String, Object>();
            int i = 0;

            for(List<Map<String, Object>> listMap : hrPaySlipPop) {
                i++;
                if(i == 1) {
                    payrpta = listMap;
                } else if (i == 2) {
                    payrptb = listMap;
                } else if (i == 3) {
                    payrptc = listMap;
                } else if (i == 4) {
                    payrptd = listMap.get(0);
                }
            }

            System.out.println("payrpta = " + payrpta);
            System.out.println("payrptb = " + payrptb);
            System.out.println("payrptc = " + payrptc);
            System.out.println("payrptd = " + payrptd);
            
        	//Map<String, Object> icubePayForm = getIcubePayForm(hrPaySlipPop);
        
	        //Map<String, Object> empInfo = salaryDAO.selectHrPayListEmp(params);
	        Map<String, Object> paySlipPopInfo = new HashMap<String, Object>();
        
	        //paySlipPopInfo.putAll(icubePayForm);
			paySlipPopInfo.put("erpCompName", result.get("erp_comp_name"));
			paySlipPopInfo.put("erpType", erpType);
			paySlipPopInfo.put("payrpta", payrpta);
			paySlipPopInfo.put("payrptb", payrptb);
			paySlipPopInfo.put("payrptc", payrptc);
			paySlipPopInfo.put("payrptd", payrptd);
        
	        return paySlipPopInfo;
	        
        } finally {}
    }
	
	private boolean isNotEmpty(Object obj) {
        return obj != null && !obj.toString().isEmpty();
    }
	
	@Override
    public Map<String, Object> getJoinDay(Map<String, Object> params) {
        return salaryDAO.getJoinDay(params);
    }
	
	@Override
    public Map<String, Object> getSelectWorkingDays(Map<String, Object> params) {
		params.put("searchStdd", "20220801");
		params.put("searchEddd", "20220831");
        return salaryDAO.getSelectWorkingDays(params);
    }
	
	@Override
    public Map<String, Object> getSelectYetWorkingDays(Map<String, Object> params) {
		params.put("searchStdd", "20220701");
		params.put("searchEddd", "20220731");
        return salaryDAO.getSelectYetWorkingDays(params);
    }
	
	@Override
    public Map<String, Object> getSelectAnnualDays(Map<String, Object> params) {
		params.put("searchStdd", "20220801");
		params.put("searchEddd", "20220831");
        return salaryDAO.getSelectAnnualDays(params);
    }
	
	@Override
    public List<Map<String, Object>> getSelectOverWork(Map<String, Object> params) {
		params.put("searchYear", "2022");
		params.put("searchMonth", "08");
        return salaryDAO.getSelectOverWork(params);
    }
	
	@Override
    public List<Map<String, Object>> getSelectDalmMonthList(Map<String, Object> params) {
		params.put("searchYear", "2022");
		params.put("searchMonth", "08");
        return salaryDAO.getSelectDalmMonthList(params);
    }
}

