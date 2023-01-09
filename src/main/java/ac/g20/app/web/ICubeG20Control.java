package ac.g20.app.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ICubeG20Control {
 	/**
 	 *<pre>
 	 * 1. MethodName	: iCubeG20Control
 	 * 2. Description	: g20컨트롤 
 	 * ------- 개정이력(Modification Information) ----------
 	 *    작성일            작성자         작성정보
 	 *    2013. 11. 8.     남정환       최초작성
 	 *  -----------------------------------------------------
 	 *</pre>
 	 * @param map
 	 * @param model
 	 * @return
 	 * @throws Exception
 	 */
 	@RequestMapping(value="/IU_FORWARD/ICubeG20Service.do")
	public String iCubeG20Control(@RequestParam Map<String, Object> map,  HttpServletRequest request, Model model) throws Exception	{
 		String path = "/neos/edoc/eapproval/link/hwp/icube/";
 		String IU_KEY = (String)map.get("approKey");
 		String IU_MODE = (String)map.get("IU_MODE");
 		String mode = (String)map.get("mode");
 		String approKey = (String)map.get("approKey");
 		
		if(IU_MODE.equals("APVL_INSERT")){// 결재 기안화면호출
			return path+"docICubeG20DraftWritePopup";
		}else if(IU_MODE.equals("APVL_EDIT")){// 결재 수정화면호출
			
			return path+"docICubeG20DraftEditPopup"; 
		}else if(IU_MODE.equals("IU_DETAIL")){ // 연동상세화면호출
			return "";
		}else if(IU_MODE.equals("IU_EDIT")){ /* 연동수정화면호출 */
			
			if(mode.equals("1")){
				return "forward:/Ac/G20/Ex/AcExResDocForm.do";	
			}
			return "forward:/Ac/G20/Ex/AcExConsDocForm.do";
		}
		
		return "";
	}
}
