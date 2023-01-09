package neos.cmm.systemx.orgchart;

import java.sql.SQLException;

import javax.servlet.ServletContext;

import org.apache.ibatis.session.SqlSession;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import bizbox.orgchart.service.IOrgEditService;
import bizbox.orgchart.service.IOrgEmpService;
import bizbox.orgchart.service.IOrgGrpService;
import bizbox.orgchart.service.IOrgService;
import bizbox.orgchart.service.impl.OrgEditServiceImpl;
import bizbox.orgchart.service.impl.OrgEmpServiceImpl;
import bizbox.orgchart.service.impl.OrgGrpServiceImpl;
import bizbox.orgchart.service.impl.OrgServiceImpl;

public class OrgChartSupport {
	private static IOrgService orgService = null;
	private static IOrgEditService editService = null;
	private static IOrgEmpService empService = null;
	private static IOrgGrpService grpService = null;
	
	
	public static void init(ServletContext sc){
		 ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
		 System.out.println("::::::::::::::::::::::::          " + act.getBean("sqlSession") + "      :::::::::::::::::::::::::::::::::::::::");
		 SqlSession sqlSession = (SqlSession)act.getBean("sqlSession");
		 
//		 try {
//			orgService = new OrgServiceImpl(sqlSession);
//			editService = new OrgEditServiceImpl(sqlSession);
//			empService = new OrgEmpServiceImpl(sqlSession);
//			grpService = new OrgGrpServiceImpl(sqlSession);
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
		 
	}
	
	public static IOrgService getIOrgService() {
		return orgService;
	}
	public static IOrgEditService getIOrgEditService() {
		return editService;
	}
	public static IOrgEmpService getIOrgEmpService() {
		return empService;
	}
	public static IOrgGrpService getIOrgGrpService() {
		return grpService;
	}
}
