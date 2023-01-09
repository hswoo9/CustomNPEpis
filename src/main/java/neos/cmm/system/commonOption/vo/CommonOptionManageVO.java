package neos.cmm.system.commonOption.vo;

import java.util.ArrayList;

/**
 *<pre>
 * 1. Package Name	: neos.cmm.system.commonOption.vo
 * 2. Class Name	: CommonOptionManageVO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2013. 9. 3.     doban7       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public class CommonOptionManageVO {
    
	private String optionSeq = "";		// 옵션 시퀀스
	private String submitType = "";		// 등록구분(insert, update)
	
	private String startYear = "";		// 회계년도 설정 시작 년도
    private String startMonth = "";		// 회계년도 설정 시작 월
    private String endYear = "";		// 회계년도 설정 종료 년도
    private String endMonth = "";		// 회계년도 설정 종료 월
    private String autoRenewVal = "";	// 회계년도 설정 자동갱신 여부
    
    private String loginFailCnt = "";	// 로그인 통제 횟수
    private String infoType = "";		// 사용자 정보 표시 유형
    private String passChk = "";		// 비밀번호 설정규칙 사용 여브
    private String passCycle = "";		// 비밀번호 안내주기
    private String passReCycle = "";	// 비밀번호 재안내주기
    private String minLength = "";		// 비밀번호 자리수(최소)
    private String maxLength = "";		// 비밀번호 자리수(최대)
	private String passMixVal = "";		// 비밀번호 문자조합
    private String passLimitVal = "";	// 비밀번호 입력제한
    
    private String menuOpenScope = "";		// 메뉴 펼침 단계 유형
    private String menuOpenScopeChk1 = "";  // 메뉴 펼침 단계(전체메뉴)
    private String menuOpenScopeChk2 = "";	// 메뉴 펼침 단계(개별조직도)
    private String menuOpenScopeChk3 = "";	// 메뉴 펼침 단계(개별메뉴)
    private String menuCnt = "";			// 메뉴 카운트 표시
    
    private String editorChk = "";		// 적용 에디터 설정
    private String erpOrgChart = "";	// ERP조직도 연동 설정
    
    
	public String getOptionSeq() {
		return optionSeq;
	}
	public void setOptionSeq(String optionSeq) {
		this.optionSeq = optionSeq;
	}
	public String getSubmitType() {
		return submitType;
	}
	public void setSubmitType(String submitType) {
		this.submitType = submitType;
	}	
    public String getStartYear() {
		return startYear;
	}
	public void setStartYear(String startYear) {
		this.startYear = startYear;
	}
	public String getStartMonth() {
		return startMonth;
	}
	public void setStartMonth(String startMonth) {
		this.startMonth = startMonth;
	}
	public String getEndYear() {
		return endYear;
	}
	public void setEndYear(String endYear) {
		this.endYear = endYear;
	}
	public String getEndMonth() {
		return endMonth;
	}
	public void setEndMonth(String endMonth) {
		this.endMonth = endMonth;
	}
	public String getAutoRenewVal() {
		return autoRenewVal;
	}
	public void setAutoRenewVal(String autoRenewVal) {
		this.autoRenewVal = autoRenewVal;
	}
	public String getLoginFailCnt() {
		return loginFailCnt;
	}
	public void setLoginFailCnt(String loginFailCnt) {
		this.loginFailCnt = loginFailCnt;
	}
	public String getInfoType() {
		return infoType;
	}
	public void setInfoType(String infoType) {
		this.infoType = infoType;
	}
	public String getPassChk() {
		return passChk;
	}
	public void setPassChk(String passChk) {
		this.passChk = passChk;
	}
	public String getPassCycle() {
		return passCycle;
	}
	public void setPassCycle(String passCycle) {
		this.passCycle = passCycle;
	}
	public String getPassReCycle() {
		return passReCycle;
	}
	public void setPassReCycle(String passReCycle) {
		this.passReCycle = passReCycle;
	}
	public String getMinLength() {
		return minLength;
	}
	public void setMinLength(String minLength) {
		this.minLength = minLength;
	}
	public String getMaxLength() {
		return maxLength;
	}
	public void setMaxLength(String maxLength) {
		this.maxLength = maxLength;
	}
    public String getPassMixVal() {
		return passMixVal;
	}
	public void setPassMixVal(String passMixVal) {
		this.passMixVal = passMixVal;
	}
	public String getPassLimitVal() {
		return passLimitVal;
	}
	public void setPassLimitVal(String passLimitVal) {
		this.passLimitVal = passLimitVal;
	}
	public String getMenuOpenScope() {
		return menuOpenScope;
	}
	public void setMenuOpenScope(String menuOpenScope) {
		this.menuOpenScope = menuOpenScope;
	}
	public String getMenuOpenScopeChk1() {
		return menuOpenScopeChk1;
	}
	public void setMenuOpenScopeChk1(String menuOpenScopeChk1) {
		this.menuOpenScopeChk1 = menuOpenScopeChk1;
	}
	public String getMenuOpenScopeChk2() {
		return menuOpenScopeChk2;
	}
	public void setMenuOpenScopeChk2(String menuOpenScopeChk2) {
		this.menuOpenScopeChk2 = menuOpenScopeChk2;
	}
	public String getMenuOpenScopeChk3() {
		return menuOpenScopeChk3;
	}
	public void setMenuOpenScopeChk3(String menuOpenScopeChk3) {
		this.menuOpenScopeChk3 = menuOpenScopeChk3;
	}
	public String getMenuCnt() {
		return menuCnt;
	}
	public void setMenuCnt(String menuCnt) {
		this.menuCnt = menuCnt;
	}
	public String getEditorChk() {
		return editorChk;
	}
	public void setEditorChk(String editorChk) {
		this.editorChk = editorChk;
	}
	public String getErpOrgChart() {
		return erpOrgChart;
	}
	public void setErpOrgChart(String erpOrgChart) {
		this.erpOrgChart = erpOrgChart;
	}

    

}
 

