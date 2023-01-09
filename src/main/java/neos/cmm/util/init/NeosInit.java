package neos.cmm.util.init;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;

import neos.cmm.systemx.orgchart.OrgChartSupport;

public class NeosInit extends HttpServlet{
	/**
	 *
	 */
	private static final long serialVersionUID = 1716427616880062618L;

	public void init(){
		try {
			ServletContext sc = getServletContext();
		
			CodeUtilInit.init(sc);
			ConstantsInit.init();
		} catch (Exception e) {
			e.printStackTrace() ;
		}
	}

}
