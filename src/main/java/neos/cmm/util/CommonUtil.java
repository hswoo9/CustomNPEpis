package neos.cmm.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.FileImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import com.duzon.dzcl.common.egov.EgovFileScrty;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import net.sf.json.JSONObject;

/**
 * 
 * @title CommonUtil.java
 */
public class CommonUtil {
	
	/*
	 * 상속금지
	 */
	private CommonUtil(){}
	
	/**
	 * @Methid Name : HtmlEncode
	 * @param obj
	 * @return
	 * Desc : 홑 따옴표 및 html 인코딩 하는 메서드
	 * @code CommonUtil.HtmlEncode(listMap);
	 * 
	 */
	public  static String  HtmlEncode(Object obj){
		String returnVal = "";
		if(obj != null){
			returnVal = HtmlUtils.htmlEscape(obj.toString());
		}
		
		//System.out.println("--------------------------------" + returnVal);
		//System.out.println("--------------------------------" + obj.toString());
		//return returnVal;
		return returnVal.replace("'", "&#39;").toString();
	}
	
	
	/**
	 * @Methid Name : HtmlEncode
	 * @param listMap
	 * @return
	 * Desc : iBatis 에서  Map 방식으로 받아올 경우 HtmlEncode 함.
	 * @code :  CommonUtil.HtmlEncode(listMap);
	 * 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static List<Map> HtmlEncode(List<Map> listMap){
		
		if(listMap == null || listMap.size()==0){
			return listMap;
		}
		int rowNum = listMap.size() ;
		Map map = null ;
		Set set = null ;
		Iterator iter = null; 
		for(int i = 0;i<rowNum;i++){
			map = listMap.get(i);
			set =  map.keySet();
			 iter = set.iterator();
			 Object key = null;
			 Object value = null;
		 
			for(;iter.hasNext();){
				key = iter.next();
				value = map.get(key);
				if(value != null && value instanceof String ){
					value = HtmlEncode(value.toString());
					map.put(key, value);
				}
			}
		}
		return listMap;
	}
	
	/**
	 * @Methid Name : HtmlEncode
	 * @param listObject
	 * @return
	 * Desc : iBatis 에서  List<T> 방식으로 받아올 경우 HtmlEncode 함.
	 * @code :  CommonUtil.HtmlEncode(List<T>, T.class)
	 */
	@SuppressWarnings("rawtypes")
	public  static void  HtmlEncode(List listObject, Class cl){
	 
	 BeanInfo info =  null;
	 try{
		 info = Introspector.getBeanInfo(cl);
	 }
	 catch(Exception ex){
		 ex.printStackTrace();
	 }
	 
	 PropertyDescriptor pd[] = info.getPropertyDescriptors();
	 
	 Method readMethod =  null;
	 Method writeMethod =  null;
	 
	 Object value = null;
	 Object obj = null ;
		try{
			 for(int i = 0;i<listObject.size();i++){
				 obj = listObject.get(i); 
				 for(int j = 0;j<pd.length;j++){
					 readMethod = pd[j].getReadMethod();
					
					 if(readMethod !=null){
						 value = readMethod.invoke(obj, new Object[]{});
						 if(value != null && value instanceof String ){
							 value = HtmlEncode(value.toString());
							 writeMethod = pd[j].getWriteMethod();
							 if(writeMethod !=null && value != null){
								 writeMethod.invoke(listObject.get(i), new Object[]{value});
							 }
						 }
					 }
				 }
			 }
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}


	
	//-----------------------------------------------------------------------------------------
	
	
	
	/**
	 * @Methid Name : HtmlDecode
	 * @param obj
	 * @return
	 * Desc : 홑 따옴표 및 html 인코딩 하는 메서드
	 * @code CommonUtil.HtmlDecode(listMap);
	 * 
	 */
	public  static String  HtmlDecode(Object obj){
		String returnVal = "";
		if(obj != null){
			returnVal = HtmlUtils.htmlUnescape(obj.toString());
		}
		
		//System.out.println("--------------------------------" + returnVal);
		//System.out.println("--------------------------------" + obj.toString());
		//return returnVal;
		return returnVal.replace("&#39;", "'").toString();
	}
	
	
	/**
	 * @Methid Name : HtmlDecode
	 * @param listMap
	 * @return
	 * Desc : iBatis 에서  Map 방식으로 받아올 경우 HtmlDecode 함.
	 * @code :  CommonUtil.HtmlDecode(listMap);
	 * 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static List<Map> HtmlDecode(List<Map> listMap){
		
		if(listMap == null || listMap.size()==0){
			return listMap;
		}
		for(int i = 0;i<listMap.size();i++){
			Map map = listMap.get(i);
			Set set =  map.keySet();
			 Iterator iter = set.iterator();
			 Object key = null;
			 Object value = null;
		 
			for(;iter.hasNext();){
				key = iter.next();
				value = map.get(key);
				if(value != null && value instanceof String ){
					value = HtmlDecode(value.toString());
					map.put(key, value);
				}
			}
		}
		return listMap;
	}
	
	/**
	 * @Methid Name : HtmlDecode
	 * @param listObject
	 * @return
	 * Desc : iBatis 에서  List<T> 방식으로 받아올 경우 HtmlDecode 함.
	 * @code :  CommonUtil.HtmlDecode(List<T>, T.class)
	 */
	@SuppressWarnings("rawtypes")
	public  static void  HtmlDecode(List listObject, Class cl){
	 
	 BeanInfo info =  null;
	 try{
		 info = Introspector.getBeanInfo(cl);
	 }
	 catch(Exception ex){
		 ex.printStackTrace();
	 }
	 
	 PropertyDescriptor pd[] = info.getPropertyDescriptors();
	 
	 Method readMethod =  null;
	 Method writeMethod =  null;
	 
	 Object value = null;
	 
		try{
			 for(int i = 0;i<listObject.size();i++){
				 for(int j = 0;j<pd.length;j++){
					 readMethod = pd[j].getReadMethod();
					 if(readMethod !=null){
						 value = readMethod.invoke(listObject.get(i), new Object[]{});
						 if(value != null && value instanceof String ){
							 value = HtmlDecode(value.toString());
							 writeMethod = pd[j].getWriteMethod();
							 if(writeMethod !=null && value != null){
								 writeMethod.invoke(listObject.get(i), new Object[]{value});
							 }
						 }
					 }
				 }
			 }
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	/**
     * 
     *<pre>
     * 1. MethodName	: AddDashToZip
     * 2. Description	: 우편번호 중간에 '-' 삽입. view에서는 '-'를 삽입한다.
     *                    ex) 480070 -> 480-070
     * ------- 개정이력(Modification Information) ----------
     *    작성일            작성자         작성정보
     *    2013. 1. 22.    송상현        최초작성
     *  ---------------------------------------------------
     *</pre>
     * @param zip
     * @return zip
     * @throws Exception
     */
    public static String AddDashToZip(String zip) throws Exception {
		String result = "";
		if(!EgovStringUtil.isEmpty(zip) && zip.length() >= 6 ) {
			result = zip.substring(0, 3) + "-" + zip.substring(3, 6);
		}else{
			result = zip;
		}
		return result;
	}
	
    /**
     * 
     *<pre>
     * 1. MethodName	: RemoveDashFromZip
     * 2. Description	: 우편번호 중간에 '-' 제거. DB입력시는 '-'를 제거해야 함
     *                    ex) 480-070 -> 480070
     * ------- 개정이력(Modification Information) ----------
     *    작성일            작성자         작성정보
     *    2013. 1. 22.    송상현        최초작성
     *  ---------------------------------------------------
     *</pre>
     * @param zip
     * @return zip
     * @throws Exception
     */
	public static String RemoveDashFromZip(String zip){
		String result = "";
		if(zip != null && zip.length() >= 7){
			result= zip.substring(0, 3) + zip.substring(4, 7);
		}else{
			result = zip;
		}
		return result;
	}
	
	
	/**
	 * @param request : HttpServletRequest 객체
	 * @code CommonUtil.getRequestParam(request);
	 * @return HashMap<String, String>
	 * @see HttpServletRequest -> HashMap<String, String>
	 * @author 김석환
	 * 
	 */
	public static HashMap<String, String> getRequestParam(HttpServletRequest request){
        HashMap<String, String> requestParam = new HashMap<String, String>();
        @SuppressWarnings("rawtypes")
		Enumeration em =  request.getParameterNames();
        String v_  = "";
        String k_  = "";
        while (em.hasMoreElements()) {
			k_ = (String) em.nextElement();
			v_ = request.getParameter(k_);
			requestParam.put(k_, v_);
		}
        
        return requestParam;
	}
	
	/**
	 * @param date : String으로 반환할  날짜
	 * @param format : String으로 변환할 format
	 * @code CommonUtil.date(sdate, "yyyyMMdd");
	 * @return String
	 * @see Date를 format 에 맞는 String으로 변환
	 * @author 김석환
	 * 
	 */		
	public static String date(Date date, String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}
	
	/**
	 * @param source : date로 반환할  날짜 
	 * @param format : String으로 변환할 format
	 * @code CommonUtil.date(sdate_param, "yyyyMMdd");
	 * @return Date
	 * @throws : 현재 날짜 Date
	 * @see : 문자열을 Date 형태로 변환
	 * @author 김석환 
	 * 
	 */	
	public static Date date(String source, String format){
		Date date = null;
				
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		try {
			date = sdf.parse(source);
		} catch (Exception e) {
			date = new Date();
		}
		return date; 
	}	
	
	/**
	 * @param str : 변환할 문자열
	 * @param idx : 초기변환하지 않을 갯수
	 * @code CommonUtil.changeMask(sdate_param, 0);
	 * @return *로 변환된 문자열
	 * @throws : 
	 * @see : 문자열 mask 처리
	 * @author 박금조 
	 * 
	 */	
	public static String changeMask(String str, int idx){
		
		if(str == null || str.equals("")) return "";
		
		String val = "";
		
		int len = str.length();
		for(int i=0; i<len; i++){
			if(i<idx){
				val += str.substring(i,i+1);
			}else{
				val += "*";
			}
		}
		return val;
	}
	
	/**
	 * 패스워드 암호화
	 * @param userPassword
	 * @return
	 * @throws Exception
	 */
	public static String passwordEncrypt(String userPassword) throws Exception {
		String enPassword = "";
		
//		enPassword = PasswordEncrypter.ComputeHash(userPassword , NeosConstants.SALT_KEY.getBytes()); // 인코딩 안함.
		enPassword = EgovFileScrty.encryptPassword(userPassword);

		return enPassword ;
	}
	
	
	    /**
	     * 브라우저 구분 얻기.
	     * 
	     * @param request
	     * @return6
	     */
    public static  String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "Firefox";
    }
	public static boolean isHwpCtrl(String ext) {
		if ( EgovStringUtil.isEmpty(ext) ) return false ;
    	if( ext.equalsIgnoreCase("hwp")) return true ;
    	return false ;
	}
	public static boolean isImage(String ext) {
		if ( EgovStringUtil.isEmpty(ext) ) return false ;
		if 	( ext.equalsIgnoreCase("jpeg") || ext.equalsIgnoreCase("bmp") 
				|| ext.equalsIgnoreCase("jpg") || ext.equalsIgnoreCase("png") 
				|| ext.equalsIgnoreCase("pdf") ) return true ;
		return false ;
	}
    public static boolean isHwpFileOpen(String ext) {
    	if ( EgovStringUtil.isEmpty(ext) ) return false ;
    	if( ext.equalsIgnoreCase("hwp") || ext.equalsIgnoreCase("gif") 
    		|| ext.equalsIgnoreCase("jpeg") || ext.equalsIgnoreCase("bmp") 
    		|| ext.equalsIgnoreCase("jpg") || ext.equalsIgnoreCase("pdf")
    		|| ext.equalsIgnoreCase("html") || ext.equalsIgnoreCase("htm") ) {
    		return true ;
    	}
    	return false ;
    }
	public static void imageMerge( String[] imageFilePathName, String mergeImageFilePathName) throws Exception {
		int rowNum = imageFilePathName.length ;
		BufferedImage[] arrBufferedImage = new BufferedImage[rowNum];
		int point = mergeImageFilePathName.lastIndexOf('.') ;
		String ext = mergeImageFilePathName.substring(point+1, mergeImageFilePathName.length()) ;
		BufferedImage mergedImage= null ;
		File file = null ;
		int width =  0 ;
		int height = 0 ;
		Graphics2D graphics =  null ;
		File mergeImageFile =  null ;
		try {
			for(int inx =0 ; inx <rowNum; inx++) {
				file = new File(imageFilePathName[inx] ) ;
				arrBufferedImage[inx] = ImageIO.read(file);
				file.delete();
			}
			for(int inx =0 ; inx <rowNum; inx++) {
				width = Math.max(width, arrBufferedImage[inx].getWidth());
				height += arrBufferedImage[inx].getHeight();
			}
			
			mergedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
			graphics = (Graphics2D) mergedImage.getGraphics();
			graphics.setBackground(Color.WHITE);
			height = 0 ;
			for( int inx = 0 ; inx < rowNum; inx++) {
				if(inx == 0) {
					graphics.drawImage(arrBufferedImage[inx], 0, 0, null);
				}else {
					height += arrBufferedImage[inx-1].getHeight();
					graphics.drawImage(arrBufferedImage[inx], 0, height, null);
				}
			}
			
			mergeImageFile = new File(mergeImageFilePathName);
			if (mergeImageFile.isFile()) {
				mergeImageFile.delete() ;
			}
			ImageIO.write(mergedImage, ext, mergeImageFile);
			graphics.dispose();
		}catch(Exception e ) {
			e.printStackTrace() ;
			if(graphics != null ) {
				try {graphics.dispose();}catch(Exception ignore) {}
			}
			
		}		
	}
	public static boolean docImageNoExists(String nonExtFilePathName, String fileExt) {
		File file = new File(nonExtFilePathName+".jpg");
		if(file.isFile()) return true ;
//		FileConvert fileConvert = new PDFBoxPdfToImage() ;
		FileConvert fileConvert = new PdfToImage() ;
//		FileConvert fileConvert = new GhostPdfToImage() ;
		String filePathName = nonExtFilePathName +"."+fileExt ;
		String destFilePathName = nonExtFilePathName +".jpg" ;
		boolean result = false ;
		try {
			result = fileConvert.fileConvert(filePathName, destFilePathName) ;
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result ;
	}
	public static  boolean writeToFile(BufferedImage buff,String savePath) {
		 ImageWriter writer = null ;
	       try {

	            System.out.println("got image : " + buff.toString());
	            Iterator iter = ImageIO.getImageWritersByFormatName("jpeg");
	            writer = (ImageWriter)iter.next();
	            ImageWriteParam iwp = writer.getDefaultWriteParam();


	            iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
	            iwp.setCompressionQuality(.5f); 


	            File file = new File(savePath);
	            FileImageOutputStream output = new FileImageOutputStream(file);
	            writer.setOutput(output);
	            IIOImage image = new IIOImage(buff, null, null);
	            writer.write(null, image, iwp);
	            writer.dispose();

	            return true;
	        } catch (Exception e) {
	        	if(writer != null )  {
	        		writer.dispose() ;
	        	}
	             e.printStackTrace();
	        }

	        return false;

	}

	public static String nvl(String str) {
		return nvl(str,"");
	}

	public static String nvl(String str, String def) {
		if(str==null) return def;
		else return str;
	}
	
	/**
	 * 문자를 숫자인지 체크후 int로 변환하여 값 리턴
	 * @param str
	 * @return
	 */
	public static int getIntNvl(String str) {
		str = nvl(str);
		if (isNumeric(str) == true) {
			return Integer.parseInt(str);
		}
		return 0;
	}
	
	/**
	 * 숫자인지 체크
	 * @param str
	 * @return
	 */
	public static boolean isNumeric(String str){  
		try  
		{  
			double d = Double.parseDouble(str);  
		}  
		catch(NumberFormatException nfe)  
		{  
			return false;  
		}  
		return true;  
	} 
	
	
	public static String getSessionData(HttpServletRequest request, String key, Map params) {
		HttpSession session = request.getSession();
		params.put(key, session.getAttribute(key));
		
		return String.valueOf(session.getAttribute(key));
	}
	
	public static String getSessionData(HttpServletRequest request, String key, ModelAndView params) {
		HttpSession session = request.getSession();
		params.addObject(key, session.getAttribute(key));
		return String.valueOf(session.getAttribute(key));
	}
	
	/**
	 * api url 호출용
	 * @param params
	 * @param urlStr
	 * @param method
	 * @return
	 */
	public static String getJsonFromUrl(Map<String,Object> params, String urlStr) {
		return getJsonFromUrl(params, urlStr, "get");
	}
	
	
	public static String getJsonFromUrl(Map<String,Object> params, String urlStr, String method) {
		
		System.out.println(getUrlParameter(params));
		
		return readJSONFeed(urlStr + "?" + getUrlParameter(params));

	}

	public static String getUrlParameter(Map<String,Object> params) {
		StringBuffer sb = new StringBuffer();
		
		if (params != null) {
			Iterator itr = params.entrySet().iterator();
			
			while(itr.hasNext()) {
				String key = String.valueOf(itr.next());
				sb.append(key);
				if(itr.hasNext()) {
					sb.append("&");
				}
			}
			
		}
		
		return sb.toString();
		
	}
	
	
	public static String readJSONFeed(String URL) {
	    StringBuilder stringBuilder = new StringBuilder();
	    HttpClient httpClient = new DefaultHttpClient();
	    HttpGet httpGet = new HttpGet(URL);

	    try {

	        HttpResponse response = httpClient.execute(httpGet);
	        StatusLine statusLine = response.getStatusLine();
	        int statusCode = statusLine.getStatusCode();

	        if (statusCode == 200) {

	            HttpEntity entity = response.getEntity();
	            InputStream inputStream = entity.getContent();
	            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream,"utf-8"),8);
	            String line;
	            while ((line = reader.readLine()) != null) {
	                stringBuilder.append(line);
	            }

	            inputStream.close();

	        } else {
	        }
	    } catch (Exception e) {
	    }
	    return stringBuilder.toString();
	}
	
	public static String htmlRead(String gwPath) throws Exception{
        File file = null;
        FileInputStream fis = null;

        BufferedInputStream in = null;
        ByteArrayOutputStream bStream = null;
        
        file = new File(gwPath);
        fis = new FileInputStream(file);
        
        in = new BufferedInputStream(fis);
        bStream = new ByteArrayOutputStream();        
        
        int htmlByte;
        
        try{
            byte buffer[] = new byte[4096];       
            while((htmlByte = in.read(buffer)) != -1){
                bStream.write(buffer, 0, htmlByte);
            }
        }catch(Exception e){
            System.out.println(e);
        }finally{
            if(bStream != null) try{bStream.close();}catch(IOException e){}
            if(in != null) try{in.close();}catch(IOException e){}
            if(fis != null) try{fis.close();}catch(IOException e){}
        }
        String htmlstr = bStream.toString();
        return htmlstr;
        
    }
	
	public static String osType(){
        String os = System.getProperty("os.name").toLowerCase();
        if(os.indexOf("win") >= 0){
            return "windows";
        }else if(os.indexOf("mac") >= 0){
            return "mac";
        }else if(os.indexOf("nux") >= 0){
            return "linux";
        }else if(os.indexOf("nix") >= 0){
            return "unix";
        }else if(os.indexOf("sunos") >= 0){
            return "solaris";
        }else
        return os;
    }
	
	public static void executeProcess(String[] cmd, String filePath){
        Process p = null;
        try{
            System.out.println("executeProcess cmd : " + cmd);
            ProcessBuilder pb = new ProcessBuilder(cmd);
            pb.directory(new File(filePath));
            p = pb.start();
            p.waitFor();
        }catch(Exception e){
            System.out.println(e);
        }finally{
            p.destroy();                           
        }
    }
	
	public static void main(String[] args) {
		
		Map<String,Object> urlParam = new HashMap<String,Object>();
		urlParam.put("id", "nana");
		urlParam.put("compSeq", "100085");
		urlParam.put("groupSeq", "1");
		urlParam.put("tId", "gw-getMenuTreeList-do");
		
		String str = getJsonFromUrl(urlParam, "http://221.133.55.230/edms/board/getUserBoardList.do");
		JSONObject.fromObject(str.substring(1));
	}
	
}
