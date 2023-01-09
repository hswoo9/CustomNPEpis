package ac.g20.cms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import ac.g20.cms.dao.PayCmsG20DAO;
import ac.g20.cms.service.PayCmsG20Service;


/**
 * @title PayCmsG20Service.java
 * @author 권현태
 *
 * @date 2018. 5. 25.
 */
@Service ( "PayCmsG20Service" )
public class PayCmsG20ServiceImpl implements PayCmsG20Service{

	@Resource ( name = "PayCmsG20DAO" )
	private PayCmsG20DAO payCmsG20DAO;

	
	@Override
	public List<HashMap<String, String>> payCmsList(Map<String, String> paraMap) throws Exception {
		return payCmsG20DAO.payCmsList(paraMap);
	}


	@Override
	public List<HashMap<String, String>> paySctrlD(Map<String, String> paraMap) throws Exception {
		return payCmsG20DAO.paySctrlD(paraMap);
	}
}
