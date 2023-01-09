package neos.cmm.vo;

/**
 * @title ConnectionVO.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */


public class ConnectionVO {
	private String	databaseType;	/* 사용 DBMS */
	private String	driver;			/* package 정보 */
	private String	url;			/* 커넥션 정보 */
	private String	userId;			/* 로그인 아이디 */
	private String	passWord;		/* 로그인 패스워드 */
	private String	systemType;		/* 연동시스템 구분 ( BizboxA / iCUBE / ERPiU ) */

	public String getDatabaseType() {
		return databaseType;
	}

	public void setDatabaseType(String databaseType) {
		this.databaseType = databaseType;
	}

	public String getDriver() {
		return driver;
	}

	public void setDriver(String driver) {
		this.driver = driver;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}

	public String getSystemType() {
		return systemType;
	}

	public void setSystemType(String systemType) {
		this.systemType = systemType;
	}

}
