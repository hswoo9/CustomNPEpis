package ac.g20.ex.vo;

/**
 * 
 * @title Abdocu_TD2.java
 * @author doban7
 *
 * @date 2016. 10. 3.
 */

public class Abdocu_TD2 {

    private String sessionid;
    private String abdocu_no;
    private String abdocu_td2_no;
    private String erp_co_cd;
    private String erp_isu_dt;
    private String erp_isu_sq;
    private String erp_ln_sq;
    
    /*사원정보*/
    private String emp_nm;
    private String dept_nm;
    private String class_nm;
    private String hcls_nm;
    
    /* 출장정보 */
    private String trip_dt;
    private String nt_cnt;
    private String day_cnt;
    
    private String start_nm;
    private String cross_nm;
    private String arr_nm;
    private String jong_nm;
    private String trmk_dc;
    
    private String km_am;
    private String fair_am;
    /*다국어 */
    private String start_nmk;
    private String cross_nmk;
    private String arr_nmk;
    private String jong_nmk;
    private String trmk_dck;
    
    private String memo_cd;
    private String check_pen;
    
    /* 금액 */
    private String day_am;
    private String food_am;
    private String room_am;
    private String other_am;
    private String total_am;
    
    private String biztrip_appl_id;
    private String biztrip_no_seq;
    private String trip_dt_str;
    
    /* 국가과학기술연구원 */
    private String trip_dt2;		// 종료일
    private String na_day_am ;
    private String na_room_am;
    private String na_food_am;
    private String trip_dt2_str;
    
    
    public String getNa_day_am() {
		return na_day_am;
	}
	public void setNa_day_am(String na_day_am) {
		this.na_day_am = na_day_am;
	}
	public String getNa_room_am() {
		return na_room_am;
	}
	public void setNa_room_am(String na_room_am) {
		this.na_room_am = na_room_am;
	}
	public String getNa_food_am() {
		return na_food_am;
	}
	public void setNa_food_am(String na_food_am) {
		this.na_food_am = na_food_am;
	}
	public String getTotal_am() {
        return total_am;
    }
    public void setTotal_am(String total_am) {
        this.total_am = total_am;
    }
    
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
    public String getAbdocu_td2_no() {
        return abdocu_td2_no;
    }
    public void setAbdocu_td2_no(String abdocu_td2_no) {
        this.abdocu_td2_no = abdocu_td2_no;
    }
    public String getErp_co_cd() {
        return erp_co_cd;
    }
    public void setErp_co_cd(String erp_co_cd) {
        this.erp_co_cd = erp_co_cd;
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
    public String getErp_ln_sq() {
        return erp_ln_sq;
    }
    public void setErp_ln_sq(String erp_ln_sq) {
        this.erp_ln_sq = erp_ln_sq;
    }
    public String getEmp_nm() {
        return emp_nm;
    }
    public void setEmp_nm(String emp_nm) {
        this.emp_nm = emp_nm;
    }
    public String getDept_nm() {
        return dept_nm;
    }
    public void setDept_nm(String dept_nm) {
        this.dept_nm = dept_nm;
    }
    public String getClass_nm() {
        return class_nm;
    }
    public void setClass_nm(String class_nm) {
        this.class_nm = class_nm;
    }
    public String getHcls_nm() {
        return hcls_nm;
    }
    public void setHcls_nm(String hcls_nm) {
        this.hcls_nm = hcls_nm;
    }
    public String getTrip_dt() {
        return trip_dt;
    }
    public void setTrip_dt(String trip_dt) {
        this.trip_dt = trip_dt;
    }
    public String getNt_cnt() {
        return nt_cnt;
    }
    public void setNt_cnt(String nt_cnt) {
        this.nt_cnt = nt_cnt;
    }
    public String getDay_cnt() {
        return day_cnt;
    }
    public void setDay_cnt(String day_cnt) {
        this.day_cnt = day_cnt;
    }
    public String getStart_nm() {
        return start_nm;
    }
    public void setStart_nm(String start_nm) {
        this.start_nm = start_nm;
    }
    public String getCross_nm() {
        return cross_nm;
    }
    public void setCross_nm(String cross_nm) {
        this.cross_nm = cross_nm;
    }
    public String getArr_nm() {
        return arr_nm;
    }
    public void setArr_nm(String arr_nm) {
        this.arr_nm = arr_nm;
    }
    public String getJong_nm() {
        return jong_nm;
    }
    public void setJong_nm(String jong_nm) {
        this.jong_nm = jong_nm;
    }
    public String getTrmk_dc() {
        return trmk_dc;
    }
    public void setTrmk_dc(String trmk_dc) {
        this.trmk_dc = trmk_dc;
    }
    public String getKm_am() {
        return km_am;
    }
    public void setKm_am(String km_am) {
        this.km_am = km_am;
    }
    public String getFair_am() {
        return fair_am;
    }
    public void setFair_am(String fair_am) {
        this.fair_am = fair_am;
    }
    public String getStart_nmk() {
        return start_nmk;
    }
    public void setStart_nmk(String start_nmk) {
        this.start_nmk = start_nmk;
    }
    public String getCross_nmk() {
        return cross_nmk;
    }
    public void setCross_nmk(String cross_nmk) {
        this.cross_nmk = cross_nmk;
    }
    public String getArr_nmk() {
        return arr_nmk;
    }
    public void setArr_nmk(String arr_nmk) {
        this.arr_nmk = arr_nmk;
    }
    public String getJong_nmk() {
        return jong_nmk;
    }
    public void setJong_nmk(String jong_nmk) {
        this.jong_nmk = jong_nmk;
    }
    public String getTrmk_dck() {
        return trmk_dck;
    }
    public void setTrmk_dck(String trmk_dck) {
        this.trmk_dck = trmk_dck;
    }
    public String getMemo_cd() {
        return memo_cd;
    }
    public void setMemo_cd(String memo_cd) {
        this.memo_cd = memo_cd;
    }
    public String getCheck_pen() {
        return check_pen;
    }
    public void setCheck_pen(String check_pen) {
        this.check_pen = check_pen;
    }
    public String getDay_am() {
        return day_am;
    }
    public void setDay_am(String day_am) {
        this.day_am = day_am;
    }
    public String getFood_am() {
        return food_am;
    }
    public void setFood_am(String food_am) {
        this.food_am = food_am;
    }
    public String getRoom_am() {
        return room_am;
    }
    public void setRoom_am(String room_am) {
        this.room_am = room_am;
    }
    public String getOther_am() {
        return other_am;
    }
    public void setOther_am(String other_am) {
        this.other_am = other_am;
    }
    public String getTrip_dt_str() {
        return trip_dt_str;
    }
    public void setTrip_dt_str(String trip_dt_str) {
        this.trip_dt_str = trip_dt_str;
    }
    public String getBiztrip_appl_id() {
        return biztrip_appl_id;
    }
    public void setBiztrip_appl_id(String biztrip_appl_id) {
        this.biztrip_appl_id = biztrip_appl_id;
    }
    public String getBiztrip_no_seq() {
        return biztrip_no_seq;
    }
    public void setBiztrip_no_seq(String biztrip_no_seq) {
        this.biztrip_no_seq = biztrip_no_seq;
    }
	public String getTrip_dt2() {
		return trip_dt2;
	}
	public void setTrip_dt2(String trip_dt2) {
		this.trip_dt2 = trip_dt2;
	}
	public String getTrip_dt2_str() {
		return trip_dt2_str;
	}
	public void setTrip_dt2_str(String trip_dt2_str) {
		this.trip_dt2_str = trip_dt2_str;
	}
        
}
 

