/*
 * Copyright work by Duzon Newturns.,
 * All rights reserved.
 */
package neos.edoc.document.record.vo;

import java.io.Serializable;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import neos.cmm.vo.SearchParamVO;

/**
 *<pre>
 * 1. Package Name	: neos.edoc.document.record.vo
 * 2. Class Name	: OuterRecordBordVO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2013. 7. 2.     work       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public class OuterRecordBordVO extends SearchParamVO{

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
}
 

