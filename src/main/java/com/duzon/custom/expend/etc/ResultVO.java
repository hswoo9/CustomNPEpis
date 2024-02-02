package com.duzon.custom.expend.etc;

import bizbox.orgchart.service.vo.LoginVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.duzon.custom.expend.etc.CommonInterface.commonCode;
public class ResultVO {
    private String	resultCode		= commonCode.emptyStr;
    private String	resultName		= commonCode.emptyStr;
    private String	errorCode		= commonCode.emptyStr;
    private String	errorTrace		= commonCode.emptyStr;
    private String	id				= commonCode.emptyStr;
    private String	groupSeq		= commonCode.emptyStr;	/* 그룹 시퀀스 - Bizbox Alpha */
    private String	compSeq			= commonCode.emptyStr;	/* 회사 시퀀스 - Bizbox Alpha */
    private String	erpCompSeq		= commonCode.emptyStr;	/* 회사 시퀀스 - ERP 기준 */
    private String	bizSeq			= commonCode.emptyStr;	/* 사업장 시퀀스 - Bizbox Alpha */
    private String	erpBizSeq		= commonCode.emptyStr;	/* 사업장 시퀀스 - ERP 기준 */
    private String	deptSeq			= commonCode.emptyStr;	/* 부서 시퀀스 - Bizbox Alpha */
    private String	erpDeptSeq		= commonCode.emptySeq;	/* 부서 시퀀스 - ERP 기준 */
    private String	empSeq			= commonCode.emptyStr;	/* 사원 시퀀스 - Bizbox Alpha */
    private String	empName			= commonCode.emptyStr;	/* 사용자 이름 */
    private String	erpEmpSeq		= commonCode.emptyStr;	/* 사원 시퀀스 - ERP 기준 */
    private String	langCode		= commonCode.emptyStr;	/* 사옹언어 코드 - Bizbox Alpha */
    private String	userSe			= commonCode.emptyStr;	/* 사용자 권한 구분 - Bizbox Alpha */
    private String	expendSeq		= commonCode.emptySeq;
    private String	expendListSeq	= commonCode.emptySeq;
    private String	expendSlipSeq	= commonCode.emptySeq;
    private String	expendMngSeq	= commonCode.emptySeq;
    private String 	count			= commonCode.emptySeq;

    /* 전자결재 연동 사용 */
    private String	eaType				= commonCode.emptyStr;	/* 전자결재 타입 */
    private String	docSeq				= commonCode.emptySeq;	/* 전자결재 아이디 */
    private String	formSeq				= commonCode.emptySeq;	/* 양식 아이디 */
    private String	approKey			= commonCode.emptyStr;	/* 외부연동 키값 */
    private String	preUrl				= commonCode.emptyStr;	/* 도메인 정보 */
    private String	processId			= commonCode.emptyStr;	/* 외부연동 아이디 값 */
    private String	docTitle			= commonCode.emptyStr;	/* 전자결재 제목 */
    private String	docContent			= commonCode.emptyStr;	/* 전자결재 본문 HTML */
    private String	interlockUrl		= commonCode.emptyStr;	/* 전자결재 이전단계 URL */
    private String	interlockName		= commonCode.emptyStr;	/* 전자결재 이전단계 버튼명칭 */
    private String	selectSql			= commonCode.emptyStr;	/* 비영리 한글 코드 쿼리 */
    private String	reDraftUrl			= commonCode.emptyStr;	/* 전자결재(비영리) 재기안 호출 URL */
    private String	oriApproKey			= commonCode.emptyStr;	/* 원문서 외부시스템 연동키 */
    private String	oriDocId			= commonCode.emptyStr;	/* 원문서 전자결재 아이디 */
    private String	formGb				= commonCode.emptyStr;	/* 양식 타입 (hwp : 0 / html : 1) */
    private String	copyApprovalLine	= commonCode.emptyStr;	/* 결재라인 포함여부(포함 : Y / 미포함 : N) */
    private String	copyAttachFile		= commonCode.emptyStr;	/* cjaqnvkdlf 포함여부(포함 : Y / 미포함 : N) */

    private Map<String, Object> header	= new HashMap<String, Object>();		/* 전자결재 본문 헤더 정보 */
    private List<Map<String, Object>> content	= new ArrayList<Map<String, Object>>();	/* 전자결재 본문 콘텐츠 정보 */
    private Map<String, Object>			footer	= new HashMap<String, Object>();		/* 전자결재 본문 푸터 정보 */
    /* 호출과 반환 변수 */
    private Map<String, Object>			params	= new HashMap<String, Object>();
    private List<Map<String, Object>>	aaData	= new ArrayList<Map<String, Object>>();
    private Map<String, Object>			aData	= new HashMap<String, Object>();
    /* 사용자 IP 정보 */
    private String	ipAddress	= commonCode.emptyStr;	/* 접근사용자 IP 정보 */
    private String	refDocList	= commonCode.emptyStr;	/* 참조문서 리스트 */

    /**
     * interlockName 영문
     *
     * @since 20180910
     */
    private String	interlockNameEn	= commonCode.interlockNameEn;
    /**
     * interlockName 일본어
     *
     * @since 20180910
     */
    private String	interlockNameJp	= commonCode.interlockNameJp;
    /**
     * interlockName 중국어
     *
     * @since 20180910
     */
    private String	interlockNameCn	= commonCode.interlockNameCn;

    public String getRefDocList() {
        return CommonConvert.CommonGetStr(refDocList);
    }

    public void setRefDocList(String refDocList) {
        this.refDocList = refDocList;
    }

    public ResultVO() {
    }

    public ResultVO(Map<String, Object> p) {
        this.setProcessId((p.containsKey("processId") ? CommonConvert.CommonGetStr(p.get("processId")) : ""));
        this.setApproKey((p.containsKey("approKey") ? CommonConvert.CommonGetStr(p.get("approKey")) : ""));
        this.setDocTitle((p.containsKey("docTitle") ? CommonConvert.CommonGetStr(p.get("docTitle")) : ""));
        this.setInterlockUrl((p.containsKey("interlockUrl") ? CommonConvert.CommonGetStr(p.get("interlockUrl")) : ""));
        this.setInterlockName((p.containsKey("interlockName") ? CommonConvert.CommonGetStr(p.get("interlockName")) : ""));
        this.setInterlockNameEn((p.containsKey(commonCode.interlockNameEn) ? CommonConvert.CommonGetStr(p.get(commonCode.interlockNameEn)) : "")); // 20180910 soyoung, interlockName 이전단계 영문/일문/중문 추가
        this.setInterlockNameJp((p.containsKey(commonCode.interlockNameJp) ? CommonConvert.CommonGetStr(p.get(commonCode.interlockNameJp)) : "")); // 20180910 soyoung, interlockName 이전단계 영문/일문/중문 추가
        this.setInterlockNameCn((p.containsKey(commonCode.interlockNameCn) ? CommonConvert.CommonGetStr(p.get(commonCode.interlockNameCn)) : "")); // 20180910 soyoung, interlockName 이전단계 영문/일문/중문 추가
        this.setDocSeq((p.containsKey("docSeq") ? CommonConvert.CommonGetStr(p.get("docSeq")) : ""));
        this.setFormSeq((p.containsKey("formSeq") ? CommonConvert.CommonGetStr(p.get("formSeq")) : ""));
        this.setDocContent((p.containsKey("docContents") ? CommonConvert.CommonGetStr(p.get("docContents")) : ""));
        this.setPreUrl((p.containsKey("preUrl") ? CommonConvert.CommonGetStr(p.get("preUrl")) : ""));
        try {
            this.setGroupSeq(CommonConvert.CommonGetStr(CommonConvert.CommonGetEmpVO().getGroupSeq()));
        }
        catch (NotFoundLoginSessionException e) {
            e.printStackTrace();
        }
    }

    public String getResultCode() {
        return CommonConvert.CommonGetStr(resultCode);
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public String getResultName() {
        return CommonConvert.CommonGetStr(resultName);
    }

    public void setResultName(String resultName) {
        this.resultName = resultName;
    }

    public String getId() {
        return CommonConvert.CommonGetStr(id);
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGroupSeq() {
        return CommonConvert.CommonGetStr(groupSeq);
    }

    public void setGroupSeq(String groupSeq) {
        this.groupSeq = groupSeq;
    }

    public String getCompSeq() {
        return CommonConvert.CommonGetStr(compSeq);
    }

    public void setCompSeq(String compSeq) {
        this.compSeq = compSeq;
    }

    public String getErpCompSeq() {
        return CommonConvert.CommonGetStr(erpCompSeq);
    }

    public void setErpCompSeq(String erpCompSeq) {
        this.erpCompSeq = erpCompSeq;
    }

    public String getBizSeq() {
        return CommonConvert.CommonGetStr(bizSeq);
    }

    public void setBizSeq(String bizSeq) {
        this.bizSeq = bizSeq;
    }

    public String getErpBizSeq() {
        return CommonConvert.CommonGetStr(erpBizSeq);
    }

    public void setErpBizSeq(String erpBizSeq) {
        this.erpBizSeq = erpBizSeq;
    }

    public String getDeptSeq() {
        return CommonConvert.CommonGetStr(deptSeq);
    }

    public void setDeptSeq(String deptSeq) {
        this.deptSeq = deptSeq;
    }

    public String getErpDeptSeq() {
        return CommonConvert.CommonGetStr(erpDeptSeq);
    }

    public void setErpDeptSeq(String erpDeptSeq) {
        this.erpDeptSeq = erpDeptSeq;
    }

    public String getEmpSeq() {
        return CommonConvert.CommonGetStr(empSeq);
    }

    public void setEmpSeq(String empSeq) {
        this.empSeq = empSeq;
    }

    public String getEmpName() {
        return CommonConvert.CommonGetStr(empName);
    }

    public void setEmpName(String empName) {
        this.empName = empName;
    }

    public String getErpEmpSeq() {
        return CommonConvert.CommonGetStr(erpEmpSeq);
    }

    public void setErpEmpSeq(String erpEmpSeq) {
        this.erpEmpSeq = erpEmpSeq;
    }

    public String getLangCode() {
        return CommonConvert.CommonGetStr(langCode);
    }

    public void setLangCode(String langCode) {
        this.langCode = langCode;
    }

    public String getUserSe() {
        return CommonConvert.CommonGetStr(userSe);
    }

    public void setUserSe(String userSe) {
        this.userSe = userSe;
    }

    public String getExpendSeq() {
        return CommonConvert.CommonGetStr(expendSeq);
    }

    public void setExpendSeq(String expendSeq) {
        this.expendSeq = expendSeq;
    }

    public String getExpendListSeq() {
        return CommonConvert.CommonGetStr(expendListSeq);
    }

    public void setExpendListSeq(String expendListSeq) {
        this.expendListSeq = expendListSeq;
    }

    public String getExpendSlipSeq() {
        return CommonConvert.CommonGetStr(expendSlipSeq);
    }

    public void setExpendSlipSeq(String expendSlipSeq) {
        this.expendSlipSeq = expendSlipSeq;
    }

    public String getExpendMngSeq() {
        return CommonConvert.CommonGetStr(expendMngSeq);
    }

    public void setExpendMngSeq(String expendMngSeq) {
        this.expendMngSeq = expendMngSeq;
    }

    public String getEaType() {
        return CommonConvert.CommonGetStr(eaType);
    }

    public void setEaType(String eaType) {
        this.eaType = eaType;
    }

    public String getDocSeq() {
        return CommonConvert.CommonGetStr(docSeq);
    }

    public void setDocSeq(String docSeq) {
        this.docSeq = docSeq;
    }

    public String getFormSeq() {
        return CommonConvert.CommonGetStr(formSeq);
    }

    public void setFormSeq(String formSeq) {
        this.formSeq = formSeq;
    }

    public String getApproKey() {
        return CommonConvert.CommonGetStr(approKey);
    }

    public void setApproKey(String approKey) {
        this.approKey = approKey;
    }

    public String getPreUrl() {
        return CommonConvert.CommonGetStr(preUrl);
    }

    public void setPreUrl(String preUrl) {
        this.preUrl = preUrl;
    }

    public String getProcessId() {
        return CommonConvert.CommonGetStr(processId);
    }

    public void setProcessId(String processId) {
        this.processId = processId;
    }

    public String getDocTitle() {
        return CommonConvert.CommonGetStr(docTitle);
    }

    public void setDocTitle(String docTitle) {
        this.docTitle = docTitle;
    }

    public String getDocContent() {
        return CommonConvert.CommonGetStr(docContent);
    }

    public void setDocContent(String docContent) {
        this.docContent = docContent;
    }

    public String getInterlockUrl() {
        return CommonConvert.CommonGetStr(interlockUrl);
    }

    public void setInterlockUrl(String interlockUrl) {
        this.interlockUrl = interlockUrl;
    }

    public String getInterlockName() {
        return CommonConvert.CommonGetStr(interlockName);
    }

    public void setInterlockName(String interlockName) {
        this.interlockName = interlockName;
    }

    public String getInterlockNameEn() {
        return CommonConvert.CommonGetStr(interlockNameEn);
    }

    public void setInterlockNameEn(String interlockNameEn) {
        this.interlockNameEn = interlockNameEn;
    }

    public String getInterlockNameJp() {
        return CommonConvert.CommonGetStr(interlockNameJp);
    }

    public void setInterlockNameJp(String interlockNameJp) {
        this.interlockNameJp = interlockNameJp;
    }

    public String getInterlockNameCn() {
        return CommonConvert.CommonGetStr(interlockNameCn);
    }

    public void setInterlockNameCn(String interlockNameCn) {
        this.interlockNameCn = interlockNameCn;
    }

    public String getSelectSql() {
        return CommonConvert.CommonGetStr(selectSql);
    }

    public void setSelectSql(String selectSql) {
        this.selectSql = selectSql;
    }

    public String getReDraftUrl() {
        return CommonConvert.CommonGetStr(reDraftUrl);
    }

    public void setReDraftUrl(String reDraftUrl) {
        this.reDraftUrl = reDraftUrl;
    }

    public String getOriApproKey() {
        return CommonConvert.CommonGetStr(oriApproKey);
    }

    public void setOriApproKey(String oriApproKey) {
        this.oriApproKey = oriApproKey;
    }

    public String getOriDocId() {
        return CommonConvert.CommonGetStr(oriDocId);
    }

    public void setOriDocId(String oriDocId) {
        this.oriDocId = oriDocId;
    }

    public String getFormGb() {
        return CommonConvert.CommonGetStr(formGb);
    }

    public void setFormGb(String formGb) {
        this.formGb = formGb;
    }

    public String getCopyApprovalLine() {
        return CommonConvert.CommonGetStr(copyApprovalLine);
    }

    public void setCopyApprovalLine(String copyApprovalLine) {
        this.copyApprovalLine = copyApprovalLine;
    }

    public String getCopyAttachFile() {
        return CommonConvert.CommonGetStr(copyAttachFile);
    }

    public void setCopyAttachFile(String copyAttachFile) {
        this.copyAttachFile = copyAttachFile;
    }

    public Map<String, Object> getHeader() {
        return header;
    }

    public void setHeader(Map<String, Object> header) {
        this.header = header;
    }

    public List<Map<String, Object>> getContent() {
        return content;
    }

    public void setContent(List<Map<String, Object>> content) {
        this.content = content;
    }

    public Map<String, Object> getFooter() {
        return footer;
    }

    public void setFooter(Map<String, Object> footer) {
        this.footer = footer;
    }

    public Map<String, Object> getParams() {
        return params;
    }

    public void setParams(Map<String, Object> param) {
        this.params = param;
    }

    public List<Map<String, Object>> getAaData() {
        return aaData;
    }

    public void setAaData(List<Map<String, Object>> aaData) {
        this.aaData = aaData;
    }

    public void addAaData(Map<String, Object> aData) {
        this.aaData.add(aData);
    }

    public Map<String, Object> getaData() {
        return aData;
    }

    public void setaData(Map<String, Object> aData) {
        this.aData = aData;
    }

    public String getIpAddress() {
        return CommonConvert.CommonGetStr(ipAddress);
    }

    public String getErrorCode() {
        return CommonConvert.CommonGetStr(errorCode);
    }

    public String getErrorTrace() {
        return CommonConvert.CommonGetStr(errorTrace);
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public void setErrorTrace(String errorTrace) {
        this.errorTrace = errorTrace;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public ResultVO setSuccess() {
        this.setResultCode(commonCode.success);
        this.setResultName("성공하였습니다.");
        return this;
    }

    public ResultVO setSuccess(String resultName) {
        this.setResultCode(commonCode.success);
        this.setResultName(resultName);
        return this;
    }

    public ResultVO setFail(String resultName) {
        this.setResultCode(commonCode.fail);
        this.setResultName(resultName);
        this.setAaData(new ArrayList<Map<String, Object>>());
        this.setaData(new HashMap<String, Object>());
        return this;
    }


    public String getCount() {
        return count;
    }

    public void setCount(String count) {
        this.count = count;
    }

    public ResultVO setFail(String resultName, Exception ex) {
        this.setResultCode(commonCode.fail);
        this.errorCode = ex.getMessage().toString();
        this.errorTrace = ex.getStackTrace().toString();
        this.setResultName(resultName);
        this.setAaData(new ArrayList<Map<String, Object>>());
        this.setaData(new HashMap<String, Object>());
        return this;
    }

    public ResultVO setLoginVo(LoginVO loginVo) {
        this.setId(CommonConvert.CommonGetStr(loginVo.getId()));
        this.setGroupSeq(CommonConvert.CommonGetStr(loginVo.getGroupSeq()));
        this.setCompSeq(CommonConvert.CommonGetStr(loginVo.getCompSeq()));
        this.setBizSeq(CommonConvert.CommonGetStr(loginVo.getBizSeq()));
        this.setDeptSeq(CommonConvert.CommonGetStr(loginVo.getOrgnztId()));
        this.setLangCode(CommonConvert.CommonGetStr(loginVo.getLangCode()));
        this.setUserSe(CommonConvert.CommonGetStr(loginVo.getUserSe()));
        this.setEaType(CommonConvert.CommonGetStr(loginVo.getEaType()));
        this.setEmpSeq(CommonConvert.CommonGetStr(loginVo.getUniqId()));
        this.setEmpName(CommonConvert.CommonGetStr(loginVo.getName()));
        this.setErpCompSeq(CommonConvert.CommonGetStr(loginVo.getErpCoCd()));
        this.setErpEmpSeq(CommonConvert.CommonGetStr(loginVo.getErpEmpCd()));
        return this;
    }

    @Override
    public String toString() {
        return "ResultVO [resultCode=" + resultCode + ", resultName=" + resultName + ", errorCode=" + errorCode + ", errorTrace=" + errorTrace + ", id=" + id + ", groupSeq=" + groupSeq + ", compSeq=" + compSeq + ", erpCompSeq=" + erpCompSeq + ", bizSeq=" + bizSeq + ", erpBizSeq=" + erpBizSeq + ", deptSeq=" + deptSeq + ", erpDeptSeq=" + erpDeptSeq + ", empSeq=" + empSeq + ", empName=" + empName + ", erpEmpSeq=" + erpEmpSeq + ", langCode=" + langCode + ", userSe=" + userSe + ", expendSeq=" + expendSeq + ", expendListSeq=" + expendListSeq + ", expendSlipSeq=" + expendSlipSeq + ", expendMngSeq=" + expendMngSeq + ", eaType=" + eaType + ", docSeq=" + docSeq + ", formSeq=" + formSeq + ", approKey=" + approKey + ", preUrl=" + preUrl + ", processId=" + processId + ", docTitle=" + docTitle + ", docContent=" + docContent + ", interlockUrl=" + interlockUrl + ", interlockName=" + interlockName + ", selectSql=" + selectSql + ", reDraftUrl=" + reDraftUrl + ", oriApproKey=" + oriApproKey
                + ", oriDocId=" + oriDocId + ", formGb=" + formGb + ", copyApprovalLine=" + copyApprovalLine + ", copyAttachFile=" + copyAttachFile + ", header=" + header + ", content=" + content + ", footer=" + footer + ", params=" + params + ", aaData=" + aaData + ", aData=" + aData + ", ipAddress=" + ipAddress + "]";
    }
}
