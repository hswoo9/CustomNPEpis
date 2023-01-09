package neos.edoc.eapproval.approvalbox.vo;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang.StringEscapeUtils;
/**
 * 
 * @title 
 * @author 공공사업부 포털개발팀 김석환
 * @since 2012. 4. 13.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 4. 13.  김석환        최초 생성
 *
 */
public class ApprovalDocumentVO 
{	
	private String c_dikeycode;
	private String deptname;
	private String c_diorgcode;
	private String username;
	private String c_diwriteday;
	private String c_diwritetime;
	private String docstatus;
	private String docstatus_ko;
	private String signtype;
	private String signtype_ko;
	private String summary;
	private String getfilecheck;
	private String getmemocheck;
	private String docproperty;
	private String doctype;
	private String doctype_code;
	private String rnum;
	private String min_key;
	private String max_key;
	private String cnt;
	private String document;
	private String c_difiletype;
	private String c_dititle;
	private String deptstatus;
	private String c_difilepath;
	private String c_didocgrade;
	private String docgradename;
	private String returnflag;
	private String documentcode;
	private String c_diuserkey;
	private String c_diproperty;
	private String c_tikeycode;
	private String c_diflag;
	private String c_didocflag;
	
	private String c_diflagname;
	private String c_didocflagname ;
	
	private String c_sumkeycode;
	private String docnumber;
	private String c_disecretgrade;
	private String iscanviewsecretdoc;
	private String dipublic;
	private String dipublic_ko;
	private String digrade;
	private String result_count;
	private String documenttype;
	private String c_cikind;
	private String c_miseqnum;
	private String c_diseqnum;
	private String c_klseqnum;
	private String subapprov;
	private String  memocount;
	private String  attachcount;
	private String c_readday;

	private String c_linkyn ;
	private String c_lnkcode;
	
	private String diPosionNm;
	private String diClassNm;
	
	private String middle_approvalyn ;
	
	private String c_ridocnum ;
	
	public String getC_ridocnum() {
		return c_ridocnum;
	}
	public void setC_ridocnum(String c_ridocnum) {
		this.c_ridocnum = c_ridocnum;
	}
	public String getMiddle_approvalyn() {
		return middle_approvalyn;
	}
	public void setMiddle_approvalyn(String middle_approvalyn) {
		this.middle_approvalyn = middle_approvalyn;
	}
	
	public String getC_lnkcode() {
		return c_lnkcode;
	}
	public void setC_lnkcode(String c_lnkcode) {
		this.c_lnkcode = c_lnkcode;
	}
	
	public String getC_readday() {
        return c_readday;
    }
    public void setC_readday(String c_readday) {
        this.c_readday = c_readday;
    }
    public String getAttachcount() {
	    if(attachcount == null) {
	        attachcount = "0";
        }
        return attachcount;
    }
    public void setAttachcount(String attachcount) {
        this.attachcount = attachcount;
    }
    public String getMemocount() {
	    if(memocount ==  null){
	        memocount = "0";
	    }
        return memocount;
    }
    public void setMemocount(String memocount) {
        this.memocount = memocount;
    }
    public String getDocumenttype() {
		return documenttype;
	}
	public void setDocumenttype(String documenttype) {
		this.documenttype = documenttype;
	}
	public String getC_cikind() {
		return c_cikind;
	}
	public void setC_cikind(String c_cikind) {
		this.c_cikind = c_cikind;
	}
	public String getC_dikeycode() {
		return c_dikeycode;
	}
	public void setC_dikeycode(String c_dikeycode) {
		this.c_dikeycode = c_dikeycode;
	}
	public String getDeptname() {
		return deptname;
	}
	public void setDeptname(String deptname) {
		this.deptname = deptname;
	}
	public String getC_diorgcode() {
		return c_diorgcode;
	}
	public void setC_diorgcode(String c_diorgcode) {
		this.c_diorgcode = c_diorgcode;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getC_diwriteday() {
		return c_diwriteday;//ConvertDate(c_diwriteday);
	}
	public void setC_diwriteday(String c_diwriteday) {
		this.c_diwriteday = c_diwriteday;
	}
	public String getC_diwritetime() {
		return c_diwritetime;
	}
	public void setC_diwritetime(String c_diwritetime) {
		this.c_diwritetime = c_diwritetime;
	}
	public String getDocstatus() {
		return docstatus;
	}
	public void setDocstatus(String docstatus) {
		this.docstatus = docstatus;
	}
	public String getDocstatus_ko() {
		return docstatus_ko;
	}
	public void setDocstatus_ko(String docstatus_ko) {
		this.docstatus_ko = docstatus_ko;
	}
	public String getSigntype() {
		return signtype;
	}
	public void setSigntype(String signtype) {
		this.signtype = signtype;
	}
	public String getSigntype_ko() {
		return signtype_ko;
	}
	public void setSigntype_ko(String signtype_ko) {
		this.signtype_ko = signtype_ko;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public String getGetfilecheck() {
		return getfilecheck;
	}
	public void setGetfilecheck(String getfilecheck) {
		this.getfilecheck = getfilecheck;
	}
	public String getGetmemocheck() {
		return getmemocheck;
	}
	public void setGetmemocheck(String getmemocheck) {
		this.getmemocheck = getmemocheck;
	}
	public String getDocproperty() {
		return docproperty;
	}
	public void setDocproperty(String docproperty) {
		this.docproperty = docproperty;
	}
	public String getDoctype() {
		return doctype;
	}
	public void setDoctype(String doctype) {
		this.doctype = doctype;
	}
	
	public String getDoctype_code() {
		return doctype_code;
	}
	public void setDoctype_code(String doctype_code) {
		this.doctype_code = doctype_code;
	}
	public String getRnum() {
		return rnum;
	}
	public void setRnum(String rnum) {
		this.rnum = rnum;
	}
	public String getMin_key() {
		return min_key;
	}
	public void setMin_key(String min_key) {
		this.min_key = min_key;
	}
	public String getMax_key() {
		return max_key;
	}
	public void setMax_key(String max_key) {
		this.max_key = max_key;
	}
	public String getCnt() {
		return cnt;
	}
	public void setCnt(String cnt) {
		this.cnt = cnt;
	}
	public String getDocument() {
		return document;
	}
	public void setDocument(String document) {
		this.document = document;
	}
	public String getC_difiletype() {
		return c_difiletype;
	}
	public void setC_difiletype(String c_difiletype) {
		this.c_difiletype = c_difiletype;
	}
	public String getC_dititle() {
		return c_dititle;
	}
	public void setC_dititle(String c_dititle) {
		this.c_dititle = c_dititle;
	}
	public String getDeptstatus() {
		return deptstatus;
	}
	public void setDeptstatus(String deptstatus) {
		this.deptstatus = deptstatus;
	}
	public String getC_difilepath() {
		return c_difilepath;
	}
	public void setC_difilepath(String c_difilepath) {
		this.c_difilepath = c_difilepath;
	}
	public String getC_didocgrade() {
		return c_didocgrade;
	}
	public void setC_didocgrade(String c_didocgrade) {
		this.c_didocgrade = c_didocgrade;
	}
	public String getDocgradename() {
		return docgradename;
	}
	public void setDocgradename(String docgradename) {
		this.docgradename = docgradename;
	}
	public String getReturnflag() {
		return returnflag;
	}
	public void setReturnflag(String returnflag) {
		this.returnflag = returnflag;
	}
	public String getDocumentcode() {
		return documentcode;
	}
	public void setDocumentcode(String documentcode) {
		this.documentcode = documentcode;
	}
	public String getC_diuserkey() {
		return c_diuserkey;
	}
	public void setC_diuserkey(String c_diuserkey) {
		this.c_diuserkey = c_diuserkey;
	}
	public String getC_diproperty() {
		return c_diproperty;
	}
	public void setC_diproperty(String c_diproperty) {
		this.c_diproperty = c_diproperty;
	}
	public String getC_tikeycode() {
		return c_tikeycode;
	}
	public void setC_tikeycode(String c_tikeycode) {
		this.c_tikeycode = c_tikeycode;
	}
	public String getC_diflag() {
		return c_diflag;
	}
	public void setC_diflag(String c_diflag) {
		this.c_diflag = c_diflag;
	}
	public String getC_sumkeycode() {
		return c_sumkeycode;
	}
	public void setC_sumkeycode(String c_sumkeycode) {
		this.c_sumkeycode = c_sumkeycode;
	}
	public String getDocnumber() {
		return docnumber;
	}
	public void setDocnumber(String docnumber) {
		this.docnumber = docnumber;
	}
	public String getC_disecretgrade() {
		return c_disecretgrade;
	}
	public void setC_disecretgrade(String c_disecretgrade) {
		this.c_disecretgrade = c_disecretgrade;
	}
	public String getIscanviewsecretdoc() {
		return iscanviewsecretdoc;
	}
	public void setIscanviewsecretdoc(String iscanviewsecretdoc) {
		this.iscanviewsecretdoc = iscanviewsecretdoc;
	}
	public String getDipublic() {
		return dipublic;
	}
	public void setDipublic(String dipublic) {
		this.dipublic = dipublic;
	}
	public String getDigrade() {
		return digrade;
	}
	public void setDigrade(String digrade) {
		this.digrade = digrade;
	}
	public String getResult_count() {
		return result_count;
	}
	public void setResult_count(String result_count) {
		this.result_count = result_count;
	}
	
	public String getDipublic_ko() {
		return dipublic_ko;
	}
	public void setDipublic_ko(String dipublic_ko) {
		this.dipublic_ko = dipublic_ko;
	}
	
	
	public String getC_miseqnum() {
		return c_miseqnum;
	}
	public void setC_miseqnum(String c_miseqnum) {
		this.c_miseqnum = c_miseqnum;
	}
	public String getC_diseqnum() {
		return c_diseqnum;
	}
	public void setC_diseqnum(String c_diseqnum) {
		this.c_diseqnum = c_diseqnum;
	}
	
	public String getC_klseqnum() {
		return c_klseqnum;
	}
	public void setC_klseqnum(String c_klseqnum) {
		this.c_klseqnum = c_klseqnum;
	}
	public String getSubapprov() {
		return subapprov;
	}
	public void setSubapprov(String subapprov) {
		this.subapprov = subapprov;
	}
	
	public String getC_didocflag() {
		return c_didocflag;
	}
	public void setC_didocflag(String c_didocflag) {
		this.c_didocflag = c_didocflag;
	}
	//yyyy-MM-dd 이런 날짜형 String을
	//yyyyMMdd 이런 형태로 변환하여 반환함
	public String ConvertDate(String datestring)
	{		
		System.out.println("datestring : " + datestring);
		String returnDate = "";
		String dateFormat_output = "yyyy-MM-dd";
		String  dateFormat_input= "yyyyMMdd";
		SimpleDateFormat format_input = new SimpleDateFormat(dateFormat_input);
		SimpleDateFormat format_output = new SimpleDateFormat(dateFormat_output);
		
		Date date = null;
		try {
			date = format_input.parse(datestring);	
			
		} catch (Exception e) {
			returnDate = datestring;
		}
		if(date!=null)
		{
			returnDate = format_output.format(date);
		}
		System.out.println("returnDate : " + returnDate);
		return returnDate;
	}
    public String getDiPosionNm() {
        return diPosionNm;
    }
    public void setDiPosionNm(String diPosionNm) {
        this.diPosionNm = diPosionNm;
    }
    public String getDiClassNm() {
        return diClassNm;
    }
    public void setDiClassNm(String diClassNm) {
        this.diClassNm = diClassNm;
    }
	public String getC_linkyn() {
		return c_linkyn;
	}
	public void setC_linkyn(String c_linkyn) {
		this.c_linkyn = c_linkyn;
	}
	public String getC_diflagname() {
		return c_diflagname;
	}
	public void setC_diflagname(String c_diflagname) {
		this.c_diflagname = c_diflagname;
	}
	public String getC_didocflagname() {
		return c_didocflagname;
	}
	public void setC_didocflagname(String c_didocflagname) {
		this.c_didocflagname = c_didocflagname;
	}    
	
}
