package ac.g20.ex.vo;

/**
 * 
 * @title Abdocu_TH.java
 * @author doban7
 *
 * @date 2016. 10. 3.
 */

public class Abdocu_TH {

    private String sessionid;
    private String abdocu_no;
    private String abdocu_th_no;
    private String erp_co_cd;
    private String erp_isu_dt;
    private String erp_isu_sq;
    private String erp_emp_cd;
    
    private String ts_dt;
    private String te_dt;
    private String tday_cnt;
    private String site_nm;
    private String ontrip_nm;
    private String req_nm;
    private String rsv_nm;
    
    /*정산급 */
    private String scost_am;
    /*개산급*/
    private String rcost_am;

    private String site_nmk;
    private String ontrip_nmk;
    private String req_nmk;
    private String rsv_nmk;
    
    /*등록, 수정자 정보 */
    private String insert_id;
    private String insert_ip;
    private String insert_dt;
    private String modify_id;
    private String modify_ip;
    private String modify_dt;
    
    private String ts_dt_str;
    private String te_dt_str;
    
    /** 선택한 출장신청서 번호 2015-01-27 이혜영**/
    private String biztrip_appl_id;  
    
    public String getSessionid() {
        return sessionid;
    }
    public void setSessionid(String sessionid) {
        this.sessionid = sessionid;
    }
    public String getAbdocu_no() {
        return abdocu_no;
    }
    public void setAbdocu_no(String abdocu_no) {
        this.abdocu_no = abdocu_no;
    }
    public String getAbdocu_th_no() {
        return abdocu_th_no;
    }
    public void setAbdocu_th_no(String abdocu_th_no) {
        this.abdocu_th_no = abdocu_th_no;
    }
    public String getErp_co_cd() {
        return erp_co_cd;
    }
    public void setErp_co_cd(String erp_co_cd) {
        this.erp_co_cd = erp_co_cd;
    }
    public String getErp_emp_cd() {
        return erp_emp_cd;
    }
    public void setErp_emp_cd(String erp_emp_cd) {
        this.erp_emp_cd = erp_emp_cd;
    }
    public String getErp_isu_dt() {
        return erp_isu_dt;
    }
    public void setErp_isu_dt(String erp_isu_dt) {
        this.erp_isu_dt = erp_isu_dt;
    }
    public String getErp_isu_sq() {
        return erp_isu_sq;
    }
    public void setErp_isu_sq(String erp_isu_sq) {
        this.erp_isu_sq = erp_isu_sq;
    }
    public String getTs_dt() {
        return ts_dt;
    }
    public void setTs_dt(String ts_dt) {
        this.ts_dt = ts_dt;
    }
    public String getTe_dt() {
        return te_dt;
    }
    public void setTe_dt(String te_dt) {
        this.te_dt = te_dt;
    }
    public String getTday_cnt() {
        return tday_cnt;
    }
    public void setTday_cnt(String tday_cnt) {
        this.tday_cnt = tday_cnt;
    }
    public String getSite_nm() {
        return site_nm;
    }
    public void setSite_nm(String site_nm) {
        this.site_nm = site_nm;
    }
    public String getOntrip_nm() {
        return ontrip_nm;
    }
    public void setOntrip_nm(String ontrip_nm) {
        this.ontrip_nm = ontrip_nm;
    }
    public String getReq_nm() {
        return req_nm;
    }
    public void setReq_nm(String req_nm) {
        this.req_nm = req_nm;
    }
    public String getRsv_nm() {
        return rsv_nm;
    }
    public void setRsv_nm(String rsv_nm) {
        this.rsv_nm = rsv_nm;
    }
    public String getScost_am() {
        return scost_am;
    }
    public void setScost_am(String scost_am) {
        this.scost_am = scost_am;
    }
    public String getRcost_am() {
        return rcost_am;
    }
    public void setRcost_am(String rcost_am) {
        this.rcost_am = rcost_am;
    }
    public String getSite_nmk() {
        return site_nmk;
    }
    public void setSite_nmk(String site_nmk) {
        this.site_nmk = site_nmk;
    }
    public String getOntrip_nmk() {
        return ontrip_nmk;
    }
    public void setOntrip_nmk(String ontrip_nmk) {
        this.ontrip_nmk = ontrip_nmk;
    }
    public String getReq_nmk() {
        return req_nmk;
    }
    public void setReq_nmk(String req_nmk) {
        this.req_nmk = req_nmk;
    }
    public String getRsv_nmk() {
        return rsv_nmk;
    }
    public void setRsv_nmk(String rsv_nmk) {
        this.rsv_nmk = rsv_nmk;
    }
    public String getInsert_id() {
        return insert_id;
    }
    public void setInsert_id(String insert_id) {
        this.insert_id = insert_id;
    }
    public String getInsert_ip() {
        return insert_ip;
    }
    public void setInsert_ip(String insert_ip) {
        this.insert_ip = insert_ip;
    }
    public String getInsert_dt() {
        return insert_dt;
    }
    public void setInsert_dt(String insert_dt) {
        this.insert_dt = insert_dt;
    }
    public String getModify_id() {
        return modify_id;
    }
    public void setModify_id(String modify_id) {
        this.modify_id = modify_id;
    }
    public String getModify_ip() {
        return modify_ip;
    }
    public void setModify_ip(String modify_ip) {
        this.modify_ip = modify_ip;
    }
    public String getModify_dt() {
        return modify_dt;
    }
    public void setModify_dt(String modify_dt) {
        this.modify_dt = modify_dt;
    }
    public String getTs_dt_str() {
        return ts_dt_str;
    }
    public void setTs_dt_str(String ts_dt_str) {
        this.ts_dt_str = ts_dt_str;
    }
    public String getTe_dt_str() {
        return te_dt_str;
    }
    public void setTe_dt_str(String te_dt_str) {
        this.te_dt_str = te_dt_str;
    }
    public String getBiztrip_appl_id() {
        return biztrip_appl_id;
    }
    public void setBiztrip_appl_id(String biztrip_appl_id) {
        this.biztrip_appl_id = biztrip_appl_id;
    }
    
    
}
 

