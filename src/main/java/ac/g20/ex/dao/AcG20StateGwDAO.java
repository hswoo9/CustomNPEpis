package ac.g20.ex.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Repository;

import ac.g20.ex.vo.StateVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @title AcG20StateGwDAO.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
@Repository("AcG20StateGwDAO")
public class AcG20StateGwDAO extends EgovComAbstractDAO {

	private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(this.getClass());

	/**
	 * getBgtConsUseAmtList doban7 2016. 11. 6.
	 * 
	 * @param stateVO
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getBgtConsUseAmtList(StateVO stateVO) {
		LOG.debug("! [G20] AcG20StateGwDAO - getBgtConsUseAmtList >> AcG20StateGwDAO.getBgtConsUseAmtList");
		LOG.debug("! [G20] AcG20StateGwDAO - StateVO stateVO >> " + stateVO.toString());
		return list("AcG20StateGwDAO.getBgtConsUseAmtList", stateVO);
	}

	/**
	 * getBgtResUseAmtList doban7 2016. 11. 6.
	 * 
	 * @param stateVO
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getBgtResUseAmtList(StateVO stateVO) {
		LOG.debug("! [G20] AcG20StateGwDAO - getBgtResUseAmtList >> AcG20StateGwDAO.getBgtResUseAmtList");
		LOG.debug("! [G20] AcG20StateGwDAO - StateVO stateVO >> " + stateVO.toString());
		return list("AcG20StateGwDAO.getBgtResUseAmtList", stateVO);
	}

	/**
	 * getGwBgtExDetailList doban7 2016. 10. 31.
	 * 
	 * @param stateVO
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getGwBgtExDetailList(StateVO stateVO) {
		LOG.debug("! [G20] AcG20StateGwDAO - getGwBgtExDetailList >> AcG20StateGwDAO.getGwBgtExDetailList");
		LOG.debug("! [G20] AcG20StateGwDAO - StateVO stateVO >> " + stateVO.toString());
		return list("AcG20StateGwDAO.getGwBgtExDetailList", stateVO);
	}

	/** 
	 * getAcExDocList doban7 2016. 11. 13.
	 * @param paramMap
	 * @param paginationInfo
	 * @return
	 */
	public Map<String, Object> getAcExDocList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return super.listOfPaging2(paramMap, paginationInfo, "AcG20StateGwDAO.getAcExDocList");	
	}

	/** 
	 * getAcExDocDetail doban7 2016. 11. 13.
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getAcExDocDetail(Map<String, Object> paramMap) {
		return list("AcG20StateGwDAO.getAcExDocDetail", paramMap);
	}
}
