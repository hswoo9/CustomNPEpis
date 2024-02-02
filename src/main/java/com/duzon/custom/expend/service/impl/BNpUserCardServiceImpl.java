package com.duzon.custom.expend.service.impl;

import com.duzon.custom.expend.etc.ResultVO;
import com.duzon.custom.expend.service.BNpUserCardService;
import com.duzon.custom.expend.service.FNpUserCardService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

@Service("BNpUserCardService")
public class BNpUserCardServiceImpl implements BNpUserCardService {

    @Resource(name = "FNpUserCardService")
    private FNpUserCardService service;

    @Override
    public ResultVO GetCardList(ResultVO params) throws Exception {
        return null;
    }

    @Override
    public ResultVO GetCardList2(Map<String, Object> params) throws Exception {
        new ResultVO();
        ResultVO result = service.GetCardList2(params);
        return result;
    }

    @Override
    public ResultVO SetCardTrans(ResultVO params) throws Exception {
        return null;
    }

    @Override
    public ResultVO SetCardUseYN(ResultVO params) throws Exception {
        return null;
    }

    @Override
    public ResultVO GetCardTransHistoryList(ResultVO params) throws Exception {
        return null;
    }
}
