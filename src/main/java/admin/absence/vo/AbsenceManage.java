package admin.absence.vo;

import egovframework.com.cmm.ComDefaultVO;

/**
 * 
 * @title 부재 이력 정보 VO
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 7. 18.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 7. 18.  박기환        최초 생성
 *
 */
public class AbsenceManage extends ComDefaultVO {

	/**
	 * 글번호
	 */
	private String rn = "";	
	
	/**
     * 전체 Count
     */
    private int resultCount = 0;
	
	/**
	 * 사용자 고유 코드
	 */
	private String uniqId = "";
	
	/**
	 * 부재자명
	 */
	private String userNm = "";
	
	/**
	 * 부서코드
	 */
	private String orgnztId = "";
	
	/**
	 * 부재 일련번호
	 */
	private String absenceSeqNum = "";
	
	/**
	 * 부재 코드
	 */
	private String absenceCode = "";
		
	/**
	 * 부재 시작 날짜
	 */
	private String absenceStartDate = "";
	
	/**
	 * 부재 종료 날짜
	 */
	private String absenceEndDate = "";
	
	/**
	 * 부재 설명
	 */
	private String absenceMemo = "";
	
	/**
	 * 부재 상태코드
	 */
	private String absenceStatusCode = "";
	
	/**
	 * 부재 상태
	 */
	private String absenceStatus = "";
	
	/**
	 * 자동 부재 해제여부
	 */
	private String absenceFlag = "";

	/**
	 * 부재명
	 */
	private String absenceNm = "";
	
	/**
	 * 부재 설명
	 */
	 private String absenceDc = "";
	 
	 /**
	  * 부재대행 일련번호
	  */
	 private String agentSeqNum = "";
	 
	 /**
	  * 부재 대행자 부서코드
	  */
	 private String agentOrgnztId = "";
	 
	 /**
	  * 부재 대행자 부서명
	  */
	 private String agentOrgnztNm = "";
	 
	 /**
	  * 부재 권한 코드
	  */
	 private String absenceAuthCode = "";
	 
	 /**
	  * 부재 대행자 사용자 코드
	  */
	 private String agentUniqId = "";	
	 
	 /**
	  * 부재 대행자 명
	  */
	 private String agentNm = "";
	 
	 /**
	  * 권한코드
	  */
	 private String authorCode = "";
	 
	 /**
	  * 권한명
	  */
	 private String authorNm = "";
	 
	 /**
	  * 직위 코드
	  */
	 private String positionCode = "";
	 
	 /**
	  * 직위명
	  */
	 private String positionNm = "";

	 /**
	  * 쿼리 타입
	  */
	 private String seqType = "";
	 
	 private String langCode = "";
	 
	 private int startRow = 0;
	 private int pageSize = 0;


    public int getStartRow() {
        return startRow;
    }

    public void setStartRow(int startRow) {
        this.startRow = startRow;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public String getLangCode() {
        return langCode;
    }

    public void setLangCode(String langCode) {
        this.langCode = langCode;
    }

    /**
	 * rn attribute 값을 리턴한다.
	 * @return rn
	 */
	public String getRn() {
		return rn;
	}

	/**
	 * rn attribute 값을 설정한다.
	 * @param rn String
	 */
	public void setRn(String rn) {
		this.rn = rn;
	}

	/**
	 * resultCount attribute 값을 리턴한다.
	 * @return resultCount
	 */
	public int getResultCount() {
		return resultCount;
	}

	/**
	 * resultCount attribute 값을 설정한다.
	 * @param resultCount int
	 */
	public void setResultCount(int resultCount) {
		this.resultCount = resultCount;
	}

	/**
	 * uniqId attribute 값을 리턴한다.
	 * @return uniqId
	 */
	public String getUniqId() {
		return uniqId;
	}

	/**
	 * uniqId attribute 값을 설정한다.
	 * @param uniqId String
	 */
	public void setUniqId(String uniqId) {
		this.uniqId = uniqId;
	}

	/**
	 * userNm attribute 값을 리턴한다.
	 * @return userNm
	 */
	public String getUserNm() {
		return userNm;
	}

	/**
	 * userNm attribute 값을 설정한다.
	 * @param userNm String
	 */
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	/**
	 * orgnztId attribute 값을 리턴한다.
	 * @return orgnztId
	 */
	public String getOrgnztId() {
		return orgnztId;
	}

	/**
	 * orgnztId attribute 값을 설정한다.
	 * @param orgnztId String
	 */
	public void setOrgnztId(String orgnztId) {
		this.orgnztId = orgnztId;
	}

	/**
	 * absenceSeqNum attribute 값을 리턴한다.
	 * @return absenceSeqNum
	 */
	public String getAbsenceSeqNum() {
		return absenceSeqNum;
	}

	/**
	 * absenceSeqNum attribute 값을 설정한다.
	 * @param absenceSeqNum String
	 */
	public void setAbsenceSeqNum(String absenceSeqNum) {
		this.absenceSeqNum = absenceSeqNum;
	}

	/**
	 * absenceCode attribute 값을 리턴한다.
	 * @return absenceCode
	 */
	public String getAbsenceCode() {
		return absenceCode;
	}

	/**
	 * absenceCode attribute 값을 설정한다.
	 * @param absenceCode String
	 */
	public void setAbsenceCode(String absenceCode) {
		this.absenceCode = absenceCode;
	}

	/**
	 * absenceStartDate attribute 값을 리턴한다.
	 * @return absenceStartDate
	 */
	public String getAbsenceStartDate() {
		return absenceStartDate;
	}

	/**
	 * absenceStartDate attribute 값을 설정한다.
	 * @param absenceStartDate String
	 */
	public void setAbsenceStartDate(String absenceStartDate) {
		this.absenceStartDate = absenceStartDate;
	}

	/**
	 * absenceEndDate attribute 값을 리턴한다.
	 * @return absenceEndDate
	 */
	public String getAbsenceEndDate() {
		return absenceEndDate;
	}

	/**
	 * absenceEndDate attribute 값을 설정한다.
	 * @param absenceEndDate String
	 */
	public void setAbsenceEndDate(String absenceEndDate) {
		this.absenceEndDate = absenceEndDate;
	}

	/**
	 * absenceMemo attribute 값을 리턴한다.
	 * @return absenceMemo
	 */
	public String getAbsenceMemo() {
		return absenceMemo;
	}

	/**
	 * absenceMemo attribute 값을 설정한다.
	 * @param absenceMemo String
	 */
	public void setAbsenceMemo(String absenceMemo) {
		this.absenceMemo = absenceMemo;
	}

	/**
	 * absenceStatusCode attribute 값을 리턴한다.
	 * @return absenceStatusCode
	 */
	public String getAbsenceStatusCode() {
		return absenceStatusCode;
	}

	/**
	 * absenceStatusCode attribute 값을 설정한다.
	 * @param absenceStatusCode String
	 */
	public void setAbsenceStatusCode(String absenceStatusCode) {
		this.absenceStatusCode = absenceStatusCode;
	}

	/**
	 * absenceStatus attribute 값을 리턴한다.
	 * @return absenceStatus
	 */
	public String getAbsenceStatus() {
		return absenceStatus;
	}

	/**
	 * absenceStatus attribute 값을 설정한다.
	 * @param absenceStatus String
	 */
	public void setAbsenceStatus(String absenceStatus) {
		this.absenceStatus = absenceStatus;
	}

	/**
	 * absenceFlag attribute 값을 리턴한다.
	 * @return absenceFlag
	 */
	public String getAbsenceFlag() {
		return absenceFlag;
	}

	/**
	 * absenceFlag attribute 값을 설정한다.
	 * @param absenceFlag String
	 */
	public void setAbsenceFlag(String absenceFlag) {
		this.absenceFlag = absenceFlag;
	}

	/**
	 * absenceNm attribute 값을 리턴한다.
	 * @return absenceNm
	 */
	public String getAbsenceNm() {
		return absenceNm;
	}

	/**
	 * absenceNm attribute 값을 설정한다.
	 * @param absenceNm String
	 */
	public void setAbsenceNm(String absenceNm) {
		this.absenceNm = absenceNm;
	}

	/**
	 * absenceDc attribute 값을 리턴한다.
	 * @return absenceDc
	 */
	public String getAbsenceDc() {
		return absenceDc;
	}

	/**
	 * absenceDc attribute 값을 설정한다.
	 * @param absenceDc String
	 */
	public void setAbsenceDc(String absenceDc) {
		this.absenceDc = absenceDc;
	}

	/**
	 * agentSeqNum attribute 값을 리턴한다.
	 * @return agentSeqNum
	 */
	public String getAgentSeqNum() {
		return agentSeqNum;
	}

	/**
	 * agentSeqNum attribute 값을 설정한다.
	 * @param agentSeqNum String
	 */
	public void setAgentSeqNum(String agentSeqNum) {
		this.agentSeqNum = agentSeqNum;
	}

	/**
	 * agentOrgnztId attribute 값을 리턴한다.
	 * @return agentOrgnztId
	 */
	public String getAgentOrgnztId() {
		return agentOrgnztId;
	}

	/**
	 * agentOrgnztId attribute 값을 설정한다.
	 * @param agentOrgnztId String
	 */
	public void setAgentOrgnztId(String agentOrgnztId) {
		this.agentOrgnztId = agentOrgnztId;
	}

	/**
	 * agentOrgnztNm attribute 값을 리턴한다.
	 * @return agentOrgnztNm
	 */
	public String getAgentOrgnztNm() {
		return agentOrgnztNm;
	}

	/**
	 * agentOrgnztNm attribute 값을 설정한다.
	 * @param agentOrgnztNm String
	 */
	public void setAgentOrgnztNm(String agentOrgnztNm) {
		this.agentOrgnztNm = agentOrgnztNm;
	}

	/**
	 * absenceAuthCode attribute 값을 리턴한다.
	 * @return absenceAuthCode
	 */
	public String getAbsenceAuthCode() {
		return absenceAuthCode;
	}

	/**
	 * absenceAuthCode attribute 값을 설정한다.
	 * @param absenceAuthCode String
	 */
	public void setAbsenceAuthCode(String absenceAuthCode) {
		this.absenceAuthCode = absenceAuthCode;
	}

	/**
	 * agentUniqId attribute 값을 리턴한다.
	 * @return agentUniqId
	 */
	public String getAgentUniqId() {
		return agentUniqId;
	}

	/**
	 * agentUniqId attribute 값을 설정한다.
	 * @param agentUniqId String
	 */
	public void setAgentUniqId(String agentUniqId) {
		this.agentUniqId = agentUniqId;
	}

	/**
	 * agentNm attribute 값을 리턴한다.
	 * @return agentNm
	 */
	public String getAgentNm() {
		return agentNm;
	}

	/**
	 * agentNm attribute 값을 설정한다.
	 * @param agentNm String
	 */
	public void setAgentNm(String agentNm) {
		this.agentNm = agentNm;
	}

	/**
	 * authorCode attribute 값을 리턴한다.
	 * @return authorCode
	 */
	public String getAuthorCode() {
		return authorCode;
	}

	/**
	 * authorCode attribute 값을 설정한다.
	 * @param authorCode String
	 */
	public void setAuthorCode(String authorCode) {
		this.authorCode = authorCode;
	}

	/**
	 * authorNm attribute 값을 리턴한다.
	 * @return authorNm
	 */
	public String getAuthorNm() {
		return authorNm;
	}

	/**
	 * authorNm attribute 값을 설정한다.
	 * @param authorNm String
	 */
	public void setAuthorNm(String authorNm) {
		this.authorNm = authorNm;
	}

	/**
	 * positionCode attribute 값을 리턴한다.
	 * @return positionCode
	 */
	public String getPositionCode() {
		return positionCode;
	}

	/**
	 * positionCode attribute 값을 설정한다.
	 * @param positionCode String
	 */
	public void setPositionCode(String positionCode) {
		this.positionCode = positionCode;
	}

	/**
	 * positionNm attribute 값을 리턴한다.
	 * @return positionNm
	 */
	public String getPositionNm() {
		return positionNm;
	}

	/**
	 * positionNm attribute 값을 설정한다.
	 * @param positionNm String
	 */
	public void setPositionNm(String positionNm) {
		this.positionNm = positionNm;
	}

	/**
	 * seqType attribute 값을 리턴한다.
	 * @return seqType
	 */
	public String getSeqType() {
		return seqType;
	}

	/**
	 * seqType attribute 값을 설정한다.
	 * @param seqType String
	 */
	public void setSeqType(String seqType) {
		this.seqType = seqType;
	}
	 
	
	
 }