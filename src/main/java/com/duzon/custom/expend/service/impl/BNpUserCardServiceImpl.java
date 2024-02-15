package com.duzon.custom.expend.service.impl;

import com.duzon.custom.expend.etc.ResultVO;
import com.duzon.custom.expend.service.BNpUserCardService;
import com.duzon.custom.expend.service.FNpUserCardService;
import com.duzon.custom.resalphag20.dao.ResAlphaG20DAO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("BNpUserCardService")
public class BNpUserCardServiceImpl implements BNpUserCardService {

    @Resource(name = "FNpUserCardService")
    private FNpUserCardService service;

    @Resource(name = "ResAlphaG20DAO")
    private ResAlphaG20DAO resAlphaG20DAO;

    @Override
    public ResultVO GetCardList(ResultVO params) throws Exception {
        return null;
    }

    @Override
    public ResultVO GetCardList2(Map<String, Object> params) throws Exception {
        new ResultVO();
        ResultVO result = service.GetCardList2(params);
        if(result.getAaData() != null){
            List<Map<String, Object>> list = (List<Map<String, Object>>) result.getAaData();
            if(list.size() > 0){
                for(int i = 0 ; i < list.size() ; i++){
                    //Map<String, Object> stradeMap = new HashMap<>();
                    Map<String, Object> stradeMap = resAlphaG20DAO.selectTradeAddrInfo2(list.get(i));
                    String mercAddr = "";
                    String mercTel = "";
                    String branchType = "";
                    if (stradeMap != null) {
                        if (stradeMap.get("CHAIN_ADDR1") != null && !String.valueOf(stradeMap.get("CHAIN_ADDR1")).equals("")) {
                            mercAddr += String.valueOf(stradeMap.get("CHAIN_ADDR1"));
                        }

                        if (stradeMap.get("CHAIN_ADDR2") != null && !String.valueOf(stradeMap.get("CHAIN_ADDR2")).equals("")) {
                            mercAddr += " " + String.valueOf(stradeMap.get("CHAIN_ADDR2"));
                        }

                        if (stradeMap.get("BRANCHTYPE") != null && !String.valueOf(stradeMap.get("BRANCHTYPE")).equals("")) {
                            branchType = String.valueOf(stradeMap.get("BRANCHTYPE"));
                        }

                        mercTel = stradeMap.get("CHAIN_TEL") != null ?  String.valueOf(stradeMap.get("CHAIN_TEL")) : "";
                    }
                    list.get(i).put("mercAddr", mercAddr);
                    list.get(i).put("mercTel", mercTel);
                    list.get(i).put("branchType", branchType);

                }
                result.setAaData(list);
            }
        }

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
