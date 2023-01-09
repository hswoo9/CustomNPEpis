package neos.cmm.util.jstree;

/**
 * 
 * @title jsTree DAO VO
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 5. 3.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 3.  박기환        최초 생성
 * 2012. 5. 12.  김석환        mdata(json 형태) 추가
 *
 */
public class TreeDaoVO {
	


	/**
	 * Depth Level 
	 */
	private int level = 1;
	
	/**
	 * 현재 컨텐츠 id
	 */
	private String contentId = "";
	
	/**
	 * 컨텐츠 이름
	 */
	private String contentNm = "";
	
	/**
	 * 상위 content_id
	 */
	private String upperContentId = "";
	
	/**
	 * 트리 상태(열림, 닫힘)
	 */
	private String state = "";
	
	/**
	 * 링크 url
	 */
	private String url = "";	
	
	/**
	 * 컨텐츠 형태
	 */
	private String rel = "";
	
	/**
	 * 하위 링크 갯수
	 */
	private int lowRankCount = 0;
	
	/**
	 * 서열
	 */
	private int ord = 0;
	
	/**
	 * 컨텐츠 타입(기관:O, 부서:D)
	 * 서식 타입(ROOT : R, 종류 : T, 양식 :F)
	 */
	private String contentType = "";
	
	/**
	 * 아이콘 주소
	 */
	private String icon = "";
	
	/**
	 * data
	 */	
	private String mdata;		
	
	private String originname;
	
	/**
	 * 권한 CRUDM유무(0:사용안함, 1:사용함)
	 */	
	private String crudmYn = "0";
	
    private String mbtlnum; // 모바일넘버
    
    private String emplyrSttusCode; // 직원 상태값 (999:재직, 004:휴직, d:삭제)
    
    public String getOriginname() {
		return originname;
	}

	public void setOriginname(String originname) {
		this.originname = originname;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getContentId() {
		return contentId;
	}

	public void setContentId(String contentId) {
		this.contentId = contentId;
	}

	public String getContentNm() {
		return contentNm;
	}

	public void setContentNm(String contentNm) {
		this.contentNm = contentNm;
	}

	public String getUpperContentId() {
		return upperContentId;
	}

	public void setUpperContentId(String upperContentId) {
		this.upperContentId = upperContentId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getRel() {
		return rel;
	}

	public void setRel(String rel) {
		this.rel = rel;
	}

	public int getLowRankCount() {
		return lowRankCount;
	}

	public void setLowRankCount(int lowRankCount) {
		this.lowRankCount = lowRankCount;
	}

	public int getOrd() {
		return ord;
	}

	public void setOrd(int ord) {
		this.ord = ord;
	}
	public String getMdata() {
		return mdata;
	}

	public void setMdata(String mdata) {
		this.mdata = mdata;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public String getCrudmYn() {
		return crudmYn;
	}

	public void setCrudmYn(String crudmYn) {
		this.crudmYn = crudmYn;
	}

    public String getMbtlnum() {
        return mbtlnum;
    }

    public String getEmplyrSttusCode() {
		return emplyrSttusCode;
	}

	public void setEmplyrSttusCode(String emplyrSttusCode) {
		this.emplyrSttusCode = emplyrSttusCode;
	}

	public void setMbtlnum(String mbtlnum) {
        this.mbtlnum = mbtlnum;
    }
	
}
