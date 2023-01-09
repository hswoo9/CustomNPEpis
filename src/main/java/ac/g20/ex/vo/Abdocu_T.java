package ac.g20.ex.vo;

/**
 * 
 * @title Abdocu_T.java
 * @author doban7
 *
 * @date 2016. 9. 7.
 */
public class Abdocu_T {
    private String wd_am = "";             
    private String vat_am = "";            
    private String unit_am = "";           
    private String tran_cd = "";           
    private String tr_nm = "";             
    private String tr_cd = "";             
    private String tel = "";               
    private String tax_dt = ""; 
    private String tax_dt2 = ""; 
    private String sup_am = "";            
    private String sessionid = "";         
    private String rstx_am = "";           
    private String rmk_dc = "";            
    private String reg_nb = "";            
    private String ref_abin_ln_no = "";    
    private String ndep_am = "";           
    private String modify_id = "";         
    private String modify_dt = "";         
    private String link_type = "";         
    private String jiro_nm = "";           
    private String jiro_cd = "";           
    private String it_use_no = "";         
    private String it_use_dt = "";         
    private String it_card_no = "";        
    private String iss_sq = "";            
    private String iss_dt = "";            
    private String intx_am = "";           
    private String insert_id = "";         
    private String insert_dt = "";         
    private String inad_am = "";           
    private String etcrvrs_ym = "";        
    private String etcdummy1 = "";
    private String etcdummy1_nm = ""; 
    private String etcdata_cd = "";
    private String etcdiv_cd = "";         
    private String et_yn = "";             
    private String erp_ln_sq = "";         
    private String erp_isu_sq = "";        
    private String erp_isu_dt = "";        
    private String erp_co_cd = "";         
    private String erp_bq_sq = "";         
    private String edit_proc = "";         
    private String docu_mode = "";         
    private String depositor = "";         
    private String ctr_nm = "";            
    private String ctr_cd = "";            
    private String ctr_appdt = "";         
    private String cms_name = "";          
    private String chain_name = "";        
    private String ceo_nm = "";            
    private String btr_nm = "";            
    private String btr_cd = "";            
    private String bk_sq2 = "";            
    private String bk_sq = "";             
    private String bank_sq = "";           
    private String bank_dt = "";           
    private String ba_nb = "";             
    private String abdocu_no_reffer = "";
    private String abdocu_t_no = "";       
    private String abdocu_no = "";         
    private String abdocu_b_no = "";
    private String erp_emp_cd = "";
    private String item_nm = "";
    private String item_cnt = "";
    private String item_am = "";
    private String emp_nm = "";
    private String tr_fg = "";
    private String tr_fg_nm = "";
    private String attr_nm = "";
    private String ppl_nb = "";
    private String addr = "";
    private String trcharge_emp = "";
    // 필요경비율
    private String etcrate = "";
    //---------------------------------------------------------------------------------------------------------------------------------------------
    private String ctr_card_num = "";
    private String ctr_card_k_nm = "";
    // CMS연동 채주 여부
    private String CMS_YN = "";
    
    
    private String purc_req_id;
    private String purc_req_h_id;
    private String purc_req_b_id;
    private String purc_req_t_id;
    private String purc_tr_type;
    
	private String pps_id_no;
    private String item_type;
    private String item_type_code_id;
    private String standard;
    private String contents;
    private String start_date;
    private String end_date;
    private String pps_fees;
   
	private String purc_cont_id;
    private String purc_cont_b_id;
    private String purc_cont_t_id;
    
    private String tr_cd2;
    private String tr_nm2;
    private String reg_nb2;
    private String ceo_nm2;
    private String item_nm2;
    private String item_cnt2;
    private String item_am2;
    private String unit_am2;
    private String sup_am2;
    private String vat_am2;
    private String next_am;
    
    private String cons_doc_seq;
    
    public String getCons_doc_seq() {
		return cons_doc_seq;
	}
	public void setCons_doc_seq(String cons_doc_seq) {
		this.cons_doc_seq = cons_doc_seq;
	}
	public String getTr_cd2() {
		return tr_cd2;
	}
	public void setTr_cd2(String tr_cd2) {
		this.tr_cd2 = tr_cd2;
	}
	public String getTr_nm2() {
		return tr_nm2;
	}
	public void setTr_nm2(String tr_nm2) {
		this.tr_nm2 = tr_nm2;
	}
	public String getReg_nb2() {
		return reg_nb2;
	}
	public void setReg_nb2(String reg_nb2) {
		this.reg_nb2 = reg_nb2;
	}
	public String getCeo_nm2() {
		return ceo_nm2;
	}
	public void setCeo_nm2(String ceo_nm2) {
		this.ceo_nm2 = ceo_nm2;
	}
	public String getItem_nm2() {
		return item_nm2;
	}
	public void setItem_nm2(String item_nm2) {
		this.item_nm2 = item_nm2;
	}
	public String getItem_cnt2() {
		return item_cnt2;
	}
	public void setItem_cnt2(String item_cnt2) {
		this.item_cnt2 = item_cnt2;
	}
	public String getItem_am2() {
		return item_am2;
	}
	public void setItem_am2(String item_am2) {
		this.item_am2 = item_am2;
	}
	public String getUnit_am2() {
		return unit_am2;
	}
	public void setUnit_am2(String unit_am2) {
		this.unit_am2 = unit_am2;
	}
	public String getSup_am2() {
		return sup_am2;
	}
	public void setSup_am2(String sup_am2) {
		this.sup_am2 = sup_am2;
	}
	public String getVat_am2() {
		return vat_am2;
	}
	public void setVat_am2(String vat_am2) {
		this.vat_am2 = vat_am2;
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
    
    public String getPps_id_no() {
		return pps_id_no;
	}
	public void setPps_id_no(String pps_id_no) {
		this.pps_id_no = pps_id_no;
	}
	public String getItem_type() {
		return item_type;
	}
	public void setItem_type(String item_type) {
		this.item_type = item_type;
	}
	public String getItem_type_code_id() {
		return item_type_code_id;
	}
	public void setItem_type_code_id(String item_type_code_id) {
		this.item_type_code_id = item_type_code_id;
	}
	public String getStandard() {
		return standard;
	}
	public void setStandard(String standard) {
		this.standard = standard;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getPps_fees() {
		return pps_fees;
	}
	public void setPps_fees(String pps_fees) {
		this.pps_fees = pps_fees;
	}
    public String getPurc_req_id() {
		return purc_req_id;
	}
	public void setPurc_req_id(String purc_req_id) {
		this.purc_req_id = purc_req_id;
	}
	public String getPurc_req_h_id() {
		return purc_req_h_id;
	}
	public void setPurc_req_h_id(String purc_req_h_id) {
		this.purc_req_h_id = purc_req_h_id;
	}
	public String getPurc_req_b_id() {
		return purc_req_b_id;
	}
	public void setPurc_req_b_id(String purc_req_b_id) {
		this.purc_req_b_id = purc_req_b_id;
	}
	public String getPurc_req_t_id() {
		return purc_req_t_id;
	}
	public void setPurc_req_t_id(String purc_req_t_id) {
		this.purc_req_t_id = purc_req_t_id;
	}
	public String getCMS_YN(){
    	return this.CMS_YN;
    }public void setCMS_YN(String CMS_YN){
    	this.CMS_YN = CMS_YN;
    }
    
    
    public String getErp_emp_cd() {
        return erp_emp_cd;
    }
    public String getTr_fg() {
        return tr_fg;
    }
    public void setTr_fg(String tr_fg) {
        this.tr_fg = tr_fg;
    }
    public String getTr_fg_nm() {
        return tr_fg_nm;
    }
    public void setTr_fg_nm(String tr_fg_nm) {
        this.tr_fg_nm = tr_fg_nm;
    }
    public String getAttr_nm() {
        return attr_nm;
    }
    public void setAttr_nm(String attr_nm) {
        this.attr_nm = attr_nm;
    }
    public String getPpl_nb() {
        return ppl_nb;
    }
    public void setPpl_nb(String ppl_nb) {
        this.ppl_nb = ppl_nb;
    }
    public String getAddr() {
        return addr;
    }
    public void setAddr(String addr) {
        this.addr = addr;
    }
    public String getTrcharge_emp() {
        return trcharge_emp;
    }
    public void setTrcharge_emp(String trcharge_emp) {
        this.trcharge_emp = trcharge_emp;
    }
    public String getAbdocu_no_reffer() {
        return abdocu_no_reffer;
    }
    public void setAbdocu_no_reffer(String abdocu_no_reffer) {
        this.abdocu_no_reffer = abdocu_no_reffer;
    }
    public String getItem_cnt() {
        return item_cnt;
    }
    public void setItem_cnt(String item_cnt) {
        this.item_cnt = item_cnt;
    }
    public String getItem_am() {
        return item_am;
    }
    public void setItem_am(String item_am) {
        this.item_am = item_am;
    }
    public String getEmp_nm() {
        return emp_nm;
    }
    public void setEmp_nm(String emp_nm) {
        this.emp_nm = emp_nm;
    }
    public String getItem_nm() {
        return item_nm;
    }
    public void setItem_nm(String item_nm) {
        this.item_nm = item_nm;
    }
    public void setErp_emp_cd(String erp_emp_cd) {
        this.erp_emp_cd = erp_emp_cd;
    }
    public String getWd_am() {
        return wd_am;
    }
    public void setWd_am(String wd_am) {
        this.wd_am = wd_am;
    }
    public String getVat_am() {
        return vat_am;
    }
    public void setVat_am(String vat_am) {
        this.vat_am = vat_am;
    }
    public String getUnit_am() {
        return unit_am;
    }
    public void setUnit_am(String unit_am) {
        this.unit_am = unit_am;
    }
    public String getTran_cd() {
        return tran_cd;
    }
    public void setTran_cd(String tran_cd) {
        this.tran_cd = tran_cd;
    }
    public String getTr_nm() {
        return tr_nm;
    }
    public void setTr_nm(String tr_nm) {
        this.tr_nm = tr_nm;
    }
    public String getTr_cd() {
        return tr_cd;
    }
    public void setTr_cd(String tr_cd) {
        this.tr_cd = tr_cd;
    }
    public String getTel() {
        return tel;
    }
    public void setTel(String tel) {
        this.tel = tel;
    }
    public String getTax_dt() {
        return tax_dt;
    }
    public void setTax_dt(String tax_dt) {
        this.tax_dt = tax_dt;
    }
    public String getTax_dt2() {
        return tax_dt2;
    }
    public void setTax_dt2(String tax_dt2) {
        this.tax_dt2 = tax_dt2;
    }
    public String getSup_am() {
        return sup_am;
    }
    public void setSup_am(String sup_am) {
        this.sup_am = sup_am;
    }
    public String getSessionid() {
        return sessionid;
    }
    public void setSessionid(String sessionid) {
        this.sessionid = sessionid;
    }
    public String getRstx_am() {
        return rstx_am;
    }
    public void setRstx_am(String rstx_am) {
        this.rstx_am = rstx_am;
    }
    public String getRmk_dc() {
        return rmk_dc;
    }
    public void setRmk_dc(String rmk_dc) {
        this.rmk_dc = rmk_dc;
    }
    public String getReg_nb() {
        return reg_nb;
    }
    public void setReg_nb(String reg_nb) {
        this.reg_nb = reg_nb;
    }
    public String getRef_abin_ln_no() {
        return ref_abin_ln_no;
    }
    public void setRef_abin_ln_no(String ref_abin_ln_no) {
        this.ref_abin_ln_no = ref_abin_ln_no;
    }
    public String getNdep_am() {
        return ndep_am;
    }
    public void setNdep_am(String ndep_am) {
        this.ndep_am = ndep_am;
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
    public String getLink_type() {
        return link_type;
    }
    public void setLink_type(String link_type) {
        this.link_type = link_type;
    }
    public String getJiro_nm() {
        return jiro_nm;
    }
    public void setJiro_nm(String jiro_nm) {
        this.jiro_nm = jiro_nm;
    }
    public String getJiro_cd() {
        return jiro_cd;
    }
    public void setJiro_cd(String jiro_cd) {
        this.jiro_cd = jiro_cd;
    }
    public String getIt_use_no() {
        return it_use_no;
    }
    public void setIt_use_no(String it_use_no) {
        this.it_use_no = it_use_no;
    }
    public String getIt_use_dt() {
        return it_use_dt;
    }
    public void setIt_use_dt(String it_use_dt) {
        this.it_use_dt = it_use_dt;
    }
    public String getIt_card_no() {
        return it_card_no;
    }
    public void setIt_card_no(String it_card_no) {
        this.it_card_no = it_card_no;
    }
    public String getIss_sq() {
        return iss_sq;
    }
    public void setIss_sq(String iss_sq) {
        this.iss_sq = iss_sq;
    }
    public String getIss_dt() {
        return iss_dt;
    }
    public void setIss_dt(String iss_dt) {
        this.iss_dt = iss_dt;
    }
    public String getIntx_am() {
        return intx_am;
    }
    public void setIntx_am(String intx_am) {
        this.intx_am = intx_am;
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
    public String getInad_am() {
        return inad_am;
    }
    public void setInad_am(String inad_am) {
        this.inad_am = inad_am;
    }
    public String getEtcrvrs_ym() {
        return etcrvrs_ym;
    }
    public void setEtcrvrs_ym(String etcrvrs_ym) {
        this.etcrvrs_ym = etcrvrs_ym;
    }
    public String getEtcdummy1() {
        return etcdummy1;
    }
    public void setEtcdummy1(String etcdummy1) {
        this.etcdummy1 = etcdummy1;
    }
    public String getEtcdata_cd() {
        return etcdata_cd;
    }
    public void setEtcdata_cd(String etcdata_cd) {
        this.etcdata_cd = etcdata_cd;
    }
    public String getEtcdiv_cd() {
        return etcdiv_cd;
    }
    public void setEtcdiv_cd(String etcdiv_cd) {
        this.etcdiv_cd = etcdiv_cd;
    }
    public String getEt_yn() {
        return et_yn;
    }
    public void setEt_yn(String et_yn) {
        this.et_yn = et_yn;
    }
    public String getErp_ln_sq() {
        return erp_ln_sq;
    }
    public void setErp_ln_sq(String erp_ln_sq) {
        this.erp_ln_sq = erp_ln_sq;
    }
    public String getErp_isu_sq() {
        return erp_isu_sq;
    }
    public void setErp_isu_sq(String erp_isu_sq) {
        this.erp_isu_sq = erp_isu_sq;
    }
    public String getErp_isu_dt() {
        return erp_isu_dt;
    }
    public void setErp_isu_dt(String erp_isu_dt) {
        this.erp_isu_dt = erp_isu_dt;
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
    public String getDepositor() {
        return depositor;
    }
    public void setDepositor(String depositor) {
        this.depositor = depositor;
    }
    public String getCtr_nm() {
        return ctr_nm;
    }
    public void setCtr_nm(String ctr_nm) {
        this.ctr_nm = ctr_nm;
    }
    public String getCtr_cd() {
        return ctr_cd;
    }
    public void setCtr_cd(String ctr_cd) {
        this.ctr_cd = ctr_cd;
    }
    public String getCtr_appdt() {
        return ctr_appdt;
    }
    public void setCtr_appdt(String ctr_appdt) {
        this.ctr_appdt = ctr_appdt;
    }
    public String getCms_name() {
        return cms_name;
    }
    public void setCms_name(String cms_name) {
        this.cms_name = cms_name;
    }
    public String getChain_name() {
        return chain_name;
    }
    public void setChain_name(String chain_name) {
        this.chain_name = chain_name;
    }
    public String getCeo_nm() {
        return ceo_nm;
    }
    public void setCeo_nm(String ceo_nm) {
        this.ceo_nm = ceo_nm;
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
    public String getBk_sq2() {
        return bk_sq2;
    }
    public void setBk_sq2(String bk_sq2) {
        this.bk_sq2 = bk_sq2;
    }
    public String getBk_sq() {
        return bk_sq;
    }
    public void setBk_sq(String bk_sq) {
        this.bk_sq = bk_sq;
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
    public String getBa_nb() {
        return ba_nb;
    }
    public void setBa_nb(String ba_nb) {
        this.ba_nb = ba_nb;
    }

    public String getAbdocu_t_no() {
        return abdocu_t_no;
    }
    public void setAbdocu_t_no(String abdocu_t_no) {
        this.abdocu_t_no = abdocu_t_no;
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
    public String getEtcrate() {
        return etcrate;
    }
    public void setEtcrate(String etcrate) {
        this.etcrate = etcrate;
    }
	public String getCtr_card_num() {
		return ctr_card_num;
	}
	public void setCtr_card_num(String ctr_card_num) {
		this.ctr_card_num = ctr_card_num;
	}
    public String getEtcdummy1_nm() {
        return etcdummy1_nm;
    }
    public void setEtcdummy1_nm(String etcdummy1_nm) {
        this.etcdummy1_nm = etcdummy1_nm;
    }
	public String getCtr_card_k_nm() {
		return ctr_card_k_nm;
	}
	public void setCtr_card_k_nm(String ctr_card_k_nm) {
		this.ctr_card_k_nm = ctr_card_k_nm;
	}
	public String getPurc_tr_type() {
		return purc_tr_type;
	}
	public void setPurc_tr_type(String purc_tr_type) {
		this.purc_tr_type = purc_tr_type;
	}
	public String getPurc_cont_t_id() {
		return purc_cont_t_id;
	}
	public void setPurc_cont_t_id(String purc_cont_t_id) {
		this.purc_cont_t_id = purc_cont_t_id;
	}
	public String getNext_am() {
		return next_am;
	}
	public void setNext_am(String next_am) {
		this.next_am = next_am;
	}
}
 

