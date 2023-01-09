package com.duzon.custom.kukgoh.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.kukgoh.util.KukgohCommVO;
import com.jcraft.jsch.SftpException;

public interface KukgohService {
	
	boolean code01save(List<KukgohCommVO> kukgohInfoList);
	Map<String, Object> getRemoteFile(Map<String, Object> map) throws SftpException, IOException;
	List<Map<String, Object>> getCommCodeClassificationMs(Map<String, Object> map);
	List<Map<String, Object>> getMainGridMs(Map<String, Object> map);
	int getMainGridTotalMs(Map<String, Object> map);
	Map<String, Object> commCodeSaveMs(Map<String, Object> map) throws JsonParseException, JsonMappingException, IOException;
	List<Map<String, Object>> getAttachFileMs(Map<String, Object> map);
	List<Map<String, Object>> getFileList(Map<String, Object> map);
	List<Map<String, Object>> getBudgetMainGrid(Map<String, Object> map);
	List<Map<String, Object>> getBudgetCdGridPop(Map<String, Object> map);
	boolean saveBgtConfig(Map<String, Object> map) throws JsonParseException, JsonMappingException, IOException;
	List<Map<String, Object>> getProjectCdGridPop(Map<String, Object> map);
	Map<String, Object> saveProjectConfig(Map<String, Object> map);
	List<Map<String, Object>> getProjectMainGrid(Map<String, Object> map);
	List<Map<String, Object>> insertResolutionMainGrid(Map<String, Object> map);
	String getErpEmpSeq(Map<String, Object> loginMap);
	String getErpDeptSeq(Map<String, Object> loginMap);
	List<Map<String, Object>> getUnSendData(Map<String, Object> data);
	List<Map<String, Object>> getSendData(Map<String, Object> data);
	List<Map<String, Object>> getEvidenceMs();
	List<Map<String, Object>> getCustomerGbMs();
	List<Map<String, Object>> getDepositGbMs();
	List<Map<String, Object>> getDepositGbCauseMs();
	
	Map<String, Object> requestInvoice1(Map<String, Object> map);
	Map<String, Object> requestInvoice2(Map<String, Object> map) throws Exception, SftpException, FileNotFoundException, IOException;
	Map<String, Object> getCommDir(Map<String, Object> map);
	void transactionTest(Map<String, Object> map) throws Exception;
	Map<String, Object> sendInfo(List<Map<String, Object>> map, String ip, String empSeq) throws Exception, SftpException, IOException;
	Map<String, Object> sendResolutionList(List<Map<String, Object>> map, String ip, String empSeq) throws Exception, SftpException, IOException;
	Map<String, Object> cancelSendInfo(Map<String, Object> map);
	List<Map<String, Object>> kukgohInvoiceGrid(Map<String, Object> map);
	Map<String, Object> invoiceValidation(Map<String, Object> map);
	Map<String, Object> saveCheck(Map<String, Object> map);
	Map<String, Object> insertAttachFile(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception;
	void asyncGetFiles() throws SftpException, IOException;
	int deleteFile(Map<String, Object> map);
	List<Map<String, Object>> kukgohInvoiceInsertGrid(Map<String, Object> map);
	List<Map<String, Object>> kukgohInvoiceInsertGrid2(Map<String, Object> map);
	List<Map<String, Object>> getInterfaceGrid(Map<String, Object> map);
	Map<String, Object> getRemoteFile2(Map<String, Object> map4) throws SftpException, IOException;
	int insertTrnscIdReadStatus(Map<String, Object> map);
	int updateTrnscIdReadStatus(Map<String, Object> map) ;
	int ckeckTrnscIdReadStatus(Map<String, Object> map) ;
	Map<String, Object> getUrlInfo();
	public void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response);
	List<Map<String, Object>> admSendGrid(Map<String, Object> map);
	List<Map<String, Object>> admAccountGrid(Map<String, Object> map);
	List<Map<String, Object>> admResolutionMainGrid(Map<String, Object> map);
	
	boolean saveAssntInfo(Map<String, Object> jsonMap) throws JsonParseException, JsonMappingException, IOException;
	List<Map<String, Object>> getAsstnGridPop(Map<String, Object> map);
	List<Map<String, Object>> getCardList(Map<String, Object> map);
	List<Map<String, Object>> getCardNoList(Map<String, Object> map);
	void updateCancelAssntInfo(Map<String, Object> map) throws Exception;
	Map<String, Object> watchNewFiles(String[] list);
	Map<String, Object> cancelProjectConfig(Map<String, Object> map);
	List<Map<String, Object>> sendInvoiceMainGrid(Map<String, Object> map);
	Map<String, Object> saveSendingInvoice(List<Map<String, Object>> list, String empSeq, String ip, String url) throws Exception;
	void saveKorailCityInfo(Map<String, Object> map);
	void saveKorailNodeInfo(Map<String, Object> map);
	void saveKorailVehicleKind(Map<String, Object> map);
	void deleteKorailInfoAll();
	String getErpDeptNo(Map<String, Object> map);
	List<Map<String, Object>> sendResolutionGrid(Map<String, Object> map) throws Exception;
	Map<String, Object> submitPageSending(Map<String, Object> map);
	Map<String, Object> submitPageConfirm(Map<String, Object> map);
	Map<String, Object> getPjtInfo(Map<String, Object> map);
	Map<String, Object> changeAccountType(Map<String, Object> map);
	Map<String, Object> getEnaraAttaches(Map<String, Object> map) throws Exception;
	Map<String, Object> getErpDeptNum(Map<String, Object> map);
	Map<String, Object> getRestradeInfo(Map<String, Object> map);
	List<Map<String, Object>> sendResolutionGrid2(Map<String, Object> map);
	Map<String, Object> getBankcode(Map<String, Object> map);
	public void exceptEnaraDoc(Map<String, Object> map);
	public void reloadEnaraExceptDoc(Map<String, Object> map);
	List<Map<String, Object>> selectEnaraExceptList(Map<String, Object> map);
}
