package ac.g20.app.service;

import java.util.HashMap;
import java.util.Map;

public interface PurcReqAppService {

	void updateDocState(Map<String, Object> map) throws Exception;

	Map<String, Object> purcReqAppSelect(HashMap<String, Object> requestMap) throws Exception;

	void purcReqBiddingApp(Map<String, Object> bodyMap) throws Exception;

}
