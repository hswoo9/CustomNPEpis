package com.duzon.custom.resalphag20.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Array;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.kukgoh.dao.KukgohDAO;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.duzon.custom.resalphag20.service.impl.PdfEcmThread;
import com.duzon.custom.resalphag20.service.impl.PdfFinalEcmThread;
import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;
import com.duzon.custom.util.FileDownload;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.jcraft.jsch.SftpException;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;

@Controller("ResAlphaG20Controller")
public class ResAlphaG20Controller {
	private static final Logger logger = LoggerFactory.getLogger(ResAlphaG20Controller.class);
	
	@Autowired
	private CommFileDAO commFileDAO;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private ResAlphaG20Service resAlphaG20Service;
	
	@Autowired
	private KukgohDAO kukgohDAO;
	
	@Value("#{bizboxa['BizboxA.fileRootPath']}")
	private String fileRootPath;
	
	@Value("#{bizboxa['BizboxA.onnaraFilePath']}")
	private String onnaraFilePath;
	
	@Value("#{bizboxa['BizboxA.onnaraFileSubPath']}")
	private String onnaraFileSubPath;
	
	@Value("#{bizboxa['BizboxA.pdfServerRootPath']}")
	private String pdfServerRootPath;
	
	@Value("#{bizboxa['BizboxA.finalPdfServerPath']}")
	private String finalPdfServerPath;
	
	@Value("#{bizboxa['BizboxA.addFinalServerPath']}")
	private String addFinalServerPath;
	
	@RequestMapping("/resAlphaG20/getFormInfo")
	public ModelAndView getFormInfo(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		try {
			mv.addObject("formInfo", resAlphaG20Service.getFormInfo(paramMap));
			mv.addObject("result", "Success");
		} catch (Exception e) {
			logger.error(e.getMessage());
			mv.addObject("result", "Failed");
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/custIframe")
	public ModelAndView custIframe(HttpServletRequest servletRequest, @RequestParam Map<String, Object> paramMap, ModelAndView mv) throws Exception {
		try {
			String iframeUrl = resAlphaG20Service.getIframeUrl(paramMap);
			mv.addObject("interface_id", paramMap.get("interface_id"));
			mv.setViewName("redirect:" + iframeUrl);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/getCustIframeHeight")
	public ModelAndView getCustIframeHeight(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		try {
			mv.addObject("height", resAlphaG20Service.getCustIframeHeight(paramMap));
			mv.addObject("result", "Success");
		} catch (Exception e) {
			logger.error(e.getMessage());
			mv.addObject("result", "Failed");
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/defaultUrl")
	public ModelAndView defaultUrl ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/resAlphaG20/iframe/defaultUrl" );
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/resAlphaG20Test")
	public ModelAndView resAlphaG20Test ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		requestMap.put( "requestUrl", request.getRequestURI( ) );
		mv.addObject("loginVO", loginVO);
		mv.addObject( "params", requestMap );
		mv.setViewName( "/resAlphaG20/resAlphaG20Test" );
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/getInterfaceIds")
	public ModelAndView getInterfaceIds (@RequestParam Map<String, Object> paramMap, ModelAndView mv) throws Exception {
		try {
			mv.addObject("interfaceIds", resAlphaG20Service.getInterfaceIds(paramMap));
			mv.addObject("result", "Success");
		} catch (Exception e) {
			logger.error(e.getMessage());
			mv.addObject("result", "Failed");
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/findOnnaraPopup")
	public String findOnnaraPopup ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		logger.info("/resAlphaG20/findOnnaraPopup");
		
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		
		Gson gson = new Gson();
		
		List<Map<String, Object>> allDept = commonService.getAllDept();
		
		model.addAttribute("allDept",  new Gson().toJson(allDept));
		model.addAttribute("deptSeq",  new Gson().toJson(loginVO.getDept_seq()));
		model.addAttribute("erpEmpSeq", loginVO.getErpEmpCd());
		model.addAttribute("organNm", new Gson().toJson(loginVO.getOrganNm()));
		model.addAttribute("orgnztNm", new Gson().toJson(loginVO.getOrgnztNm()));


		return "/resAlphaG20/pop/ONNARApopup";
	}
	
	@RequestMapping("/resAlphaG20/getOnnaraGrid")
	@ResponseBody
	public Map<String, Object> getOnnaraGrid ( @RequestParam HashMap<String, Object> requestMap, String[] erpEmpSeqArray, HttpServletRequest request, Model model ) throws Exception {
		logger.info("kukgoh/getOnnaraGrid");
		List<Map<String, Object>> onnaraDocList = null;
		
		Gson gson = new Gson();
		String data = String.valueOf(requestMap.get("erpEmpSeqJson"));		
		Type listType = new TypeToken<Map<String, String[]>>() {}.getType();
		Map<String, String[]> listMap = gson.fromJson(data, listType);
		
		String[] arr = (String[])listMap.get("paramArr");
		List<String> erpEmpSeqArr = new ArrayList<String>();
		
		for (String string : arr) {
			erpEmpSeqArr.add(string);
		}

		requestMap.put("erpEmpSeqArr", erpEmpSeqArr);
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			onnaraDocList = resAlphaG20Service.getOnnaraDocs(requestMap);
		} catch (Exception e) {
			logger.info("ERROR :", e);
		}
		
		resultMap.put("list", onnaraDocList);
		resultMap.put("totalCount", onnaraDocList.size());
		
		return resultMap;
	}
	
	@RequestMapping("/resAlphaG20/downloadDocFileAjax")
	@ResponseBody
	public Map<String, Object> downloadDocFileAjax ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = resAlphaG20Service.getOnnaraDocFile(requestMap);
		
		logger.info("resultMap : " + resultMap);
		
		return resultMap;
	}
	
	@RequestMapping(value = "/resAlphaG20/fileDownLoad")
	@ResponseBody 
	public void fileDownLoad(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws NoPermissionException, SftpException, IOException {
		logger.info("resAlphaG20/fileDownLoad");
		resAlphaG20Service.fileDown(map, servletRequest, servletResponse);
	}
	
	@RequestMapping(value = "/resAlphaG20/downloadFile")
	@ResponseBody 
	public void downloadFile(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws NoPermissionException, SftpException, IOException {
		logger.info("resAlphaG20/downloadFile");
		resAlphaG20Service.downloadFile(map, servletRequest, servletResponse);
	}
	
	@RequestMapping(value = "/resAlphaG20/makeZipFile")
	@ResponseBody 
	public Map<String, Object> makeZipFile(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest, HttpServletResponse servletResponse) throws NoPermissionException, SftpException, IOException {
		logger.info("resAlphaG20/makeZipFile");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) map.get("param");
		List<Map<String, Object>> resultList = gson.fromJson(jsonData, listType);
		
		try {
			String zipFileFullPath = resAlphaG20Service.makeZipFile(resultList, servletRequest, servletResponse);
			
			map.put("zipFileFullPath", zipFileFullPath);
		} catch (Exception e) {
			logger.info("makeZipFile ERROR : ", e);
		}
		
		return map;
	}
	
	/**
	 * @param resDocSeq or consDocSeq
	 * @return 
	 * @throws Exception
	 * 알파문서 headDocSeq로 온나라 정보 읽어오기
	 */
	@RequestMapping("/resAlphaG20/getDocMappingOnnara")
	@ResponseBody
	public Map<String, Object> getDocMappingOnnara ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultDocList = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> docList = null;
		
		try {
			
			logger.info("==================== getDocMappingOnnara ====================");
			
			docList = resAlphaG20Service.getDocMappingOnnaraDocId(requestMap);
			
			for (Map<String, Object> map : docList) {
				
				map.put("DOCID", map.get("o_docid"));
				
				Map<String, Object> docInfo = resAlphaG20Service.getOnnaraDocInfo(map);
				List<Map<String, Object>> attachList = resAlphaG20Service.getOnnaraDocAllFiles(map);
				
				if (attachList.size() > 0) {
					docInfo.put("attachVo", attachList);
				}
				
				resultDocList.add(docInfo);
			}
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
	    
	    resultMap.put("data", docList);
	    resultMap.put("resultDocList", resultDocList);
	    
		return resultMap;
	}
	
	/**
	 * @param resDocSeq or consDocSeq
	 * @return 
	 * @throws Exception
	 * 온나라 문서 <-> 알파 문서 맵핑 저장
	 */
	@RequestMapping("/resAlphaG20/saveOnnaraMapping")
	@ResponseBody
	public void saveOnnaraMapping ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		logger.info("============ saveOnnaraMapping ================");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) requestMap.get("data");
		List<Map<String, Object>> resultList = gson.fromJson(jsonData, listType);
		
		logger.info("============ saveOnnaraMapping End ================");
		
		try {
			resAlphaG20Service.updateOnnaraUsedStatus(requestMap);
			
			resAlphaG20Service.saveOnnaraMapping(resultList);
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
	}
	
	@RequestMapping("/resAlphaG20/openHwpDocumentPop")
	public String openHwpDocumentPop ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		model.addAttribute("hwpInfo", requestMap);
		model.addAttribute("onnaraFileSubPath", onnaraFileSubPath);
		
		return "/resAlphaG20/pop/hwpViewer";
	}
	
	/**
	 * 
		 * @MethodName : approvalProcessCustom
		 * @author : jy
		 * @since : 2020. 5. 19.
		 * 설명 : 결재 기안 시 실행
	 */
	@RequestMapping("/resAlphaG20/approvalProcessCustom")
	public ModelAndView approvalProcessCustom ( @RequestBody HashMap<String, Object> requestMap, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/approvalProcessCustom");
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		Map<String, Object> paramMap = new HashMap<>();
		
		try {
			
			logger.info("============ approvalProcessCustom ================");
			
			logger.info("requestMap : " + requestMap);
			if (requestMap.get("resDocSeq") != null && !"".equals(requestMap.get("resDocSeq"))) {
				requestMap.put("targetType", "resDocSeq");
				requestMap.put("targetSeq", requestMap.get("resDocSeq"));
			} else if (requestMap.get("consDocSeq") != null && !"".equals(requestMap.get("consDocSeq"))) {
				requestMap.put("targetType", "consDocSeq");
				requestMap.put("targetSeq", requestMap.get("consDocSeq"));
			}
			logger.info("requestMap : " + requestMap);
			
			resAlphaG20Service.saveUseOnnaraDocs(requestMap);
			
			requestMap.put("C_DIKEYCODE", requestMap.get("docSeq"));
			
			logger.info("============ approvalProcessCustom ================");
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * @MethodName : 결재 완료 시 동작
	 * @author : 이재용
	 * @since : 2020. 05. 25
	 * 설명 : 
	 */
	@RequestMapping("/resAlphaG20/endProcessCustom")
	public ModelAndView endProcessCustom ( @RequestBody HashMap<String, Object> requestMap, HttpServletRequest request, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/endProcessCustom");
		Map<String, Object> paramMap = new HashMap<>();
		String resultCode = "SUCCESS";
		String resultMessage = "성공하였습니다.";
		
		try {
			
			logger.info("============ endProcessCustom ================");
			
			logger.info("requestMap : " + requestMap);
			if (requestMap.get("resDocSeq") != null && !"".equals(requestMap.get("resDocSeq"))) {
				requestMap.put("targetType", "resDocSeq");
				requestMap.put("targetSeq", requestMap.get("resDocSeq"));
			} else if (requestMap.get("consDocSeq") != null && !"".equals(requestMap.get("consDocSeq"))) {
				requestMap.put("targetType", "consDocSeq");
				requestMap.put("targetSeq", requestMap.get("consDocSeq"));
			}
			logger.info("requestMap : " + requestMap);
			
			requestMap.put("C_DIKEYCODE", requestMap.get("docSeq"));
			
			Thread t = new Thread(new PdfEcmThread(requestMap, resAlphaG20Service, pdfServerRootPath, kukgohDAO));
			t.start();
			
			logger.info("============ endProcessCustom ================");
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		mv.addObject("resultCode", resultCode);
		mv.addObject("resultMessage", resultMessage);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * @MethodName : IE 전용 한글 뷰어
	 * @author : 이재용
	 * @since : 2018. 8. 21.
	 * 설명 : 
	 */
	@RequestMapping(value = "/resAlphaG20/annualSalaryViewDown", method = RequestMethod.GET)
	public void annualSalaryViewDown(@RequestParam Map<String, Object> map,HttpServletRequest request, HttpServletResponse response) {
		logger.info("annualSalaryViewDown");
		
		String resultPath = (String) map.get("filePath");
		String fileName = resultPath.split("/")[resultPath.split("/").length - 1];
		
		logger.info("annualSalaryViewDown : " + resultPath);
		logger.info("annualSalaryViewDown : !" + fileName);
		
		temFileDown(resultPath, fileName, response);
	}
	
	private void temFileDown(String filePath, String fileName, HttpServletResponse response){
		
		File file = new File(filePath);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				e.printStackTrace();
			}
	
			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(fileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null)
				response.setHeader( "Content-Length", file.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			FileDownload.outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
	}
	
	@RequestMapping("/resAlphaG20/moveFileToTemp.do")
	@ResponseBody
	public Map<String, Object> moveFileToTemp(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest servletRequest) throws NoPermissionException{
		
		logger.info("/resAlphaG20/moveFileToTemp");
		
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = req.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		Map<String, Object> resultMap = new HashMap<>();
		
		Gson gson = new Gson();
		String data = (String) paramMap.get("params");		
		Type listType = new TypeToken<String[]>() {}.getType();
		String[] params = gson.fromJson(data, listType);
		
		String fileKey = String.valueOf(paramMap.get("dj_fileKey"));
		
		if ("".equals(fileKey)) {
			fileKey = "Y" + java.util.UUID.randomUUID().toString();
		}
		try {
			
			for (String docId : params) {
				
				Map<String, Object> param = new HashMap<>();
				
				param.put("DOCID", docId);
				param.put("fileKey", fileKey);
				
				resAlphaG20Service.getOnnaraMovedFile(param);
				
			}			
		} catch (Exception e) {
			logger.info("ERROR : " , e);
		}
		
		resultMap.put("fileKey", fileKey);
		resultMap.put("empSeq", loginMap.get("empSeq"));
		resultMap.put("compSeq", loginMap.get("compSeq"));
		
		return resultMap;
	}
	
	@RequestMapping("/resAlphaG20/saveTradeBojo")
	@ResponseBody
	public void saveTradeBojo ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		logger.info("============ saveTradeBojo ================");
		
		try {
			
			resAlphaG20Service.saveTradeBojo(requestMap);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		logger.info("============ saveTradeBojo End ================");
	}
	
	@RequestMapping("/resAlphaG20/getTradeBojo")
	@ResponseBody
	public Map<String, Object> getTradeBojo ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		logger.info("============ getTradeBojo ================");
		
		try {
			
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			Gson gson = new Gson();
			String jsonData = (String) requestMap.get("data");
			List<Map<String, Object>> resultList = gson.fromJson(jsonData, listType);
			
			resAlphaG20Service.getTradeBojo(resultList);
			
			resultMap.put("resultList", resultList);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		logger.info("============ getTradeBojo End ================");
		
		return resultMap;
		
	}
	
	@RequestMapping("/resAlphaG20/updateTradeBojo")
	@ResponseBody
	public void updateTradeBojo ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		logger.info("============ updateTradeBojo ================");
		
		try {
			
			if ("bojoUse".equals(String.valueOf(requestMap.get("key"))) || "bojoReasonText".equals(String.valueOf(requestMap.get("key")))) {
				resAlphaG20Service.updateTradeBojo(requestMap);
			} else {
				throw new Exception("======= ERROR : bojoUse 혹은 bojoReasonText 가 아닙니다. =======");
			}
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		logger.info("============ updateTradeBojo End ================");
	}
	
	@RequestMapping("/resAlphaG20/getResTrade")
	public ModelAndView getResTrade( @RequestParam HashMap<String, Object> requestMap, ModelAndView mv) throws NoPermissionException{
		
		logger.info("============ getResTrade ================");
		
		try {
			
			mv.addObject("resTrade", resAlphaG20Service.getResTrade(requestMap));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		logger.info("============ getResTrade End ================");
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/pdfViewer")
	public void pdfTest ( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, ModelAndView mv ) throws Exception {
		
		logger.info("/logger/pdfTest");
		FileInputStream fis = null;
		BufferedOutputStream bos = null;
		
		try {
			
			String pdfFileName = String.valueOf(param.get("fileFullPath"));
			File pdfFile = new File(pdfFileName);
			
			fis = new FileInputStream(pdfFile);
			int size = fis.available();
			byte[] buf = new byte[size];
			int readCount = fis.read(buf);
			
			response.flushBuffer();
			bos = new BufferedOutputStream(response.getOutputStream());
			
			bos.write(buf, 0, readCount);
			bos.flush();
			
		} catch (Exception e) {
			logger.info("ERROR : " , e);
		} finally {
		    if (fis != null) fis.close(); //close는 꼭! 반드시!
		    if (bos != null) bos.close();
		}
	}
	
	@RequestMapping("/resAlphaG20/downloadDocFileAjaxToPDF")
	@ResponseBody
	public Map<String, Object> downloadDocFileAjaxToPDF ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = null;
		
		try {
			
			resultMap = resAlphaG20Service.getOnnaraDocFile(requestMap);
			
			String yyyyMM = String.valueOf(resultMap.get("yyyyMM"));
			String sFileName = String.valueOf(resultMap.get("SFILENAME")).split("\\.")[0];
			String fileFullPath = onnaraFileSubPath + "/" + yyyyMM + "/PDF_" + sFileName + ".pdf";
			
			File f = new File(fileFullPath);
			
			if (!f.exists()) {
				
				PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
				
				pdfEcmFileVO.setRep_id(yyyyMM + sFileName);
				pdfEcmFileVO.setComp_seq("1000");
				pdfEcmFileVO.setDoc_id("DOC" + sFileName);
				pdfEcmFileVO.setDoc_no("001");
				pdfEcmFileVO.setDoc_path(pdfServerRootPath + "upload/ea/cust/" + yyyyMM);
				pdfEcmFileVO.setDoc_ext("hwp");
				pdfEcmFileVO.setDoc_name(sFileName);
				pdfEcmFileVO.setDoc_title(String.valueOf(resultMap.get("FLETTL")));
				
				PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();
				
				pdfEcmMainVO.setRep_id(yyyyMM + sFileName);
				pdfEcmMainVO.setComp_seq("1000");
				pdfEcmMainVO.setDept_seq("1");
				pdfEcmMainVO.setEmp_seq("1");
				pdfEcmMainVO.setPdf_path(pdfServerRootPath + "upload/ea/cust/" + yyyyMM);
				pdfEcmMainVO.setPdf_name("PDF_" + sFileName);
				pdfEcmMainVO.setStatus_cd("D0001");
				
				resAlphaG20Service.savePdfEcmFile(pdfEcmFileVO);
				resAlphaG20Service.savePdfEcmMain(pdfEcmMainVO);
			}
			
			resultMap.put("fileFullPath", fileFullPath);
			
			while (!f.exists()) {
				Thread.sleep(400);
			}
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
	}
	
	@RequestMapping("/resAlphaG20/moveExcelFileToTemp.do")
	@ResponseBody
	public Map<String, Object> moveExcelFileToTemp( @RequestParam HashMap<String, Object> params, HttpServletRequest servletRequest) throws NoPermissionException{
		
		logger.info("/resAlphaG20/moveExcelFileToTemp");
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
		Map<String, Object> resultMap = new HashMap<>();
		String fileKey = String.valueOf(params.get("dj_fileKey"));
		
		if ("".equals(fileKey)) {
			fileKey = "Y" + java.util.UUID.randomUUID().toString();
		}
		
		try {
			
			List<Map<String, Object>> tradeList = resAlphaG20Service.getAllTradeInfo(params);
			
			for (Map<String, Object> tradeMap : tradeList) {
				
				String flag = String.valueOf(tradeMap.get("interface_type"));
				Map<String, Object> requestMap = new HashMap<String, Object>();
				
				if ("card".equals(flag)) {
					// 카드 처리
					requestMap.put("syncId", String.valueOf(tradeMap.get("interface_seq")));
					requestMap.put("CO_CD", loginMap.get("erpCompSeq"));
					
					makeCardExcel(tradeMap, requestMap, fileKey, servletRequest);
					
				} else if ("etax".equals(flag)) {
					// 세금계산서 처리
					requestMap.put("syncId", String.valueOf(tradeMap.get("interface_seq")));
					
					makeEtaxExcel(tradeMap, requestMap, fileKey, servletRequest);
				}
				
			}
		} catch (Exception e) {
			logger.info("전표생성 ERROR : " , e);
		} finally {
			resultMap.put("fileKey", fileKey);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : 전자세금계산서 전표 excel 파일 
	 * @author : 이재용 feat.문형진
	 * @throws Exception 
	 * @since : 2020. 06. 17.
	 * 설명 : 
	 */
	public void makeEtaxExcel(Map<String, Object> tradeMap, Map<String, Object> requestMap, String fileKey ,HttpServletRequest request) throws Exception {
		
		Map<String, Object> excelMap = new HashMap<String, Object>();
		Map<String, Object> tmpMap = resAlphaG20Service.getIssNo(requestMap);
		Map<String, Object> etaxInfoMap = resAlphaG20Service.selectETaxDetailInfo(tmpMap);
		
		String taxTy = String.valueOf(etaxInfoMap.get("taxTy"));
        String prefix = "";
        if ("1".equals(taxTy) || "2".equals(taxTy)) {
        	prefix = "전자세금계산서";
        } else if ("3".equals(taxTy) || "4".equals(taxTy)) {
        	prefix = "전자계산서";
        } else {
        	prefix = "매입세금계산서";
        }
		
        excelMap.put("title", prefix);
        
		//승인번호
		excelMap.put("authNum", String.valueOf(etaxInfoMap.get("authNum")));
		
		/**
		 *  공급자
		 */
		// 등록번호
		excelMap.put("lSaupNum", String.valueOf(etaxInfoMap.get("lSaupNum")));
		// 상호
		excelMap.put("lTrName", String.valueOf(etaxInfoMap.get("lTrName")));
		// 명칭
		excelMap.put("lCeoName", String.valueOf(etaxInfoMap.get("lCeoName")));
		// 사업장 주소
		excelMap.put("lDivAddr", String.valueOf(etaxInfoMap.get("lDivAddr")) + String.valueOf(etaxInfoMap.get("lDivAddr2")));
		// 종목
		excelMap.put("lJongmokName", String.valueOf(etaxInfoMap.get("lJongmokName")));
		// 종사업장번호
		excelMap.put("lJongmokNum", String.valueOf(etaxInfoMap.get("lJongmokNum")));
		// 업태
		excelMap.put("lBusinessType", String.valueOf(etaxInfoMap.get("lBusinessType")));
		// 부서명
		excelMap.put("lDeptName", String.valueOf(etaxInfoMap.get("lDeptName")));
		// 담당자
		excelMap.put("lEmpName", String.valueOf(etaxInfoMap.get("lEmpName")));
		// 연락처
		excelMap.put("lTell", String.valueOf(etaxInfoMap.get("lTell")));
		// 휴대폰
		excelMap.put("lCellPhone", String.valueOf(etaxInfoMap.get("lCellPhone")));
		// 이메일
		excelMap.put("lEmail", String.valueOf(etaxInfoMap.get("lEmail")));
		
		/**
		 *  공급받는자
		 */
		// 등록번호
		excelMap.put("rSaupNum", String.valueOf(etaxInfoMap.get("rSaupNum")));
		// 상호
		excelMap.put("rTrName", String.valueOf(etaxInfoMap.get("rTrName")));
		// 명칭
		excelMap.put("rCeoName", String.valueOf(etaxInfoMap.get("rCeoName")));
		// 사업장 주소
		excelMap.put("rDivAddr", String.valueOf(etaxInfoMap.get("rDivAddr") + String.valueOf(etaxInfoMap.get("rDivAddr2"))));
		// 종목
		excelMap.put("rJongmokName", String.valueOf(etaxInfoMap.get("rJongmokName")));
		// 종사업장번호
		excelMap.put("rJongmokNum", String.valueOf(etaxInfoMap.get("rJongmokNum")));
		// 업태
		excelMap.put("rBusinessType", String.valueOf(etaxInfoMap.get("rBusinessType")));
		// 이메일
		excelMap.put("rEmail", String.valueOf(etaxInfoMap.get("rEmail")));
		
		/**
		 *  하단 공통
		 */
		
		String stdAmt = String.format("%,d",Integer.valueOf(String.valueOf(etaxInfoMap.get("stdAmt"))));
		String vatAmt = String.format("%,d",Integer.valueOf(String.valueOf(etaxInfoMap.get("vatAmt"))));
		String amt = String.format("%,d",Integer.valueOf(String.valueOf(etaxInfoMap.get("amt"))));
		
		
		// 작성일자
		excelMap.put("lssDate", String.valueOf(etaxInfoMap.get("lssDate")));
		// 작성일자 (년)
		excelMap.put("year", String.valueOf(etaxInfoMap.get("issDate")).substring(0, 4));
		// 작성일자 (월)
		excelMap.put("month", String.valueOf(etaxInfoMap.get("issDate")).substring(4, 6));
		// 작성일자 (일)
		excelMap.put("date", String.valueOf(etaxInfoMap.get("issDate")).substring(6, 8));	
		// 공급가액
		excelMap.put("stdAmt", stdAmt);
		// 세액
		excelMap.put("vatAmt", vatAmt);
		// 항목
		excelMap.put("mainItemDc", String.valueOf(etaxInfoMap.get("mainItemDc")));
		// 비고
		excelMap.put("dummy1", String.valueOf(etaxInfoMap.get("dummy1")));
		// 단가
		excelMap.put("amt", amt);
		// 이 금액을 - 함
		excelMap.put("dummy", String.valueOf(etaxInfoMap.get("dummy2")));
		
		/**
		 *   여기서 부터 excelMap 정보와 fileKey로 temp파일 만들기 
		 */
		
		Map<String, Object> beans  = new HashMap<String, Object>();
		
		List<Map<String, Object>> list = new ArrayList<>();
		
		list.add(excelMap);
		
		
		beans.put("list", list);
		
        try {
        	
        	//템플릿 엑셀파일 위치
        	String path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + "cashTemplete.xlsx");
        	
        	InputStream is = new BufferedInputStream(new FileInputStream(path));
            
        	
        	XLSTransformer transformer = new XLSTransformer();
            Workbook resultWorkbook = transformer.transformXLS(is, beans);
            
            String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");

        	File dir = new File(tempPath+fileKey);
            
            if(!dir.isDirectory()){
            	CommFileUtil.makeDir(tempPath + fileKey);
            }
            
            OutputStream os = new FileOutputStream(new File(tempPath + fileKey + File.separator + prefix + "_"+String.valueOf(etaxInfoMap.get("authNum"))+".xlsx"));
            
            resultWorkbook.write(os);
            os.close();
            
            logger.info("매입세금계산서 만들었어요오~~");
           
        } catch (ParsePropertyException | InvalidFormatException | IOException ex) {
        	  logger.info("매입세금못만듬 ㅡㅡ;", ex);
        }	
		
		
		
		
		
		
		
	}
	
	/**
	 * @MethodName : 전자세금계산서 전표 excel 파일 
	 * @author : 이재용 feat.문형진
	 * @throws Exception 
	 * @since : 2020. 06. 17.
	 * 설명 : 
	 */
	public void makeCardExcel(Map<String, Object> tradeMap, Map<String, Object> requestMap, String fileKey,HttpServletRequest request) throws Exception {
		
		Map<String, Object> excelMap = new HashMap<String, Object>();
		Map<String, Object> cardInfoMap = resAlphaG20Service.userCardDetailInfo(requestMap);
		
		String amt_md_amount = String.format("%,d", Integer.valueOf(String.valueOf(cardInfoMap.get("amt_md_amount"))));
		String vat_md_amount = String.format("%,d", Integer.valueOf(String.valueOf(cardInfoMap.get("vat_md_amount"))));
		String serAmount = String.format("%,d", Integer.valueOf(String.valueOf(cardInfoMap.get("serAmount"))));
		String requestAmount =String.format("%,d", Integer.valueOf(String.valueOf(cardInfoMap.get("requestAmount"))));
		
		// 카드번호
		excelMap.put("cardNum", fn_cardNum(String.valueOf(cardInfoMap.get("cardNum"))));
		// 승인일시
		excelMap.put("authDate", fn_authDate(String.valueOf(cardInfoMap.get("authDate")) + String.valueOf(cardInfoMap.get("authTime"))));
		// 승인번호
		excelMap.put("authNum", String.valueOf(cardInfoMap.get("authNum")));
		// 가맹점명
		excelMap.put("mercName", String.valueOf(cardInfoMap.get("mercName")));
		// 사업자번호
		excelMap.put("mercSaupNo", String.valueOf(cardInfoMap.get("mercSaupNo")));
		// 주소
		excelMap.put("mercAddr", String.valueOf(cardInfoMap.get("mercAddr")));
		// 전화번호
		excelMap.put("mercTel", String.valueOf(cardInfoMap.get("mercTel")));
		// 공급가액
		excelMap.put("amtMdAmount", amt_md_amount);
		// 부가세
		excelMap.put("vatMdAmount", vat_md_amount);
		// 서비스금액
		excelMap.put("serAmount", serAmount);
		// 금액
		excelMap.put("requestAmount", requestAmount);
		
		/**
		 *   여기서 부터 excelMap 정보와 fileKey로 temp파일 만들기 
		 */
		
		
		
		Map<String, Object> beans  = new HashMap<String, Object>();
				
				List<Map<String, Object>> list = new ArrayList<>();
				
				list.add(excelMap);
				
		
				beans.put("list", list);
		
        try {
        	
        	//템플릿 엑셀파일 위치
        	String path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + "cardTemplete.xlsx");
        	
        	InputStream is = new BufferedInputStream(new FileInputStream(path));
            
        	
        	XLSTransformer transformer = new XLSTransformer();
            Workbook resultWorkbook = transformer.transformXLS(is, beans);
            
            
            String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
            File dir = new File(tempPath+fileKey);
            
            if(!dir.isDirectory()){
            	CommFileUtil.makeDir(tempPath + fileKey);
            }
            	
            // 저장경로 : 템프파일 경로/파일키/카드승인전표_승인키.xlsx 으로 저장
            OutputStream os = new FileOutputStream(new File(tempPath + fileKey + File.separator + "카드승인전표_"+String.valueOf(cardInfoMap.get("authNum"))+".xlsx"));
           
            resultWorkbook.write(os);
            os.close();
            
            logger.info("카드승인전표 만들렀다요네");
           
        } catch (ParsePropertyException | InvalidFormatException | IOException ex) {
        	  logger.info("카드승인전표 작성 실패....",ex);
        }	
		
		
		
		
		
		
		
	}
	
	public String fn_cardNum(String str) {
		
		String result = "";
		
		if (str.length() == 16) {
			result = str.substring(0, 4) + "-" + str.substring(4, 8) + "-" + str.substring(8, 12) + "-" + str.substring(12);
		}
		
		return result;
	}
	
	public String fn_authDate(String str) {
		
		String result = str.substring(0, 4) + "-" + str.substring(4, 6) + "-" + str.substring(6, 8) + " " + str.substring(8, 10) + ":" + str.substring(10, 12) + ":" + str.substring(12);
		
		return result;
	}
	
	@RequestMapping("/resAlphaG20/moveExcelFileToTempWorkFee")
	@ResponseBody
	public Map<String, Object> moveExcelFileToTempWorkFee( @RequestParam HashMap<String, Object> params, HttpServletRequest servletRequest){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//템플릿 파일명
		String templeteName = "workFeeTemplate.xlsx";
		
		//저장파일 이름
		String resultFileName = "업무추진비 집행내역 및 추진결과.xlsx";
		
		String fileKey = "Y" + java.util.UUID.randomUUID().toString();
		
        try {
        	
        	resAlphaG20Service.saveWorkFee(params);
        	
        	//템플릿 엑셀파일 위치
        	String path = servletRequest.getSession().getServletContext().getRealPath("/exceltemplate/" + templeteName);
        	
        	InputStream is = new BufferedInputStream(new FileInputStream(path));
        	
        	XLSTransformer transformer = new XLSTransformer();
            
        	Workbook resultWorkbook = transformer.transformXLS(is, params);
            
            String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
            
            File dir = new File(tempPath+fileKey);
            
            if(!dir.isDirectory()){
            	CommFileUtil.makeDir(tempPath + fileKey);
            }
            	
            OutputStream os = new FileOutputStream(new File(tempPath + fileKey + File.separator + resultFileName));
           
            resultWorkbook.write(os);
            os.close();
            
            logger.info("excel파일 만들었다");
           
        } catch (Exception ex) {
        	  logger.info("excel파일 실패....",ex);
        } finally {
        	resultMap.put("dj_fileKey", fileKey);
		}
        
        return resultMap;
	}
	@RequestMapping("/resAlphaG20/moveExcelFileToTempDailyExp")
	@ResponseBody
	public Map<String, Object> moveExcelFileToTempDailyExp(@RequestParam Map<String, Object> maps, HttpServletRequest servletRequest){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//템플릿 파일명
		String templeteName = "dailyExpTemplate.xlsx";
		
		//저장파일 이름
		String resultFileName = "일상경비 사용내역.xlsx";
		
		String fileKey = "Y" + java.util.UUID.randomUUID().toString();
		
		try {
			
			String params = (String) maps.get("list");	
			// params = String 형태의 배열오브젝트 "[{}, {}] ;
			
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			Gson gson = new Gson();
			
			// 파싱
			List<Map<String, Object>> lists = gson.fromJson(params, listType);
			
			Map<String, Object> param = new HashMap<String,Object>();
			
			param.put("resDocSeq", lists.get(0).get("resDocSeq"));
			param.put("data", params);
			
			// insert
			resAlphaG20Service.saveDailyExp(param);
			
			
			int total = 0;
			String totalComma ="";
			
			// 세션-> loginVo-> 부서명 가져오자
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			String deptNm =String.valueOf(loginMap.get("organNm"));
			
			for(Map<String, Object> map : lists ) {
				
				total += Integer.valueOf(String.valueOf(map.get("djDailyExpAmt")).replaceAll(",", ""));
			}
			
			//3자리 컴마
			DecimalFormat df = new DecimalFormat( "#,##0" );
			
			totalComma = df.format(total);
			
			Map<String, Object> bean = new HashMap<String,Object>();
			
			bean.put("list", lists);
			bean.put("deptNm", deptNm);
			bean.put("title", lists.get(0).get("title"));
			bean.put("totalAmt", totalComma);
			
			//템플릿 엑셀파일 위치
			String path = servletRequest.getSession().getServletContext().getRealPath("/exceltemplate/" + templeteName);
			
			InputStream is = new BufferedInputStream(new FileInputStream(path));
			
			XLSTransformer transformer = new XLSTransformer();
			
			
			
			Workbook resultWorkbook = transformer.transformXLS(is, bean);
			
			String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
			
			File dir = new File(tempPath+fileKey);
			
			if(!dir.isDirectory()){
				CommFileUtil.makeDir(tempPath + fileKey);
			}
			
			OutputStream os = new FileOutputStream(new File(tempPath + fileKey + File.separator + resultFileName));
			
			resultWorkbook.write(os);
			os.close();
			
			logger.info("excel파일 만들었다");
			
		} catch (Exception ex) {
			logger.info("excel파일 실패....",ex);
		} finally {
			resultMap.put("dj_fileKey", fileKey);
		}
		
		return resultMap;
	}
	
	@RequestMapping("/resAlphaG20/getWorkFee")
	public ModelAndView getWorkFee(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		try {
			mv.addObject("workFee", resAlphaG20Service.getWorkFee(paramMap));
			mv.addObject("result", "Success");
		} catch (Exception e) {
			logger.error(e.getMessage());
			mv.addObject("result", "Failed");
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	@RequestMapping("/resAlphaG20/getDailyExp")
	public ModelAndView getDailyExp(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		try {
			
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			Gson gson = new Gson();
			
			// 파싱
			List<Map<String, Object>> lists = gson.fromJson((String)resAlphaG20Service.getDailyExp(paramMap), listType);
			
			mv.addObject("dailyExp", lists);
			
			mv.addObject("result", "Success");
		} catch (Exception e) {
			logger.error(e.getMessage());
			mv.addObject("result", "Failed");
		}
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping("/resAlphaG20/convertPdfToBase64")
	@ResponseBody
	public Map<String, Object> base64Test(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		final boolean IS_CHUNKED = true;
		
		String pdfFileName = String.valueOf(paramMap.get("fileFullPath"));
		
		try {
			
			byte[] base64EncodedData = Base64.encodeBase64(loadFileAsBytesArray(pdfFileName), IS_CHUNKED);
			
			String base64Code = new String(base64EncodedData);
			
			resultMap.put("base64Code", base64Code);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return resultMap;
	}
	
	@RequestMapping("/resAlphaG20/pdfViewerIE")
	public void base64TestEx(@RequestParam Map<String, Object> paramMap, ModelAndView mv, HttpServletResponse response){
		
		String sourceFile = String.valueOf(paramMap.get("fileFullPath"));
		
		try {
			
			byte[] fileByte = FileUtils.readFileToByteArray(new File(sourceFile));
			 
			response.setContentType("application/pdf");
			response.setContentLength(fileByte.length);
			 
			response.setHeader("Content-Disposition", "inline; fileName=\"" + URLEncoder.encode(sourceFile, "UTF-8") + "\";");
			response.getOutputStream().write(fileByte);
			 
			response.getOutputStream().flush();
			response.getOutputStream().close();

		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
	}
	
	public static byte[] loadFileAsBytesArray(String fileName) throws Exception {

        File file = new File(fileName);
        int length = (int) file.length();
        BufferedInputStream reader = new BufferedInputStream(new FileInputStream(file));
        byte[] bytes = new byte[length];
        reader.read(bytes, 0, length);
        reader.close();
        return bytes;
    }
	
	@RequestMapping("/resAlphaG20/getErpEmpSeqInDept")
	@ResponseBody
	public Map<String, Object> getErpEmpSeqInDept(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			List<Map<String, Object>> list = resAlphaG20Service.getErpEmpSeqInDept(paramMap);
			
			resultMap.put("list", list);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return resultMap;
	}
	
	@RequestMapping("/resAlphaG20/getCardInfoG20")
	@ResponseBody
	public Map<String, Object> getCardInfoG20(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			paramMap.put("BANK_CD", "");
			paramMap.put("BANK_NM", "");
			paramMap.put("ACCT_NO", "");
				
			resAlphaG20Service.getCardInfoG20(paramMap);
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return paramMap;
	}
	
	/**
	 * 
	 * @MethodName : G20에 미등록된 거래처 리스트 조회 화면 이동 컨트롤러
	 * @author : 이재용
	 * @since : 2020. 06. 29
	 * 설명 : 그룹웨어 알파 (카드, 세금계산서) 승인내역에는 있지만 G20에 미등록된 거래처 리스트 조회 화면
	 */
	@RequestMapping("/resAlphaG20/unRgisteredSaupListPage")
	public String unRgisteredSaupListPage(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("loginMap", loginMap);
			model.addAttribute("CO_CD", loginMap.get("erpCompSeq"));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return "/resAlphaG20/unRegisteredSaup";
	}
	
	/**
	 * @MethodName : G20에 미등록된 거래처 리스트 조회
	 * @author : 이재용
	 * @since : 2020. 06. 29
	 * 설명 : 그룹웨어 알파 (카드, 세금계산서) 승인내역에는 있지만 G20에 미등록된 거래처 리스트 조회
	 */
	@RequestMapping("/resAlphaG20/getRegisteredSaupList")
	@ResponseBody
	public Map<String, Object> getRegisteredSaupList(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
		
		try {
			List<Map<String, Object>> list = resAlphaG20Service.getUnRegisteredSaupList(paramMap);
			
			for (Map<String, Object> map : list) {
				map.put("CO_CD", paramMap.get("CO_CD"));
				int cnt = resAlphaG20Service.checkUnRegister(map);
				
				if (cnt == 0) {
					resultList.add(map);
				}
			}
			
			resultMap.put("list", resultList);
			resultMap.put("total", resultList.size());
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : G20에 미등록된 거래처 리스트 디테일 조회
	 * @author : 이재용
	 * @since : 2020. 07. 23
	 * 설명 : 그룹웨어 알파 (카드, 세금계산서) 승인내역에는 있지만 G20에 미등록된 거래처 리스트  디테일 조회
	 */
	@RequestMapping("/resAlphaG20/getRegisteredSaupDetailList")
	@ResponseBody
	public Map<String, Object> getRegisteredSaupDetailList(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
		
		try {
			List<Map<String, Object>> list = resAlphaG20Service.selectCardSeunginList(paramMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : Card 사용 여부 롤백
	 * @author : 이재용
	 * @since : 2020. 07. 15
	 * 설명 : 카드 롤백 설정 화면
	 */
	@RequestMapping("/resAlphaG20/rollbackCard")
	@ResponseBody
	public Map<String, Object> rollbackCard(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
            if(paramMap.get("statVal").toString() == "Y" || paramMap.get("statVal").equals("Y")){
                Map<String, Object> cardReturnInfo = resAlphaG20Service.selectReturnCardLogInfo(paramMap);

                resAlphaG20Service.saveReturnCardLog(cardReturnInfo);
                resAlphaG20Service.saveReturnCardHist(cardReturnInfo);

                resAlphaG20Service.updateCardAqTmp(paramMap);
                resAlphaG20Service.updateRestradeTbl(paramMap);
            } else {
                Map<String, Object> cardHist = resAlphaG20Service.cardHistRollback(paramMap);

                resAlphaG20Service.updateCardAqTmpRollback(cardHist);
                resAlphaG20Service.updateRestradeTblRollback(cardHist);
            }

		} catch (Exception e) {
			logger.info("Rollback ERROR : ", e);
		}
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : Etax 사용 여부 롤백
	 * @author : 이재용
	 * @since : 2020. 07. 28
	 * 설명 : 세금계산서 롤백 설정 화면
	 */
	@RequestMapping("/resAlphaG20/rollbackEtax")
	@ResponseBody
	public Map<String, Object> rollbackEtax(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {

            Map<String, Object> tmpMap = resAlphaG20Service.getEtaxSyncId(paramMap);

			if (tmpMap != null) {

                if(paramMap.get("statVal").toString() == "Y" || paramMap.get("statVal").equals("Y")){

                    // 반환 로그 테이블에 저장 res_return_etax_log
                    Map<String, Object> etaxReturnInfo = resAlphaG20Service.selectReturnEtaxLogInfo(tmpMap);
                    resAlphaG20Service.saveReturnEtaxLog(etaxReturnInfo);
                    resAlphaG20Service.saveReturnEtaxHist(etaxReturnInfo);

                    String syncId = String.valueOf(tmpMap.get("sync_id"));

                    if (syncId != null && !"".equals(syncId)) {
                        paramMap.put("syncId", syncId);

                        resAlphaG20Service.updateEtaxAqTmp(paramMap);
                        resAlphaG20Service.updateRestradeTbl(paramMap);
                    } else {
                        resultMap.put("OUT_MSG", "카드 사용정보가 없습니다.");
                    }
                } else {
//                    Map<String, Object> cardHist = resAlphaG20Service.cardHistRollback(paramMap);
//
//                    resAlphaG20Service.updateCardAqTmpRollback(cardHist);
//                    resAlphaG20Service.updateRestradeTblRollback(cardHist);

                    Map<String, Object> etaxHist = resAlphaG20Service.etaxHistRollback(tmpMap);

                    resAlphaG20Service.updateEtaxAqTmpRollback(etaxHist);
                    resAlphaG20Service.updateRestradeTblRollback(etaxHist);
                }

			} else {
				resultMap.put("OUT_MSG", "사용정보가 없습니다.");
			}
		} catch (Exception e) {
			logger.info("Rollback ERROR : ", e);
		}
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : makeFileKey
	 * @author : pjm
	 * @since : 2020. 07. 20
	 * 설명 : 알파 전자결재 임시파일키 생성
	 */
	@RequestMapping("/resAlphaG20/makeFileKey")
	@ResponseBody
	public Map<String, Object> makeFileKey( @RequestParam HashMap<String, Object> params, HttpServletRequest servletRequest){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String fileKey = "Y" + java.util.UUID.randomUUID().toString();
		
        try {
        	
            String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
            
            File dir = new File(tempPath+fileKey);
            
            if(!dir.isDirectory()){
            	CommFileUtil.makeDir(tempPath + fileKey);
            }
            	
            logger.info("fileKey 생성");
           
        } catch (Exception ex) {
        	  logger.info("fileKey 생성 실패....",ex);
        } finally {
        	resultMap.put("dj_fileKey", fileKey);
		}
        
        return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : card 팝업 주소,전화 (하나로브랜치) 조회
	 * @author : 이재용
	 * @since : 2020. 07. 30
	 * 설명 : 하나로브랜치에서 주소, 전화 조회
	 */
	@RequestMapping("/resAlphaG20/getBranchTradeInfo")
	@ResponseBody
	public Map<String, Object> getBranchTradeInfo(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		Map<String, Object> resultMap = null;
		
		try {
			
			resultMap = resAlphaG20Service.getBranchTradeInfo(paramMap);
			
		} catch (Exception e) {
			logger.info("Branch ERROR : ", e);
		}
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : selectPdfErrorDocs
	 * @author : 이재용
	 * @since : 2020. 09. 09
	 * 설명 : PDF 솔루션 실패 리스트 조회
	 */
	@RequestMapping("/resAlphaG20/selectPdfErrorDocs")
	@ResponseBody
	public Map<String, Object> selectPdfErrorDocs(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== selectPdfErrorDocs ==");
	
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			List<Map<String, Object>> list = resAlphaG20Service.selectPdfErrorDocs(paramMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("selectPdfErrorDocs ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : selectPdfErrorDocsPage
	 * @author : 이재용
	 * @since : 2020. 09. 09
	 * 설명 : 
	 */
	@RequestMapping("/resAlphaG20/viewPdfErrorDocs")
	public String selectPdfErrorDocsPage(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("loginMap", loginMap);
			model.addAttribute("CO_CD", loginMap.get("erpCompSeq"));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return "/resAlphaG20/viewPdfErrorDocs";
	}
	
	/**
	 * 
	 * @MethodName : 일계표, 전표 최종 다운로드 페이지
	 * @author : 이재용
	 * @since : 2020. 11. 10
	 * 설명 : 일계표, 전표 최종 다운로드 페이지
	 */
	@RequestMapping("/resAlphaG20/downloadFinalDocsView")
	public String downloadFinalDocsView(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("loginMap", loginMap);
			model.addAttribute("CO_CD", loginMap.get("erpCompSeq"));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return "/resAlphaG20/downloadFinalDocsView";
	}
	
	/**
	 * 
	 * @MethodName : selectAdocuAndDailyDocs
	 * @author : 이재용
	 * @since : 2020. 11. 10
	 * 설명 : 인계표, 전표 최종 리스트 조회
	 */
	@RequestMapping("/resAlphaG20/selectAdocuAndDailyDocs")
	@ResponseBody
	public Map<String, Object> selectAdocuAndDailyDocs(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== selectAdocuAndDailyDocs ==");
	
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			List<Map<String, Object>> list = resAlphaG20Service.selectAdocuListByFillDt(paramMap);
			
			for (Map<String, Object> map : list) {
				String pdf_path = String.valueOf(map.get("pdf_path"));
				String pdf_name = String.valueOf(map.get("pdf_name"));
				
				File f = new File("/home" + pdf_path.substring(2) + "/" + pdf_name + ".pdf");
				
				if (f.exists()) {
					map.put("fileSize", f.length());
				} else {
					map.put("fileSize", 0);
				}
			}
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("selectAdocuAndDailyDocs ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : selectCardFullList
	 * @author : 이재용
	 * @since : 2020. 11. 12
	 * 설명 : 카드사용현황 리스트 조회
	 */
	@RequestMapping("/resAlphaG20/selectCardFullList")
	@ResponseBody
	public Map<String, Object> selectCardFullList(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== selectCardFullList ==");
	
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			List<Map<String, Object>> list = resAlphaG20Service.selectCardFullList(paramMap);
			
			resultMap.put("list", list);
			resultMap.put("total", resAlphaG20Service.selectCardFullListTotal(paramMap));
			
		} catch (Exception e) {
			logger.info("selectCardFullList ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : customCardList
	 * @author : 이재용
	 * @since : 2020. 11. 12
	 * 설명 : 커스텀 카드 사용 내역 현황
	 */
	@RequestMapping("/resAlphaG20/customCardList")
	public String customCardList(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("loginMap", loginMap);
			model.addAttribute("CO_CD", loginMap.get("erpCompSeq"));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return "/resAlphaG20/customCardList";
	}	
	
	/**
	 * 
	 * @MethodName : saveSelfPayCard
	 * @author : 이재용
	 * @since : 2020. 11. 12
	 * 설명 : 자부담 금액 저장
	 */
	@RequestMapping("/resAlphaG20/saveSelfPayCard")
	@ResponseBody
	public Map<String, Object> saveSelfPayCard(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== saveSelfPayCard ==");
	
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.saveSelfPayCard(paramMap);
			
		} catch (Exception e) {
			logger.info("saveSelfPayCard ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : updateSelfPayCard
	 * @author : 이재용
	 * @since : 2020. 11. 12
	 * 설명 : 자부담 금액 수정
	 */
	@RequestMapping("/resAlphaG20/updateSelfPayCard")
	@ResponseBody
	public Map<String, Object> updateSelfPayCard(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== updateSelfPayCard ==");
	
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.updateSelfPayCard(paramMap);
			
		} catch (Exception e) {
			logger.info("updateSelfPayCard ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : saveAdjustPayCard
	 * @author : 이재용
	 * @since : 2020. 11. 13
	 * 설명 : 조정 금액 등록
	 */
	@RequestMapping("/resAlphaG20/saveAdjustPayCard")
	@ResponseBody
	public Map<String, Object> saveAdjustPayCard(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== saveAdjustPayCard ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.saveAdjustPayCard(paramMap);
			
		} catch (Exception e) {
			logger.info("saveAdjustPayCard ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : updateAdjustPayCard
	 * @author : 이재용
	 * @since : 2020. 11. 13
	 * 설명 : 조정 금액 수정
	 */
	@RequestMapping("/resAlphaG20/updateAdjustPayCard")
	@ResponseBody
	public Map<String, Object> updateAdjustPayCard(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== updateAdjustPayCard ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.updateAdjustPayCard(paramMap);
			
		} catch (Exception e) {
			logger.info("updateAdjustPayCard ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : saveCardNotionInfo
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 사원 매핑 등록
	 */
	@RequestMapping("/resAlphaG20/saveCardNotionInfo")
	@ResponseBody
	public Map<String, Object> saveCardNotionInfo(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== saveCardNotionInfo ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("isSucc", true);
		
		try {
			
			List<Map<String, Object>> cardNotionList = resAlphaG20Service.selectCardNotionInfoList(paramMap);
			
			if (cardNotionList.size() > 0) { // 이미 등록되있는 사원일 경우
				resultMap.put("isSucc", false);
			} else {
				resAlphaG20Service.saveCardNotionInfo(paramMap);
			}
			
		} catch (Exception e) {
			resultMap.put("isSucc", false);
			logger.info("saveCardNotionInfo ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : deleteCardNotionInfo
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 사원 매핑 삭제
	 */
	@RequestMapping("/resAlphaG20/deleteCardNotionInfo")
	@ResponseBody
	public Map<String, Object> deleteCardNotionInfo(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== deleteCardNotionInfo ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.deleteCardNotionInfo(paramMap);
			
		} catch (Exception e) {
			logger.info("deleteCardNotionInfo ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : selectCardNotionInfoList
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 사원 매핑 리스트 조회
	 */
	@RequestMapping("/resAlphaG20/selectCardNotionInfoList")
	@ResponseBody
	public Map<String, Object> selectCardNotionInfoList(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== selectCardNotionInfoList ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			List<Map<String, Object>> list = resAlphaG20Service.selectCardNotionInfoList(paramMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("selectCardNotionInfoList ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : selectCardNotionCycle
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 주기 조회
	 */
	@RequestMapping("/resAlphaG20/selectCardNotionCycle")
	@ResponseBody
	public Map<String, Object> selectCardNotionCycle(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== selectCardNotionCycle ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resultMap.put("cycleMap", resAlphaG20Service.selectCardNotionCycle(paramMap)); 
			
		} catch (Exception e) {
			logger.info("selectCardNotionCycle ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : saveCardNotionCycle
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 주기 저장
	 */
	@RequestMapping("/resAlphaG20/saveCardNotionCycle")
	@ResponseBody
	public Map<String, Object> saveCardNotionCycle(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== saveCardNotionCycle ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			Map<String, Object> map = resAlphaG20Service.selectCardNotionCycle(paramMap);
			
			if (map == null) {
				resAlphaG20Service.saveCardNotionCycle(paramMap);
			} else {
				resAlphaG20Service.updateCardNotionCycle(paramMap);
			}
			
			
		} catch (Exception e) {
			logger.info("saveCardNotionCycle ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : updateCardNotionCycle
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 주기 수정
	 */
	@RequestMapping("/resAlphaG20/updateCardNotionCycle")
	@ResponseBody
	public Map<String, Object> updateCardNotionCycle(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== updateCardNotionCycle ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.updateCardNotionCycle(paramMap);
			
		} catch (Exception e) {
			logger.info("updateCardNotionCycle ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : cardNotionSettingView
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 알림 설정 페이지
	 */
	@RequestMapping("/resAlphaG20/cardNotionSettingView")
	public String cardNotionSettingView(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			Map<String, Object> param = new HashMap<String, Object>();
			String cycle = "0";
			
			param.put("interfaceType", "card");
			
			Map<String, Object> map = resAlphaG20Service.selectCardNotionCycle(param);
			
			if (map != null) {
				cycle = String.valueOf(map.get("cycle"));
			} 
			
			model.addAttribute("cycle", cycle);
			model.addAttribute("loginMap", loginMap);
			model.addAttribute("CO_CD", loginMap.get("erpCompSeq"));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return "/resAlphaG20/cardNotionSettingView";
	}
	
	/**
	 * 
	 * @MethodName : selectCardInfoList
	 * @author : 이재용
	 * @since : 2020. 11. 18
	 * 설명 : 카드 정보 리스트
	 */
	@RequestMapping("/resAlphaG20/selectCardInfoList")
	@ResponseBody
	public Map<String, Object> selectCardInfoList(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== selectCardInfoList ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			List<Map<String, Object>> list = resAlphaG20Service.selectCardInfoList(paramMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("selectCardInfoList ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : customEtaxList
	 * @author : 이재용
	 * @since : 2020. 11. 25
	 * 설명 : 커스텀 세금계산서 사용 내역 현황
	 */
	@RequestMapping("/resAlphaG20/customEtaxList")
	public String customEtaxList(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Map<String, Object> loginMap = commonService.commonGetEmpInfo(servletRequest);
			
			model.addAttribute("loginMap", loginMap);
			model.addAttribute("CO_CD", loginMap.get("erpCompSeq"));
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		return "/resAlphaG20/customEtaxList";
	}
	
	/**
	 * @param getMoniteringEtaxList
	 * @return 
	 * @throws Exception
	 * 세금계산서 모니터링 페이지
	 */
	@RequestMapping("/resAlphaG20/getMoniteringEtaxList")
	@ResponseBody
	public Map<String, Object> getMoniteringEtaxList ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<>();
		
		try {
			
			logger.info("==================== getMoniteringEtaxList ====================");
			
			list = resAlphaG20Service.getMoniteringEtaxList(requestMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
	    
		return resultMap;
	}
	
	/**
	 * @param getAttachInfo
	 * @return 
	 * @throws Exception
	 * a_attachinfo 문서 첨부파일 리스트
	 */
	@RequestMapping("/resAlphaG20/getAttachInfo")
	@ResponseBody
	public Map<String, Object> getAttachInfo ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<>();
		
		try {
			
			logger.info("==================== getAttachInfo ====================");
			
			list = resAlphaG20Service.getAttachInfo(requestMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @param getAttachInfo2
	 * @return 
	 * @throws Exception
	 * a_attachinfo 문서 첨부파일 리스트2
	 */
	@RequestMapping("/resAlphaG20/getAttachInfo2")
	@ResponseBody
	public Map<String, Object> getAttachInfo2 ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request, Model model ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<>();
		
		try {
			
			logger.info("==================== getAttachInfo2 ====================");
			
			list = resAlphaG20Service.getAttachInfo2(requestMap);
			
			resultMap.put("list", list);
			resultMap.put("total", list.size());
			
		} catch (Exception e) {
			logger.info("ERROR : ", e);
		}
		
		return resultMap;
	}
	
	@RequestMapping(value = "/resAlphaG20/saveResalphaAttach")
	@ResponseBody
	public Map<String, Object> saveResalphaAttach(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi, HttpServletRequest servletRequest) {
		logger.info("kukgoh/saveResalphaAttach");
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			resultMap = resAlphaG20Service.insertAttachFile(map, multi);
			resultMap.put("outYn", "Y");
		} catch (Exception e) {
			resultMap.put("outYn", "N");
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : deleteResalphaAttach
	 * @author : 이재용
	 * @since : 2020. 12. 10
	 * 설명 : 새로 추가된 파일 삭제
	 */
	@RequestMapping("/resAlphaG20/deleteResalphaAttach")
	@ResponseBody
	public Map<String, Object> deleteResalphaAttach(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== deleteResalphaAttach ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.deleteResalphaAttach(paramMap);
			
		} catch (Exception e) {
			logger.info("deleteResalphaAttach ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : deleteOrgResalphaAttach
	 * @author : 이재용
	 * @since : 2020. 12. 10
	 * 설명 : 기존 a_attachinfo 파일 삭제
	 */
	@RequestMapping("/resAlphaG20/deleteOrgResalphaAttach")
	@ResponseBody
	public Map<String, Object> deleteOrgResalphaAttach(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== deleteOrgResalphaAttach ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			resAlphaG20Service.saveResalphaAttach(paramMap);
			
		} catch (Exception e) {
			logger.info("deleteOrgResalphaAttach ERROR : ", e);
		}
		
		return resultMap;
	}
	
	/**
	 * @MethodName : 타임스탬프 PDF 최종 보관
	 * @author : 이재용
	 * @since : 2020. 12. 14
	 * 설명 : 
	 */
	@RequestMapping("/resAlphaG20/saveFinalPDF")
	@ResponseBody
	public Map<String, Object> saveFinalPDF ( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest request) throws Exception {
		logger.info("============ saveFinalPDF START ================");
		logger.info("/logger/saveFinalPDF");
		
		Map<String, Object> paramMap = new HashMap<>();
		String resultCode = "SUCCESS";
		String resultMessage = "PDF 생성을 시작하였습니다. 생성 완료 후 확인 가능합니다.";
		String orgDocFileSubName = "_0000000001";
		
		Map<String, Object> loginMap = commonService.commonGetEmpInfo(request);
		
		try {
			
			List<Map<String, Object>> resultList 	= new ArrayList<>();
			List<Map<String, Object>> fileList 		= resAlphaG20Service.getAttachInfo2(requestMap);
			Map<String, Object> orgDocMap 		= resAlphaG20Service.getDocOrg(requestMap);
			
			String c_dikeycode 		= String.valueOf(requestMap.get("C_DIKEYCODE"));
			String orgDocPath 		= String.valueOf(orgDocMap.get("c_difilepath"));
			String	 splitOrgDocPath 	= orgDocPath.split("documentDir")[1]; // ex ) /1224/2020/02/02
			
			requestMap.put("compSeq", loginMap.get("compSeq"));
			requestMap.put("empSeq", loginMap.get("empSeq"));
			requestMap.put("deptSeq", loginMap.get("deptSeq"));
			requestMap.put("finalSavedPath", 		pdfServerRootPath + finalPdfServerPath.split("home/")[1] + splitOrgDocPath);
			requestMap.put("finalSavedFileName", 	String.valueOf(requestMap.get("pdfName")));
			
			if ("1".equals(String.valueOf(requestMap.get("gubun")))) { // 일계표의 경우 따로 처리
				Map<String, Object> dailyMap = new HashMap<>();
				
				dailyMap.put("file_extsn", "pdf");
				dailyMap.put("stre_file_name", String.valueOf(orgDocMap.get("c_dikeycode")) + orgDocFileSubName);
				dailyMap.put("c_aititle", String.valueOf(orgDocMap.get("c_dititle")));
				dailyMap.put("attachFilePath", pdfServerRootPath + orgDocPath.split("home/")[1] + "/" + c_dikeycode);
				dailyMap.put("zipAttachFilePath", orgDocPath);
				
				resultList.add(dailyMap);
			}
			
			for (Map<String, Object> map : fileList) {
				String attachFilePath 		= "";
				String zipAttachFilePath 	= "";
				String file_stre_cours = String.valueOf(map.get("file_stre_cours"));
				
				if (file_stre_cours.indexOf("documentDir") > -1) { // 기존 첨부파일
					attachFilePath 		= pdfServerRootPath + "upload/ea" + file_stre_cours; // 첨부파일 경로 (윈도우)
					zipAttachFilePath 	= "/home/upload/ea" + file_stre_cours;	// 첨부파일 (리눅스)
				} else { // 새로 추가된 파일
					attachFilePath 		= pdfServerRootPath + file_stre_cours.split("home/")[1];
					zipAttachFilePath 	= file_stre_cours;	// 첨부파일 (리눅스)
				}
				
				map.put("zipAttachFilePath", zipAttachFilePath);
				map.put("attachFilePath", attachFilePath);
				
				resultList.add(map);
			}
			
			Thread t = new Thread(new PdfFinalEcmThread(resultList, resAlphaG20Service, requestMap));
			t.start();
			
			logger.info("============ saveFinalPDF END ================");
			
		} catch (Exception e) {
			resultCode = "FAIL";
			resultMessage = "실패하였습니다.";
			logger.info("ERROR : ", e);
		}
		
		paramMap.put("resultCode", resultCode);
		paramMap.put("resultMessage", resultMessage);
		
		return paramMap;
	}
	
	/**
	 * 
	 * @MethodName : sendSmsMessage
	 * @author : 구슬기
	 * @since : 2020. 12. 17
	 * 설명 : SMS 전송 페이지
	 */
	@RequestMapping("/resAlphaG20/sendSmsMessage")
	public String sendSmsMessage(@RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest, Model model){
		
		logger.info("== sendSmsMessage ==");
		
		Map<String, Object> loginMap;
		
		try {
			loginMap = commonService.commonGetEmpInfo(servletRequest);
			String deptNm = String.valueOf(loginMap.get("orgnztNm"));
			String deptSeq = String.valueOf(loginMap.get("deptSeq"));
			String empSeq = String.valueOf(loginMap.get("empSeq"));
			String empName = String.valueOf(loginMap.get("empName"));
			
			model.addAttribute("deptNm", deptNm);
			model.addAttribute("deptSeq", deptSeq);
			model.addAttribute("empSeq", empSeq);
			model.addAttribute("empName", empName);
		} catch (NoPermissionException e) {
			logger.info("ERROR:", e);
		}
		
		return "/resAlphaG20/sendSmsMessage";
	}
	
	/**
	 * 
	 * @MethodName : getAdocuTradeList
	 * @author : 이재용
	 * @since : 2020. 12. 17
	 * 설명 : 거래처별 SMS 전송 리스트
	 */
	@RequestMapping("/resAlphaG20/getAdocuTradeList")
	@ResponseBody
	public Map<String, Object> getAdocuTradeList(@RequestParam Map<String, Object> paramMap, ModelAndView mv){
		
		logger.info("== getAdocuTradeList ==");
		
		Map<String, Object> resultMap = new HashMap<>();
		List<Map<String, Object>> tradeList = new ArrayList<Map<String,Object>>();
		
		try {
			
			paramMap.put("CO_CD", "5000");
			
			tradeList = resAlphaG20Service.getAdocuTradeList(paramMap);
			
			resultMap.put("list", tradeList);
			resultMap.put("total", Integer.parseInt(resAlphaG20Service.getAdocuTradeInfoTotal(paramMap)));
			
		} catch (Exception e) {
			logger.info("getAdocuTradeList ERROR : ", e);
		} finally {
			resAlphaG20Service.deleteAdocuTmp(paramMap);
		}
		
		return resultMap;
	}
	
	/**
	 * 
	 * @MethodName : saveInfoAboutSms
	 * @author : 구슬기
	 * @since : 2020. 12. 18
	 * 설명 : SMS 관련 정보 저장
	 */
	@RequestMapping("/resAlphaG20/saveInfoAboutSms")
	@ResponseBody
	public String saveInfoAboutSms(@RequestParam Map<String, Object> paramMap){
		String result = "suc";
		
		logger.info("== saveInfoAboutSms ==");
		ArrayList<String> numberArray = new ArrayList<>();
		
		try {
			
			String message = String.valueOf(paramMap.get("message"));
			numberArray.add(String.valueOf(paramMap.get("e_phone_num")));
			
			resAlphaG20Service.saveInfoAboutSms(paramMap); // 테이블 저장
			resAlphaG20Service.saveSmsLog(paramMap); // 로그 저장
			
			commonService.sendSmsByBizTongAgent("", message, numberArray);
		} catch (Exception e) {
			result = "fail";
			logger.info("saveInfoAboutSms ERROR : ", e);
		}
		
		return result;
	}
	
	/**
	 * 
	 * @MethodName : cardAlamBatch
	 * @author : jy
	 * @since : 2020. 12. 22
	 * 설명 : 알람 테스트
	 */
	@RequestMapping("/resAlphaG20/cardAlamBatch")
	@ResponseBody
	public void cardAlamBatch(@RequestParam Map<String, Object> paramMap){
		
		logger.info("== cardAlamBatch ==");
		
		try {
			resAlphaG20Service.notionNotSettleCard();
		} catch (Exception e) {
			logger.info("cardAlamBatch ERROR : ", e);
		}
		
	}
	
	/**
	 * 
	 * @MethodName : saveSmsMessage
	 * @author : jy
	 * @since : 2020. 12. 23
	 * 설명 : SMS Message save
	 */
	@RequestMapping("/resAlphaG20/saveSmsMessage")
	@ResponseBody
	public void saveSmsMessage(@RequestParam Map<String, Object> paramMap){
		
		logger.info("== saveSmsMessage ==");
		
		try {
			String message = resAlphaG20Service.selectSmsMessage(paramMap);
			
			if (message != null) {
				resAlphaG20Service.updateSmsMessage(paramMap);
			} else {
				resAlphaG20Service.saveSmsMessage(paramMap);
			}
			
		} catch (Exception e) {
			logger.info("saveSmsMessage ERROR : ", e);
		}
	}
	
	/**
	 * 
	 * @MethodName : selectSmsMessage
	 * @author : jy
	 * @since : 2020. 12. 23
	 * 설명 : SMS 메시지 템플릿
	 */
	@RequestMapping("/resAlphaG20/selectSmsMessage")
	@ResponseBody
	public Map<String, Object> selectSmsMessage(@RequestParam Map<String, Object> paramMap){
		
		logger.info("== selectSmsMessage ==");
		
		try {
			String message = resAlphaG20Service.selectSmsMessage(paramMap);
			
			if (message != null) {
				resAlphaG20Service.updateSmsMessage(paramMap);
			} else {
				message = "";
			}
			
			paramMap.put("message", message);
			
		} catch (Exception e) {
			logger.info("saveSmsMessage ERROR : ", e);
		}
		
		return paramMap;
	}
	
	/**
	 * 
	 * @MethodName : sendSmsCheckedAll
	 * @author : jy
	 * @since : 2020. 12. 23
	 * 설명 : SMS 전송 정보 저장 및 메시지 전송
	 */
	@RequestMapping("/resAlphaG20/sendSmsCheckedAll")
	@ResponseBody
	public Map<String, Object> sendSmsCheckedAll(@RequestParam Map<String, Object> paramMap){
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("isSucc", true);
		
		logger.info("== sendSmsCheckedAll ==");
		
		Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
		Gson gson = new Gson();
		String jsonData = (String) paramMap.get("param");		
		List<Map<String, Object>> smsList = gson.fromJson(jsonData, listType);
		
		try {
			
			for (Map<String, Object> map : smsList) {
				resAlphaG20Service.saveInfoAboutSms(map); // 테이블 저장
				resAlphaG20Service.saveSmsLog(map); // 로그 저장
				
				ArrayList<String> numberArray = new ArrayList<>();
				
				numberArray.add(String.valueOf(map.get("e_phone_num")));
				String content = String.valueOf(map.get("message"));
				
				commonService.sendSmsByBizTongAgent("", content, numberArray);
			}
			
		} catch (Exception e) {
			resultMap.put("isSucc", false);
			logger.info("sendSmsCheckedAll ERROR : ", e);
		}
		
		return resultMap;
	}
}
