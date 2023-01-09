package com.duzon.custom.busTrip.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;
import java.util.UUID;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.tftp.TFTPErrorPacket;
import org.apache.noggit.JSONParser;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.hssf.record.PageBreakRecord.Break;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.solr.common.util.Hash;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.duzon.custom.bsrp.controller.BsrpController;
import com.duzon.custom.busTrip.service.BusTripService;
import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.resalphag20.service.ResAlphaG20Service;
import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;
import com.ibm.icu.text.SimpleDateFormat;
import com.jcraft.jsch.SftpException;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;

/**
 * @author MHJ
 *
 */
@Controller
public class BusTripController {

	private static final Logger logger = (Logger) LoggerFactory.getLogger(BusTripController.class);

	@Autowired
	private CommonService commonService;

	@Autowired
	private BusTripService busTripService;

	@Autowired
	private CommFileDAO commFileDAO;
	
	@Autowired
	private ResAlphaG20Service resAlphaG20Service;

	
	@Value("#{bizboxa['BizboxA.pdfServerRootPath']}")
	private String pdfServerRootPath;
	
	
	@RequestMapping(value = "/busTrip/gradeCostList", method = RequestMethod.GET)
	public String gradeCostList(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("gradeCostList");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		// model.addAttribute("userInfo",
		// commonService.commonGetEmpInfo(servletRequest));
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);

		return "/busTrip/gradeCostList";

	}

	@RequestMapping(value = "/busTrip/withinBusTrip", method = RequestMethod.GET)
	public String withinBusTrip(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("withinBusTrip");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", map);

		return "/busTrip/iframe/withinBusTrip";

	}

	@RequestMapping(value = "/busTrip/withinBusTripReq", method = RequestMethod.GET)
	public String withinBusTripReq(Model model, @RequestParam Map<String, Object> map,
			HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("withinBusTripReq");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		// model.addAttribute("userInfo",
		// commonService.commonGetEmpInfo(servletRequest));
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);

		return "/busTrip/withinBusTripReq";

	}

	@RequestMapping(value = "/busTrip/onnaraBtPop", method = RequestMethod.GET)
	public String onnaraBtPop(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("onnaraBtPop");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		// model.addAttribute("userInfo",
		// commonService.commonGetEmpInfo(servletRequest));
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", map);
		model.addAttribute("orgCode" ,servletRequest.getParameter("orgCode"));
		model.addAttribute("dept_seq" ,servletRequest.getParameter("dept_seq"));
		return "/busTrip/pop/onnaraBtPop";

	}
	@RequestMapping(value = "/busTrip/roomAndFoodPop", method = RequestMethod.GET)
	public String roomAndFoodPop(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("roomAndFoodPop");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", map);
		/*model.addAttribute("orgCode" ,servletRequest.getParameter("orgCode"));*/
		return "/busTrip/pop/roomAndFoodPop";
		
	}
	@RequestMapping(value = "/busTrip/onnaraBtPop2", method = RequestMethod.GET)
	public String onnaraBtPop2(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("onnaraBtPop2");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", map);
		model.addAttribute("orgCode" ,servletRequest.getParameter("orgCode"));
		model.addAttribute("dept_seq" ,servletRequest.getParameter("dept_seq"));
		
		return "/busTrip/pop/onnaraBtPop2";
		
	}
	@RequestMapping(value = "/busTrip/apiPop", method = RequestMethod.GET)
	public String apiPop(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("apiPop");
		
		String sort = servletRequest.getParameter("sort");
		String bizDate = servletRequest.getParameter("bizDate");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		model.addAttribute("sortId", sort);
		model.addAttribute("bizDate", bizDate);
		
		return "/busTrip/pop/apiPop";
		
	}
	@RequestMapping(value = "/busTrip/ban0Pop", method = RequestMethod.GET)
	public String ban0Pop(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("ban0Pop");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/pop/ban0Pop";
		
	}

	@RequestMapping(value = "/busTrip/getUserPop", method = RequestMethod.GET)
	public String getUserPop(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("getUserPop");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		// model.addAttribute("userInfo",
		// commonService.commonGetEmpInfo(servletRequest));
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);

		return "/busTrip/pop/getUserPop";

	}

	@RequestMapping(value = "/busTrip/makeOutTripExcel", method = RequestMethod.POST)
	@ResponseBody
	public void makeOutTripExcel(@RequestBody List<Map<String, Object>> list, HttpServletRequest request) throws Exception {

		logger.info("makeOutTripExcel");
		
		try {
			List<Map<String, Object>> lists = new ArrayList<>();
			List<Map<String, Object>> lists2 = new ArrayList<>();
			List<Map<String, Object>> lists3 = new ArrayList<>();
			List<Map<String, Object>> lists4 = new ArrayList<>();
			Map<String, Object> beans  = new HashMap<String, Object>();
			
			
			String resseq = null ;
			String fileKey = null;
			for (int i = 0; i < list.size(); i++) {
				
				resseq = String.valueOf(list.get(0).get("resDocSeq"));
				fileKey = String.valueOf(list.get(0).get("fileKeyy"));
				
				
				Map<String, Object> excelMap = new HashMap<String, Object>();
				 for (Entry<String, Object> entry : list.get(i).entrySet()) {
					 logger.info("[인덱스 "+i+"] [key]:" + entry.getKey() + ", [value]:" + entry.getValue());
			          
					 excelMap.put(entry.getKey(), entry.getValue());
			            
			        }
					lists.add(excelMap);

			}
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> excelMap = new HashMap<String, Object>();
					if(list.get(i).get("carempName") == null){
						excelMap.put("carempName", list.get(i).get("empName"));
						excelMap.put("oilc", "사용내역없음");
						lists2.add(excelMap);
					}else{
						excelMap.put("carempName", list.get(i).get("carempName"));
						excelMap.put("distance", list.get(i).get("distance"));
						excelMap.put("oilc", list.get(i).get("oilc"));
						excelMap.put("oiltype", list.get(i).get("oiltype"));
						excelMap.put("dusql", list.get(i).get("dusql"));
						excelMap.put("etcc", list.get(i).get("etcc"));
						excelMap.put("oil_city_kor", list.get(i).get("oil_city_kor"));
						excelMap.put("cartotal", list.get(i).get("cartotal"));
						lists2.add(excelMap);
					}

			}
			Map<String, Object> tempMap  = new HashMap<String, Object>();
			tempMap.put("resDocSeq", resseq);
			
			List<Map<String, Object>> templist =busTripService.getAllCardInfoByResDocSeq(tempMap);
			if(!templist.isEmpty()){
				Map<String, Object> excelMap = new HashMap<String, Object>();
				for (int i = 0; i < templist.size(); i++) {
					excelMap.put("empName", templist.get(i).get("emp_name"));
					excelMap.put("bizday", templist.get(i).get("biz_day"));
					excelMap.put("duqlsort", templist.get(i).get("cardSort"));
					excelMap.put("trname", templist.get(i).get("trName"));
					excelMap.put("cardnum", templist.get(i).get("cardNum"));
					excelMap.put("tradeamt", templist.get(i).get("cost"));
					excelMap.put("regDate", templist.get(i).get("regDate"));
					lists3.add(excelMap);
					}
				
			}else{
				Map<String, Object> excelMap = new HashMap<String, Object>();
				
				excelMap.put("trname", "사용내역없음");
				lists3.add(excelMap);
			}
			
			int bus =0;
			int cardBus =0;
			int train =0;
			int cardTrain =0;
			int ship =0;
			int cardShip =0;
			int air =0;
			int cardAir =0;
			int car1 =0;
			int cardCar1 =0;
			int car2 =0;
			int cardCar2 =0;
			int etcTrafic =0;
			int cardEtcTrafic =0;
			int dayc =0;
			int foodc =0;
			int roomc =0;
			int cardRoomc =0;
			int total =0;
			int cardTotal =0;
			int tradeAmt =0;
						
			try {
				for (int i = 0; i < list.size(); i++) {
					
					if(list.get(i).get("bus") != null) {
						bus += Integer.valueOf(String.valueOf(list.get(i).get("bus")));
					}
					if(list.get(i).get("cardBus") != null) {
						cardBus += Integer.valueOf(String.valueOf( list.get(i).get("cardBus")));
					}
					if(list.get(i).get("train") != null) {
						train += Integer.valueOf(String.valueOf( list.get(i).get("train")));
					}
					if(list.get(i).get("cardTrain") != null) {
						cardTrain += Integer.valueOf(String.valueOf( list.get(i).get("cardTrain")));
					}
					if(list.get(i).get("ship") != null) {
						ship += Integer.valueOf(String.valueOf( list.get(i).get("ship")));
					}
					if(list.get(i).get("cardShip") != null) {
						cardShip += Integer.valueOf(String.valueOf( list.get(i).get("cardShip")));
					}
					if(list.get(i).get("air") != null) {
						air += Integer.valueOf(String.valueOf( list.get(i).get("air")));
					}
					if(list.get(i).get("cardAir") != null) {
						cardAir += Integer.valueOf(String.valueOf( list.get(i).get("cardAir")));
					}
					if(list.get(i).get("car1") != null) {
						car1 += Integer.valueOf(String.valueOf( list.get(i).get("car1")));
					}
					if(list.get(i).get("cardCar1") != null) {
						cardCar1 += Integer.valueOf(String.valueOf( list.get(i).get("cardCar1")));
					}
					if(list.get(i).get("car2") != null) {
						car2 += Integer.valueOf(String.valueOf( list.get(i).get("car2")));
					}
					if(list.get(i).get("cardCar2") != null) {
						cardCar2 += Integer.valueOf(String.valueOf( list.get(i).get("cardCar2")));
					}
					if(list.get(i).get("etcTrafic") != null) {
						etcTrafic += Integer.valueOf(String.valueOf( list.get(i).get("etcTrafic")));
					}
					if(list.get(i).get("cardEtcTrafic") != null) {
						cardEtcTrafic += Integer.valueOf(String.valueOf( list.get(i).get("cardEtcTrafic")));
					}
					if(list.get(i).get("dayc") != null) {
						dayc += Integer.valueOf(String.valueOf( list.get(i).get("dayc")));
					}
					if(list.get(i).get("foodc") != null) {
						foodc += Integer.valueOf(String.valueOf( list.get(i).get("foodc")));
					}
					if(list.get(i).get("roomc") != null) {
						roomc += Integer.valueOf(String.valueOf( list.get(i).get("roomc")));
					}
					if(list.get(i).get("cardRoomc") != null) {
						cardRoomc += Integer.valueOf(String.valueOf( list.get(i).get("cardRoomc")));
					}
					if(list.get(i).get("total") != null) {
						total += Integer.valueOf(String.valueOf( list.get(i).get("total")));
					}
					if(list.get(i).get("cardTotal") != null) {
						bus += Integer.valueOf(String.valueOf( list.get(i).get("cardTotal")));
					}
					
				}
				for (int i = 0; i < lists3.size(); i++) {
					
					if(lists3.get(i).get("tradeamt") != null) {
						tradeAmt += Integer.valueOf(String.valueOf( lists3.get(i).get("tradeamt")));
					}
				}
			} catch (Exception e) {
				logger.info("합계구하는곳인데",e);
				
			}
			
			
			Map<String, Object> totalCostMap = new HashMap<String, Object>();
			
			totalCostMap.put("bus", bus+cardBus);
			totalCostMap.put("train", train +cardTrain);
			totalCostMap.put("ship", ship+cardShip);
			totalCostMap.put("air", air+cardAir);
			totalCostMap.put("car1", car1+cardCar1);
			totalCostMap.put("car2", car2+cardCar2);
			totalCostMap.put("etcTrafic", etcTrafic+cardEtcTrafic);
			totalCostMap.put("dayc", dayc);
			totalCostMap.put("foodc", foodc);
			totalCostMap.put("roomc", roomc+cardRoomc);
			totalCostMap.put("total", total+cardTotal);
			totalCostMap.put("cardTotal", cardTotal);
			totalCostMap.put("tradeAmt", tradeAmt);
			
			lists4.add(totalCostMap);
			
			/**
			 *   여기서 부터 excelMap 정보와 fileKey로 temp파일 만들기 
			 */
			beans.put("list", lists);
			beans.put("list2", lists2);
			beans.put("list3", lists3);
			beans.put("list4", lists4);
			
			
			
	        try {
	        	//템플릿 엑셀파일 위치
//	        	String path = "C:/Users/MHJ/Desktop/newoutTripTemplete.xlsx";
	        	String path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + "newoutTripTemplete.xlsx");
	        	
	        	InputStream is = new BufferedInputStream(new FileInputStream(path));
	        	
	        	XLSTransformer transformer = new XLSTransformer();
	        	
	            Workbook resultWorkbook = transformer.transformXLS(is, beans);
//	            String tempPath = "C:/Users/MHJ/Desktop/result/";
	            
	            String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
	            String tempPath3 = CommFileUtil.getFilePath(commFileDAO, "ea/bizTemp", "N");
	            
	            
	            logger.info(tempPath);
	            logger.info(tempPath3);
	            //pdf파일 서버 경로로 잡아주기
	            String tempPath2 = "Z:/upload/ea/bizTemp/";
	        	
	            File dir = new File(tempPath+fileKey);
	            
	            if(!dir.isDirectory()){
	            	CommFileUtil.makeDir(tempPath + fileKey);
	            }
	            String randomKey = "B" + java.util.UUID.randomUUID().toString();
	            
	            OutputStream os = new FileOutputStream(new File(tempPath3 + randomKey+"_출장집계표"+".xlsx"));
	            
	            resultWorkbook.write(os);
	            os.close();				
	            
	           
	       /*    // 엑셀파일 만들어졌으면 pdf로 말자 
	            try {
	    			//만들어질 파일경로+이름?
	    			String fileFullPath = tempPath2 + randomKey + "_출장집계표"+".pdf";
	    			
	    			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	    			String ymd = sdf.format(new Date());
	    			
	    			File f = new File(fileFullPath);
	    			
	    			if (!f.exists()) {
	    				
	    				PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
	    				
	    				pdfEcmFileVO.setRep_id(ymd + randomKey);
	    				pdfEcmFileVO.setComp_seq("1000");
	    				pdfEcmFileVO.setDoc_id("DOC" + randomKey);
	    				pdfEcmFileVO.setDoc_no("001");
	    				pdfEcmFileVO.setDoc_path(tempPath2);
	    				pdfEcmFileVO.setDoc_ext("xlsx");
	    				pdfEcmFileVO.setDoc_name(randomKey+"_출장집계표");
	    				pdfEcmFileVO.setDoc_title("출장집계표.xlsx");
	    				
	    				PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();
	    				
	    				pdfEcmMainVO.setRep_id(ymd + randomKey);
	    				pdfEcmMainVO.setComp_seq("1000");
	    				pdfEcmMainVO.setDept_seq("1");
	    				pdfEcmMainVO.setEmp_seq("1");
	    				pdfEcmMainVO.setPdf_path(tempPath2);
	    				pdfEcmMainVO.setPdf_name(randomKey+"_출장집계표");
	    				pdfEcmMainVO.setStatus_cd("D0001");
	    				
	    				resAlphaG20Service.savePdfEcmFile(pdfEcmFileVO);
	    				resAlphaG20Service.savePdfEcmMain(pdfEcmMainVO);
	    			}
	    			
	    			
	    			while (!f.exists()) {
	    				Thread.sleep(400);
	    			
	    				 // 옮기기
			            //원본 파일경로+ 파일명
						 String oriFilePath = tempPath3 + randomKey + "_출장집계표"+".pdf";
						 //복사될 파일경로+ 파일명
						 String copyFilePath =tempPath +fileKey+File.separator +"출장집계표.pdf";
						 
						 
						 //파일객체생성
						 File oriFile = new File(oriFilePath);
						 //복사파일객체생성
						 File copyFile = new File(copyFilePath);
						 
						 try {
							 
							 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							 
							 int fileByte = 0; 
							 // fis.read()가 -1 이면 파일을 다 읽은것
							 while((fileByte = fis.read()) != -1) {
								 fos.write(fileByte);
							 }
							 //자원사용종료
							 fis.close();
							 fos.close();
							 
						 } catch (FileNotFoundException e) {
							 logger.info("FileNotFoundException", e);
						 } catch (IOException e) {
							 logger.info("IOException", e);
						 }
		    			
	    			
	    			
	    			}*/
	    			
	            // 옮기기
	            //원본 파일경로+ 파일명
				 String oriFilePath = tempPath3 + randomKey + "_출장집계표"+".xlsx";
				 //복사될 파일경로+ 파일명
				 String copyFilePath =tempPath +fileKey+File.separator +"출장집계표.xlsx";
				 
				 
				 //파일객체생성
				 File oriFile = new File(oriFilePath);
				 //복사파일객체생성
				 File copyFile = new File(copyFilePath);
				 
				 try {
					 
					 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
					 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
					 
					 int fileByte = 0; 
					 // fis.read()가 -1 이면 파일을 다 읽은것
					 while((fileByte = fis.read()) != -1) {
						 fos.write(fileByte);
					 }
					 //자원사용종료
					 fis.close();
					 fos.close();
					 logger.info("만들었다~~~ 오류");
	    			
	    		} catch (Exception e) {
	    			logger.info("ERROR : ", e);
	    		}
	            
	        } catch (Exception e) {
	        	  logger.info("ERROR!!!!!!ERROR!!!!!!ERROR!!!!!!출장집계표 (시외) 엑셀",e);
	        }	
			
		} catch (Exception e) {
			logger.info("집계표만들기 오류",e);
		}
		
		
	}
	
	@SuppressWarnings("unlikely-arg-type")
	@RequestMapping(value="/busTrip/upMooExcel")
	@ResponseBody
	public Map<String, String> upMooExcel(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response){
		
		logger.info("/busTrip/upMooExcel");
		
		Map<String, String> returnMap = new HashMap<String, String>();
		String path = "";
		
		try {
			
			Gson gson = new Gson();
			String list = (String) map.get("list");		
			String title = String.valueOf(map.get("title"));
			Type listType = new TypeToken<List<Map<String, String>>>() {}.getType();
			
			List<Map<String, Object>> jsonList = gson.fromJson(list, listType);
			
			Map<String, Object> beans  = new HashMap<String, Object>();
			
			
			for (Map<String, Object> listMap : jsonList) {
				listMap.put("c_tiname", String.valueOf(listMap.get("c_tiname")).equals("null") ? "" :  String.valueOf(listMap.get("c_tiname")) );
				listMap.put("dept_name", String.valueOf(listMap.get("dept_name")).equals("null") ? "" :  String.valueOf(listMap.get("dept_name")));
				listMap.put("mgt_name", String.valueOf(listMap.get("mgt_name")).equals("null") ? "" :  String.valueOf(listMap.get("mgt_name")));
				listMap.put("authDate", String.valueOf(listMap.get("authDate")).equals("null") ? "" :  String.valueOf(listMap.get("authDate")));
				listMap.put("TR_NM", String.valueOf(listMap.get("TR_NM")).equals("null") ? "" :  String.valueOf(listMap.get("TR_NM")));
				listMap.put("merc_saup_no", String.valueOf(listMap.get("merc_saup_no")).equals("null") ? "" :  String.valueOf(listMap.get("merc_saup_no")));
				listMap.put("auth_num", String.valueOf(listMap.get("auth_num")).equals("null") ? "" :  String.valueOf(listMap.get("auth_num")));
				listMap.put("mercAddr", String.valueOf(listMap.get("mercAddr")).equals("null") ? "" :  String.valueOf(listMap.get("mercAddr")));
				listMap.put("CTR_NM", String.valueOf(listMap.get("CTR_NM")).equals("null") ? "" :  String.valueOf(listMap.get("CTR_NM")));
				listMap.put("card_num", String.valueOf(listMap.get("card_num")).equals("null") ? "" :  String.valueOf(listMap.get("card_num")));
				listMap.put("UNIT_AM", String.format("%,d",Integer.valueOf(String.valueOf(listMap.get("UNIT_AM"))).equals("null") ? "0" :  Integer.valueOf(String.valueOf(listMap.get("UNIT_AM")))));
				
				
				listMap.put("djWorkFeeDate", String.valueOf(listMap.get("djWorkFeeDate")).equals("null") ? "" :  String.valueOf(listMap.get("djWorkFeeDate")).substring(0,12));
				
				listMap.put("djWorkFeeUser1", String.valueOf(listMap.get("djWorkFeeUser1")).equals("null") ? "" :  String.valueOf(listMap.get("djWorkFeeUser1")));
				listMap.put("djWorkFeeUser2", String.valueOf(listMap.get("djWorkFeeUser2")).equals("null") ? "" :  String.valueOf(listMap.get("djWorkFeeUser2")));
				
				listMap.put("djWorkFeeAmt", String.format("%,d",Integer.valueOf(String.valueOf(listMap.get("djWorkFeeAmt"))).equals("null") ? "0" : String.format("%,d",Integer.valueOf(String.valueOf(listMap.get("djWorkFeeAmt")).substring(1,String.valueOf(listMap.get("djWorkFeeAmt")).indexOf('(')-1)))));
				
				
				listMap.put("djWorkFeeType", String.valueOf(listMap.get("djWorkFeeType")).equals("null") ? "" :  String.valueOf(listMap.get("djWorkFeeType")));
				listMap.put("emp_name", String.valueOf(listMap.get("emp_name")).equals("null") ? "" :  String.valueOf(listMap.get("emp_name")));
				
				listMap.put("res_date", String.valueOf(listMap.get("res_date")).equals("null") ? "" :  String.valueOf(listMap.get("res_date")));
				
				
				listMap.put("doc_no", String.valueOf(listMap.get("doc_no")).equals("null") ? "" :  String.valueOf(listMap.get("doc_no")));
				listMap.put("regNo", String.valueOf(listMap.get("regNo")).equals("null") ? "" :  String.valueOf(listMap.get("regNo")));
				listMap.put("fill_dt", String.valueOf(listMap.get("fill_dt")).equals("null") ? "" :  String.valueOf(listMap.get("fill_dt")));
				listMap.put("c_ridocfullnum", String.valueOf(listMap.get("c_ridocfullnum")).equals("null") ? "" :  String.valueOf(listMap.get("c_ridocfullnum")));
				String status ="미처리";
				
				if(!String.valueOf(listMap.get("res_date")).equals("null")) {
					status ="결의완료";
				}
				if(!String.valueOf(listMap.get("c_ridocfullnum")).equals("null")) {
					status ="지급완료";
				}
				listMap.put("status", status);
			}
			
			beans.put("list", jsonList);
			
			
			//템플릿 엑셀파일 위치
			if (request.getServerName().contains("localhost") || request.getServerName().contains("127.0.0.1")) {
				path = "C:/Users/dev-jitsu/Desktop/upMooChuJinTemplate.xlsx";
			} else {
				path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + "upMooChuJinTemplate.xlsx");
			}
			
        	returnMap = makeExcelFile(path, beans, title, request);
        	
		} catch (Exception e) {
			logger.info("upMooExcel  Error : ", e);
		}
		
		return returnMap;
	}
	
	public Map<String, String> makeExcelFile(String path, Map<String, Object> beans, String title, HttpServletRequest request) throws Exception{
		Map<String, String> resultMap = new HashMap<String, String>();
		InputStream is = new BufferedInputStream(new FileInputStream(path));
		String temp = "";
    	
		XLSTransformer transformer = new XLSTransformer();
        Workbook resultWorkbook = transformer.transformXLS(is, beans);
        
//        String uuid = UUID.randomUUID().toString();
        
        if (request.getServerName().contains("localhost") || request.getServerName().contains("127.0.0.1")) {
        	temp = "C:/Users/dev-jitsu/Desktop/testExcel";
		} else {
			temp = "/home/upload/upMooExcel";
		}
        
    	File dir = new File(temp);
        
        if(!dir.isDirectory()){
        	CommFileUtil.makeDir(temp);
        }
        
        String fileFullPath = temp + File.separator + title + ".xlsx";
        
        OutputStream os = new FileOutputStream(new File(fileFullPath));
        
        resultMap.put("fileFullPath", fileFullPath);
        resultMap.put("fileName", title + ".xlsx");
        
        resultWorkbook.write(os);
        os.close();
        
        return resultMap;
	}
	
	
	@RequestMapping(value = "/busTrip/excelDownLoad")
	@ResponseBody 
	public void excelDownLoad(@RequestParam Map<String, Object> map,
			HttpServletRequest servletRequest, HttpServletResponse servletResponse,
			@RequestParam String fileName, @RequestParam String fileFullPath) throws NoPermissionException, SftpException, IOException {
		logger.info("busTrip/excelDownLoad");
		
		map.put("fileName", URLDecoder.decode(fileName, "UTF-8"));
		map.put("fileFullPath", URLDecoder.decode(fileFullPath, "UTF-8"));
		
		busTripService.excelDown(map, servletRequest, servletResponse);
	}
	
	@RequestMapping(value = "/busTrip/getUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getUserInfo(@RequestParam Map<String, Object> map) {
		logger.info("getUserInfo");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getUserInfo(map));

		return result;
	}

	@RequestMapping(value = "/busTrip/getPositionList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPositionList(@RequestParam Map<String, Object> map) {
		logger.info("getPositionList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getPositionList());

		return result;
	}

	@RequestMapping(value = "/busTrip/getWorkFeeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getWorkFeeList(@RequestParam Map<String, Object> map) {
		logger.info("getWorkFeeList");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> msUpMooList= busTripService.getMsUpMooList(map);
			List<Map<String, Object>> resultList= new ArrayList<>();
			
			for(Map<String, Object> msData : msUpMooList) {
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				
				paramMap.put("erp_gisu_date",msData.get("erp_gisu_date"));
				paramMap.put("erp_gisu_sq",msData.get("erp_gisu_sq"));
				paramMap.put("erp_bg_sq",msData.get("erp_bg_sq"));
				paramMap.put("erp_ln_sq",msData.get("erp_ln_sq"));
				
				Map<String, Object> addInfo = busTripService.getCardinfoByGisu(paramMap);
				
				
				if(addInfo != null) {
					
					msData.putAll(addInfo);
					
					if(addInfo.get("sync_id") != null) {
						paramMap.put("CO_CD", "5000");
						paramMap.put("syncId", addInfo.get("sync_id"));
						paramMap.put("mercSaupNo", addInfo.get("merc_saup_no"));
						try {
							Map<String, Object> cardInfoMap = resAlphaG20Service.userCardDetailInfo(paramMap);
							
							msData.put("authDate", fn_authDate(String.valueOf(cardInfoMap.get("authDate")) + String.valueOf(cardInfoMap.get("authTime"))));
							msData.put("mercAddr", String.valueOf(cardInfoMap.get("mercAddr")));
							
						} catch (Exception e) {
							logger.info("userCardDetailInfo",e);
						}
					
					
					}
					
					
					paramMap.put("res_doc_seq",addInfo.get("res_doc_seq"));
					
					Map<String, Object> workFeeInfo= busTripService.getWorkFeeList(paramMap);
					if(workFeeInfo != null ) {
						
						msData.putAll(workFeeInfo);
					
					
						if(workFeeInfo.get("workFeeData") != null){
							Gson gson = new Gson();
							
							System.out.println(workFeeInfo.get("workFeeData"));
							
							String data = String.valueOf(workFeeInfo.get("workFeeData"));		
							Type listType = new TypeToken<Map<String, String>>(){}.getType();
							Map<String, Object> listMap = gson.fromJson(data, listType);
							
							
							msData.put("djWorkFeeDate", listMap.get("djWorkFeeDate"));
							msData.put("djWorkFeeUser1", listMap.get("djWorkFeeUser1"));
							msData.put("djWorkFeeUser2", listMap.get("djWorkFeeUser2"));
							msData.put("djWorkFeeAmt", listMap.get("djWorkFeeAmt"));
							
							
							String a="";
							
							if(listMap.get("djWorkFeeType1").equals("√")) {
									a += "사업추진회의 및 행사";
							}
							if(listMap.get("djWorkFeeType2").equals("√")) {
								if(a != "") {
									a += ",유관기관 업무협의 및 간담회";
								} else {
									a += "유관기관 업무협의 및 간담회";
								}
								
							}
							if(listMap.get("djWorkFeeType3").equals("√")) {
								if(a != "") {
									a += ",직원사기진작 및 회식";
								} else {
									a += "직원사기진작 및 회식";
								}
							}
							if(listMap.get("djWorkFeeType4").equals("√")) {
								if(a != "") {
									a += ","+(String)listMap.get("djWorkFeeType4Txt");
								} else {
									a += (String)listMap.get("djWorkFeeType4Txt");
								}
								
							}
							
							msData.put("djWorkFeeType", a);
							
						}
					}
					
					paramMap.put("ISU_DT", msData.get("isu_dtt"));
					paramMap.put("ISU_SQ", msData.get("isu_sqq"));
					
					Map<String, Object> docInfo= busTripService.getDocInfobyISUDTAndSQ(paramMap);
					 
					 if(docInfo != null) {
						 msData.put("appr_dikey", docInfo.get("c_dikeycode"));
						 msData.put("c_ridocfullnum", docInfo.get("c_ridocfullnum"));
					 }
					
					
				} 
				resultList.add(msData);
			}
			
			
			
			
			
			result.put("list", resultList);
		} catch (Exception e) {
			logger.info("getWorkFeeList", e);
		} 
		
		
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getonNaraBTListPaging", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getonNaraBTListPaging(@RequestParam Map<String, Object> map) {
		logger.info("getonNaraBTListPaging");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> onList= busTripService.getonNaraBTListPaging(map);
			 List<Map<String, Object>> bizList= busTripService.getAllBizDataWithin(map);
			 List<Map<String, Object>> resultList= new ArrayList<>();
			 int totalCntSum =0;
			 for(Map<String, Object> onMap : onList){
				 int cnt =0;
				 
				 for(Map<String, Object>bizMap : bizList){
					 HashMap<String, Object> cloneMap = new  HashMap<String, Object>();
					 cloneMap.putAll(onMap);
					 
					 //온나라데이터 출장번호
					 String tripNo = String.valueOf(cloneMap.get("TRIP_NO"));
					 //온나라데이터 출장자번호
					 String empNo = String.valueOf(cloneMap.get("EP_NO"));
					 
					 //마리아db에 저장된 출장번호
					 String trNo= String.valueOf(bizMap.get("biz_trip_no"));
					 //마리아db 저장된 출장자 번호
					 String erpNo= String.valueOf(bizMap.get("btEmpSeq"));
					 
					 if(tripNo.equals(trNo) && empNo.equals(erpNo)){
						 cnt++;
					cloneMap.put("COST", Integer.valueOf(String.valueOf(bizMap.get("amt_pay")))); 
					cloneMap.put("mgt_name", bizMap.get("mgt_name"));
					cloneMap.put("erp_budget_name", bizMap.get("erp_budget_name"));
					cloneMap.put("emp_name", bizMap.get("emp_name"));
					cloneMap.put("res_date", bizMap.get("res_date"));
					cloneMap.put("doc_no", bizMap.get("doc_no"));
					cloneMap.put("regNo", bizMap.get("regNo"));
					cloneMap.put("doc_seq", bizMap.get("doc_seq"));
					
					
					Map<String, Object> paramMap = new HashMap<String, Object>();
					
					paramMap.put("erp_gisu_date", bizMap.get("erp_gisu_date"));
					paramMap.put("erp_gisu_sq", bizMap.get("erp_gisu_sq"));
					
					Map<String, Object> msList= busTripService.getMsDataOne(paramMap);
						
					 if(msList != null) {
						 
						 cloneMap.put("fill_dt", msList.get("FILL_DT"));
						 
						 paramMap.put("ISU_DT", msList.get("ISU_DT"));
						 paramMap.put("ISU_SQ", msList.get("ISU_SQ"));
						 
						 Map<String, Object> docInfo= busTripService.getDocInfobyISUDTAndSQ(paramMap);
						 
						 if(docInfo != null) {
							 cloneMap.put("appr_dikey", docInfo.get("c_dikeycode"));
							 cloneMap.put("c_ridocfullnum", docInfo.get("c_ridocfullnum"));
						 }
						 
					 }
					
						 
					resultList.add(cloneMap);
					 }
					 
				 }
				 
				 if(cnt == 0){
					 resultList.add(onMap);
					 
				 }
				 totalCntSum += cnt;
			 }
			 
			 result.put("list", resultList);
			result.put("totalCount", busTripService.getonNaraBTListPagingTotal(map) +totalCntSum-1);
		} catch (Exception e) {
			logger.info("getonNaraBTListPaging", e);
		} 
		
		 
		 
		 return result;
	}
	@RequestMapping(value = "/busTrip/getonNaraBTListOutside", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getonNaraBTListOutside(@RequestParam Map<String, Object> map) {
		logger.info("getonNaraBTListOutside");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> onList= busTripService.getonNaraBTListPaging(map);
			List<Map<String, Object>> bizList= busTripService.getAllBizDataOutside(map);
			
			List<Map<String, Object>> resultList= new ArrayList<>();
			
			int totalCntSum =0;
			
			
			for(Map<String, Object> onMap : onList){
				int cnt =0;
				
				for(Map<String, Object>bizMap : bizList){
					HashMap<String, Object> cloneMap = new  HashMap<String, Object>();
					cloneMap.putAll(onMap);
					
					//온나라데이터 출장번호
					String tripNo = String.valueOf(cloneMap.get("TRIP_NO"));
					//온나라데이터 출장자번호
					String empNo = String.valueOf(cloneMap.get("EP_NO"));
					
					//마리아db에 저장된 출장번호
					String trNo= String.valueOf(bizMap.get("biz_trip_no"));
					//마리아db 저장된 출장자 번호
					String erpNo= String.valueOf(bizMap.get("btEmpSeq"));
					
					if(tripNo.equals(trNo) && empNo.equals(erpNo)){
						cnt++;
	
						String card = String.valueOf(bizMap.get("file_seq2"));	
						
						int trafic=0;
						int room=0;
						int etc=0;
						
						trafic += Integer.valueOf(String.valueOf(bizMap.get("trafic_cost")));
						room += Integer.valueOf(String.valueOf(bizMap.get("room_cost")));
						etc += Integer.valueOf(String.valueOf(bizMap.get("etc_cost")));
						
						
						if(card.equals("") || card != null) {
							HashMap<String, Object> cardMap = new  HashMap<String, Object>();
							cardMap.put("sub_seq", bizMap.get("sub_seq"));	
							
							List<Map<String, Object>> cardInfo= busTripService.getCardCostBySort(cardMap);
							
								for(Map<String, Object> maaap : cardInfo) {
									
									String sort = (String)maaap.get("cardSort");
									
									if(sort.equals("교통")) {
										trafic +=	Integer.valueOf(String.valueOf(maaap.get("cost")));
										
									}else if(sort.equals("기타")) {
										etc +=	Integer.valueOf(String.valueOf(maaap.get("cost")));
										
									}else if(sort.equals("숙박")) {
										room +=	Integer.valueOf(String.valueOf(maaap.get("cost")));
										
									}
								}
							
						}
						
						
						cloneMap.put("COST", Integer.valueOf(String.valueOf(bizMap.get("total_cost"))));
						
						cloneMap.put("etc_cost", etc);
						cloneMap.put("room_cost", room);
						cloneMap.put("trafic_cost", trafic);
						
						
						cloneMap.put("mgt_name", bizMap.get("mgt_name"));
						cloneMap.put("erp_budget_name", bizMap.get("erp_budget_name"));
						cloneMap.put("emp_name", bizMap.get("emp_name"));
						cloneMap.put("res_date", bizMap.get("res_date"));
						cloneMap.put("doc_no", bizMap.get("doc_no"));
						cloneMap.put("regNo", bizMap.get("regNo"));
						cloneMap.put("doc_seq", bizMap.get("doc_seq"));
						/*cloneMap.put("c_ridocfullnum", bizMap.get("c_ridocfullnum"));*/
						/*cloneMap.put("appr_dikey", bizMap.get("appr_dikey"));*/
						
						
						Map<String, Object> paramMap = new HashMap<String, Object>();
						
						paramMap.put("erp_gisu_date", bizMap.get("erp_gisu_date"));
						paramMap.put("erp_gisu_sq", bizMap.get("erp_gisu_sq"));
						
						Map<String, Object> msList= busTripService.getMsDataOne(paramMap);
						
						if(msList != null) {
							
							cloneMap.put("fill_dt", msList.get("FILL_DT"));
							
							paramMap.put("ISU_DT", msList.get("ISU_DT"));
							paramMap.put("ISU_SQ", msList.get("ISU_SQ"));
							
							Map<String, Object> docInfo= busTripService.getDocInfobyISUDTAndSQ(paramMap);
							
							if(docInfo != null) {
								cloneMap.put("appr_dikey", docInfo.get("c_dikeycode"));
								cloneMap.put("c_ridocfullnum", docInfo.get("c_ridocfullnum"));
							}
							
						}
						
						
						resultList.add(cloneMap);
					}
					
				}
				
				if(cnt == 0){
					resultList.add(onMap);
					
				}
				totalCntSum += cnt;
			}
			
			result.put("list", resultList);
			/*result.put("totalCount", busTripService.getonNaraBTListPagingTotal(map) +totalCntSum-1);*/
		} catch (Exception e) {
			logger.info("getonNaraBTListPaging", e);
		} 
		
		
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getonNaraBTList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getonNaraBTList(@RequestParam Map<String, Object> map) {
		logger.info("getonNaraBTList");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> onList= busTripService.getonNaraBTList(map);
			
			 List<Map<String, Object>> resultList= new ArrayList<>();
			
			 for(Map<String, Object> onMap : onList){
				 
					 HashMap<String, Object> paramMap = new  HashMap<String, Object>();
					 
					 String tripNo = String.valueOf(onMap.get("TRIP_NO"));
					 String empNo = String.valueOf(onMap.get("EP_NO"));
					 paramMap.put("trip_no_onnara", tripNo);
					 paramMap.put("emp_seq", empNo);
					 
					 if("A1702".equals(map.get("trip_code"))) {
						 
						 int cnt = busTripService.getMatchBizInfo(paramMap);
						 if( cnt > 0){
							 logger.info("결재중 / 결제완료인 res_doc_seq가 있다");
							 
						 } else {
							 logger.info("없다");
							 resultList.add(onMap);
							
							 
							 
						 }
					 } else {
						 int cnt = busTripService.getMatchBizInfoCity(paramMap);
						 if( cnt > 0){
							 logger.info("결재중 / 결제완료인 res_doc_seq가 있다");
							 
						 } else {
							 logger.info("없다");
							 resultList.add(onMap);
							 
						 }
						 
					 }
					 
					 
					 
				 
			 }
			 
			 
			 result.put("list",resultList);
			 
		} catch (Exception e) {
				logger.info("getonNaraBTList", e);
		}
		
		

		return result;
	}
	@RequestMapping(value = "/busTrip/getOpnetInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getOpnetInfo(@RequestParam Map<String, Object> map) {
		logger.info("getOpnetInfo");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> list = busTripService.getOpnetInfo(map);
			
			result.put("list",list);
			
		} catch (Exception e) {
			logger.info("getOpnetInfo", e);
		}
		
		
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getAlldeptList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getAlldeptList(@RequestParam Map<String, Object> map) {
		logger.info("getAlldeptList");
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			List<Map<String, Object>> allDept = commonService.getAllDept();
			
			result.put("list",allDept);
			
		} catch (Exception e) {
			logger.info("getAlldeptList", e);
		}
		
		
		
		return result;
	}

	@RequestMapping(value = "/busTrip/getSuccessBIzInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSuccessBIzInfo(@RequestParam Map<String, Object> map) {
		logger.info("getSuccessBIzInfo");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", busTripService.getSuccessBIzInfo(map));
		result.put("totalCount", busTripService.getSuccessBIzInfoCount(map));
		
		return result;
	}
	
	@RequestMapping(value = "/busTrip/getSuccessBIzInfo2", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSuccessBIzInfo2(@RequestParam Map<String, Object> map) {
	    logger.info("getSuccessBIzInfo2");
	    Map<String, Object> result = new HashMap<String, Object>();
	    result.put("list", busTripService.getSuccessBIzInfo2(map));
	    result.put("totalCount", busTripService.getSuccessBIzInfoCount2(map));
	    return result;
	}
	  
	@RequestMapping(value = "/busTrip/getGradeCostList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getGradeCostList(@RequestParam Map<String, Object> map) {
		logger.info("getGradeCostList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getGradeCostList());
		result.put("totalCount", busTripService.getGradeCostListTotal());

		return result;
	}

	@RequestMapping(value = "/busTrip/saveGradeCost", method = RequestMethod.POST)
	@ResponseBody
	public String saveGradeCost(@RequestParam Map<String, Object> map) {
		logger.info("saveGradeCost");

		String result = "success";
		try {
			busTripService.saveGradeCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/modGradeCost", method = RequestMethod.POST)
	@ResponseBody
	public String modGradeCost(@RequestParam Map<String, Object> map) {
		logger.info("modGradeCost");

		String result = "success";
		try {
			busTripService.modGradeCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/delGradeCost", method = RequestMethod.POST)
	@ResponseBody
	public String delGradeCost(@RequestParam Map<String, Object> map) {
		logger.info("delGradeCost");

		String result = "success";
		try {
			busTripService.delGradeCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/returnTrip", method = RequestMethod.GET)
	public String returnTrip(Model model, @RequestParam Map<String, Object> map,HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("returnTrip");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/returnTrip";
		
	}
	
	@RequestMapping(value = "/busTrip/returnTrip2", method = RequestMethod.GET)
	public String returnTrip2(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws NoPermissionException {
	    logger.info("returnTrip2");
	    LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
	    model.addAttribute("userInfo", loginVO);
	    model.addAttribute("param", map);
	    return "/busTrip/returnTrip2";
	}
	
	@RequestMapping(value = "/busTrip/workFeeList", method = RequestMethod.GET)
	public String workFeeList(Model model, @RequestParam Map<String, Object> map,
			HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("workFeeList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/workFeeList";
		
	}
	@RequestMapping(value = "/busTrip/almTest", method = RequestMethod.GET)
	public String almTest(Model model, @RequestParam Map<String, Object> map,	HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("almTest");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/almTest";
		
	}
	@RequestMapping(value = "/busTrip/opnetList", method = RequestMethod.GET)
	public String opnetList(Model model, @RequestParam Map<String, Object> map,	HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("opnetList");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/opnetList";
		
	}
	@RequestMapping(value = "/busTrip/tripList1", method = RequestMethod.GET)
	public String tripList1(Model model, @RequestParam Map<String, Object> map,	HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("tripList1");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/tripList1";
		
	}
	@RequestMapping(value = "/busTrip/tripList2", method = RequestMethod.GET)
	public String tripList2(Model model, @RequestParam Map<String, Object> map,	HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("tripList2");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);
		
		return "/busTrip/tripList2";
		
	}
	@RequestMapping(value = "/busTrip/oilAndCityCostList", method = RequestMethod.GET)
	public String oilAndCityCostList(Model model, @RequestParam Map<String, Object> map,HttpServletRequest servletRequest) throws NoPermissionException {
		logger.info("oilAndCityCostList");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("userInfo", loginVO);
		model.addAttribute("param", map);

		return "/busTrip/oilAndCityCostList";

	}

	@RequestMapping(value = "/busTrip/getalm", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> getalm(@RequestParam Map<String, Object> map) {
		logger.info("getalm");
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			
			result.put("list", busTripService.getalm(map));
		} catch (Exception e) {
			logger.info( "getalm",e);
		}
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getalm2", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> getalm2(@RequestParam Map<String, Object> map) {
		logger.info("getalm2");
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			
			result.put("list", busTripService.getalm2(map));
		} catch (Exception e) {
			logger.info( "getalm2",e);
		}
		
		
		return result;
	}
	@RequestMapping(value = "/busTrip/setAlm", method = RequestMethod.POST)
	@ResponseBody
	public  void setAlm(@RequestParam Map<String, Object> map) {
		logger.info("setAlm");
		
		try {
			
			busTripService.setAlm(map);
		} catch (Exception e) {
			logger.info( "setAlm",e);
		}
		
	}
	@RequestMapping(value = "/busTrip/changeStatus", method = RequestMethod.POST)
	@ResponseBody
	public void changeStatus(@RequestParam Map<String, Object> map) {
		logger.info("changeStatus");
			
		busTripService.changeStatus(map);
		
	}
	@RequestMapping(value = "/busTrip/getAllBizData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getAllBizData(@RequestParam Map<String, Object> map) {
		logger.info("getAllBizData");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", busTripService.getAllBizData(map));
		result.put("totalCount", busTripService.getAllBizDataTotal(map)); //토탈
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getAllBizDataOut", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getAllBizDataOut(@RequestParam Map<String, Object> map) {
		logger.info("getAllBizDataOut");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", busTripService.getAllBizDataOut(map));
		result.put("totalCount", busTripService.getAllBizDataOutTotal(map)); //토탈
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getTraficWay", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getTraficWay(@RequestParam Map<String, Object> map) {
		logger.info("getTraficWay");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getTraficWay());

		return result;
	}

	@RequestMapping(value = "/busTrip/getOilCostList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getOilCostList(@RequestParam Map<String, Object> map) {
		logger.info("getOilCostList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getOilCostList());
		result.put("totalCount", busTripService.getOilCostListTotal());

		return result;
	}

	@RequestMapping(value = "/busTrip/getCityCostList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCityCostList(@RequestParam Map<String, Object> map) {
		logger.info("getCityCostList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getCityCostList(map));
		result.put("totalCount", busTripService.getCityCostListTotal());

		return result;
	}

	@RequestMapping(value = "/busTrip/getOilTypeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getOilTypeList(@RequestParam Map<String, Object> map) {
		logger.info("getOilTypeList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getOilTypeList());

		return result;
	}

	@RequestMapping(value = "/busTrip/getCarTypeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCarTypeList(@RequestParam Map<String, Object> map) {
		logger.info("getCarTypeList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getCarTypeList());

		return result;
	}

	@RequestMapping(value = "/busTrip/getTimeTypeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getTimeTypeList(@RequestParam Map<String, Object> map) {
		logger.info("getTimeTypeList");
		Map<String, Object> result = new HashMap<String, Object>();

		result.put("list", busTripService.getTimeTypeList());

		return result;
	}

	@RequestMapping(value = "/busTrip/saveOilCost", method = RequestMethod.POST)
	@ResponseBody
	public String saveOilCost(@RequestParam Map<String, Object> map) {
		logger.info("saveOilCost");

		String result = "success";
		try {
			busTripService.saveOilCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/modOilCost", method = RequestMethod.POST)
	@ResponseBody
	public String modOilCost(@RequestParam Map<String, Object> map) {
		logger.info("modOilCost");

		String result = "success";
		try {
			busTripService.modOilCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/delOilCost", method = RequestMethod.POST)
	@ResponseBody
	public String delOilCost(@RequestParam Map<String, Object> map) {
		logger.info("delOilCost");

		String result = "success";
		try {
			busTripService.delOilCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/saveCityCost", method = RequestMethod.POST)
	@ResponseBody
	public String saveCityCost(@RequestParam Map<String, Object> map) {
		logger.info("saveCityCost");

		String result = "success";
		try {
			busTripService.saveCityCost(map);
		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/modCityCost", method = RequestMethod.POST)
	@ResponseBody
	public String modCityCost(@RequestParam Map<String, Object> map) {
		logger.info("modCityCost");

		String result = "success";
		try {
			busTripService.modCityCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/delCityCost", method = RequestMethod.POST)
	@ResponseBody
	public String delCityCost(@RequestParam Map<String, Object> map) {
		logger.info("delCityCost");

		String result = "success";
		try {
			busTripService.delCityCost(map);
		} catch (Exception e) {

			result = "fail";
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/getCityCost", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCityCost(@RequestParam Map<String, Object> map) {
		logger.info("getCityCost");

		Map<String, Object> result = new HashMap<String, Object>();
		try {
			busTripService.getCityCost(map);
			result.put("result", busTripService.getCityCost(map));

		} catch (Exception e) {

		}

		return result;

	}

	@RequestMapping(value = "/busTrip/getErpEmpNumByDept", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getErpEmpNumByDept(@RequestParam Map<String, Object> map) {
		logger.info("getErpEmpNumByDept");
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			result.put("result", busTripService.getErpEmpNumByDept(map));
		} catch (Exception e) {
			
		}
		
		return result;
	}
	@RequestMapping(value = "/busTrip/addUserInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addUserInfo(@RequestParam Map<String, Object> map) {
		logger.info("addUserInfo");

		Map<String, Object> result = new HashMap<>();

		try {
			result.put("result", busTripService.addUserInfo(map));
		} catch (Exception e) {
				logger.info("addUserInfo",e);
		}

		return result;
	}

	@RequestMapping(value = "/busTrip/getClientInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getClientInfo(@RequestParam Map<String, Object> map) {
		logger.info("getClientInfo");

		Map<String, Object> result = new HashMap<>();

		try {
			result.put("result", busTripService.getClientInfo(map));

		} catch (Exception e) {

		}

		return result;
	}

	@RequestMapping(value = "/busTrip/bizInsertOutSubCard", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bizInsertOutSubCard(@RequestParam Map<String, Object> map) {
		logger.info("bizInsertOutSubCard");
		
		try {
			busTripService.bizInsertOutSubCard(map);
			
		} catch (Exception e) {
			logger.info("[bizInsertOutSubCard]",e);
		}
		
		return map;
	}
	@RequestMapping(value = "/busTrip/insertResTrade", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertResTrade(@RequestParam Map<String, Object> map) {
		logger.info("insertResTrade");

		try {
			busTripService.insertResTrade(map);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return map;
	}

	@RequestMapping(value = "/busTrip/deleteOutSub", method = RequestMethod.POST)
	@ResponseBody
	public void deleteOutSub(@RequestParam Map<String, Object> map) {
		logger.info("deleteOutSub");
		
		try {
			busTripService.deleteOutSub(map);
			
		} catch (Exception e) {
			logger.info("deleteOutSub",e);
		}
		
	}
	@RequestMapping(value = "/busTrip/getToolTipFile", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getToolTipFile(@RequestParam Map<String, Object> map) {
		logger.info("getToolTipFile");
		
		Map<String, Object> result = new HashMap<>();
		try {
		
			result.put("result", busTripService.getToolTipFile(map));
		} catch (Exception e) {
			logger.info("getToolTipFile",e);
		}
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/deleteResTrade", method = RequestMethod.POST)
	@ResponseBody
	public void deleteResTrade(@RequestParam Map<String, Object> map) {
		logger.info("deleteResTrade");

		try {
			busTripService.deleteResTrade(map);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@RequestMapping(value = "/busTrip/beforeDeleteBiz", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> beforeDeleteBiz(@RequestParam Map<String, Object> map) {
		logger.info("beforeDeleteBiz");
		
		try {
			
			busTripService.beforeDeleteCity(map);
			busTripService.beforeDeleteCommon(map);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
		
	}
	@RequestMapping(value = "/busTrip/insertBizCommon", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertBizCommon(@RequestParam Map<String, Object> map) {
		logger.info("insertBizCommon");
		
			try {
				
				busTripService.insertBizCommon(map);

			} catch (Exception e) {
				e.printStackTrace();
			}
			return map;

	}

	@RequestMapping(value = "/busTrip/insertBizSub", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertBizSub(@RequestParam Map<String, Object> map) {
		logger.info("insertBizSub");

			try {
				busTripService.insertBizSub(map);

			} catch (Exception e) {
				e.printStackTrace();
			}

		return map;

	}

	@RequestMapping(value = "/busTrip/getOutBtRow", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getOutBtRow(@RequestParam Map<String, Object> map) {
		logger.info("getBtRowData");
		
		Map<String, Object> result = new HashMap<>();
		try {
			result.put("result", busTripService.getOutBtRow(map));
			
		} catch (Exception e) {
			logger.info("getOutBtRow 에러",e);
		}
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/getBtRowData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBtRowData(@RequestParam Map<String, Object> map) {
		logger.info("getBtRowData");

		Map<String, Object> result = new HashMap<>();

		result.put("result", busTripService.getBtRowData(map));

		return result;

	}
	@RequestMapping(value = "/busTrip/getBtRowData2", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBtRowData2(@RequestParam Map<String, Object> map) {
		logger.info("getBtRowData2");
		
		Map<String, Object> result = new HashMap<>();
		
		result.put("result", busTripService.getBtRowData2(map));
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/getRowdataNow", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getRowdataNow(@RequestParam Map<String, Object> map) {
		logger.info("getRowdataNow");
		
		Map<String, Object> result = new HashMap<>();
		
		result.put("result", busTripService.getRowdataNow(map));
		
		return result;
		
	}

	@RequestMapping(value = "/busTrip/makeExcel", method = RequestMethod.POST)
	@ResponseBody
	public void makeExcel(@RequestBody List<Map<String, Object>> list, HttpServletRequest request)
			throws EncryptedDocumentException, InvalidFormatException, IOException {
		logger.info("makeExcel");
		
		
		String path = request.getSession().getServletContext().getRealPath("/exceltemplate/" + "BusTripTemplete.xlsx");

		XSSFWorkbook workbook = (XSSFWorkbook) WorkbookFactory.create(new File(path));

		XSSFSheet sheet = workbook.getSheetAt(0);

		// 기본 스타일
		XSSFCellStyle style = workbook.createCellStyle();

		// 마지막 합계 줄 스타일 ( 기본줄+ 배경 + 글씨굵게 + 글씨크기)
		XSSFCellStyle style2 = workbook.createCellStyle();

		// 기본 금액 스타일
		XSSFCellStyle style3 = workbook.createCellStyle();

		// 마지막줄 금액 스타일(기본 금액스타일 + 배경 + 글씨굵게 + 글씨크기)
		XSSFCellStyle style4 = workbook.createCellStyle();

		////////////////////////////////////////////////////////

		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		////////////////////////////////////////////////////////

		style2.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style2.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style2.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style2.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style2.setAlignment(HorizontalAlignment.CENTER);
		style2.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		// 배경색 넣기
		style2.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style2.setFillPattern(CellStyle.SOLID_FOREGROUND);

		// 폰트 굵기 조절 및 사이즈 조절
		Font boldFont = workbook.createFont();
		boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		boldFont.setFontName("맑은 고딕");
		boldFont.setFontHeight((short) (13 * 20));

		// 굵기 크기 조절한 폰트 넣어주기
		style2.setFont(boldFont);

		////////////////////////////////////////////////////////

		style3.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style3.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style3.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style3.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style3.setAlignment(HorizontalAlignment.CENTER);
		style3.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		// 데이터 포멧 만들기
		XSSFDataFormat format = workbook.createDataFormat();

		// 데이터포멧 천 자리 컴마
		style3.setDataFormat(format.getFormat("#,##0"));

		////////////////////////////////////////////////////////

		style4.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style4.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style4.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style4.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style4.setAlignment(HorizontalAlignment.CENTER);
		style4.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		// 배경색 넣기
		style4.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style4.setFillPattern(CellStyle.SOLID_FOREGROUND);

		// 폰트 굵기 넣어주기
		style4.setFont(boldFont);
		// 데이터포멧 천 자리 컴마 넣어주기
		style4.setDataFormat(format.getFormat("#,##0"));

		////////////////////////////////////////////////////////

		// 엑셀 rownum 인데 템플릿상에 위에 2줄은 있어서
		int rownum = 2;

		// 입력된줄 숫자
		int rowCnt = 0;

		// 맨 마지막 행 토탈금액 산출용 변수
		int realLastAmt = 0;

		// 파일키는 한개만있어도되니까 for문 돌리기전에 하나뺴서 저장해놓자
		String fileKey = (String) list.get(0).get("file_key");

		logger.info("====================넘어온 파일키 : " + fileKey + "===============================");
		if (fileKey == "" || fileKey == null) {

			fileKey = "Y" + java.util.UUID.randomUUID().toString();

			logger.info("====================새로만든 파일키 : " + fileKey + "===============================");

			String tempPath;
			try {

				tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
				CommFileUtil.makeDir(tempPath + fileKey);

			} catch (Exception e) {
				logger.info("폴더 만들기오류~", e);
				e.printStackTrace();
			}

		}

		for (int i = 0; i < list.size(); i++) {
			rowCnt = 0;
			Map<String, Object> m = list.get(i);

			String bkNb = (String) m.get("bankNb");
			int orderNb = (int) m.get("orderNb");

			String Yn = (String) (m.get("useYn"));

			if (Yn.equals("N")) {
				Map<String, Object[]> data = new TreeMap<String, Object[]>();
				data.put(String.valueOf(i),
						new Object[] { m.get("depositor"), m.get("bankNb"), m.get("date"),
								m.get("stime") + "~" + m.get("etime") + "(" + m.get("hour") + "시간)", m.get("purpose"),
								m.get("location"), m.get("carYn"), m.get("amt") });

				for (String key : data.keySet()) {
					Row row = sheet.createRow(rownum++);
					row.setHeight((short) 400);

					Object[] objArr = data.get(key);
					int cellnum = 0;
					for (Object obj : objArr) {
						Cell cell = row.createCell(cellnum++);
						cell.setCellStyle(style);

						if (obj instanceof Date)
							cell.setCellValue((Date) obj);
						else if (obj instanceof Boolean)
							cell.setCellValue((Boolean) obj);
						else if (obj instanceof String)
							cell.setCellValue((String) obj);
						else if (obj instanceof Double)
							cell.setCellValue((Double) obj);
						else if (obj instanceof Integer)
							cell.setCellValue((Integer) obj);
						// int 값일경우는 스타일3번 적용 (천자리 컴마)
						cell.setCellStyle(style3);
					}
					rowCnt++;
				}

				list.get(i).put("useYn", "Y");
			}

			for (int j = 0; j < list.size(); j++) {
				Map<String, Object> m2 = list.get(j);
				if (m2.get("bankNb").equals(bkNb) && !m2.get("orderNb").equals(orderNb)
						&& m2.get("useYn").equals("N")) {
					Map<String, Object[]> data = new TreeMap<String, Object[]>();
					data.put(String.valueOf(this),
							new Object[] { m2.get("depositor"), m2.get("bankNb"), m2.get("date"),
									m2.get("stime") + "~" + m2.get("etime") + "(" + m2.get("hour") + "시간)",
									m2.get("purpose"), m2.get("location"), m2.get("carYn"), m2.get("amt") });

					for (String key : data.keySet()) {
						Row row = sheet.createRow(rownum++);
						row.setHeight((short) 400);
						Object[] objArr = data.get(key);
						int cellnum = 0;
						for (Object obj : objArr) {
							Cell cell = row.createCell(cellnum++);
							cell.setCellStyle(style);

							if (obj instanceof Date)
								cell.setCellValue((Date) obj);
							else if (obj instanceof Boolean)
								cell.setCellValue((Boolean) obj);
							else if (obj instanceof String)
								cell.setCellValue((String) obj);
							else if (obj instanceof Double)
								cell.setCellValue((Double) obj);
							else if (obj instanceof Integer)
								cell.setCellValue((Integer) obj);
							// int 값일경우는 스타일3번 적용 (천자리 컴마)
							cell.setCellStyle(style3);
						}
						rowCnt++;
					}

					list.get(j).put("useYn", "Y");
				}

			}
			// 쓰인 행이 2개 이상일때 즉, 셀병합이 필요할때
			if (rowCnt > 1) {

				// 병합 끝 행 줄번호
				int endRow = rownum - 1;

				// 병합 시작 행 줄번호
				int startRow = rownum - rowCnt;

				// 병합만하면되는게 아니라 값을 다 더해줘야해서 시작줄~ 끝줄까지 for문 돌리기위해 시작줄번호를 하나 카피해놈
				int startRowCpoy = startRow;

				// 병합할 행 총 합 가격
				int totalAmt = 0;

				// 병합할 행들의 값들 더하기
				for (; startRowCpoy <= endRow; startRowCpoy++) {

					totalAmt += (int) sheet.getRow(startRowCpoy).getCell(7).getNumericCellValue();

					// 병합셀 선언하고 스타일적용 및 값 세팅
					XSSFRow mergeRow = sheet.getRow(startRowCpoy);
					XSSFCell mergeCells = mergeRow.createCell(8);
					mergeCells.setCellStyle(style3);

					// 마지막 행 까지 다 했으면 첫번째 행의 컬럼(cell)에 총합계를 넣어주자
					// [엑셀에서 병합하게되면 병합하는 행이나 컬럼의 첫번째값으로 통일되기때문에]
					if (startRowCpoy == endRow) {
						XSSFCell firstCell = sheet.getRow(startRow).getCell(8);
						firstCell.setCellValue(totalAmt);
						realLastAmt += totalAmt;

					}
				}

				// 성명 병합 (행부터 행 / 컬럼부터 컬럼)
				sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, 0, 0));

				// 임금계좌 병합
				sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, 1, 1));

				// 총액 병합
				sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, 8, 8));

				// 행의 숫자가 1일때 즉, 병합할필요없는 단일 행일때
			} else if (rowCnt == 1) {
				int startRow = rownum - rowCnt;
				int totalAmtOne = (int) sheet.getRow(startRow).getCell(7).getNumericCellValue();

				XSSFRow mergeRow = sheet.getRow(startRow);
				XSSFCell mergeCells = mergeRow.createCell(8);
				mergeCells.setCellStyle(style3);
				mergeCells.setCellValue(totalAmtOne);
				realLastAmt += totalAmtOne;
			}

		}

		XSSFRow lastRow = sheet.createRow(rownum);
		lastRow.setHeight((short) 500); // 행의 높이 조정

		XSSFCell lastCell = lastRow.createCell(0);
		lastCell.setCellValue("합계");

		// 마지막줄 병합해서 합계 줄 만들기
		sheet.addMergedRegion(new CellRangeAddress(rownum, rownum, 0, 6));

		// 셀마다 스타일적용 테두리 및 가운데정렬
		sheet.getRow(rownum).getCell(0).setCellStyle(style2);
		sheet.getRow(rownum).createCell(1).setCellStyle(style2);
		sheet.getRow(rownum).createCell(2).setCellStyle(style2);
		sheet.getRow(rownum).createCell(3).setCellStyle(style2);
		sheet.getRow(rownum).createCell(4).setCellStyle(style2);
		sheet.getRow(rownum).createCell(5).setCellStyle(style2);
		sheet.getRow(rownum).createCell(6).setCellStyle(style2);

		// 총액 입력하기
		sheet.getRow(rownum).createCell(7).setCellValue(realLastAmt);
		sheet.getRow(rownum).getCell(7).setCellStyle(style4);

		// 셀마다 스타일적용 테두리 및 가운데정렬
		sheet.getRow(rownum).createCell(8).setCellStyle(style4);

		// 7~8번 컬럼 병합
		sheet.addMergedRegion(new CellRangeAddress(rownum, rownum, 7, 8));

		try {
			
			// 공통기능 업로드 템프 경로 불어오기
			String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");

			
			File dir = new File(tempPath+fileKey);
			
			if(!dir.isDirectory()){
				CommFileUtil.makeDir(tempPath + fileKey);
			}

			FileOutputStream out = new FileOutputStream(new File(tempPath + fileKey + File.separator + "출장비 집계표.xlsx"));

			workbook.write(out);

			out.close();

			logger.info("출장집계표 만들었어요");

		} catch (FileNotFoundException e) {
			
			logger.info("FileNotFoundException", e);
		} catch (IOException e) {
			logger.info("IOException", e);
		} catch (Exception e) {
			logger.info("Exception", e);
		}
	}
	@RequestMapping(value = "/busTrip/makeExcel2", method = RequestMethod.POST)
	@ResponseBody
	public void makeExcel2(@RequestBody List<Map<String, Object>> list, HttpServletRequest request)
			throws EncryptedDocumentException, InvalidFormatException, IOException {
		logger.info("makeExcel2");
		
		
		String path = request.getSession().getServletContext()
				.getRealPath("/exceltemplate/" + "outTripTemplete.xlsx");
		
		XSSFWorkbook workbook = (XSSFWorkbook) WorkbookFactory.create(new File(path));
		
		XSSFSheet sheet = workbook.getSheetAt(0);
		
		// 기본 스타일
		XSSFCellStyle style = workbook.createCellStyle();
		
		// 마지막 합계 줄 스타일 ( 기본줄+ 배경 + 글씨굵게 + 글씨크기)
		XSSFCellStyle style2 = workbook.createCellStyle();
		
		// 기본 금액 스타일
		XSSFCellStyle style3 = workbook.createCellStyle();
		
		// 마지막줄 금액 스타일(기본 금액스타일 + 배경 + 글씨굵게 + 글씨크기)
		XSSFCellStyle style4 = workbook.createCellStyle();
		
		////////////////////////////////////////////////////////
		
		style.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style.setAlignment(HorizontalAlignment.CENTER);
		style.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		
		////////////////////////////////////////////////////////
		
		style2.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style2.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style2.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style2.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style2.setAlignment(HorizontalAlignment.CENTER);
		style2.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		
		// 배경색 넣기
		style2.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style2.setFillPattern(CellStyle.SOLID_FOREGROUND);
		
		// 폰트 굵기 조절 및 사이즈 조절
		Font boldFont = workbook.createFont();
		boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		boldFont.setFontName("맑은 고딕");
		boldFont.setFontHeight((short) (13 * 20));
		
		// 굵기 크기 조절한 폰트 넣어주기
		style2.setFont(boldFont);
		
		////////////////////////////////////////////////////////
		
		style3.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style3.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style3.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style3.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style3.setAlignment(HorizontalAlignment.CENTER);
		style3.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		
		// 데이터 포멧 만들기
		XSSFDataFormat format = workbook.createDataFormat();
		
		// 데이터포멧 천 자리 컴마
		style3.setDataFormat(format.getFormat("#,##0"));
		
		////////////////////////////////////////////////////////
		
		style4.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		style4.setBorderRight(XSSFCellStyle.BORDER_THIN);
		style4.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		style4.setBorderTop(XSSFCellStyle.BORDER_THIN);
		style4.setAlignment(HorizontalAlignment.CENTER);
		style4.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		
		// 배경색 넣기
		style4.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		style4.setFillPattern(CellStyle.SOLID_FOREGROUND);
		
		// 폰트 굵기 넣어주기
		style4.setFont(boldFont);
		// 데이터포멧 천 자리 컴마 넣어주기
		style4.setDataFormat(format.getFormat("#,##0"));
		
		////////////////////////////////////////////////////////
		
		// 엑셀 rownum 인데 템플릿상에 위에 2줄은 있어서
		int rownum = 2;
		
		// 입력된줄 숫자
		int rowCnt = 0;
		
		// 맨 마지막 행 토탈금액 산출용 변수
		int realLastAmt = 0;
		
		// 파일키는 한개만있어도되니까 for문 돌리기전에 하나뺴서 저장해놓자
		String fileKey = (String) list.get(0).get("file_key");
		
		logger.info("====================넘어온 파일키 : " + fileKey + "===============================");
		if (fileKey == "" || fileKey == null) {
			
			fileKey = "Y" + java.util.UUID.randomUUID().toString();
			
			logger.info("====================새로만든 파일키 : " + fileKey + "===============================");
			
			String tempPath;
			try {
				
				tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
				CommFileUtil.makeDir(tempPath + fileKey);
				
			} catch (Exception e) {
				logger.info("폴더 만들기오류~", e);
				e.printStackTrace();
			}
			
		}
		
		for (int i = 0; i < list.size(); i++) {
			rowCnt = 0;
			Map<String, Object> m = list.get(i);
			
			String bkNb = (String) m.get("bankNb");
			int orderNb = (int) m.get("orderNb");
			
			String Yn = (String) (m.get("useYn"));
			
			if (Yn.equals("N")) {
				Map<String, Object[]> data = new TreeMap<String, Object[]>();
				data.put(String.valueOf(i),
						new Object[] { m.get("depositor"), m.get("bankNb"), m.get("sdate")+"~"+m.get("edate"),m.get("term"),
								 m.get("purpose"),	m.get("location"), m.get("carYn"), m.get("amt") });
				
				for (String key : data.keySet()) {
					Row row = sheet.createRow(rownum++);
					row.setHeight((short) 400);
					
					Object[] objArr = data.get(key);
					int cellnum = 0;
					for (Object obj : objArr) {
						Cell cell = row.createCell(cellnum++);
						cell.setCellStyle(style);
						
						if (obj instanceof Date)
							cell.setCellValue((Date) obj);
						else if (obj instanceof Boolean)
							cell.setCellValue((Boolean) obj);
						else if (obj instanceof String)
							cell.setCellValue((String) obj);
						else if (obj instanceof Double)
							cell.setCellValue((Double) obj);
						else if (obj instanceof Integer)
							cell.setCellValue((Integer) obj);
						// int 값일경우는 스타일3번 적용 (천자리 컴마)
						cell.setCellStyle(style3);
					}
					rowCnt++;
				}
				
				list.get(i).put("useYn", "Y");
			}
			
			for (int j = 0; j < list.size(); j++) {
				Map<String, Object> m2 = list.get(j);
				if (m2.get("bankNb").equals(bkNb) && !m2.get("orderNb").equals(orderNb)
						&& m2.get("useYn").equals("N")) {
					Map<String, Object[]> data = new TreeMap<String, Object[]>();
					data.put(String.valueOf(this),
							new Object[] { m2.get("depositor"), m2.get("bankNb"), m.get("sdate")+"~"+m.get("edate"),m.get("term"),
									m2.get("purpose"), m2.get("location"), m2.get("carYn"), m2.get("amt") });
					
					for (String key : data.keySet()) {
						Row row = sheet.createRow(rownum++);
						row.setHeight((short) 400);
						Object[] objArr = data.get(key);
						int cellnum = 0;
						for (Object obj : objArr) {
							Cell cell = row.createCell(cellnum++);
							cell.setCellStyle(style);
							
							if (obj instanceof Date)
								cell.setCellValue((Date) obj);
							else if (obj instanceof Boolean)
								cell.setCellValue((Boolean) obj);
							else if (obj instanceof String)
								cell.setCellValue((String) obj);
							else if (obj instanceof Double)
								cell.setCellValue((Double) obj);
							else if (obj instanceof Integer)
								cell.setCellValue((Integer) obj);
							// int 값일경우는 스타일3번 적용 (천자리 컴마)
							cell.setCellStyle(style3);
						}
						rowCnt++;
					}
					
					list.get(j).put("useYn", "Y");
				}
				
			}
			// 쓰인 행이 2개 이상일때 즉, 셀병합이 필요할때
			if (rowCnt > 1) {
				
				// 병합 끝 행 줄번호
				int endRow = rownum - 1;
				
				// 병합 시작 행 줄번호
				int startRow = rownum - rowCnt;
				
				// 병합만하면되는게 아니라 값을 다 더해줘야해서 시작줄~ 끝줄까지 for문 돌리기위해 시작줄번호를 하나 카피해놈
				int startRowCpoy = startRow;
				
				// 병합할 행 총 합 가격
				int totalAmt = 0;
				
				// 병합할 행들의 값들 더하기
				for (; startRowCpoy <= endRow; startRowCpoy++) {
					
					totalAmt += (int) sheet.getRow(startRowCpoy).getCell(7).getNumericCellValue();
					
					// 병합셀 선언하고 스타일적용 및 값 세팅
					XSSFRow mergeRow = sheet.getRow(startRowCpoy);
					XSSFCell mergeCells = mergeRow.createCell(8);
					mergeCells.setCellStyle(style3);
					
					// 마지막 행 까지 다 했으면 첫번째 행의 컬럼(cell)에 총합계를 넣어주자
					// [엑셀에서 병합하게되면 병합하는 행이나 컬럼의 첫번째값으로 통일되기때문에]
					if (startRowCpoy == endRow) {
						XSSFCell firstCell = sheet.getRow(startRow).getCell(8);
						firstCell.setCellValue(totalAmt);
						realLastAmt += totalAmt;
						
					}
				}
				
				// 성명 병합 (행부터 행 / 컬럼부터 컬럼)
				sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, 0, 0));
				
				// 임금계좌 병합
				sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, 1, 1));
				
				// 총액 병합
				sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, 8, 8));
				
				// 행의 숫자가 1일때 즉, 병합할필요없는 단일 행일때
			} else if (rowCnt == 1) {
				int startRow = rownum - rowCnt;
				int totalAmtOne = (int) sheet.getRow(startRow).getCell(7).getNumericCellValue();
				
				XSSFRow mergeRow = sheet.getRow(startRow);
				XSSFCell mergeCells = mergeRow.createCell(8);
				mergeCells.setCellStyle(style3);
				mergeCells.setCellValue(totalAmtOne);
				realLastAmt += totalAmtOne;
			}
			
		}
		
		XSSFRow lastRow = sheet.createRow(rownum);
		lastRow.setHeight((short) 500); // 행의 높이 조정
		
		XSSFCell lastCell = lastRow.createCell(0);
		lastCell.setCellValue("합계");
		
		// 마지막줄 병합해서 합계 줄 만들기
		sheet.addMergedRegion(new CellRangeAddress(rownum, rownum, 0, 6));
		
		// 셀마다 스타일적용 테두리 및 가운데정렬
		sheet.getRow(rownum).getCell(0).setCellStyle(style2);
		sheet.getRow(rownum).createCell(1).setCellStyle(style2);
		sheet.getRow(rownum).createCell(2).setCellStyle(style2);
		sheet.getRow(rownum).createCell(3).setCellStyle(style2);
		sheet.getRow(rownum).createCell(4).setCellStyle(style2);
		sheet.getRow(rownum).createCell(5).setCellStyle(style2);
		sheet.getRow(rownum).createCell(6).setCellStyle(style2);
		
		// 총액 입력하기
		sheet.getRow(rownum).createCell(7).setCellValue(realLastAmt);
		sheet.getRow(rownum).getCell(7).setCellStyle(style4);
		
		// 셀마다 스타일적용 테두리 및 가운데정렬
		sheet.getRow(rownum).createCell(8).setCellStyle(style4);
		
		// 7~8번 컬럼 병합
		sheet.addMergedRegion(new CellRangeAddress(rownum, rownum, 7, 8));
		
		try {
			
			// 공통기능 업로드 템프 경로 불어오기
			String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
			
			
			File dir = new File(tempPath+fileKey);
			
			if(!dir.isDirectory()){
				CommFileUtil.makeDir(tempPath + fileKey);
			}
			
			FileOutputStream out = new FileOutputStream(new File(tempPath + fileKey + File.separator + "출장비 집계표.xlsx"));
			
			workbook.write(out);
			
			out.close();
			
			logger.info("출장집계표 만들었어요");
			
		} catch (FileNotFoundException e) {
			
			logger.info("FileNotFoundException", e);
		} catch (IOException e) {
			logger.info("IOException", e);
		} catch (Exception e) {
			logger.info("Exception", e);
		}
	}

	@RequestMapping(value = "/busTrip/outSideBusTrip", method = RequestMethod.GET)
	public String outSideBusTrip(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("outSideBusTrip");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", map);

		return "/busTrip/iframe/outSideBusTrip";

	}
	
	@RequestMapping(value = "/busTrip/outSideBusTrip2", method = RequestMethod.GET)
	public String outSideBusTrip2(Model model, @RequestParam Map<String, Object> map, HttpServletRequest servletRequest)
			throws NoPermissionException {
		logger.info("outSideBusTrip");

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("loginVO", loginVO);
		model.addAttribute("params", map);

		return "/busTrip/iframe/outSideBusTrip2";

	}

	@RequestMapping(value = "/busTrip/zxcv", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> zxcv(@RequestParam Map<String, Object> map, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		logger.info("zxcv");

		String serviceKey = "F720200318";
		String returnTYpe = "json";

		StringBuilder urlBuilder = new StringBuilder("http://www.opinet.co.kr/api/"); /* URL */

		urlBuilder.append(URLEncoder.encode((String) map.get("serviceNm"),"UTF-8")); /* Service name */

		urlBuilder.append("?" + URLEncoder.encode("out", "UTF-8") + "="	+ URLEncoder.encode(returnTYpe, "UTF-8")); /* return type */

		urlBuilder.append("&" + URLEncoder.encode("code", "UTF-8") + "="+ serviceKey); /* Service Key */

		if(map.get("sido") != null){
			urlBuilder.append("&" + URLEncoder.encode("sido", "UTF-8") + "="	+ URLEncoder.encode((String)(map.get("sido")) , "UTF-8")); /* return type */
			
		}
		if(map.get("prodcd") != null){
			urlBuilder.append("&" + URLEncoder.encode("prodcd", "UTF-8") + "="	+ URLEncoder.encode((String)(map.get("prodcd")) , "UTF-8")); /* return type */
			
		}

		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		System.out.println(sb.toString());

		Map<String, Object> result = new HashMap<>();

		result.put("result", sb.toString());
		
		
		return result;

	}
	
	@RequestMapping(value = "/busTrip/trainApi", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> trainApi(@RequestParam Map<String, Object> map, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		logger.info("trainApi");
		
		String serviceKey = "i6rIbaBdbjN9T6Ql3X8uE%2B6gLNHQFD1tNKdmgv%2BgLr3uuB8o%2BimI%2FeFsMarCHsBiCsGt%2BY384lSBdVg1Ds3GFQ%3D%3D";
		
		StringBuilder urlBuilder = new StringBuilder("http://openapi.tago.go.kr/openapi/service/TrainInfoService/"); /* URL */
		
		urlBuilder.append(URLEncoder.encode("getStrtpntAlocFndTrainInfo","UTF-8")); /* Service name */
		
		urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "="+ serviceKey); /* Service Key */
		
		urlBuilder.append("&" + URLEncoder.encode("depPlandTime", "UTF-8") + "="	+ URLEncoder.encode((String)(map.get("depPlandTime")) , "UTF-8")); /* 날짜 */
		
		urlBuilder.append("&" + URLEncoder.encode("depPlaceId", "UTF-8") + "="	+ URLEncoder.encode((String)(map.get("depPlaceId")) , "UTF-8")); /* 출발지 */
			
		urlBuilder.append("&" + URLEncoder.encode("arrPlaceId", "UTF-8") + "="	+ URLEncoder.encode((String)(map.get("arrPlaceId")) , "UTF-8")); /* 도착지 */
		
		urlBuilder.append("&" + URLEncoder.encode("trainGradeCode", "UTF-8") + "="	+ URLEncoder.encode((String)(map.get("trainGradeCode")) , "UTF-8")); /* 기차등급 */
		
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "="	+ URLEncoder.encode("1000" , "UTF-8")); /* 행갯수 */
			
		
		URL url = new URL(urlBuilder.toString());
		
		System.out.println("호출 URL : "+url);
		logger.info("호출 URL : "+url);
		
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");
		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}
		StringBuilder sb = new StringBuilder();
		String line;
		while ((line = rd.readLine()) != null) {
			
			sb.append(line);
		}
		rd.close();
		conn.disconnect();
		System.out.println(sb.toString());
		
		JSONObject xml = XML.toJSONObject(sb.toString());
		
		String xmlString = xml.toString();
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		
		Map<String, Object> result = new HashMap<>();
       
		Map<String, Object> data = new HashMap<>();


		data = objectMapper.readValue(xmlString, new TypeReference<Map<String, Object>>(){});
		
		 Map<String, Object> dataResponse = (Map<String, Object>) data.get("response");
         Map<String, Object> body = (Map<String, Object>) dataResponse.get("body");
         Map<String, Object> items = null;
         List<Map<String, Object>> itemList = null;
         	
         System.out.println(body);
        
         if(!body.get("totalCount").toString().equals("0"))  {
         items = (Map<String, Object>) body.get("items");
         itemList = (List<Map<String, Object>>) items.get("item");

         result.put("result", itemList);
         
         } else{
        	 
        	 List<Map<String, Object>> notItem = new ArrayList<>();
        	 Map<String, Object> nonono = new HashMap<>();
        	 nonono.put("adultcharge", 0);
        	 
        	 notItem.add(nonono);
        	 
        	 result.put("result", notItem);
         }
		
		return result;
		
	}
	
	
	@Scheduled(cron="0 0 6 * * *")
	@RequestMapping(value = "/busTrip/UgaBatch", method = RequestMethod.GET)
	@ResponseBody
	public void UgaBatch() throws IOException {
		logger.info("================UgaBatch============ 매일 오전 6시 실행 ==========================");
		
		String serviceKey = "F720200318";
		String returnTYpe = "json";
		StringBuilder urlBuilder = new StringBuilder("http://www.opinet.co.kr/api/"); /* URL */
		
		urlBuilder.append(URLEncoder.encode("avgSidoPrice.do","UTF-8")); /* Service name */
		
		urlBuilder.append("?" + URLEncoder.encode("out", "UTF-8") + "="	+ URLEncoder.encode(returnTYpe, "UTF-8")); /* return type */
		
		urlBuilder.append("&" + URLEncoder.encode("code", "UTF-8") + "="+ serviceKey); /* Service Key */
		
		
		URL url = new URL(urlBuilder.toString());
		logger.info("================유가배치URL============ :  "+ url);
		
		try {
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Content-type", "application/json");
			
			logger.info("===========유가배치 응답코드=========== :  " + conn.getResponseCode());
			
			BufferedReader rd;
			
			if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
				logger.info("==============유가배치 연결================");
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				logger.info("==============유가배치 연결 실패================");
				rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			
			StringBuilder sb = new StringBuilder();
			
			String line;
			while ((line = rd.readLine()) != null) {
				
				sb.append(line);
			}
			rd.close();
			conn.disconnect();
			
			logger.info("==========유가배치 결과 : "+sb.toString());
			
			JsonParser jsonparser = new JsonParser();
			
			JsonObject jsonOBJ = (JsonObject)jsonparser.parse(sb.toString());
			JsonObject jsonOBJ2 = (JsonObject)jsonOBJ.get("RESULT");
			JsonArray arr =  (JsonArray) jsonOBJ2.get("OIL");
			
			
			
			
			SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy-MM-dd");
			
			Date time = new Date();
			
			String time1 = format1.format(time);
			
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			
			for(int i =0; i< arr.size(); i++){
				
				JsonObject jsonOBJ3 = (JsonObject)arr.get(i);
				
				Map<String, Object> map = new HashMap<>();
				
				map.put("SIDOCD", jsonOBJ3.get("SIDOCD").toString());
				map.put("SIDONM", jsonOBJ3.get("SIDONM").toString());
				map.put("PRICE",  Double.valueOf(jsonOBJ3.get("PRICE").toString()));
				map.put("PRODCD", jsonOBJ3.get("PRODCD").toString());
				map.put("DATE", time1);
				
				list.add(map);
				
			}
			
			busTripService.UgaBatch(list);
		} catch (Exception e) {
			logger.info("유가배치오류",e);
		}
		
		
	}
	
	
	@RequestMapping(value = "/busTrip/makeFileKey", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> makeFileKey(@RequestParam Map<String, Object> map) {
		logger.info("===============makeFileKey===============");
		Map<String, Object> result = new HashMap<String, Object>();
		String fileKey = "Y" + java.util.UUID.randomUUID().toString();
		
		result.put("dj_fileKey", fileKey);
		
		return result;
	}
	
	@RequestMapping(value = "/busTrip/getKorailVehicle", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getKorailVehicle(@RequestParam Map<String, Object> map) {
		logger.info("===============getKorailVehicle===============");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", busTripService.getKorailVehicle());
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getKorailCity", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getKorailCity(@RequestParam Map<String, Object> map) {
		logger.info("===============getKorailCity===============");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", busTripService.getKorailCity());
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getKorailNode", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getKorailNode(@RequestParam Map<String, Object> map) {
		logger.info("===============getKorailNode===============");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("list", busTripService.getKorailNode(map));
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getUga", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getUga(@RequestParam Map<String, Object> map) {
		logger.info("===============getUga===============");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("result", busTripService.getUga(map));
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getGradeCost", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getGradeCost(@RequestParam Map<String, Object> map) {
		logger.info("===============getGradeCost===============");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("result", busTripService.getGradeCost(map));
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getOilTypeCost", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getOilTypeCost(@RequestParam Map<String, Object> map) {
		logger.info("===============getOilTypeCost===============");
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("result", busTripService.getOilTypeCost(map));
		
		return result;
	}
	@RequestMapping(value = "/busTrip/bizInsertBody", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bizInsertBody(@RequestParam Map<String, Object> map) {
		logger.info("===============bizInsertBody===============");
		
		busTripService.bizInsertBody(map);
		
		return map;
	}
	@RequestMapping(value = "/busTrip/selectOutBizInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selectOutBizInfo(@RequestParam Map<String, Object> map) {
		logger.info("===============selectOutBizInfo===============");
		
		busTripService.selectOutBizInfo(map);
		
		return busTripService.selectOutBizInfo(map);
	}
	
	
	@RequestMapping(value = "/busTrip/updateLastcommon", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateLastcommon(@RequestParam Map<String, Object> map) {
		logger.info("updateLastcommon");


				busTripService.updateLastcommon(map);


		return map;
	}
	@RequestMapping(value = "/busTrip/updateLastOut", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateLastOut(@RequestParam Map<String, Object> map) {
		logger.info("updateLastOut");
		
		
		busTripService.updateLastOut(map);
		
		
		return map;
	}
	@RequestMapping(value = "/busTrip/updateTradeSeq", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateTradeSeq(@RequestParam Map<String, Object> map) {
		logger.info("updateTradeSeq");
		
		
		busTripService.updateTradeSeq(map);
		
		
		return map;
	}
	@RequestMapping(value = "/busTrip/deleteRowData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteRowData(@RequestParam Map<String, Object> map) {
		logger.info("deleteRowData");
		
		
		busTripService.deleteRowData(map);
		
		
		return map;
	}
	@RequestMapping(value = "/busTrip/getOrgCode", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getOrgCode(@RequestParam Map<String, Object> map) {
		logger.info("getOrgCode");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("result", busTripService.getOrgCode(map));
		
		return result;
	}
	@RequestMapping(value = "/busTrip/getAreaCost", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getAreaCost(@RequestParam Map<String, Object> map) {
		logger.info("getAreaCost");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("result", busTripService.getAreaCost(map));
		
		return result;
	}
	@RequestMapping(value = "/busTrip/bizInsertFoot", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bizInsertFoot(@RequestParam Map<String, Object> map) {
		logger.info("bizInsertFoot");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			busTripService.bizInsertFoot(map);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	@RequestMapping(value = "/busTrip/InsertPjtAndBudget", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> InsertPjtAndBudget(@RequestParam Map<String, Object> map) {
		logger.info("InsertPjtAndBudget");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			busTripService.InsertPjtAndBudget(map);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	@RequestMapping(value = "/busTrip/getCardCostByattachId", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCardCostByattachId(@RequestParam Map<String, Object> map) {
		logger.info("getCardCostByattachId");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getCardCostByattachId(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getDayTransPortDetail", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDayTransPortDetail(@RequestParam Map<String, Object> map) {
		logger.info("getDayTransPortDetail");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getDayTransPortDetail(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getCardCostBySubSeq", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCardCostBySubSeq(@RequestParam Map<String, Object> map) {
		logger.info("getCardCostBySubSeq");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getCardCostBySubSeq(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getAllCardInfoByResDocSeq", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getAllCardInfoByResDocSeq(@RequestParam Map<String, Object> map) {
		logger.info("getAllCardInfoByResDocSeq");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getAllCardInfoByResDocSeq(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getCardCostBySubSeqDetail", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCardCostBySubSeqDetail(@RequestParam Map<String, Object> map) {
		logger.info("getCardCostBySubSeqDetail");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getCardCostBySubSeqDetail(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getLastInfoByOutTrip", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getLastInfoByOutTrip(@RequestParam Map<String, Object> map) {
		logger.info("getLastInfoByOutTrip");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getLastInfoByOutTrip(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getCardExistYn", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCardExistYn(@RequestParam Map<String, Object> map) {
		logger.info("getCardExistYntTrip");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getCardExistYn(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/sendSmsByBizTongAgent", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendSmsByBizTongAgent(@RequestParam Map<String, Object> map) {
		logger.info("sendSmsByBizTongAgent");
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("massage", "fail");
		try {
			Gson gson = new Gson();
			String arr = String.valueOf(map.get("numArr"));
			
			Type listType = new TypeToken<List<String>>(){}.getType();
			List<String> list = gson.fromJson(arr, listType);
			
			commonService.sendSmsByBizTongAgent((String)map.get("title"), (String)map.get("content"),list );
			result.put("massage", "success");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getCardsInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCardsInfo(@RequestParam Map<String, Object> map) {
		logger.info("getCardsInfo");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			result.put("result",busTripService.getCardsInfo(map));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/busTrip/getBizTemp", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBizTemp(@RequestParam Map<String, Object> map) {
		logger.info("getBizTemp");
		Map<String, Object> result = new HashMap<>();
		
		try {
			
			result.put("result", busTripService.getBizTemp(map));
		} catch (Exception e) {
			logger.info("insertBizTemp" , e);
		}
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/insertBizTemp", method = RequestMethod.POST)
	@ResponseBody
	public void insertBizTemp(@RequestParam Map<String, Object> map) {
		logger.info("insertBizTemp");
		
		try {
			
			busTripService.insertBizTemp(map);
		} catch (Exception e) {
			logger.info("insertBizTemp" , e);
		}
		
		
	}
	@RequestMapping(value = "/busTrip/getDayByDayInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDayByDayInfo(@RequestParam Map<String, Object> map) {
		logger.info("getDayByDayInfo");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			
		
		List<Map<String, Object>> list = busTripService.getDayByDayInfo(map);
		
		for(Map<String, Object> data : list) {

			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("out_sub_seq", data.get("sub_seq"));
			
			List<Map<String, Object>> addInfo = busTripService.getCardCostBySubSeqDetail(paramMap);
			
			if(!addInfo.isEmpty()) {
				for(Map<String, Object> data2 : addInfo) {
					
					String sort = (String)data2.get("cardSort");
					
					if("교통".equals(sort)) {
						data.put("b_car_cost", data2.get("cost"));
					} else if("숙박".equals(sort)) {
						data.put("b_room_cost", data2.get("cost"));
						
					}else if("기타".equals(sort)) {
						data.put("b_etc_cost", data2.get("cost"));
						
					}
				} 
			}
			
		}
		result.put("result", list);
		} catch (Exception e) {
			logger.info("getDayByDayInfo",e);
		}
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/deleteOutSubDayData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteOutSubDayData(@RequestParam Map<String, Object> map) {
		logger.info("deleteOutSubDayData");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			 busTripService.deleteOutSubDayData(map);
			 result.put("result", "success");
			
		} catch (Exception e) {
			
			result.put("result", "fail");
			logger.info("==============deleteOutSubDayData 오류입니당=========",e);
		}
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/getDayByDayOverlap", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDayByDayOverlap(@RequestParam Map<String, Object> map) {
		logger.info("getDayByDayOverlap");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("result", busTripService.getDayByDayOverlap(map));
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/getFilePk", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getFilePk(@RequestParam Map<String, Object> map) throws Exception {
		logger.info("getFilePk");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		
		result.put("result", busTripService.getFilePk(map));
		
		String fileKey =String.valueOf(map.get("fileKey"));
		
		System.out.println(fileKey);
		
		Map<String, Object> filesname = new HashMap<>();
		
		
		try {
			
			filesname = busTripService.getFilePk(map);
		
		} catch (Exception e) {
			logger.info("BusTripControllor======= 2983 Line ==========",e);
		}
		
		
		String fileSeqArray =  String.valueOf(filesname.get("file_seq")) ;
		String fileSeq2Array = String.valueOf(filesname.get("file_seq2")) ;
		String fileSeq3Array =  String.valueOf(filesname.get("file_seq3")) ;
		String fileSeq4Array =  String.valueOf(filesname.get("file_seq4")) ;
		 
		 String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
		
		 try {
			 //첨부파일 seq 
				if(!"null".equals(fileSeqArray)){
					int cnt = 1;
					String[] sarr =fileSeqArray.split(",");
					
					 for(String v : sarr){
						 Map<String, Object> paramMap = new HashMap<>();
						
						 paramMap.put("attach_file_id", v);
						 
						 Map<String, Object> filesname2 = new HashMap<>();
						 
						 filesname2 = busTripService.getAttachInfoByOne(paramMap);
						 
						String file_path = String.valueOf(filesname2.get("file_path"));
						String file_extension = String.valueOf(filesname2.get("file_extension"));
						String real_file_name = String.valueOf(filesname2.get("real_file_name"));
						String attach_file_id = String.valueOf(filesname2.get("attach_file_id"));
						
						Map<String, Object> fileUserInfo = new HashMap<>();
						fileUserInfo =busTripService.getFileUserAndBizDay(paramMap);
						String copyFileName1 = String.valueOf(fileUserInfo.get("biz_day")).replaceAll("-", "");
						String copyFileName2 = String.valueOf(fileUserInfo.get("emp_name"));
						
						
						 //원본 파일경로+ 파일명
						 String oriFilePath = file_path+attach_file_id+"."+file_extension;
						 //복사될 파일경로+ 파일명
						 String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"출장이행확인증빙"+"."+file_extension;
						 
						 File dir = new File(tempPath+fileKey);
				            
				            
				            if(!dir.isDirectory()){
				            	CommFileUtil.makeDir(tempPath+fileKey);
				            }
				            	
						 
						 
						 //파일객체생성
						 File oriFile = new File(oriFilePath);
						 //복사파일객체생성
						 File copyFile = new File(copyFilePath);
						 
						 try {
							 
							 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							 
							 int fileByte = 0; 
							 // fis.read()가 -1 이면 파일을 다 읽은것
							 while((fileByte = fis.read()) != -1) {
								 fos.write(fileByte);
							 }
							 //자원사용종료
							 fis.close();
							 fos.close();
							 
						 } catch (FileNotFoundException e) {
							 logger.info("FileNotFoundException", e);
						 } catch (IOException e) {
							 logger.info("IOException", e);
						 }
						 cnt++;
					 }
				}
				
				if(!"null".equals(fileSeq3Array)){
					String[] sarr3 =fileSeq3Array.split(",");
					int cnt = 1;
					for(String v : sarr3){
						 Map<String, Object> paramMap = new HashMap<>();
						
						 paramMap.put("attach_file_id", v);
						 
						 Map<String, Object> filesname2 = new HashMap<>();
						 
						 filesname2 = busTripService.getAttachInfoByOne(paramMap);
						 
						String file_path = String.valueOf(filesname2.get("file_path"));
						String file_extension = String.valueOf(filesname2.get("file_extension"));
						String real_file_name = String.valueOf(filesname2.get("real_file_name"));
						String attach_file_id = String.valueOf(filesname2.get("attach_file_id"));
						 
						Map<String, Object> fileUserInfo = new HashMap<>();
						fileUserInfo =busTripService.getFileUserAndBizDay3(paramMap);
						String copyFileName1 = String.valueOf(fileUserInfo.get("biz_day")).replaceAll("-", "");
						String copyFileName2 = String.valueOf(fileUserInfo.get("emp_name"));
						
						 //원본 파일경로+ 파일명
						 String oriFilePath = file_path+attach_file_id+"."+file_extension;
						 //복사될 파일경로+ 파일명
						 String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"교통수단증빙"+cnt+"."+file_extension;
						 
						 File dir = new File(tempPath+fileKey);
				            
				            System.out.println("$$$$$$$$$$$$$$$$$$$$"+ file_path+fileKey);
				            
				            
				            
				            if(!dir.isDirectory()){
				            	CommFileUtil.makeDir(tempPath+fileKey);
				            }
				            	
						 
						 
						 //파일객체생성
						 File oriFile = new File(oriFilePath);
						 //복사파일객체생성
						 File copyFile = new File(copyFilePath);
						 
						 try {
							 
							 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							 
							 int fileByte = 0; 
							 // fis.read()가 -1 이면 파일을 다 읽은것
							 while((fileByte = fis.read()) != -1) {
								 fos.write(fileByte);
							 }
							 //자원사용종료
							 fis.close();
							 fos.close();
							 
						 } catch (FileNotFoundException e) {
							 logger.info("FileNotFoundException", e);
						 } catch (IOException e) {
							 logger.info("IOException", e);
						 }
						 
						 cnt++;
						 
					 }
					
				}
				 if(!"null".equals(fileSeq4Array)){
					 int cnt = 1;
					 String[] sarr4 =fileSeq4Array.split(",");
					 for(String v : sarr4){
						 
						 Map<String, Object> paramMap = new HashMap<>();
						
						 paramMap.put("attach_file_id", v);
						 
						 Map<String, Object> filesname2 = new HashMap<>();
						 
						 filesname2 = busTripService.getAttachInfoByOne(paramMap);
						 
						String file_path = String.valueOf(filesname2.get("file_path"));
						String file_extension = String.valueOf(filesname2.get("file_extension"));
						String real_file_name = String.valueOf(filesname2.get("real_file_name"));
						String attach_file_id = String.valueOf(filesname2.get("attach_file_id"));
						 
						Map<String, Object> fileUserInfo = new HashMap<>();
						fileUserInfo =busTripService.getFileUserAndBizDay4(paramMap);
						String copyFileName1 = String.valueOf(fileUserInfo.get("biz_day")).replaceAll("-", "");
						String copyFileName2 = String.valueOf(fileUserInfo.get("emp_name"));
						
						 //원본 파일경로+ 파일명
						 String oriFilePath = file_path+attach_file_id+"."+file_extension;
						 //복사될 파일경로+ 파일명
						 String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"교통수단증빙(기타)"+"."+file_extension;
						 
						 File dir = new File(tempPath+fileKey);
				            
				            System.out.println("$$$$$$$$$$$$$$$$$$$$"+ file_path+fileKey);
				            
				            
				            
				            if(!dir.isDirectory()){
				            	CommFileUtil.makeDir(tempPath+fileKey);
				            }
				            	
						 
						 
						 //파일객체생성
						 File oriFile = new File(oriFilePath);
						 //복사파일객체생성
						 File copyFile = new File(copyFilePath);
						 
						 try {
							 
							 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							 
							 int fileByte = 0; 
							 // fis.read()가 -1 이면 파일을 다 읽은것
							 while((fileByte = fis.read()) != -1) {
								 fos.write(fileByte);
							 }
							 //자원사용종료
							 fis.close();
							 fos.close();
							 
						 } catch (FileNotFoundException e) {
							 logger.info("FileNotFoundException", e);
						 } catch (IOException e) {
							 logger.info("IOException", e);
						 }
						 cnt++;
					 }
				 }
				 
				 if(!"null".equals(fileSeq2Array)){
						//증빙파일 seq 
						String[] sarr2 =fileSeq2Array.split(",");
						int cnt = 1;
						 for(String v : sarr2){
							 
							 Map<String, Object> paramMap = new HashMap<>();
							
							 paramMap.put("attach_file_id", v);
							 
							 Map<String, Object> filesname2 = new HashMap<>();
							 
							 filesname2 = busTripService.getAttachInfoByOne(paramMap);
							 
							String file_path = String.valueOf(filesname2.get("file_path"));
							String file_extension = String.valueOf(filesname2.get("file_extension"));
							String real_file_name = String.valueOf(filesname2.get("real_file_name"));
							String attach_file_id = String.valueOf(filesname2.get("attach_file_id"));
							
							Map<String, Object> fileUserInfo = new HashMap<>();
							fileUserInfo =busTripService.getFileUserAndBizDay2(paramMap);
							String copyFileName1 = String.valueOf(fileUserInfo.get("biz_day")).replaceAll("-", "");
							String copyFileName2 = String.valueOf(fileUserInfo.get("emp_name"));
							
							 //원본 파일경로+ 파일명
							 String oriFilePath = file_path+attach_file_id+"."+file_extension;
							 //복사될 파일경로+ 파일명
							 String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"법인카드증빙"+"."+file_extension;
							 
							 File dir = new File(tempPath+fileKey);
					            
					            System.out.println("$$$$$$$$$$$$$$$$$$$$"+ file_path+fileKey);
					            
					            
					            
					            if(!dir.isDirectory()){
					            	CommFileUtil.makeDir(tempPath+fileKey);
					            }
					            	
							 
							 
							 //파일객체생성
							 File oriFile = new File(oriFilePath);
							 //복사파일객체생성
							 File copyFile = new File(copyFilePath);
							 
							 try {
								 
								 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
								 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
								 
								 int fileByte = 0; 
								 // fis.read()가 -1 이면 파일을 다 읽은것
								 while((fileByte = fis.read()) != -1) {
									 fos.write(fileByte);
								 }
								 //자원사용종료
								 fis.close();
								 fos.close();
								 
							 } catch (FileNotFoundException e) {
								 logger.info("FileNotFoundException", e);
							 } catch (IOException e) {
								 logger.info("IOException", e);
							 }
							 cnt++;
						 }
						
						
					}
		} catch (Exception e) {
			logger.info("BusTripControllor==========",e);

		}
		 
		
		
		return result;
		
	}
	@RequestMapping(value = "/busTrip/getFilePkVer2", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getFilePkVer2(@RequestParam Map<String, Object> map) throws Exception {
		logger.info("getFilePkVer2");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
			//의미없는 result ㅋㅋㅋㅋ
		result.put("result", busTripService.getFilePkVer2(map));
		
		String fileKey =String.valueOf(map.get("fileKey"));
		
		System.out.println(fileKey);
		
		List<Map<String, Object>> filesnameList = new ArrayList<Map<String,Object>>();
		
			
			filesnameList = busTripService.getFilePkVer2(map);
			
		
		String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
		
		try {
			for(Map<String, Object> v : filesnameList){
				String empName = String.valueOf(v.get("emp_name"));
				String bizDay = String.valueOf(v.get("biz_day"));
				String file_seq = String.valueOf(v.get("file_seq"));
				String file_seq2 = String.valueOf(v.get("file_seq2"));
				String file_seq3 = String.valueOf(v.get("file_seq3"));
				String file_seq4 = String.valueOf(v.get("file_seq4"));
				
				if(!"null".equals(file_seq)){
					
					String[] fileSeqArr =file_seq.split(",");
					int cnt =1;
					for(String seq : fileSeqArr) {
						
						Map<String, Object> paramMap = new HashMap<>();
						
						paramMap.put("attach_file_id", seq);
						
						Map<String, Object> fileInfo = new HashMap<>();
						
						fileInfo = busTripService.getAttachInfoByOne(paramMap);
						
						String file_path = String.valueOf(fileInfo.get("file_path"));
						String file_extension = String.valueOf(fileInfo.get("file_extension"));
						String real_file_name = String.valueOf(fileInfo.get("real_file_name"));
						String attach_file_id = String.valueOf(fileInfo.get("attach_file_id"));
						
						String copyFileName1 = bizDay.replaceAll("-", "");
						String copyFileName2 = empName;
						
						//원본 파일경로+ 파일명
						String oriFilePath = file_path+attach_file_id+"."+file_extension;
						//복사될 파일경로+ 파일명
						String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"_"+"출장이행확인증빙"+cnt+"."+file_extension;
						
						File dir = new File(tempPath+fileKey);
						
						
						if(!dir.isDirectory()){
							CommFileUtil.makeDir(tempPath+fileKey);
						}
						
						//파일객체생성
						File oriFile = new File(oriFilePath);
						//복사파일객체생성
						File copyFile = new File(copyFilePath);
						
						try {
							
							FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							
							int fileByte = 0; 
							// fis.read()가 -1 이면 파일을 다 읽은것
							while((fileByte = fis.read()) != -1) {
								fos.write(fileByte);
							}
							//자원사용종료
							fis.close();
							fos.close();
							
						} catch (FileNotFoundException e) {
							logger.info("FileNotFoundException", e);
						} catch (IOException e) {
							logger.info("IOException", e);
						}
						cnt++;
					}
					
					
				}
				if(!"null".equals(file_seq3)){
					
					String[] fileSeqArr3 =file_seq3.split(",");
					int cnt =1;
					
					for(String seq : fileSeqArr3) {
						
						Map<String, Object> paramMap = new HashMap<>();
						
						paramMap.put("attach_file_id", seq);
						
						Map<String, Object> fileInfo = new HashMap<>();
						
						fileInfo = busTripService.getAttachInfoByOne(paramMap);
						
						String file_path = String.valueOf(fileInfo.get("file_path"));
						String file_extension = String.valueOf(fileInfo.get("file_extension"));
						String real_file_name = String.valueOf(fileInfo.get("real_file_name"));
						String attach_file_id = String.valueOf(fileInfo.get("attach_file_id"));
						
						String copyFileName1 = bizDay.replaceAll("-", "");
						String copyFileName2 = empName;
						
						//원본 파일경로+ 파일명
						String oriFilePath = file_path+attach_file_id+"."+file_extension;
						//복사될 파일경로+ 파일명
						String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"_"+"교통수단증빙"+cnt+"."+file_extension;
						
						File dir = new File(tempPath+fileKey);
						
						
						if(!dir.isDirectory()){
							CommFileUtil.makeDir(tempPath+fileKey);
						}
						
						//파일객체생성
						File oriFile = new File(oriFilePath);
						//복사파일객체생성
						File copyFile = new File(copyFilePath);
						
						try {
							
							FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							
							int fileByte = 0; 
							// fis.read()가 -1 이면 파일을 다 읽은것
							while((fileByte = fis.read()) != -1) {
								fos.write(fileByte);
							}
							//자원사용종료
							fis.close();
							fos.close();
							
						} catch (FileNotFoundException e) {
							logger.info("FileNotFoundException", e);
						} catch (IOException e) {
							logger.info("IOException", e);
						}
						cnt++;
					}
				}
				if(!"null".equals(file_seq4)){
					
					String[] fileSeqArr4 =file_seq4.split(",");
					int cnt =1;
					
					for(String seq : fileSeqArr4) {
						Map<String, Object> paramMap = new HashMap<>();
						
						paramMap.put("attach_file_id", seq);
						
						Map<String, Object> fileInfo = new HashMap<>();
						
						fileInfo = busTripService.getAttachInfoByOne(paramMap);
						
						String file_path = String.valueOf(fileInfo.get("file_path"));
						String file_extension = String.valueOf(fileInfo.get("file_extension"));
						String real_file_name = String.valueOf(fileInfo.get("real_file_name"));
						String attach_file_id = String.valueOf(fileInfo.get("attach_file_id"));
						
						String copyFileName1 = bizDay.replaceAll("-", "");
						String copyFileName2 = empName;
						
						//원본 파일경로+ 파일명
						String oriFilePath = file_path+attach_file_id+"."+file_extension;
						//복사될 파일경로+ 파일명
						String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"_"+"교통수단(기타)증빙"+cnt+"."+file_extension;
						
						File dir = new File(tempPath+fileKey);
						
						
						if(!dir.isDirectory()){
							CommFileUtil.makeDir(tempPath+fileKey);
						}
						
						//파일객체생성
						File oriFile = new File(oriFilePath);
						//복사파일객체생성
						File copyFile = new File(copyFilePath);
						
						try {
							
							FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							
							int fileByte = 0; 
							// fis.read()가 -1 이면 파일을 다 읽은것
							while((fileByte = fis.read()) != -1) {
								fos.write(fileByte);
							}
							//자원사용종료
							fis.close();
							fos.close();
							
						} catch (FileNotFoundException e) {
							logger.info("FileNotFoundException", e);
						} catch (IOException e) {
							logger.info("IOException", e);
						}
						cnt++;
					}
				}
				if(!"null".equals(file_seq2)){
					
					String[] fileSeqArr2 =file_seq2.split(",");
					int cnt =1;
					
					for(String seq : fileSeqArr2) {
						
						Map<String, Object> paramMap = new HashMap<>();
						
						paramMap.put("attach_file_id", seq);
						
						Map<String, Object> fileInfo = new HashMap<>();
						
						fileInfo = busTripService.getAttachInfoByOne(paramMap);
						
						String file_path = String.valueOf(fileInfo.get("file_path"));
						String file_extension = String.valueOf(fileInfo.get("file_extension"));
						String real_file_name = String.valueOf(fileInfo.get("real_file_name"));
						String attach_file_id = String.valueOf(fileInfo.get("attach_file_id"));
						
						String copyFileName1 = bizDay.replaceAll("-", "");
						String copyFileName2 = empName;
						
						//원본 파일경로+ 파일명
						String oriFilePath = file_path+attach_file_id+"."+file_extension;
						//복사될 파일경로+ 파일명
						String copyFilePath =tempPath +fileKey+File.separator +copyFileName1+"_"+copyFileName2+"_"+"법인카드증빙"+cnt+"."+file_extension;
						
						File dir = new File(tempPath+fileKey);
						
						
						if(!dir.isDirectory()){
							CommFileUtil.makeDir(tempPath+fileKey);
						}
						
						//파일객체생성
						File oriFile = new File(oriFilePath);
						//복사파일객체생성
						File copyFile = new File(copyFilePath);
						
						try {
							
							FileInputStream fis = new FileInputStream(oriFile); //읽을파일
							FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
							
							int fileByte = 0; 
							// fis.read()가 -1 이면 파일을 다 읽은것
							while((fileByte = fis.read()) != -1) {
								fos.write(fileByte);
							}
							//자원사용종료
							fis.close();
							fos.close();
							
						} catch (FileNotFoundException e) {
							logger.info("FileNotFoundException", e);
						} catch (IOException e) {
							logger.info("IOException", e);
						}
						cnt++;
					}
				}
				
			}
					
				
		} catch (Exception e) {
			logger.info("asdasd",e);
			
		}
		
		
		
		return result;
		
	}
	
	
	@RequestMapping("/busTrip/makeCardExcel")
	@ResponseBody
	public Map<String, Object> makeCardExcel( @RequestParam HashMap<String, Object> requestMap, HttpServletRequest servletRequest) throws Exception{
		
		logger.info("/busTrip/makeCardExcel");
		
		Map<String, Object> resultMap = new HashMap<>();
		
		
		Map<String, Object> excelMap = new HashMap<String, Object>();
		
		String authNum = "";
		try {
			
			Map<String, Object> cardInfoMap = resAlphaG20Service.userCardDetailInfo(requestMap);
		
			authNum= String.valueOf( cardInfoMap.get("authNum"));
			
		
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
		} catch (Exception e) {
			logger.info("카드정보조회 오류", e);
		}
		/**
		 *   여기서 부터 excelMap 정보와 fileKey로 temp파일 만들기 
		 */
		
		
		
		Map<String, Object> beans  = new HashMap<String, Object>();
				
				List<Map<String, Object>> list = new ArrayList<>();
				
				list.add(excelMap);
				
		
				beans.put("list", list);
				
        try {
        	
        	String path ="";

        	if(servletRequest.getServerName().contains("localhost") || servletRequest.getServerName().contains("127.0.0.1")) {
        		 path = "C:/Users/MHJ/Desktop/cardTemplete.xlsx";
			}else{
				//템플릿 엑셀파일 위치
				path = servletRequest.getSession().getServletContext().getRealPath("/exceltemplate/" + "cardTemplete.xlsx");
			}
        	
			
        	
        	
        	 InputStream is = new BufferedInputStream(new FileInputStream(path));
            
        	
        	XLSTransformer transformer = new XLSTransformer();
            Workbook resultWorkbook = transformer.transformXLS(is, beans);
            
            
            String tempPath = CommFileUtil.getFilePath(commFileDAO, "bus", "Y");
            File dir = new File(tempPath);
            
            System.out.println("$$$$$$$$$$$$$$$$$$$$"+ tempPath);
            
            
            
            if(!dir.isDirectory()){
            	CommFileUtil.makeDir(tempPath);
            }
            	
            // 저장경로 : 템프파일 경로/파일키/카드승인전표_승인키.xlsx 으로 저장
            OutputStream os = new FileOutputStream(new File(tempPath + File.separator + "증빙용_"+authNum+".xlsx"));
           
            resultMap.put("path", tempPath);
            resultMap.put("realFileName", "증빙용_"+authNum+".xlsx");
            resultMap.put("targetId", requestMap.get("targetId"));
            
            
            
            resultWorkbook.write(os);
            os.close();
            
            logger.info("카드승인전표 이미지 게또");
           
        } catch (Exception ex) {
        	  logger.info("카드승인전표 작성 실패....",ex);
        }
        
		return uploadFileInsert(resultMap);
	
	}
	
	public Map<String, Object> uploadFileInsert(Map<String, Object>map) {
		
		Map<String, Object> returnMap = new HashMap<>();

		try {
			
		String path = String.valueOf(map.get("path"));
		String fileName = String.valueOf(map.get("realFileName"));
		try {
			File f = new File(path+fileName);
			
			String fileSize = String.valueOf(f.length());
			
			Map<String, Object> tempMap = new HashMap<>();
			
			tempMap.put("targetTableName", "bus_out_trip");
			tempMap.put("targetId", map.get("targetId"));
			tempMap.put("fileSeq", commFileDAO.getCommFileSeq(tempMap));
			
			commFileDAO.commFileInfoInsert(tempMap);
			
			String ext = fileName.substring(fileName.lastIndexOf(".")+1);
			int Idx = fileName.lastIndexOf(".");
           	String _fileName = fileName.substring(0, Idx);
			
			returnMap.put("filePath", path);
			returnMap.put("fileNm", _fileName);
			returnMap.put("ext", ext);
			returnMap.put("fileSize", fileSize);
			returnMap.put("attach_file_id", tempMap.get("attach_file_id"));
			returnMap.put("fileSeq", tempMap.get("fileSeq"));
			returnMap.put("targetId", tempMap.get("targetId"));
			returnMap.put("targetTableName", tempMap.get("targetTableName"));
			
			commFileDAO.commFileInfoUpdate(returnMap);
			
			String a =tempMap.get("attach_file_id")+"."+ext;
			File fnew = new File(path+a);
			f.renameTo(fnew);
			
		} catch (Exception e) {
			logger.info("uploadFileInsert 오류발생", e);
		}
		} catch (Exception e) {
			logger.info("형진ERROR:", e);
		}
       	
		return returnMap;
		
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


	/**
	 * @MethodName : 출장집계표 excel 그려서 파일 저장하기 
	 * @author : 문형진
	 * @throws Exception 
	 * @since : 2020. 06. 17.
	 * 설명 : 
	 */
	public void makeEtaxExcel(Map<String, Object> tradeMap, Map<String, Object> requestMap, String fileKey ,HttpServletRequest request) throws Exception {
		
		Map<String, Object> excelMap = new HashMap<String, Object>();
		
		
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
            
            // 저장경로 : 템프파일 경로/파일키/매입세금계산서_승인키.xlsx 으로 저장
            OutputStream os = new FileOutputStream(new File(tempPath + fileKey + File.separator + "출장집계표"+".xlsx"));
            
            resultWorkbook.write(os);
            os.close();
            
            logger.info("출장집계표 (시외) 엑셀");
           
        } catch (ParsePropertyException | InvalidFormatException | IOException ex) {
        	  logger.info("ERROR!!!!!!ERROR!!!!!!ERROR!!!!!!출장집계표 (시외) 엑셀", ex);
        }	
		
		
	}
	
	
	
	@RequestMapping(value = "/busTrip/addTransportTable", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addTransportTable(@RequestBody List<Map<String, Object>> list) {
		logger.info("addTransportTable");
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", list);
			
			busTripService.addTransportTable(map);
			
			result.put("message", "성공");

		} catch (Exception e) {
			
			result.put("message", "실패");
			
			
		}


		return result;
	}

	
	@RequestMapping(value = "/busTrip/makeExcelByBizTrip")
	@ResponseBody 
	public Map<String, Object> makeExcelByBizTrip(@RequestParam Map<String, Object> map, HttpServletRequest servletRequest) throws Exception {
		logger.info("busTrip/makeExcelByBizTrip");
		//ㅁㄴㅇㅁㄴㅇ
		String fileKey = (String) map.get("file_key");
		//String fileKey = (String) "3241";
		//map.put("res_doc_seq", 20319);
		
		List<Map<String, Object>> lists = new ArrayList<>();
		List<Map<String, Object>> lists2 = new ArrayList<>();
		List<Map<String, Object>> lists3 = new ArrayList<>();
		List<Map<String, Object>> lists4 = new ArrayList<>();
		
		Map<String, Object> beans  = new HashMap<String, Object>();
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			
			int etcTotal=0;
			int dayTotal=0;
			int foodTotal=0;
			int roomTotal=0;
			int allTotal=0;
			
			int carAllTotal=0;
			int tradeAmt=0;
			int traficTotal=0;
			
			List<Map<String, Object>> list =  busTripService.getBizTripDataByResSeq(map);
			
			for(Map<String, Object> obj : list) {
				
				Map<String, Object> excelParam = new HashMap<>();
				
				excelParam.putAll(obj);
				
				etcTotal+= Integer.valueOf(String.valueOf(obj.get("etc_cost")));
				dayTotal+= Integer.valueOf(String.valueOf(obj.get("day_cost")));
				foodTotal+=Integer.valueOf(String.valueOf(obj.get("food_cost")));
				roomTotal+=Integer.valueOf(String.valueOf(obj.get("room_cost")));
				allTotal+=Integer.valueOf(String.valueOf(obj.get("total_cost")));
				
				Map<String, Object> getparam = new HashMap<>();
				
				getparam.put("sub_seq", obj.get("sub_seq"));
				
				List<Map<String, Object>> list2 =  busTripService.getTransportDataByOutSubSeq(getparam);
				
				int bus=0;
				int train=0;
				int ship=0;
				int air=0;
				int car1=0;
				int car2=0;

				int cardTrafic=0;
				int cardRoom=0;
				int cardEtc=0;
				
				int Total=0;
				
				int cardTotal=0;
				
				for(Map<String, Object> obj2 : list2) {
					
					if(obj2.get("trafic_way_kr").equals("차량")) {
						
						if(obj2.get("car_yn").equals("이용안함")) {
							
							car1 += Integer.valueOf(String.valueOf(obj2.get("cost")));
							
							Map<String, Object> excelParam2 = new HashMap<>();
							
							excelParam2.put("carempName", obj.get("biz_emp_name"));
							excelParam2.put("biz_day", obj.get("biz_day"));
							excelParam2.put("distance", obj2.get("distance"));
							excelParam2.put("oilc", obj2.get("oil_cost"));
							excelParam2.put("dusql", obj2.get("dusql"));
							excelParam2.put("oilc", obj2.get("oil_cost"));
							excelParam2.put("etcc", obj.get("etc_cost"));
							excelParam2.put("oiltype", obj2.get("oil_sort_kor"));
							excelParam2.put("oil_city_kor", obj2.get("oil_city_kor"));
							excelParam2.put("traficc", car1);
							excelParam2.put("cartotal", Integer.valueOf(String.valueOf(car1))+Integer.valueOf(String.valueOf(obj.get("etc_cost"))));
							
							carAllTotal += Integer.valueOf(String.valueOf(car1))+Integer.valueOf(String.valueOf(obj.get("etc_cost")));
							
							lists2.add(excelParam2);
							
						}else {
							car2 += Integer.valueOf(String.valueOf(obj2.get("cost")));
							
						}
						
					} else if(obj2.get("trafic_way_kr").equals("버스"))	{
						bus += Integer.valueOf(String.valueOf(obj2.get("cost")));
						
					}else if(obj2.get("trafic_way_kr").equals("선박"))	{
						ship += Integer.valueOf(String.valueOf(obj2.get("cost")));
						
					}else if(obj2.get("trafic_way_kr").equals("열차"))	{
						train += Integer.valueOf(String.valueOf(obj2.get("cost")));
						
					}else if(obj2.get("trafic_way_kr").equals("항공"))	{
						air += Integer.valueOf(String.valueOf(obj2.get("cost")));
						
					}
					
				}
				
				List<Map<String, Object>> list3 =  busTripService.getCardDataByOutSubSeq(getparam);
				if(!list3.isEmpty()) {
					
					for(Map<String, Object> obj3 : list3) {
						
						if(obj3.get("cardSort").equals("교통")) {
							cardTrafic += Integer.valueOf(String.valueOf(obj3.get("cost")));
							
						} else if(obj3.get("cardSort").equals("숙박")){
							cardRoom += Integer.valueOf(String.valueOf(obj3.get("cost")));
							
						}else if(obj3.get("cardSort").equals("기타"))	{
							cardEtc += Integer.valueOf(String.valueOf(obj3.get("cost")));
							
						}
						
						Map<String, Object> excelParam3 = new HashMap<>();
						excelParam3.putAll(obj3);
						excelParam3.put("empName", obj.get("biz_emp_name"));
						excelParam3.put("bizday", obj.get("biz_day"));
						excelParam3.put("tradeAmtReplace", Integer.valueOf(String.valueOf(obj3.get("tradeAmt")).replaceAll(",", "")));
						
						tradeAmt += Integer.valueOf(String.valueOf(obj3.get("tradeAmt")).replaceAll(",", ""));
						
						lists3.add(excelParam3);
						
					}
				}
				
				int a =Integer.valueOf(String.valueOf(obj.get("day_cost")));
				int b =Integer.valueOf(String.valueOf(obj.get("etc_cost")));
				int c =Integer.valueOf(String.valueOf(obj.get("food_cost")));
				int d =Integer.valueOf(String.valueOf(obj.get("room_cost")));
				
				Total+= bus+train+ship+air+car1+car2+a+b+c+d;
				cardTotal+=cardTrafic+cardRoom+cardEtc;
				traficTotal += bus+train+ship+air+car1+car2;
				
				excelParam.put("bus", bus);
				excelParam.put("train", train);
				excelParam.put("ship", ship);
				excelParam.put("air", air);
				excelParam.put("car1", car1);
				excelParam.put("car2", car2);

				excelParam.put("cardTrafic", cardTrafic);
				excelParam.put("cardRoom", cardRoom);
				excelParam.put("cardEtc", cardEtc);
				excelParam.put("total", Total);
				excelParam.put("cardotal", cardTotal);
				
				excelParam.put("sort", "개인정산");
				excelParam.put("cardsort", "법인카드");
				
				lists.add(excelParam);
				
				
				etcTotal += cardEtc;
				roomTotal += cardRoom;
			}
			
			Map<String, Object> excelParam4 = new HashMap<>();
			
			excelParam4.put("etcTrafic", etcTotal);
			excelParam4.put("dayc", dayTotal);
			excelParam4.put("foodc", foodTotal);
			excelParam4.put("roomc", roomTotal);
			excelParam4.put("total", allTotal);
			excelParam4.put("carAllTotal", carAllTotal);
			excelParam4.put("tradeAmt", tradeAmt);
			excelParam4.put("traficAllTotal", tradeAmt+traficTotal);
			
			lists4.add(excelParam4);
			
		} catch (Exception e) {
			logger.info("뭐냐",e);
		}
		
		
		beans.put("list", lists);
		beans.put("list2", lists2);
		beans.put("list3", lists3);
		beans.put("list4", lists4);
		
		
		
        try {
        	//템플릿 엑셀파일 위치
        	//String path = "D:\\newoutTripTemplete.xlsx";
        	String path = servletRequest.getSession().getServletContext().getRealPath("/exceltemplate/" + "newoutTripTemplete.xlsx");
        	
        	InputStream is = new BufferedInputStream(new FileInputStream(path));
        	
        	XLSTransformer transformer = new XLSTransformer();
        	
            Workbook resultWorkbook = transformer.transformXLS(is, beans);
//            String tempPath = "C:/Users/MHJ/Desktop/result/";
            
            String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
            String tempPath3 = CommFileUtil.getFilePath(commFileDAO, "ea/bizTemp", "N");
            
        	
            File dir = new File(tempPath+fileKey);
            
            if(!dir.isDirectory()){
            	CommFileUtil.makeDir(tempPath + fileKey);
            }
            String randomKey = "B" + java.util.UUID.randomUUID().toString();
            
            //OutputStream os = new FileOutputStream(new File("D:\\출장집계표"+".xlsx"));
            OutputStream os = new FileOutputStream(new File(tempPath + fileKey+File.separator+"출장집계표"+".xlsx"));
            //OutputStream os = new FileOutputStream(new File(tempPath3 + randomKey+"_출장집계표"+".xlsx"));
            
            resultWorkbook.write(os);
           
            os.close();				
            
           /* // 옮기기
            //원본 파일경로+ 파일명
			 String oriFilePath = tempPath3 + randomKey + "_출장집계표"+".xlsx";
			 //복사될 파일경로+ 파일명
			 String copyFilePath =tempPath +fileKey+File.separator +"출장집계표.xlsx";
			 
			 
			 //파일객체생성
			 File oriFile = new File(oriFilePath);
			 //복사파일객체생성
			 File copyFile = new File(copyFilePath);
			 
			 try {
				 
				 FileInputStream fis = new FileInputStream(oriFile); //읽을파일
				 FileOutputStream fos = new FileOutputStream(copyFile); //복사할파일
				 
				 int fileByte = 0; 
				 // fis.read()가 -1 이면 파일을 다 읽은것
				 while((fileByte = fis.read()) != -1) {
					 fos.write(fileByte);
				 }
				 //자원사용종료
				 fis.close();
				 fos.close();
    			
    			
    		} catch (Exception e) {
    			logger.info("ERROR : ", e);
    		}*/
            
        } catch (Exception e) {
        	  logger.info("ERROR!!!!!!ERROR!!!!!!ERROR!!!!!!출장집계표 (시외) 엑셀",e);
        }	
		
		
		return	resultMap;
	}
	
	
	
	
	
	
	
	
	
}
