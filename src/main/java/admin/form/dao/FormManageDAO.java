/**
 * 
 */
package admin.form.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import admin.form.vo.FolderVO;
import admin.form.vo.FormVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @title FormManageDAO.java
 * @author doban7
 *
 * @date 2016. 8. 18. 
 */
@Repository("FormManageDAO")
public class FormManageDAO extends EgovComAbstractDAO{

	/** 
	 * selectFormTreeList doban7 2016. 8. 18.
	 * @param vo
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFormTreeList(HashMap<String, Object> vo) {
		return (List<Map<String, Object>>) list("FormManage.FormTreeList", vo);
	}
	
	/** 
	 * formSelectOne doban7 2016. 8. 18.
	 * @param formVO
	 * @return
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public HashMap<String, Object> getFormInfo(FormVO formVO) {
		return (HashMap<String, Object>)selectByPk("FormManage.getFormInfo", formVO);
	}

	/** 
	 * getFormAuthList doban7 2016. 8. 29.
	 * @param formVO
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<EgovMap> getFormAuthList(FormVO formVO) {
		return list("FormManage.getFormAuthList", formVO);
	}
	
	/** 
	 * getFolderList doban7 2016. 8. 18.
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getFolderList(Map<String, Object> paramMap) {
		return (List<HashMap<String, String>>)list("FormManage.getFolderList", paramMap);
	}

	/** 
	 * insertForm doban7 2016. 8. 18.
	 * @param paramMap
	 * @return
	 */
	public Object insertForm(Map<String, Object> paramMap) {
		return update("FormManage.insertForm", paramMap);
	}

	/** 
	 * updateForm doban7 2016. 8. 18.
	 * @param paramMap
	 * @return
	 */
	public Object updateForm(Map<String, Object> paramMap) {
		return update("FormManage.updateForm", paramMap);
	}

	/** 
	 * deleteFormAuth doban7 2016. 8. 26.
	 * @param paramMap
	 */
	public void deleteFormAuth(Map<String, Object> paramMap) {
		delete("FormManage.deleteFormAuth", paramMap);
	}

	/** 
	 * insertFormAuth doban7 2016. 8. 26.
	 * @param paramMap
	 */
	public void insertFormAuth(Map<String, Object> paramMap) {
		insert("FormManage.insertFormAuth", paramMap);
	}

	/** 
	 * delFormInfo doban7 2016. 8. 30.
	 * @param formVO
	 */
	public void deleteForm(FormVO formVO) {
		delete("FormManage.deleteForm", formVO);
	}

	/** 
	 * getForderInfo doban7 2016. 8. 19.
	 * @param folderVO
	 * @return
	 */
	@SuppressWarnings({"deprecation", "unchecked" })
	public HashMap<String, Object> getFolderInfo(FolderVO folderVO) {
		return (HashMap<String, Object>)selectByPk("FormManage.getFolderInfo", folderVO);
	}
	
	/** 
	 * insertForder doban7 2016. 8. 19.
	 * @param paramMap
	 * @return
	 */
	public Object insertFolder(Map<String, Object> paramMap) {
		return insert("FormManage.insertFolder", paramMap);
	}

	/** 
	 * updateForder doban7 2016. 8. 19.
	 * @param paramMap
	 * @return
	 */
	public Object updateFolder(Map<String, Object> paramMap) {
		return update("FormManage.updateFolder", paramMap);
	}

	/** 
	 * getFormKey doban7 2016. 8. 24.
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String getFormKey() {
		return (String) selectByPk("FormManage.getFormKey", null);
	}

	/** 
	 * deleteFolderAuth doban7 2016. 8. 26.
	 * @param paramMap
	 */
	public void deleteFolderAuth(Map<String, Object> paramMap) {
		delete("FormManage.deleteFolderAuth", paramMap);
	}

	/** 
	 * insertFolderAuth doban7 2016. 8. 26.
	 * @param paramMap
	 */
	public void insertFolderAuth(Map<String, Object> paramMap) {
		insert("FormManage.insertFolderAuth", paramMap);
	}

	/** 
	 * getFolderAuthList doban7 2016. 8. 29.
	 * @param forderVO
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<EgovMap> getFolderAuthList(FolderVO forderVO) {
		return list("FormManage.getFolderAuthList", forderVO);
	}

	/** 
	 * getChildFolderCnt doban7 2016. 8. 30.
	 * @param folderVO
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public int getChildFolderCnt(FolderVO folderVO) {
		return (int) selectByPk("FormManage.getChildFolderCnt", folderVO);
	}

	/** 
	 * deleteFolderInfo doban7 2016. 8. 30.
	 * @param folderVO
	 */
	public void deleteFolder(FolderVO folderVO) {
		delete("FormManage.deleteFolder", folderVO);
	}

	public String getOutProcessDiv(Map<String, Object> paramMap) {
		return (String) select("FormManage.getOutProcessDiv", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>>getDetailCodeList(Map<String,Object> paramMap){
		return (List<Map<String,Object>>) list("FormManage.getDetailCodeList", paramMap);
	}

	/** 
	 * getOutProcessInterlock doban7 2016. 12. 22.
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getOutProcessInterlock(Map<String, Object> paramMap) {
		return (Map<String, Object>) select("FormManage.getOutProcessInterlock", paramMap);
	}
	
	public void deleteConfigSet(Map<String, Object> paramMap){
		delete("FormManage.deleteConfigSet", paramMap);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> GetFormTreeViewJT(Map<String, Object> params) {
		return list("FormManage.GetFormTreeViewJT", params);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getFormList(Map<String, Object> paramMap) {
		return (List<HashMap<String, String>>)list("FormManage.getFormList", paramMap);
	}

	public void deleteFormReader(Map<String, Object> paramMap) {
		delete("FormManage.deleteFormReader", paramMap);
	}

	public void insertFormReader(Map<String, Object> paramMap) {
		insert("FormManage.insertFormReader", paramMap);		
	}
	
	@SuppressWarnings("unchecked")
	public List<EgovMap> getFormReaderList(FormVO formVO) {
		return list("FormManage.getFormReaderList", formVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<EgovMap> getDraftReaderList(Map<String, Object> paramMap) {
		return list("FormManage.getDraftReaderList", paramMap);
	}

	public void deleteFormLine(Map<String, Object> paramMap) {
		delete("FormManage.deleteFormLine", paramMap);
	}

	public void insertFormLine(Map<String, Object> paramMap) {
		insert("FormManage.insertFormLine", paramMap);	
	}

	@SuppressWarnings("unchecked")
	public List<EgovMap> getFormLineList(FormVO formVO) {
		return list("FormManage.getFormLineList", formVO);
	}

	@SuppressWarnings("deprecation")
	public int getDraftDocCnt(FormVO formVO) {
		return (int) selectByPk("FormManage.getDraftDocCnt", formVO);
	}
}
