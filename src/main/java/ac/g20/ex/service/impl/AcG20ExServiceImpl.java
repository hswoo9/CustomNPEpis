package ac.g20.ex.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLDecoder;
import java.nio.channels.FileChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.commcode.dao.CodeDAO;
import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.service.CommFileService;
import com.duzon.custom.commfile.util.CommFileUtil;
import com.duzon.custom.common.utiles.EgovStringUtil;
import com.duzon.custom.consdocmng.dao.ConsDocMngDAO;
import com.duzon.custom.consdocmng.service.ConsDocMngService;
import com.duzon.custom.nightDuty.excel.ExcelRead;
import com.duzon.custom.nightDuty.excel.ExcelReadOption;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO;
import ac.g20.code.dao.AcG20CodeErpDAO;
import ac.g20.ex.dao.AcG20Ex2GwDAO;
import ac.g20.ex.dao.AcG20ExErpDAO;
import ac.g20.ex.dao.AcG20ExGwDAO;
import ac.g20.ex.service.AcG20ExService;
import ac.g20.ex.vo.ACardVO;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_D;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import ac.g20.ex.vo.Abdocu_TD;
import ac.g20.ex.vo.Abdocu_TD2;
import ac.g20.ex.vo.Abdocu_TH;
import ac.g20.ex.vo.PayDataVO;
import ac.g20.ex.vo.proposalVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.code.CommonCodeUtil;


/**
 * @title AcG20ExServiceImpl.java
 * @author doban7
 *
 * @date 2016. 9. 1.
 */
@Service ( "AcG20ExService" )
public class AcG20ExServiceImpl implements AcG20ExService{

	@Resource ( name = "AcG20ExErpDAO" )
	private AcG20ExErpDAO acG20ExErpDAO;
	@Resource ( name = "AcG20ExGwDAO" )
	private AcG20ExGwDAO acG20ExGwDAO;
	@Resource ( name = "AcG20Ex2GwDAO" )
	private AcG20Ex2GwDAO acG20Ex2GwDAO;
	@Resource ( name = "AcCommonService" )
	AcCommonService acCommonService;
	@Resource(name = "CommFileService")
	CommFileService commFileService;
	@Autowired
	CodeDAO codeDAO;
	@Autowired
	private ConsDocMngDAO consDocMngDAO;
	@Autowired
	private ConsDocMngService consDocMngService;

	/**
	 * GetConnection doban7 2016. 9. 1.
	 * 
	 * @return
	 */
	private ConnectionVO GetConnection ( ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> param = new HashMap<String, Object>( );
		param.put( "loginVO", loginVO );
		return acCommonService.acErpSystemInfo( param );
	}

	/**
	 * doban7 2016. 9. 5.
	 * chkErpBgtClose
	 **/
	@Override
	public HashMap<String, String> chkErpBgtClose ( ConnectionVO conVo, Map<String, String> paraMap ) throws Exception {
		return acG20ExErpDAO.chkErpBgtClose( paraMap, conVo );
	}

	/**
	 * doban7 2016. 9. 5.
	 * getErpGisuInfo
	 **/
	@Override
	public HashMap<String, String> getErpGisuInfo ( ConnectionVO conVo, Map<String, String> paraMap ) throws Exception {
		return acG20ExErpDAO.getErpGisuInfo( paraMap, conVo );
	}

	/**
	 * doban7 2016. 9. 5.
	 * insertAbdocu_H
	 **/
	@Override
	public Map<String, Object> insertAbdocu_H ( Abdocu_H abdocu_H ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.insertAbdocu_H( abdocu_H );
		map.put( "result", result.toString( ) );
		return map;
	}

	/**
	 * doban7 2016. 9. 5.
	 * updateAbdocu_H
	 **/
	@Override
	public Map<String, Object> updateAbdocu_H ( Abdocu_H abdocu_H ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.updateAbdocu_H( abdocu_H );
		map.put( "result", abdocu_H.getAbdocu_no( ) );
		return map;
	}

	/**
	 * doban7 2016. 9. 6.
	 * getAbdocuH
	 **/
	@Override
	public Abdocu_H getAbdocuH ( Abdocu_H abdocu_H ) throws Exception {
		return acG20ExGwDAO.getAbdocuH( abdocu_H );
	}

	/**
	 * doban7 2016. 9. 7.
	 * getAbdocuB
	 **/
	@Override
	public List<Abdocu_B> getAbdocuB_List ( Abdocu_H abdocu_H ) throws Exception {
		return acG20ExGwDAO.getAbdocuB_List( abdocu_H );
	}

	/**
	 * doban7 2016. 9. 7.
	 * getErpBudgetInfo
	 **/
	@Override
	public HashMap<String, String> getBudgetInfo ( ConnectionVO conVo, Map<String, String> paramMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		
		/* ERP 예산 정보 조회 */
		HashMap<String, String> result = acG20ExErpDAO.getErpBudgetInfo( paramMap, conVo );
		/* ERP 기수 정보 조회 */
		HashMap<String, String> gisuInfo = acG20ExErpDAO.getErpGisuInfo( paramMap, conVo );
		paramMap.put( "FROM_DT", gisuInfo.get( "FROM_DT" ) );
		paramMap.put( "TO_DT", gisuInfo.get( "TO_DT" ) );
		long erp_SUNGIN_DELAY_AM = Long.parseLong( getStringValue( result, "SUNGIN_DELAY_AM" ) );
		long erp_APPLY_AM = Long.parseLong( getStringValue( result, "APPLY_AM" ) );
		long erp_OPEN_AM = Long.parseLong( getStringValue( result, "OPEN_AM" ) );
		long erp_LEFT_AM = Long.parseLong( getStringValue( result, "LEFT_AM" ) );
		long erp_ACCEPT_AM = Long.parseLong( getStringValue( result, "ACCEPT_AM" ) ); //배정액
		map.put( "ERP_APPLY_AM", erp_APPLY_AM );
		map.put( "ERP_OPEN_AM", erp_OPEN_AM );
		map.put( "ERP_LEFT_AM", erp_LEFT_AM );
		map.put( "ERP_ACCEPT_AM", erp_ACCEPT_AM ); //배정액
		
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			HashMap<String, String> gwBudgetConsAmt = acG20Ex2GwDAO.getBudgetConsUseAmt( paramMap );
			HashMap<String, String> gwBudgetResAmt = acG20Ex2GwDAO.getBudgetResUseAmt( paramMap );
			
			long balanceAmt = Long.parseLong( getStringValue( gwBudgetConsAmt, "balanceAmt" ) );
			long resBudgetAmt = Long.parseLong( getStringValue( gwBudgetResAmt, "resBudgetAmt" ) );
			long new_APPLY_AM = erp_APPLY_AM + resBudgetAmt;
			long new_LEFT_AM = erp_LEFT_AM - balanceAmt - resBudgetAmt;
			
			result.put( "ERP_APPLY_AM", Long.toString( erp_APPLY_AM ) );
			result.put( "REFER_AM", Long.toString( balanceAmt ) );
			result.put( "APPLY_AM", Long.toString( new_APPLY_AM ) );
			result.put( "OPEN_AM", Long.toString( erp_OPEN_AM ) );
			result.put( "LEFT_AM", Long.toString( new_LEFT_AM ) );

		}else{
			/*  
			 *	품의 액 
			 */
			paramMap.put( "DOCU_MODE", "0" );
			HashMap<String, String> gwBudgetConsAmt = acG20ExGwDAO.getBudgetConsUseAmt( paramMap ); /* 품의된 금액 */
			/*
			 * 	결의 액
			 */
			paramMap.put( "DOCU_MODE", "1" );
			HashMap<String, String> gwBudgetResAmt = acG20ExGwDAO.getBudgetResUseAmt( paramMap ); /* 참조결의된 금액 */
			
			//품의금액
			long gw_APPLY_AM_1 = Long.parseLong( getStringValue( gwBudgetConsAmt, "APPLY_AM" ) );
			//집행금액
			long gw_APPLY_AM_2 = Long.parseLong( getStringValue( gwBudgetResAmt, "APPLY_AM" ) );
			
			long new_APPLY_AM = 0;/* 집행액 */
			long new_OPEN_AM = 0; /* 예산액 */
			long new_LEFT_AM = 0; /* 예산잔액 */
			long new_REFER_AM = 0 ; /* 참조 품의 액 */ 
			
			new_APPLY_AM = erp_APPLY_AM + gw_APPLY_AM_1 - gw_APPLY_AM_2;
			new_OPEN_AM = erp_OPEN_AM;
			new_LEFT_AM = erp_LEFT_AM - gw_APPLY_AM_1 + gw_APPLY_AM_2;
			new_REFER_AM = gw_APPLY_AM_1 - gw_APPLY_AM_2;
			
			result.put( "ERP_APPLY_AM", Long.toString( erp_APPLY_AM ) );
			result.put( "REFER_AM", Long.toString( new_REFER_AM ) );
			result.put( "APPLY_AM", Long.toString( new_APPLY_AM ) );
			result.put( "OPEN_AM", Long.toString( new_OPEN_AM ) );
			result.put( "LEFT_AM", Long.toString( new_LEFT_AM ) );
		}
		result.put( "SUNGIN_DELAY_AM", Long.toString( erp_SUNGIN_DELAY_AM ) );
		map.put( "result", result );
		return result;
	}

	/**
	 * getStringValue doban7 2016. 9. 7.
	 * 
	 * @param result
	 * @param string
	 * @return
	 */
	private String getStringValue ( HashMap<String, String> map, String key ) {
		String val = "0";
		if ( map.containsKey( key ) ) {
			if ( map.get( key ) != null ) {
				val = String.valueOf( map.get( key ) );
			}
		}
		return val;
	}

	/**
	 * doban7 2016. 9. 7.
	 * insertAbdocu_B
	 **/
	@Override
	public Map<String, Object> insertAbdocu_B ( Abdocu_B abdocu_B ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.insertAbdocu_B( abdocu_B );
		map.put( "result", result.toString( ) );
		return map;
	}

	/**
	 * doban7 2016. 9. 7.
	 * updateAbdocu_B
	 **/
	@Override
	public Map<String, Object> updateAbdocu_B ( Abdocu_B abdocu_B ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.updateAbdocu_B( abdocu_B );
		map.put( "result", abdocu_B.getAbdocu_b_no( ) );
		return map;
	}

	/**
	 * doban7 2016. 9. 7.
	 * setAbdocuT
	 **/
	@Override
	public List<Abdocu_T> getAbdocuT_List ( Abdocu_B abdocu_B ) throws Exception {
		return acG20ExGwDAO.getAbdocuT_List( abdocu_B );
	}

	/**
	 * doban7 2016. 9. 8.
	 * insertAbdocu_T
	 **/
	@Override
	public Map<String, Object> insertAbdocu_T ( Abdocu_T abdocu_T ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.insertAbdocu_T( abdocu_T );
		map.put( "result", result.toString( ) );
		abdocu_T.setAbdocu_t_no( result.toString( ) );
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T.getAbdocu_b_no( ) );
		map.put( "abdocu_B", abdocu_B );
		return map;
	}

	/**
	 * doban7 2016. 9. 8.
	 * updateAbdocu_T
	 **/
	@Override
	public Map<String, Object> updateAbdocu_T ( Abdocu_T abdocu_T ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.updateAbdocu_T( abdocu_T );
		map.put( "result", abdocu_T.getAbdocu_t_no( ) );
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T.getAbdocu_b_no( ) );
		map.put( "abdocu_B", abdocu_B );
		return map;
	}

	/**
	 * 
	 * doban7 2016. 9. 7.
	 * deleteAbdocu_H
	 *
	 */
	@Override
	public Integer deleteAbdocu_H ( Abdocu_H abdocu_H ) throws Exception {
		//        Map<String, Object> map = new HashMap<String, Object>();
		Abdocu_B abdocu_b = new Abdocu_B( );
		abdocu_b.setAbdocu_no( abdocu_H.getAbdocu_no( ) );
		int result = acG20ExGwDAO.deleteAbdocu_B( abdocu_b );
		String itemsUseYn = CommonCodeUtil.getCodeName( "G20301", "001" );
		if ( itemsUseYn.equals( "Y" ) ) {
			deleleItems( abdocu_H );
		}
		//        map.put("result", result);
		return result;
	}

	private void deleleItems ( Abdocu_H abdocu ) throws Exception {
		Abdocu_D abdocu_d = new Abdocu_D( );
		Abdocu_TH abdocu_th = new Abdocu_TH( );
		Abdocu_TD abdocu_td = new Abdocu_TD( );
		Abdocu_TD2 abdocu_td2 = new Abdocu_TD2( );
		abdocu_d.setAbdocu_no( abdocu.getAbdocu_no( ) );
		abdocu_th.setAbdocu_no( abdocu.getAbdocu_no( ) );
		abdocu_td.setAbdocu_no( abdocu.getAbdocu_no( ) );
		abdocu_td2.setAbdocu_no( abdocu.getAbdocu_no( ) );
		acG20ExGwDAO.deleteAbdocu_D( abdocu_d );
		acG20ExGwDAO.deleteAbdocu_TH( abdocu_th );
		acG20ExGwDAO.deleteAbdocu_TD( abdocu_td );
		acG20ExGwDAO.deleteAbdocu_TD2( abdocu_td2 );
		//        
	}

	/**
	 * doban7 2016. 9. 7.
	 * deleteAbdocu_B
	 **/
	@Override
	public Map<String, Object> deleteAbdocu_B ( Abdocu_B abdocu_B ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		acG20ExGwDAO.deleteAbdocu_B( abdocu_B );
		map.put( "result", "delete" );
		return map;
	}

	/**
	 * 
	 * doban7 2016. 9. 7.
	 * deleteAbdocu_T
	 *
	 */
	@Override
	public Map<String, Object> deleteAbdocu_T ( Abdocu_T abdocu_T ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		int result = acG20ExGwDAO.deleteAbdocu_T( abdocu_T );
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T.getAbdocu_b_no( ) );
		map.put( "abdocu_B", abdocu_B );
		map.put( "result", result );
		return map;
	}

	/**
	 * doban7 2016. 9. 19.
	 * approvalValidation
	 * @throws Exception 
	 **/
	@Override
	public Map<String, Object> approvalValidation ( ConnectionVO conVo, Abdocu_B abdocu_B ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		String abdocu_no_reffer = abdocu_B.getAbdocu_no_reffer( );
		String docu_mode = abdocu_B.getDocu_mode( );
		Abdocu_H abdocu_H_result = new Abdocu_H( );
		abdocu_H_result.setAbdocu_no( abdocu_B.getAbdocu_no( ) );
		Abdocu_B abdocu_B_result = null;
		//        String pattern = "####################";
		//        DecimalFormat df = new DecimalFormat(pattern);
		//exec P_GWG20_COMMON_LEFT_AMT @CO_CD='9000',@DIV_CD='1000',@BGT_CD='2134310100',@MGT_CD='1000',@GISU_DT=null,@SUM_CT_AM='0',@BOTTOM_CD='',@LANGKIND='KR'
		
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			/* 품의서 이거나 참조품의 가져오기 안한 지출결의서 */
			if ( "0".equals( docu_mode ) || ("1".equals( docu_mode ) && (abdocu_no_reffer == null || abdocu_no_reffer.isEmpty( ) || abdocu_no_reffer.equalsIgnoreCase( "0" ))) ) {
				abdocu_H_result = acG20ExGwDAO.getAbdocuH( abdocu_H_result ); // 결의서 정보
				abdocu_B_result = acG20ExGwDAO.getBgtApplyAmSumThis( abdocu_B ); // 현 결의서 예산별 결의금액 합계
				HashMap<String, String> paramMap = new HashMap<String, String>( );
				paramMap.put( "CO_CD", abdocu_H_result.getErp_co_cd( ) );
				paramMap.put( "DIV_CD", abdocu_H_result.getErp_div_cd( ) );
				paramMap.put( "BGT_CD", abdocu_B.getAbgt_cd( ) );
				paramMap.put( "MGT_CD", abdocu_H_result.getMgt_cd( ) );
				paramMap.put( "GISU_DT", abdocu_H_result.getErp_gisu_dt( ) );
				paramMap.put( "SUM_CT_AM", "0" );
				paramMap.put( "BOTTOM_CD", abdocu_H_result.getBottom_cd( ) );
				paramMap.put( "LANGKIND", "KR" );
				
				HashMap<String, String> gisuInfo = acG20ExErpDAO.getErpGisuInfo( paramMap, conVo );
				paramMap.put( "FROM_DT", gisuInfo.get( "FROM_DT" ) );
				paramMap.put( "TO_DT", gisuInfo.get( "TO_DT" ) );
				
				paramMap.put( "gisu", String.valueOf(gisuInfo.get( "GI_SU" )) );
				paramMap.put( "erpBudgetSeq", abdocu_B.getAbgt_cd( ) );
				paramMap.put( "mgtSeq", abdocu_H_result.getMgt_cd( ) );
				paramMap.put( "budgetSeq", abdocu_B.getAbdocu_b_no() );
				
				HashMap<String, String> result = acG20ExErpDAO.getErpBudgetInfo( paramMap, conVo );
				long erp_LEFT_AM = Long.parseLong( getStringValue( result, "LEFT_AM" ) );
				/* 결의안된 품의액 */
				HashMap<String, String> gwBudgetConsAmt = acG20Ex2GwDAO.getBudgetConsUseAmt( paramMap );
				long balanceAmt = Long.parseLong( getStringValue( gwBudgetConsAmt, "balanceAmt" ) );
				/* 미전송 결의액 */
				HashMap<String, String> gwBudgetResAmt = acG20Ex2GwDAO.getBudgetResUseAmt( paramMap );
				long resBudgetAmt = Long.parseLong( getStringValue( gwBudgetResAmt, "resBudgetAmt" ) );
				long new_LEFT_AM = 0; /* 예산잔액 */
				// 예산잔액  : erp 예산잔액 - 결의안된 품의액 - 미전송 결의액
				new_LEFT_AM = erp_LEFT_AM - balanceAmt - resBudgetAmt;
				String tempApply_am = abdocu_B_result.getApply_am( );
				long valiAPPLY_AM = Long.parseLong( tempApply_am );/* 검사할 집행금액 */ 
				long resultAM = new_LEFT_AM - valiAPPLY_AM;
				map.put( "result", Long.toString( resultAM ) );
				map.put( "ctlFg", getStringValue( result, "CTL_FG" ) ); /* 예산통제 여부 flag */
				map.put( "trCnt", abdocu_B_result.getTr_cnt() );
			}
			else {
				/* 참조품의 가져오기 한 지출결의서 */
				// TODO 참조품의 결의서 수정필요
				abdocu_B_result = acG20ExGwDAO.getBgtApplyAmSumReffer( abdocu_B );
				long gw_APPLY_AM = Long.parseLong( abdocu_B_result.getApply_am( ) ); // 품의서 참조한 결의서의 예산별 결의금액
				long gw_OPEN_AM = Long.parseLong( abdocu_B_result.getOpen_am( ) ); // 참조품의서의 예산별 품의금액
				long resultAM = gw_OPEN_AM - gw_APPLY_AM;
				map.put( "result", Long.toString( resultAM ) );
				map.put( "ctlFg", "10" );
				map.put( "trCnt", abdocu_B_result.getTr_cnt() );
			}
		}else{
			/* 품의서 이거나 참조품의 가져오기 안한 지출결의서 */
			if ( "0".equals( docu_mode ) || ("1".equals( docu_mode ) && (abdocu_no_reffer == null || abdocu_no_reffer.isEmpty( ) || abdocu_no_reffer.equalsIgnoreCase( "0" ))) ) {
				abdocu_H_result = acG20ExGwDAO.getAbdocuH( abdocu_H_result ); // 결의서 정보
				abdocu_B_result = acG20ExGwDAO.getBgtApplyAmSumThis( abdocu_B ); // 현 결의서 예산별 결의금액 합계
				HashMap<String, String> paramMap = new HashMap<String, String>( );
				paramMap.put( "CO_CD", abdocu_H_result.getErp_co_cd( ) );
				paramMap.put( "DIV_CD", abdocu_H_result.getErp_div_cd( ) );
				paramMap.put( "BGT_CD", abdocu_B.getAbgt_cd( ) );
				paramMap.put( "MGT_CD", abdocu_H_result.getMgt_cd( ) );
				paramMap.put( "GISU_DT", abdocu_H_result.getErp_gisu_dt( ) );
				paramMap.put( "SUM_CT_AM", "0" );
				paramMap.put( "BOTTOM_CD", abdocu_H_result.getBottom_cd( ) );
				paramMap.put( "LANGKIND", "KR" );
				
				
				HashMap<String, String> gisuInfo = acG20ExErpDAO.getErpGisuInfo( paramMap, conVo );
				paramMap.put( "FROM_DT", gisuInfo.get( "FROM_DT" ) );
				paramMap.put( "TO_DT", gisuInfo.get( "TO_DT" ) );
				
				HashMap<String, String> result = acG20ExErpDAO.getErpBudgetInfo( paramMap, conVo );
				long erp_LEFT_AM = Long.parseLong( getStringValue( result, "LEFT_AM" ) );
				/* 품의된 금액 */
				paramMap.put( "DOCU_MODE", "0" );
				HashMap<String, String> gwBudgetConsAmt = acG20ExGwDAO.getBudgetConsUseAmt( paramMap );
				long gw_APPLY_AM_1 = Long.parseLong( getStringValue( gwBudgetConsAmt, "APPLY_AM" ) );
				/* 참조결의된 금액 */
				paramMap.put( "DOCU_MODE", "1" );
				HashMap<String, String> gwBudgetResAmt = acG20ExGwDAO.getBudgetResUseAmt( paramMap );
				long gw_APPLY_AM_2 = Long.parseLong( getStringValue( gwBudgetResAmt, "APPLY_AM" ) );
				long new_LEFT_AM = 0; /* 예산잔액 */
				// 예산잔액  : erp 예산잔액 - 품의액 + 품의참조결의액
				new_LEFT_AM = erp_LEFT_AM - gw_APPLY_AM_1 + gw_APPLY_AM_2;
				String tempApply_am = abdocu_B_result.getApply_am( );
				long valiAPPLY_AM = Long.parseLong( tempApply_am );/* 검사할 집행금액 */ 
				long resultAM = new_LEFT_AM - valiAPPLY_AM;
				map.put( "result", Long.toString( resultAM ) );
				map.put( "ctlFg", getStringValue( result, "CTL_FG" ) ); /* 예산통제 여부 flag */
				map.put( "trCnt", abdocu_B_result.getTr_cnt() );
			}
			else {
				/* 참조품의 가져오기 한 지출결의서 */
				abdocu_B_result = acG20ExGwDAO.getBgtApplyAmSumReffer( abdocu_B );
				long gw_APPLY_AM = Long.parseLong( abdocu_B_result.getApply_am( ) ); // 품의서 참조한 결의서의 예산별 결의금액
				long gw_OPEN_AM = Long.parseLong( abdocu_B_result.getOpen_am( ) ); // 참조품의서의 예산별 품의금액
				long resultAM = gw_OPEN_AM - gw_APPLY_AM;
				map.put( "result", Long.toString( resultAM ) );
				map.put( "ctlFg", "10" );
				map.put( "trCnt", abdocu_B_result.getTr_cnt() );
			}
		}
		return map;
	}

	/**
	 * doban7 2016. 9. 21.
	 * getTaxConifg
	 **/
	@Override
	public HashMap<String, String> getErpTaxConifg ( ConnectionVO conVo, HashMap<String, String> paraMap ) throws Exception {
		return acG20ExErpDAO.getErpTaxConifg( paraMap, conVo );
	}

	/**
	 * doban7 2016. 9. 26.
	 * getBudgetInfo2
	 * 
	 * @throws Exception
	 **/
	@Override
	public Map<String, String> getBudgetInfo2 ( HashMap<String, String> paraMap ) throws Exception {
		ConnectionVO conVo = GetConnection( );
		HashMap<String, String> result = acG20ExErpDAO.getErpBudgetInfo( paraMap, conVo );
		return result;
	}

	/**
	 * doban7 2016. 9. 26.
	 * getBudgetInfo3
	 * 
	 * @throws Exception
	 **/
	@Override
	public Map<String, Object> getBudgetInfo3 ( HashMap<String, String> paramMap ) throws Exception {
		ConnectionVO conVo = GetConnection( );
		Map<String, Object> map = new HashMap<String, Object>( );
		HashMap<String, String> result = acG20ExErpDAO.getErpBudgetInfo( paramMap, conVo );
		HashMap<String, String> gisuInfo = acG20ExErpDAO.getErpGisuInfo( paramMap, conVo );
		paramMap.put( "FROM_DT", gisuInfo.get( "FROM_DT" ) );
		paramMap.put( "TO_DT", gisuInfo.get( "TO_DT" ) );
		long erp_SUNGIN_DELAY_AM = Long.parseLong( getStringValue( result, "SUNGIN_DELAY_AM" ) );
		
		HashMap<String, String> consParam = paramMap;
		consParam.put( "DOCU_MODE", "0" );
		HashMap<String, String> gwBudgetConsAmt = acG20ExGwDAO.getBudgetConsUseAmt( consParam ); /* 품의된 금액 */
		
		paramMap.put( "DOCU_MODE", "1" );
		HashMap<String, String> gwBudgetResAmt = acG20ExGwDAO.getBudgetResUseAmt( paramMap ); /* 참조결의된 금액 */
		
		long erp_APPLY_AM = Long.parseLong( getStringValue( result, "APPLY_AM" ) );
		long erp_OPEN_AM = Long.parseLong( getStringValue( result, "OPEN_AM" ) );
		long erp_LEFT_AM = Long.parseLong( getStringValue( result, "LEFT_AM" ) );
		long erp_ACCEPT_AM = Long.parseLong( getStringValue( result, "ACCEPT_AM" ) ); //배정액
		map.put( "ERP_APPLY_AM", erp_APPLY_AM ); // ERP 기집행액
		map.put( "ERP_OPEN_AM", erp_OPEN_AM ); // ERP 예산액
		map.put( "ERP_LEFT_AM", erp_LEFT_AM ); // ERP 예산잔액
		map.put( "ERP_ACCEPT_AM", erp_ACCEPT_AM ); // ERP 배정액
		long gw_APPLY_AM_1 = Long.parseLong( getStringValue( gwBudgetConsAmt, "APPLY_AM" ) );
		long gw_APPLY_AM_2 = Long.parseLong( getStringValue( gwBudgetResAmt, "APPLY_AM" ) );
		// 2013-05-14 참조품의일때 금회집행액을 가져온다. 참조품의번호 없으면 0;
		long gw_APPLY_AM_3 = 0;
		HashMap<String, String> gwBudgetResAmtThis = acG20ExGwDAO.getResApplyAmThis( paramMap ); /* 금회집행액 */
		if ( gwBudgetResAmtThis != null ) {
			gw_APPLY_AM_3 = Long.parseLong( getStringValue( gwBudgetResAmtThis, "APPLY_AM" ) );
		}
		long new_APPLY_AM = 0;/* 집행액 */
		long new_OPEN_AM = 0; /* 예산액 */
		long new_LEFT_AM = 0; /* 예산잔액 */
		new_APPLY_AM = erp_APPLY_AM + gw_APPLY_AM_1 - gw_APPLY_AM_2;
		new_OPEN_AM = erp_OPEN_AM;
		// 2013-05-14 참조품의일때 금회집행액을 더해준다.
		new_LEFT_AM = erp_LEFT_AM - gw_APPLY_AM_1 + gw_APPLY_AM_2;
		long new_TOTAL_LEFT_AM = erp_LEFT_AM - gw_APPLY_AM_1 + gw_APPLY_AM_2 + gw_APPLY_AM_3;
		long new_REFER_AM = gw_APPLY_AM_1 - gw_APPLY_AM_2 - gw_APPLY_AM_3;
		map.put( "APPLY_AM", new_APPLY_AM ); // GW 집행액 (ERP 집행액 - GW 품의액 + GW 참조품의결의액)
		map.put( "OPEN_AM", new_OPEN_AM ); // 예산액 (ERP 예산액)
		map.put( "LEFT_AM", new_LEFT_AM ); // 예산잔액 (ERP 예산잔액 - GW 품의액 + GW 참조품의결의액 )
		map.put( "TOTAL_LEFT_AM", new_TOTAL_LEFT_AM ); // 예산잔액 (ERP 예산잔액 - GW 품의액 + GW 참조품의결의액 + 금회집행액 참조품의액)
		map.put( "SUNGIN_DELAY_AM", erp_SUNGIN_DELAY_AM );
		
		
		long consAm = Long.parseLong( getStringValue( gwBudgetConsAmt, "APPLY_AM" ) );
		long resAm = Long.parseLong( getStringValue( gwBudgetResAmt, "APPLY_AM" ) );
		
		map.put( "REFER_AM", consAm - resAm); // 품의잔액
		map.put( "result", result );
		
		
		/* 양식코드 리뉴얼 */
		long A_AM = Long.parseLong( getStringValue( result, "OPEN_AM" ) );				// AB_OPEN_AM
		long B_AM = Long.parseLong( getStringValue( result, "APPLY_AM" ) );				// AB_ERP_APPLY_AM
		long C_AM = Long.parseLong( getStringValue( result, "LEFT_AM" ) );				// AB_LEFT_AM
		long D_AM = Long.parseLong( getStringValue( result, "ACCEPT_AM" ) );			// AB_ACCEPT_AM
		long E_AM = Long.parseLong( getStringValue( gwBudgetConsAmt, "APPLY_AM" ) );	// 코드 미사용
		long F_AM = Long.parseLong( getStringValue( gwBudgetResAmt, "APPLY_AM" ) );		// 코드 미사용
		long G_AM = E_AM - F_AM - gw_APPLY_AM_3;										// AB_REFFER_AM
		long H_AM = B_AM + G_AM;														// AB_GW_APPLY_AM
		long I_AM = C_AM - G_AM;														// AB_TOTAL_RESULT_AM
		
		map.put( "AB_OPEN_AM", A_AM );				
		map.put( "AB_ERP_APPLY_AM", B_AM );				 
		map.put( "AB_LEFT_AM", C_AM );		
		map.put( "AB_ACCEPT_AM", D_AM);		
		map.put( "AB_REFFER_AM", G_AM );	
		map.put( "AB_GW_APPLY_AM", H_AM );	
		map.put( "AB_GW_LEFT_AM", I_AM );	
		
		//map.put("result1", gwBudgetInfo);
		return map;
	}

	/**
	 * doban7 2016. 9. 28.
	 * getReferConfer
	 **/
	public List<HashMap<String, String>> getReferConfer ( HashMap<String, String> paraMap ) throws Exception {
		String isAllDocView = paraMap.get( "isAllDocView" ); //지출결의 권한자
		String queryID = "AcG20ExGw.getReferConfer";
		if ( isAllDocView.equals( "1" ) ) { // 전체문서보기(지출결의 권한자)
			queryID = "AcG20ExGw.getReferConferAll";
			return acG20ExGwDAO.getReferConfer( paraMap, queryID );
		}else{
			List<HashMap<String, String>> referConfer = acG20ExGwDAO.getReferConfer( paraMap, queryID );
			List<HashMap<String, String>> returList = new ArrayList<>( );
			
			if(paraMap.get("isAllView") == null){
				returList = referConfer;
			}
			else if ( paraMap.get( "isAllView" ).toString( ).equals( "001" ) ) {
				for ( HashMap<String, String> item : referConfer ) {
					// AND		(OPEN_AM - APPLY_AM)  <![CDATA[<>]]> 0
					
					if(! item.get( "APPLY_AM" ).equals( item.get( "OPEN_AM" ))){
						returList.add( item );
					}
				}
			}
			else {
				returList = referConfer;
			}
			return returList;	
		}
	}

	/**
	 * doban7 2016. 9. 29.
	 * insertReferConfer
	 **/
	@Override
	public Map<String, Object> insertReferConfer ( Abdocu_H abdocu_H_Tmp ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Abdocu_H abdocu_H = new Abdocu_H( );
		Abdocu_B abdocu_B = new Abdocu_B( );
		abdocu_H.setAbdocu_no_reffer( abdocu_H_Tmp.getAbdocu_no_reffer( ) );
		// abdocu_h 헤더 정보 저장  
		String abdocu_no = acG20ExGwDAO.insertReferConfer_H( abdocu_H_Tmp );
		abdocu_H.setAbdocu_no( abdocu_no );
		abdocu_B.setAbdocu_no_reffer( abdocu_H_Tmp.getAbdocu_no_reffer( ) );
		abdocu_B.setAbdocu_no( abdocu_H_Tmp.getAbdocu_no( ) );
		// abdocu_b 예산 정보 조회 
		List<Abdocu_B> Abdocu_B_list = acG20ExGwDAO.selectReferConfer_B( abdocu_B );
		for ( int i = 0, max = Abdocu_B_list.size( ); i < max; i++ ) {
			Abdocu_B t_abdocu_B = Abdocu_B_list.get( i );
			t_abdocu_B.setInsert_id( abdocu_H_Tmp.getInsert_id( ) );
			// abdocu_b 예산 정보 저장 
			acG20ExGwDAO.insertReferConfer_B( t_abdocu_B );
			// abdocu_t 채주 정보 조회 
			List<Abdocu_T> Abdocu_T_list = acG20ExGwDAO.selectReferConfer_T( t_abdocu_B );
			for ( int j = 0, jMax = Abdocu_T_list.size( ); j < jMax; j++ ) {
				Abdocu_T t_abdocu_T = Abdocu_T_list.get( j );
				t_abdocu_B.setInsert_id( abdocu_H_Tmp.getInsert_id( ) );
				// abdocu_t 채주 정보 저장 
				acG20ExGwDAO.insertReferConfer_T( t_abdocu_T );
			}
		}
		map.put( "result", abdocu_H );
		return map;
	}

	/**
	 * doban7 2016. 9. 29.
	 * getConferBalance
	 **/
	@Override
	public String getConferBalance ( Abdocu_B abdocu_b ) throws Exception {
		return acG20ExGwDAO.getConferBalance( abdocu_b );
	}

	/**
	 * doban7 2016. 9. 29.
	 * getReturnConferBudget
	 **/
	@Override
	public Map<String, Object> getReturnConferBudget ( HashMap<String, String> paraMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		int spendCnt = acG20ExGwDAO.getUseSpendStandingCnt( paraMap );
		if ( spendCnt > 0 ) {
			map.put( "result", "ING" );
			return map;
		}
		List<HashMap<String, String>> selectList = getReferConfer( paraMap );
		HashMap<String, String> returnBudget = selectList.get( 0 ); /* 예산환원 할 예산 */
		Long open_am = Long.parseLong( getStringValue( returnBudget, "OPEN_AM" ).replace( ",", "" ).trim( ) );
		Long apply_am = Long.parseLong( getStringValue( returnBudget, "APPLY_AM" ).replace( ",", "" ).trim( ) );
		String abdocu_no = getStringValue( returnBudget, "ABDOCU_NO" );
		Long returnOpen_am = open_am - apply_am;
		returnOpen_am = returnOpen_am * -1;
		Abdocu_B abdocu_B = new Abdocu_B( );
		abdocu_B.setAbdocu_b_no( paraMap.get( "ABDOCU_B_NO" ) );
		abdocu_B.setApply_am( returnOpen_am + "" );
		/* 품의금액 - 잔액 = 업데이트 금액 */
		//acG20ExGwDAO.updateReturnConferBudget(abdocu_B); 
		abdocu_B = new Abdocu_B( );
		abdocu_B.setApply_am( returnOpen_am + "" );
		abdocu_B.setConfer_return( paraMap.get( "ABDOCU_B_NO" ) );
		abdocu_B.setAbdocu_no( abdocu_no );
		abdocu_B.setErp_co_cd( "0" );
		acG20ExGwDAO.insertAbdocu_B( abdocu_B );
		// 환원처리를 row insert 가 아닌  환원여부 체크로 수정 필요할듯 함.
		map.put( "result", "OK" );
		return map;
	}

	/**
	 * doban7 2016. 9. 29.
	 * returnConferBudgetRollBack
	 **/
	@Override
	public Map<String, Object> returnConferBudgetRollBack ( HashMap<String, String> paraMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Abdocu_B abdocu_B = new Abdocu_B( );
		abdocu_B.setConfer_return( paraMap.get( "ABDOCU_B_NO" ) );
		Abdocu_B abdocu_B_Info = acG20ExGwDAO.getReturnConferBudgetRollBackInfo( abdocu_B );
		/* 예산환원 백업정보 삭제 */
		acG20ExGwDAO.deleteAbdocu_B( abdocu_B_Info );
		abdocu_B = new Abdocu_B( );
		abdocu_B.setAbdocu_b_no( paraMap.get( "ABDOCU_B_NO" ) );
		abdocu_B.setApply_am( abdocu_B_Info.getApply_am( ) );
		/* 품의금액 - 잔액 = 업데이트 금액 */
		//acG20ExGwDAO.updateReturnConferBudget(abdocu_B); 
		map.put( "result", "OK" );
		return map;
	}

	/**
	 * doban7 2016. 10. 6.
	 * getETCDUMMY1_Info
	 **/
	@Override
	public HashMap<String, String> getErpETCDUMMY1_Info ( HashMap<String, String> paraMap, ConnectionVO conVo ) throws Exception {
		return acG20ExErpDAO.getErpETCDUMMY1_Info( paraMap, conVo );
	}

	/**
	 * doban7 2016. 10. 6.
	 * getETCDUMMY1
	 **/
	@Override
	public HashMap<String, String> getETCDUMMY1 ( HashMap<String, String> paraMap ) throws Exception {
		return acG20ExGwDAO.getETCDUMMY1( paraMap );
	}

	/**
	 * doban7 2016. 10. 1.
	 * getACardSungin_List
	 **/
	@Override
	public List<ACardVO> getACardSungin_List ( ACardVO aCardVO ) throws Exception {
		return acG20ExGwDAO.getACardSungin_List( aCardVO );
	}

	/**
	 * doban7 2016. 10. 2.
	 * getACardList
	 **/
	@Override
	public List<HashMap<String, String>> getACardList ( HashMap<String, Object> paraMap ) throws Exception {
		return acG20ExGwDAO.getACardList( paraMap );
	}

	/**
	 * doban7 2016. 10. 2.
	 * getErpACardSunginList
	 **/
	@Override
	public List<HashMap<String, String>> getErpACardSunginList ( HashMap<String, String> requestMap, ConnectionVO conVo ) throws Exception {
		return acG20ExErpDAO.getErpACardSunginList( requestMap, conVo );
	}

	/**
	 * doban7 2016. 10. 2.
	 * setACardSungin
	 **/
	@Override
	public Map<String, Object> setACardSungin ( ACardVO aCardVO ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		acG20ExGwDAO.deleteACardSungin( aCardVO );
		int result = 0;
		if ( aCardVO.getStrPKEY( ) != null ) {
			for ( int i = 0; i < aCardVO.getStrISS_DT( ).length; i++ ) {
				aCardVO.setISS_DT( aCardVO.getStrISS_DT( )[i] );
				aCardVO.setISS_SQ( aCardVO.getStrISS_SQ( )[i] );
				aCardVO.setCHAIN_NAME( EgovStringUtil.getHtmlStrCnvr( aCardVO.getStrCHAIN_NAME( )[i] ) );
				aCardVO.setCHAIN_REGNB( aCardVO.getStrCHAIN_REGNB( )[i] );
				aCardVO.setSUNGIN_NB( aCardVO.getStrSUNGIN_NB( )[i] );
				aCardVO.setSUNGIN_AM( aCardVO.getStrSUNGIN_AM( )[i] );
				aCardVO.setVAT_AM( aCardVO.getStrVAT_AM( )[i] );
				aCardVO.setTOT_AM( aCardVO.getStrTOT_AM( )[i] );
				aCardVO.setUSER_TYPE( aCardVO.getStrUSER_TYPE( )[i] );
				aCardVO.setGW_STATE( aCardVO.getStrGW_STATE().length > 0 ?  aCardVO.getStrGW_STATE( )[i] : "");
//				aCardVO.setGW_STATE( aCardVO.getStrGW_STATE( )[i] );
				aCardVO.setGW_STATE_HAN( aCardVO.getStrGW_STATE_HAN( )[i] );
				aCardVO.setPKEY( aCardVO.getStrPKEY( )[i] );
				aCardVO.setCTR_CD( aCardVO.getStrCTR_CD( )[i] );
				aCardVO.setCTR_NM( aCardVO.getStrCTR_NM( )[i] );
				aCardVO.setCARD_NB( aCardVO.getStrCARD_NB( )[i] );
				aCardVO.setCHAIN_BUSINESS( aCardVO.getStrCHAIN_BUSINESS().length > 0 ?  aCardVO.getStrCHAIN_BUSINESS( )[i] : "");
//				aCardVO.setCHAIN_BUSINESS( aCardVO.getStrCHAIN_BUSINESS( )[i] );
				aCardVO.setADMIT_DT( aCardVO.getStrADMIT_DT().length > 0 ?  aCardVO.getStrADMIT_DT( )[i] : "");
//				aCardVO.setADMIT_DT( aCardVO.getStrADMIT_DT( )[i] );
				aCardVO.setCANCEL_YN( aCardVO.getStrCANCEL_YN().length > 0 ?  aCardVO.getStrCANCEL_YN( )[i] : "");
//				aCardVO.setCANCEL_YN( aCardVO.getStrCANCEL_YN( )[i] );
				String abdocu_t_no = acG20ExGwDAO.insertAbdocu_T_ACard( aCardVO );
				aCardVO.setAbdocu_t_no( abdocu_t_no );
				acG20ExGwDAO.insertACardSungin( aCardVO );
			}
		}
		result = 1;
		Abdocu_T abdocu_T_Tmp = new Abdocu_T( );
		abdocu_T_Tmp.setAbdocu_b_no( aCardVO.getAbdocu_b_no( ) );
		//        acG20ExGwDAO.sumBudgetUpdate(abdocu_T_Tmp);
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T_Tmp );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T_Tmp.getAbdocu_b_no( ) );
		map.put( "abdocu_B", abdocu_B );
		map.put( "result", result );
		return map;
	}

	/**
	 * doban7 2016. 10. 3.
	 * getAbdocuTH
	 **/
	@Override
	public Abdocu_TH getAbdocuTH ( Abdocu_H abdocu_h ) throws Exception {
		return acG20ExGwDAO.getAbdocuTH( abdocu_h );
	}

	/**
	 * doban7 2016. 10. 3.
	 * getAbdocuTD_List
	 **/
	@Override
	public List<Abdocu_TD> getAbdocuTD_List ( Abdocu_H abdocu_h ) throws Exception {
		return acG20ExGwDAO.getAbdocuTD_List( abdocu_h );
	}

	/**
	 * doban7 2016. 10. 3.
	 * getAbdocuTD2_List
	 **/
	@Override
	public List<Abdocu_TD2> getAbdocuTD2_List ( Abdocu_H abdocu_h ) throws Exception {
		return acG20ExGwDAO.getAbdocuTD2_List( abdocu_h );
	}

	/**
	 * doban7 2016. 10. 3.
	 * insertAbdocu_TH
	 **/
	@Override
	public Object insertAbdocu_TH ( Abdocu_TH abdocu_th ) throws Exception {
		return acG20ExGwDAO.insertAbdocu_TH( abdocu_th );
	}

	/**
	 * doban7 2016. 10. 3.
	 * updateAbdocu_TH
	 **/
	@Override
	public int updateAbdocu_TH ( Abdocu_TH abdocu_th ) throws Exception {
		return acG20ExGwDAO.updateAbdocu_TH( abdocu_th );
	}

	/**
	 * doban7 2016. 10. 3.
	 * deleteAbdocu_TH
	 **/
	@Override
	public int deleteAbdocu_TH ( Abdocu_TH abdocu_th ) throws Exception {
		return acG20ExGwDAO.deleteAbdocu_TH( abdocu_th );
	}

	/**
	 * doban7 2016. 10. 4.
	 * updateAbdocu_TD
	 **/
	@Override
	public int updateAbdocu_TD ( Abdocu_TD abdocu_td ) throws Exception {
		return acG20ExGwDAO.updateAbdocu_TD( abdocu_td );
	}

	/**
	 * doban7 2016. 10. 4.
	 * insertAbdocu_TD
	 **/
	@Override
	public Object insertAbdocu_TD ( Abdocu_TD abdocu_td ) throws Exception {
		return acG20ExGwDAO.insertAbdocu_TD( abdocu_td );
	}

	/**
	 * doban7 2016. 10. 4.
	 * updateAbdocu_TD2
	 **/
	@Override
	public int updateAbdocu_TD2 ( Abdocu_TD2 abdocu_td2 ) throws Exception {
		return acG20ExGwDAO.updateAbdocu_TD2( abdocu_td2 );
	}

	/**
	 * doban7 2016. 10. 4.
	 * insertAbdocu_TD2
	 **/
	@Override
	public Object insertAbdocu_TD2 ( Abdocu_TD2 abdocu_td2 ) throws Exception {
		return acG20ExGwDAO.insertAbdocu_TD2( abdocu_td2 );
	}

	/**
	 * doban7 2016. 10. 4.
	 * deleteAbdocu_TD
	 **/
	@Override
	public int deleteAbdocu_TD ( Abdocu_TD abdocu_td ) throws Exception {
		return acG20ExGwDAO.deleteAbdocu_TD( abdocu_td );
	}

	/**
	 * doban7 2016. 10. 4.
	 * deleteAbdocu_TD2
	 **/
	@Override
	public int deleteAbdocu_TD2 ( Abdocu_TD2 abdocu_td2 ) throws Exception {
		return acG20ExGwDAO.deleteAbdocu_TD2( abdocu_td2 );
	}

	/**
	 * doban7 2016. 10. 4.
	 * getAbdocuD_List
	 **/
	@Override
	public List<Abdocu_D> getAbdocuD_List ( Abdocu_H abdocu_h ) throws Exception {
		return acG20ExGwDAO.getAbdocuD_List( abdocu_h );
	}

	/**
	 * doban7 2016. 10. 4.
	 * updateAbdocu_D
	 **/
	@Override
	public int updateAbdocu_D ( Abdocu_D abdocu_d ) throws Exception {
		return acG20ExGwDAO.updateAbdocu_D( abdocu_d );
	}

	/**
	 * doban7 2016. 10. 4.
	 * insertAbdocu_D
	 **/
	@Override
	public Object insertAbdocu_D ( Abdocu_D abdocu_d ) throws Exception {
		return acG20ExGwDAO.insertAbdocu_D( abdocu_d );
	}

	/**
	 * doban7 2016. 10. 4.
	 * deleteAbdocu_D
	 **/
	@Override
	public int deleteAbdocu_D ( Abdocu_D abdocu_d ) throws Exception {
		return acG20ExGwDAO.deleteAbdocu_D( abdocu_d );
	}

	/**
	 * doban7 2016. 10. 5.
	 * getItemsTotalAm
	 **/
	@Override
	public HashMap<String, String> getItemsTotalAm ( Abdocu_H abdocu_H ) throws Exception {
		String queryID = "AcG20ExGw.getGoodsItemsTotal";
		if ( abdocu_H.getDocu_fg( ).equals( "8" ) ) {
			queryID = "AcG20ExGw.getTravelItemsTotal";
		}
		return acG20ExGwDAO.getItemsTotalAm( abdocu_H, queryID );
	}

	/**
	 * doban7 2016. 10. 6.
	 * setAbdocuCause
	 **/
	@Override
	public Integer setAbdocuCause ( Abdocu_H abdocu ) throws Exception {
		return acG20ExGwDAO.updateAbdocuCause( abdocu );
	}

	/**
	 * doban7 2016. 10. 21.
	 * getThisPayDataList
	 **/
	@Override
	public List<PayDataVO> getThisPayDataList ( HashMap<String, String> paraMap ) throws Exception {
		return acG20ExGwDAO.getThisPayDataList( paraMap );
	}

	/**
	 * doban7 2016. 10. 24.
	 * getErpPayData
	 **/
	@Override
	public List<HashMap<String, Object>> getErpPayData ( HashMap<String, Object> paraMap, ConnectionVO conVo ) throws Exception {
		return acG20ExErpDAO.getErpPayData( paraMap, conVo );
	}

	/**
	 * doban7 2016. 10. 24.
	 * setPayData
	 **/
	@Override
	public Map<String, Object> setPayData ( PayDataVO payDataVO ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		acG20ExGwDAO.deleteAbdocu_T_PayData( payDataVO );
		int result = 0;
		if ( payDataVO.getStrPKEY( ) != null ) {
			for ( int i = 0; i < payDataVO.getStrPKEY( ).length; i++ ) {
				payDataVO.setPKEY( payDataVO.getStrPKEY( )[i] );
				payDataVO.setEMP_TR_CD( payDataVO.getStrEMP_TR_CD( )[i] );
				payDataVO.setKOR_NM( payDataVO.getStrKOR_NM( )[i] );
				payDataVO.setDEPT_NM( payDataVO.getStrDEPT_NM( )[i] );
				payDataVO.setRVRS_YM( payDataVO.getStrRVRS_YM( )[i] );
				payDataVO.setSQ( payDataVO.getStrSQ( )[i] );
				payDataVO.setGISU_DT( payDataVO.getStrGISU_DT( )[i] );
				payDataVO.setPAY_DT( payDataVO.getStrPAY_DT( )[i] );
				payDataVO.setTPAY_AM( payDataVO.getStrTPAY_AM( )[i] );
				payDataVO.setSUP_AM( payDataVO.getStrSUP_AM( )[i] );
				payDataVO.setVAT_AM( payDataVO.getStrVAT_AM( )[i] );
				payDataVO.setINTX_AM( payDataVO.getStrINTX_AM( )[i] );
				payDataVO.setRSTX_AM( payDataVO.getStrRSTX_AM( )[i] );
				payDataVO.setETC_AM( payDataVO.getStrETC_AM( )[i] );
				payDataVO.setACCT_NO( payDataVO.getStrACCT_NO( )[i] );
				payDataVO.setPYTB_CD( payDataVO.getStrPYTB_CD( )[i] );
				payDataVO.setDPST_NM( payDataVO.getStrDPST_NM( )[i] );
				payDataVO.setBANK_NM( payDataVO.getStrBANK_NM( )[i] );
				payDataVO.setRSRG_NO( payDataVO.getStrRSRG_NO( )[i] );
				payDataVO.setPJT_NM( payDataVO.getStrPJT_NM( )[i] );
				String abdocu_t_no = acG20ExGwDAO.insertAbdocu_T_PayData( payDataVO );
				payDataVO.setAbdocu_t_no( abdocu_t_no );
				acG20ExGwDAO.insertPayData( payDataVO );
			}
		}
		result = 1;
		Abdocu_T abdocu_T_Tmp = new Abdocu_T( );
		abdocu_T_Tmp.setAbdocu_b_no( payDataVO.getAbdocu_b_no( ) );
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T_Tmp );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T_Tmp.getAbdocu_b_no( ) );
		map.put( "abdocu_B", abdocu_B );
		map.put( "result", result );
		return map;
	}

	/** 
	 * insertPurcReq parkjm 2018. 3. 15.
	 * @param abdocu_H, paramMap
	 * @return
	 */
	@Override
	public Map<String, Object> insertPurcReq(Abdocu_H abdocu_H, HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		Object result = null;
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			String consDocSeq = acG20Ex2GwDAO.insertConsDoc(paramMap);
			paramMap.put("consDocSeq", consDocSeq);
			Object purcReqId = acG20ExGwDAO.insertPurcReq(paramMap);
			paramMap.put("purcReqId", purcReqId);
			map.put("consDocSeq", consDocSeq);
			map.put("purcReqId", purcReqId.toString());
			if(abdocu_H.getAbdocu_no() != null && abdocu_H.getAbdocu_no().equals("0")) {
				acG20Ex2GwDAO.updateConsDoc(paramMap);
				String consSeq = acG20Ex2GwDAO.insertConsHead(paramMap);
				paramMap.put("abdocuNo", consSeq);
				Object purcReqHId = acG20ExGwDAO.insertPurcReqH(paramMap);
				map.put("result", consSeq);
				map.put("purcReqHId", purcReqHId.toString());
			}
		}else{																							// G20 품의서
			Object purcReqId = acG20ExGwDAO.insertPurcReq(paramMap);
			paramMap.put("purcReqId", purcReqId);
			map.put("purcReqId", purcReqId.toString());
			
			if(abdocu_H.getAbdocu_no() != null && abdocu_H.getAbdocu_no().equals("0")) {
				result = acG20ExGwDAO.insertAbdocu_H(abdocu_H);
				paramMap.put("abdocuNo", result);
				Object purcReqHId = acG20ExGwDAO.insertPurcReqH(paramMap);
				map.put("result", result.toString());
				map.put("purcReqHId", purcReqHId.toString());
			}
		}
		
		return map;
	}

	/** 
	 * updatePurcReq parkjm 2018. 3. 15.
	 * @param abdocu_H, paramMap
	 * @return
	 */
	@Override
	public Map<String, Object> updatePurcReq(Abdocu_H abdocu_H, HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		
		acG20ExGwDAO.updatePurcReq(paramMap);
		
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			if(abdocu_H.getAbdocu_no() != null && abdocu_H.getAbdocu_no().equals("0")) {
				acG20Ex2GwDAO.updateConsDoc(paramMap);
				String consSeq = acG20Ex2GwDAO.insertConsHead(paramMap);
				paramMap.put("abdocuNo", consSeq);
				Object purcReqHId = acG20ExGwDAO.insertPurcReqH(paramMap);
				map.put("purcReqHId", purcReqHId.toString());
			}
			else if(abdocu_H.getAbdocu_no() != null && !"".equals(abdocu_H.getAbdocu_no())) {
				acG20Ex2GwDAO.updateConsDoc(paramMap);
				acG20Ex2GwDAO.updateConsHead(paramMap);
				paramMap.put("abdocuNo", abdocu_H.getAbdocu_no());
				acG20ExGwDAO.updatePurcReqH(paramMap);
			}
		}else{																							// G20 품의서
			if(abdocu_H.getAbdocu_no() != null && abdocu_H.getAbdocu_no().equals("0")) {
				Object result = acG20ExGwDAO.insertAbdocu_H(abdocu_H);
				paramMap.put("abdocuNo", result);
				Object purcReqHId = acG20ExGwDAO.insertPurcReqH(paramMap);
				paramMap.put("purcReqHId", purcReqHId);
			}
			else if(abdocu_H.getAbdocu_no() != null && !"".equals(abdocu_H.getAbdocu_no())) {
				acG20ExGwDAO.updateAbdocu_H(abdocu_H);
				paramMap.put("abdocuNo", abdocu_H.getAbdocu_no());
				acG20ExGwDAO.updatePurcReqH(paramMap);
			}
		}
		map.put("consDocSeq", paramMap.get("consDocSeq"));
		map.put("purcReqId", paramMap.get("purcReqId"));
		map.put("result", paramMap.get("abdocuNo"));
		map.put("purcReqHId", paramMap.get("purcReqHId"));
		return map;
	}

	/** 
	 * getPurcReq parkjm 2018. 3. 15.
	 * @param paramMap
	 * @return
	 */
	@Override
	public Map<String, Object> getPurcReq(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		map.put("purcReqInfo", acG20ExGwDAO.getPurcReq(paramMap));
		map.put("purcReqHList", acG20ExGwDAO.getPurcReqH(paramMap));
		map.put("purcReqAttachFileList", commFileService.getAttachFileList(paramMap));
		map.put("purcReqAttachFileList2", acG20ExGwDAO.getAttachFileList(paramMap));
		return map;
	}
	
	/**
	 * parkjm 2018. 3. 20.
	 * insertPurcReqB
	 **/
	@Override
	public Map<String, Object> insertPurcReqB ( Abdocu_B abdocu_B , HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.insertAbdocu_B( abdocu_B );
		paramMap.put("abdocuBNo", result.toString());
		Object purcReqBId = acG20ExGwDAO.insertPurcReqB(paramMap);
		map.put( "result", result.toString( ) );
		map.put( "purcReqBId", purcReqBId.toString( ) );
		return map;
	}

	/**
	 * parkjm 2018. 3. 20.
	 * updatePurcReqB
	 **/
	@Override
	public Map<String, Object> updatePurcReqB ( Abdocu_B abdocu_B , HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.updateAbdocu_B( abdocu_B );
		paramMap.put("abdocuBNo", abdocu_B.getAbdocu_b_no( ));
		acG20ExGwDAO.updatePurcReqB(paramMap);
		map.put( "result", abdocu_B.getAbdocu_b_no( ) );
		map.put( "purcReqBId", abdocu_B.getPurc_req_b_id() );
		return map;
	}
	
	/**
	 * 
	 * parkjm 2018. 3. 20.
	 * delPurcReqH
	 *
	 */
	@Override
	public Integer delPurcReqH ( Abdocu_H abdocu_H ) throws Exception {
		//        Map<String, Object> map = new HashMap<String, Object>();
		Abdocu_B abdocu_b = new Abdocu_B( );
		abdocu_b.setAbdocu_no( abdocu_H.getAbdocu_no( ) );
		abdocu_b.setPurc_req_h_id( abdocu_H.getPurc_req_h_id() );
		int result = acG20ExGwDAO.deleteAbdocu_B( abdocu_b );
		acG20ExGwDAO.delPurcReqB( abdocu_b );
		String itemsUseYn = CommonCodeUtil.getCodeName( "G20301", "001" );
		if ( itemsUseYn.equals( "Y" ) ) {
			deleleItems( abdocu_H );
		}
		//        map.put("result", result);
		return result;
	}
	
	/**
	 * 
	 * parkjm 2018. 3. 20.
	 * delPurcReqH
	 *
	 */
	@Override
	public Integer delPurcReq_H ( Abdocu_H abdocu_H ) throws Exception {
		int result = delPurcReqH(abdocu_H);
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			result = acG20Ex2GwDAO.delAbdocu_H( abdocu_H );
		}
		result = acG20ExGwDAO.delPurcReq_H( abdocu_H );
		return result;
	}
	
	/**
	 * parkjm 2018. 3. 20.
	 * delPurcReqB
	 **/
	@Override
	public Map<String, Object> delPurcReqB ( Abdocu_B abdocu_B ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		acG20ExGwDAO.deleteAbdocu_B( abdocu_B );
		acG20ExGwDAO.delPurcReqB( abdocu_B );
		map.put( "result", "delete" );
		return map;
	}

	/**
	 * 
	 * parkjm 2018. 3. 20.
	 * delPurcReqT
	 *
	 */
	@Override
	public Map<String, Object> delPurcReqT ( Abdocu_T abdocu_T ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		int result = acG20ExGwDAO.deleteAbdocu_T( abdocu_T );
		acG20ExGwDAO.delPurcReqT( abdocu_T );
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		acG20ExGwDAO.updatePurcReqB_ApplyAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T.getAbdocu_b_no( ) );
		abdocu_B.setNext_am(acG20ExGwDAO.getPurcReqBNextAm(abdocu_T));
		map.put( "abdocu_B", abdocu_B );
		map.put( "result", result );
		return map;
	}
	
	/**
	 * parkjm 2018. 3. 20.
	 * getPurcReqB
	 **/
	@Override
	public List<Abdocu_B> getPurcReqB ( Abdocu_H abdocu_H ) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcReqB( abdocu_H );
		}else{
			return acG20ExGwDAO.getPurcReqB( abdocu_H );
		}
	}
	
	/**
	 * parkjm 2018. 3. 20.
	 * insertPurcReqT
	 **/
	@Override
	public Map<String, Object> insertPurcReqT ( Abdocu_T abdocu_T, HashMap<String, Object> paramMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.insertAbdocu_T( abdocu_T );
		map.put( "result", result.toString( ) );
		abdocu_T.setAbdocu_t_no( result.toString( ) );
		paramMap.put("abdocuTNo", result.toString());
		Object purcReqTId = acG20ExGwDAO.insertPurcReqT(paramMap);
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		acG20ExGwDAO.updatePurcReqB_ApplyAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T.getAbdocu_b_no( ) );
		abdocu_B.setNext_am(acG20ExGwDAO.getPurcReqBNextAm(abdocu_T));
		map.put( "abdocu_B", abdocu_B );
		return map;
	}

	/**
	 * parkjm 2018. 3. 20.
	 * updatePurcReqT
	 **/
	@Override
	public Map<String, Object> updatePurcReqT ( Abdocu_T abdocu_T, HashMap<String, Object> paramMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Object result = acG20ExGwDAO.updateAbdocu_T( abdocu_T );
		map.put( "result", abdocu_T.getAbdocu_t_no( ) );
		paramMap.put("abdocuTNo", abdocu_T.getAbdocu_t_no( ));
		acG20ExGwDAO.updatePurcReqT(paramMap);
		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
		acG20ExGwDAO.updatePurcReqB_ApplyAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getAbdocuB_One( abdocu_T.getAbdocu_b_no( ) );
		abdocu_B.setNext_am(acG20ExGwDAO.getPurcReqBNextAm(abdocu_T));
		map.put( "abdocu_B", abdocu_B );
		map.put( "purcReqTId", abdocu_T.getPurc_req_t_id() );
		return map;
	}
	
	/**
	 * parkjm 2018. 3. 20.
	 * getPurcReqT
	 **/
	@Override
	public List<Abdocu_T> getPurcReqT ( Abdocu_B abdocu_B ) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			return acG20Ex2GwDAO.getPurcReqT( abdocu_B );
		}else{
			return acG20ExGwDAO.getPurcReqT( abdocu_B );
		}
	}

	/**
	 * parkjm 2018. 3. 22.
	 * setPurcReqAttach
	 **/
	@Override
	public Map<String, Object> setPurcReqAttach(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("purcReqAttachId", acG20ExGwDAO.setPurcReqAttach(paramMap));
		return map;
	}
	
	/**
	 * parkjm 2018. 3. 22.
	 * setPurcReqAttach
	 **/
	@Override
	public Map<String, Object> setPurcContAttach(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("purcContAttachId", acG20ExGwDAO.setPurcContAttach(paramMap));
		return map;
	}

	/**
	 * parkjm 2018. 3. 23.
	 * makePurcReqNo
	 **/
	@Override
	public Map<String, Object> makePurcReqNo(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		acG20ExGwDAO.makePurcReqNo(paramMap);
		map.put("purcReqInfo", acG20ExGwDAO.getPurcReq(paramMap));
		map.put("purcReqHBList", acG20ExGwDAO.getPurcReqHBList(paramMap));
		paramMap.put("purcTrType", "001");
		map.put("purcReqTList1", acG20ExGwDAO.getPurcReqTList(paramMap));
		paramMap.put("purcTrType", "002");
		map.put("purcReqTList2", acG20ExGwDAO.getPurcReqTList(paramMap));
		return map;
	}

	@Override
	public void updatePurcReqState(Map<String, Object> paramMap) throws Exception {
		if(paramMap.get("purcReqIdArr") != null && !"".equals(paramMap.get("purcReqIdArr"))) {
			String purcReqIdArr = String.valueOf(paramMap.get("purcReqIdArr"));
			String[] arr = purcReqIdArr.split(",");
			String reqState = String.valueOf(paramMap.get("reqState"));
			for (String purcReqId : arr) {
				paramMap.put("purcReqId", purcReqId);
				paramMap.put("reqState", reqState);
				updatePurcReqStateProcess(paramMap);
			}
		}else {
			updatePurcReqStateProcess(paramMap);
		}
	}
	
	@SuppressWarnings("unchecked")
	private void updatePurcReqStateProcess(Map<String, Object> paramMap) throws Exception  {
		String reqState = String.valueOf(paramMap.get("reqState"));
		String purcReqId = String.valueOf(paramMap.get("purcReqId"));
		if(reqState.equals("005")) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			if("G20_2.0".equals(getErpType())){
				Map<String, Object> resultMap = (Map<String, Object>)acG20ExGwDAO.getPurcReq((HashMap<String, Object>)paramMap);
				paramMap.put("confferReturn", "Y");
				paramMap.put("empName", loginVO.getName());
				paramMap.put("empSeq", loginVO.getUniqId());
				paramMap.put("consDocSeq", resultMap.get("consDocSeq"));
				acG20Ex2GwDAO.updateConsConfferStatus(paramMap);
			}else{
				List<String> abdocuBNoList = acG20ExGwDAO.selectAbdocuBNoList(purcReqId);
				for (String abdocu_b_no : abdocuBNoList) {
					HashMap<String, String> paraMap = new HashMap<String, String>();
					paraMap.put( "ABDOCU_B_NO", abdocu_b_no );
					paraMap.put( "isAllDocView", "1" );
					paraMap.put( "C_DIUSERKEY", loginVO.getUniqId( ) );
					paraMap.put( "OrgnztId", loginVO.getOrgnztId( ) );
					paraMap.put( "deptSeq", loginVO.getOrgnztId( ) );
					paraMap.put( "empSeq", loginVO.getUniqId( ) );
					paraMap.put( "langCode", loginVO.getLangCode( ) );
					//	    paraMap.put("CO_CD", getCO_CD());
					String getConferType = CommonCodeUtil.getCodeName( "G20301", "GET_CONFER_TYPE" );
					paraMap.put( "getConferType", getConferType );
					
					getReturnConferBudgetPurcReq( paraMap );
				}
			}
		}else if(reqState.equals("004")) {
			if("G20_2.0".equals(getErpType())){
				Map<String, Object> resultMap = (Map<String, Object>)acG20ExGwDAO.getPurcReq((HashMap<String, Object>)paramMap);
				String contTypeCodeId = String.valueOf(resultMap.get("contTypeCodeId"));
				if(contTypeCodeId != null && "001".equals(contTypeCodeId)) {
					paramMap.put("reqState", "100");
				}
			}
		}else if(reqState.equals("179")) {
			if("G20_2.0".equals(getErpType())){
				Map<String, Object> resultMap = (Map<String, Object>)acG20ExGwDAO.getPurcReq((HashMap<String, Object>)paramMap);
				String contTypeCodeId = String.valueOf(resultMap.get("contTypeCodeId"));
				if(contTypeCodeId != null && "001".equals(contTypeCodeId)) {
					paramMap.put("reqState", "004");
				}
			}
		}
		acG20ExGwDAO.updatePurcReqState(paramMap);
		paramMap.put("result", "OK");
	}

	@Resource(name = "CommFileDAO")
	CommFileDAO commFileDAO;
	
	@Override
	public Map<String, Object> excelUploadSave(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 파일 저장 경로
		String path = "tpf_temp";
       	String subPathYn = "N";
       	String filePath = CommFileUtil.getFilePath(commFileDAO, path, subPathYn);
       	// 파일 저장 경로
	           	
       	MultipartFile mFile = multi.getFile("fileNm");
       	if (mFile == null || mFile.isEmpty()) {
       		throw new RuntimeException("엑셀파일을 선택 해 주세요.");
       	}
       	
       	String fileName = mFile.getOriginalFilename();
       	String ext = fileName.substring(fileName.lastIndexOf(".")+1);
       	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
       	String tempNm = sdf.format(new Date());
       	tempNm = tempNm + (long)(Math.random() * Math.pow(10, 10)) + "." + ext;
       	
       	// 임시파일저장
       	CommFileUtil.makeDir(filePath);	           	
       	File saveFile = new File(filePath + tempNm);
       	CommFileUtil.fileWrite(mFile, saveFile);
       	// 임시파일저장
       	
       	List<Map<String, String>> excelContents = excelToList(saveFile, map);
       	
       	// 임시파일삭제
       	saveFile.delete();
       	// 임시파일삭제
       	
       	// 엑셀데이터 업로드
       	if(excelContents != null) {
       		for (Map<String, String> excelContent : excelContents) {
       			String abdocu_t_no = String.valueOf(acG20ExGwDAO.excelUploadSaveAbdocuT(excelContent));
       			excelContent.put("abdocu_t_no", abdocu_t_no);
       			acG20ExGwDAO.excelUploadSavePurcReqT(excelContent);
       		}
       		Abdocu_T abdocu_T = new Abdocu_T();
       		String abdocu_b_no = String.valueOf(map.get("abdocuBNo"));
       		String purc_req_b_id = String.valueOf(map.get("purc_req_b_id"));
       		abdocu_T.setAbdocu_b_no(abdocu_b_no);
       		abdocu_T.setPurc_req_b_id(purc_req_b_id);
       		acG20ExGwDAO.updateAbdocuB_ApplyAm( abdocu_T );
       		acG20ExGwDAO.updatePurcReqB_ApplyAm( abdocu_T );
       		String applyAm = String.valueOf(acG20ExGwDAO.selectAbdocuB_ApplyAm(abdocu_b_no));
       		resultMap.put("applyAm", applyAm);
       	}
       	// 엑셀데이터 업로드
       	
       	resultMap.put("result", map.get("result"));
       	resultMap.put("message", map.get("message"));
		return resultMap;
	}
	
	private List<Map<String , String>> excelToList(File saveFile, Map<String, Object> map) throws Exception {
		ExcelReadOption excelReadOption = new ExcelReadOption();
		excelReadOption.setFilePath(saveFile.getAbsolutePath());
		excelReadOption.setStartRow(2);		
		String purc_req_type = String.valueOf(map.get("purc_req_type"));
		String purc_tr_type = String.valueOf(map.get("purc_tr_type"));
		List<String> colums = null;
		if("1".equals(purc_req_type) || (!"2".equals(purc_req_type) && "002".equals(purc_tr_type))) {
//			colums = stringToList("item_type", "item_nm", "item_cnt", "standard", "item_am", "unit_am", "sup_am", "vat_am", "rmk_dc");
//			excelReadOption.setOutputColumns("A", "B", "C", "D", "E", "F", "G", "H", "I");
			colums = stringToList("item_type", "item_nm", "item_cnt", "standard", "item_am", "rmk_dc");
			excelReadOption.setOutputColumns("A", "B", "C", "D", "E", "F");
		}else if("2".equals(purc_req_type)) {
//			colums = stringToList("pps_id_no", "tr_nm", "reg_nb", "ceo_nm", "item_type", "item_nm", "item_cnt", "standard", "item_am", "unit_am", "sup_am", "vat_am", "pps_fees", "rmk_dc");
//			excelReadOption.setOutputColumns("A", "B", "C", "D", "E", "F", "G", "H", "I","J","K","L","M","N");
			colums = stringToList("pps_id_no", "tr_nm", "reg_nb", "ceo_nm", "item_type", "item_nm", "item_cnt", "standard", "item_am", "rmk_dc");
			excelReadOption.setOutputColumns("A", "B", "C", "D", "E", "F", "G", "H", "I","J");
		}else if("3".equals(purc_req_type) || "4".equals(purc_req_type)) {
//			colums = stringToList("item_nm", "contents", "start_date", "end_date", "unit_am", "sup_am", "vat_am", "rmk_dc");
//			excelReadOption.setOutputColumns("A", "B", "C", "D", "E", "F", "G", "H");
			colums = stringToList("item_nm", "contents", "unit_am", "rmk_dc");
			excelReadOption.setOutputColumns("A", "B", "C", "D");
		}else {
			colums = new ArrayList<String>();
		}
		
		List<Map<String, String>> excelContents = ExcelRead.read(excelReadOption);
		
		for (Map<String, String> article: excelContents) {
			if(colums.size() == excelReadOption.getOutputColumns().size()) {
				List<String> tempColums = excelReadOption.getOutputColumns();
				int i = 0;
				for(String colum : colums) {
					if("item_cnt".equals(colum) || "item_am".equals(colum) || "unit_am".equals(colum) || "sup_am".equals(colum) || "vat_am".equals(colum) || "pps_fees".equals(colum)) {
						try {
							String am = article.get(tempColums.get(i)).replaceAll(",", "");
							Long.parseLong(am);
							article.put(colum, am);
							if("item_am".equals(colum)) {
								String taxType = String.valueOf(map.get("taxType"));
								long itemCnt = Long.parseLong(article.get("item_cnt"));
								long itemAm = Long.parseLong(am);
								long unitAm = itemCnt * itemAm;
								long supAm = unitAm;
								long vatAm = 0;
								if("1".equals(taxType)) {
									supAm = Math.round((Math.round(unitAm / 1.1 * 10)) / 10);
									vatAm = unitAm - supAm;
								}
								if("2".equals(purc_req_type)) {
									long ppsFees = Math.round(Math.floor(unitAm * 0.0054));
									unitAm = unitAm + ppsFees;
									article.put("pps_fees", String.valueOf(ppsFees));
								}
								article.put("unit_am", String.valueOf(unitAm));
								article.put("sup_am", String.valueOf(supAm));
								article.put("vat_am", String.valueOf(vatAm));
							}else if( "unit_am".equals(colum)) {
								String taxType = String.valueOf(map.get("taxType"));
								long unitAm = Long.parseLong(am);
								long supAm = unitAm;
								long vatAm = 0;
								if("1".equals(taxType)) {
									supAm = Math.round((Math.round(unitAm / 1.1 * 10)) / 10);
									vatAm = unitAm - supAm;
								}
								article.put("sup_am", String.valueOf(supAm));
								article.put("vat_am", String.valueOf(vatAm));
							}
						} catch (Exception e) {
							e.printStackTrace();
							map.put("result", "Failed");
							map.put("message", "수량, 단가, 금액, 공급가액, 부가세는 숫자만 입력가능합니다.");
							return null;
						}
					}else if("start_date".equals(colum) || "end_date".equals(colum)) {
						try {
							String tempDate = article.get(tempColums.get(i)).replaceAll("-", "");
							Integer.parseInt(tempDate);
							DateFormat df = new SimpleDateFormat("yyyyMMdd");
							Date date = df.parse(tempDate);
							String modDate = df.format(date);
							article.put(colum, modDate);
						} catch (Exception e) {
							e.printStackTrace();
							map.put("result", "Failed");
							map.put("message", "날짜형식이 올바른지 확인해 주세요.\nex) 2018-01-01");
							return null;
						}
					}else {
						article.put(colum, article.get(tempColums.get(i)));
					}
					i++;
				}
			}
			
			String item_type = article.get("item_type");
			if(item_type != null) {
				if("유형자산".equals(item_type)) {
					article.put("item_type_code_id", "001");
				}else if("무형자산".equals(item_type)) {
						article.put("item_type_code_id", "002");
				}else if("소모품".equals(item_type)) {
					article.put("item_type_code_id", "003");
				}else {
					map.put("result", "Failed");
					map.put("message", "품목구분은 유형자산, 무형자산, 소모품 3가지만 입력가능합니다.");
					return null;
				}
			}
			
			article.put("empSeq", String.valueOf(map.get("empSeq")));
			article.put("empIp", String.valueOf(map.get("empIp")));
			article.put("abdocu_no", String.valueOf(map.get("abdocuNo")));
			article.put("abdocu_b_no", String.valueOf(map.get("abdocuBNo")));
			article.put("docu_mode", String.valueOf(map.get("docu_mode")));
			article.put("erp_co_cd", String.valueOf(map.get("erp_co_cd")));
			article.put("tr_fg", String.valueOf(map.get("tr_fg")));
			article.put("tr_fg_nm", String.valueOf(map.get("tr_fg_nm")));
			article.put("purc_req_b_id", String.valueOf(map.get("purc_req_b_id")));
			article.put("purc_tr_type", String.valueOf(map.get("purc_tr_type")));
			System.out.println(article);
		}
		map.put("result", "Success");
		map.put("message", "모든 데이터가 업로드 되었습니다.");
		return excelContents;
	}
	
	private List<String> stringToList(String ... strings){
		List<String> temp = new ArrayList<String>();
        for(String str : strings) {
        	temp.add(str);
        }
		return temp;
	}

	@Override
	public Object purcReqListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcReqListData(map);
	}

	@Override
	public Object purcReqListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcReqListDataTotal(map);
	}
	
	@Override
	public Object purcContListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContListData(map);
	}
	
	@Override
	public Object purcContListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContListDataTotal(map);
	}
	
	/**
	 * doban7 2016. 9. 29.
	 * getReturnConferBudget
	 **/
	public Map<String, Object> getReturnConferBudgetPurcReq ( HashMap<String, String> paraMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		int spendCnt = acG20ExGwDAO.getUseSpendStandingCnt( paraMap );
		if ( spendCnt > 0 ) {
			map.put( "result", "ING" );
			return map;
		}
		List<HashMap<String, String>> selectList = getReferConferPurcReq( paraMap );
		HashMap<String, String> returnBudget = selectList.get( 0 ); /* 예산환원 할 예산 */
		Long open_am = Long.parseLong( getStringValue( returnBudget, "OPEN_AM" ).replace( ",", "" ).trim( ) );
		Long apply_am = Long.parseLong( getStringValue( returnBudget, "APPLY_AM" ).replace( ",", "" ).trim( ) );
		String abdocu_no = getStringValue( returnBudget, "ABDOCU_NO" );
		Long returnOpen_am = open_am - apply_am;
		returnOpen_am = returnOpen_am * -1;
		Abdocu_B abdocu_B = new Abdocu_B( );
		abdocu_B.setAbdocu_b_no( paraMap.get( "ABDOCU_B_NO" ) );
		abdocu_B.setApply_am( returnOpen_am + "" );
		/* 품의금액 - 잔액 = 업데이트 금액 */
		//acG20ExGwDAO.updateReturnConferBudget(abdocu_B); 
		abdocu_B = new Abdocu_B( );
		abdocu_B.setApply_am( returnOpen_am + "" );
		abdocu_B.setConfer_return( paraMap.get( "ABDOCU_B_NO" ) );
		abdocu_B.setAbdocu_no( abdocu_no );
		abdocu_B.setErp_co_cd( "0" );
		acG20ExGwDAO.insertAbdocu_B( abdocu_B );
		// 환원처리를 row insert 가 아닌  환원여부 체크로 수정 필요할듯 함.
		map.put( "result", "OK" );
		return map;
	}
	
	/**
	 * doban7 2016. 9. 28.
	 * getReferConfer
	 **/
	public List<HashMap<String, String>> getReferConferPurcReq ( HashMap<String, String> paraMap ) throws Exception {
		return acG20ExGwDAO.getReferConferPurcReq( paraMap );
	}

	@Override
	public String makeContInfo(Map<String, String> paraMap) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		String purcContId = String.valueOf(acG20ExGwDAO.makePurcCont(paraMap));
		map.put("purcContId", purcContId);
		
		paraMap.put("purcContId", purcContId);
		acG20ExGwDAO.makePurcContB(paraMap);
		acG20ExGwDAO.makePurcContT(paraMap);
		acG20ExGwDAO.delMakePurcContB(map);
		
		List<Abdocu_B> abdocu_B_list = acG20ExGwDAO.getPurcContB(map);
		Abdocu_T abdocu_T = new Abdocu_T();
		for (Abdocu_B abdocu_B : abdocu_B_list) {
			abdocu_T.setPurc_cont_b_id(abdocu_B.getPurc_cont_b_id());
			acG20ExGwDAO.updatePurcContB_ApplyAm( abdocu_T );
			acG20ExGwDAO.updatePurcContB_OpenAm( abdocu_T );
		}
		abdocu_T.setPurc_cont_id(purcContId);
		acG20ExGwDAO.updatePurcCont_contAm( abdocu_T );
		acG20ExGwDAO.updatePurcCont_basicAm( abdocu_T );
		return purcContId;
	}

	@Override
	public Object updatePurcCont(Map<String, String> paraMap) throws Exception {
		acG20ExGwDAO.updatePurcReqRequester(paraMap);
		return acG20ExGwDAO.updatePurcCont(paraMap);
	}
	
	/**
	 * parkjm 2018. 4. 3.
	 * getPurcContB
	 **/
	@Override
	public List<Abdocu_B> getPurcContB ( Map<String, Object> map ) throws Exception {
		return acG20ExGwDAO.getPurcContB( map );
	}
	
	/** 
	 * getPurcCont parkjm 2018. 4. 3.
	 * @param paramMap
	 * @return
	 */
	@Override
	public Map<String, Object> getPurcCont(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		map.put("purcContInfo", acG20ExGwDAO.purcContInfo(paramMap));
		map.put("purcReqInfo", acG20ExGwDAO.getPurcReq(paramMap));
//		map.put("purcReqHList", acG20ExGwDAO.getPurcReqH(paramMap));
		map.put("purcReqHList", acG20Ex2GwDAO.getPurcContH(paramMap));
		map.put("purcReqAttachFileList", commFileService.getAttachFileList(paramMap));
		map.put("purcReqAttachFileList2", acG20ExGwDAO.getAttachFileList(paramMap));
		
		paramMap.put("targetTableName", "tpf_purc_cont");
		paramMap.put("targetId", paramMap.get("purcContId"));
		map.put("purcReqAttachFileListCont", commFileService.getAttachFileList(paramMap));
		map.put("purcReqAttachFileListCont2", acG20ExGwDAO.getAttachFileList2(paramMap));
		map.put("purcContAddTr", acG20ExGwDAO.getPurcContAddTr(paramMap));

		if("Y".equals(paramMap.get("trDetail"))){
			ConnectionVO conVo = GetConnection( );
			LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
			Map<String, Object> purcContInfo = (Map<String, Object>)map.get("purcContInfo");
			
			HashMap<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("CO_CD", loginVO.getErpCoCd());
			paraMap.put("TR_CD", String.valueOf(purcContInfo.get("trCd")));
			paraMap.put("trType", "");
			paraMap.put("trName", "");
			paraMap.put("trDetailType", "");
			
			List<HashMap<String, String>> selectList = null;
			selectList = acG20CodeErpDAO.getErpTradeList(paraMap, conVo);
			if(selectList != null && selectList.size() == 1) {
				HashMap<String, String> trDetail = selectList.get(0);
				purcContInfo.put("trDetail", trDetail);
			}
			List<Map<String, Object>> purcContAddTr = (List<Map<String, Object>>)map.get("purcContAddTr");
			for (Map<String, Object> tempTr : purcContAddTr) {
				paraMap.put("TR_CD", String.valueOf(tempTr.get("trCd")));
				List<HashMap<String, String>> selectList2 = null;
				selectList2 = acG20CodeErpDAO.getErpTradeList(paraMap, conVo);
				if(selectList2 != null && selectList2.size() == 1) {
					HashMap<String, String> trDetail = selectList2.get(0);
					tempTr.put("trDetail", trDetail);
				}
			}
		}
		return map;
	}
	
	/**
	 * parkjm 2018. 4. 4.
	 * getPurcContT
	 **/
	@Override
	public List<Abdocu_T> getPurcContT ( Abdocu_B abdocu_B ) throws Exception {
		return acG20ExGwDAO.getPurcContT( abdocu_B );
	}
	
	/**
	 * parkjm 2018. 3. 20.
	 * updatePurcContT
	 **/
	@Override
	public Map<String, Object> updatePurcContT ( Abdocu_T abdocu_T, HashMap<String, Object> paramMap ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Long leftAm = Long.parseLong(String.valueOf(acG20ExGwDAO.getPurcReqLeftAm(abdocu_T)));
		Long unitAm = Long.parseLong(abdocu_T.getUnit_am());
		if(leftAm - unitAm < 0) {
			map.put("result", "Excess");
			map.put("resultMsg", "요청액 초과");
			return map;
		}
		
		Object result = acG20ExGwDAO.updatePurcContT( abdocu_T );
		map.put("result", abdocu_T.getPurc_cont_t_id());
		acG20ExGwDAO.updatePurcContB_ApplyAm( abdocu_T );
		acG20ExGwDAO.updatePurcCont_contAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getpurcContB_One( abdocu_T.getPurc_cont_b_id() );
		paramMap.put("purcContId", paramMap.get("purc_cont_id"));
		map.put("purcContInfo", acG20ExGwDAO.purcContInfo(paramMap));
		map.put( "abdocu_B", abdocu_B );
		map.put( "purcReqTId", abdocu_T.getPurc_req_t_id() );
		return map;
	}
	
	/**
	 * 
	 * parkjm 2018. 4. 4.
	 * delPurcContT
	 *
	 */
	@Override
	public Map<String, Object> delPurcContT ( Abdocu_T abdocu_T ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("purcContId", abdocu_T.getPurc_cont_id());
		
		int result = acG20ExGwDAO.delPurcContT( abdocu_T );
		acG20ExGwDAO.updatePurcContB_ApplyAm( abdocu_T );
		acG20ExGwDAO.updatePurcCont_contAm( abdocu_T );
		acG20ExGwDAO.delMakePurcContB(paramMap);
		
		Abdocu_B abdocu_B = acG20ExGwDAO.getpurcContB_One( abdocu_T.getPurc_cont_b_id() );
		map.put("purcContInfo", acG20ExGwDAO.purcContInfo(paramMap));
		map.put( "abdocu_B", abdocu_B );
		map.put( "result", result );
		return map;
	}
	
	public Object getPurcReqLeftAm(Abdocu_T abdocu_T) throws Exception {
		return acG20ExGwDAO.getPurcReqLeftAm(abdocu_T);
	}

	@Override
	public Object checkPurcContComplete(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.checkPurcContComplete(map);
	}
	
	@Override
	public Object checkPurcContApproval(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.checkPurcContApproval(map);
	}

	@Override
	public Object purcContRepApprovalComplete(Map<String, Object> map) throws Exception {
		String result = "Failed";
		if(acG20ExGwDAO.checkPurcContractedComplete(map) < 1 || "2".equals(map.get("purcReqType"))) {
			map.put("reqDocState", "007");
		}
		acG20ExGwDAO.resetAbdocuT(map);
		acG20ExGwDAO.updateAbdocuT(map);
		acG20ExGwDAO.updateAbdocuB_ApplyAm_purc(map);
		acG20ExGwDAO.updateReqDocSts(map);
		result = "Success";
		return result;
	}
	
	@Override
	public Object updateContDocSts(Map<String, Object> map) throws Exception {
		String result = "Failed";
		acG20ExGwDAO.updateContDocSts(map);
		result = "Success";
		return result;
	}
	
	@Override
	public Object purcContracted(Map<String, Object> map) throws Exception {
		String result = "Failed";
		acG20ExGwDAO.updateContDocSts(map);
		if("006".equals(acG20ExGwDAO.checkPurcReqState(map))) {
			if(acG20ExGwDAO.checkPurcContractedComplete(map) < 1) {
				map.put("reqDocState", "007");
				acG20ExGwDAO.updateReqDocSts(map);
			}
		}
		result = "Success";
		return result;
	}

	@Override
	public String makeFileKey(HashMap<String, Object> requestMap) throws Exception {
		String fileKey = String.valueOf(requestMap.get("fileKey"));
		if(fileKey == null || "".equals(fileKey)){
			fileKey = "Y" + java.util.UUID.randomUUID().toString();
		}
		List<Map<String, Object>> tempSaveFileList = acG20ExGwDAO.tempSaveFileList(requestMap);
		for (Map<String, Object> fileMap : tempSaveFileList) {
			String filePath = String.valueOf(fileMap.get("filePath"));
			String fileName = String.valueOf(fileMap.get("fileName"));
			String realFileName = String.valueOf(fileMap.get("realFileName"));
			String fileExtension = String.valueOf(fileMap.get("fileExtension"));
			String tempPath = CommFileUtil.getFilePath(commFileDAO, "uploadTemp", "N");
			
			FileInputStream fis = new FileInputStream(filePath + fileName + "." + fileExtension);
			CommFileUtil.makeDir(tempPath + fileKey);
			FileOutputStream fos = new FileOutputStream(tempPath + fileKey + File.separator + realFileName + "." + fileExtension);
			
			FileChannel fcin = fis.getChannel();
			FileChannel fcout = fos.getChannel();
			
			long size = fcin.size();
			fcin.transferTo(0, size, fcout);
			
			fcout.close();
			fcin.close();
			
			fis.close();
			fos.close();
		}
		return fileKey;
	}

	@Override
	public String makeContInspInfo(HashMap<String, Object> requestMap) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
       	String today = sdf.format(new Date());
       	requestMap.put("today", today);
		String purcContInspId = acG20ExGwDAO.makeContInspInfo(requestMap);
		requestMap.put("purcContInspId", purcContInspId);
		acG20ExGwDAO.makeContInspTInfo(requestMap);
		acG20ExGwDAO.makeContInspTInfo2(requestMap);
		return purcContInspId;
	}

	@Override
	public Map<String, Object> getContInsp(HashMap<String, Object> requestMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("contInsp", acG20ExGwDAO.getContInsp(requestMap));
		requestMap.put("purcTrType", "001");
		resultMap.put("contInspT1", acG20ExGwDAO.getContInspT(requestMap));
		requestMap.put("purcTrType", "002");
		resultMap.put("contInspT2", acG20ExGwDAO.getContInspT(requestMap));
		requestMap.put("targetTableName", "tpf_purc_cont_insp");
		requestMap.put("targetId", requestMap.get("purcContInspId"));
		resultMap.put("contInspAttachFile", commFileService.getAttachFileList(requestMap));
		return resultMap;
	}

	@Override
	public int updatePurcContInsp(HashMap<String, Object> requestMap) throws Exception {
		return acG20ExGwDAO.updatePurcContInsp(requestMap);
	}
	
	@Override
	public int updatePurcContInspT(HashMap<String, Object> requestMap) throws Exception {
		return acG20ExGwDAO.updatePurcContInspT(requestMap);
	}
	
	@Override
	public void updatePurcReqContent(HashMap<String, Object> requestMap) throws Exception {
		acG20ExGwDAO.updatePurcReqContent(requestMap);
	}
	
	@Override
	public void makeContentsStr(HashMap<String, Object> requestMap) throws Exception {
		acG20ExGwDAO.makeContentsStr(requestMap);
	}
	
	@Override
	public Map<String, Object> getPurcContDocInfo(HashMap<String, Object> requestMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("purcContInfo", acG20ExGwDAO.purcContInfo(requestMap));
		resultMap.put("purcContBList", acG20ExGwDAO.getPurcContHBList(requestMap));
		requestMap.put("purcTrType", "001");
		resultMap.put("purcContTList1", acG20ExGwDAO.getPurcContTList(requestMap));
		requestMap.put("purcTrType", "002");
		resultMap.put("purcContTList2", acG20ExGwDAO.getPurcContTList(requestMap));
		return resultMap;
	}

	@Override
	public void updatePurcContContent(HashMap<String, Object> requestMap) throws Exception {
		acG20ExGwDAO.updatePurcContContent(requestMap);
	}

	@Override
	public Object purcContInspListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContInspListData(map);
	}

	@Override
	public Object purcContInspListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContInspListDataTotal(map);
	}

	@Override
	public Object inspTopBoxInit(HashMap<String, Object> requestMap) throws Exception {
		return acG20ExGwDAO.inspTopBoxInit(requestMap);
	}
	
	public HashMap<String, String> getFixAm2 (Map<String, String> paraMap ) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return acG20ExErpDAO.getFixAm2(conVo, paraMap);
	}
	
	public List<HashMap<String, String>> getFixAm (Map<String, String> paraMap ) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return acG20ExErpDAO.getFixAm(conVo, paraMap);
	}

	public List<HashMap<String, String>> getErpSalaryInfo(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		return acG20ExErpDAO.getErpSalaryInfo(conVo, paraMap);
	}

	@Override
	public Object updatePurcReqContAm(HashMap<String, Object> requestMap) throws Exception {
		acG20ExGwDAO.updatePurcReqContAm(requestMap);
		return acG20ExGwDAO.selectPurcReqContAm(requestMap);
	}

	@Override
	public void makeContInfoUpdate(Map<String, String> map) throws Exception {
		acG20ExGwDAO.makeContInfoUpdate(map);
	}
	
	@Override
	public void updatePurcContInspContent(HashMap<String, Object> requestMap) throws Exception {
		acG20ExGwDAO.updatePurcContInspContent(requestMap);
	}

	@Override
	public Map<String, Object> checkInspComplete(HashMap<String, Object> requestMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("contStep", acG20ExGwDAO.checkInspComplete(requestMap));
		requestMap.put("skip", 0);
		requestMap.put("pageSize", 1);
		resultMap.put("contInspList", acG20ExGwDAO.purcContInspListData(requestMap));
		return resultMap;
	}

	@Override
	public Object purcContModListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContModListData(map);
	}

	@Override
	public Object purcContModListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContModListDataTotal(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getContMod(HashMap<String, Object> requestMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> purcContInfo = (Map<String, Object>)acG20ExGwDAO.purcContInfo(requestMap);
		resultMap.put("purcContInfo", purcContInfo);
		resultMap.put("attachFileList", acG20ExGwDAO.getAttachFileList2(requestMap));
		resultMap.put("purcContAddTr", acG20ExGwDAO.getPurcContAddTr(requestMap));
		resultMap.put("consModifyEndBList", consDocMngDAO.consModifyEndBListSelect(purcContInfo));
		resultMap.put("consModifyEndTList", consDocMngDAO.consModifyEndTListSelect(purcContInfo));
		
		requestMap.put("purcContId", purcContInfo.get("purcContIdBefore"));
		
		resultMap.put("purcContInfoOrg", acG20ExGwDAO.purcContInfo(requestMap));
		resultMap.put("attachFileListOrg", acG20ExGwDAO.getAttachFileList2(requestMap));
		resultMap.put("purcContAddTrOrg", acG20ExGwDAO.getPurcContAddTr(requestMap));
		return resultMap;
	}

	@Override
	public String makeContModInfo(HashMap<String, Object> requestMap) throws Exception {
		String purcContModId = acG20ExGwDAO.makeContModInfo(requestMap);
		requestMap.put("purcContModId", purcContModId);
		// 변경 계약 예산 생성 시점 변경(문서 결재완료)
		acG20ExGwDAO.makeContModBInfo(requestMap);
		acG20ExGwDAO.makeContModTInfo(requestMap);
		acG20ExGwDAO.makeContModAttachFile(requestMap);
		acG20ExGwDAO.makeContModAddTr(requestMap);
		return purcContModId;
	}

	@Override
	public void updatePurcContMod(HashMap<String, Object> requestMap) throws Exception {
		acG20ExGwDAO.updatePurcContMod(requestMap);
	}
	
	@Override
	public Map<String, Object> updatePurcContModT(Abdocu_T abdocu_T, HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		/*Long leftAm = Long.parseLong(String.valueOf(acG20ExGwDAO.getPurcReqLeftAm(abdocu_T)));
		Long unitAm = Long.parseLong(abdocu_T.getUnit_am());
		if(leftAm - unitAm < 0) {
			map.put("result", "Excess");
			map.put("resultMsg", "요청액 초과");
			return map;
		}*/
		
		Object result = acG20ExGwDAO.updatePurcContT( abdocu_T );
		map.put("result", abdocu_T.getPurc_cont_t_id());
		acG20ExGwDAO.updatePurcContB_ApplyAm( abdocu_T );
		acG20ExGwDAO.updatePurcCont_contAm( abdocu_T );
		Abdocu_B abdocu_B = acG20ExGwDAO.getpurcContB_One( abdocu_T.getPurc_cont_b_id() );
		paramMap.put("purcContId", paramMap.get("purc_cont_id"));
		map.put("purcContInfo", acG20ExGwDAO.purcContInfo(paramMap));
		map.put( "abdocu_B", abdocu_B );
		map.put( "purcReqTId", abdocu_T.getPurc_req_t_id() );
		return map;
	}

	@Override
	public Object getApplyAm(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("applyAm", acG20ExGwDAO.getApplyAm(paramMap)); // 계약금액
		resultMap.put("aceptAm", acG20ExGwDAO.getAceptAm(paramMap)); // 계약집행금액
		return resultMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object completePurcContMod(HashMap<String, Object> paramMap) throws Exception {
//		acG20ExGwDAO.resetAbdocuTMod(paramMap); // 리셋
//		acG20ExGwDAO.updateAbdocuTMod(paramMap); // 채주정보
//		acG20ExGwDAO.updateAbdocuB_ApplyAm_purc(paramMap); // 예산정보
		Map<String, Object> purcContInfo = (Map<String, Object>)acG20ExGwDAO.purcContInfo(paramMap);
		consDocMngService.consDocModifyEnd(purcContInfo);
		acG20ExGwDAO.completePurcContMod(paramMap); // 상태업데이트
		acG20ExGwDAO.completePurcContModB(paramMap); // 상태업데이트
		acG20ExGwDAO.completePurcContModT(paramMap); // 상태업데이트
		return null;
	}
	
	@Override
	public Object requestPurcContMod(HashMap<String, Object> paramMap) throws Exception {
		acG20ExGwDAO.requestPurcContMod(paramMap); // 상태업데이트
		return null;
	}

	@Override
	public Object purcContPayListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContPayListData(map);
	}

	@Override
	public Object purcContPayListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcContPayListDataTotal(map);
	}
	
	@Override
	public Object getTemplateKey(HashMap<String, Object> paramMap) throws Exception {
		return acG20ExGwDAO.getTemplateKey(paramMap);
	}
	
	@Override
	public Object getPurcContPjtList(HashMap<String, Object> paramMap) throws Exception {
		return acG20ExGwDAO.getPurcContPjtList(paramMap);
	}
	
	@Override
	public Map<String, Object> insertPurcContPay ( Abdocu_H abdocu_H_Tmp, ConnectionVO conVo ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		Abdocu_H abdocu_H = new Abdocu_H( );
		Abdocu_B abdocu_B = new Abdocu_B( );
		abdocu_H.setAbdocu_no_reffer( abdocu_H_Tmp.getAbdocu_no_reffer( ) );
		// abdocu_h 헤더 정보 저장  
		abdocu_H_Tmp.setDocu_fg("1");
		abdocu_H_Tmp.setDocu_fg_text("지출결의서");
		String abdocu_no = acG20ExGwDAO.insertReferConfer_H( abdocu_H_Tmp );
		
		// 대급지급 헤더 정보 저장
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> contPayParam = acG20ExGwDAO.getPurcContPayParam(abdocu_H_Tmp);
		contPayParam.put("abdocuNo", abdocu_no);
		contPayParam.put("empSeq", loginVO.getUniqId());
		contPayParam.put("empIp", loginVO.getIp());
		String purcContPayId = acG20ExGwDAO.insertPurcContPay(contPayParam);
		contPayParam.put("purcContPayId", purcContPayId);
		
		// 입출금계좌 업데이트
		Map<String, Object> btrInfo = acG20ExErpDAO.insert("AcG20ExErp.getBtrInfo", contPayParam, conVo);
		if(btrInfo != null && !"".equals(btrInfo)) {
			btrInfo.put("abdocuNo", abdocu_no);
			acG20ExGwDAO.update("AcG20ExGw.updateTradeInfo", btrInfo);
		}
		
		// 원인행위일/계약일/검수일/원인행워자 업데이트 start
		abdocu_H.setAbdocu_no( abdocu_no );
		if(contPayParam.get("contDate2") == null || "".equals(contPayParam.get("contDate2"))){
			contPayParam.put("contDate2", contPayParam.get("contDate"));
		}
		abdocu_H.setCause_dt(String.valueOf(contPayParam.get("contDate2")));
		abdocu_H.setSign_dt(String.valueOf(contPayParam.get("contDate2")));
		abdocu_H.setInspect_dt(String.valueOf(contPayParam.get("inspDate")));
		abdocu_H.setCause_id(String.valueOf(contPayParam.get("erpEmpCd")));
		abdocu_H.setCause_nm(String.valueOf(contPayParam.get("erpEmpNm")));
		
		acG20ExGwDAO.updateAbdocuCause( abdocu_H );
		// 원인행위일/계약일/검수일/원인행워자 업데이트 end
		
		abdocu_B.setAbdocu_no_reffer( abdocu_H_Tmp.getAbdocu_no_reffer( ) );
		abdocu_B.setAbdocu_no( abdocu_H_Tmp.getAbdocu_no( ) );
		abdocu_B.setPurc_cont_id( abdocu_H_Tmp.getPurc_cont_id( ) );
		
		// abdocu_b 예산 정보 조회 
		List<Abdocu_B> Abdocu_B_list = acG20ExGwDAO.selectPurcContPay_B( abdocu_B );
		for ( int i = 0, max = Abdocu_B_list.size( ); i < max; i++ ) {
			Abdocu_B t_abdocu_B = Abdocu_B_list.get( i );
			t_abdocu_B.setInsert_id( abdocu_H_Tmp.getInsert_id( ) );
			// abdocu_b 예산 정보 저장 
			acG20ExGwDAO.insertReferConfer_B( t_abdocu_B );
			
			// 대급지급 예산 정보 저장
			contPayParam.put("abdocuBNo", t_abdocu_B.getAbdocu_b_no());
			contPayParam.put("purcContBId", t_abdocu_B.getPurc_cont_b_id());
			String purcContPayBId = acG20ExGwDAO.insertPurcContPayB(contPayParam);
			contPayParam.put("purcContPayBId", purcContPayBId);
			
			// abdocu_t 채주 정보 조회
			List<Abdocu_T> Abdocu_T_list = acG20ExGwDAO.selectPurcContPay_T( t_abdocu_B );
			for ( int j = 0, jMax = Abdocu_T_list.size( ); j < jMax; j++ ) {
				Abdocu_T t_abdocu_T = Abdocu_T_list.get( j );
				t_abdocu_B.setInsert_id( abdocu_H_Tmp.getInsert_id( ) );
				// abdocu_t 채주 정보 저장 
				acG20ExGwDAO.insertReferConfer_T( t_abdocu_T );
				
				// 대급지급 체주 정보 저장
				contPayParam.put("abdocuTNo", t_abdocu_T.getAbdocu_t_no());
				contPayParam.put("purcContTId", t_abdocu_T.getPurc_cont_t_id());
				String purcContPayTId = acG20ExGwDAO.insertPurcContPayT(contPayParam);
				//contPayParam.put("purcContPayTId", purcContPayTId);
				
				// 거래처 정보 업데이트
				if("2".equals(contPayParam.get("purcReqTypeCodeId"))) {
					HashMap<String, String> paraMap = new HashMap<String, String>();
					paraMap.put("CO_CD", String.valueOf(contPayParam.get("erpCoCd")));
					paraMap.put("TR_CD", t_abdocu_T.getTr_cd());
					
					List<HashMap<String, String>> selectList = null;
					selectList = acG20CodeErpDAO.getErpTradeList(paraMap, conVo);
					if(selectList != null && selectList.size() == 1) {
						HashMap<String, String> tradeInfo = selectList.get(0);
						tradeInfo.put("abdocu_no", abdocu_no);
						tradeInfo.put("abdocu t_no", t_abdocu_T.getAbdocu_t_no());
						acG20ExGwDAO.updateContPayTradeInfo(tradeInfo);
					}
				}
			}
		}
		// 거래처 정보 업데이트
		if(!"2".equals(contPayParam.get("purcReqTypeCodeId"))) {
			HashMap<String, String> paraMap = new HashMap<String, String>();
			paraMap.put("CO_CD", String.valueOf(contPayParam.get("erpCoCd")));
			paraMap.put("TR_CD", String.valueOf(contPayParam.get("trCd")));
		    
			List<HashMap<String, String>> selectList = null;
			selectList = acG20CodeErpDAO.getErpTradeList(paraMap, conVo);
			if(selectList != null && selectList.size() == 1) {
				HashMap<String, String> tradeInfo = selectList.get(0);
				tradeInfo.put("abdocu_no", abdocu_no);
				acG20ExGwDAO.updateContPayTradeInfo(tradeInfo);
			}
		}
		map.put( "result", abdocu_H );
		map.put( "purcContPayId", purcContPayId );
		return map;
	}
	
	@Resource(name="AcG20CodeErpDAO")
	private AcG20CodeErpDAO acG20CodeErpDAO;

	@Override
	public void updatePurcContPay(Map<String, Object> map) throws Exception {
		acG20ExGwDAO.updatePurcContPay(map);
	}

	@Override
	public Object getPurcContPay(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.getPurcContPay(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object purcContPayComplete(Map<String, Object> map) throws Exception {
		String result = "Failed";
		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		if(acG20ExGwDAO.checkPurcContPayComplete(map) > 0) {
			return "Approval";
		}

		paramMap.put("purcContId", map.get("purcContId"));
		
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			paramMap.put("confferReturn", "Y");
			paramMap.put("empName", loginVO.getName());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("consDocSeq", map.get("consDocSeq"));
			acG20Ex2GwDAO.updateConsConfferStatus(paramMap);
		}else{
			// 로직 수정으로 주석 20180912
			//acG20ExGwDAO.purcContPayComplete(map);
			
			List<Abdocu_B> purcContBList = acG20ExGwDAO.getPurcContB(paramMap);
			
			HashMap<String, String> paramMap2 = new HashMap<String, String>();
			Map<String, Object> returnMap = null;
			if(purcContBList != null) {
				for(int i = 0; i < purcContBList.size(); i++) {
					paramMap2.put("ABDOCU_B_NO", purcContBList.get(i).getAbdocu_b_no());
					paramMap2.put("isAllDocView", "0");
					returnMap = getReturnConferBudget(paramMap2);
					result = String.valueOf(returnMap.get("result"));
					if("ING".equals(result)) return "Approval";
				}
			}
		}

		Map<String, Object> purcContInfo = (Map<String, Object>) acG20ExGwDAO.purcContInfo(paramMap);
		paramMap.put("purcReqId", purcContInfo.get("purcReqId"));

		map.put("docState", "007");	// 대금지급
		acG20ExGwDAO.updateContDocSts(map);
//		map.put("purcReqId", purcContInfo.get("purcReqId"));
//		map.put("reqDocState", "010");	// 대금지급
//		acG20ExGwDAO.updateReqDocSts(map);
		result = "Success";
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Object purcContPayCompleteRollBack(Map<String, Object> map) throws Exception {
		String result = "Failed";
		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("purcContId", map.get("purcContId"));
		
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			paramMap.put("confferReturn", "N");
			paramMap.put("empName", "");
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("consDocSeq", map.get("consDocSeq"));
			acG20Ex2GwDAO.updateConsConfferStatus(paramMap);
			result = "Success";
		}else{
			List<Abdocu_B> purcContBList = acG20ExGwDAO.getPurcContB(paramMap);
			
			int delCnt = 0;
			
			if(purcContBList != null) {
				for(int i = 0; i < purcContBList.size(); i++) {
					Abdocu_B abdocu_B = new Abdocu_B( );
					abdocu_B.setConfer_return( purcContBList.get(i).getAbdocu_b_no() );
					Abdocu_B abdocu_B_Info = acG20ExGwDAO.getReturnConferBudgetRollBackInfo( abdocu_B );
					if(abdocu_B_Info != null){
						acG20ExGwDAO.deleteAbdocu_B( abdocu_B_Info );
						delCnt ++;
					}
				}
			}
			
			if(delCnt > 0){
				result = "Success";
			}else{
				result = "Not";
			}
		}
		
		if("Success".equals(result)){
			Map<String, Object> purcContInfo = (Map<String, Object>) acG20ExGwDAO.purcContInfo(paramMap);
			paramMap.put("purcReqId", purcContInfo.get("purcReqId"));
			
			map.put("docState", "004");	// 대금지급
			acG20ExGwDAO.updateContDocSts(map);
		}
		return result;
	}

	@Override
	public Object updatePurcContPayContent(Map<String, Object> map) throws Exception {
		acG20ExGwDAO.updatePurcContPayContent(map);
		return "Success";
	}

	@Override
	public Object getContPay(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("contPay", acG20ExGwDAO.getContPay(map));
		resultMap.put("abdocuH", acG20ExGwDAO.getAbdocuH(map));
		resultMap.put("abdocuB", acG20ExGwDAO.getAbdocuB(map));
		resultMap.put("abdocuT", acG20ExGwDAO.getAbdocuT(map));
		return resultMap;
	}

	@Override
	public Object purcItemListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcItemListData(map);
	}

	@Override
	public Object purcItemListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.purcItemListDataTotal(map);
	}

	@Override
	public Object updateItemType(Map<String, Object> map) throws Exception {
		acG20ExGwDAO.updateItemType(map);
		return "Success";
	}

	@Override
	public Object getContPopupListData(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.getContPopupListData(map);
	}

	@Override
	public Object getContPopupListDataTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.getContPopupListDataTotal(map);
	}

	@Override
	public List<HashMap<String, String>> getRefDoc(Map<String, String> paraMap) throws Exception {
		return acG20ExGwDAO.getRefDoc(paraMap);
	}

	public List<HashMap<String, String>> payCmsList(HashMap<String, String> map) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return acG20ExErpDAO.payCmsList(conVo, map);
	}

	public List<HashMap<String, String>> tkpPayYm(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return acG20ExErpDAO.tkpPayYm(conVo, paraMap);
	}

	public List<HashMap<String, String>> paySctrlD(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return acG20ExErpDAO.paySctrlD(conVo, paraMap);
	}

	public List<HashMap<String, String>> tkpPayCd(Map<String, String> paraMap) throws Exception {
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		
		return acG20ExErpDAO.tkpPayCd(conVo, paraMap);
	}
	
	@Override
	public List<Map<String, Object>> getMainGrid(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> list = acG20ExGwDAO.getMainGrid(map);
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
		}else {
			for(Map<String, Object> listMap: list) {
				listMap.put("mgt_nm", URLDecoder.decode((String)listMap.get("mgt_nm"), "UTF-8"));
			}
		}
		return list;
	}
	
	@Override
	public int getMainGridTotal(Map<String, Object> map) throws Exception {
		return acG20ExGwDAO.getMainGridTotal(map);
	}
	
	private String getErpType() {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("group_code", "ERP_TYPE");
		List<Map<String, Object>> erpType = codeDAO.getCommCodeList(paramMap);
		if(erpType != null && erpType.size() > 0){		// G20 품의서 2.0
			return (String)erpType.get(0).get("code");
		}else{
			return null;
		}
	}

	@Override
	public Object updateContTrInfo(Map<String, Object> map) throws Exception {
		acG20ExGwDAO.updateContTrInfo(map);
		return "Success";
	}

	@Override
	public Object insertAddTr(Map<String, Object> map) throws Exception {
		acG20ExGwDAO.insertAddTr(map);
		return "Success";
	}
	
	@Override
	public Object deleteAddTr(Map<String, Object> map) throws Exception {
		acG20ExGwDAO.deleteAddTr(map);
		return "Success";
	}

	@Override
	public String insertPurcReqBidding(HashMap<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.insertPurcReqBidding(map);
	}

	@Override
	public Object purcBiddingData(Map<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.purcBiddingData(map);
	}

	@Override
	public Object purcBiddingDataTotal(Map<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.purcBiddingDataTotal(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updatePurcBiddingState(Map<String, Object> paramMap) throws Exception {
		String reqState = String.valueOf(paramMap.get("reqState"));
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> resultMap = (Map<String, Object>)acG20ExGwDAO.getPurcReq((HashMap<String, Object>)paramMap);
		if(reqState.equals("199")) {
			paramMap.put("confferReturn", "Y");
			paramMap.put("empName", loginVO.getName());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("consDocSeq", resultMap.get("consDocSeq"));
			acG20Ex2GwDAO.updateConsConfferStatus(paramMap);
			paramMap.put("reqStateOrg", resultMap.get("reqState"));
		}else if(reqState.equals("can")) {
			paramMap.put("confferReturn", "N");
			paramMap.put("empName", "");
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("consDocSeq", resultMap.get("consDocSeq"));
			acG20Ex2GwDAO.updateConsConfferStatus(paramMap);
			paramMap.put("reqState", resultMap.get("reqStateOrg"));
		}
		acG20ExGwDAO.updatePurcReqState(paramMap);
		paramMap.put("result", "OK");
	}

	@Override
	public Object checkPurcBiddingApproval(Map<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.checkPurcBiddingApproval(map);
	}

	@Override
	public Object selectPurcReqDept(Map<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.selectPurcReqDept(map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void insertPurcReqBiddingEvalTr(HashMap<String, Object> map) throws Exception {
		acG20Ex2GwDAO.deletePurcReqBiddingEvalTr(map);
		acG20Ex2GwDAO.deletePurcReqBiddingEvalSubTr(map);
		List<Map<String, Object>> tradeArr = (List<Map<String, Object>>)map.get("tradeArr");
		for (Map<String, Object> trade : tradeArr) {
			String purc_req_bidding_t_id = acG20Ex2GwDAO.insertPurcReqBiddingEvalTr(trade);
			List<Map<String, Object>> subTradeArr = (List<Map<String, Object>>)trade.get("subTradeArr");
			for (Map<String, Object> subTrade : subTradeArr) {
				subTrade.put("purc_req_bidding_t_id", purc_req_bidding_t_id);
				acG20Ex2GwDAO.insertPurcReqBiddingEvalSubTr(subTrade);
			}
		}
		if(!"mod".equals(map.get("type"))) {
			acG20ExGwDAO.updatePurcReqState(map);
		}
	}

	@Override
	public Object selectPurcReqBiddingEvalTr(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("tradeList", acG20Ex2GwDAO.selectPurcReqBiddingEvalTr(map));
		resultMap.put("subTradeList", acG20Ex2GwDAO.selectPurcReqBiddingEvalSubTr(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectPurcReqBiddingNego(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>( );
		map.put("attachFileList", commFileService.getAttachFileList(paramMap));
		return map;
	}

	@Override
	public Object selectPurcReqBidding(HashMap<String, Object> paramMap) throws Exception {
		return acG20Ex2GwDAO.selectPurcReqBidding(paramMap);
	}
	
	@Override
	public Object selectPurcReqBiddingRefer(HashMap<String, Object> paramMap) throws Exception {
		return acG20Ex2GwDAO.selectPurcReqBiddingRefer(paramMap);
	}
	
	@Override
	public Object selectRefDoc(HashMap<String, Object> paramMap) throws Exception {
		return acG20Ex2GwDAO.selectRefDoc(paramMap);
	}

	@Override
	public void updatePurcContModReturn(HashMap<String, Object> map) throws Exception {
		acG20Ex2GwDAO.updatePurcContModReturn(map);
	}

	@Override
	public Object insertResTrade(HashMap<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.insertResTrade(map);
	}

	@Override
	public void insertPurcContPay2(HashMap<String, Object> map) throws Exception {
		acG20Ex2GwDAO.deletePurcContPay2(map);
		acG20Ex2GwDAO.insertPurcContPay2(map);
	}

	@Override
	public Object selectPurcReqBiddingEval(HashMap<String, Object> paramMap) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("committeInfo", acG20Ex2GwDAO.selectCommitteeSeq(paramMap));
		resultMap.put("committeScoreList", acG20Ex2GwDAO.selectPurcReqBiddingEval(resultMap));
		return resultMap ;
	}

	@Override
	public Object updateContTrEvalInfo(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> biddingT = acG20Ex2GwDAO.selectPurcReqBiddingT(map);
		map.put("trCd", biddingT.get("tr_cd"));
		map.put("trNm", biddingT.get("tr_nm"));
		map.put("regNb", biddingT.get("reg_nb"));
		Map<String, String> paraMap = new HashMap<String ,String>();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		paraMap.put("CO_CD", loginVO.getErpCoCd());
		paraMap.put("TR_CD", String.valueOf(biddingT.get("tr_cd")));
		List<HashMap<String, String>> selectList = null;
		ConnectionVO conVo = new ConnectionVO();
		conVo = GetConnection();
		selectList = acG20CodeErpDAO.getErpTradeList(paraMap, conVo);
		if(selectList != null && selectList.size() == 1) {
			HashMap<String, String> tradeInfo = selectList.get(0);
			map.put("ceoNm", tradeInfo.get("CEO_NM"));
			resultMap.put("tradeInfo", tradeInfo);
		}
		acG20Ex2GwDAO.updatePurcContTr(map);
		acG20ExGwDAO.updateContTrInfo(map);
		List<Map<String, Object>> biddingTSubList = acG20Ex2GwDAO.selectPurcReqBiddingTSub(biddingT);
		map.put("trCd", null);
		acG20ExGwDAO.deleteAddTr(map);
		for (Map<String, Object> biddingTSub : biddingTSubList) {
			map.put("trCd", biddingTSub.get("tr_cd"));
			map.put("trNm", biddingTSub.get("tr_nm"));
			acG20ExGwDAO.insertAddTr(map);
		}
		resultMap.put("biddingTSubList", biddingTSubList);
		return resultMap;
	}

	@Override
	public Object selectFormInfo(Map<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.selectFormInfo(map);
	}

	@Override
	public Object updateResHeadNote(Map<String, Object> map) throws Exception {
		acG20Ex2GwDAO.updateResBudgetNote(map);
		acG20Ex2GwDAO.updateResHeadNote(map);
		return "Success";
	}

	@Override
	public Object selectPurcReqBiddingEvalTrSocialBiz(Map<String, Object> map) throws Exception {
		return acG20Ex2GwDAO.selectPurcReqBiddingEvalTrSocialBiz(map);
	}

	@Override
	public int purcContModReqCheck(HashMap<String, Object> requestMap) throws Exception {
		return acG20Ex2GwDAO.purcContModReqCheck(requestMap);
	}

	@Override
	public List<proposalVO> proposalEvaluationList() throws Exception {
		return acG20ExGwDAO.proposalEvaluationList();
	}

	@Override
	public int proposalEvaluationListTotal() throws Exception {
		return acG20ExGwDAO.proposalEvaluationListTotal();
	}
}
