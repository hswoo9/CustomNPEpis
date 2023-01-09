package ac.g20.ex.vo;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
/**
 * 
 * @title Abdocu_H.java
 * @author doban7
 *
 * @date 2016. 9. 6.
 */
public class Abdocu_H {

    private String sessionid;
    private String rmk_dc;
    private String modify_id;
    private String modify_dt;
    private String mgt_nm;
    private String mgt_nm_encoding;

    private String mgt_cd;
    private String insert_id;
    private String insert_dt;
    private String erp_year;
    private String erp_gisu_to_dt;
    private String erp_gisu_sq;
    private String erp_gisu_from_dt;
    private String erp_gisu_dt;
    private String erp_acisu_dt;
    
    private String erp_gisu;
    private String erp_emp_nm;
    private String erp_emp_cd;
    private String erp_div_nm;
    private String erp_div_cd;
    private String erp_dept_nm;
    private String erp_dept_cd;
    private String erp_co_cd;
    private String erp_co_nm;
    private String edit_proc;
    private String docu_mode;
    private String docu_fg;
    private String docu_fg_text;
    private String btr_nm;
    private String btr_cd;
    private String bottom_nm;
    private String bottom_cd;
    private String abdocu_no_reffer;
    private String abdocu_no;
    
    private String abdocu_no_new;
    
    private String c_dikeycode;
    private String sanction_no;
    private String docnumber;
    private String btr_nb;
    /*로그인 사원의 erp 정보 */
    private String tmp_dept_nm;   //부서명
    private String tmp_dept_cd;   // 부서코드
    private String tmp_emp_nm;  // 사원명
    private String tmp_emp_cd;  //사원코드

    private String cause_dt;    // 원인행위
    private String sign_dt;     // 계약일
    private String inspect_dt; //검수일  
    private String cause_id;  // 원인행위자 코드
    private String cause_nm; //원인행위자명
    
    private String hc_nm;
    private String hc_cd;
    
    private String complete_yn ;
    
    @SuppressWarnings("unused")
    private String[] date;
    
    private String it_businessLink;

    private List<HashMap<String, Object>>  erpgisu;
    
    private String purc_req_id;
    
    private String purc_req_h_id;
    
    private String purc_cont_id;
    
    private String cont_am;
    
    private String compSeq;
    
    private String compName;
    
    private String deptSeq;
    
    private String deptName;
    
    private String empSeq;
    
    private String empName;
    
    private String outProcessInterfaceId;
    
    private String outProcessInterfaceMId;
    
    private String outProcessInterfaceDId;
    
    private String consDocSeq;
    
    private String consSeq;
    
    private String totalAmt;
    
//-----------------------------------------------------------------------------------------------    
    
    
    
    public String getTotalAmt() {
		return totalAmt;
	}

	public void setTotalAmt(String totalAmt) {
		this.totalAmt = totalAmt;
	}

	public String getConsDocSeq() {
		return consDocSeq;
	}

	public void setConsDocSeq(String consDocSeq) {
		this.consDocSeq = consDocSeq;
	}

	public String getConsSeq() {
		return consSeq;
	}

	public void setConsSeq(String consSeq) {
		this.consSeq = consSeq;
	}

	public String getCompSeq() {
		return compSeq;
	}

	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}



	public String getCompName() {
		return compName;
	}



	public void setCompName(String compName) {
		this.compName = compName;
	}



	public String getDeptSeq() {
		return deptSeq;
	}



	public void setDeptSeq(String deptSeq) {
		this.deptSeq = deptSeq;
	}



	public String getDeptName() {
		return deptName;
	}



	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}



	public String getEmpSeq() {
		return empSeq;
	}



	public void setEmpSeq(String empSeq) {
		this.empSeq = empSeq;
	}



	public String getEmpName() {
		return empName;
	}



	public void setEmpName(String empName) {
		this.empName = empName;
	}



	public String getOutProcessInterfaceId() {
		return outProcessInterfaceId;
	}



	public void setOutProcessInterfaceId(String outProcessInterfaceId) {
		this.outProcessInterfaceId = outProcessInterfaceId;
	}



	public String getOutProcessInterfaceMId() {
		return outProcessInterfaceMId;
	}



	public void setOutProcessInterfaceMId(String outProcessInterfaceMId) {
		this.outProcessInterfaceMId = outProcessInterfaceMId;
	}



	public String getOutProcessInterfaceDId() {
		return outProcessInterfaceDId;
	}



	public void setOutProcessInterfaceDId(String outProcessInterfaceDId) {
		this.outProcessInterfaceDId = outProcessInterfaceDId;
	}



	public String getSessionid() {
        return sessionid;
    }



    public String getAbdocu_no_reffer() {
        return abdocu_no_reffer;
    }



    public void setAbdocu_no_reffer(String abdocu_no_reffer) {
        this.abdocu_no_reffer = abdocu_no_reffer;
    }



    public String getDocnumber() {
        return docnumber;
    }



    public void setDocnumber(String docnumber) {
        this.docnumber = docnumber;
    }



    public String getDocu_fg_text() {
        return docu_fg_text;
    }



    public void setDocu_fg_text(String docu_fg_text) {
        this.docu_fg_text = docu_fg_text;
    }



    public String getC_dikeycode() {
        return c_dikeycode;
    }



    public void setC_dikeycode(String c_dikeycode) {
        this.c_dikeycode = c_dikeycode;
    }



    public String getSanction_no() {
        return sanction_no;
    }



    public void setSanction_no(String sanction_no) {
        this.sanction_no = sanction_no;
    }



    public void setSessionid(String sessionid) {
        this.sessionid = sessionid;
    }



    public String getRmk_dc() {
        return rmk_dc;
    }



    public void setRmk_dc(String rmk_dc) {
        this.rmk_dc = rmk_dc;
    }



    public String getModify_id() {
        return modify_id;
    }



    public void setModify_id(String modify_id) {
        this.modify_id = modify_id;
    }



    public String getModify_dt() {
        return modify_dt;
    }



    public void setModify_dt(String modify_dt) {
        this.modify_dt = modify_dt;
    }



    public String getMgt_nm() {
        
        try {
            return URLDecoder.decode(mgt_nm, "UTF-8");
        }
        catch(Exception e) {
            return "";
        }
    }

    public void setMgt_nm(String mgt_nm) {

        this.mgt_nm = mgt_nm;
    }

    public String getMgt_cd() {
        //java.net.URLEncoder.

        return mgt_cd;
    }



    public void setMgt_cd(String mgt_cd) {
        this.mgt_cd = mgt_cd;
    }



    public String getInsert_id() {
        return insert_id;
    }



    public void setInsert_id(String insert_id) {
        this.insert_id = insert_id;
    }



    public String getInsert_dt() {
        return insert_dt;
    }



    public void setInsert_dt(String insert_dt) {
        this.insert_dt = insert_dt;
    }



    public String getErp_year() {
        return erp_year;
    }



    public void setErp_year(String erp_year) {
        this.erp_year = erp_year;
    }



    public String getErp_gisu_to_dt() {
        return erp_gisu_to_dt;
    }



    public void setErp_gisu_to_dt(String erp_gisu_to_dt) {
        this.erp_gisu_to_dt = erp_gisu_to_dt;
    }



    public String getErp_gisu_sq() {
        return erp_gisu_sq;
    }



    public void setErp_gisu_sq(String erp_gisu_sq) {
        this.erp_gisu_sq = erp_gisu_sq;
    }



    public String getErp_gisu_from_dt() {
        return erp_gisu_from_dt;
    }



    public void setErp_gisu_from_dt(String erp_gisu_from_dt) {
        this.erp_gisu_from_dt = erp_gisu_from_dt;
    }



    public String getErp_gisu_dt() {
        return erp_gisu_dt;
    }

    public String getErp_acisu_dt() {
        return erp_acisu_dt;
    }

    public void setErp_gisu_dt(String erp_gisu_dt) {
        this.erp_gisu_dt = erp_gisu_dt;
    }

    public void setErp_acisu_dt(String erp_acisu_dt) {
        this.erp_acisu_dt = erp_acisu_dt;
    }


    public String getErp_gisu() {
        return erp_gisu;
    }



    public void setErp_gisu(String erp_gisu) {
        this.erp_gisu = erp_gisu;
    }



    public String getErp_emp_nm() {
        return erp_emp_nm;
    }



    public void setErp_emp_nm(String erp_emp_nm) {
        this.erp_emp_nm = erp_emp_nm;
    }



    public String getErp_emp_cd() {
        return erp_emp_cd;
    }



    public void setErp_emp_cd(String erp_emp_cd) {
        this.erp_emp_cd = erp_emp_cd;
    }



    public String getErp_div_nm() {
        return erp_div_nm;
    }



    public void setErp_div_nm(String erp_div_nm) {
        this.erp_div_nm = erp_div_nm;
    }



    public String getErp_div_cd() {
        return erp_div_cd;
    }



    public void setErp_div_cd(String erp_div_cd) {
        this.erp_div_cd = erp_div_cd;
    }



    public String getErp_dept_nm() {
        return erp_dept_nm;
    }



    public void setErp_dept_nm(String erp_dept_nm) {
        this.erp_dept_nm = erp_dept_nm;
    }



    public String getErp_dept_cd() {
        return erp_dept_cd;
    }



    public void setErp_dept_cd(String erp_dept_cd) {
        this.erp_dept_cd = erp_dept_cd;
    }



    public String getErp_co_cd() {
        return erp_co_cd;
    }



    public void setErp_co_cd(String erp_co_cd) {
        this.erp_co_cd = erp_co_cd;
    }



    public String getEdit_proc() {
        return edit_proc;
    }



    public void setEdit_proc(String edit_proc) {
        this.edit_proc = edit_proc;
    }



    public String getDocu_mode() {
        return docu_mode;
    }



    public void setDocu_mode(String docu_mode) {
        this.docu_mode = docu_mode;
    }



    public String getDocu_fg() {
        return docu_fg;
    }



    public void setDocu_fg(String docu_fg) {
        this.docu_fg = docu_fg;
    }



    public String getBtr_nm() {
        return btr_nm;
    }



    public void setBtr_nm(String btr_nm) {
        this.btr_nm = btr_nm;
    }



    public String getBtr_cd() {
        return btr_cd;
    }



    public void setBtr_cd(String btr_cd) {
        this.btr_cd = btr_cd;
    }



    public String getBottom_nm() {
        return bottom_nm;
    }



    public void setBottom_nm(String bottom_nm) {
        this.bottom_nm = bottom_nm;
    }



    public String getBottom_cd() {
    	if(bottom_cd == null){
    		return "";
    	}else{
    		return bottom_cd;
    	}
    }



    public void setBottom_cd(String bottom_cd) {
        this.bottom_cd = bottom_cd;
    }






    public String getAbdocu_no() {
        return abdocu_no;
    }



    public void setAbdocu_no(String abdocu_no) {
        this.abdocu_no = abdocu_no;
    }



    public List<HashMap<String, Object>> getErpgisu() {
        return erpgisu;
    }



    public void setErpgisu(List<HashMap<String, Object>> erpgisu) {
        this.erpgisu = erpgisu;
    }



    public void setDate(String[] date) {
        this.date = date;
    }




    
    
    
    //------------------------------------------------------------------------------------
    
    public String[] getDate() {
        String temp = erp_gisu_dt;

        if(temp !=null && temp.length()== 10 && temp.split("-").length==3){
            return temp.split("-");
        }
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); 
        SimpleDateFormat dateFormat2 = new SimpleDateFormat("yyyyMMdd");
        try {
			Date t_date = null;
			t_date = dateFormat2.parse(erp_gisu_dt);
			temp = dateFormat.format(t_date);
			return temp.split("-");
        	
		} catch (Exception e) {
	            
            temp = dateFormat.format(new Date());      
            return temp.split("-");
		}

    }

    public String getMgt_nm_encoding() {
        return mgt_nm;
    }



    public void setMgt_nm_encoding(String mgt_nm) {
        try {
            mgt_nm = URLEncoder.encode(mgt_nm, "UTF-8");
        }
        catch(UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        System.out.println("mgt_nm : " + mgt_nm);
        this.mgt_nm = mgt_nm;
    }
    
    public String toString(){
    	return "c_dikeycode : " + c_dikeycode + ", " + "abdocu_no : " + abdocu_no + ", " + "docu_mode : " + docu_mode;
    }



    public String getBtr_nb() {
        return btr_nb;
    }



    public void setBtr_nb(String btr_nb) {
        this.btr_nb = btr_nb;
    }



    public String getTmp_dept_nm() {
        return tmp_dept_nm;
    }



    public String getTmp_dept_cd() {
        return tmp_dept_cd;
    }



    public String getTmp_emp_nm() {
        return tmp_emp_nm;
    }



    public String getTmp_emp_cd() {
        return tmp_emp_cd;
    }



    public void setTmp_dept_nm(String tmp_dept_nm) {
        this.tmp_dept_nm = tmp_dept_nm;
    }



    public void setTmp_dept_cd(String tmp_dept_cd) {
        this.tmp_dept_cd = tmp_dept_cd;
    }



    public void setTmp_emp_nm(String tmp_emp_nm) {
        this.tmp_emp_nm = tmp_emp_nm;
    }



    public void setTmp_emp_cd(String tmp_emp_cd) {
        this.tmp_emp_cd = tmp_emp_cd;
    }



    public String getCause_dt() {
        return cause_dt;
    }



    public void setCause_dt(String cause_dt) {
        this.cause_dt = cause_dt;
    }



    public String getSign_dt() {
        return sign_dt;
    }



    public void setSign_dt(String sign_dt) {
        this.sign_dt = sign_dt;
    }



    public String getInspect_dt() {
        return inspect_dt;
    }



    public void setInspect_dt(String inspect_dt) {
        this.inspect_dt = inspect_dt;
    }



    public String getCause_id() {
        return cause_id;
    }



    public void setCause_id(String cause_id) {
        this.cause_id = cause_id;
    }



    public String getCause_nm() {
        return cause_nm;
    }



    public void setCause_nm(String cause_nm) {
        this.cause_nm = cause_nm;
    }



    public String getAbdocu_no_new() {
        return abdocu_no_new;
    }



    public void setAbdocu_no_new(String abdocu_no_new) {
        this.abdocu_no_new = abdocu_no_new;
    }

    public String getHc_nm() {
        return hc_nm;
    }
    public String getHc_cd() {
        return hc_cd;
    }

    public void setHc_nm(String hc_nm) {
        this.hc_nm = hc_nm;
    }
    public void setHc_cd(String hc_cd) {
        this.hc_cd = hc_cd;
    }



    public String getComplete_yn() {
        return complete_yn;
    }



    public void setComplete_yn(String complete_yn) {
        this.complete_yn = complete_yn;
    }



	public String getErp_co_nm() {
		return erp_co_nm;
	}



	public void setErp_co_nm(String erp_co_nm) {
		this.erp_co_nm = erp_co_nm;
	}



	public String getIt_businessLink() {
		return it_businessLink;
	}



	public void setIt_businessLink(String it_businessLink) {
		this.it_businessLink = it_businessLink;
	}



	public String getPurc_req_h_id() {
		return purc_req_h_id;
	}



	public void setPurc_req_h_id(String purc_req_h_id) {
		this.purc_req_h_id = purc_req_h_id;
	}



	public String getPurc_req_id() {
		return purc_req_id;
	}



	public void setPurc_req_id(String purc_req_id) {
		this.purc_req_id = purc_req_id;
	}



	public String getPurc_cont_id() {
		return purc_cont_id;
	}



	public void setPurc_cont_id(String purc_cont_id) {
		this.purc_cont_id = purc_cont_id;
	}



	public String getCont_am() {
		return cont_am;
	}



	public void setCont_am(String cont_am) {
		this.cont_am = cont_am;
	}

    
}
 

