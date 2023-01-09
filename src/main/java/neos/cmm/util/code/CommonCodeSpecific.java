package neos.cmm.util.code;

import java.util.List;
import java.util.Map;

import egovframework.com.utl.fcc.service.EgovStringUtil;

public class CommonCodeSpecific {
    
    /**
     * 메신저 도메인을 반환한다.
     * 
     * @return
     */
    public static String getMessengerURL() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "URL");
        } catch (Exception ignore) {
        }
        return result;
    }
    /**
     * 메신저 에 sms 연동여부를 확인한다.
     * 
     * @return
     */
    public static String getMessengerSMSYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "SMS");
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 메신저에 휴직자 포함여부
     * 
     * @return
     */
    public static String getMessengerUserRetireYN() {
        String result = "Y";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "RETIRE");
            if(EgovStringUtil.isEmpty(result)) {
                result = "Y";
            }
        } catch (Exception ignore) {
            result = "Y";
        }
        return result;
    }
    /**
     * 열람지정시 메신저 쪽지로 알림이 가게하는 기능
     * Y : 기능 동작
     * N : 기능 정지
     * 
     * @return
     */
    public static String getReadingMessengerYN() {
        String result = "Y";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "READINGLINK");
            if(EgovStringUtil.isEmpty(result)) {
                result = "Y";
            }
        } catch (Exception ignore) {
            result = "Y";
        }
        return result;
    }
    /**
     * 메신저file size;
     * 
     * @return
     */
    public static String getMessengerFileSize() {
        String result = "50";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "FILE_SIZE");
            if(EgovStringUtil.isEmpty(result)) {
                result = "50";
            }
        } catch (Exception ignore) {
            result = "50";
        }
        return result;
    }
    /**
     * 메신저대화하기기능 사용여부 1: 사용  0: 미사용;
     * 
     * 
     * @return
     */
    public static String getMessengerTolkyn() {
        String result = "1";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "TOLK_YN");
            if(EgovStringUtil.isEmpty(result)) {
                result = "1";
            }
        } catch (Exception ignore) {
            result = "1";
        }
        return result;
    }
    /**
     * 메신저와SMS 연동시 URL 을 반환한다..
     * 
     * @return
     */
    public static String getMessengerSMSURL() {
        String result = "/neos/sms/smsSendForm.do";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "SMS_URL");
            if (EgovStringUtil.isEmpty(result)) {
                result = "/neos/sms/smsSendForm.do";
            }
        } catch (Exception ignore) {
            result = "/neos/sms/smsSendForm.do";
        }
        return result;
    }

    /**
     * 메신저 알람주소를 반환한다.
     * 
     * @return
     */
    public static String getMessengerAalram() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "ALRAM");
        } catch (Exception ignore) {
        }
        return result;
    }

    /**
     * 감사 종류를 반환한다.
     * 
     * @return
     */
    public static List<Map<String, String>> getApprovalLineButtonList() {
        List<Map<String, String>> list = null;
        try {
            list = CommonCodeUtil.getCodeList("AUDIT");
        } catch (Exception ignore) {
        }
        return list;
    }

    /**
     * 모바일 도메인 주소를 반환한다.
     * 
     * @return
     */
    public static String getMobileDomain() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("MOBILE", "URL");
        } catch (Exception ignore) {
        }
        return result;
    }

    public static boolean isMobileDomain(String url) {
        boolean result = false;
        String dbUrl = "";
        try {
            List<Map<String, String>> list = CommonCodeUtil
                    .getCodeList("MOBILE");
            Map<String, String> codeMap = null;
            int rowNum = 0;
            if (list != null) {
                rowNum = list.size();
            }

            for (int inx = 0; inx < rowNum; inx++) {
                codeMap = list.get(inx);
                dbUrl = codeMap.get("CODE_NM");

                if (url.contains(dbUrl)) {
                    result = true;
                    break;
                }
            }
        } catch (Exception ignore) {

        }
        return result;
    }
    // 모바일 앱 사용여부
    public static String getMobileApp() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("MB_APP", "APP");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    

    // 접수문서 결재 여부
    public static String getReceiveApproval() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("RCV001", "RCVAPV");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }

    // 비전자 문서 결재 여부
    public static String getNonElecReceiveApproval() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("RCV001", "NONDOCAPV");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }

    // 문서제목수정가능여부
//    public static String getDocNameEdit() {
//        String result = "N";
//        try {
//            result = CommonCodeUtil.getCodeName("DOC003", "D_SUBJ");
//            if (EgovStringUtil.isEmpty(result)) {
//                result = "N";
//            }
//        } catch (Exception ignore) {
//            result = "N";
//        }
//        return result;
//    }

    // 결재시 쪽지 전송여부
    public static String getApprovalNote() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("PUSHMG", "NOTE");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }

    // 전체문서 보기 가능..
    public static boolean isApprovalDocView(List<String> authorList) {
        String codeID = "";
        String authorID = "";
        String codeNm = "";
        try {
            List<Map<String, String>> list = CommonCodeUtil.getCodeList("DOC_VW");
            Map<String, String> codeMap = null;
            int authorRowNum = 0;
            int rowNum = 0;

            if (authorList != null) {
                authorRowNum = authorList.size();
            }

            if (list != null) {
                rowNum = list.size();
            }
            for (int authorInx = 0; authorInx < authorRowNum; authorInx++) {
                authorID = authorList.get(authorInx);

                for (int inx = 0; inx < rowNum; inx++) {
                    codeMap = list.get(inx);
                    if (codeMap == null)
                        continue;

                    codeID = codeMap.get("CODE");
                    codeNm = codeMap.get("CODE_NM");
                    if (codeID.equals(authorID)) {
                        return true;
                    }

                }
            }

        } catch (Exception ignore) {

        }
        return false;
    }
    
    /**
     * 보안제외 전체문서보기 권한리스트
     */
    public static boolean isApprovalDocViewExtScty(List<String> authorList) {
        String codeID = "";
        String authorID = "";
        String codeNm = "";
        try {
            List<Map<String, String>> list = CommonCodeUtil.getCodeList("DOC_VW_EXTSCTY");
            Map<String, String> codeMap = null;
            int authorRowNum = 0;
            int rowNum = 0;

            if (authorList != null) {
                authorRowNum = authorList.size();
            }

            if (list != null) {
                rowNum = list.size();
            }
            for (int authorInx = 0; authorInx < authorRowNum; authorInx++) {
                authorID = authorList.get(authorInx);

                for (int inx = 0; inx < rowNum; inx++) {
                    codeMap = list.get(inx);
                    if (codeMap == null)
                        continue;

                    codeID = codeMap.get("CODE");
                    codeNm = codeMap.get("CODE_NM");
                    if (codeID.equals(authorID)) {
                        return true;
                    }

                }
            }

        } catch (Exception ignore) {

        }
        return false;
    }    
    
    
    // 전체문서 보기 가능..
    public static boolean isG20ErpAuth(List<String> authorList) {
        String codeID = "";
        String authorID = "";
        String codeNm = "";
        try {
            List<Map<String, String>> list = CommonCodeUtil.getCodeList("G20DEL");
            Map<String, String> codeMap = null;
            int authorRowNum = 0;
            int rowNum = 0;

            if (authorList != null) {
                authorRowNum = authorList.size();
            }

            if (list != null) {
                rowNum = list.size();
            }
            for (int authorInx = 0; authorInx < authorRowNum; authorInx++) {
                authorID = authorList.get(authorInx);

                for (int inx = 0; inx < rowNum; inx++) {
                    codeMap = list.get(inx);
                    if (codeMap == null)
                        continue;

                    codeID = codeMap.get("CODE");
                    codeNm = codeMap.get("CODE_NM");
                    if (codeID.equals(authorID)) {
                        return true;
                    }

                }
            }

        } catch (Exception ignore) {

        }
        return false;
    }   

    public static  String getUseCodeYN(String code_id, String code) {
        String result = "N" ;
        try {
            result = CommonCodeUtil.getCodeName(code_id, code);
            if ( EgovStringUtil.isEmpty(result) ) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result ; 
    }
    /**
     * 결재라인 정보에서 사용자 프로필 조회시 ID 노출여부
     * 
     * @return
     */
    public static String getProfileId() {
        String result = "Y";
        try {
            result = CommonCodeUtil.getCodeName("APPRV", "PROFILEID");
            if (EgovStringUtil.isEmpty(result)) {
                result = "Y";
            }
        } catch (Exception ignore) {
            result = "Y";
        }
        return result;
    }
    /**
     * 메모보고 에디터
     * 
     * @return
     */
    public static String getMemoReportEditorHwp() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("MEMRP", "MRHWP");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 인수/인계권한여부
     * 
     * @return
     */
    public static boolean isChargeAuth(List<String> authorList) {
        String codeID = "";
        String authorID = "";
        String codeNm = "";
        try {
            List<Map<String, String>> list = CommonCodeUtil.getCodeList("AUTH01");
            Map<String, String> codeMap = null;
            int authorRowNum = 0;
            int rowNum = 0;

            if (authorList != null) {
                authorRowNum = authorList.size();
            }

            if (list != null) {
                rowNum = list.size();
            }
            for (int authorInx = 0; authorInx < authorRowNum; authorInx++) {
                authorID = authorList.get(authorInx);

                for (int inx = 0; inx < rowNum; inx++) {
                    codeMap = list.get(inx);
                    if (codeMap == null)
                        continue;

                    codeID = codeMap.get("CODE");
                    codeNm = codeMap.get("CODE_NM");
                    if (codeID.equals(authorID)) {
                        return true;
                    }

                }
            }

        } catch (Exception ignore) {

        }
        return false;
    }

    /**
     * 그룹웨어리스트 WSDL URL
     * 
     * @return
     */
    public static String getGrpWSDLURL() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("GRPLST", "WSDLURL");
            if (EgovStringUtil.isEmpty(result)) {
                result = "";
            }
        } catch (Exception ignore) {
            result = "";
        }
        return result;
    }

    /**
     * 그룹웨어리스트 그룹ID
     * 
     * @return
     */
    public static String getGrpID() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("GRPLST", "GRPID");
            if (EgovStringUtil.isEmpty(result)) {
                result = "";
            }
        } catch (Exception ignore) {
            result = "";
        }
        return result;
    }

    /**
     * 그룹웨어리스트 그룹코드
     * 
     * @return
     */
    public static String getGrpCD() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("GRPLST", "GRPCD");
            if (EgovStringUtil.isEmpty(result)) {
                result = "";
            }
        } catch (Exception ignore) {
            result = "";
        }
        return result;
    }

    /**
     * 그룹웨어리스트 그룹비밀번호
     * 
     * @return
     */
    public static String getGrpPW() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("GRPLST", "GRPPW");
            if (EgovStringUtil.isEmpty(result)) {
                result = "";
            }
        } catch (Exception ignore) {
            result = "";
        }
        return result;
    }
    /**
     * 결재라인 정렬순서
     * 
     * @return
     */
    public static String getApprovalLineSort() {
        String result = "ASC";
        try {
            result = CommonCodeUtil.getCodeName("APL", "100");
            if (EgovStringUtil.isEmpty(result)) {
                result = "ASC";
            }
        } catch (Exception ignore) {
            result = "ASC";
        }
        return result;
    }
    
    /**
     * 타사메일 SSO URL
     * 
     * @return
     */
    public static String getMailVendor() {
        String result = "MAILPLUG";
        try {
            result = CommonCodeUtil.getCodeName("MAIL", "VENDOR");
            if (EgovStringUtil.isEmpty(result)) {
                result = "MAILPLUG";
            }
        } catch (Exception ignore) {
            result = "MAILPLUG";
        }
        return result;
    }
    
    /**
     * 구문서함에서 자신이 기안한 문서만 보도록 한다.
     * 
     * @return
     */
    public static String getDiuserKey() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("OLDDOC", "DIUSERKEY");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    
    /**
     * 그룹웨어 연동파라미터 변환IU_KEY
     * 
     * @return
     */
    public static String getIuKeyParam() {
        String result = "IU_KEY";
        try {
            result = CommonCodeUtil.getCodeName("LNK004", "IU_KEY");
            if (EgovStringUtil.isEmpty(result)) {
                result = "IU_KEY";
            }
        } catch (Exception ignore) {
            result = "IU_KEY";
        }
        return result;
    }
    /**
     * 그룹웨어 연동파라미터 변환ID
     * 
     * @return
     */
    public static String getIDParam() {
        String result = "id";
        try {
            result = CommonCodeUtil.getCodeName("LNK004", "id");
            if (EgovStringUtil.isEmpty(result)) {
                result = "id";
            }
        } catch (Exception ignore) {
            result = "id";
        }
        return result;
    }
    /**
     * 그룹웨어 연동파라미터 변환formId
     * 
     * @return
     */
    public static String getFormIDParam() {
        String result = "form_id";
        try {
            result = CommonCodeUtil.getCodeName("LNK004", "form_id");
            if (EgovStringUtil.isEmpty(result)) {
                result = "form_id";
            }
        } catch (Exception ignore) {
            result = "form_id";
        }
        return result;
    }
    /**
     * 그룹웨어 연동파라미터 변환 erpNo
     * 
     * @return
     */
    public static String getErpNoParam() {
        String result = "erp_no";
        try {
            result = CommonCodeUtil.getCodeName("LNK004", "erp_no");
            if (EgovStringUtil.isEmpty(result)) {
                result = "erp_no";
            }
        } catch (Exception ignore) {
            result = "erp_no";
        }
        return result;
    }
    /**
     * 그룹웨어 연동파라미터 변환 erpNo
     * 
     * @return
     */
    public static String getTemplateKeyParam() {
        String result = "template_key";
        try {
            result = CommonCodeUtil.getCodeName("LNK004", "template_key");
            if (EgovStringUtil.isEmpty(result)) {
                result = "template_key";
            }
        } catch (Exception ignore) {
            result = "template_key";
        }
        return result;
    }

    /**
     * BlueSearch에서 MAIL 검색 여부
     * 
     * @return
     */
    public static String getMailSearch() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("MAIL", "SEARCH");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    
    /**
     * 의견등록시 메신저 연동여부.
     * 
     * @return
     */
    public static String getMSNOpinionYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "OPINION");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 문서 수정시 메신저 연동여부.
     * 
     * @return
     */
    public static String getMSNDocEditYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("MSN", "DOCEDIT");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * IU 연동 옵션값을 가져온다 
     * 
     * @return
     */
    public static String getIUOption(String code) {
        String result = "1";
        try {
            result = CommonCodeUtil.getCodeName("IU_OPT", code);
            if (EgovStringUtil.isEmpty(result)) {
                result = "1";
            }
        } catch (Exception ignore) {
            result = "1";
        }
        return result;
    }
    /**
     * pdf 파일 이미지 변환여부. 
     * 
     * @return
     */
//    public static String getPdfImageConvetYN() {
//        String result = "Y";
//        try {
//            result = CommonCodeUtil.getCodeName("PDF", "IMAGE");
//            if (EgovStringUtil.isEmpty(result)) {
//                result = "Y";
//            }
//        } catch (Exception ignore) {
//            result = "Y";
//        }
//        return result;
//    }
    /**
     * 양식에 입력되는 주소 부서, 개인 주소 여부 확인
     * 
     * @return
     */
//    public static String getAddressEMPYN() {
//        String result = "N";
//        try {
//            result = CommonCodeUtil.getCodeName("DOC003", "D_EMPADDR");
//            if (EgovStringUtil.isEmpty(result)) {
//                result = "N";
//            }
//        } catch (Exception ignore) {
//            result = "N";
//        }
//        return result;
//    }
    /**
     * 증명서신청 부서, 개인 주소 여부 확인
     * 
     * @return
     */
    public static String getEssAddressEMPYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("DOC003", "D_ESSEMPADDR");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    
    /**
     * sms 연동여부
     * 
     * @return
     */
    public static String getSmsYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("LINKYN", "SMSYN");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    
    /**
     * 연동종류
     * 
     * @return
     */
    public static String getLNK(String code) {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("LNK", code);
            if (EgovStringUtil.isEmpty(result)) {
                result = "";
            }
        } catch (Exception ignore) {
            result = "";
        }
        return result;
    }   
    /**
     * 메일종류 
     * 
     * @return
     */
    public static String getEmailKind()  {
        String result = "DUZON";
        try {
            result = CommonCodeUtil.getCodeName("EMAIL", "KIND");
            if (EgovStringUtil.isEmpty(result)) {
                result = "DUZON";
            }
        } catch (Exception ignore) {
            result = "DUZON";
        }
        return result;
    }
    /**
     * https 지원여부
     * 
     * @return
     */
    public static String getHttpsYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("HP001", "HTTPS");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * https port
     * 
     * @return
     */
    public static String getHttpsPort() {
        String result = "443";
        try {
            result = CommonCodeUtil.getCodeName("HP001", "HTTPS_PORT");
            if (EgovStringUtil.isEmpty(result)) {
                result = "443";
            }
        } catch (Exception ignore) {
            result = "443";
        }
        return result;
    }
    /**
     * http port
     * 
     * @return
     */
    public static String getHttpPort() {
        String result = "80";
        try {
            result = CommonCodeUtil.getCodeName("HP001", "HTTP_PORT");
            if (EgovStringUtil.isEmpty(result)) {
                result = "80";
            }
        } catch (Exception ignore) {
            result = "80";
        }
        return result;
    }
    /**
     * 근태 엑셀파일 출력시 엑셀파일 암호화 여부
     * 
     * @return
     */
    public static String getWorkExcelYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("XLSPWD", "WORK_XLS");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    
    public static String getSendCode() {
        String result = "";
        try {
            result = CommonCodeUtil.getCodeName("APPROVAL", "SENDCODE");
            if (EgovStringUtil.isEmpty(result)) {
                result = "";
            }
        } catch (Exception ignore) {
            result = "";
        }
        return result;  
    }
    /**
     * G20연동 자기가 속한 부서원의 참조품의 불러오기 
     * 
     * @return
     */
    public static String getG20viewD() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("G20VIEW", "G20VIEWD");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 협조 반려여부
     * 
     * @return
     */
    public static String getCooperationRtnYN() {
        String result = "Y";
        try {
            result = CommonCodeUtil.getCodeName("APPRV", "CPRRTN");
            if (EgovStringUtil.isEmpty(result)) {
                result = "Y";
            }
        } catch (Exception ignore) {
            result = "Y";
        }
        return result;
    }
    /**
     * 양식에 의견있음 표시여부.
     * 
     * @return
     */
//    public static String getDocOpinionYN() {
//        String result = "N";
//        try {
//            result = CommonCodeUtil.getCodeName("APPRV", "DOCOPN");
//            if (EgovStringUtil.isEmpty(result)) {
//                result = "N";
//            }
//        } catch (Exception ignore) {
//            result = "N";
//        }
//        return result;
//    }

    /**
     * 인천항만공사만 이메일 사용자저장시 도메인 변경 url 중 /mail 부분 생략
     * 
     * @return
     */
    public static String getMailSaveUrl() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("EMAIL", "USER_SAVE");
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 시간외수당EXCEL FILE 다운로드 주소.
     * 
     * @return
     */
    public static String getOverTimeExcelURI() {
        String result = "/worktime/overTimeStatusDocExcel.do";
        try {
            result = CommonCodeUtil.getCodeName("DOC003", "OVT_EXCELURI");
            if (EgovStringUtil.isEmpty(result)) {
                result = "/worktime/overTimeStatusDocExcel.do";
            }
        } catch (Exception ignore) {
            result = "/worktime/overTimeStatusDocExcel.do";
        }
        return result;
    }
    
    public static String getMailUserDeleteNewYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("EMAIL", "USER_DELETE_NEW");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    public static String getPayPwdYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("PAY001", "PWD");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    public static String getDefaultReceiveApprvalYN() {
        String result = " Y";
        try {
            result = CommonCodeUtil.getCodeName("DOC003", "R_APPRV");
            if (EgovStringUtil.isEmpty(result)) {
                result = "Y";
            }
        } catch (Exception ignore) {
            result = "Y";
        }
        return result;
    }
    /**
     * 발송대기함 대내만 사용할지
     * 
     * @return
     */
    public static String getInnerYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("INNER", "YN");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 대외문서시 파일체크여부
     * 
     * @return
     */
    public static String getOutFileLimitYN() {
        String result = "N";
        try {
            result = CommonCodeUtil.getCodeName("DOC003", "OUT_FILELIMITYN");
            if (EgovStringUtil.isEmpty(result)) {
                result = "N";
            }
        } catch (Exception ignore) {
            result = "N";
        }
        return result;
    }
    /**
     * 더존메일 사용하는 고객사에 한하여 전자우편 대메뉴를 클릭 했을 때 팝업창으로 띄어 줄지 여부
     * 
     * @return
     */
        public static String getDuzonMailPopupOpenYN() {
            String result = "N";
            try {
                result = CommonCodeUtil.getCodeName("EMAIL", "DUZONMAIL_POPUP");
                if (EgovStringUtil.isEmpty(result)) {
                    result = "N";
                }
            } catch (Exception ignore) {
                result = "N";
            }
            return result;
        }   
    /**
     * 메신저 대화창에서 파일을 주고받는 것을 컨트롤함 0: 제한  1 : 허용
     * @return
     */
        public static String getFileTrans() {
            String result = "1";
            try {
                result = CommonCodeUtil.getCodeName("MSN", "FILETRANS");
                if (EgovStringUtil.isEmpty(result)) {
                    result = "1";
                }
            } catch (Exception ignore) {
                result = "1";
            }
            return result;
        }
    /**
     * 메신저 메일카운트 노출을 컨트롤함 1: SHOW  0 : HIDE
     * @return
     */
        public static String getMessengerMailCount() {
                String result = "1";
                try {
                    result = CommonCodeUtil.getCodeName("MSN", "MAILCOUNT");
                    if (EgovStringUtil.isEmpty(result)) {
                        result = "1";
                    }
                } catch (Exception ignore) {
                    result = "1";
                }
                return result;
        }
    /**
     * 메신저 결재카운트 노출을 컨트롤함 1: SHOW  0 : HIDE
     * @return
     */
        public static String getMessengerApprovalCount() {
                    String result = "1";
                    try {
                        result = CommonCodeUtil.getCodeName("MSN", "APPROVALCOUNT");
                        if (EgovStringUtil.isEmpty(result)) {
                            result = "1";
                        }
                    } catch (Exception ignore) {
                        result = "1";
                    }
                    return result;
        }
    /**
     * 메신저 직위 직급 표시 여부 null : 정상  CLASS : 강제로 직위표시  POSITION : 직금
     * @return
     */
        public static String getShowClass() {
                    String result = "REGULAR";
                    try {
                        result = CommonCodeUtil.getCodeName("MSN", "SHOWCLASS");
                        if (EgovStringUtil.isEmpty(result)) {
                            result = "REGULAR";
                        }
                    } catch (Exception ignore) {
                        result = "REGULAR";
                    }
                    return result;
        }
        /**
         * 메세지 파일첨부사이즈 제어 기본 : 0(무제한) , 제한 : 제한범위입력 MB단위
         * @return
         */
            public static String getMessagefilesize() {
                        String result = "0";
                        try {
                            result = CommonCodeUtil.getCodeName("MSN", "MFILE_SIZE");
                            if (EgovStringUtil.isEmpty(result)) {
                                result = "0";
                            }
                        } catch (Exception ignore) {
                            result = "0";
                        }
                        return result;
            }
                
    /**
     *  장애인개발원 사용여부
     */
        public static String getKoddiUseYn() {
            String result = "";
            try {
                result = CommonCodeUtil.getCodeName("KD_YN", "USEYN");
                //result = CommonCodeUtil.getCodeName("KD_YN1", "USEYN");
                //System.out.println("result = ["+result+"]");
            } catch (Exception e) {}
            return result;
        }
    
    /**
     *  메신저 쪽지에서 파일 전송 컨트롤 클라이언트 구버전  0 : 허용   1 : 불허
     *                      클라이언트  신버전 0 : 불허   1 : 허용
     */
        public static String getCheckAttSizeYN() {
            String result = "0";
            try {
                result = CommonCodeUtil.getCodeName("MSN", "ATTSIZE");
                if (EgovStringUtil.isEmpty(result)) {
                    result = "0";
                }
            } catch (Exception ignore) {
                result = "0";
            }
            return result;
        }
    
    /**
     *  해당고객사의 허용된(계약된) 유저수(겸직은 포함X)
     *  0: 무제한모드
     *  0 보다클때 해당 숫자로 제어모드(사용자저장 불가)
     */
     public static String getpermissionUser() {
         String result = "0";
         try {
             result = CommonCodeUtil.getCodeName("GWINFO", "USER");
             if (EgovStringUtil.isEmpty(result)) {
                        result = "0";
             }
         } catch (Exception ignore) {
                    result = "0";
         }
         return result;
     }
     
     /**
         *  필수 기본항목의 공개여부에서 비공개를 선택시 비공개 사유를 입력하는 란을 안보이도록 할 수 있는 옵션
         */
         public static String getClosedYN() {
             String result = "Y";
             try {
                 result = CommonCodeUtil.getCodeName("DOC001", "PUBLICCAUSE");
                 if (EgovStringUtil.isEmpty(result)) {
                            result = "Y";
                 }
             } catch (Exception ignore) {
                        result = "Y";
             }
             return result;
         }
    
        
}
