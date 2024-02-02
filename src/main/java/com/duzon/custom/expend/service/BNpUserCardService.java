package com.duzon.custom.expend.service;

import com.duzon.custom.expend.etc.ResultVO;

import java.util.Map;

public interface BNpUserCardService {

    ResultVO GetCardList(ResultVO params) throws Exception;

    ResultVO GetCardList2(Map<String, Object> params) throws Exception;

    ResultVO SetCardTrans(ResultVO params) throws Exception;

    ResultVO SetCardUseYN(ResultVO params) throws Exception;

    ResultVO GetCardTransHistoryList(ResultVO params) throws Exception;
}
