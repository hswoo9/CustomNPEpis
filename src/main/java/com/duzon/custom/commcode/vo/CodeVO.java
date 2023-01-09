package com.duzon.custom.commcode.vo;

import java.sql.Timestamp;

public class CodeVO {
	
	private int CODE_MST_ID;
	private int UP_CODE_MST_ID;
	private String CODE_NM;
	private String CODE_DESC;
	private int ORDERBY;
	private String USE_YN;
	private int CREATE_ID;
	private Timestamp CREATE_DT;
	private int UPDATE_ID;
	private Timestamp UPDATE_DT;
	
	public CodeVO(int CODE_MST_ID, int UP_CODE_MST_ID, String CODE_NM, String CODE_DESC, int ORDERBY, String USE_YN, int CREATE_ID, Timestamp CREATE_DT,int UPDATE_ID,Timestamp UPDATE_DT) {
		
		this.CODE_MST_ID = CODE_MST_ID;
		this.UP_CODE_MST_ID = UP_CODE_MST_ID;
		this.CODE_NM = CODE_NM;
		this.CODE_DESC = CODE_DESC;
		this.ORDERBY = ORDERBY;
		this.USE_YN = USE_YN;
		this.CREATE_ID = CREATE_ID;
		this.CREATE_DT = CREATE_DT;
		this.UPDATE_ID = UPDATE_ID;
		this.UPDATE_DT = UPDATE_DT;
	
	}

	public int getCODE_MST_ID() {
		return CODE_MST_ID;
	}

	public void setCODE_MST_ID(int cODE_MST_ID) {
		CODE_MST_ID = cODE_MST_ID;
	}

	public int getUP_CODE_MST_ID() {
		return UP_CODE_MST_ID;
	}

	public void setUP_CODE_MST_ID(int uP_CODE_MST_ID) {
		UP_CODE_MST_ID = uP_CODE_MST_ID;
	}

	public String getCODE_NM() {
		return CODE_NM;
	}

	public void setCODE_NM(String cODE_NM) {
		CODE_NM = cODE_NM;
	}

	public String getCODE_DESC() {
		return CODE_DESC;
	}

	public void setCODE_DESC(String cODE_DESC) {
		CODE_DESC = cODE_DESC;
	}

	public int getORDERBY() {
		return ORDERBY;
	}

	public void setORDERBY(int oRDERBY) {
		ORDERBY = oRDERBY;
	}

	public String getUSE_YN() {
		return USE_YN;
	}

	public void setUSE_YN(String uSE_YN) {
		USE_YN = uSE_YN;
	}

	public int getCREATE_ID() {
		return CREATE_ID;
	}

	public void setCREATE_ID(int cREATE_ID) {
		CREATE_ID = cREATE_ID;
	}

	public Timestamp getCREATE_DT() {
		return CREATE_DT;
	}

	public void setCREATE_DT(Timestamp cREATE_DT) {
		CREATE_DT = cREATE_DT;
	}

	public int getUPDATE_ID() {
		return UPDATE_ID;
	}

	public void setUPDATE_ID(int uPDATE_ID) {
		UPDATE_ID = uPDATE_ID;
	}

	public Timestamp getUPDATE_DT() {
		return UPDATE_DT;
	}

	public void setUPDATE_DT(Timestamp uPDATE_DT) {
		UPDATE_DT = uPDATE_DT;
	}
	
	
	
}
