package com.duzon.custom.expend.service;

import com.duzon.custom.expend.etc.ResultVO;

import java.util.Map;

public interface FNpUserCardService {

    ResultVO GetNotUseList(ResultVO param) throws Exception;

    /**
     * 카드 내역 이관 목록 조회
     *
     * @param param
     *            ( groupSeq, compSeq, empSeq )
     * @return ( syncId )
     * @throws Exception
     */
    ResultVO GetTransLIst(ResultVO param) throws Exception;

    /**
     * 카드 내역 수신 목록 조회
     *
     * @param param
     *            ( groupSeq, compSeq, empSeq )
     * @return ( syncId )
     * @throws Exception
     */
    ResultVO GetReceiveList(ResultVO param) throws Exception;

    /**
     * 카드 내역 현황 조회 ( 사용자 )
     *
     * @param param
     *            ( compSeq, cardAuthDateFrom, cardAuthDateTo, searchPartnerName, searchPartnerNo, searchGeoraeStat, searchAuthNum, searchSendYn, searchApprovalEmpName )
     * @return ResultVO.aaData ( syncId, georaeStatName, georaeStat, authDate, authTime, authNum, partnerName, partnerNo, cardName, cardNum, reqAmt, stdAmt, vatAmt, serAmt, approvalStatName, approvalStat )
     * @throws Exception
     */
    ResultVO GetCardList(ResultVO param) throws Exception;
    ResultVO GetCardList2(Map<String, Object> var1) throws Exception;

    /**
     * 카드 내역 이관
     *
     * @param param
     *            ( groupSeq, compSeq, syncId, cardNum, authNum, authDate, authTime, partnerNo, partnerName, reqAmt, empSeq, empName, receiveEmpSeq, receiveEmpName, receiveEmpSuperKey )
     * @return
     * @throws Exception
     */
    ResultVO SetTransCardItem(ResultVO param) throws Exception;

    /**
     * 카드 내역 사용 / 미사용 처리 ( 사용자 )
     *
     * @param param
     *            ( useYN, cardUseYNList )
     * @return
     * @throws Exception
     */
    ResultVO SetCardUseYN(ResultVO param) throws Exception;

    //	/**
    //	 * 카드 이관 항목 조회
    //	 *
    //	 * @param param
    //	 *            ( groupSeq, compSeq, syncId )
    //	 * @return ( seq, compSeq, syncId, cardNum, authNum, authDate, authTime, partnerNo, partnerName, reqAmt, transSeq, transName, receiveSeq, receiveName, useYn, supperKey )
    //	 * @throws Exception
    //	 */
    //	ResultVO GetTransItem(ResultVO param) throws Exception;
    //
    //	/**
    //	 * 카드 이관 항목 생성
    //	 *
    //	 * @param param
    //	 *            ( groupSeq, compSeq, syncId, cardNum, authNum, authDate, authTime, partnerNo, partnerName, reqAmt, empSeq, empName, receiveEmpSeq, receiveEmpName, receiveEmpSuperKey )
    //	 * @return ( transSeq )
    //	 * @throws Exception
    //	 */
    //	ResultVO SetTransInsertItem(ResultVO param) throws Exception;
    //
    //	/**
    //	 * 카드 이관 항목 수정
    //	 *
    //	 * @param param
    //	 *            ( groupSeq, compSeq, syncId, empSeq, empName, receiveEmpSeq, receiveEmpName, receiveEmpSuperKey )
    //	 * @return ( void )
    //	 * @throws Exception
    //	 */
    //	ResultVO SetTransUpdateItem(ResultVO param) throws Exception;

    /**
     * 카드사용내역 이관 목록 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    ResultVO GetCardTransHistoryList(ResultVO param) throws Exception;

}
