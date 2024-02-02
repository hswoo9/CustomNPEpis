package com.duzon.custom.expend.service;

import java.util.List;
import java.util.Map;

public interface ExpendService {

    List<Map<String, Object>> getDocListData(Map<String, Object> params);

    String getDocListDataTotalCount(Map<String, Object> params);

}
