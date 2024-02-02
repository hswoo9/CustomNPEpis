package com.duzon.custom.expend.etc;

import ac.cmm.vo.ConnectionVO2;
import bizbox.orgchart.service.vo.LoginVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import org.codehaus.jackson.type.TypeReference;
import com.duzon.custom.expend.etc.CommonInterface.commonCode;
import com.duzon.custom.expend.etc.CommonMapInterface.commonExPath;
@Service("CommonConvert")
public class CommonConvert {

    private static String getDateCode(Object o) {
        String toO = "";
        String returnVal = "";
        try {
            toO = o.toString();
            toO = toO.replace("-", "");
            returnVal = toO.substring(0, 4) + "-" + toO.substring(4, 6) + "-" + toO.substring(6, 8);
        } catch (Exception ex) {
            returnVal = "";
        }
        return returnVal;
    }

    private static String getCurrencyCode(Object o) {
        String returnVal = "";
        try {
            returnVal = String.format("%,.0f", Double.parseDouble(o.toString()));
        } catch (Exception ex) {
            returnVal = "0";
        }
        return returnVal;
    }

    /**
     * NP 반환 포멧 설정
     */
    public static ResultVO setNpResultFormat(ResultVO param) {

        /* resultVO aData 변경 */
        Map<String, Object> resultAData = new HashMap<String, Object>();
        Map<String, Object> aData = param.getaData();
        Iterator<String> iterator = aData.keySet().iterator();

        while (iterator.hasNext()) {
            String key = iterator.next();
            switch (key) {
                case "resDate":
                case "regDate":
                    resultAData.put(key, getDateCode(aData.get(key)));
                    break;
                case "tradeAmt":
                case "tradeStdAmt":
                case "tradeVatAmt":
                case "resAmt":
                case "budgetAmt":
                case "erpOpenAmt":
                case "erpApplyAmt":
                case "erpLeftAmt":
                case "budgetStdAmt":
                case "budgetTaxAmt":
                    resultAData.put(key, getCurrencyCode(aData.get(key)));
                default:
                    resultAData.put(key, aData.get(key));
                    break;
            }
        }
        param.setaData(resultAData);

        /* resultVO aaData 변경 */
        List<Map<String, Object>> aaData = param.getAaData();

        for (int i = 0; i < aaData.size(); i++) {
            Map<String, Object> item = aaData.get(i);
            Iterator<String> iterator2 = item.keySet().iterator();

            while (iterator2.hasNext()) {
                String key = iterator2.next();
                switch (key) {
                    case "resDate":
                    case "regDate":
                        item.put(key, getDateCode(item.get(key)));
                        break;
                    case "tradeAmt":
                    case "tradeStdAmt":
                    case "tradeVatAmt":
                    case "resAmt":
                    case "budgetAmt":
                    case "erpOpenAmt":
                    case "erpApplyAmt":
                    case "erpLeftAmt":
                    case "budgetStdAmt":
                    case "budgetTaxAmt":
                    case "consDocAmt":
                        item.put(key, getCurrencyCode(item.get(key)));
                    default:
                        item.put(key, item.get(key));
                        break;
                }
            }
        }
        param.setAaData(aaData);

        /* 반환 데이터 리턴 */
        return param;
    }

    /* NULL to ... */
    /* NULL to ... - EmptyStr 반환 */
    public static String CommonGetStr(Object params) {
        String result = commonCode.emptyStr;
        if (params != null) {
            result = (StringUtils.isEmpty(String.valueOf(params)) ? commonCode.emptyStr : String.valueOf(params));
        }
        return result;
    }

    /* NULL to ... - EmptySeq 반환 */
    public static String CommonGetSeq(Object params) {
        String result = commonCode.emptySeq;
        if (params != null) {
            result = (StringUtils.isEmpty(String.valueOf(params)) ? commonCode.emptySeq : String.valueOf(params));
        }
        return result;
    }

    /* NULL to ... - 0.0 반환 */
    public static double CommonGetDouble(Object params) {
        double result = Double.parseDouble("0.0");
        if (params != null) {
            if ((CommonConvert.CommonGetStr(params).equals(""))) {
                result = Double.parseDouble("0.0");
            } else {
                if (CommonConvert.CommonGetStr(params).indexOf(".") > -1) {
                    result = Double.parseDouble(CommonConvert.CommonGetStr(params));
                } else {
                    result = Double.parseDouble(CommonConvert.CommonGetStr(params) + ".0");
                }
            }
        }
        return result;
    }

    /* Map to ... */
    /* map to ... - Map to Get String 반환 */
    public static String CommonGetParamStr(Map<String, Object> params) {
        String keyAttribute = commonCode.emptyStr;
        StringBuilder result = new StringBuilder();
        Iterator<String> itr = params.keySet().iterator();
        while (itr.hasNext()) {
            keyAttribute = itr.next();
            if (!CommonConvert.CommonGetStr(result).toString().equals(commonCode.emptyStr)) {
                result.append("&" + keyAttribute + "=" + (String) params.get(keyAttribute));
            } else {
                result.append("?" + keyAttribute + "=" + (String) params.get(keyAttribute));
            }
        }
        return result.toString();
    }

    /* Map to ... - Map to String 반환 */
    public static String CommonGetMapStr(Map<String, Object> params) {
        String result = commonCode.emptyStr;
        result = (params == null ? commonCode.emptyStr : params.toString());
        return result;
    }

    /* Map to ... - Map to JSON String 반환 */
    public static String ConvertMapToJson(Map<String, Object> params) {
        return CommonConvert.CommonGetMapToJSONStr(params);
    }

    public static String CommonGetMapToJSONStr(Map<String, Object> params) {
        String result = commonCode.emptyStr;
        JSONObject json = new JSONObject();
        Set<String> key = params.keySet();
        for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
            String keyName = CommonConvert.CommonGetStr(iterator.next());
            json.put(keyName, CommonGetStr(params.get(keyName)));
        }
        result = CommonGetStr(json.toString());
        return result;
    }

    /* Map to ... - Map to JSON Object 반환 */
    public static JSONObject CommonGetMapToJSONObj(Map<String, Object> params) {
        JSONObject result = new JSONObject();
        Set<String> key = params.keySet();
        for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
            String keyName = CommonConvert.CommonGetStr(iterator.next());
            result.put(keyName, CommonGetStr(params.get(keyName)));
        }
        return result;
    }

    /* Helper - ListMap To JSON */
    public static String CommonGetListMapToJson(List<Map<String, Object>> param) throws Exception {
        String result = commonCode.emptyStr;
        JSONArray jsonArray = JSONArray.fromObject(param);
        result = jsonArray.toString();
        return result;
    }

    /* Helper - ListMap To JSON */
    public static JSONArray ConvertListMapToJson(List<Map<String, Object>> param) throws Exception {
        return CommonConvert.CommonGetListMapToJsonArray(param);
    }

    public static JSONArray CommonGetListMapToJsonArray(List<Map<String, Object>> param) throws Exception {
        JSONArray jsonArray = JSONArray.fromObject(param);
        return jsonArray;
    }

    /* Map to ... - Map to Object 반환 */
    public static Object ConvertMapToObject(Map<String, Object> params, Object objClass) {
        return CommonConvert.CommonGetMapToObject(params, objClass);
    }

    public static Object CommonGetMapToObject(Map<String, Object> params, Object objClass) {
        String keyAttribute = null;
        String setMethodString = "set";
        String setMethod = null;
        String getMethodString = "get";
        String getMethod = null;
        Object obj = new Object();
        Iterator<String> itr = params.keySet().iterator();
        while (itr.hasNext()) {
            keyAttribute = itr.next();
            setMethod = setMethodString + keyAttribute.substring(0, 1).toUpperCase() + keyAttribute.substring(1);
            getMethod = getMethodString + keyAttribute.substring(0, 1).toUpperCase() + keyAttribute.substring(1);
            try {
                Method[] methods = objClass.getClass().getDeclaredMethods();
                /* Get */
                for (int i = 0; i <= methods.length - 1; i++) {
                    if (getMethod.equals(methods[i].getName())) {
                        obj = methods[i].invoke(objClass);
                    }
                }
                /* Set */
                for (int i = 0; i <= methods.length - 1; i++) {
                    if (setMethod.equals(methods[i].getName())) {
                        if (obj.getClass().getName().equals("java.lang.String")) {
                            methods[i].invoke(objClass, CommonConvert.CommonGetStr(params.get(keyAttribute)));
                        } else {
                            methods[i].invoke(objClass, Integer.parseInt(CommonConvert.CommonGetSeq(params.get(keyAttribute))));
                        }
                    }
                }
            } catch (SecurityException e) {
                /* e.printStackTrace(); */
            } catch (IllegalAccessException e) {
                /* e.printStackTrace(); */
            } catch (IllegalArgumentException e) {
                /* e.printStackTrace(); */
            } catch (InvocationTargetException e) {
                /* e.printStackTrace(); */
            }
        }
        return objClass;
    }
    /* List to ... */

    /* Object to ... */
    /* Object to ... - Object to Map 반환 */
    public static Map<String, Object> ConverObjectToMap(Object params) {
        return CommonConvert.CommonGetObjectToMap(params);
    }

    public static Map<String, Object> CommonGetObjectToMap(Object params) {
        try {
            Field[] fields = params.getClass().getDeclaredFields();
            Map<String, Object> result = new HashMap<String, Object>();
            for (int i = 0; i <= fields.length - 1; i++) {
                fields[i].setAccessible(true);
                result.put(fields[i].getName(), CommonGetStr(fields[i].get(params)));
            }
            return result;
        } catch (IllegalArgumentException e) {
            /* e.printStackTrace(); */
        } catch (IllegalAccessException e) {
            /* e.printStackTrace(); */
        }
        return null;
    }

    /* JSON to ... */
    /* JSON to ... - JSON to Map */
    public static Map<String, Object> ConvertJsonToMap(String params) {
        return CommonConvert.CommonGetJSONToMap(params);
    }

    public static Map<String, Object> CommonGetJSONToMap(String params) {
        params = CommonCharSetToString(CommonGetStr(params));
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            result = mapper.readValue(params, new TypeReference<Map<String, String>>() {});
        } catch (JsonParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JsonMappingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return result;
    }

    /* JSON to ... - JSON to ListMap */
    public static List<Map<String, Object>> ConvertJsonToListMap(String jsonStr) throws Exception {
        return CommonConvert.CommonGetJSONToListMap(jsonStr);
    }

    public static List<Map<String, Object>> CommonGetJSONToListMap(String jsonStr) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        jsonStr = CommonCharSetToString(jsonStr);
        try {
            result = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>() {});
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return result;
    }

    public static String CommonCharSetToString(String params) {
        params = params.replaceAll("&nbsp;", " ");
        params = params.replaceAll("&nbsp", " ");
        params = params.replaceAll("&lt;", "<");
        params = params.replaceAll("&lt", "<");
        params = params.replaceAll("&gt;", ">");
        params = params.replaceAll("&gt", ">");
        params = params.replaceAll("&amp;", "&");
        params = params.replaceAll("&amp", "&");
        params = params.replaceAll("&quot;", "\"");
        params = params.replaceAll("&quot", "\"");
        return params;
    }

    /**
     * <pre>
     * # 로그인 사용자 정보를 조회하여, 필요한 부분만 추려서 Map으로 반환
     *   - 로그인 아이디 : id
     *   - 그룹 시퀀스 : groupSeq
     *   - 회사 시퀀스 : compSeq
     *   - 사업장 시퀀스 : bizSeq
     *   - 부서 시퀀스 : deptSeq
     *   - 사원 시퀀스 : empSeq
     *   - 사원 이름 : empName
     *   - 사용언어 코드 : langCode
     *   - 사용자 접근 권한 : userSe
     *   - ERP 사원 번호 : erpEmpSeq
     *   - ERP 회사 코드 : erpCompSeq
     *   - 연동 전자결재 구분 : eaType
     *
     * # 주의 사항
     *   - interlock.exp.web.VInterlockPopController 사용 불가
     *   - interlock.exp.web.BInterlockController 사용 불가
     * </pre>
     *
     * @return
     * @throws NotFoundLoginSessionException
     */
    public static Map<String, Object> CommonGetEmpInfo() throws NotFoundLoginSessionException {
        Map<String, Object> result = new HashMap<String, Object>();
        LoginVO loginVo = CommonConvert.CommonGetEmpVO();
        if (loginVo == null) {
            throw new NotFoundLoginSessionException("Not found login session..");
        }

        result.put(commonCode.id, CommonConvert.CommonGetStr(loginVo.getId())); /* 로그인 아이디 */
        result.put(commonCode.groupSeq, CommonConvert.CommonGetStr(loginVo.getGroupSeq())); /* 그룹시퀀스 */
        result.put(commonCode.compSeq, CommonConvert.CommonGetStr(loginVo.getCompSeq())); /* 회사시퀀스 */
        result.put(commonCode.bizSeq, CommonConvert.CommonGetStr(loginVo.getBizSeq())); /* 사업장시퀀스 */
        result.put(commonCode.deptSeq, CommonConvert.CommonGetStr(loginVo.getOrgnztId())); /* 부서시퀀스 */
        result.put(commonCode.empSeq, CommonConvert.CommonGetStr(loginVo.getUniqId())); /* 사원시퀀스 */
        result.put(commonCode.empName, CommonConvert.CommonGetStr(loginVo.getName())); /* 사원이름 */
        result.put(commonCode.langCode, CommonConvert.CommonGetStr(loginVo.getLangCode())); /* 사용언어코드 */
        result.put(commonCode.userSe, CommonConvert.CommonGetStr(loginVo.getUserSe())); /* 사용자접근권한 */
        result.put(commonCode.erpEmpSeq, CommonConvert.CommonGetStr(loginVo.getErpEmpCd())); /* ERP사원번호 */
        result.put(commonCode.erpCompSeq, CommonConvert.CommonGetStr(loginVo.getErpCoCd())); /* ERP회사코드 */
        result.put(commonCode.eaType, CommonConvert.CommonGetStr(loginVo.getEaType())); /* 연동 전자결재 구분 */

        return result;
    }

    /**
     * <pre>
     * # 로그인 사용자 정보 조회
     *
     * # 주의 사항
     *   - interlock.exp.web.VInterlockPopController 사용 불가
     *   - interlock.exp.web.BInterlockController 사용 불가
     *
     * # 주요 사용 getter
     *   - 로그인 아이디 : getId()
     *   - 그룹 시퀀스 : getGroupSeq()
     *   - 회사 시퀀스 : getCompSeq()
     *   - 사업장 시퀀스 : getBizSeq()
     *   - 부서 시퀀스 : getOrgnztId()
     *   - 사원 시퀀스 : getUniqId()
     *   - 사원 이름 : getName()
     *   - 사용언어 코드 : getLangCode()
     *   - 사용자 접근 권한 : getUserSe()
     *   - ERP 사원 번호 : getErpEmpCd()
     *   - ERP 회사 코드 : getErpCoCd()
     *   - 연동 전자결재 구분 : getEaType()
     *
     * </pre>
     *
     * @return bizbox.orgchart.service.vo.LoginVO
     * @throws NotFoundLoginSessionException
     */
    public static LoginVO CommonGetEmpVO() throws NotFoundLoginSessionException {
        LoginVO loginVo = new LoginVO();
        loginVo = (LoginVO) RequestContextHolder.getRequestAttributes().getAttribute("LoginVO", RequestAttributes.SCOPE_SESSION);
        RequestContextHolder.getRequestAttributes().getSessionId();
        if (loginVo == null) {
            /* ERPiU 테스트 */
//            loginVo = new LoginVO();
//            loginVo.setId("ERPiU");
//            loginVo.setGroupSeq("dragons_test");
//            loginVo.setCompSeq("1229");
//            loginVo.setBizSeq("1229");
//            loginVo.setOrgnztId("1231");
//            loginVo.setUniqId("1233");
//            loginVo.setName("ERPiU");
//            loginVo.setLangCode("kr");
//            loginVo.setUserSe("ADMIN");
//            loginVo.setErpEmpCd("0529");
//            loginVo.setErpCoCd("10000");
//            loginVo.setEaType("eap");

            /* iCUBE 테스트 */
            // loginVo = new LoginVO();
            // loginVo.setId("admin");
            // loginVo.setGroupSeq("dragons_test");
            // loginVo.setCompSeq("1000");
            // loginVo.setBizSeq("1000");
            // loginVo.setOrgnztId("1110");
            // loginVo.setUniqId("1");
            // loginVo.setName("admin");
            // loginVo.setLangCode("kr");
            // loginVo.setUserSe("ADMIN");
            // loginVo.setErpEmpCd("admin");
            // loginVo.setErpCoCd("3585");
            // loginVo.setEaType("eap");

            /* 생보부동산신탁 */
            // loginVo = new LoginVO();
            // loginVo.setId("admin");
            // loginVo.setGroupSeq("sbtrustastest");
            // loginVo.setCompSeq("1000");
            // loginVo.setBizSeq("1000100");
            // loginVo.setOrgnztId("1000111140");
            // loginVo.setUniqId("23324");
            // loginVo.setName("손혜진");
            // loginVo.setLangCode("kr");
            // loginVo.setUserSe("USER");
            // loginVo.setErpEmpCd("00274");
            // loginVo.setErpCoCd("1000");
            // loginVo.setEaType("eap");

            /* 한성자동차 - 테스트 */
            // loginVo = new LoginVO();
            // loginVo.setId("admin");
            // loginVo.setGroupSeq("THSMC");
            // loginVo.setCompSeq("1000");
            // loginVo.setBizSeq("104104");
            // loginVo.setOrgnztId("104H09007");
            // loginVo.setUniqId("16276");
            // loginVo.setName("홍민호");
            // loginVo.setLangCode("kr");
            // loginVo.setUserSe("ADMIN");
            // loginVo.setErpEmpCd("104");
            // loginVo.setErpCoCd("04150HS18");
            // loginVo.setEaType("eap");

            /* ERPiU - 영리 기획 검수 */
            /*
             * loginVo = new LoginVO(); loginVo.setId("ERPiU"); loginVo.setGroupSeq("dragons_test"); loginVo.setCompSeq("1229"); loginVo.setBizSeq("1229"); loginVo.setOrgnztId("1231"); loginVo.setUniqId("1233"); loginVo.setName("ERPiU"); loginVo.setLangCode("kr"); loginVo.setUserSe("ADMIN"); loginVo.setErpEmpCd("0529"); loginVo.setErpCoCd("10000"); loginVo.setEaType("eap");
             */

            // ExpInfo.TempLog("Not found login session..", null);
            // throw new NotFoundLoginSessionException("Not found login session..");



            /* iCUBE 테스트 */
            loginVo = new LoginVO();
            loginVo.setId("admin");
            loginVo.setGroupSeq("epis");
            loginVo.setCompSeq("1000");
            loginVo.setBizSeq("1000");
            loginVo.setOrgnztId("1110");
            loginVo.setUniqId("1");
            loginVo.setName("admin");
            loginVo.setLangCode("kr");
            loginVo.setUserSe("ADMIN");
            loginVo.setErpEmpCd("120523006");
            loginVo.setErpCoCd("5000");
            loginVo.setEaType("ea");
        }

        StringBuilder sb = new StringBuilder();
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] =======================================");
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 아이디 : " + loginVo.getId());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 그룹시퀀스 : " + loginVo.getGroupSeq());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 회사시퀀스 : " + loginVo.getCompSeq());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 사업장시퀀스 : " + loginVo.getBizSeq());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 부서시퀀스 : " + loginVo.getOrgnztId());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 사원시퀀스 : " + loginVo.getUniqId());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 사원명 : " + loginVo.getName());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 언어코드 : " + loginVo.getLangCode());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 권한 : " + loginVo.getUserSe() + " / " + loginVo.getId());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 사원번호 : " + loginVo.getErpEmpCd());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 회사코드 : " + loginVo.getErpCoCd());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 전자결재 : " + loginVo.getEaType());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] 세션 : " + RequestContextHolder.getRequestAttributes().getSessionId());
        sb.append(System.getProperty("line.separator"));
        sb.append("[_LOGIN] =======================================");
        sb.append(System.getProperty("line.separator"));


        return loginVo;
    }

    /* Map 에서 Map 으로 복사 진행 - target 미정의 */
    public static Map<String, Object> CommonSetMapCopy(Map<String, Object> source) {
        Map<String, Object> result = new HashMap<String, Object>();
        result = CommonSetMapCopy(source, result);
        return result;
    }

    /* key 복사 ( Map > Map ) */
    public static Map<String, Object> CommonSetMapCopy(Map<String, Object> source, Map<String, Object> target, String[] keys) throws Exception {
        if (source != null && source.size() > 0) {
            for (String item : keys) {
                if (null == source.get(item)) {
                    target.put(item, null);
                } else {
                    target.put(item, source.get(item));
                }
            }
        }
        return target;
    }

    /* key 를 모를경우 복사 ( Map > Map ) */
    public static Map<String, Object> CommonSetMapCopyNotKey(Map<String, Object> source) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        if (source != null) {
            Set<String> key = source.keySet();
            for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
                String keyName = CommonConvert.CommonGetStr(iterator.next());
                result.put(keyName, source.get(keyName));
            }
        }
        return result;
    }

    /* Map 에서 Map 으로 복사 진행 - target 정의 */
    public static Map<String, Object> CommonSetMapCopy(Map<String, Object> source, Map<String, Object> target) {
        if (source != null) {
            Set<String> key = source.keySet();
            for (Iterator<String> iterator = key.iterator(); iterator.hasNext();) {
                String keyName = CommonConvert.CommonGetStr(iterator.next());
                switch (keyName) {
                    case "group_seq":
                    case commonCode.groupSeq:
                        target.put(commonCode.groupSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "comp_seq":
                    case commonCode.compSeq:
                        target.put(commonCode.compSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "biz_seq":
                    case commonCode.bizSeq:
                        target.put(commonCode.bizSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "dept_seq":
                    case commonCode.deptSeq:
                        target.put(commonCode.deptSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "user_id":
                    case "emp_seq":
                    case commonCode.empSeq:
                        target.put(commonCode.empSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "erp_emp_seq":
                    case commonCode.erpEmpSeq:
                        target.put(commonCode.erpEmpSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "erp_co_cd":
                    case "erpCoCd":
                    case commonCode.erpCompSeq:
                        target.put(commonCode.erpCompSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "lang_code":
                    case commonCode.langCode:
                        target.put(commonCode.langCode, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "form_id":
                    case "formId":
                    case "template_key":
                    case commonCode.formSeq:
                        target.put(commonCode.formSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        target.put("form_id", source.get(keyName));
                        target.put("formId", source.get(keyName));
                        target.put("template_key", source.get(keyName));
                        break;
                    case "form_tp":
                    case commonCode.formTp:
                        target.put(commonCode.formTp, source.get(keyName));
                        target.put("processId", source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "form_d_tp":
                    case commonCode.formDTp:
                        target.put(commonCode.formDTp, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "doc_id":
                    case "diKeyCode":
                    case commonCode.docId:
                    case commonCode.docSeq:
                        target.put("diKeyCode", source.get(keyName));
                        target.put(commonCode.docSeq, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "appro_key":
                    case "approkey":
                    case commonCode.approKey:
                        target.put(commonCode.approKey, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "type":
                    case commonCode.processId:
                        target.put(commonCode.processId, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "stat":
                    case commonCode.docSts:
                        target.put(commonCode.docSts, source.get(keyName));
                        target.put(keyName, source.get(keyName));
                        break;
                    case "doc_title":
                    case commonCode.docTitle:
                        target.put(commonCode.docTitle, source.get(keyName));
                        break;
                    case "doc_content":
                    case commonCode.docContent:
                        target.put(commonCode.docContent, source.get(keyName));
                        break;
                    case "interlock_url":
                    case commonCode.interlockUrl:
                        target.put(commonCode.interlockUrl, source.get(keyName));
                        break;
                    case "interlock_name":
                    case commonCode.interlockName:
                        target.put(commonCode.interlockName, source.get(keyName));
                        break;
                    default:
                        target.put(keyName, source.get(keyName));
                        break;
                }
                target.put(keyName, source.get(keyName));
            }
        }
        return target;
    }

    /* 필요한 파라미터 키 등록 */
    @SuppressWarnings("deprecation")
    public static Map<String, Object> CommonSetParams(Map<String, Object> source, String[] keyArray) {
        for (String key : keyArray) {
            if (!source.containsKey(key)) {
                source.put(key, "");
            }
        }
        return source;
    }

    /* iCUBE 연동이면서 G20 인 경우 확인 */
    public static boolean CommonGetNP(ConnectionVO2 conVo) {
        switch (CommonConvert.CommonGetStr(conVo.getErpTypeCode())) {
            case commonCode.iCUBE: /* ERP iCUBE */
                if (CommonConvert.CommonGetStr(conVo.getG20YN()).toUpperCase().equals(commonCode.emptyYes)) {
                    return true;
                }
                /* return false; */
                return true; /* 개발을 위해 임시로 처리 */
            default:
                return false;
        }
    }

    /* client IP 주소 가져오기 */
    public static String CommonGetClientIP(HttpServletRequest request) {
        String result = request.getHeader("X-FORWARDED-FOR");
        if (result == null || result.length() == 0) {
            result = request.getHeader("Proxy-Client-IP");
        }
        if (result == null || result.length() == 0) {
            result = request.getHeader("WL-Proxy-Client-IP"); // 웹로직?
        }
        if (result == null || result.length() == 0) {
            result = request.getRemoteAddr();
        }
        if (result == null) {
            result = "";
        }
        return result;
    }

    /* Javascript로 ' 기호 출력시 사용 */
    public static String CommonConvertSpecialCharaterForHTML(String value) {
        String result = value;
        if (result.indexOf("'") > -1) {
            result = result.replaceAll("'", "&#39;");
        }
        if (result.indexOf("\"") > -1) {
            result = result.replaceAll("\"", "&quot;");
        }
        return result;
    }

    /* Ajax 통해 들어온 특수문자 변경 처리 */
    public static String CommonConvertSpecialCharaterForJava(String value) {
        String result = value;
        if (result.indexOf("&apos;") > -1) {
            result = result.replaceAll("&apos;", "'");
        }
        if (result.indexOf("&quot;") > -1) {
            result = result.replaceAll("&quot;", "\"");
        }
        return result;
    }

    /* 로그인 점검 및 권한 확인 */
    public static String CommonLoginAuthChk(String path, String authType) throws Exception {
        Map<String, Object> loginInfo = new HashMap<String, Object>();
        loginInfo = CommonConvert.CommonGetEmpInfo();
        if (loginInfo != null) {
            if (CommonConvert.CommonGetStr(loginInfo.get(commonCode.userSe)).equals(authType)) {
                return path;
            } else {
                /* 권한 없음 경로 반환 */
                return commonExPath.ErrorPagePath + commonExPath.cmErrorCheckAuth;
            }
        } else {
            /* 로그인 경로 반환 */
            return commonExPath.ErrorPagePath + commonExPath.cmErrorCheckLogin;
        }
    }

    /* toString with null check */
    public static String NullToString(Object o) {
        String result = "";
        try {
            result = o == null ? "" : o.toString();
        } catch (Exception ex) {
            result = "";
        }
        return result;
    }

    /* toString with null check */
    public static String NullToString(Object o, String defaultStr) {
        String result = defaultStr;
        try {
            result = o == null ? defaultStr : o.toString();
            result = o.equals("") ? defaultStr : o.toString();
        } catch (Exception ex) {
            result = defaultStr;
        }
        return result;
    }

    public static String ReturnDateFormat(Object date) {
        String returnStr = NullToString(date);
        if (returnStr.length() > 7) {
            returnStr = returnStr.substring(0, 4) + "-" + returnStr.substring(4, 6) + "-" + returnStr.substring(6, 8);
        }
        return returnStr;
    }

    public static String ReturnIntComma(String num) {
        DecimalFormat df = new DecimalFormat("#,###");
        if (num.equals("")) {
            return "";
        } else {
            return df.format(Integer.parseInt(num));
        }
    }

    public static Map<String, Object> CloudParamCheck(Map<String, Object> param) {
        try {
            if (!param.containsKey(commonCode.groupSeq)) {
                param.put(commonCode.groupSeq, CommonGetStr(CommonGetEmpVO().getGroupSeq()));
            } else {
                if (CommonGetStr(param.get(commonCode.groupSeq)).equals("")) {
                    param.put(commonCode.groupSeq, CommonGetStr(CommonGetEmpVO().getGroupSeq()));
                }
            }
        } catch (Exception e) {
            // TODO: handle exception
            param.put(commonCode.groupSeq, "");
        }
        return param;
    }

    public static Map<String, Object> ConToMap(ConnectionVO2 conVo) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("erpCompName", CommonConvert.CommonGetStr(conVo.getErpCompName()));
        map.put("erpCompSeq", CommonConvert.CommonGetStr(conVo.getErpCompSeq()));
        map.put("erpTypeCode", CommonConvert.CommonGetStr(conVo.getErpTypeCode()));
        map.put("g20YN", CommonConvert.CommonGetStr(conVo.getG20YN()));

        return map;
    }

    public static String GetToday() {
        Calendar day = Calendar.getInstance();
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        return df.format(day.getTime());
    }

    public static void Append(StringBuilder sb, String appender) {
        sb.append(appender + System.getProperty("line.separator"));
    }

}
