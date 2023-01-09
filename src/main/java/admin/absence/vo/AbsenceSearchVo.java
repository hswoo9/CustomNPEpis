package admin.absence.vo;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @title 
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 7. 18.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 7. 18.  박기환        최초 생성
 *
 */
public class AbsenceSearchVo extends AbsenceManage {
	
	/**
	 * 페이지 정보
	 */
	private PaginationInfo paginationInfo=new PaginationInfo();

	/**
	 * paginationInfo attribute 값을 리턴한다.
	 * @return paginationInfo
	 */
	public PaginationInfo getPaginationInfo() {
		return paginationInfo;
	}

	/**
	 * paginationInfo attribute 값을 설정한다.
	 * @param paginationInfo PaginationInfo
	 */
	public void setPaginationInfo(PaginationInfo paginationInfo) {
		this.paginationInfo = paginationInfo;
	}
}
