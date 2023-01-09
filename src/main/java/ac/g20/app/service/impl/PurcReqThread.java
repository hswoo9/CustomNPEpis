package ac.g20.app.service.impl;

import java.util.Map;

import org.apache.logging.log4j.LogManager;

import ac.g20.app.dao.PurcReqAppDAO;

public class PurcReqThread implements Runnable {
	private org.apache.logging.log4j.Logger logger = LogManager.getLogger( PurcReqThread.class );
	
	private boolean stopped = false;
	
	private PurcReqAppDAO purcReqAppDAO;
	private String docId;
	private String approKey;
	
	public PurcReqThread(String docId, PurcReqAppDAO purcReqAppDAO, String approKey){
		this.docId = docId;
		this.approKey = approKey;
		this.purcReqAppDAO = purcReqAppDAO;
	}
	
	@Override
	public void run(){
		process();
	}
	
	private void process(){
		int cnt = 0;
		while(!stopped){
			try {
				cnt++;
				Thread.sleep(1000);
				
				long startTime = System.currentTimeMillis();
				logger.info("========= Thread start " + cnt +" =======================================");
				logger.info(Long.valueOf(startTime).toString());
				
				Map<String, Object> result = (Map<String, Object>)purcReqAppDAO.getApprovalInfo(this.docId);	// 결재문서정보
				logger.info(result != null ? result.toString() : "null");
				
				if(result != null && result.get("docNo") != null && !"".equals(result.get("docNo"))){
					// 2.0 테이블 문서정보 업데이트
					result.put("approKey", this.approKey);
					purcReqAppDAO.updateConsDocEaInfo(result);
					
					long endTime = System.currentTimeMillis();
					logger.info("========= Thread end " + cnt +" =======================================");
					logger.info(Long.valueOf(endTime).toString());
					stopped = true;
				}
				if(cnt > 10){
					stopped = true;
				}
			} catch (InterruptedException e) {
				logger.error(e);
				stopped = true;
			} catch (Exception e){
				logger.error(e);
				stopped = true;
			}
		}
		
	}
	
	private void process(int cnt){
		
		try {
			Thread.sleep(1000);
			
			long startTime = System.currentTimeMillis();
			logger.info("========= Thread start " + cnt +" =======================================");
			logger.info(Long.valueOf(startTime).toString());
			
			Map<String, Object> result = (Map<String, Object>)purcReqAppDAO.getApprovalInfo(this.docId);	// 결재문서정보
			logger.info(result != null ? result.toString() : "null");
			
			if(result != null && result.get("docNo") != null && !"".equals(result.get("docNo"))){
				// 2.0 테이블 문서정보 업데이트
				result.put("approKey", this.approKey);
				purcReqAppDAO.updateConsDocEaInfo(result);
				
				long endTime = System.currentTimeMillis();
				logger.info("========= Thread end " + cnt +" =======================================");
				logger.info(Long.valueOf(endTime).toString());
			}else if(cnt > 0){
				process(cnt - 1);
			}
		} catch (InterruptedException e) {
			logger.error(e);
		}
		
	}
}
