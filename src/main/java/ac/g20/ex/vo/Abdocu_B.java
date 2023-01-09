package ac.g20.ex.vo;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

/**
 * 
 * @title Abdocu_B.java
 * @author doban7
 *
 * @date 2016. 9. 7.
 */
public class Abdocu_B {

    private String vat_fg;            
    private String tran_cd;           
    private String tr_fg;             
    private String set_fg;            
    private String sessionid;         
    private String rmk_dc;            
    private String modify_id;         
    private String modify_dt;         
    private String it_use_way;        
    private String insert_id;         
    private String insert_dt;         
    private String open_am;
    private String apply_am;
    private String erp_gisu_sq;       
    private String erp_gisu_dt;       
    private String erp_co_cd;         
    private String erp_bq_sq;         
    private String erp_bk_sq;         
    private String erp_bgt_nm4;       
    private String erp_bgt_nm3;       
    private String erp_bgt_nm2;       
    private String erp_bgt_nm1;       
    private String docu_mode;         
    private String div_nm2;           
    private String div_cd2;           
    private String ctl_fg;            
    private String bank_sq;           
    private String bank_dt;           
    private String abgt_nm;           
    private String abgt_cd;           
    private String abdocu_no;
    private String abdocu_no_new;
    private String abdocu_b_no;
    private String abdocu_b_no_new;
    private String erp_emp_cd;
    private String abdocu_no_reffer;
    private String confer_return;
    
    private String abdocu_b_no_reffer;
    
    private String tr_fg_nm;             
    private String set_fg_nm;     
    private String vat_fg_nm;
    
    private String it_sbgtcdLink;
    
    private String purc_req_id;
    private String purc_req_h_id;
    private String purc_req_b_id;
    private String return_yn;
    private String purc_tr_type;
    
    private String purc_cont_id;
    private String purc_cont_b_id;
    
    private String apply_am2;
    
    private String mgt_nm;
    private String mgt_cd;
    private String mgt_nm_encoding;
    
    private String exec_am;
    private String refer_am;
    private String left_am;
    private String bottom_nm;
    private String bottom_cd;
    
    private String erp_gisu_from_dt;
    private String erp_gisu_to_dt;
    private String erp_gisu;
    
    private String cons_doc_seq;
    
    private String erp_bgt_cd4;       
    private String erp_bgt_cd3;       
    private String erp_bgt_cd2;       
    private String erp_bgt_cd1;
    
    private String ctl_fg_nm;
    
    /*G20 2.0 예산 파라미터 추가 - 2020.03.19*/
    private String erp_open_amt;		// erp 예산 편성 금액
    private String erp_apply_amt;		// erp 예산 결의 금액
    private String erp_res_amt;			// erp 원인행위 금액(사용X)
    private String erp_left_amt;		// erp 예산잔액
    private String gw_balance_amt;		// 작성시점 그룹웨어 예산 잔액(erp_left_amt - (그룹웨어 품의금액 - erp 미전송 결의금액) 
    private String budget_std_amt;		// 부가세 대급금
    private String budget_tax_amt;		// 부가세
    private String budget_amt;			// 사용 예산 금액 (budget_std_amt + budget_tax_amt)
    private String tr_cnt;
    /*G20 2.0 예산 파라미터 추가 - 2020.03.19*/
    
    public String getTr_cnt() {
		return tr_cnt;
	}
	public void setTr_cnt(String tr_cnt) {
		this.tr_cnt = tr_cnt;
	}
	public String getErp_open_amt() {
		return erp_open_amt;
	}
	public void setErp_open_amt(String erp_open_amt) {
		this.erp_open_amt = erp_open_amt;
	}
	public String getErp_apply_amt() {
		return erp_apply_amt;
	}
	public void setErp_apply_amt(String erp_apply_amt) {
		this.erp_apply_amt = erp_apply_amt;
	}
	public String getErp_res_amt() {
		return erp_res_amt;
	}
	public void setErp_res_amt(String erp_res_amt) {
		this.erp_res_amt = erp_res_amt;
	}
	public String getErp_left_amt() {
		return erp_left_amt;
	}
	public void setErp_left_amt(String erp_left_amt) {
		this.erp_left_amt = erp_left_amt;
	}
	public String getGw_balance_amt() {
		return gw_balance_amt;
	}
	public void setGw_balance_amt(String gw_balance_amt) {
		this.gw_balance_amt = gw_balance_amt;
	}
	public String getBudget_std_amt() {
		return budget_std_amt;
	}
	public void setBudget_std_amt(String budget_std_amt) {
		this.budget_std_amt = budget_std_amt;
	}
	public String getBudget_tax_amt() {
		return budget_tax_amt;
	}
	public void setBudget_tax_amt(String budget_tax_amt) {
		this.budget_tax_amt = budget_tax_amt;
	}
	public String getBudget_amt() {
		return budget_amt;
	}
	public void setBudget_amt(String budget_amt) {
		this.budget_amt = budget_amt;
	}
	public String getCtl_fg_nm() {
		return ctl_fg_nm;
	}
	public void setCtl_fg_nm(String ctl_fg_nm) {
		this.ctl_fg_nm = ctl_fg_nm;
	}
	public String getCons_doc_seq() {
		return cons_doc_seq;
	}
	public void setCons_doc_seq(String cons_doc_seq) {
		this.cons_doc_seq = cons_doc_seq;
	}
	public String getErp_bgt_cd4() {
		return erp_bgt_cd4;
	}
	public void setErp_bgt_cd4(String erp_bgt_cd4) {
		this.erp_bgt_cd4 = erp_bgt_cd4;
	}
	public String getErp_bgt_cd3() {
		return erp_bgt_cd3;
	}
	public void setErp_bgt_cd3(String erp_bgt_cd3) {
		this.erp_bgt_cd3 = erp_bgt_cd3;
	}
	public String getErp_bgt_cd2() {
		return erp_bgt_cd2;
	}
	public void setErp_bgt_cd2(String erp_bgt_cd2) {
		this.erp_bgt_cd2 = erp_bgt_cd2;
	}
	public String getErp_bgt_cd1() {
		return erp_bgt_cd1;
	}
	public void setErp_bgt_cd1(String erp_bgt_cd1) {
		this.erp_bgt_cd1 = erp_bgt_cd1;
	}
	private String next_am;
    
    public String getExec_am() {
		return exec_am;
	}
	public void setExec_am(String exec_am) {
		this.exec_am = exec_am;
	}
	public String getRefer_am() {
		return refer_am;
	}
	public void setRefer_am(String refer_am) {
		this.refer_am = refer_am;
	}
	public String getLeft_am() {
		return left_am;
	}
	public void setLeft_am(String left_am) {
		this.left_am = left_am;
	}
	public String getErp_emp_cd() {
        return erp_emp_cd;
    }
    public String getAbdocu_no_reffer() {
        return abdocu_no_reffer;
    }
    public void setAbdocu_no_reffer(String abdocu_no_reffer) {
        this.abdocu_no_reffer = abdocu_no_reffer;
    }
   
    public String getOpen_am() {
        return open_am;
    }
    public void setOpen_am(String open_am) {
        this.open_am = open_am;
    }
    public String getApply_am() {
        return apply_am;
    }
    public void setApply_am(String apply_am) {
        this.apply_am = apply_am;
    }
    public void setErp_emp_cd(String erp_emp_cd) {
        this.erp_emp_cd = erp_emp_cd;
    }
    public String getVat_fg() {
        return vat_fg;
    }
    public void setVat_fg(String vat_fg) {
        this.vat_fg = vat_fg;
    }
    public String getTran_cd() {
        return tran_cd;
    }
    public void setTran_cd(String tran_cd) {
        this.tran_cd = tran_cd;
    }
    public String getTr_fg() {
        return tr_fg;
    }
    public void setTr_fg(String tr_fg) {
        this.tr_fg = tr_fg;
    }
    public String getSet_fg() {
        return set_fg;
    }
    public void setSet_fg(String set_fg) {
        this.set_fg = set_fg;
    }
    public String getSessionid() {
        return sessionid;
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
    public String getIt_use_way() {
        return it_use_way;
    }
    public void setIt_use_way(String it_use_way) {
        this.it_use_way = it_use_way;
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
    public String getErp_gisu_sq() {
        return erp_gisu_sq;
    }
    public void setErp_gisu_sq(String erp_gisu_sq) {
        this.erp_gisu_sq = erp_gisu_sq;
    }
    public String getErp_gisu_dt() {
        return erp_gisu_dt;
    }
    public void setErp_gisu_dt(String erp_gisu_dt) {
        this.erp_gisu_dt = erp_gisu_dt;
    }
    public String getErp_co_cd() {
        return erp_co_cd;
    }
    public void setErp_co_cd(String erp_co_cd) {
        this.erp_co_cd = erp_co_cd;
    }
    public String getErp_bq_sq() {
        return erp_bq_sq;
    }
    public void setErp_bq_sq(String erp_bq_sq) {
        this.erp_bq_sq = erp_bq_sq;
    }
    public String getErp_bk_sq() {
        return erp_bk_sq;
    }
    public void setErp_bk_sq(String erp_bk_sq) {
        this.erp_bk_sq = erp_bk_sq;
    }
    public String getErp_bgt_nm4() {
        return erp_bgt_nm4;
    }
    public void setErp_bgt_nm4(String erp_bgt_nm4) {
        this.erp_bgt_nm4 = erp_bgt_nm4;
    }
    public String getErp_bgt_nm3() {
        return erp_bgt_nm3;
    }
    public void setErp_bgt_nm3(String erp_bgt_nm3) {
        this.erp_bgt_nm3 = erp_bgt_nm3;
    }
    public String getErp_bgt_nm2() {
        return erp_bgt_nm2;
    }
    public void setErp_bgt_nm2(String erp_bgt_nm2) {
        this.erp_bgt_nm2 = erp_bgt_nm2;
    }
    public String getErp_bgt_nm1() {
        return erp_bgt_nm1;
    }
    public void setErp_bgt_nm1(String erp_bgt_nm1) {
        this.erp_bgt_nm1 = erp_bgt_nm1;
    }
    public String getDocu_mode() {
        return docu_mode;
    }
    public void setDocu_mode(String docu_mode) {
        this.docu_mode = docu_mode;
    }
    public String getDiv_nm2() {
        return div_nm2;
    }
    public void setDiv_nm2(String div_nm2) {
        this.div_nm2 = div_nm2;
    }
    public String getDiv_cd2() {
        return div_cd2;
    }
    public void setDiv_cd2(String div_cd2) {
        this.div_cd2 = div_cd2;
    }
    public String getCtl_fg() {
        return ctl_fg;
    }
    public void setCtl_fg(String ctl_fg) {
        this.ctl_fg = ctl_fg;
    }
    public String getBank_sq() {
        return bank_sq;
    }
    public void setBank_sq(String bank_sq) {
        this.bank_sq = bank_sq;
    }
    public String getBank_dt() {
        return bank_dt;
    }
    public void setBank_dt(String bank_dt) {
        this.bank_dt = bank_dt;
    }
    public String getAbgt_nm() {
        return abgt_nm;
    }
    public void setAbgt_nm(String abgt_nm) {
        this.abgt_nm = abgt_nm;
    }
    public String getAbgt_cd() {
        return abgt_cd;
    }
    public void setAbgt_cd(String abgt_cd) {
        this.abgt_cd = abgt_cd;
    }
    public String getAbdocu_no() {
        return abdocu_no;
    }
    public void setAbdocu_no(String abdocu_no) {
        this.abdocu_no = abdocu_no;
    }

    public String getAbdocu_b_no() {
        return abdocu_b_no;
    }
    public void setAbdocu_b_no(String abdocu_b_no) {
        this.abdocu_b_no = abdocu_b_no;
    }
	public String getConfer_return() {
		return confer_return;
	}
	public void setConfer_return(String confer_return) {
		this.confer_return = confer_return;
	}
    public String getAbdocu_b_no_reffer() {
        return abdocu_b_no_reffer;
    }
    public void setAbdocu_b_no_reffer(String abdocu_b_no_reffer) {
        this.abdocu_b_no_reffer = abdocu_b_no_reffer;
    }
    public String getAbdocu_no_new() {
        return abdocu_no_new;
    }
    public void setAbdocu_no_new(String abdocu_no_new) {
        this.abdocu_no_new = abdocu_no_new;
    }
    public String getAbdocu_b_no_new() {
        return abdocu_b_no_new;
    }
    public void setAbdocu_b_no_new(String abdocu_b_no_new) {
        this.abdocu_b_no_new = abdocu_b_no_new;
    }
    public String getTr_fg_nm() {
        return tr_fg_nm;
    }
    public void setTr_fg_nm(String tr_fg_nm) {
        this.tr_fg_nm = tr_fg_nm;
    }
    public String getSet_fg_nm() {
        return set_fg_nm;
    }
    public void setSet_fg_nm(String set_fg_nm) {
        this.set_fg_nm = set_fg_nm;
    }
    public String getVat_fg_nm() {
        return vat_fg_nm;
    }
    public void setVat_fg_nm(String vat_fg_nm) {
        this.vat_fg_nm = vat_fg_nm;
    }
	public String getIt_sbgtcdLink() {
		return it_sbgtcdLink;
	}
	public void setIt_sbgtcdLink(String it_sbgtcdLink) {
		this.it_sbgtcdLink = it_sbgtcdLink;
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
	public String getPurc_req_b_id() {
		return purc_req_b_id;
	}
	public void setPurc_req_b_id(String purc_req_b_id) {
		this.purc_req_b_id = purc_req_b_id;
	}
	public String getReturn_yn() {
		return return_yn;
	}
	public void setReturn_yn(String return_yn) {
		this.return_yn = return_yn;
	}
	public String getPurc_tr_type() {
		return purc_tr_type;
	}
	public void setPurc_tr_type(String purc_tr_type) {
		this.purc_tr_type = purc_tr_type;
	}
	public String getPurc_cont_id() {
		return purc_cont_id;
	}
	public void setPurc_cont_id(String purc_cont_id) {
		this.purc_cont_id = purc_cont_id;
	}
	public String getPurc_cont_b_id() {
		return purc_cont_b_id;
	}
	public void setPurc_cont_b_id(String purc_cont_b_id) {
		this.purc_cont_b_id = purc_cont_b_id;
	}
	public String getApply_am2() {
		return apply_am2;
	}
	public void setApply_am2(String apply_am2) {
		this.apply_am2 = apply_am2;
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
	public String getBottom_nm() {
		return bottom_nm;
	}
	public void setBottom_nm(String bottom_nm) {
		this.bottom_nm = bottom_nm;
	}
	public String getMgt_cd() {
		return mgt_cd;
	}
	public void setMgt_cd(String mgt_cd) {
		this.mgt_cd = mgt_cd;
	}
	public String getBottom_cd() {
		return bottom_cd;
	}
	public void setBottom_cd(String bottom_cd) {
		this.bottom_cd = bottom_cd;
	}
	public String getErp_gisu_from_dt() {
		return erp_gisu_from_dt;
	}
	public void setErp_gisu_from_dt(String erp_gisu_from_dt) {
		this.erp_gisu_from_dt = erp_gisu_from_dt;
	}
	public String getErp_gisu_to_dt() {
		return erp_gisu_to_dt;
	}
	public void setErp_gisu_to_dt(String erp_gisu_to_dt) {
		this.erp_gisu_to_dt = erp_gisu_to_dt;
	}
	public String getErp_gisu() {
		return erp_gisu;
	}
	public void setErp_gisu(String erp_gisu) {
		this.erp_gisu = erp_gisu;
	}
	public String getNext_am() {
		return next_am;
	}
	public void setNext_am(String next_am) {
		this.next_am = next_am;
	}
}
 

