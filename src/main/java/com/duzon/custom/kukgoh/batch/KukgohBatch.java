package com.duzon.custom.kukgoh.batch;

import java.util.List;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.request.ServletWebRequest;

import com.duzon.custom.kukgoh.controller.KukgohContorller;
import com.duzon.custom.kukgoh.service.KukgohService;

public class KukgohBatch {
	
	@Autowired
	KukgohService kukgohService;
	
	private static final Logger logger = (Logger) LoggerFactory.getLogger(KukgohBatch.class);
	
	final static String[] INTFCID_LIST = {"IF-EXE-EFS-0192", "IF-EXE-EFS-0196", "IF-EXE-EFS-0242"};
	
	// ENARA 연계 모듈 폴더 배치
	public void sndAgentMsg() throws Exception, NoPermissionException {
		logger.info("==================== sndAgentMsg Start ====================");
		logger.info("kukgoh/sndAgentMsg!!!");
		logger.info("==================== sndAgentMsg Start ====================");
		
		Map<String, Object> resultMap = kukgohService.watchNewFiles(INTFCID_LIST);
		
		logger.info("resultMap : " + resultMap);
		
		if (resultMap.get("flag").equals("Y")) { // 새로 추가된 파일이 있을 경우
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> resultList = (List<Map<String, Object>>) resultMap.get("resultList");
			
			logger.info(resultList.size() + " 결과 갯수 ");
			
			for (Map<String, Object> map : resultList) {
				
				map.put("EMP_SEQ", "SYSTEM");
				map.put("EMP_IP", "SYSTEM");
				map.put("CODE_VAL", "0");
				map.put("code",(String)map.get("intfcId"));
				
				if(kukgohService.ckeckTrnscIdReadStatus(map) == 0) {
					map.put("status", "Y");
					
					logger.info("==================== getRemoteFile Start ====================");
					kukgohService.getRemoteFile2(map);
					logger.info("==================== getRemoteFile End ====================");
					
					map.put("status", "N");
					kukgohService.ckeckTrnscIdReadStatus(map);
				}
			}
		}
	}
}
