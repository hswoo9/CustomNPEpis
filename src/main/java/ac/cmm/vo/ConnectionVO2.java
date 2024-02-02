package ac.cmm.vo;

/**
 * @title ConnectionVO.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */

import com.duzon.custom.expend.etc.CommonInterface.commonCode;

public class ConnectionVO2 {
	private String databaseType = commonCode.emptyStr; /* 사용 DBMS */
	private String driver = commonCode.emptyStr; /* package 정보 */
	private String url = commonCode.emptyStr; /* 커넥션 정보 */
	private String userId = commonCode.emptyStr; /* 로그인 아이디 */
	private String password = commonCode.emptyStr; /* 로그인 패스워드 */
	private String erpTypeCode = commonCode.emptyStr; /* 연동시스템 구분 ( iCUBE / ERPiU / ETC ) */
	private String g20YN = commonCode.emptyStr;
	private String erpCompSeq = commonCode.emptyStr;
	private String erpCompName = commonCode.emptyStr;

	/* ==================================================================================================== */
	/* getter */
	/* ==================================================================================================== */
	public String getDatabaseType() {
		return databaseType;
	}

	public String getDriver() {
		return driver;
	}

	public String getUrl() {
		return url;
	}

	public String getUserId() {
		return userId;
	}

	public String getPassword() {
		return password;
	}

	/**
	 * <pre>
	 * # 연동 ERP 정의
	 *   - ERPiU : 사용 가능
	 *   - iCUBE : 사용 가능
	 *   - ETC : 사용 불가
	 * </pre>
	 */
	public String getErpTypeCode() {
		return erpTypeCode;
	}

	/**
	 * <pre>
	 * # G20 연동 여부 정의
	 *   - Y : 연동
	 *   - N : 미연동
	 * </pre>
	 */
	public String getG20YN() {
		if (g20YN == null || g20YN.equals("")) {
			return "N";
		} else {
			return g20YN.toUpperCase();
		}
	}

	public String getErpCompSeq() {
		return erpCompSeq;
	}

	public String getErpCompName() {
		return erpCompName;
	}

	/* ==================================================================================================== */
	/* setter */
	/* ==================================================================================================== */
	public void setDatabaseType(String databaseType) {
		// oracle, mssql
		this.databaseType = databaseType;
	}

	public void setDriver(String driver) {
		// com.microsoft.sqlserver.jdbc.SQLServerDriver
		//
		this.driver = driver;
	}

	public void setUrl(String url) {
		// jdbc:sqlserver://128.0.0.1:1433;databasename=NEOE
		//
		this.url = url;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setErpTypeCode(String erpTypeCode) {
		this.erpTypeCode = erpTypeCode;
	}

	public void setG20YN(String g20yn) {
		if (g20yn == null || g20yn.equals("")) {
			this.g20YN = "N";
		} else {
			this.g20YN = g20yn.toUpperCase();
		}
	}

	public void setErpCompSeq(String erpCompSeq) {
		this.erpCompSeq = erpCompSeq;
	}

	public void setErpCompName(String erpCompName) {
		this.erpCompName = erpCompName;
	}


	/* ==================================================================================================== */
	/* is */
	/* ==================================================================================================== */
	/**
	 * <pre>
	 * # G20 연동 여부 확인
	 *   - G20 연동 : true
	 *   - G20 미연동 : false
	 * </pre>
	 */
	public boolean isG20() {
		if (this.getG20YN() != null) {
			if (this.getG20YN().toUpperCase().equals(commonCode.emptyYes)) {
				return true;
			}
		}

		return false;
	}

	/**
	 * <pre>
	 * # ERPiU 연동 여부 확인
	 *   - ERPiU 연동 : true
	 *   - ERPiU 미연동 : false
	 * </pre>
	 */
	public boolean isERPIU() {
		if (this.getErpTypeCode() != null) {
			if (this.getErpTypeCode().toUpperCase().equals(commonCode.ERPiU.toUpperCase())) {
				return true;
			}
		}

		return false;
	}

	/**
	 * <pre>
	 * # iCUBE 연동 여부 확인
	 *   - iCUBE 연동 : true
	 *   - iCUBE 미연동 : false
	 * </pre>
	 */
	public boolean isICUBE() {
		if (this.getErpTypeCode() != null) {
			if (this.getErpTypeCode().toUpperCase().equals(commonCode.iCUBE.toUpperCase())) {
				return true;
			}
		}

		return false;
	}

	/* ==================================================================================================== */
	/* ext */
	/* ==================================================================================================== */
	@Override
	public String toString() {
		return "ConnectionVO [databaseType=" + databaseType + ", driver=" + driver + ", url=" + url + ", userId=####, password=****, erpTypeCode=" + erpTypeCode + ", g20YN=" + g20YN + ", erpCompSeq=" + erpCompSeq + ", erpCompName=" + erpCompName + "]";
	}

}
