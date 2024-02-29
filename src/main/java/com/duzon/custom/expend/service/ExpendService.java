package com.duzon.custom.expend.service;

import java.util.List;
import java.util.Map;

public interface ExpendService {

    List<Map<String, Object>> getDocListData(Map<String, Object> params);

    String getDocListDataTotalCount(Map<String, Object> params);

    Map<String, Object> setResCardUse(Map<String, Object> params);

    List<Map<String, Object>> getResTradeList(Map<String, Object> params);

    Map<String, Object> getModifyLogList(Map<String, Object> params);

    Map<String, Object> setCardMoney(Map<String, Object> params) throws Exception;


}
