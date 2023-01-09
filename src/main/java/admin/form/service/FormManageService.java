package admin.form.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import admin.form.vo.FolderVO;
import admin.form.vo.FormVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @title FormManageService.java
 * @author doban7
 *
 * @date 2016. 8. 18. 
 */
public interface FormManageService {

	/** 
	 * getFormTreeList doban7 2016. 8. 18.
	 * @param vo
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> getFormTreeList(HashMap<String, Object> vo) throws Exception;
	
	/** 
	 * getFormInfo doban7 2016. 8. 18.
	 * @param formVO
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> getFormInfo(FormVO formVO) throws Exception;
	
	/**
	 * 
	 * getFormInfo doban7 2016. 9. 1.
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getFormInfo(HashMap<String, String> vo) throws Exception;

	Map<String, Object> setFormInfo(Map<String, Object> paramMap, MultipartHttpServletRequest multiRequest) throws Exception;

	/** 
	 * delFormInfo doban7 2016. 8. 30.
	 * @param formVO
	 * @return
	 */
	Map<String, Object> delFormInfo(FormVO formVO) throws Exception;


	/** 
	 * getFormInfo doban7 2016. 8. 19.
	 * @param folderVO
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> getFolderInfo(FolderVO folderVO) throws Exception ;
	
	/** 
	 * getFolderList doban7 2016. 8. 18.
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> getFolderList(Map<String, Object> paramMap) throws Exception;

	/** 
	 * insertFolderInfo doban7 2016. 8. 29.
	 * @param paramMap
	 * @return
	 */
	Map<String, Object> insertFolderInfo(Map<String, Object> paramMap) throws Exception;

	/** 
	 * updateFolderInfo doban7 2016. 8. 29.
	 * @param paramMap
	 * @return
	 */
	Map<String, Object> updateFolderInfo(Map<String, Object> paramMap) throws Exception;

	/** 
	 * delFolderInfo doban7 2016. 8. 30.
	 * @param folderVO
	 * @return
	 */
	Map<String, Object> delFolderInfo(FolderVO folderVO) throws Exception;

	/** 
	 * 외부연동여부 확인
	 * @param paramMap 
	 * @return String
	 */
	public String getOutProcessDiv(Map<String, Object> paramMap) throws Exception;
	
	/** 
	 * 양식상세구분  - 양식상세구분 리스트 불러오기
	 * @param paramMap 
	 * @return String
	 */
	public List<Map<String,Object>> getDetailCodeList(Map<String,Object>paramMap)throws Exception;

	/** 
	 * getOutProcessInterlock doban7 2016. 12. 22.
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getOutProcessInterlock(Map<String, Object> paramMap) throws Exception;

	List<Map<String, Object>> GetFormTreeViewJT(Map<String, Object> params);

	List<HashMap<String, String>> getFormList(Map<String, Object> paramMap);

	List<EgovMap> getDraftReaderList(Map<String, Object> paramMap);

}
