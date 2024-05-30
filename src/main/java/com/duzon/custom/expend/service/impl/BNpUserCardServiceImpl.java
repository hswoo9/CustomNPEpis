package com.duzon.custom.expend.service.impl;

import com.duzon.custom.budget.dao.BudgetDAO;
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

    @Resource ( name = "BudgetDAO" )
    private BudgetDAO budgetDAO;

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
            if(params.containsKey("branch")) {
                if (params.get("branch").toString().equals("Y")) {
                    List<Map<String, Object>> stradeList = resAlphaG20DAO.selectTradeAddrInfo2(params);
                    if (list.size() > 0) {
                        for(int i = 0 ; i < list.size() ; i++) {
                            Map<String, Object> erpBgMap = budgetDAO.getErpBgInfo(list.get(i));

                            if (erpBgMap != null) {
                                list.get(i).putAll(erpBgMap);
                            }
                        }


                        if (stradeList.size() > 0) {
                            for(int i = 0 ; i < list.size() ; i++) {
                                for(int j = 0 ; j < stradeList.size() ; j++) {
                                    String mercAddr = "";
                                    String mercTel = "";
                                    String branchType = "";
                                    String cancelYn = "N";
                                    String cardDept = "";
                                    if(list.get(i).get("authNum").toString().equals(stradeList.get(j).get("APPR_NO").toString())) {
                                        if(stradeList.get(j).get("CHAIN_ADDR1") != null && !String.valueOf(stradeList.get(j).get("CHAIN_ADDR1")).equals("")) {
                                            mercAddr += String.valueOf(stradeList.get(j).get("CHAIN_ADDR1"));
                                        }
                                        if(stradeList.get(j).get("CHAIN_ADDR2") != null && !String.valueOf(stradeList.get(j).get("CHAIN_ADDR2")).equals("")) {
                                            mercAddr += " " + String.valueOf(stradeList.get(j).get("CHAIN_ADDR2"));
                                        }
                                        if(stradeList.get(j).get("BRANCHTYPE") != null && !String.valueOf(stradeList.get(j).get("BRANCHTYPE")).equals("")) {
                                            branchType = String.valueOf(stradeList.get(j).get("BRANCHTYPE"));
                                        }
                                        if(stradeList.get(j).get("CHAIN_TEL") != null && !String.valueOf(stradeList.get(j).get("CHAIN_TEL")).equals("")) {
                                            mercTel = String.valueOf(stradeList.get(j).get("CHAIN_TEL"));
                                        }else{
                                            mercTel = "";
                                        }

                                        if(stradeList.get(j).get("CANCEL_YN") != null && !String.valueOf(stradeList.get(j).get("CANCEL_YN")).equals("")) {
                                            cancelYn = String.valueOf(stradeList.get(j).get("CANCEL_YN"));
                                        }
                                        if(stradeList.get(j).get("CARD_DEPT") != null && !String.valueOf(stradeList.get(j).get("CARD_DEPT")).equals("")) {
                                            cardDept = String.valueOf(stradeList.get(j).get("CARD_DEPT"));
                                        }

                                        list.get(i).put("mercAddr", mercAddr);
                                        list.get(i).put("mercTel", mercTel);
                                        list.get(i).put("branchType", branchType);
                                        list.get(i).put("cancelYn", cancelYn);
                                        list.get(i).put("cardDept", cardDept);
                                        list.get(i).put("chainCd", String.valueOf(stradeList.get(j).get("CHAIN_CD")));
                                        list.get(i).put("chainCeo", String.valueOf(stradeList.get(j).get("CHAIN_CEO")));

                                    }


                                }
                            }

                        }
                    }
                }
            }

            result.setAaData(list);
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
