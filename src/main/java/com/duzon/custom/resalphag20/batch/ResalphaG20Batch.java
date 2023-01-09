package com.duzon.custom.resalphag20.batch;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.jcraft.jsch.SftpException;

@EnableScheduling
@Configuration
public class ResalphaG20Batch {

	@Autowired
	ResAlphaG20Service resalphaG20Service;
	
	private static final Logger logger = (Logger) LoggerFactory.getLogger(ResalphaG20Batch.class);
	
	/**
	 * Method Name : 카드 미정산 데이터 배치 작업
	 * 작성일 : 2020. 12. 22.
	 * 작성자 : jy
	 * Method 설명 : 일배치 새벽 2시 - 정산 기한 지난 데이터들 알림 설정
	 */
	@Scheduled(cron="0 0 2 * * *")
	public void cardAlamBatch() throws SftpException, IOException{
		logger.info("cardAlamBatch - PM 02:00 일배치");
		
		try {
//			resalphaG20Service.notionNotSettleCard();
		} catch (Exception e) {
			logger.info("cardAlamBatch ERROR :", e);
		}
	}
	
	/**
	 * Method Name : 카드 미정산 알림 전송
	 * 작성일 : 2020. 12. 22.
	 * 작성자 : jy
	 * Method 설명 : 일배치 오전 9시
	 */
	@Scheduled(cron="0 0 2 * * *")
	public void sendCardAlamBatch() throws SftpException, IOException{
		logger.info("sendCardAlamBatch - PM 02:00 일배치");
		
		try {
			resalphaG20Service.sendCardAlamBatch();
		} catch (Exception e) {
			logger.info("cardAlamBatch ERROR :", e);
		}
	}
}
