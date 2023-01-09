package admin.form.vo;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 * 
 * @title FormVO.java
 * @author doban7
 *
 * @date 2016. 8. 19.
 */
public class FormVO {
	
	private LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	
    public LoginVO getLoginVO() {
		return loginVO;
	}

	private String c_tikeycode;
    private String c_tiname;
    private String c_tiuseorgcode;
    private String c_tiorgcode;
    private String c_tiuserkey; 
    private String c_timemo;
    private String c_cikind;
    private String c_tiuseflag;
    private String c_tijunkyuljaeflag; 
    private String c_tiheader;
    private String c_tifooter;
    private String c_tilastuserkey;
    private String c_tisymbol;
    private String c_tilogo;
    private String c_tiform;
    private String c_tiflag;
    private String c_tilistcode;
    private String c_tisortoption;
    private String mode;
    private String receivedept;
    private String receivedept_ko;
    private String type;
    private String childcode;
    private String childcodedetail;
    private String parent;
    private String c_ord;
    private String c_isurlwidth;
    private String c_isurlheight;
    private String c_isurldirect;
    private String c_isurlpop;
    private String c_tiregistpageurl;
    private String c_tichgpageurl;
    private String c_servicename;
    private String c_tichgpage;
    private String c_tidetailpage;
    private String c_urlparam;
    private String c_arccomncode;
    private String c_tivisible ;
    private String c_lnkcode ;
    private String c_tiapprover;
    
	private String orgIds = "";
	
	private String orgGbs = "";
	
    private String c_tilastdate;

	public String getC_tikeycode() {
		return c_tikeycode;
	}

	public void setC_tikeycode(String c_tikeycode) {
		this.c_tikeycode = c_tikeycode;
	}

	public String getC_tiname() {
		return c_tiname;
	}

	public void setC_tiname(String c_tiname) {
		this.c_tiname = c_tiname;
	}

	public String getC_tiuseorgcode() {
		return c_tiuseorgcode;
	}

	public void setC_tiuseorgcode(String c_tiuseorgcode) {
		this.c_tiuseorgcode = c_tiuseorgcode;
	}

	public String getC_tiorgcode() {
		return c_tiorgcode;
	}

	public void setC_tiorgcode(String c_tiorgcode) {
		this.c_tiorgcode = c_tiorgcode;
	}

	public String getC_tiuserkey() {
		return c_tiuserkey;
	}

	public void setC_tiuserkey(String c_tiuserkey) {
		this.c_tiuserkey = c_tiuserkey;
	}

	public String getC_timemo() {
		return c_timemo;
	}

	public void setC_timemo(String c_timemo) {
		this.c_timemo = c_timemo;
	}

	public String getC_cikind() {
		return c_cikind;
	}

	public void setC_cikind(String c_cikind) {
		this.c_cikind = c_cikind;
	}

	public String getC_tiuseflag() {
		return c_tiuseflag;
	}

	public void setC_tiuseflag(String c_tiuseflag) {
		this.c_tiuseflag = c_tiuseflag;
	}

	public String getC_tijunkyuljaeflag() {
		return c_tijunkyuljaeflag;
	}

	public void setC_tijunkyuljaeflag(String c_tijunkyuljaeflag) {
		this.c_tijunkyuljaeflag = c_tijunkyuljaeflag;
	}

	public String getC_tiheader() {
		return c_tiheader;
	}

	public void setC_tiheader(String c_tiheader) {
		this.c_tiheader = c_tiheader;
	}

	public String getC_tifooter() {
		return c_tifooter;
	}

	public void setC_tifooter(String c_tifooter) {
		this.c_tifooter = c_tifooter;
	}

	public String getC_tilastuserkey() {
		return c_tilastuserkey;
	}

	public void setC_tilastuserkey(String c_tilastuserkey) {
		this.c_tilastuserkey = c_tilastuserkey;
	}

	public String getC_tisymbol() {
		return c_tisymbol;
	}

	public void setC_tisymbol(String c_tisymbol) {
		this.c_tisymbol = c_tisymbol;
	}

	public String getC_tilogo() {
		return c_tilogo;
	}

	public void setC_tilogo(String c_tilogo) {
		this.c_tilogo = c_tilogo;
	}

	public String getC_tiform() {
		return c_tiform;
	}

	public void setC_tiform(String c_tiform) {
		this.c_tiform = c_tiform;
	}

	public String getC_tiflag() {
		return c_tiflag;
	}

	public void setC_tiflag(String c_tiflag) {
		this.c_tiflag = c_tiflag;
	}

	public String getC_tilistcode() {
		return c_tilistcode;
	}

	public void setC_tilistcode(String c_tilistcode) {
		this.c_tilistcode = c_tilistcode;
	}

	public String getC_tisortoption() {
		return c_tisortoption;
	}

	public void setC_tisortoption(String c_tisortoption) {
		this.c_tisortoption = c_tisortoption;
	}

	public String getMode() {
		return mode;
	}

	public void setMode(String mode) {
		this.mode = mode;
	}

	public String getReceivedept() {
		return receivedept;
	}

	public void setReceivedept(String receivedept) {
		this.receivedept = receivedept;
	}

	public String getReceivedept_ko() {
		return receivedept_ko;
	}

	public void setReceivedept_ko(String receivedept_ko) {
		this.receivedept_ko = receivedept_ko;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getChildcode() {
		return childcode;
	}

	public void setChildcode(String childcode) {
		this.childcode = childcode;
	}

	public String getChildcodedetail() {
		return childcodedetail;
	}

	public void setChildcodedetail(String childcodedetail) {
		this.childcodedetail = childcodedetail;
	}

	public String getParent() {
		return parent;
	}

	public void setParent(String parent) {
		this.parent = parent;
	}

	public String getC_ord() {
		return c_ord;
	}

	public void setC_ord(String c_ord) {
		this.c_ord = c_ord;
	}

	public String getC_isurlwidth() {
		return c_isurlwidth;
	}

	public void setC_isurlwidth(String c_isurlwidth) {
		this.c_isurlwidth = c_isurlwidth;
	}

	public String getC_isurlheight() {
		return c_isurlheight;
	}

	public void setC_isurlheight(String c_isurlheight) {
		this.c_isurlheight = c_isurlheight;
	}

	public String getC_isurldirect() {
		return c_isurldirect;
	}

	public void setC_isurldirect(String c_isurldirect) {
		this.c_isurldirect = c_isurldirect;
	}

	public String getC_isurlpop() {
		return c_isurlpop;
	}

	public void setC_isurlpop(String c_isurlpop) {
		this.c_isurlpop = c_isurlpop;
	}

	public String getC_tiregistpageurl() {
		return c_tiregistpageurl;
	}

	public void setC_tiregistpageurl(String c_tiregistpageurl) {
		this.c_tiregistpageurl = c_tiregistpageurl;
	}

	public String getC_tichgpageurl() {
		return c_tichgpageurl;
	}

	public void setC_tichgpageurl(String c_tichgpageurl) {
		this.c_tichgpageurl = c_tichgpageurl;
	}

	public String getC_servicename() {
		return c_servicename;
	}

	public void setC_servicename(String c_servicename) {
		this.c_servicename = c_servicename;
	}

	public String getC_tichgpage() {
		return c_tichgpage;
	}

	public void setC_tichgpage(String c_tichgpage) {
		this.c_tichgpage = c_tichgpage;
	}

	public String getC_tidetailpage() {
		return c_tidetailpage;
	}

	public void setC_tidetailpage(String c_tidetailpage) {
		this.c_tidetailpage = c_tidetailpage;
	}

	public String getC_urlparam() {
		return c_urlparam;
	}

	public void setC_urlparam(String c_urlparam) {
		this.c_urlparam = c_urlparam;
	}

	public String getC_arccomncode() {
		return c_arccomncode;
	}

	public void setC_arccomncode(String c_arccomncode) {
		this.c_arccomncode = c_arccomncode;
	}

	public String getC_tivisible() {
		return c_tivisible;
	}

	public void setC_tivisible(String c_tivisible) {
		this.c_tivisible = c_tivisible;
	}

	public String getC_lnkcode() {
		return c_lnkcode;
	}

	public void setC_lnkcode(String c_lnkcode) {
		this.c_lnkcode = c_lnkcode;
	}

	public String getC_tiapprover() {
		return c_tiapprover;
	}

	public void setC_tiapprover(String c_tiapprover) {
		this.c_tiapprover = c_tiapprover;
	}

	public String getC_tilastdate() {
		return c_tilastdate;
	}

	public void setC_tilastdate(String c_tilastdate) {
		this.c_tilastdate = c_tilastdate;
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