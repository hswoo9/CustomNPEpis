package com.duzon.custom.expend.service.impl;

import com.duzon.custom.expend.dao.ExpendDAO;
import com.duzon.custom.expend.dao.FNpUserCardServiceADAO;
import com.duzon.custom.expend.etc.CommonConvert;
import com.duzon.custom.expend.service.ExpendService;
import com.google.gson.Gson;
import org.springframework.stereotype.Service;
import com.google.gson.reflect.TypeToken;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("ExpendService")
public class ExpendServiceImpl implements ExpendService {

    @Resource(name = "ExpendDAO")
    private ExpendDAO expendDAO;

    @Override
    public List<Map<String, Object>> getDocListData(Map<String, Object> params) {
        return expendDAO.selectList("Expend.getDocListData", params);
    }

    @Override
    public String getDocListDataTotalCount(Map<String, Object> params) {
        return (String) expendDAO.selectOne("Expend.getDocListDataTotalCount", params);
    }

    @Override
    @Transactional
    public Map<String, Object> setResCardUse(Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        String status = "";
        String message = "";

        Map<String, Object> tradeMap = (Map<String, Object>) expendDAO.selectOne("Expend.getTradeMap", params);
        Map<String, Object> cardMap = (Map<String, Object>) expendDAO.selectOne("Expend.getCardMap", params);
        if(tradeMap != null){
            params.put("resDocSeq", tradeMap.get("res_doc_seq"));
            expendDAO.update("Expend.updateCardTrade", params);
            expendDAO.update("Expend.updateTradeCard", params);

            params.put("prev_interface_type", tradeMap.get("interface_type"));
            params.put("prev_interface_seq", tradeMap.get("interface_seq"));
            params.put("next_interface_type", "card");
            params.put("next_interface_seq", params.get("syncId"));
            params.put("prev_if_d_id", cardMap.get("if_d_id"));
            params.put("prev_if_m_id", cardMap.get("if_m_id"));
            params.put("next_if_d_id", tradeMap.get("res_doc_seq"));
            params.put("next_if_m_id", params.get("tradeSeq"));
            params.put("reg_seq", params.get("empSeq"));

            expendDAO.update("Expend.insertTradeCardHistory", params);

            message = "처리되었습니다.";
            status = "200";
        }else{
            message = "거래처 정보가 없습니다.";
            status = "500";
        }


        result.put("status", status);
        result.put("message", message);
        return result;
    }

    @Override
    public List<Map<String, Object>> getResTradeList(Map<String, Object> params) {
        return expendDAO.selectList("Expend.getResTradeList", params);
    }

    @Override
    public Map<String, Object> getModifyLogList(Map<String, Object> params) {
        Map<String, Object> resultMap = new HashMap<>();
        Map<String, Object> originalData = (Map<String, Object>) expendDAO.selectOne("Expend.getOriginalData", params);
        List<Map<String, Object>> logList = expendDAO.selectList("Expend.getModifyLogList", params);
        resultMap.put("originalData", originalData);
        resultMap.put("logList", logList);
        return resultMap;
    }

    @Override
    public Map<String, Object> setCardMoney(Map<String, Object> params) throws Exception{
        Map<String, Object> result = new HashMap<>();
        String status = "";
        String message = "";

        if(params.containsKey("cardTransData")){
            try{
                List<Map<String, Object>> paramsList = new ArrayList<>();
                paramsList = CommonConvert.CommonGetJSONToListMap(CommonConvert.CommonGetStr(params.get("cardTransData")));
                if(paramsList.size() > 0){
                    for(int i = 0 ; i < paramsList.size() ; i++){
                        params.putAll(paramsList.get(i));
                        expendDAO.insert("Expend.setCardModifyLog", params);
                        expendDAO.update("Expend.setCardMoney", params);
                        expendDAO.update("Expend.setCardSendYn", params);
                    }
                }
                message = "처리되었습니다.";
                status = "200";
            }catch (Exception e){
                message = "저장 중 오류 발생";
                status = "500";
            }

        }
        result.put("status", status);
        result.put("message", message);
        return result;
    }
}
