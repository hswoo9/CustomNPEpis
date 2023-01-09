package admin.signinfo.vo;



import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @title 
 * @author 공공사업부 포털개발팀 김석환
 * @since 2012. 5. 21.
 * @version 
 * @dscription 전자결재 - 시스템관리 - 업무관리 - 관인관리 VO 클래스
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 21.  김석환        최초 생성
 *
 */

public class SignInfoVO {
	
    
    

    private Integer result_count = 0;
    

	String c_sicode;
    String c_siseqnum;
    String c_oiorgcode;
    String c_uiuserkey;
    String c_cikind;
    String c_cikind_ko;
	String c_siname;
    String c_sistatus;
    String c_sisize;
    String c_sidate;
    String c_sidefaultflag;
    String c_simemo;
    String c_silastdate;
    String c_siorgcode;
    String c_silastuserkey;
    String deptname;
    String c_sifilename;
    String mode;
	String c_fileid;


	


	public String getDeptname() {
		return deptname;
	}
	public void setDeptname(String deptname) {
		this.deptname = deptname;
	}
	public Integer getResult_count() {
		return result_count;
	}
	public void setResult_count(Integer result_count) {
		this.result_count = result_count;
	}
	public String getC_sicode() {
		return c_sicode;
	}
	public void setC_sicode(String c_sicode) {
		this.c_sicode = c_sicode;
	}
	public String getC_siseqnum() {
		return c_siseqnum;
	}
	public void setC_siseqnum(String c_siseqnum) {
		this.c_siseqnum = c_siseqnum;
	}
	public String getC_oiorgcode() {
		return c_oiorgcode;
	}
	public void setC_oiorgcode(String c_oiorgcode) {
		this.c_oiorgcode = c_oiorgcode;
	}
	public String getC_uiuserkey() {
		return c_uiuserkey;
	}
	public void setC_uiuserkey(String c_uiuserkey) {
		this.c_uiuserkey = c_uiuserkey;
	}
	public String getC_cikind() {
		return c_cikind;
	}
	public void setC_cikind(String c_cikind) {
		this.c_cikind = c_cikind;
	}
    public String getC_cikind_ko() {
		return c_cikind_ko;
	}
	public void setC_cikind_ko(String c_cikind_ko) {
		this.c_cikind_ko = c_cikind_ko;
	}
	public String getC_siname() {
		return c_siname;
	}
	public void setC_siname(String c_siname) {
		this.c_siname = c_siname;
	}
	public String getC_sistatus() {
		return c_sistatus;
	}
	public void setC_sistatus(String c_sistatus) {
		this.c_sistatus = c_sistatus;
	}
	public String getC_sisize() {
		return c_sisize;
	}
	public void setC_sisize(String c_sisize) {
		this.c_sisize = c_sisize;
	}
	public String getC_sidate() {
		return c_sidate;
	}
	public void setC_sidate(String c_sidate) {
		this.c_sidate = c_sidate;
	}
	public String getC_sidefaultflag() {
		return c_sidefaultflag;
	}
	public void setC_sidefaultflag(String c_sidefaultflag) {
		this.c_sidefaultflag = c_sidefaultflag;
	}
	public String getC_simemo() {
		return c_simemo;
	}
	public void setC_simemo(String c_simemo) {
		this.c_simemo = c_simemo;
	}
	public String getC_silastdate() {
		return c_silastdate;
	}
	public void setC_silastdate(String c_silastdate) {
		this.c_silastdate = c_silastdate;
	}
	public String getC_siorgcode() {
		return c_siorgcode;
	}
	public void setC_siorgcode(String c_siorgcode) {
		this.c_siorgcode = c_siorgcode;
	}
	public String getC_silastuserkey() {
		return c_silastuserkey;
	}
	public void setC_silastuserkey(String c_silastuserkey) {
		this.c_silastuserkey = c_silastuserkey;
	}
	public String getC_sifilename() {
		return c_sifilename;
	}
	public void setC_sifilename(String c_sifilename) {
		this.c_sifilename = c_sifilename;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
    public String getC_fileid() {
		return c_fileid;
	}
	public void setC_fileid(String c_fileid) {
		this.c_fileid = c_fileid;
	}	
}
