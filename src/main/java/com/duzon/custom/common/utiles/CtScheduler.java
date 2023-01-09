package com.duzon.custom.common.utiles;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.vacationApply.service.vacationApplyService;

public class CtScheduler {
	
	private static final Logger logger = LoggerFactory.getLogger(CtScheduler.class);
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private vacationApplyService vacationApplyService;
	
	public void dailyWorkAgree() {
		Map<String, Object> map = new HashMap<String, Object>();
		commonService.dailyWorkAgree(map);
	}
	
	public void monthlyWorkPlanMake() {
		Map<String, Object> map = new HashMap<String, Object>();
		commonService.monthlyWorkPlanMake(map);
	}
	
	/**
	 * @MethodName : familyBenefitMonthBatch
	 * @author : doxx
	 * @since : 2020. 6. 11
	 * 설명 : 가족수당 월배치
	 */
	public void familyBenefitMonthBatch() {
		vacationApplyService.familyBenefitMonthBatch();
	};

	/**
	 * @MethodName : welfareBenefitMonthBatch
	 * @author : doxx
	 * @since :  2020. 6. 11
	 * 설명 : 복지포인트 월배치
	 */
	public void welfareBenefitMonthBatch() {
		vacationApplyService.welfareBenefitMonthBatch();
	};
	
	


	
}
