package com.duzon.custom.approval.service;

import java.util.List;
import java.util.Map;

public interface ApprovalUserService {
    /**
     * 즐겨찾기 결재선 저장
     * @param params
     * @return
     */
    Map<String, Object> setUserFavApproveRoute(Map<String, Object> params);

    /**
     * 나의 즐겨찾기 결재선 리스트 조회
     * @param params
     * @return
     */
    List<Map<String, Object>> getUserFavApproveRouteList(Map<String, Object> params);

    /**
     * 나의 즐겨찾기 결재선 상세 조회
     * @param params
     * @return
     */
    List<Map<String, Object>> getUserFavApproveRouteDetail(Map<String, Object> params);

    /**
     * 나의 즐겨찾기 결재선 삭제
     * @param params
     * @return
     */
    Map<String, Object> setUserFavApproveRouteActiveN(Map<String, Object> params);
}
