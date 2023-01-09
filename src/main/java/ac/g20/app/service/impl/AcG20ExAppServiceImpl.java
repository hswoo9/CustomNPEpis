package ac.g20.app.service.impl;

import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.duzon.custom.common.utiles.DateUtil;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import ac.g20.app.dao.AcG20ExAppErpDAO;
import ac.g20.app.dao.AcG20ExAppGwDAO;
import ac.g20.app.service.AcG20ExAppService;
import ac.g20.ex.dao.AcG20ExErpDAO;
import ac.g20.ex.dao.AcG20ExGwDAO;
import ac.g20.ex.service.AcG20ExService;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_D;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import ac.g20.ex.vo.Abdocu_TD;
import ac.g20.ex.vo.Abdocu_TD2;
import ac.g20.ex.vo.Abdocu_TH;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;


/**
 * @title acG20ExServiceImpl.java
 * @author doban7
 *
 * @date 2016. 9. 1.
 */
@Service ( "AcG20ExAppService" )
public class AcG20ExAppServiceImpl implements AcG20ExAppService {

	@Resource ( name = "AcG20ExErpDAO" )
	private AcG20ExErpDAO acG20ExErpDAO;
	@Resource ( name = "AcG20ExGwDAO" )
	private AcG20ExGwDAO acG20ExGwDAO;
	@Resource ( name = "AcG20ExAppErpDAO" )
	private AcG20ExAppErpDAO acG20ExAppErpDAO;
	@Resource ( name = "AcG20ExAppGwDAO" )
	private AcG20ExAppGwDAO acG20ExAppGwDAO;
	@Resource ( name = "AcCommonService" )
	AcCommonService acCommonService;
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	@Resource ( name = "AcG20ExService" )
	private AcG20ExService acG20ExService;
	private ConnectionVO conVo = new ConnectionVO( );

	/**
	 * GetConnection doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private ConnectionVO GetConnection ( Map<String, Object> param ) throws Exception {
		return acCommonService.acErpSystemInfo( param );
	}

	/**
	 * 
	 * getStringValue doban7 2016. 9. 26.
	 * 
	 * @param map
	 * @param key
	 * @return
	 */
	private String getStringValue ( Map<String, String> map, String key ) {
		String val = "0";
		if ( map.containsKey( key ) ) {
			if ( map.get( key ) != null ) {
				val = String.valueOf( map.get( key ) );
			}
		}
		return val;
	}

	@SuppressWarnings ( "unchecked" )
	@Override
	public Map<String, Object> docG20Approval ( Map<String, Object> paramMap ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> abDocuInfoMap = null;
		Map<String, Object> tempMap2 = null;
		String abDocuNo = (String) paramMap.get( "docxNumb" );
		Map<String, Object> param = new HashMap<String, Object>( );
		param.put( "abdocu_no", abDocuNo );
		Map<String, Object> abDocuMap = acG20ExAppGwDAO.getAppAbDocuH( param );
		Object temp = null;
		temp = abDocuMap.get( "ABDOCU_NO_REFFER" );
		String abdocuNoReffer = "";
		String curDate = DateUtil.getCurrentDate( "yyyy-MM-dd" );
		String proposalDate = "";
		String proposalYear = "";
		String proposalMonth = "";
		String proposalDay = "";
		if ( temp != null ) {
			abdocuNoReffer = temp.toString( );
		}
		Map<String, Object> referDocInfo = null;
		if ( !EgovStringUtil.isEmpty( abdocuNoReffer ) && paramMap.get( "refDocInfoList" ) == null ) {
			param.put( "abdocu_no_reffer", abdocuNoReffer );
			param.put( "langCode", loginVO.getLangCode( ) );
			List<Map<String, Object>> list = acG20ExAppGwDAO.getAppReferDocInfo( param );
			if ( list != null && list.size( ) > 0 ) {
				resultMap.put( "refDocInfoList", list ); //  g20 참고문서
				referDocInfo = list.get( 0 );
				proposalDate = (String) referDocInfo.get( "REFRIREGYMD" );
				if ( !EgovStringUtil.isEmpty( proposalDate ) ) {
					proposalYear = proposalDate.substring( 0, 4 );
					proposalMonth = proposalDate.substring( 5, 7 );
					proposalDay = proposalDate.substring( 8, 10 );
				}
			}
		}
		if ( EgovStringUtil.isEmpty( proposalDate ) ) {
			proposalDate = curDate;
			proposalYear = proposalDate.substring( 0, 4 );
			proposalMonth = proposalDate.substring( 5, 7 );
			proposalDay = proposalDate.substring( 8, 10 );
		}
		HashMap<String, String> abDocuParamMap = new HashMap<String, String>( );
		abDocuParamMap.put( "CO_CD", (String) abDocuMap.get( "ERP_CO_CD" ) );
		abDocuParamMap.put( "DIV_CD", (String) abDocuMap.get( "ERP_DIV_CD" ) );
		abDocuParamMap.put( "MGT_CD", (String) abDocuMap.get( "MGT_CD" ) );
		abDocuParamMap.put( "GISU_DT", (String) abDocuMap.get( "ERP_GISU_DT" ) );
		abDocuParamMap.put( "SUM_CT_AM", "0" );
		abDocuParamMap.put( "BOTTOM_CD", (String) abDocuMap.get( "BOTTOM_CD" ) );
		abDocuParamMap.put( "LANGKIND", "KR" );
		abDocuParamMap.put( "DOCU_MODE", abDocuMap.get( "DOCU_MODE" ).toString( ) );
		abDocuParamMap.put( "abDocuNo", abDocuNo );
		String mode = "0";
		String docxGubn = (String) paramMap.get( "ciKind" );
		if ( docxGubn.equals( "010" ) ) {
			mode = "0";
		}
		else {
			mode = "1";
		}
		int rowNum = 0;
		List<Map<String, Object>> abDocuBInfoList = acG20ExAppGwDAO.getAppAbDocuB_List( param );
		Map<String, Object> abDocuBInfoMap = null;
		if ( abDocuBInfoList != null )
			rowNum = abDocuBInfoList.size( );
		if ( rowNum == 0 ) {
			throw new Exception( "회계정보가 없습니다." );
		}
		String curAbgtCD = "";
		String prevAbgtCD = "";
		long abgtApplyAM = 0;
		long openAM = 0;
		long applyAM = 0;
		long leftAM = 0;
		long totalLeftAM = 0;
		long totalLeftReturnAM = 0;
		//		budgetInfoMap.put("ERP_APPLY_AM", tempMap2.get("ERP_APPLY_AM")  ); 
		//		budgetInfoMap.put("ERP_OPEN_AM", tempMap2.get("ERP_OPEN_AM")  ); 
		//		budgetInfoMap.put("ERP_LEFT_AM", tempMap2.get("ERP_LEFT_AM")  );	
		long erpApplyAM = 0;
		long erpOpenAM = 0;
		long erpLeftAM = 0;
		long totalErpLeftAM = 0;
		long totalErpLeftReturnAM = 0;
		long erpAcceptAM = 0;
		//		String dbApplyAM = "" ;
		
		
		/* 신규 양식 코드 정보 */
		/* ERP 기준 / ERP 순수 데이터 사용 데이터 변형 x */
		long AB_OPEN_AM = 0;
		long AB_ERP_APPLY_AM = 0;
		long AB_LEFT_AM = 0;
		long AB_ACCEPT_AM = 0;
		/* GW 기준 / ERP + GW 합성 */
		long AB_REFFER_AM = 0;
		long AB_GW_APPLY_AM = 0;
		long AB_GW_LEFT_AM = 0;
		long AB_APPLY_AM = 0;
		long AB_CONS_BALANCE_AM = 0;
		
		for ( int inx = 0, rowNum2 = rowNum - 1; inx < rowNum2; inx++ ) {
			abDocuBInfoMap = abDocuBInfoList.get( inx );
			curAbgtCD = (String) abDocuBInfoMap.get( "ABGT_CD" );
			//dbApplyAM = abDocuBInfoMap.get("APPLY_AM").toString() ;
			temp = abDocuBInfoMap.get( "APPLY_AM" );
			if ( temp == null ) {
				abgtApplyAM = 0;
			}
			else {
				abgtApplyAM = Long.parseLong( temp.toString( ) );
			}
			//abgtApplyAM =  (Long)abDocuBInfoMap.get("APPLY_AM") ;
			if ( !curAbgtCD.equals( prevAbgtCD ) ) {
				abDocuParamMap.put( "BGT_CD", curAbgtCD );
				tempMap2 = acG20ExService.getBudgetInfo3( abDocuParamMap ); 
				leftAM = (Long) tempMap2.get( "LEFT_AM" );
				totalLeftAM = (Long) tempMap2.get( "TOTAL_LEFT_AM" );
				totalLeftReturnAM = leftAM;
				applyAM = (Long) tempMap2.get( "APPLY_AM" );
				openAM = (Long) tempMap2.get( "OPEN_AM" );
				temp = tempMap2.get( "ERP_LEFT_AM" );
				if ( temp != null ) {
					erpLeftAM = (Long) temp;
				}
				else {
					erpLeftAM = 0;
				}
				totalErpLeftAM = erpLeftAM;
				totalErpLeftReturnAM = erpLeftAM;
				temp = tempMap2.get( "ERP_APPLY_AM" );
				if ( temp != null ) {
					erpApplyAM = (Long) temp;
				}
				else {
					erpApplyAM = 0;
				}
				temp = tempMap2.get( "ERP_OPEN_AM" );
				if ( temp != null ) {
					erpOpenAM = (Long) temp;
				}
				else {
					erpOpenAM = 0;
				}
				temp = tempMap2.get( "ERP_ACCEPT_AM" );
				if ( temp != null ) {
					erpAcceptAM = (Long) temp;
				}
				else {
					erpAcceptAM = 0;
				}
				/* 신규 예산 코드 */
				AB_OPEN_AM = (long) tempMap2.get( "AB_OPEN_AM" );
				AB_ERP_APPLY_AM = (long) tempMap2.get( "AB_ERP_APPLY_AM" );
				AB_LEFT_AM = (long) tempMap2.get( "AB_LEFT_AM" );
				AB_ACCEPT_AM = (long) tempMap2.get( "AB_ACCEPT_AM" );
				AB_REFFER_AM = (long) tempMap2.get( "AB_REFFER_AM" );
				AB_GW_APPLY_AM = (long) tempMap2.get( "AB_GW_APPLY_AM" );
				AB_GW_LEFT_AM = (long) tempMap2.get( "AB_GW_LEFT_AM" );
				
				prevAbgtCD = curAbgtCD;
			}
			totalLeftAM -= abgtApplyAM;
			totalLeftReturnAM += abgtApplyAM;
			abDocuBInfoMap.put( "LEFT_AM", leftAM );
			abDocuBInfoMap.put( "TOTAL_LEFT_AM", totalLeftAM );
			abDocuBInfoMap.put( "TOTAL_LEFT_RETURN_AM", totalLeftReturnAM );
			abDocuBInfoMap.put( "BASED_APPLY_AM", applyAM );
			abDocuBInfoMap.put( "OPEN_AM", openAM );
			totalErpLeftAM -= abgtApplyAM;
			totalErpLeftReturnAM += abgtApplyAM;
			abDocuBInfoMap.put( "ERP_LEFT_AM", erpLeftAM );
			abDocuBInfoMap.put( "TOTAL_ERP_LEFT_AM", totalErpLeftAM );
			abDocuBInfoMap.put( "TOTAL_ERP_LEFT_RETURN_AM", totalErpLeftReturnAM );
			abDocuBInfoMap.put( "ERP_APPLY_AM", erpApplyAM );
			abDocuBInfoMap.put( "ERP_OPEN_AM", erpOpenAM );
			abDocuBInfoMap.put( "ERP_ACCEPT_AM", erpAcceptAM );
			abDocuBInfoMap.put( "REFER_AM", tempMap2.get( "REFER_AM" ) ); // 품의잔액
			HashMap<String, String> result = (HashMap<String, String>) tempMap2.get( "result" );
			abDocuBInfoMap.put( "LEVEL01_CD", result.get( "LEVEL01_CD" ) );
			abDocuBInfoMap.put( "LEVEL02_CD", result.get( "LEVEL02_CD" ) );
			abDocuBInfoMap.put( "LEVEL03_CD", result.get( "LEVEL03_CD" ) );
			abDocuBInfoMap.put( "LEVEL04_CD", result.get( "LEVEL04_CD" ) );
			abDocuBInfoMap.put( "LEVEL05_CD", result.get( "LEVEL05_CD" ) );
			abDocuBInfoMap.put( "LEVEL06_CD", result.get( "LEVEL06_CD" ) );
			abDocuBInfoMap.put( "LEVEL01_NM", result.get( "LEVEL01_NM" ) );
			abDocuBInfoMap.put( "LEVEL02_NM", result.get( "LEVEL02_NM" ) );
			abDocuBInfoMap.put( "LEVEL03_NM", result.get( "LEVEL03_NM" ) );
			abDocuBInfoMap.put( "LEVEL04_NM", result.get( "LEVEL04_NM" ) );
			abDocuBInfoMap.put( "LEVEL05_NM", result.get( "LEVEL05_NM" ) );
			abDocuBInfoMap.put( "LEVEL06_NM", result.get( "LEVEL06_NM" ) );
			// 금액 출처 정리및 수정 필요.
			abDocuBInfoMap.put( "AB_OPEN_AM", AB_OPEN_AM );
			abDocuBInfoMap.put( "AB_ERP_APPLY_AM", AB_ERP_APPLY_AM );
			abDocuBInfoMap.put( "AB_LEFT_AM", AB_LEFT_AM );
			abDocuBInfoMap.put( "AB_ACCEPT_AM", AB_ACCEPT_AM );
			abDocuBInfoMap.put( "AB_REFFER_AM", AB_REFFER_AM );
			abDocuBInfoMap.put( "AB_GW_APPLY_AM", AB_GW_APPLY_AM );
			abDocuBInfoMap.put( "AB_GW_LEFT_AM", AB_GW_LEFT_AM );
			AB_APPLY_AM = Long.parseLong( abDocuBInfoMap.get( "AB_APPLY_AM" ).toString( ) );
			if(abDocuBInfoMap.get( "AB_CONS_BALANCE_AM" ) == null){
				AB_CONS_BALANCE_AM = 0;
			}else{
				AB_CONS_BALANCE_AM = Long.parseLong( abDocuBInfoMap.get( "AB_CONS_BALANCE_AM" ).toString( ) );
			}
			abDocuBInfoMap.put("AB_TOTAL_RESULT_AM", AB_GW_LEFT_AM - AB_APPLY_AM);
			abDocuBInfoMap.put("AB_TOTAL_CONS_BALANCE_AM", AB_CONS_BALANCE_AM - AB_APPLY_AM);
			abDocuBInfoMap.put("AB_CONS_AM", AB_CONS_BALANCE_AM + Long.parseLong( abDocuBInfoMap.get( "AB_CONS_USE_AM" ).toString( ) ));
		}
		JSONArray detailBList = JSONArray.fromObject( abDocuBInfoList );
		abDocuParamMap.put( "abDocuNo", abDocuNo );
		List<Map<String, Object>> abDocuInfoList = acG20ExAppGwDAO.getAppAbDocuT_List( param );
		String totalUnitAM = "";
		String totalSupAM = "";
		String totalVatAM = "";
		String amtHan = "";
		if ( abDocuInfoList != null )
			rowNum = abDocuInfoList.size( );
		if ( rowNum == 0 ) {
			throw new Exception( BizboxAMessage.getMessage( "TX000009347", "회계정보가 없습니다" ) );
		}
		JSONArray detailList = JSONArray.fromObject( abDocuInfoList );
		abDocuInfoMap = abDocuInfoList.get( 0 );
		resultMap.put( "tranInfoMap", abDocuInfoMap );
		abDocuInfoMap = abDocuInfoList.get( rowNum - 1 );
		temp = abDocuInfoMap.get( "UNIT_AM" );
		if ( temp != null ) {
			totalUnitAM = temp.toString( );
		}
		amtHan = EgovStringUtil.moneyToHan( totalUnitAM );
		temp = abDocuInfoMap.get( "SUP_AM" ); //총공금액
		if ( temp != null ) {
			totalSupAM = temp.toString( );
		}
		temp = abDocuInfoMap.get( "VAT_AM" ); // 총 부가세금액
		if ( temp != null ) {
			totalVatAM = temp.toString( );
		}
		String mgtNm = (String) abDocuMap.get( "MGT_NM" );
		mgtNm = URLDecoder.decode( mgtNm, "UTF-8" );
		abDocuMap.put( "MGT_NM", mgtNm );
		abDocuParamMap.put( "ABGT_NM", (String) abDocuInfoMap.get( "DETAIL_ABGT_NM" ) );
		abDocuInfoMap = abDocuInfoList.get( 1 );
		abDocuParamMap.put( "BGT_CD", (String) abDocuInfoMap.get( "DETAIL_ABGT_CD" ) );
		Map<String, Object> budgetInfoMap = new HashMap<String, Object>( );
		tempMap2 = acG20ExService.getBudgetInfo3( abDocuParamMap );
		HashMap<String, String> result = (HashMap<String, String>) tempMap2.get( "result" );
		budgetInfoMap.put( "A_REFER_AM", tempMap2.get( "REFER_AM" ) );
		budgetInfoMap.put( "BGT01_NM", result.get( "BGT01_NM" ) );
		budgetInfoMap.put( "BGT02_NM", result.get( "BGT02_NM" ) );
		budgetInfoMap.put( "BGT03_NM", result.get( "BGT03_NM" ) );
		budgetInfoMap.put( "BGT04_NM", result.get( "BGT04_NM" ) );
		budgetInfoMap.put( "BGT01_CD", result.get( "BGT01_CD" ) );
		budgetInfoMap.put( "BGT02_CD", result.get( "BGT02_CD" ) );
		budgetInfoMap.put( "BGT03_CD", result.get( "BGT03_CD" ) );
		budgetInfoMap.put( "BGT04_CD", result.get( "BGT04_CD" ) );
		budgetInfoMap.put( "LEVEL01_CD", result.get( "LEVEL01_CD" ) );
		budgetInfoMap.put( "LEVEL02_CD", result.get( "LEVEL02_CD" ) );
		budgetInfoMap.put( "LEVEL03_CD", result.get( "LEVEL03_CD" ) );
		budgetInfoMap.put( "LEVEL04_CD", result.get( "LEVEL04_CD" ) );
		budgetInfoMap.put( "LEVEL05_CD", result.get( "LEVEL05_CD" ) );
		budgetInfoMap.put( "LEVEL06_CD", result.get( "LEVEL06_CD" ) );
		budgetInfoMap.put( "LEVEL01_NM", result.get( "LEVEL01_NM" ) );
		budgetInfoMap.put( "LEVEL02_NM", result.get( "LEVEL02_NM" ) );
		budgetInfoMap.put( "LEVEL03_NM", result.get( "LEVEL03_NM" ) );
		budgetInfoMap.put( "LEVEL04_NM", result.get( "LEVEL04_NM" ) );
		budgetInfoMap.put( "LEVEL05_NM", result.get( "LEVEL05_NM" ) );
		budgetInfoMap.put( "LEVEL06_NM", result.get( "LEVEL06_NM" ) );
		budgetInfoMap.put( "APPLY_AM", tempMap2.get( "APPLY_AM" ) );
		budgetInfoMap.put( "OPEN_AM", tempMap2.get( "OPEN_AM" ) );
		budgetInfoMap.put( "LEFT_AM", tempMap2.get( "LEFT_AM" ) );
		budgetInfoMap.put( "SUNGIN_DELAY_AM", tempMap2.get( "SUNGIN_DELAY_AM" ) );
		temp = tempMap2.get( "ERP_APPLY_AM" );
		if ( temp != null ) {
			erpApplyAM = (Long) temp;
		}
		else {
			erpApplyAM = 0;
		}
		temp = tempMap2.get( "ERP_OPEN_AM" );
		if ( temp != null ) {
			erpOpenAM = (Long) temp;
		}
		else {
			erpOpenAM = 0;
		}
		temp = tempMap2.get( "ERP_LEFT_AM" );
		if ( temp != null ) {
			erpLeftAM = (Long) temp;
		}
		else {
			erpLeftAM = 0;
		}
		temp = tempMap2.get( "ERP_ACCEPT_AM" );
		if ( temp != null ) {
			erpAcceptAM = (Long) temp;
		}
		else {
			erpAcceptAM = 0;
		}
		budgetInfoMap.put( "ERP_APPLY_AM", erpApplyAM );
		budgetInfoMap.put( "ERP_OPEN_AM", erpOpenAM );
		budgetInfoMap.put( "ERP_LEFT_AM", erpLeftAM );
		budgetInfoMap.put( "ERP_ACCEPT_AM", erpAcceptAM );
		resultMap.put( "amtHan", amtHan );
		resultMap.put( "abDocuInfoList", abDocuInfoList );
		resultMap.put( "abDocuMap", abDocuMap );
		resultMap.put( "abDocuBInfoMap", abDocuBInfoMap );
		resultMap.put( "totalUnitAM", totalUnitAM );
		resultMap.put( "totalSupAM", totalSupAM );
		resultMap.put( "totalVatAM", totalVatAM );
		resultMap.put( "budgetInfoMap", budgetInfoMap );
		resultMap.put( "detailList", detailList );
		resultMap.put( "detailBList", detailBList );
		resultMap.put( "mode", mode );
		resultMap.put( "referDocInfo", referDocInfo );
		resultMap.put( "proposalYear", proposalYear );
		resultMap.put( "proposalMonth", proposalMonth );
		resultMap.put( "proposalDay", proposalDay );
		resultMap.put( "proposalDate", proposalDate );
		return resultMap;
	}

	@Override
	public Map<String, Object> docG20MultiApproval ( Map<String, Object> paramMap ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> abDocuInfoMap = null;
		Map<String, Object> tempMap2 = null;
		String abDocuNo = (String) paramMap.get( "docxNumb" );
		Map<String, Object> param = new HashMap<String, Object>( );
		param.put( "abdocu_no", abDocuNo );
		Map<String, Object> abDocuMap = acG20ExAppGwDAO.getAppAbDocuH( param );
		String mgtNm = (String) abDocuMap.get( "MGT_NM" );
		mgtNm = URLDecoder.decode( mgtNm, "UTF-8" );
		abDocuMap.put( "MGT_NM", mgtNm );
		Object temp = null;
		temp = abDocuMap.get( "ABDOCU_NO_REFFER" );
		String abdocuNoReffer = "";
		String curDate = DateUtil.getCurrentDate( "yyyy-MM-dd" );
		String proposalDate = "";
		String proposalYear = "";
		String proposalMonth = "";
		String proposalDay = "";
		if ( temp != null ) {
			abdocuNoReffer = temp.toString( );
		}
		Map<String, Object> referDocInfo = null;
		if ( !EgovStringUtil.isEmpty( abdocuNoReffer ) && paramMap.get( "refDocInfoList" ) == null ) {
			param.put( "abdocu_no_reffer", abdocuNoReffer );
			param.put( "langCode", loginVO.getLangCode( ) );
			List<Map<String, Object>> list = acG20ExAppGwDAO.getAppReferDocInfo( param );
			resultMap.put( "refDocInfoList", list ); //  g20 참조문서
			referDocInfo = list.get( 0 );
			proposalDate = (String) referDocInfo.get( "REFRIREGYMD" );
			if ( !EgovStringUtil.isEmpty( proposalDate ) ) {
				proposalYear = proposalDate.substring( 0, 4 );
				proposalMonth = proposalDate.substring( 5, 7 );
				proposalDay = proposalDate.substring( 8, 10 );
			}
		}
		if ( EgovStringUtil.isEmpty( proposalDate ) ) {
			proposalDate = curDate;
			proposalYear = proposalDate.substring( 0, 4 );
			proposalMonth = proposalDate.substring( 5, 7 );
			proposalDay = proposalDate.substring( 8, 10 );
		}
		HashMap<String, String> abDocuParamMap = new HashMap<String, String>( );
		abDocuParamMap.put( "CO_CD", (String) abDocuMap.get( "ERP_CO_CD" ) );
		abDocuParamMap.put( "DIV_CD", (String) abDocuMap.get( "ERP_DIV_CD" ) );
		abDocuParamMap.put( "MGT_CD", (String) abDocuMap.get( "MGT_CD" ) );
		abDocuParamMap.put( "GISU_DT", (String) abDocuMap.get( "ERP_GISU_DT" ) );
		abDocuParamMap.put( "SUM_CT_AM", "0" );
		abDocuParamMap.put( "BOTTOM_CD", (String) abDocuMap.get( "BOTTOM_CD" ) );
		abDocuParamMap.put( "LANGKIND", "KR" );
		abDocuParamMap.put( "DOCU_MODE", abDocuMap.get( "DOCU_MODE" ).toString( ) );
		abDocuParamMap.put( "abDocuNo", abDocuNo );
		String mode = "0";
		String docxGubn = (String) paramMap.get( "ciKind" );
		if ( docxGubn.equals( "010" ) ) {
			mode = "0";
		}
		else {
			mode = "1";
		}
		int rowNum = 0;
		List<Map<String, Object>> abDocuBInfoList = acG20ExAppGwDAO.getAppAbDocuB_List( param );
		Map<String, Object> abDocuBInfoMap = null;
		if ( abDocuBInfoList != null ) {
			rowNum = abDocuBInfoList.size( );
		}
		if ( rowNum == 0 ) {
			throw new Exception( BizboxAMessage.getMessage( "TX000009347", "회계정보가 없습니다" ) );
		}
		String curAbgtCD = "";
		String prevAbgtCD = "";
		long abgtApplyAM = 0;
		long openAM = 0;
		long applyAM = 0;
		long leftAM = 0;
		long suginDelayAM = 0;
		long erpApplyAM = 0;
		long erpOpenAM = 0;
		long erpLeftAM = 0;
		long erpAcceptAM = 0;
		String abDocuBNo = ""; //ABDOCU_B_NO
		String totalUnitAM = "";
		String totalSupAM = "";
		String totalVatAM = "";
		String amtHan = "";
		Map<String, String> tempMap = null;
		List<Map<String, Object>> abDocuInfoList = null;
		int subRowNum = 0;
		temp = null;
		for ( int inx = 0, realRowNum = rowNum - 1; inx < realRowNum; inx++ ) {
			abDocuBInfoMap = abDocuBInfoList.get( inx );
			curAbgtCD = (String) abDocuBInfoMap.get( "ABGT_CD" );
			abgtApplyAM = Long.parseLong( abDocuBInfoMap.get( "APPLY_AM" ).toString( ) );
			abDocuBNo = abDocuBInfoMap.get( "ABDOCU_B_NO" ).toString( );
			abDocuParamMap.put( "BGT_CD", curAbgtCD );
			tempMap2 = acG20ExService.getBudgetInfo3( abDocuParamMap );
			leftAM = (Long) tempMap2.get( "LEFT_AM" );
			applyAM = (Long) tempMap2.get( "APPLY_AM" );
			openAM = (Long) tempMap2.get( "OPEN_AM" );
			suginDelayAM = (Long) tempMap2.get( "SUNGIN_DELAY_AM" );
			//			leftAM -= abgtApplyAM ;
			abDocuBInfoMap.put( "LEFT_AM", leftAM ); // 과목예산 잔액
			abDocuBInfoMap.put( "BASED_APPLY_AM", applyAM ); //기집행액
			abDocuBInfoMap.put( "OPEN_AM", openAM );
			abDocuBInfoMap.put( "SUNGIN_DELAY_AM", suginDelayAM );
			temp = tempMap2.get( "ERP_APPLY_AM" );
			if ( temp != null ) {
				erpApplyAM = (Long) temp;
			}
			else {
				erpApplyAM = 0;
			}
			temp = tempMap2.get( "ERP_OPEN_AM" );
			if ( temp != null ) {
				erpOpenAM = (Long) temp;
			}
			else {
				erpOpenAM = 0;
			}
			temp = tempMap2.get( "ERP_LEFT_AM" );
			if ( temp != null ) {
				erpLeftAM = (Long) temp;
			}
			else {
				erpLeftAM = 0;
			}
			temp = tempMap2.get( "ERP_ACCEPT_AM" );
			if ( temp != null ) {
				erpAcceptAM = (Long) temp;
			}
			else {
				erpAcceptAM = 0;
			}
			abDocuBInfoMap.put( "ERP_APPLY_AM", erpApplyAM );
			abDocuBInfoMap.put( "ERP_OPEN_AM", erpOpenAM );
			abDocuBInfoMap.put( "ERP_LEFT_AM", erpLeftAM );
			abDocuBInfoMap.put( "ERP_ACCEPT_AM", erpAcceptAM );
			abDocuParamMap.put( "abDocuBNo", abDocuBNo );
			param.put( "abdocu_b_no", abDocuBNo );
			abDocuInfoList = acG20ExAppGwDAO.getAppAbDocuT_List( param );
			abDocuBInfoMap.put( "abDocuInfoList", abDocuInfoList );
			if ( abDocuInfoList != null ) {
				subRowNum = abDocuInfoList.size( );
			}
			totalUnitAM = "0";
			totalSupAM = "0";
			totalVatAM = "0";
			amtHan = "";
			if ( subRowNum > 0 ) {
				abDocuInfoMap = abDocuInfoList.get( subRowNum - 1 );
				temp = abDocuInfoMap.get( "UNIT_AM" );
				if ( temp != null ) {
					totalUnitAM = temp.toString( );
				}
				amtHan = EgovStringUtil.moneyToHan( totalUnitAM );
				temp = abDocuInfoMap.get( "SUP_AM" ); //총공금액
				if ( temp != null ) {
					totalSupAM = temp.toString( );
				}
				temp = abDocuInfoMap.get( "VAT_AM" ); // 총 부가세금액
				if ( temp != null ) {
					totalVatAM = temp.toString( );
				}
			}
			abDocuBInfoMap.put( "totalUnitAM", totalUnitAM );
			abDocuBInfoMap.put( "totalSupAM", totalSupAM );
			abDocuBInfoMap.put( "totalVatAM", totalVatAM );
			abDocuBInfoMap.put( "amtHan", amtHan );
			abDocuParamMap.put( "ABGT_NM", (String) abDocuBInfoMap.get( "ABGT_NM" ) );
			abDocuParamMap.put( "BGT_CD", (String) abDocuBInfoMap.get( "ABGT_CD" ) );
			tempMap = acG20ExService.getBudgetInfo2( abDocuParamMap );
			abDocuBInfoMap.put( "BGT01_NM", tempMap.get( "BGT01_NM" ) );
			abDocuBInfoMap.put( "BGT02_NM", tempMap.get( "BGT02_NM" ) );
			abDocuBInfoMap.put( "BGT03_NM", tempMap.get( "BGT03_NM" ) );
			abDocuBInfoMap.put( "BGT04_NM", tempMap.get( "BGT04_NM" ) );
			abDocuBInfoMap.put( "BGT01_CD", tempMap.get( "BGT01_CD" ) );
			abDocuBInfoMap.put( "BGT02_CD", tempMap.get( "BGT02_CD" ) );
			abDocuBInfoMap.put( "BGT03_CD", tempMap.get( "BGT03_CD" ) );
			abDocuBInfoMap.put( "BGT04_CD", tempMap.get( "BGT04_CD" ) );
		}
		JSONArray detailBList = JSONArray.fromObject( abDocuBInfoList );
		resultMap.put( "amtHan", amtHan );
		resultMap.put( "abDocuMap", abDocuMap );
		resultMap.put( "detailBList", detailBList );
		resultMap.put( "mode", mode );
		resultMap.put( "proposalYear", proposalYear );
		resultMap.put( "proposalMonth", proposalMonth );
		resultMap.put( "proposalDay", proposalDay );
		resultMap.put( "proposalDate", proposalDate );
		return resultMap;
	}

	@SuppressWarnings ( "rawtypes" )
	@Override
	public Map<String, Object> docG20ItemDetail ( String abdocu_no ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		List<Map> itemDetailList = acG20ExAppGwDAO.getAppAbDocuD_List( abdocu_no );
		List<Map> businessDetailList = acG20ExAppGwDAO.getAppAbDocuTD2_List( abdocu_no );
		itemDetailList = CommonUtil.HtmlEncode( itemDetailList );
		businessDetailList = CommonUtil.HtmlEncode( businessDetailList );
		JSONArray jsonItemDetailList = JSONArray.fromObject( itemDetailList );
		JSONArray jsonBusinessDetailList = JSONArray.fromObject( businessDetailList );
		resultMap.put( "itemDetailList", jsonItemDetailList );
		resultMap.put( "businessDetailList", jsonBusinessDetailList );
		return resultMap;
	}

	/**
	 * 품의서 결재 완료
	 * doban7 2016. 9. 28.
	 * completeApproval
	 *
	 */
	@Override
	public Map<String, Object> completeApproval ( Abdocu_H abdocu_Tmp ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		//        LOG.error(" _NEOSG20DAO.completeApproval(abdocu_Tmp) - history :" + abdocu_Tmp.toString());
		int result = acG20ExAppGwDAO.completeApproval( abdocu_Tmp );
		map.put( "result", result );
		return map;
	}

	/**
	 * 결의서 전송
	 * doban7 2016. 9. 28.
	 * insertG20Data
	 *
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public Map<String, Object> insertG20Data ( Abdocu_H abdocu_Tmp ) throws SQLException, Exception {
		Map<String, Object> param = new HashMap<String, Object>( );
		
		Map<String, String> DrafterInfo = (Map<String, String>) commonSql.selectByPk( "AcG20ExAppGw.getDrafterInfo", abdocu_Tmp.getC_dikeycode( ) );
		LoginVO loginVo = new LoginVO( );
		if(DrafterInfo != null){
			loginVo.setCompSeq( EgovStringUtil.isNullToString(DrafterInfo.get( "COMP_SEQ" )) );
			loginVo.setOrgnztId( EgovStringUtil.isNullToString(DrafterInfo.get( "DEPT_SEQ" )) );
			loginVo.setUniqId( EgovStringUtil.isNullToString(DrafterInfo.get( "EMP_SEQ" )) );	
		}		
		param.put( "loginVO", loginVo );
		conVo = GetConnection( param );
		Abdocu_H insertAbdocu_Tmp = null;
		Map<String, String> result_H = null;
		Map<String, String> result_B = null;
		Map<String, String> result_T = null;
		Map<String, String> result_D = null;
		Map<String, String> result_TH = null;
		Map<String, String> result_TD = null;
		Map<String, String> result_TD2 = null;
		//
		String erp_gisu_dt = null;
		String erp_gisu_sq = null;
		String erp_bq_sq = "";
		String erp_bk_sq = "";
		List<Abdocu_B> insertAbdocu_B_Tmp = null;
		List<Abdocu_T> insertAbdocu_T_Tmp = null;
		List<Abdocu_D> insertAbdocu_D_Tmp = null;
		Abdocu_TH insertAbdocu_TH_Tmp = null;
		List<Abdocu_TD> insertAbdocu_TD_Tmp = null;
		List<Abdocu_TD2> insertAbdocu_TD2_Tmp = null;
		int FailedRetryCount = 5;
		String state_use = CommonCodeUtil.getCodeName( "G20301", "001" );
		/*
		 * 예산정보에 따른 거래처 정보 모두 저장
		 */
		List<List<Abdocu_T>> insertAbdocu_T_Tmp_List = new ArrayList<List<Abdocu_T>>( );
		StringBuilder abdocuBTmpSql = new StringBuilder( );
		StringBuilder abdocuTTmpSql = new StringBuilder( );
		StringBuilder abdocuTDTmpSql = new StringBuilder( );
		StringBuilder abdocuTD2TmpSql = new StringBuilder( );
		StringBuilder abdocuDTmpSql = new StringBuilder( );
		boolean abdocuTTmpSqlUnionAll = false;
		/* ERP 에 데이터 입력 시작 */
		try {
			abdocu_Tmp.setErp_gisu_dt( erp_gisu_dt );
			abdocu_Tmp.setErp_gisu_sq( erp_gisu_sq );
			insertAbdocu_Tmp = acG20ExGwDAO.getAbdocuH( abdocu_Tmp );
			insertAbdocu_B_Tmp = acG20ExGwDAO.getAbdocuB_List( insertAbdocu_Tmp );
			result_H = acG20ExAppErpDAO.insertG20Data_H( insertAbdocu_Tmp, conVo );
			if ( !getStringValue( result_H, "ret_val" ).equals( "0" ) ) {
				throw new Exception( getStringValue( result_H, "RETURN_MESSAGE" ) );
			}
			erp_gisu_dt = getStringValue( result_H, "ERP_GISU_DT" );
			erp_gisu_sq = getStringValue( result_H, "ERP_GISU_SQ" );
			abdocu_Tmp.setErp_gisu_sq( erp_gisu_sq );
			for ( int i = 0, max = insertAbdocu_B_Tmp.size( ), iLimit = max - 1; i < max; i++ ) {
				Abdocu_B abdocu_B_Tmp = insertAbdocu_B_Tmp.get( i );
				abdocu_B_Tmp.setErp_gisu_dt( erp_gisu_dt );
				abdocu_B_Tmp.setErp_gisu_sq( erp_gisu_sq );
				result_B = acG20ExAppErpDAO.insertG20Data_B( abdocu_B_Tmp, conVo );
				erp_gisu_dt = getStringValue( result_B, "ERP_GISU_DT" );
				erp_gisu_sq = getStringValue( result_B, "ERP_GISU_SQ" );
				erp_bq_sq = getStringValue( result_B, "ERP_BQ_SQ" );
				if ( result_B.containsKey( "ERP_BK_SQ" ) ) {
					erp_bk_sq = getStringValue( result_B, "ERP_BK_SQ" );
				}
				else {
					erp_bk_sq = "0";
				}
				abdocu_B_Tmp.setErp_gisu_dt( erp_gisu_dt );
				abdocu_B_Tmp.setErp_gisu_sq( erp_gisu_sq );
				abdocu_B_Tmp.setErp_bq_sq( erp_bq_sq );
				abdocu_B_Tmp.setErp_bk_sq( erp_bk_sq );
				if ( i > 0 ) {
					abdocuBTmpSql.append( "\n UNION ALL " );
				}
				abdocuBTmpSql.append( "\n SELECT '" + erp_gisu_dt + "' ERP_GISU_DT , " );
				abdocuBTmpSql.append( "\n        '" + erp_gisu_sq + "' ERP_GISU_SQ,  " );
				abdocuBTmpSql.append( "\n        '" + erp_bq_sq + "'  ERP_BQ_SQ ,  " );
				abdocuBTmpSql.append( "\n        '" + erp_bk_sq + "'  ERP_BK_SQ,  " );
				abdocuBTmpSql.append( "\n        '" + abdocu_B_Tmp.getAbdocu_b_no( ) + "' ABDOCU_B_NO " );
				abdocuBTmpSql.append( "\n        FROM DUAL " );
				insertAbdocu_T_Tmp = acG20ExGwDAO.getAbdocuT_List( abdocu_B_Tmp );
				for ( int j = 0, jMax = insertAbdocu_T_Tmp.size( ), jLimit = jMax - 1; j < jMax; j++ ) {
					Abdocu_T abdocu_T_Tmp = insertAbdocu_T_Tmp.get( j );
					abdocu_T_Tmp.setErp_isu_dt( erp_gisu_dt );
					abdocu_T_Tmp.setErp_isu_sq( erp_gisu_sq );
					abdocu_T_Tmp.setErp_bq_sq( erp_bq_sq );
					abdocu_T_Tmp.setBk_sq( erp_bk_sq );
					result_T = acG20ExAppErpDAO.insertG20Data_T( abdocu_T_Tmp, conVo );
					if ( !getStringValue( result_T, "ret_val" ).equals( "0" ) ) {
						throw new Exception( getStringValue( result_T, "RETURN_MESSAGE" ) );
					}
					abdocu_T_Tmp.setErp_isu_dt( getStringValue( result_T, "ERP_GISU_DT" ) );
					abdocu_T_Tmp.setErp_isu_sq( getStringValue( result_T, "ERP_GISU_SQ" ) );
					abdocu_T_Tmp.setErp_bq_sq( getStringValue( result_T, "ERP_BQ_SQ" ) );
					abdocu_T_Tmp.setErp_ln_sq( getStringValue( result_T, "ERP_LN_SQ" ) );
					abdocu_T_Tmp.setBk_sq2( getStringValue( result_T, "ERP_BK_SQ2" ) );
					abdocu_T_Tmp.setErp_emp_cd( insertAbdocu_Tmp.getErp_emp_cd( ) );
					insertAbdocu_T_Tmp_List.add( insertAbdocu_T_Tmp );
					//System.out.println(insertAbdocu_T_Tmp_List.size());
					if ( i == 0 && j > 0 ) {
						abdocuTTmpSql.append( "\n UNION ALL " );
						abdocuTTmpSqlUnionAll = true;
					}
					else if ( j >= 0 ) {
						if ( abdocuTTmpSqlUnionAll ) {
							abdocuTTmpSql.append( "\n UNION ALL " );
						}
						else {
							abdocuTTmpSqlUnionAll = true;
						}
					}
					abdocuTTmpSql.append( "\n SELECT '" + abdocu_T_Tmp.getErp_isu_dt( ) + "' ERP_ISU_DT, " );
					abdocuTTmpSql.append( "\n        '" + abdocu_T_Tmp.getErp_isu_sq( ) + "' ERP_ISU_SQ, " );
					abdocuTTmpSql.append( "\n        '" + abdocu_T_Tmp.getErp_bq_sq( ) + "'  ERP_BQ_SQ, " );
					abdocuTTmpSql.append( "\n        '" + abdocu_T_Tmp.getErp_ln_sq( ) + "'  ERP_LN_SQ, " );
					abdocuTTmpSql.append( "\n        '" + abdocu_T_Tmp.getBk_sq2( ) + "'  BK_SQ2, " );
					abdocuTTmpSql.append( "\n        '" + abdocu_T_Tmp.getAbdocu_t_no( ) + "' ABDOCU_T_NO " );
					abdocuTTmpSql.append( "\n  FROM DUAL " );
				}
			}
			if ( state_use.equals( "Y" ) ) {
				if ( insertAbdocu_Tmp.getDocu_fg( ).equals( "8" ) ) { //여비명세서 G20 insert
					insertAbdocu_TH_Tmp = acG20ExGwDAO.getAbdocuTH( insertAbdocu_Tmp );
					if ( insertAbdocu_TH_Tmp != null ) {
						insertAbdocu_TH_Tmp.setErp_isu_dt( erp_gisu_dt );
						insertAbdocu_TH_Tmp.setErp_isu_sq( erp_gisu_sq );
						insertAbdocu_TH_Tmp.setErp_emp_cd( insertAbdocu_Tmp.getErp_emp_cd( ) );
						result_TH = acG20ExAppErpDAO.insertG20Data_TH( insertAbdocu_TH_Tmp, conVo );
						insertAbdocu_TH_Tmp.setErp_isu_dt( getStringValue( result_TH, "ERP_ISU_DT" ) );
						insertAbdocu_TH_Tmp.setErp_isu_sq( getStringValue( result_TH, "ERP_ISU_SQ" ) );
					}
					insertAbdocu_TD_Tmp = acG20ExGwDAO.getAbdocuTD_List( insertAbdocu_Tmp );
					if ( insertAbdocu_TD_Tmp != null && insertAbdocu_TD_Tmp.size( ) > 0 ) {
						for ( int i = 0, max = insertAbdocu_TD_Tmp.size( ); i < max; i++ ) {
							Abdocu_TD abdocu_TD_Tmp = insertAbdocu_TD_Tmp.get( i );
							abdocu_TD_Tmp.setErp_isu_dt( erp_gisu_dt );
							abdocu_TD_Tmp.setErp_isu_sq( erp_gisu_sq );
							result_TD = acG20ExAppErpDAO.insertG20Data_TD( abdocu_TD_Tmp, conVo );
							abdocu_TD_Tmp.setErp_isu_dt( getStringValue( result_TD, "ERP_ISU_DT" ) );
							abdocu_TD_Tmp.setErp_isu_sq( getStringValue( result_TD, "ERP_ISU_SQ" ) );
							abdocu_TD_Tmp.setErp_ln_sq( getStringValue( result_TD, "ERP_LN_SQ" ) );
							if ( i > 0 ) {
								abdocuTDTmpSql.append( "\n UNION ALL " );
							}
							abdocuTDTmpSql.append( "\n SELECT '" + getStringValue( result_TD, "ERP_ISU_DT" ) + "' ERP_ISU_DT , " );
							abdocuTDTmpSql.append( "\n        '" + getStringValue( result_TD, "ERP_ISU_SQ" ) + "' ERP_ISU_SQ,  " );
							abdocuTDTmpSql.append( "\n        '" + getStringValue( result_TD, "ERP_LN_SQ" ) + "'  ERP_LN_SQ ,  " );
							abdocuTDTmpSql.append( "\n        '" + abdocu_TD_Tmp.getAbdocu_td_no( ) + "' ABDOCU_TD_NO " );
							abdocuTDTmpSql.append( "\n        FROM DUAL " );
						}
					}
					insertAbdocu_TD2_Tmp = acG20ExGwDAO.getAbdocuTD2_List( insertAbdocu_Tmp );
					if ( insertAbdocu_TD2_Tmp != null && insertAbdocu_TD2_Tmp.size( ) > 0 ) {
						for ( int i = 0, max = insertAbdocu_TD2_Tmp.size( ); i < max; i++ ) {
							Abdocu_TD2 abdocu_TD2_Tmp = insertAbdocu_TD2_Tmp.get( i );
							abdocu_TD2_Tmp.setErp_isu_dt( erp_gisu_dt );
							abdocu_TD2_Tmp.setErp_isu_sq( erp_gisu_sq );
							result_TD2 = acG20ExAppErpDAO.insertG20Data_TD2( abdocu_TD2_Tmp, conVo );
							abdocu_TD2_Tmp.setErp_isu_dt( getStringValue( result_TD2, "ERP_ISU_DT" ) );
							abdocu_TD2_Tmp.setErp_isu_sq( getStringValue( result_TD2, "ERP_ISU_SQ" ) );
							abdocu_TD2_Tmp.setErp_ln_sq( getStringValue( result_TD2, "ERP_LN_SQ" ) );
							if ( i > 0 ) {
								abdocuTD2TmpSql.append( "\n UNION ALL " );
							}
							abdocuTD2TmpSql.append( "\n SELECT '" + getStringValue( result_TD2, "ERP_ISU_DT" ) + "' ERP_ISU_DT , " );
							abdocuTD2TmpSql.append( "\n        '" + getStringValue( result_TD2, "ERP_ISU_SQ" ) + "' ERP_ISU_SQ,  " );
							abdocuTD2TmpSql.append( "\n        '" + getStringValue( result_TD2, "ERP_LN_SQ" ) + "'  ERP_LN_SQ ,  " );
							abdocuTD2TmpSql.append( "\n        '" + abdocu_TD2_Tmp.getAbdocu_td2_no( ) + "' ABDOCU_TD2_NO " );
							abdocuTD2TmpSql.append( "\n        FROM DUAL " );
						}
					}
				}
				else { //일반명세서 G20 insert 
					insertAbdocu_D_Tmp = acG20ExGwDAO.getAbdocuD_List( insertAbdocu_Tmp );
					if ( insertAbdocu_D_Tmp != null && insertAbdocu_D_Tmp.size( ) > 0 ) {
						for ( int i = 0, max = insertAbdocu_D_Tmp.size( ); i < max; i++ ) {
							Abdocu_D abdocu_D_Tmp = insertAbdocu_D_Tmp.get( i );
							abdocu_D_Tmp.setErp_isu_dt( erp_gisu_dt );
							abdocu_D_Tmp.setErp_isu_sq( erp_gisu_sq );
							abdocu_D_Tmp.setErp_emp_cd( insertAbdocu_Tmp.getErp_emp_cd( ) );
							result_D = acG20ExAppErpDAO.insertG20Data_D( abdocu_D_Tmp, conVo );
							abdocu_D_Tmp.setErp_isu_dt( getStringValue( result_D, "ERP_ISU_DT" ) );
							abdocu_D_Tmp.setErp_isu_sq( getStringValue( result_D, "ERP_ISU_SQ" ) );
							abdocu_D_Tmp.setErp_ln_sq( getStringValue( result_D, "ERP_LN_SQ" ) );
							if ( i > 0 ) {
								abdocuDTmpSql.append( "\n UNION ALL " );
							}
							abdocuDTmpSql.append( "\n SELECT '" + getStringValue( result_D, "ERP_ISU_DT" ) + "' ERP_ISU_DT , " );
							abdocuDTmpSql.append( "\n        '" + getStringValue( result_D, "ERP_ISU_SQ" ) + "' ERP_ISU_SQ,  " );
							abdocuDTmpSql.append( "\n        '" + getStringValue( result_D, "ERP_LN_SQ" ) + "'  ERP_LN_SQ ,  " );
							abdocuDTmpSql.append( "\n        '" + abdocu_D_Tmp.getAbdocu_d_no( ) + "' ABDOCU_D_NO " );
							abdocuDTmpSql.append( "\n        FROM DUAL " );
						}
					}
				}
			}
		}
		catch ( Exception ex ) {
			ex.printStackTrace( );
			/*
			 * ERP에 데이터 입력할때 실패할 경우 DATA 삭제 계속 실패할 경우 1초간격으로 5번 시도하며 5번 시도할경우
			 * throw 발생
			 */
			for ( int i = 0, max = FailedRetryCount; i < max; i++ ) {
				Map<String, String> paramMap = new HashMap<String, String>( );
				paramMap.put( "ERP_CO_CD", insertAbdocu_Tmp.getErp_co_cd( ) );
				paramMap.put( "ERP_DIV_CD", insertAbdocu_Tmp.getErp_div_cd( ) );
				paramMap.put( "ERP_GISU_DT", insertAbdocu_Tmp.getErp_gisu_dt( ) );
				paramMap.put( "ERP_GISU_SQ", insertAbdocu_Tmp.getErp_gisu_sq( ) );
				paramMap.put( "BANK_DT", "" );
				paramMap.put( "BANK_SQ", "" );
				paramMap.put( "TRAN_CD", "000" );
				paramMap.put( "ABDOCU_NO", insertAbdocu_Tmp.getAbdocu_no( ) );
				paramMap.put( "DUMMY1", insertAbdocu_Tmp.getAbdocu_no( ) );
				try {
					Map<String, String> delMap = acG20ExAppErpDAO.deleteG20Data( paramMap, conVo );
					String code = getStringValue( delMap, "ret_val" );
					if ( code.equalsIgnoreCase( "0" ) ) {// 성공
						break;
					}
					Thread.sleep( 1000 );
				}
				catch ( Exception e ) {
					if ( i == 5 ) {
						throw e;
					}
					ex.printStackTrace( );
					//                    LOG.error(e);
					Thread.sleep( 1000 );
				}
			}
			throw ex;
		}
		/* ERP 에 데이터 입력 끝 */
		/* ERP에서 return 받은 내용 GW 에 업데이트 */
		try {
			/* 프로젝트 정보 에 적용 */
			acG20ExAppGwDAO.completeERPAbdocuHData( abdocu_Tmp );
			/* 예산 정보 적용 */
			acG20ExAppGwDAO.completeERPDataAbdocuBMerge( abdocuBTmpSql.toString( ) );
			/* 거래처 정보 적용 */
			acG20ExAppGwDAO.completeERPDataAbdocuTMerge( abdocuTTmpSql.toString( ) );
			if ( state_use.equals( "Y" ) ) {
				if ( insertAbdocu_Tmp.getDocu_fg( ).equals( "8" ) ) { // 여비명세 완료 
					if ( insertAbdocu_TH_Tmp != null ) {
						acG20ExAppGwDAO.completeERPAbdocuTHData( insertAbdocu_TH_Tmp );
					}
					if ( insertAbdocu_TD_Tmp != null && insertAbdocu_TD_Tmp.size( ) > 0 ) {
						acG20ExAppGwDAO.completeERPDataAbdocuTDMerge( abdocuTDTmpSql.toString( ) );
					}
					if ( insertAbdocu_TD2_Tmp != null && insertAbdocu_TD2_Tmp.size( ) > 0 ) {
						acG20ExAppGwDAO.completeERPDataAbdocuTD2Merge( abdocuTD2TmpSql.toString( ) );
					}
				}
				else {// 일반명세 완료 
					if ( insertAbdocu_D_Tmp != null && insertAbdocu_D_Tmp.size( ) > 0 ) {
						acG20ExAppGwDAO.completeERPDataAbdocuDMerge( abdocuDTmpSql.toString( ) );
					}
				}
			}
		}
		catch ( Exception ex ) {
			throw ex;
		}
		//        LOG.error(" _NEOSG20DAO.completeApproval(abdocu_Tmp) - history :" + abdocu_Tmp.toString());
		int result = acG20ExAppGwDAO.completeApproval( abdocu_Tmp );
		Map<String, Object> map = new HashMap<String, Object>( );
		map.put( "result", result_H );
		return map;
	}

	/**
	 * qksfu
	 * doban7 2016. 9. 28.
	 * approvalReturn
	 * 
	 * @throws Exception
	 *
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public Map<String, Object> approvalReturn ( Abdocu_H abdocu ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Map<String, Object> param = new HashMap<String, Object>( );
		Map<String, String> DrafterInfo = (Map<String, String>) commonSql.selectByPk( "AcG20ExAppGw.getDrafterInfo", abdocu.getC_dikeycode( ) );
		LoginVO loginVo = new LoginVO( );
		if(DrafterInfo != null){
			loginVo.setCompSeq( EgovStringUtil.isNullToString(DrafterInfo.get( "COMP_SEQ" )) );
			loginVo.setOrgnztId( EgovStringUtil.isNullToString(DrafterInfo.get( "DEPT_SEQ" )) );
			loginVo.setUniqId( EgovStringUtil.isNullToString(DrafterInfo.get( "EMP_SEQ" )) );	
		}
		param.put( "loginVO", loginVo );
		conVo = GetConnection( param );
		Abdocu_H abdocuH = acG20ExGwDAO.getAbdocuH( abdocu );
		Map<String, String> result = null;
		//        int result = 0;
		/*
		 * if("0".equals(abdocuH.getDocu_mode())){
		 * // result = _NEOSG20DAO.deleteAbdocu_H(param);
		 * }else{
		 * result = acG20ExErpDAO.approvalReturn(abdocuH);
		 * }
		 */
		if ( abdocuH.getDocu_mode( ).equals( "1" ) ) {
			result = acG20ExAppErpDAO.approvalReturn( abdocuH, conVo );
		}
		//        map.put("result", getStringValue(result, "ret_val"));
		if ( !getStringValue( result, "ret_val" ).equals( "0" ) ) {
			throw new Exception( getStringValue( result, "RETURN_MESSAGE" ) );
		}
		return map;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public Map<String, Object> approvalEnd ( Abdocu_H abdocu ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Map<String, Object> param = new HashMap<String, Object>( );
		Map<String, String> DrafterInfo = (Map<String, String>) commonSql.selectByPk( "AcG20ExAppGw.getDrafterInfo", abdocu.getC_dikeycode() );
		LoginVO loginVo = new LoginVO( );
		if(DrafterInfo != null){
			loginVo.setCompSeq( EgovStringUtil.isNullToString(DrafterInfo.get( "COMP_SEQ" )) );
			loginVo.setOrgnztId( EgovStringUtil.isNullToString(DrafterInfo.get( "DEPT_SEQ" )) );
			loginVo.setUniqId( EgovStringUtil.isNullToString(DrafterInfo.get( "EMP_SEQ" )) );	
		}
		param.put( "loginVO", loginVo );
		conVo = GetConnection( param );
		Abdocu_H abdocuH = acG20ExGwDAO.getAbdocuH( abdocu );
		//List<Abdocu_B> list = _NEOSG20DAO.getAbdocu_B_TmpList(param);
		abdocuH.setDocnumber( abdocu.getDocnumber( ) );
		Map<String, String> result = acG20ExAppErpDAO.approvalEnd( abdocuH, conVo );
		//        map.put("result", getStringValue(result, "count"));
		if ( !getStringValue( result, "ret_val" ).equals( "0" ) ) {
			throw new Exception( getStringValue( result, "RETURN_MESSAGE" ) );
		}
		return map;
	}
}
