package ac.g20.app.service;

import java.util.HashMap;
import java.util.Map;

public interface PurcContAppService {

	void updateDocState(Map<String, Object> map) throws Exception;

	Map<String, Object> purcContAppSelect(HashMap<String, Object> requestMap) throws Exception;
	
	void updateInspDocState(Map<String, Object> map) throws Exception;
	
	Map<String, Object> purcContInspAppSelect(HashMap<String, Object> requestMap) throws Exception;

	void updatePayDocState(Map<String, Object> bodyMap) throws Exception;

	Map<String, Object> purcContPayAppSelect(HashMap<String, Object> requestMap) throws Exception;

	void updateModDocState(Map<String, Object> bodyMap) throws Exception;


}
