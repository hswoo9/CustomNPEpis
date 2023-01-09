/*
 * Copyright doban7 by Duzon Newturns.,
 * All rights reserved.
 */
package neos.edoc.document.record.vo;

/**
 *<pre>
 * 1. Package Name	: neos.edoc.document.record.vo
 * 2. Class Name	: RecordDetailVO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2014. 3. 17.     doban7       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public class RecordDetailVO {

    private String c_dikeycode;
    private String c_dititle; /* 문서제목 */
    private String c_winame; /*단위업무명 */
    private String c_aititle;  /*기록물철명 */
    private String c_riusername; /*기안접수자명 */
    private String c_riownusername; /*업무담당자명 */
    private String c_riregdate; /* 등록일자 */
    private String c_riafterenforce; /*시행일자 */
    private String c_dipublic; /* 공개여부코드*/
    private String c_dipublic_ko; /*공개여부 */
    private int c_digrade; /* 공개등급 코드 */
    private String c_digrade_str; /*공개등급 */
    private String c_didocflag; /*문서구분 */
    private String c_diflag; /*전자비전자 구분*/
    private String c_ridocnum; /*문서번호*/
    private String c_ritypeflag; /*등록구분*/
    private String c_ritypeflagname; /*등록구분명*/
    private String sendreceiver; /*수발신처*/
    private String c_ditreatment; /*문서취급*/
    private String c_cikeyname; /*결재권자코드*/
    private String c_rimakeyear; /*생산년도*/
    private String c_riafterpage; /* 쪽수 */
    private String c_disecretgrade; /*보안여부*/ 
    private String c_disecretgradenm; /*보안여부*/
    private String c_dipreserve; /*보존기한*/
    private String c_dipreservenm; /*보존기한명*/
    private String c_rideleteopt; /* 삭제여부 */

	private String c_riuserkey;/* 기안접수자 코드 */
    

	public String getC_dikeycode() {
        return c_dikeycode;
    }
    public void setC_dikeycode(String c_dikeycode) {
        this.c_dikeycode = c_dikeycode;
    }
    public String getC_dititle() {
        return c_dititle;
    }
    public void setC_dititle(String c_dititle) {
        this.c_dititle = c_dititle;
    }
    public String getC_winame() {
        return c_winame;
    }
    public void setC_winame(String c_winame) {
        this.c_winame = c_winame;
    }
    public String getC_aititle() {
        return c_aititle;
    }
    public void setC_aititle(String c_aititle) {
        this.c_aititle = c_aititle;
    }
    public String getC_riusername() {
        return c_riusername;
    }
    public void setC_riusername(String c_riusername) {
        this.c_riusername = c_riusername;
    }
    public String getC_riownusername() {
        return c_riownusername;
    }
    public void setC_riownusername(String c_riownusername) {
        this.c_riownusername = c_riownusername;
    }
    public String getC_riregdate() {
        return c_riregdate;
    }
    public void setC_riregdate(String c_riregdate) {
        this.c_riregdate = c_riregdate;
    }
    public String getC_riafterenforce() {
        return c_riafterenforce;
    }
    public void setC_riafterenforce(String c_riafterenforce) {
        this.c_riafterenforce = c_riafterenforce;
    }
    public String getC_dipublic() {
        return c_dipublic;
    }
    public void setC_dipublic(String c_dipublic) {
        this.c_dipublic = c_dipublic;
    }
    public String getC_dipublic_ko() {
        return c_dipublic_ko;
    }
    public void setC_dipublic_ko(String c_dipublic_ko) {
        this.c_dipublic_ko = c_dipublic_ko;
    }
    public int getC_digrade() {
        return c_digrade;
    }
    public void setC_digrade(int c_digrade) {
        this.c_digrade = c_digrade;
    }
    public String getC_digrade_str() {
        return c_digrade_str;
    }
    public void setC_digrade_str(String c_digrade_str) {
        this.c_digrade_str = c_digrade_str;
    }
    public String getC_didocflag() {
        return c_didocflag;
    }
    public void setC_didocflag(String c_didocflag) {
        this.c_didocflag = c_didocflag;
    }
    public String getC_diflag() {
        return c_diflag;
    }
    public void setC_diflag(String c_diflag) {
        this.c_diflag = c_diflag;
    }
    public String getC_ridocnum() {
        return c_ridocnum;
    }
    public void setC_ridocnum(String c_ridocnum) {
        this.c_ridocnum = c_ridocnum;
    }
    public String getC_ritypeflag() {
        return c_ritypeflag;
    }
    public void setC_ritypeflag(String c_ritypeflag) {
        this.c_ritypeflag = c_ritypeflag;
    }
    public String getC_ritypeflagname() {
        return c_ritypeflagname;
    }
    public void setC_ritypeflagname(String c_ritypeflagname) {
        this.c_ritypeflagname = c_ritypeflagname;
    }
    public String getSendreceiver() {
        return sendreceiver;
    }
    public void setSendreceiver(String sendreceiver) {
        this.sendreceiver = sendreceiver;
    }
    public String getC_ditreatment() {
        return c_ditreatment;
    }
    public void setC_ditreatment(String c_ditreatment) {
        this.c_ditreatment = c_ditreatment;
    }
    public String getC_cikeyname() {
        return c_cikeyname;
    }
    public void setC_cikeyname(String c_cikeyname) {
        this.c_cikeyname = c_cikeyname;
    }
    public String getC_rimakeyear() {
        return c_rimakeyear;
    }
    public void setC_rimakeyear(String c_rimakeyear) {
        this.c_rimakeyear = c_rimakeyear;
    }
    public String getC_riafterpage() {
        return c_riafterpage;
    }
    public void setC_riafterpage(String c_riafterpage) {
        this.c_riafterpage = c_riafterpage;
    }
    public String getC_disecretgrade() {
        return c_disecretgrade;
    }
    public void setC_disecretgrade(String c_disecretgrade) {
        this.c_disecretgrade = c_disecretgrade;
    }
    public String getC_disecretgradenm() {
        return c_disecretgradenm;
    }
    public void setC_disecretgradenm(String c_disecretgradenm) {
        this.c_disecretgradenm = c_disecretgradenm;
    }
    public String getC_dipreserve() {
        return c_dipreserve;
    }
    public void setC_dipreserve(String c_dipreserve) {
        this.c_dipreserve = c_dipreserve;
    }
    public String getC_dipreservenm() {
        return c_dipreservenm;
    }
    public void setC_dipreservenm(String c_dipreservenm) {
        this.c_dipreservenm = c_dipreservenm;
    }
    public String getC_rideleteopt() {
        return c_rideleteopt;
    }
    public void setC_rideleteopt(String c_rideleteopt) {
        this.c_rideleteopt = c_rideleteopt;
    }

    public String getC_riuserkey() {
		return c_riuserkey;
	}
	public void setC_riuserkey(String c_riuserkey) {
		this.c_riuserkey = c_riuserkey;
	}    
    
}
 

