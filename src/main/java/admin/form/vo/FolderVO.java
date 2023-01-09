package admin.form.vo;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * @title ForderVO.java
 * @author doban7
 *
 * @date 2016. 8. 19. 
 */
public class FolderVO {
	
	private LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	
	private String c_fikeycode;  //폴더키코드   
	
	private String c_finame;     //폴더명

	private String c_fimemo;     //설명
	
	private String c_fiord;      //정렬
	
	private String c_fivisible;  //노출여부
	
	private String c_fiorgcode;     //등록회사
	
	private String c_fiuseflag = "000"; //사용여부

	private String orgIds = "";
	
	private String orgGbs = "";
	
    public String getC_fikeycode() {
		return c_fikeycode;
	}

	public void setC_fikeycode(String c_fikeycode) {
		this.c_fikeycode = c_fikeycode;
	}

	public String getC_finame() {
		return c_finame;
	}

	public void setC_finame(String c_finame) {
		this.c_finame = c_finame;
	}

	public String getC_fimemo() {
		return c_fimemo;
	}

	public void setC_fimemo(String c_fimemo) {
		this.c_fimemo = c_fimemo;
	}

	public String getC_fiord() {
		return c_fiord;
	}

	public void setC_fiord(String c_fiord) {
		this.c_fiord = c_fiord;
	}

	public String getC_fivisible() {
		return c_fivisible;
	}

	public void setC_fivisible(String c_fivisible) {
		this.c_fivisible = c_fivisible;
	}

	public String getC_fiorgcode() {
		return c_fiorgcode;
	}

	public void setC_fiorgcode(String c_fiorgcode) {
		this.c_fiorgcode = c_fiorgcode;
	}

	public String getC_fiuseflag() {
		return c_fiuseflag;
	}

	public void setC_fiuseflag(String c_fiuseflag) {
		this.c_fiuseflag = c_fiuseflag;
	}

	public LoginVO getLoginVO() {
		return loginVO;
	}

	public String getOrgIds() {
		return orgIds;
	}

	public void setOrgIds(String orgIds) {
		this.orgIds = orgIds;
	}

	public String getOrgGbs() {
		return orgGbs;
	}

	public void setOrgGbs(String orgGbs) {
		this.orgGbs = orgGbs;
	}
	

}
