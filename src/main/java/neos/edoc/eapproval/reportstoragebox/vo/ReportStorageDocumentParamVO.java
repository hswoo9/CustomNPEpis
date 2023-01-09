package neos.edoc.eapproval.reportstoragebox.vo;

import neos.cmm.vo.SearchParamVO;


/**
 * 
 * @title 상신/보관함 검색관련 VO
 * @author 공공사업부 포털개발팀 김석환
 * @since 2012. 5. 2.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 2.  김석환        최초 생성
 *
 */
public class ReportStorageDocumentParamVO extends SearchParamVO{
	private String docstatus_select;

	private String[] c_dikeycodes ;
	
	private String draftRtnYN ;
	
	private String c_didocflag;


	private String c_diflag ; 
	
	public String getC_didocflag() {
		return c_didocflag;
	}

	public void setC_didocflag(String c_didocflag) {
		this.c_didocflag = c_didocflag;
	}

	public String[] getC_dikeycodes() {
		return c_dikeycodes;
	}

	public void setC_dikeycodes(String[] c_dikeycodes) {
		this.c_dikeycodes = c_dikeycodes;
	}
	
	public String getDocstatus_select() {
		return docstatus_select;
	}

	public void setDocstatus_select(String docstatus_select) {
		this.docstatus_select = docstatus_select;
	}
	
	public String getDraftRtnYN() {
		return draftRtnYN;
	}

	public void setDraftRtnYN(String draftRtnYN) {
		this.draftRtnYN = draftRtnYN;
	}
	public String getC_diflag() {
		return c_diflag;
	}

	public void setC_diflag(String c_diflag) {
		this.c_diflag = c_diflag;
	}

	@Override
	public String getDocstatus()
	{
		return getSigntype();
	}
}
