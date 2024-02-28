package com.duzon.custom.expend.controller;

import ac.cmm.service.AcCommonService;
import ac.cmm.vo.ConnectionVO2;
import bizbox.orgchart.service.vo.LoginVO;
import com.duzon.custom.commcode.service.CListService;
import com.duzon.custom.common.utiles.EgovStringUtil;
import com.duzon.custom.expend.etc.*;
import com.duzon.custom.expend.service.BNpUserCardService;
import com.duzon.custom.expend.service.ExpendService;
import com.duzon.custom.expend.vo.CustomLabelVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.acls.NotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
public class ExpendController {

    private static final Logger logger = LoggerFactory.getLogger(ExpendController.class);

    @Resource(name ="AcCommonService")
    AcCommonService acCommonService;

    @Resource(name = "CommonInfo")
    private CommonInfo cmInfo;

    @Resource(name = "BNpUserCardService")
    private BNpUserCardService npCardService;

    @Autowired
    private ExpendService expendService;

    @RequestMapping(value = "/expend/npUserCardReport.do")
    public String npUserCardReport(@RequestParam Map<String, Object> params, Model model) {
        logger.debug("npUserCardReport");
        try{
            LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
            if(loginVo == null){
                throw new NotFoundException("로그인 정보가 없습니다.");
            }
            ConnectionVO2 conVo = cmInfo.CommonGetConnectionInfo(CommonConvert.CommonGetStr(loginVo.getCompSeq()));
            if (conVo.getErpCompSeq() == null || conVo.getErpCompSeq().isEmpty())
                throw new NotFoundConnectionException("ERP 연동 설정을 확인하세요.");
            if (CommonConvert.CommonGetStr(conVo.getErpTypeCode()).equals("iCUBE") && conVo.getG20YN().equals("N"))
                throw new CheckICUBEG20TypeException("iCUBE G20 설정확인이 필요함.");

            Map<String, Object> conInfoTemp = CommonConvert.CommonGetObjectToMap(conVo);
            Map<String, Object> conInfo = new HashMap<>();
            conInfo.put("erpCompName", conInfoTemp.get("erpCompName").toString());
            conInfo.put("erpCompSeq", conInfoTemp.get("erpCompSeq").toString());
            conInfo.put("erpTypeCode", conInfoTemp.get("erpTypeCode").toString());
            conInfo.put("g20YN", conInfoTemp.get("g20YN").toString());

            model.addAttribute("conVo", CommonConvert.CommonGetMapToJSONObj(conInfo));

            String pCompSeq = CommonConvert.CommonGetStr(loginVo.getCompSeq());
            String plangCode = CommonConvert.CommonGetStr(loginVo.getLangCode());
            String pGroupSeq = CommonConvert.CommonGetStr(loginVo.getGroupSeq());

            CustomLabelVO vo = cmInfo.CommonGetCustomLabelInfo(pCompSeq, plangCode, pGroupSeq);
            model.addAttribute("CL", vo.getData());
            params.put("empInfo", CommonConvert.CommonGetMapToJSONObj(CommonConvert.CommonGetEmpInfo()));
            model.addAttribute("ViewBag", params);
            model.addAttribute("loginVo", CommonConvert.CommonGetMapToJSONObj(getPublicLoginVo(loginVo)));


        }catch (Exception e){
            e.printStackTrace();
            logger.info(e.getMessage());
        }

        return "/expend/npUserCardReport";
    }

    @RequestMapping(value = "/expend/docListPop.do")
    public String docListPop(@RequestParam Map<String, Object> params, Model model) {
        logger.debug("docListPop");
        if(params.containsKey("syncId")){
            model.addAttribute("syncId", params.get("syncId"));
        }
        return "/popup/expend/popup/docListPop";
    }

    @RequestMapping(value = "/expend/getDocListData.do")
    public String getDocListData(@RequestParam Map<String, Object> params, Model model) {
        logger.debug("docListData");
        model.addAttribute("list", expendService.getDocListData(params));
        model.addAttribute("totalCount", expendService.getDocListDataTotalCount(params));
        return "jsonView";
    }

    @RequestMapping(value = "/expend/np/user/NpUserCardReportSelect2.do")
    public String NpUserCardReportSelect2(@RequestParam Map<String, Object> params, HttpServletRequest request, Model model) throws Exception {
        LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
        ConnectionVO2 conVo = new ConnectionVO2();
        ResultVO result = new ResultVO();
        try{
            CommonException.Login();
            loginVo = CommonConvert.CommonGetEmpVO();
            params.put("empSeq", loginVo.getUniqId());
            params.put("deptSeq", loginVo.getOrgnztId());
            params.put("compSeq", loginVo.getCompSeq());
            params.put("groupSeq", loginVo.getGroupSeq());
            result.setLoginVo(loginVo);
            result.setParams(params);
            result = npCardService.GetCardList2(params);
            result.setSuccess();
        }catch (Exception e){
            e.printStackTrace();
            logger.info(e.getMessage());
        }
        model.addAttribute("result", result);
        return "jsonView";
    }

    @RequestMapping(value = "/expend/setResCardUse.do")
    public String setResCardUse(@RequestParam Map<String, Object> params, Model model) {
        logger.debug("setResCardUse");
        LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
        params.put("empSeq", loginVo.getUniqId());
        model.addAttribute("result", expendService.setResCardUse(params));
        return "jsonView";
    }

    @RequestMapping(value = "/expend/getResTradeList.do")
    public String getResTradeList(@RequestParam Map<String, Object> params, Model model) {
        logger.debug("setResCardUse");
        model.addAttribute("result", expendService.getResTradeList(params));
        return "jsonView";
    }

    @RequestMapping(value = "/expend/setCardMoney.do")
    public String setCardMoney(@RequestParam Map<String, Object> params, Model model)  throws Exception{
        logger.debug("setResCardUse");
        model.addAttribute("result", expendService.setCardMoney(params));
        return "jsonView";
    }

    private Map<String, Object> getPublicLoginVo(LoginVO loginVo) {
        Map<String, Object> returnObj = new HashMap<>();
        if (loginVo == null)
            return returnObj;
        returnObj.put("bizSeq", loginVo.getBizSeq());
        returnObj.put("classNm", loginVo.getClassNm());
        returnObj.put("classCode", loginVo.getClassCode());
        returnObj.put("authorCode", loginVo.getAuthorCode());
        returnObj.put("compSeq", loginVo.getCompSeq());
        returnObj.put("deptSeq", loginVo.getOrganId());
        returnObj.put("eaType", loginVo.getEaType());
        returnObj.put("erpCoCd", loginVo.getErpCoCd());
        returnObj.put("erpEmpCd", loginVo.getErpEmpCd());
        returnObj.put("groupSeq", loginVo.getGroupSeq());
        returnObj.put("langCode", loginVo.getLangCode());
        returnObj.put("name", loginVo.getName());
        returnObj.put("organId", loginVo.getOrganId());
        returnObj.put("organNm", loginVo.getOrganNm());
        returnObj.put("orgnztId", loginVo.getOrgnztId());
        returnObj.put("orgnztNm", loginVo.getOrgnztNm());
        returnObj.put("positionCode", loginVo.getPositionCode());
        returnObj.put("positionNm", loginVo.getPositionNm());
        returnObj.put("empSeq", loginVo.getUniqId());
        returnObj.put("uniqId", loginVo.getUniqId());
        return returnObj;
    }
}
