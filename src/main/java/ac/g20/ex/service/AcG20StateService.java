package ac.g20.ex.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ac.cmm.vo.ConnectionVO;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.StateVO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @title AcG20ExStateService.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
public interface AcG20StateService {

	/**
	 * getSbgtLevel doban7 2016. 10. 26.
	 * 
	 * @param param
	 * @param conVo
	 * @return
	 */
	List<HashMap<String, Object>> getErpSbgtLevel(HashMap<String, String> param, ConnectionVO conVo) throws Exception;

	/**
	 * getErpBgtCompareStatus doban7 2016. 10. 27.
	 * 
	 * @param stateVO
	 * @param conVo
	 * @return
	 */
	List<HashMap<String, Object>> getErpBgtCompareStatus(StateVO stateVO, ConnectionVO conVo) throws Exception;

	/**
	 * getErpBgtStepStatus doban7 2016. 10. 31.
	 * 
	 * @param stateVO
	 * @param conVo
	 * @return
	 */
	List<HashMap<String, Object>> getErpBgtStepStatus(StateVO stateVO, ConnectionVO conVo) throws Exception;

	/**
	 * getBgtConsUseAmtList doban7 2016. 11. 6.
	 * 
	 * @param stateVO
	 * @return
	 */
	List<HashMap<String, Object>> getBgtConsUseAmtList(StateVO stateVO) throws Exception;

	/**
	 * getBgtResUseAmtList doban7 2016. 11. 6.
	 * 
	 * @param stateVO
	 * @return
	 */
	List<HashMap<String, Object>> getBgtResUseAmtList(StateVO stateVO) throws Exception;

	/**
	 * getErpBgtExDetailList doban7 2016. 10. 31.
	 * 
	 * @param stateVO
	 * @param conVo
	 * @return
	 */
	List<HashMap<String, Object>> getErpBgtExDetailList(StateVO stateVO, ConnectionVO conVo) throws Exception;

	/**
	 * getGwBgtExDetailList doban7 2016. 10. 31.
	 * 
	 * @param stateVO
	 * @return
	 */
	List<HashMap<String, Object>> getGwBgtExDetailList(StateVO stateVO) throws Exception;

	/** 
	 * getAcExDocList doban7 2016. 11. 13.
	 * @param paramMap
	 * @param paginationInfo
	 * @return
	 */
	Map<String, Object> getAcExDocList(Map<String, Object> paramMap, PaginationInfo paginationInfo)throws Exception;

	/** 
	 * getAcExDocDetail doban7 2016. 11. 13.
	 * @param paramMap
	 * @return
	 */
	List<HashMap<String, String>> getAcExDocDetail(Map<String, Object> paramMap) throws Exception;

	/** 
	 * delAcExDoc doban7 2016. 11. 13.
	 * @param abdocu_Tmp
	 * @param conVo 
	 * @return
	 */
	HashMap<String, Object> delAcExDoc(Abdocu_H abdocu_Tmp, ConnectionVO conVo) throws Exception;

	/** 
	 * delAcExDocConfer doban7 2016. 11. 13.
	 * @param paramMap
	 * @return
	 */
	HashMap<String, Object> delAcExDocConfer(Abdocu_H abdocu_Tmp)throws Exception;



}
