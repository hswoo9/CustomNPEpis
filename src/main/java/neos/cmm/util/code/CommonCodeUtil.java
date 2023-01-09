package neos.cmm.util.code;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import admin.option.dao.OptionManageDAO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.code.service.impl.CommonCodeDAO;

public class CommonCodeUtil   {

    //private static CommonCodeUtil commonCodeUtil = new  CommonCodeUtil();

    private static Map<String, List<Map<String, String>>> codeHashMap = null ;
    private static Map<String, List<Map<String, String>>> codeChildHashMap = null ;
    
    private static Object listLock = new Object();
    private static Object listChildLock = new Object();
    private static Object nameLock = new Object();
    private static Object nameChildLock = new Object();

    // 전자결재 옵션 추가
    private static Map<String, List<Map<String, String>>> optionHashMap = null ;
    private static Object listOptionLock = new Object();
    private static Object nameOptionLock = new Object();
    
    
    //상속을 못하게 하기위했어 생성자를 private 으로함.
    private CommonCodeUtil() {};

    /**
     * 전체코드 가져오기(ISCHILD 가 'Y' 인것 제외함)
     */
    public static  void init(CommonCodeDAO commonCodeDAO) throws Exception {
        codeHashMap = null ;
        codeHashMap = new HashMap <String, List<Map<String, String>>>() ;
        List<Map<String, String>> list = commonCodeDAO.selectCommonCode() ;
        List<Map<String, String>> codeList = null ;
        Map<String, String> codeMap = new HashMap<String, String>();
        int rowNum =  0 ;
        if( list != null ) {
            rowNum = list.size() ;
        }

        String curCiflagCode = "" ;
        String prevCiflagCode = "" ;
        int inx = 0 ;
        for( ; inx < rowNum; inx++ ) {
            codeMap = list.get(inx) ;
            curCiflagCode = codeMap.get("CODE_ID");

            if( !prevCiflagCode.equals(curCiflagCode)) {
                if(inx != 0) {
                    codeHashMap.put(prevCiflagCode, codeList) ;
                }
                prevCiflagCode = curCiflagCode ;
                codeList = new ArrayList<Map<String, String>>();
                codeList.add(codeMap);

            }else {
                codeList.add(codeMap);
            }
        }

        codeHashMap.put(prevCiflagCode, codeList) ;
    }


    /**
     * 전체코드 가져오기(ISCHILD 가 'Y' 인것만 가져옴)
     */
    public static  void initChild(CommonCodeDAO commonCodeDAO) throws Exception {
        codeChildHashMap = null ;
        codeChildHashMap = new HashMap <String, List<Map<String, String>>>() ;
        List<Map<String, String>> list = commonCodeDAO.selectChildCommonCode() ;
        List<Map<String, String>> codeList = null ;
        Map<String, String> codeMap = new HashMap<String, String>();
        int rowNum =  0 ;
        if( list != null ) {
            rowNum = list.size() ;
        }

        String curCiflagCode = "" ;
        String prevCiflagCode = "" ;
        int inx = 0 ;
        for( ; inx < rowNum; inx++ ) {
            codeMap = list.get(inx) ;
            curCiflagCode = codeMap.get("CODE_ID");

            if( !prevCiflagCode.equals(curCiflagCode)) {
                if(inx != 0) {
                    codeChildHashMap.put(prevCiflagCode, codeList) ;
                }
                prevCiflagCode = curCiflagCode ;
                codeList = new ArrayList<Map<String, String>>();
                codeList.add(codeMap);

            }else {
                codeList.add(codeMap);
            }
        }

        codeChildHashMap.put(prevCiflagCode, codeList) ;
    }

    /**
     * 코드리스트를 반환한다.
     * @param flagCode
     * @return
     */
    public static  List<Map<String, String>>  getCodeList( String codeID )throws Exception  {
        synchronized(CommonCodeUtil.listLock) {
            return codeHashMap.get(codeID) ;
        }
    }

    /**
     * 
     * getCodeListLang doban7 2017. 1. 31.
     * @param codeID
     * @return
     * @throws Exception
     */
    public static  List<Map<String, String>>  getCodeListLang( String codeID )throws Exception  {

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	String langCode = "";
    	if(loginVO != null){
    		langCode = loginVO.getLangCode();	
    	}
    	
    	List<Map<String, String>> list = getCodeList(codeID)  ;
		if(list == null){
			return list ;
		}
		for (Map<String, String> codeMap : list) {
			if (langCode.equals("en")) {
				codeMap.put("CODE_NM", codeMap.get("CODE_EN"));
	        }else if (langCode.equals("jp")){
	        	codeMap.put("CODE_NM", codeMap.get("CODE_JP"));
	        }else if (langCode.equals("cn")){
	        	codeMap.put("CODE_NM", codeMap.get("CODE_CN"));
	        }else{
	        	codeMap.put("CODE_NM", codeMap.get("CODE_KR"));
	        }
		}
		
        return list ;
    }    
    /**
     * 코드리스트를 반환한다.(Child)
     * @param flagCode
     * @return
     */
    public static  List<Map<String, String>>  getChildCodeList( String codeID )throws Exception  {
        synchronized(CommonCodeUtil.listChildLock) {
            return codeChildHashMap.get(codeID) ;
        }
    }

    /**
     * 코드리스트 전체를 반환한다.(Child)
     * @param flagCode
     * @return
     */
    public static  List<Map<String, String>>  getChildCodeListAll(  )throws Exception  {
        List<Map<String, String>> list = new ArrayList<Map<String, String>>();
        synchronized(CommonCodeUtil.listChildLock) {
            Iterator<String> iter = codeChildHashMap.keySet().iterator();
            List<Map<String, String>> temp = null;
            while (iter.hasNext()) {
                String key = iter.next();
                String val = "";
                temp =  codeChildHashMap.get(key);
                if(temp != null) {
                    //System.out.println(temp.size() + " :  temp.size()");
                    if(temp.size() > 0){
                        val = temp.get(0).get("CODE_DC");
                    }   
                }
                
                Map<String, String> item = new HashMap<String, String>();
                item.put("CODE", key);
                item.put("CODE_DC", val);
                list.add(item);
            }
        }
        return list;
    }

    /**
     * 코드 이름을 반환 한다.
     * @param flagCode
     * @param ciKeyCode
     * @param columnName
     * @return
     */
    public static  String getCodeName( String codeID, String code ) throws Exception  {
    	/*LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	String langCode = "";
    	if(loginVO != null){
    		langCode = loginVO.getLangCode();
    	}*/
        return getCodeName( codeID, code, "kr") ;
    }
    /**
     * 코드 이름을 반환 한다.
     * @param flagCode
     * @param ciKeyCode
     * @param columnName
     * @return
     */
    public static  String getCodeName( String codeID, String code, String langCode ) throws Exception  {

        synchronized(CommonCodeUtil.nameLock) {
            List<Map<String, String>> codeList =  codeHashMap.get(codeID) ;
            Map<String, String> codeMap = null ;
            String codeName = "" ;
            String keyCode = "" ;
            if(codeList == null ) return "" ;
            int rowNum = 0 ;
            rowNum  = codeList.size() ;

            for( int inx=0; inx< rowNum; inx++) {
                codeMap =  codeList.get(inx);
                if( codeMap == null ) return "" ;
                keyCode = codeMap.get("CODE") ;
                if(code.equals(keyCode)) {
                    if (langCode.equals("en")) {
                    	codeName = codeMap.get("CODE_EN") ;
                    }else if (langCode.equals("jp")){
                    	codeName = codeMap.get("CODE_JP") ;
                    }else if (langCode.equals("cn")){
                    	codeName = codeMap.get("CODE_CN") ;
                    }else{
                    	codeName = codeMap.get("CODE_KR") ;	
                    }
                    break;
                }
            }
            return codeName ;
        }
    }
    
    
    public static  String getChildCodeName( String codeID, String code ) throws Exception  {
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	String langCode = "";
    	if(loginVO != null){
    		langCode = loginVO.getLangCode();
    	}
        return getChildCodeName( codeID, code, langCode) ;
    }
    
    /**
     * 코드 이름을 반환 한다.
     * @param flagCode
     * @param ciKeyCode
     * @param columnName
     * @return
     */
    public static  String getChildCodeName( String codeID, String code, String langCode ) throws Exception  {
        synchronized(CommonCodeUtil.nameChildLock) {
            List<Map<String, String>> codeList =  codeChildHashMap.get(codeID) ;
            Map<String, String> codeMap = null ;
            String codeName = "" ;
            String keyCode = "" ;
            if(codeList == null ) return "" ;
            int rowNum = 0 ;
            rowNum  = codeList.size() ;

            for( int inx=0; inx< rowNum; inx++) {
                codeMap =  codeList.get(inx);
                if( codeMap == null ) return "" ;
                keyCode = codeMap.get("CODE") ;
                if(code.equals(keyCode)) {
                    if (langCode.equals("en")) {
                    	codeName = codeMap.get("CODE_EN") ;
                    }else if (langCode.equals("jp")){
                    	codeName = codeMap.get("CODE_JP") ;
                    }else if (langCode.equals("cn")){
                    	codeName = codeMap.get("CODE_CN") ;
                    }else{
                    	codeName = codeMap.get("CODE_KR") ;	
                    }
                    break;
                }
            }
            return codeName ;
        }
    }

    /*
     *  코드를 다시 가져온다.
     */
    public static  void reBuild( CommonCodeDAO commonCodeDAO ) throws Exception {
        synchronized(CommonCodeUtil.listLock) {
            synchronized(CommonCodeUtil.nameLock) {
                init(commonCodeDAO);
            }
        }
        synchronized(CommonCodeUtil.listChildLock) {
            synchronized(CommonCodeUtil.nameChildLock) {
                initChild(commonCodeDAO);
            }
        }
    }

	/** 
	 * initOption doban7 2016. 11. 24.
	 * @param optionManageDAO
	 */
	public static void initOption(OptionManageDAO optionManageDAO) {
        optionHashMap = null ;
        optionHashMap = new HashMap <String, List<Map<String, String>>>() ;
        
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("sMODULE_TP", "np");
        
        List<Map<String, String>> list = optionManageDAO.GetOptionListAll(paramMap);
        
        List<Map<String, String>> optionList = null ;
        Map<String, String> optionMap = new HashMap<String, String>();
        int rowNum =  0 ;
        if( list != null ) {
            rowNum = list.size() ;
        }

        String curComSeq = "" ;
        String prevComSeq = "" ;
        int inx = 0 ;
        for( ; inx < rowNum; inx++ ) {
        	optionMap = list.get(inx) ;
            curComSeq = optionMap.get("CO_ID");

            if( !prevComSeq.equals(curComSeq)) {
                if(inx != 0) {
                	optionHashMap.put(prevComSeq, optionList) ;
                }
                prevComSeq = curComSeq ;
                optionList = new ArrayList<Map<String, String>>();
                optionList.add(optionMap);

            }else {
            	optionList.add(optionMap);
            }
        }

        optionHashMap.put(prevComSeq, optionList) ;
	}
	
	/**
	 * 회사 옵션 리스트
	 * getOptionList doban7 2016. 12. 22.
	 * @param compSeq
	 * @return
	 * @throws Exception
	 */
	public static  List<Map<String, String>>  getOptionList( String compSeq )throws Exception  {
		synchronized(CommonCodeUtil.listOptionLock) {
			return optionHashMap.get(compSeq) ;
		}
	}
	
	/** 
	 * 회사 ,옵션  value
	 * getOptionValue doban7 2016. 12. 22.
	 * @param compSeq
	 * @param optionId
	 * @return
	 * @throws Exception
	 */
    public static  String getOptionValue( String compSeq, String optionId ) throws Exception  {
        synchronized(CommonCodeUtil.nameOptionLock) {
            List<Map<String, String>> codeList =  optionHashMap.get(compSeq) ;
            Map<String, String> codeMap = null ;
            String codeName = "" ;
            String keyCode = "" ;
            if(codeList == null ) return "" ;
            int rowNum = 0 ;
            rowNum  = codeList.size() ;

            for( int inx=0; inx< rowNum; inx++) {
                codeMap =  codeList.get(inx);
                if( codeMap == null ) return "" ;
                keyCode = codeMap.get("OPTION_ID") ;  // 옵션 아이디
                if(optionId.equals(keyCode)) {
                    codeName = codeMap.get("OPTION_VALUE") ; // 옵션 value
                    break;
                }
            }
            return codeName ;
        }
    }
    
    public static  void reBuildOption( OptionManageDAO optionManageDAO) throws Exception {

        synchronized(CommonCodeUtil.listOptionLock) {
            synchronized(CommonCodeUtil.nameOptionLock) {
            	initOption(optionManageDAO);
            }
        }
    }
}
