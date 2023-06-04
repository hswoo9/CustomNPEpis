package com.duzon.custom.approval.service;

import ac.cmm.vo.ConnectionVO;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ApprovalService {
    /**
     * 기록물철 트리
     * @param params
     * @return
     */
    List<Map<String, Object>> getArchiveTreeList(Map<String, Object> params);

    Map<String, Object> getUserInfo(Map<String, Object> params);

    /**
     * 상신 문서 저장
     * @param params
     */
    void setApproveDocInfo(Map<String, Object> params, MultipartFile docFile, MultipartFile[] mpfList, String base_dir, String base_down_dir) throws UnsupportedEncodingException;

    /**
     * 결재 문서 정보
     */
    Map<String, Object> getDocInfoApproveRoute(Map<String, Object> params);

    /**
     * 문서의 현재 결재 순서
     */
    Map<String, Object> getDocApproveNowRoute(Map<String, Object> params);

    /**
     * 문서의 현재 협조 순서
     */
    Map<String, Object> getDocCooperationNowRoute(Map<String, Object> params);

    /**
     * 문서 결재현황 보기
     */
    List<Map<String, Object>> getDocApproveStatusHistList(Map<String, Object> params);

    /**
     * 문서 결재자 의견 보기
     */
    List<Map<String, Object>> getDocApproveHistOpinList(Map<String, Object> params);

    /**
     * 공통 코드 조회 ( wkCodeId = 코드 기본키 )
     * @param params
     * @return
     */
    Map<String, Object> getCmCodeInfo(Map<String, Object> params);

    /**
     * 문서 결재
     */
    void setDocApproveNRefer(Map<String, Object> params, MultipartFile docFile);

    /**
     * 현재 결재순번 결재자 문서 최초 열람시간
     * @param params
     */
    void setDocApproveRouteReadDt(Map<String, Object> params);

    /**
     * 상신 문서 회수 (최종결재 전 회수 가능)
     */
    void setApproveRetrieve(Map<String, Object> params);

    Map<String, Object> approveCheck(Map<String, Object> map);
}
