package com.duzon.custom.expend.service.impl;

import com.duzon.custom.expend.dao.ExpendDAO;
import com.duzon.custom.expend.dao.FNpUserCardServiceADAO;
import com.duzon.custom.expend.service.ExpendService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
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
}
