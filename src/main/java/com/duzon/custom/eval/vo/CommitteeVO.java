package com.duzon.custom.eval.vo;

import java.util.Map;

public class CommitteeVO {

	private String committee_seq;
	private String eval_company_seq;
	private String req_dept_name;
	private String req_dept_seq;
	private String req_date;
	private String title;
	private String budget;
	private String rates;
	private String eval_s_date;
	private String eval_e_date;
	private String eval_s_time;
	private String eval_e_time;
	private String eval_place;
	private String join_org_cnt;
	private String commissioner_cnt;
	private String major_emp_name;
	private String major_emp_seq;
	private String req_header_emp_name;
	private String req_header_emp_seq;
	private String step;
	private String reject_dscr;
	private String order_no;
	private String remark;
	private String active;
	private String create_date;
	private String create_emp_seq;
	private String eval_year;
	private String eval_doc_num;
	
	private String create_emp_name;
	private String create_dept_name;
	private String create_duty_name;
	
	private String major_dept;
	private String major_dept_seq;
	private String biz_type_array;
	private String biz_type_code_id;
	
	private String opr_emp_name_1;
	private String opr_emp_seq_1;
	private String opr_dept_1;
	private String opr_dept_seq_1;

	private String opr_emp_name_2;
	private String opr_emp_seq_2;
	private String opr_dept_2;
	private String opr_dept_seq_2;
	
	private String opr_emp_name_3;
	private String opr_emp_seq_3;
	private String opr_dept_3;
	private String opr_dept_seq_3;
	
	private String opr_emp_name_4;
	private String opr_emp_seq_4;
	private String opr_dept_4;
	private String opr_dept_seq_4;
	
	private String opr_emp_name_5;
	private String opr_emp_seq_5;
	private String opr_dept_5;
	private String opr_dept_seq_5;
	
	private String opr_emp_name_6;
	private String opr_emp_seq_6;
	private String opr_dept_6;
	private String opr_dept_seq_6;
	
	private String opr_emp_name_7;
	private String opr_emp_seq_7;
	private String opr_dept_7;
	private String opr_dept_seq_7;
	
	private String evalItemList;
	private String joinOrgList;
	private String eval_item_seq;
	private String display_title;

	private String join_select_type;

	private String bidding_type;
	private String req_state;
	private String purc_req_id;
	private String company_type;
	private String project_pm;
    private String deviation;
    private String evalCm;
	private String committee_guest;

	private String in_mb_cnt;

    public String getEvalCm() {
        return evalCm;
    }

    public void setEvalCm(String evalCm) {
        this.evalCm = evalCm;
    }

    public String getDeviation() {
        return deviation;
    }

    public void setDeviation(String deviation) {
        this.deviation = deviation;
    }

    public String getCommittee_seq() {
		return committee_seq;
	}
	public void setCommittee_seq(String committee_seq) {
		this.committee_seq = committee_seq;
	}
	public String getReq_dept_name() {
		return req_dept_name;
	}
	public void setReq_dept_name(String req_dept_name) {
		this.req_dept_name = req_dept_name;
	}
	public String getReq_dept_seq() {
		return req_dept_seq;
	}
	public void setReq_dept_seq(String req_dept_seq) {
		this.req_dept_seq = req_dept_seq;
	}
	public String getReq_date() {
		return req_date;
	}
	public void setReq_date(String req_date) {
		this.req_date = req_date;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getBudget() {
		return budget;
	}
	public void setBudget(String budget) {
		this.budget = budget;
	}
	public String getEval_place() {
		return eval_place;
	}
	public void setEval_place(String eval_place) {
		this.eval_place = eval_place;
	}

	public String getCommittee_Guest() { return committee_guest;}
	public void setCommittee_Guest(String committee_guest) { this.committee_guest = committee_guest; }

	public String getIn_mb_cnt() { return in_mb_cnt; }
	public void setIn_mb_cnt(String in_mb_cnt) { this.in_mb_cnt = in_mb_cnt; }

	public String getJoin_org_cnt() {
		return join_org_cnt;
	}
	public void setJoin_org_cnt(String join_org_cnt) {
		this.join_org_cnt = join_org_cnt;
	}
	public String getCommissioner_cnt() {
		return commissioner_cnt;
	}
	public void setCommissioner_cnt(String commissioner_cnt) {
		this.commissioner_cnt = commissioner_cnt;
	}
	public String getMajor_emp_name() {
		return major_emp_name;
	}
	public void setMajor_emp_name(String major_emp_name) {
		this.major_emp_name = major_emp_name;
	}
	public String getMajor_emp_seq() {
		return major_emp_seq;
	}
	public void setMajor_emp_seq(String major_emp_seq) {
		this.major_emp_seq = major_emp_seq;
	}
	public String getReq_header_emp_name() {
		return req_header_emp_name;
	}
	public void setReq_header_emp_name(String req_header_emp_name) {
		this.req_header_emp_name = req_header_emp_name;
	}
	public String getReq_header_emp_seq() {
		return req_header_emp_seq;
	}
	public void setReq_header_emp_seq(String req_header_emp_seq) {
		this.req_header_emp_seq = req_header_emp_seq;
	}
	public String getStep() {
		return step;
	}
	public void setStep(String step) {
		this.step = step;
	}
	public String getReject_dscr() {
		return reject_dscr;
	}
	public void setReject_dscr(String reject_dscr) {
		this.reject_dscr = reject_dscr;
	}
	public String getOrder_no() {
		return order_no;
	}
	public void setOrder_no(String order_no) {
		this.order_no = order_no;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getActive() {
		return active;
	}
	public void setActive(String active) {
		this.active = active;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getCreate_emp_seq() {
		return create_emp_seq;
	}
	public void setCreate_emp_seq(String create_emp_seq) {
		this.create_emp_seq = create_emp_seq;
	}
	public String getEval_s_time() {
		return eval_s_time;
	}
	public void setEval_s_time(String eval_s_time) {
		this.eval_s_time = eval_s_time;
	}
	public String getEval_e_time() {
		return eval_e_time;
	}
	public void setEval_e_time(String eval_e_time) {
		this.eval_e_time = eval_e_time;
	}
	public String getMajor_dept() {
		return major_dept;
	}
	public void setMajor_dept(String major_dept) {
		this.major_dept = major_dept;
	}
	public String getMajor_dept_seq() {
		return major_dept_seq;
	}
	public void setMajor_dept_seq(String major_dept_seq) {
		this.major_dept_seq = major_dept_seq;
	}
	public String getBiz_type_array() {
		return biz_type_array;
	}
	public void setBiz_type_array(String biz_type_array) {
		this.biz_type_array = biz_type_array;
	}
	public String getBiz_type_code_id() {
		return biz_type_code_id;
	}
	public void setBiz_type_code_id(String biz_type_code_id) {
		this.biz_type_code_id = biz_type_code_id;
	}
	public String getCreate_emp_name() {
		return create_emp_name;
	}
	public void setCreate_emp_name(String create_emp_name) {
		this.create_emp_name = create_emp_name;
	}
	public String getCreate_dept_name() {
		return create_dept_name;
	}
	public void setCreate_dept_name(String create_dept_name) {
		this.create_dept_name = create_dept_name;
	}
	public String getCreate_duty_name() {
		return create_duty_name;
	}
	public void setCreate_duty_name(String create_duty_name) {
		this.create_duty_name = create_duty_name;
	}
	public String getEval_company_seq() {
		return eval_company_seq;
	}
	public void setEval_company_seq(String eval_company_seq) {
		this.eval_company_seq = eval_company_seq;
	}
	public String getEvalItemList() {
		return evalItemList;
	}
	public void setEvalItemList(String evalItemList) {
		this.evalItemList = evalItemList;
	}
	public String getEval_item_seq() {
		return eval_item_seq;
	}
	public void setEval_item_seq(String eval_item_seq) {
		this.eval_item_seq = eval_item_seq;
	}
	public String getDisplay_title() {
		return display_title;
	}
	public void setDisplay_title(String display_title) {
		this.display_title = display_title;
	}
	public String getJoinOrgList() {
		return joinOrgList;
	}
	public void setJoinOrgList(String joinOrgList) {
		this.joinOrgList = joinOrgList;
	}
	public String getOpr_emp_name_1() {
		return opr_emp_name_1;
	}
	public void setOpr_emp_name_1(String opr_emp_name_1) {
		this.opr_emp_name_1 = opr_emp_name_1;
	}
	public String getOpr_emp_seq_1() {
		return opr_emp_seq_1;
	}
	public void setOpr_emp_seq_1(String opr_emp_seq_1) {
		this.opr_emp_seq_1 = opr_emp_seq_1;
	}
	public String getOpr_dept_1() {
		return opr_dept_1;
	}
	public void setOpr_dept_1(String opr_dept_1) {
		this.opr_dept_1 = opr_dept_1;
	}
	public String getOpr_dept_seq_1() {
		return opr_dept_seq_1;
	}
	public void setOpr_dept_seq_1(String opr_dept_seq_1) {
		this.opr_dept_seq_1 = opr_dept_seq_1;
	}
	public String getOpr_emp_name_2() {
		return opr_emp_name_2;
	}
	public void setOpr_emp_name_2(String opr_emp_name_2) {
		this.opr_emp_name_2 = opr_emp_name_2;
	}
	public String getOpr_emp_seq_2() {
		return opr_emp_seq_2;
	}
	public void setOpr_emp_seq_2(String opr_emp_seq_2) {
		this.opr_emp_seq_2 = opr_emp_seq_2;
	}
	public String getOpr_dept_2() {
		return opr_dept_2;
	}
	public void setOpr_dept_2(String opr_dept_2) {
		this.opr_dept_2 = opr_dept_2;
	}
	public String getOpr_dept_seq_2() {
		return opr_dept_seq_2;
	}
	public void setOpr_dept_seq_2(String opr_dept_seq_2) {
		this.opr_dept_seq_2 = opr_dept_seq_2;
	}
	public String getOpr_emp_name_3() {
		return opr_emp_name_3;
	}
	public void setOpr_emp_name_3(String opr_emp_name_3) {
		this.opr_emp_name_3 = opr_emp_name_3;
	}
	public String getOpr_emp_seq_3() {
		return opr_emp_seq_3;
	}
	public void setOpr_emp_seq_3(String opr_emp_seq_3) {
		this.opr_emp_seq_3 = opr_emp_seq_3;
	}
	public String getOpr_dept_3() {
		return opr_dept_3;
	}
	public void setOpr_dept_3(String opr_dept_3) {
		this.opr_dept_3 = opr_dept_3;
	}
	public String getOpr_dept_seq_3() {
		return opr_dept_seq_3;
	}
	public void setOpr_dept_seq_3(String opr_dept_seq_3) {
		this.opr_dept_seq_3 = opr_dept_seq_3;
	}
	public String getOpr_emp_name_4() {
		return opr_emp_name_4;
	}
	public void setOpr_emp_name_4(String opr_emp_name_4) {
		this.opr_emp_name_4 = opr_emp_name_4;
	}
	public String getOpr_emp_seq_4() {
		return opr_emp_seq_4;
	}
	public void setOpr_emp_seq_4(String opr_emp_seq_4) {
		this.opr_emp_seq_4 = opr_emp_seq_4;
	}
	public String getOpr_dept_4() {
		return opr_dept_4;
	}
	public void setOpr_dept_4(String opr_dept_4) {
		this.opr_dept_4 = opr_dept_4;
	}
	public String getOpr_dept_seq_4() {
		return opr_dept_seq_4;
	}
	public void setOpr_dept_seq_4(String opr_dept_seq_4) {
		this.opr_dept_seq_4 = opr_dept_seq_4;
	}
	public String getOpr_emp_name_5() {
		return opr_emp_name_5;
	}
	public void setOpr_emp_name_5(String opr_emp_name_5) {
		this.opr_emp_name_5 = opr_emp_name_5;
	}
	public String getOpr_emp_seq_5() {
		return opr_emp_seq_5;
	}
	public void setOpr_emp_seq_5(String opr_emp_seq_5) {
		this.opr_emp_seq_5 = opr_emp_seq_5;
	}
	public String getOpr_dept_5() {
		return opr_dept_5;
	}
	public void setOpr_dept_5(String opr_dept_5) {
		this.opr_dept_5 = opr_dept_5;
	}
	public String getOpr_dept_seq_5() {
		return opr_dept_seq_5;
	}
	public void setOpr_dept_seq_5(String opr_dept_seq_5) {
		this.opr_dept_seq_5 = opr_dept_seq_5;
	}
	public String getJoin_select_type() {
		return join_select_type;
	}
	public void setJoin_select_type(String join_select_type) {
		this.join_select_type = join_select_type;
	}
	public String getBidding_type() {
		return bidding_type;
	}
	public void setBidding_type(String bidding_type) {
		this.bidding_type = bidding_type;
	}
	public String getReq_state() {
		return req_state;
	}
	public void setReq_state(String req_state) {
		this.req_state = req_state;
	}
	public String getPurc_req_id() {
		return purc_req_id;
	}
	public void setPurc_req_id(String purc_req_id) {
		this.purc_req_id = purc_req_id;
	}
	public String getCompany_type() {
		return company_type;
	}
	public void setCompany_type(String company_type) {
		this.company_type = company_type;
	}
	public String getRates() {
		return rates;
	}
	public void setRates(String rates) {
		this.rates = rates;
	}
	public String getEval_s_date() {
		return eval_s_date;
	}
	public void setEval_s_date(String eval_s_date) {
		this.eval_s_date = eval_s_date;
	}
	public String getEval_e_date() {
		return eval_e_date;
	}
	public void setEval_e_date(String eval_e_date) {
		this.eval_e_date = eval_e_date;
	}
	public String getEval_year() {
		return eval_year;
	}
	public void setEval_year(String eval_year) {
		this.eval_year = eval_year;
	}
	public String getEval_doc_num() {
		return eval_doc_num;
	}
	public void setEval_doc_num(String eval_doc_num) {
		this.eval_doc_num = eval_doc_num;
	}
	public String getOpr_emp_name_6() {
		return opr_emp_name_6;
	}
	public void setOpr_emp_name_6(String opr_emp_name_6) {
		this.opr_emp_name_6 = opr_emp_name_6;
	}
	public String getOpr_emp_seq_6() {
		return opr_emp_seq_6;
	}
	public void setOpr_emp_seq_6(String opr_emp_seq_6) {
		this.opr_emp_seq_6 = opr_emp_seq_6;
	}
	public String getOpr_dept_6() {
		return opr_dept_6;
	}
	public void setOpr_dept_6(String opr_dept_6) {
		this.opr_dept_6 = opr_dept_6;
	}
	public String getOpr_dept_seq_6() {
		return opr_dept_seq_6;
	}
	public void setOpr_dept_seq_6(String opr_dept_seq_6) {
		this.opr_dept_seq_6 = opr_dept_seq_6;
	}
	public String getOpr_emp_name_7() {
		return opr_emp_name_7;
	}
	public void setOpr_emp_name_7(String opr_emp_name_7) {
		this.opr_emp_name_7 = opr_emp_name_7;
	}
	public String getOpr_emp_seq_7() {
		return opr_emp_seq_7;
	}
	public void setOpr_emp_seq_7(String opr_emp_seq_7) {
		this.opr_emp_seq_7 = opr_emp_seq_7;
	}
	public String getOpr_dept_7() {
		return opr_dept_7;
	}
	public void setOpr_dept_7(String opr_dept_7) {
		this.opr_dept_7 = opr_dept_7;
	}
	public String getOpr_dept_seq_7() {
		return opr_dept_seq_7;
	}
	public void setOpr_dept_seq_7(String opr_dept_seq_7) {
		this.opr_dept_seq_7 = opr_dept_seq_7;
	}
	public String getProject_pm() {
		return project_pm;
	}
	public void setProject_pm(String project_pm) {
		this.project_pm = project_pm;
	}

}
