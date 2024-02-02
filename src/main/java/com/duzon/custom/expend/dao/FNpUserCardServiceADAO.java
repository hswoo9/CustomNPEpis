package com.duzon.custom.expend.dao;


import com.duzon.custom.common.dao.AbstractDAO;
import com.duzon.custom.expend.etc.ResultVO;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository("FNpUserCardServiceADAO")
public class FNpUserCardServiceADAO extends AbstractDAO {

    public ResultVO GetNotUseList(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* LIST */
            result.setAaData((List<Map<String, Object>>) selectList("NpUserCard.GetNotUseList", p));
            result.setAaData((result.getAaData() == null ? new ArrayList<Map<String, Object>>() : result.getAaData()));
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    /* 카드 내역 이관 목록 조회 */
    @SuppressWarnings("unchecked")
    public ResultVO GetTransLIst(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* LIST */
            result.setAaData((List<Map<String, Object>>) selectList("NpUserCard.GetTransLIst", p));
            result.setAaData((result.getAaData() == null ? new ArrayList<Map<String, Object>>() : result.getAaData()));
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    /* 카드 내역 수신 목록 조회 */
    @SuppressWarnings("unchecked")
    public ResultVO GetReceiveList(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* LIST */
            result.setAaData((List<Map<String, Object>>) selectList("NpUserCard.GetReceiveList", p));
            result.setAaData((result.getAaData() == null ? new ArrayList<Map<String, Object>>() : result.getAaData()));
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    /* 카드 내역 현황 조회 ( 사용자 ) */
    @SuppressWarnings("unchecked")
    public ResultVO GetCardList(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* LIST */
            result.setAaData((List<Map<String, Object>>) selectList("NpUserCard.GetCardList", p));
            result.setAaData((result.getAaData() == null ? new ArrayList<Map<String, Object>>() : result.getAaData()));
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }
    public ResultVO GetCardList2FullList(Map<String, Object> params) throws Exception {
        ResultVO result = new ResultVO();

        try {
            result.setAaData(selectList("NpAdminCard.GetCardList2FullList", params));
            result.setSuccess();
        } catch (Exception var4) {
            result.setFail("법인카드 승인내역 전체 조회 중 오류 발생 GetCardList2FullList  ERROR MSG : " + var4.getMessage(), var4);
        }

        return result;
    }

    /* 카드 이관 항목 조회 */
    @SuppressWarnings("unchecked")
    public ResultVO GetTransItem(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* MAP */
            result.setaData((Map<String, Object>) selectOne("NpUserCard.GetTransItem", p));
            result.setaData((result.getaData() == null ? new HashMap<String, Object>() : result.getaData()));
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    /* 카드 이관 항목 생성 */
    public ResultVO SetTransInsertItem(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* MAP */
            insert("NpUserCard.SetTransInsertItem", p);
            result.setaData(p);
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    /* 카드 이관 항목 수정 */
    public ResultVO SetTransUpdateItem(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* MAP */
            update("NpUserCard.SetTransUpdateItem", p);
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    public ResultVO SetCardUseYNUpdate(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* MAP */
            update("NpUserCard.SetUseYNUpdateItem", p);
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    public ResultVO SetCardUseYNInsert(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* MAP */
            insert("NpUserCard.SetUseYNInsertItem", p);
            result.setaData(p);
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

    @SuppressWarnings("unchecked")
    public ResultVO GetCardTransHistoryListSelect(Map<String, Object> p) throws Exception {
        /* VO */
        ResultVO result = new ResultVO();

        try {
            /* LIST */
            result.setAaData((List<Map<String, Object>>) selectList("NpUserCard.GetCardTransHistoryListSelect", p));
            result.setSuccess();
        }
        catch (Exception e) {
            /* EXCEPTION */
            result.setFail("Data 질의 요청중 에러 발생", e);
        }

        /* RETURN */
        return result;
    }

}
