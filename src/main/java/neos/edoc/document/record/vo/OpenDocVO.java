/*
 * Copyright 이재혁 by Duzon Newturns.,
 * All rights reserved.
 */
package neos.edoc.document.record.vo;

import java.io.Serializable;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import neos.cmm.vo.SearchParamVO;

/**
 *<pre>
 * 1. Package Name	: neos.edoc.document.record.vo
 * 2. Class Name	: OpenDocVO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2016. 1. 4.     이재혁       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public class OpenDocVO extends SearchParamVO {
    private String c_dikeycode;    
    private String c_wikey;
    private String c_aikeycode;
    private String c_winame;
    private String c_ainame;
    private String c_wicard;
    private String c_dititle;
    private String c_draftcause;
    private String c_didrafttime;
    private String standardcode;
    private String organ_nm;
    private String orgnzt_id;
    private String orgnzt_nm;
    private String user_nm;
    private String c_ridocnum;
    private String docnumber;
    private String c_aipreserve;
    private String c_digrade;
    private String c_dipublicbasic;
    private String c_dipubliccause;
    private String receivenum;
    private String c_ritypeflag;
    private String c_ridocnum2;
    private String c_dititle2;
    private String c_dipublicyn;
    private String docinfocode;
    private String new_upt;
    private String c_klusername;
    private String c_klorgcode;
    private String view_regdate;
    private String c_aikeycode2;
    private String record_receive;
    private String doc_sys;
    private String c_aidata;
    private String c_riregdate;
    private String count_result;
    private String status;
    private String status_cause;
    private String c_csvseqnum;
    private String c_oddoctype;
    private String result_count;
    private String csvkeycode;
    
    public String getCsvkeycode() {
        return csvkeycode;
    }
    public void setCsvkeycode(String csvkeycode) {
        this.csvkeycode = csvkeycode;
    }
    public String getResult_count() {
        return result_count;
    }
    public void setResult_count(String result_count) {
        this.result_count = result_count;
    }
    public String getStatus_cause() {
        return status_cause;
    }
    public void setStatus_cause(String status_cause) {
        this.status_cause = status_cause;
    }
    public String getC_oddoctype() {
        return c_oddoctype;
    }
    public void setC_oddoctype(String c_oddoctype) {
        this.c_oddoctype = c_oddoctype;
    }
    public String getC_csvseqnum() {
        return c_csvseqnum;
    }
    public void setC_csvseqnum(String c_csvseqnum) {
        this.c_csvseqnum = c_csvseqnum;
    }
    
    public String getCount_result() {
        return count_result;
    }
    public void setCount_result(String count_result) {
        this.count_result = count_result;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getC_riregdate() {
        return c_riregdate;
    }
    public void setC_riregdate(String c_riregdate) {
        this.c_riregdate = c_riregdate;
    }
    public String getC_dikeycode() {
        return c_dikeycode;
    }
    public void setC_dikeycode(String c_dikeycode) {
        this.c_dikeycode = c_dikeycode;
    }
    public String getC_wikey() {
        return c_wikey;
    }
    public void setC_wikey(String c_wikey) {
        this.c_wikey = c_wikey;
    }
    public String getC_aikeycode() {
        return c_aikeycode;
    }
    public void setC_aikeycode(String c_aikeycode) {
        this.c_aikeycode = c_aikeycode;
    }
    public String getC_winame() {
        return c_winame;
    }
    public void setC_winame(String c_winame) {
        this.c_winame = c_winame;
    }
    public String getC_ainame() {
        return c_ainame;
    }
    public void setC_ainame(String c_ainame) {
        this.c_ainame = c_ainame;
    }
    public String getC_wicard() {
        return c_wicard;
    }
    public void setC_wicard(String c_wicard) {
        this.c_wicard = c_wicard;
    }
    public String getC_dititle() {
        return c_dititle;
    }
    public void setC_dititle(String c_dititle) {
        this.c_dititle = c_dititle;
    }
    public String getC_draftcause() {
        return c_draftcause;
    }
    public void setC_draftcause(String c_draftcause) {
        this.c_draftcause = c_draftcause;
    }
    public String getC_didrafttime() {
        return c_didrafttime;
    }
    public void setC_didrafttime(String c_didrafttime) {
        this.c_didrafttime = c_didrafttime;
    }
    public String getStandardcode() {
        return standardcode;
    }
    public void setStandardcode(String standardcode) {
        this.standardcode = standardcode;
    }
    public String getOrgan_nm() {
        return organ_nm;
    }
    public void setOrgan_nm(String organ_nm) {
        this.organ_nm = organ_nm;
    }
    public String getOrgnzt_id() {
        return orgnzt_id;
    }
    public void setOrgnzt_id(String orgnzt_id) {
        this.orgnzt_id = orgnzt_id;
    }
    public String getOrgnzt_nm() {
        return orgnzt_nm;
    }
    public void setOrgnzt_nm(String orgnzt_nm) {
        this.orgnzt_nm = orgnzt_nm;
    }
    public String getUser_nm() {
        return user_nm;
    }
    public void setUser_nm(String user_nm) {
        this.user_nm = user_nm;
    }
    public String getC_ridocnum() {
        return c_ridocnum;
    }
    public void setC_ridocnum(String c_ridocnum) {
        this.c_ridocnum = c_ridocnum;
    }
    public String getDocnumber() {
        return docnumber;
    }
    public void setDocnumber(String docnumber) {
        this.docnumber = docnumber;
    }
    public String getC_aipreserve() {
        return c_aipreserve;
    }
    public void setC_aipreserve(String c_aipreserve) {
        this.c_aipreserve = c_aipreserve;
    }
    public String getC_digrade() {
        return c_digrade;
    }
    public void setC_digrade(String c_digrade) {
        this.c_digrade = c_digrade;
    }
    public String getC_dipublicbasic() {
        return c_dipublicbasic;
    }
    public void setC_dipublicbasic(String c_dipublicbasic) {
        this.c_dipublicbasic = c_dipublicbasic;
    }
    public String getC_dipubliccause() {
        return c_dipubliccause;
    }
    public void setC_dipubliccause(String c_dipubliccause) {
        this.c_dipubliccause = c_dipubliccause;
    }
    public String getReceivenum() {
        return receivenum;
    }
    public void setReceivenum(String receivenum) {
        this.receivenum = receivenum;
    }
    public String getC_ritypeflag() {
        return c_ritypeflag;
    }
    public void setC_ritypeflag(String c_ritypeflag) {
        this.c_ritypeflag = c_ritypeflag;
    }
    public String getC_ridocnum2() {
        return c_ridocnum2;
    }
    public void setC_ridocnum2(String c_ridocnum2) {
        this.c_ridocnum2 = c_ridocnum2;
    }
    public String getC_dititle2() {
        return c_dititle2;
    }
    public void setC_dititle2(String c_dititle2) {
        this.c_dititle2 = c_dititle2;
    }
    public String getC_dipublicyn() {
        return c_dipublicyn;
    }
    public void setC_dipublicyn(String c_dipublicyn) {
        this.c_dipublicyn = c_dipublicyn;
    }
    public String getDocinfocode() {
        return docinfocode;
    }
    public void setDocinfocode(String docinfocode) {
        this.docinfocode = docinfocode;
    }
    public String getNew_upt() {
        return new_upt;
    }
    public void setNew_upt(String new_upt) {
        this.new_upt = new_upt;
    }
    public String getC_klusername() {
        return c_klusername;
    }
    public void setC_klusername(String c_klusername) {
        this.c_klusername = c_klusername;
    }
    public String getC_klorgcode() {
        return c_klorgcode;
    }
    public void setC_klorgcode(String c_klorgcode) {
        this.c_klorgcode = c_klorgcode;
    }
    public String getView_regdate() {
        return view_regdate;
    }
    public void setView_regdate(String view_regdate) {
        this.view_regdate = view_regdate;
    }
    public String getC_aikeycode2() {
        return c_aikeycode2;
    }
    public void setC_aikeycode2(String c_aikeycode2) {
        this.c_aikeycode2 = c_aikeycode2;
    }
    public String getRecord_receive() {
        return record_receive;
    }
    public void setRecord_receive(String record_receive) {
        this.record_receive = record_receive;
    }
    public String getDoc_sys() {
        return doc_sys;
    }
    public void setDoc_sys(String doc_sys) {
        this.doc_sys = doc_sys;
    }
    public String getC_aidata() {
        return c_aidata;
    }
    public void setC_aidata(String c_aidata) {
        this.c_aidata = c_aidata;
    }
    
    @Override
    public PaginationInfo getPaginationInfo() {
        
        PaginationInfo paginationInfo = super.getPaginationInfo();      
        int num = paginationInfo.getCurrentPageNo();

        if(num==0){

            paginationInfo.setCurrentPageNo(1);
            paginationInfo.setPageSize(1);
            paginationInfo.setRecordCountPerPage(1);
            paginationInfo.setTotalRecordCount(1);
        }
        
        return paginationInfo;
    }
    
}
 

