package neos.cmm.util.init;

import javax.servlet.ServletContext;

import neos.cmm.util.code.CommonCodeUtil;
import neos.cmm.util.code.service.impl.CommonCodeDAO;
//import neos.mail.messenger.service.MailMessengerService;
//import neos.mobile.push.service.impl.PushManageDAO;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import admin.option.dao.OptionManageDAO;

public class CodeUtilInit{


	public static void init(ServletContext sc){
		try {
			ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
			CommonCodeDAO commonCodeDAO = (CommonCodeDAO)act.getBean("CommonCodeDAO");
			OptionManageDAO optionManageDAO = (OptionManageDAO)act.getBean("OptionManageDAO");
			
			
			CommonCodeUtil.init(commonCodeDAO) ;
			CommonCodeUtil.initChild(commonCodeDAO);
			CommonCodeUtil.initOption(optionManageDAO);
			
//			try{
//				if("Y".equals(CommonCodeSpecific.getMobileApp()) ) {
//					PushManageDAO pushManageDAO = (PushManageDAO)act.getBean("PushManageDAO");
//					MobileCodeUtil.initMessengerSEQ(pushManageDAO);
//
//					MobileCodeUtil.initPush(pushManageDAO);
//				}
//				/*MessengerCodeUtil은 모바일에서 사용하기 때문에 공통으로 초기화 한다.*/
////				MailMessengerService mailMessengerService = (MailMessengerService)act.getBean("MailMessengerService");
////				MessengerCodeUtil.getGrp(mailMessengerService.grp());
////				MessengerCodeUtil.getGrpUser(mailMessengerService.grpuser());
////				MessengerCodeUtil.initReservedQueue(mailMessengerService.ReserveMsgList());
//			}catch(Exception ex){
//				ex.printStackTrace();
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
