package ac.g20.cms.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @title AcG20ExStateService.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
public interface PayCmsG20Service {

	List<HashMap<String, String>> payCmsList(Map<String, String> paraMap) throws Exception;

	List<HashMap<String, String>> paySctrlD(Map<String, String> paraMap) throws Exception; 

}
