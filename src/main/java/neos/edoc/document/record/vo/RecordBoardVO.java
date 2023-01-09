package neos.edoc.document.record.vo;

import java.io.Serializable;

import neos.cmm.vo.SearchParamVO;

import org.apache.commons.lang.builder.ToStringBuilder;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @title RecordBoardVO.java
 *
 * @date 2016. 11. 21.
 */
@SuppressWarnings("serial")
public class RecordBoardVO extends SearchParamVO implements Serializable {
    
    private String lang_code = "";
    
	/** 연동문서 여부 */
	private String c_linkyn = "" ;
	private String c_lnkcode = "" ;

	/** 열람자명 */
	private String c_rsusername = "";

	/** 문서키코드 */
	private String c_dikeycode = "";
	
	/** 편철날짜 */
	private String c_riregdate = "";	

	/** 생산 구분 */
	private String c_ritypeflag = "";

	/** 생산 구분명 */
	private String c_ritypeflagname = "";	

	/** 담당자코드 */
	private String c_riuserkey = "";

	/** 담당자id */
	private String c_uiuserid = "";
	
	/** 기록물철keycode */
	private String c_aikeycode = "";
	
	private String c_sireceivecode = "";
	
	private String c_sireceivename = "";
	
	private String sendername = "";
	
	private String c_kluserkey = "";
	
	private String c_disecretgrade = "";
	
	private String c_diflagname = "";
	
	private String c_approvalstatus = "" ;
	private String c_approvalstatusname = "" ;
	private String selectFlag = "";
	
	private String c_ridrafter = "" ;
	private String c_ristatus = "" ;
	private String preservename = "";
	private String readingtype = "";
	
	private boolean inorder = false;
	
	private String fileId = "";
	
	private String c_didocsize = "";
	
	private String c_risendorgname = "";
	private String c_risenddeptname = "";
	public boolean isInorder() {
		return inorder;
	}

	public void setInorder(boolean inorder) {
		this.inorder = inorder;
	}

	public String getReadingtype() {
		return readingtype;
	}

	public void setReadingtype(String readingtype) {
		this.readingtype = readingtype;
	}

	public String getPreservename() {
		return preservename;
	}

	public void setPreservename(String preservename) {
		this.preservename = preservename;
	}

	public String getC_ristatus() {
		return c_ristatus;
	}

	public void setC_ristatus(String c_ristatus) {
		this.c_ristatus = c_ristatus;
	}

	public String getC_ridrafter() {
		return c_ridrafter;
	}

	public void setC_ridrafter(String c_ridrafter) {
		this.c_ridrafter = c_ridrafter;
	}

	/** 문서구분**/
    private String c_didocflag = "";
	
	
	public String getSelectFlag() {
		return selectFlag;
	}

	public void setSelectFlag(String selectFlag) {
		this.selectFlag = selectFlag;
	}

	public String getC_diflagname() {
		return c_diflagname;
	}

	public void setC_diflagname(String c_diflagname) {
		this.c_diflagname = c_diflagname;
	}

	public String getC_disecretgrade() {
		return c_disecretgrade;
	}

	public void setC_disecretgrade(String c_disecretgrade) {
		this.c_disecretgrade = c_disecretgrade;
	}

	public String getC_kluserkey() {
		return c_kluserkey;
	}

	public void setC_kluserkey(String c_kluserkey) {
		this.c_kluserkey = c_kluserkey;
	}

	public String getC_sireceivecode() {
		return c_sireceivecode;
	}

	public void setC_sireceivecode(String c_sireceivecode) {
		this.c_sireceivecode = c_sireceivecode;
	}

	public String getC_sireceivename() {
		return c_sireceivename;
	}

	public void setC_sireceivename(String c_sireceivename) {
		this.c_sireceivename = c_sireceivename;
	}

	public String getSendername() {
		return sendername;
	}

	public void setSendername(String sendername) {
		this.sendername = sendername;
	}
	
	public String getC_rsusername() {
		return c_rsusername;
	}

	public void setC_rsusername(String c_rsusername) {
		this.c_rsusername = c_rsusername;
	}

	public String getC_aikeycode() {
		return c_aikeycode;
	}

	public void setC_aikeycode(String c_aikeycode) {
		this.c_aikeycode = c_aikeycode;
	}

	public String getC_uiuserid() {
		return c_uiuserid;
	}

	public void setC_uiuserid(String c_uiuserid) {
		this.c_uiuserid = c_uiuserid;
	}

	/** 첨부파일여부 */
	private String attachcount = "";		
	
	/** 메모체크 */
	private String summarycheck = "";
	
	/** 메모체크 */
	private String memocheck = "";
	
	/** 삭제여부 */
    private String c_rideleteopt = "";
    
    /** 문서번호 */
    private String c_ridocnum = "";
    
    public String getC_ridocnum() {
		return c_ridocnum;
	}

	public void setC_ridocnum(String c_ridocnum) {
		this.c_ridocnum = c_ridocnum;
	}

	/** 변경후시행일자 */
    private String c_riafterenforce = "";	

	/** 파일경로 */
    private String c_difilepath = "";
    
    /** 전자비전자구분 */
    private String c_diflag = "";
    
    /** 단위업무명 */
    private String c_winame = "";
    
    /** 기록물철명 */
    private String c_aititle = "";
    
    /** 변경후수신처 */
    private String c_riafterreceive = "";
    
    /** 문서번호 */
    private String fulldocnumber = "";
    
    /** 편철여부 */
    private String c_aiokflag = "";
    
    /** 문서번호 */
    private String docnumForUser = "";
    
    /** 파일확장자명 */
    private String fileType = "";
    
    /** 대내,외 */
    private String c_didoctype ="";
    
    /** 시행일자 */
    private String dienforceForUser = "";
    
    /** 공개여부 */
    private String c_dipublic ="";
    
    /** 부서코드 */
    private String c_oiorgcode ="";
    
    /** 문서도착날짜 */
    private String c_riarrivedate ="";
    
    /** 수신기관 */
    private String c_rsorgname ="";
    
    /** 열람자 */
    private String c_rsuserkey ="";
    
   	/** 수신부서 */
    private String c_rsdeptname ="";
    
    /** 수신부서 */
    private String c_riflagname ="";
    
    /** 첨부유무 */
    private int c_filecount = 0;
    
    /** 열람자id */
    private String readingUserId ="";
    
    /** 열람자name */
    private String readingUserNm ="";    
    
    private String c_difiletype = "";
	private String c_rsorgcode ="";
    private String c_rsseqnum ="";
    private String c_rsnowopt ="";
    private String c_rsday ="";
    private String c_rstime ="";
    private String c_rsokflag ="";
    private String c_rsmemo ="";
    private String c_rsreceiveday ="";
    private String c_rsreceivetime ="";
    private String didoctype = "";
    private String c_aipreserve = "";
    private String c_dimemo = "";
    private String c_riform = "";
    private String c_rikind = "";
    private String c_dititle2 = "";
    private String c_riafterpage = "";    
	private String likeycode = "";
    private String c_dikeycodeNew = "";
    private String c_rireseq = "";
    private String c_digrade ="";
    private String c_rispacial ="";
    private String c_riusername ="";
    private String c_dienforce ="";
    private String positionname ="";
    private String c_riorgnum ="";
    private String c_rireturnflag ="";
    private String c_didocgrade ="";
    private String c_aiseqnum = "";
    private String c_aifilename = "";
    private String c_aifiletype = "";
    private String c_aisize = "";
    private String c_kpinum = "";
    private String c_kpiname = "";
    private String c_kpigubun = "";
    private String c_kpiorg = "";    
    private String senderusername = "";

	private String tempattnm = "";
    private String realattnm = "";    
    
    
    public String getSenderusername() {
		return senderusername;
	}

	public void setSenderusername(String senderusername) {
		this.senderusername = senderusername;
	}

	public String getC_didocflag() {
        return c_didocflag;
    }

    public void setC_didocflag(String c_didocflag) {
        this.c_didocflag = c_didocflag;
    }

    public String getC_difiletype() {
		return c_difiletype;
	}

	public void setC_difiletype(String c_difiletype) {
		this.c_difiletype = c_difiletype;
	}
    
    public String getC_kpinum() {
		return c_kpinum;
	}

	public void setC_kpinum(String c_kpinum) {
		this.c_kpinum = c_kpinum;
	}

	public String getC_kpiname() {
		return c_kpiname;
	}

	public void setC_kpiname(String c_kpiname) {
		this.c_kpiname = c_kpiname;
	}

	public String getC_kpigubun() {
		return c_kpigubun;
	}

	public void setC_kpigubun(String c_kpigubun) {
		this.c_kpigubun = c_kpigubun;
	}

	public String getC_kpiorg() {
		return c_kpiorg;
	}

	public void setC_kpiorg(String c_kpiorg) {
		this.c_kpiorg = c_kpiorg;
	}

	public String getC_aiseqnum() {
		return c_aiseqnum;
	}

	public void setC_aiseqnum(String c_aiseqnum) {
		this.c_aiseqnum = c_aiseqnum;
	}

	public String getC_aifilename() {
		return c_aifilename;
	}

	public void setC_aifilename(String c_aifilename) {
		this.c_aifilename = c_aifilename;
	}

	public String getC_aifiletype() {
		return c_aifiletype;
	}

	public void setC_aifiletype(String c_aifiletype) {
		this.c_aifiletype = c_aifiletype;
	}

	public String getC_aisize() {
		return c_aisize;
	}

	public void setC_aisize(String c_aisize) {
		this.c_aisize = c_aisize;
	}

	public String getC_digrade() {
		return c_digrade;
	}

	public void setC_digrade(String c_digrade) {
		this.c_digrade = c_digrade;
	}

	public String getC_rispacial() {
		return c_rispacial;
	}

	public void setC_rispacial(String c_rispacial) {
		this.c_rispacial = c_rispacial;
	}

	public String getC_riusername() {
		return c_riusername;
	}

	public void setC_riusername(String c_riusername) {
		this.c_riusername = c_riusername;
	}

	public String getC_dienforce() {
		return c_dienforce;
	}

	public void setC_dienforce(String c_dienforce) {
		this.c_dienforce = c_dienforce;
	}

	public String getPositionname() {
		return positionname;
	}

	public void setPositionname(String positionname) {
		this.positionname = positionname;
	}

	public String getC_riorgnum() {
		return c_riorgnum;
	}

	public void setC_riorgnum(String c_riorgnum) {
		this.c_riorgnum = c_riorgnum;
	}

	public String getC_rireturnflag() {
		return c_rireturnflag;
	}

	public void setC_rireturnflag(String c_rireturnflag) {
		this.c_rireturnflag = c_rireturnflag;
	}

	public String getC_didocgrade() {
		return c_didocgrade;
	}

	public void setC_didocgrade(String c_didocgrade) {
		this.c_didocgrade = c_didocgrade;
	}

	public String getC_rireseq() {
		return c_rireseq;
	}

	public void setC_rireseq(String c_rireseq) {
		this.c_rireseq = c_rireseq;
	}

	public String getC_riafterpage() {
		return c_riafterpage;
	}

	public void setC_riafterpage(String c_riafterpage) {
		this.c_riafterpage = c_riafterpage;
	}  

	public String getC_dikeycodeNew() {
		return c_dikeycodeNew;
	}

	public void setC_dikeycodeNew(String c_dikeycodeNew) {
		this.c_dikeycodeNew = c_dikeycodeNew;
	}

	public String getLikeycode() {
		return likeycode;
	}

	public void setLikeycode(String likeycode) {
		this.likeycode = likeycode;
	}

	public String getC_dimemo() {
		return c_dimemo;
	}

	public void setC_dimemo(String c_dimemo) {
		this.c_dimemo = c_dimemo;
	}

	public String getC_riform() {
		return c_riform;
	}

	public void setC_riform(String c_riform) {
		this.c_riform = c_riform;
	}

	public String getC_rikind() {
		return c_rikind;
	}

	public void setC_rikind(String c_rikind) {
		this.c_rikind = c_rikind;
	}

	public String getC_dititle2() {
		return c_dititle2;
	}

	public void setC_dititle2(String c_dititle2) {
		this.c_dititle2 = c_dititle2;
	}

	public String getC_aipreserve() {
		return c_aipreserve;
	}

	public void setC_aipreserve(String c_aipreserve) {
		this.c_aipreserve = c_aipreserve;
	}

	public String getDidoctype() {
		return didoctype;
	}

	public void setDidoctype(String didoctype) {
		this.didoctype = didoctype;
	}

	private int readingSeq = 1;
    
    public int getReadingSeq() {
		return readingSeq;
	}

	public void setReadingSeq(int readingSeq) {
		this.readingSeq = readingSeq;
	}

	public String getReadingUserNm() {
		return readingUserNm;
	}

	public void setReadingUserNm(String readingUserNm) {
		this.readingUserNm = readingUserNm;
	}

	public String getReadingUserId() {
		return readingUserId;
	}

	public void setReadingUserId(String readingUserId) {
		this.readingUserId = readingUserId;
	}

	public int getC_filecount() {
		return c_filecount;
	}

	public void setC_filecount(int c_filecount) {
		this.c_filecount = c_filecount;
	}

	public String getC_riflagname() {
		return c_riflagname;
	}

	public void setC_riflagname(String c_riflagname) {
		this.c_riflagname = c_riflagname;
	}

	public String getC_rsdeptname() {
		return c_rsdeptname;
	}

	public void setC_rsdeptname(String c_rsdeptname) {
		this.c_rsdeptname = c_rsdeptname;
	}

	public String getC_rsorgname() {
		return c_rsorgname;
	}

	public void setC_rsorgname(String c_rsorgname) {
		this.c_rsorgname = c_rsorgname;
	}

	public String getC_riarrivedate() {
		return c_riarrivedate;
	}

	public void setC_riarrivedate(String c_riarrivedate) {
		this.c_riarrivedate = c_riarrivedate;
	}

	public String getC_oiorgcode() {
		return c_oiorgcode;
	}

	public void setC_oiorgcode(String c_oiorgcode) {
		this.c_oiorgcode = c_oiorgcode;
	}

	public String getC_dipublic() {
		return c_dipublic;
	}

	public void setC_dipublic(String c_dipublic) {
		this.c_dipublic = c_dipublic;
	}

	public String getDienforceForUser() {
		return dienforceForUser;
	}

	public void setDienforceForUser(String dienforceForUser) {
		this.dienforceForUser = dienforceForUser;
	}

	public String getC_didoctype() {
		return c_didoctype;
	}

	public void setC_didoctype(String c_didoctype) {
		this.c_didoctype = c_didoctype;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getC_dikeycode() {
		return c_dikeycode;
	}

	public void setC_dikeycode(String c_dikeycode) {
		this.c_dikeycode = c_dikeycode;
	}

	public String getC_riregdate() {
		return c_riregdate;
	}

	public void setC_riregdate(String c_riregdate) {
		this.c_riregdate = c_riregdate;
	}

	public String getC_ritypeflag() {
		return c_ritypeflag;
	}

	public void setC_ritypeflag(String c_ritypeflag) {
		this.c_ritypeflag = c_ritypeflag;
	}

	public String getC_ritypeflagname() {
		return c_ritypeflagname;
	}

	public void setC_ritypeflagname(String c_ritypeflagname) {
		this.c_ritypeflagname = c_ritypeflagname;
	}

	public String getC_riuserkey() {
		return c_riuserkey;
	}

	public void setC_riuserkey(String c_riuserkey) {
		this.c_riuserkey = c_riuserkey;
	}

	public String getAttachcount() {
		return attachcount;
	}

	public void setAttachcount(String attachcount) {
		this.attachcount = attachcount;
	}

	public String getSummarycheck() {
		return summarycheck;
	}

	public void setSummarycheck(String summarycheck) {
		this.summarycheck = summarycheck;
	}

	public String getMemocheck() {
		return memocheck;
	}

	public void setMemocheck(String memocheck) {
		this.memocheck = memocheck;
	}

	public String getC_rideleteopt() {
		return c_rideleteopt;
	}

	public void setC_rideleteopt(String c_rideleteopt) {
		this.c_rideleteopt = c_rideleteopt;
	}

	public String getC_riafterenforce() {
		return c_riafterenforce;
	}

	public void setC_riafterenforce(String c_riafterenforce) {
		this.c_riafterenforce = c_riafterenforce;
	}

	public String getC_difilepath() {
		return c_difilepath;
	}

	public void setC_difilepath(String c_difilepath) {
		this.c_difilepath = c_difilepath;
	}

	public String getC_diflag() {
		return c_diflag;
	}

	public void setC_diflag(String c_diflag) {
		this.c_diflag = c_diflag;
	}

	public String getC_winame() {
		return c_winame;
	}

	public void setC_winame(String c_winame) {
		this.c_winame = c_winame;
	}

	public String getC_aititle() {
		return c_aititle;
	}

	public void setC_aititle(String c_aititle) {
		this.c_aititle = c_aititle;
	}

	public String getC_riafterreceive() {
		return c_riafterreceive;
	}

	public void setC_riafterreceive(String c_riafterreceive) {
		this.c_riafterreceive = c_riafterreceive;
	}

	public String getFulldocnumber() {
		return fulldocnumber;
	}

	public void setFulldocnumber(String fulldocnumber) {
		this.fulldocnumber = fulldocnumber;
	}

	public String getC_aiokflag() {
		return c_aiokflag;
	}

	public void setC_aiokflag(String c_aiokflag) {
		this.c_aiokflag = c_aiokflag;
	}

	public String getDocnumForUser() {
		return docnumForUser;
	}

	public void setDocnumForUser(String docnumForUser) {
		this.docnumForUser = docnumForUser;
	}

	public String getResult_count() {
		return result_count;
	}

	public void setResult_count(String result_count) {
		this.result_count = result_count;
	}
	
	 public String getC_rsuserkey() {
			return c_rsuserkey;
	}

	public void setC_rsuserkey(String c_rsuserkey) {
		this.c_rsuserkey = c_rsuserkey;
	}
	
	public String getC_rsorgcode() {
		return c_rsorgcode;
	}

	public void setC_rsorgcode(String c_rsorgcode) {
		this.c_rsorgcode = c_rsorgcode;
	}

	public String getC_rsseqnum() {
		return c_rsseqnum;
	}

	public void setC_rsseqnum(String c_rsseqnum) {
		this.c_rsseqnum = c_rsseqnum;
	}

	public String getC_rsnowopt() {
		return c_rsnowopt;
	}

	public void setC_rsnowopt(String c_rsnowopt) {
		this.c_rsnowopt = c_rsnowopt;
	}

	public String getC_rsday() {
		return c_rsday;
	}

	public void setC_rsday(String c_rsday) {
		this.c_rsday = c_rsday;
	}

	public String getC_rstime() {
		return c_rstime;
	}

	public void setC_rstime(String c_rstime) {
		this.c_rstime = c_rstime;
	}

	public String getC_rsokflag() {
		return c_rsokflag;
	}

	public void setC_rsokflag(String c_rsokflag) {
		this.c_rsokflag = c_rsokflag;
	}

	public String getC_rsmemo() {
		return c_rsmemo;
	}

	public void setC_rsmemo(String c_rsmemo) {
		this.c_rsmemo = c_rsmemo;
	}

	public String getC_rsreceiveday() {
		return c_rsreceiveday;
	}

	public void setC_rsreceiveday(String c_rsreceiveday) {
		this.c_rsreceiveday = c_rsreceiveday;
	}

	public String getC_rsreceivetime() {
		return c_rsreceivetime;
	}

	public void setC_rsreceivetime(String c_rsreceivetime) {
		this.c_rsreceivetime = c_rsreceivetime;
	}

    public String getTempattnm() {
		return tempattnm;
	}

	public void setTempattnm(String tempattnm) {
		this.tempattnm = tempattnm;
	}

	public String getRealattnm() {
		return realattnm;
	}

	public void setRealattnm(String realattnm) {
		this.realattnm = realattnm;
	}
	
	
	/** 총리스트 */
	private String result_count = "";    
    
	/** 검색시작일 */
    private String searchBgnDe = "";		

	/** 검색조건 */
    private String searchCnd = "";
    
    /** 검색종료일 */
    private String searchEndDe = "";
    
    /** 검색단어 */
    private String searchWrd = "";
    
    /** 정렬순서(DESC,ASC) */
    private long sortOrdr = 0L;

    /** 검색사용여부 */
    private String searchUseYn = "";

    /** 페이지갯수 */
    private int pageUnit = 10;

    /** 페이지사이즈 */
    private int pageSize = 10;

    /** 첫페이지 인덱스 */
    private int firstIndex = 1;

    /** 마지막페이지 인덱스 */
    private int lastIndex = 1;

    /** 페이지당 레코드 개수 */
    private int recordCountPerPage = 10;

    /** 레코드 번호 */
    private int rowNo = 0;    
    
    //---------------------------------
    // 2009.06.29 : 2단계 기능 추가
    //---------------------------------
    /** 하위 페이지 인덱스 (댓글 및 만족도 조사 여부 확인용) */
    private String subPageIndex = "";
    ////-------------------------------
    
    //** 조회 함수명 */
    private String jsFunction = "";

	
	/**
     * searchBgnDe attribute를 리턴한다.
     * 
     * @return the searchBgnDe
     */
    public String getSearchBgnDe() {
	return searchBgnDe;
    }

    /**
     * searchBgnDe attribute 값을 설정한다.
     * 
     * @param searchBgnDe
     *            the searchBgnDe to set
     */
    public void setSearchBgnDe(String searchBgnDe) {
	this.searchBgnDe = searchBgnDe;
    }

    /**
     * searchCnd attribute를 리턴한다.
     * 
     * @return the searchCnd
     */
    public String getSearchCnd() {
	return searchCnd;
    }

    /**
     * searchCnd attribute 값을 설정한다.
     * 
     * @param searchCnd
     *            the searchCnd to set
     */
    public void setSearchCnd(String searchCnd) {
	this.searchCnd = searchCnd;
    }

    /**
     * searchEndDe attribute를 리턴한다.
     * 
     * @return the searchEndDe
     */
    public String getSearchEndDe() {
	return searchEndDe;
    }

    /**
     * searchEndDe attribute 값을 설정한다.
     * 
     * @param searchEndDe
     *            the searchEndDe to set
     */
    public void setSearchEndDe(String searchEndDe) {
	this.searchEndDe = searchEndDe;
    }

    /**
     * searchWrd attribute를 리턴한다.
     * 
     * @return the searchWrd
     */
    public String getSearchWrd() {
	return searchWrd;
    }

    /**
     * searchWrd attribute 값을 설정한다.
     * 
     * @param searchWrd
     *            the searchWrd to set
     */
    public void setSearchWrd(String searchWrd) {
	this.searchWrd = searchWrd;
    }

    /**
     * sortOrdr attribute를 리턴한다.
     * 
     * @return the sortOrdr
     */
    public long getSortOrdr() {
	return sortOrdr;
    }

    /**
     * sortOrdr attribute 값을 설정한다.
     * 
     * @param sortOrdr
     *            the sortOrdr to set
     */
    public void setSortOrdr(long sortOrdr) {
	this.sortOrdr = sortOrdr;
    }

    /**
     * searchUseYn attribute를 리턴한다.
     * 
     * @return the searchUseYn
     */
    public String getSearchUseYn() {
	return searchUseYn;
    }

    /**
     * searchUseYn attribute 값을 설정한다.
     * 
     * @param searchUseYn
     *            the searchUseYn to set
     */
    public void setSearchUseYn(String searchUseYn) {
	this.searchUseYn = searchUseYn;
    }

    /**
     * pageUnit attribute를 리턴한다.
     * 
     * @return the pageUnit
     */
    public int getPageUnit() {
	return pageUnit;
    }

    /**
     * pageUnit attribute 값을 설정한다.
     * 
     * @param pageUnit
     *            the pageUnit to set
     */
    public void setPageUnit(int pageUnit) {
	this.pageUnit = pageUnit;
    }

    /**
     * pageSize attribute를 리턴한다.
     * 
     * @return the pageSize
     */
    public int getPageSize() {
	return pageSize;
    }

    /**
     * pageSize attribute 값을 설정한다.
     * 
     * @param pageSize
     *            the pageSize to set
     */
    public void setPageSize(int pageSize) {
	this.pageSize = pageSize;
    }

    /**
     * firstIndex attribute를 리턴한다.
     * 
     * @return the firstIndex
     */
    public int getFirstIndex() {
	return firstIndex;
    }

    /**
     * firstIndex attribute 값을 설정한다.
     * 
     * @param firstIndex
     *            the firstIndex to set
     */
    public void setFirstIndex(int firstIndex) {
	this.firstIndex = firstIndex;
    }

    /**
     * lastIndex attribute를 리턴한다.
     * 
     * @return the lastIndex
     */
    public int getLastIndex() {
	return lastIndex;
    }

    /**
     * lastIndex attribute 값을 설정한다.
     * 
     * @param lastIndex
     *            the lastIndex to set
     */
    public void setLastIndex(int lastIndex) {
	this.lastIndex = lastIndex;
    }

    /**
     * recordCountPerPage attribute를 리턴한다.
     * 
     * @return the recordCountPerPage
     */
    public int getRecordCountPerPage() {
	return recordCountPerPage;
    }

    /**
     * recordCountPerPage attribute 값을 설정한다.
     * 
     * @param recordCountPerPage
     *            the recordCountPerPage to set
     */
    public void setRecordCountPerPage(int recordCountPerPage) {
	this.recordCountPerPage = recordCountPerPage;
    }

    /**
     * rowNo attribute를 리턴한다.
     * 
     * @return the rowNo
     */
    public int getRowNo() {
	return rowNo;
    }

    /**
     * rowNo attribute 값을 설정한다.
     * 
     * @param rowNo
     *            the rowNo to set
     */
    public void setRowNo(int rowNo) {
	this.rowNo = rowNo;    }

    

    /**
     * subPageIndex attribute를 리턴한다.
     * @return the subPageIndex
     */
    public String getSubPageIndex() {
        return subPageIndex;
    }

    /**
     * subPageIndex attribute 값을 설정한다.
     * @param subPageIndex the subPageIndex to set
     */
    public void setSubPageIndex(String subPageIndex) {
        this.subPageIndex = subPageIndex;
    }

    /**
     * toString 메소드를 대치한다.
     */
    public String toString() {
	return ToStringBuilder.reflectionToString(this);
    }        
 
	public String getJsFunction() {
		return jsFunction;
	}

	public void setJsFunction(String jsFunction) {
		this.jsFunction = jsFunction;
	}	
	public String getC_linkyn() {
		return c_linkyn;
	}

	public void setC_linkyn(String c_linkyn) {
		this.c_linkyn = c_linkyn;
	}
	
	
	public String getC_approvalstatus() {
		return c_approvalstatus;
	}

	public void setC_approvalstatus(String c_approvalstatus) {
		this.c_approvalstatus = c_approvalstatus;
	}

	public String getC_approvalstatusname() {
		return c_approvalstatusname;
	}

	public void setC_approvalstatusname(String c_approvalstatusname) {
		this.c_approvalstatusname = c_approvalstatusname;
	}
	public String getC_lnkcode() {
		return c_lnkcode;
	}

	public void setC_lnkcode(String c_lnkcode) {
		this.c_lnkcode = c_lnkcode;
	}
	@Override
	public PaginationInfo getPaginationInfo() {
		
		PaginationInfo paginationInfo = super.getPaginationInfo();		
		int num = paginationInfo.getCurrentPageNo();
		if(num==0){

			paginationInfo.setCurrentPageNo(1);
			paginationInfo.setPageSize(1);
			paginationInfo.setRecordCountPerPage(1);
			paginationInfo.setTotalRecordCount(1);
		}		
		return paginationInfo;
	}

    public String getLang_code() {
        return lang_code;
    }

    public void setLang_code(String lang_code) {
        this.lang_code = lang_code;
    }

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public String getC_didocsize() {
		return c_didocsize;
	}

	public void setC_didocsize(String c_didocsize) {
		this.c_didocsize = c_didocsize;
	}

	public String getC_risendorgname() {
		return c_risendorgname;
	}

	public void setC_risendorgname(String c_risendorgname) {
		this.c_risendorgname = c_risendorgname;
	}

	public String getC_risenddeptname() {
		return c_risenddeptname;
	}

	public void setC_risenddeptname(String c_risenddeptname) {
		this.c_risenddeptname = c_risenddeptname;
	}
	

}
