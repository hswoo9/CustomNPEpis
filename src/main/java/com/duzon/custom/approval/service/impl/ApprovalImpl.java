package com.duzon.custom.approval.service.impl;

import com.duzon.custom.approval.repository.ApprovalManagementRepository;
import com.duzon.custom.approval.repository.ApprovalRepository;
import com.duzon.custom.approval.service.ApprovalService;
import com.duzon.custom.common.utiles.BlobToPdfConvert;
import com.duzon.custom.common.utiles.StringUtil;
import com.duzon.custom.eval.dao.EvalDAO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dev_jitsu.MainLib;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

import static com.duzon.custom.common.utiles.CommonUtil2.filePath;

@Service
public class ApprovalImpl implements ApprovalService {

    @Autowired
    private EvalDAO evalDAO;

    @Autowired
    private ApprovalRepository approvalRepository;

    @Autowired
    private ApprovalManagementRepository approvalManagementRepository;

    @Override
    public List<Map<String, Object>> getArchiveTreeList(Map<String, Object> params) {
        Map<String, Map<String, Object>> tree = new HashMap<>();

        String searchYear = StringUtil.isNullToString(params.get("searchYear"));
        String type = StringUtil.isNullToString(params.get("type"));
        String allVisible = StringUtil.isNullToString(params.get("allVisible"));

        Calendar c = Calendar.getInstance();
        int m = c.get(2) + 1;
        String y = String.valueOf(c.get(1) - 1);

        if (type.equals("takeover")) {
            params.put("lastY", "");
        } else if (allVisible.equals("Y")) {
            params.put("lastY", "Y");
        } else if (m <= 2) {
            if (searchYear.equals("") || searchYear.equals(y) || searchYear.equals(String.valueOf(c.get(1)))) {
                searchYear = null;
                params.put("lastY", "Y");
            } else {
                params.put("lastY", "");
            }
        } else {
            params.put("lastY", "");
        }
        params.put("searchYear", searchYear);

        String manageDeptSeq = StringUtil.isNullToString(params.get("manageDeptSeq"));

        if (manageDeptSeq.equals("")){
            Map<String, Object> mngMap = approvalManagementRepository.getEaManageDeptSeq(params);
            manageDeptSeq = mngMap.get("MANAGE_DEPT_SEQ").toString();
        }

        params.put("manageDeptSeq", manageDeptSeq);

        List<Map<String, Object>> list = approvalRepository.getArchiveTreeList(params);
        Map<String, Map<String, Object>> burffer = new HashMap<>();

        for (Map<String, Object> item : list) {
            Map<String, Object> node = new HashMap<>();
            Map<String, Object> nodeState = new HashMap<>();

            nodeState.put("disabled", Boolean.valueOf(false));
            nodeState.put("selected", Boolean.valueOf(false));
            nodeState.put("opened", Boolean.valueOf(item.get("STATE").toString().equals("open")));

            String gbnOrg = StringUtil.isNullToString(item.get("CONTENTTYPE"));
            String upperCode = StringUtil.isNullToString(item.get("UPPER_CODE"));
            String aiKeyCode = StringUtil.isNullToString(item.get("C_AIKEYCODE"));
            String id = gbnOrg.toLowerCase() + aiKeyCode;
            String parent = StringUtil.isNullToString(item.get("UPPER_TYPE")) + upperCode;

            Map<String, Object> textAttribute = new HashMap<>();
            textAttribute.put("style", "");

            String wigubun = StringUtil.isNullToString(item.get("C_WIGUBUN"));
            String name = "";

            if ("00000000000".equals(upperCode)) {
                parent = "#";
                node.put("icon", "root");
                node.put("expanded", true);
                name = "기록물철";
            } else {
                name = StringUtil.isNullToString(item.get("C_AITITLE"));
                if ("m".equals(gbnOrg.toLowerCase())) {
                    node.put("icon", "group");
                } else if ("d".equals(gbnOrg.toLowerCase())) {
                    if (wigubun.equals("g")) {
                        textAttribute.put("style", "color:#3d9100");
                    } else if (wigubun.equals("c")) {
                        textAttribute.put("style", "color:#058df5");
                    }
                } else if ("a".equals(gbnOrg.toLowerCase())) {
                    node.put("icon", "col_green");
                }
            }

            node.put("text", name);
            node.put("name", name);
            node.put("seq", aiKeyCode);
            node.put("id", gbnOrg.toLowerCase() + aiKeyCode);
            node.put("parent", parent);
            node.put("contenttype", gbnOrg);
            node.put("state", nodeState);
            node.put("textAttribute", textAttribute);
            node.put("gbn_org", gbnOrg.toLowerCase());
            node.put("aiKeyCode", aiKeyCode);
            node.put("upperCode", upperCode);
            node.put("items", new ArrayList());
            node.put("type", StringUtil.isNullToString(item.get("ARCHIVETYPE")));
            node.put("reDate", StringUtil.isNullToString(item.get("PRESERVENAME")));
            node.put("preserve", StringUtil.isNullToString(item.get("C_AIPRESERVE")));
            node.put("urlPath", StringUtil.isNullToString(item.get("REL")));
            node.put("wikey", StringUtil.isNullToString(item.get("WIKEY")));
            node.put("winame", StringUtil.isNullToString(item.get("WINAME")));
            node.put("aistopyear", StringUtil.isNullToString(item.get("AISTOPYEAR")));
            node.put("wigubun", StringUtil.isNullToString(item.get("C_WIGUBUN")));
            burffer.put(id, node);
        }
        for (int i = list.size() - 1; i > -1; i--) {
            Map<String, Object> item = list.get(i);
            String gbnOrg = StringUtil.isNullToString(item.get("CONTENTTYPE"));
            String upperCode = StringUtil.isNullToString(item.get("UPPER_CODE"));
            String aiKeyCode = StringUtil.isNullToString(item.get("C_AIKEYCODE"));
            String id = String.valueOf(gbnOrg.toLowerCase()) + aiKeyCode;
            String parent = String.valueOf(StringUtil.isNullToString(item.get("UPPER_TYPE")).toLowerCase()) + upperCode;
            Map<String, Object> bNode = burffer.get(id);
            if (upperCode.equals("00000000000")) {
                tree.put(id, burffer.get(id));
            } else {
                ((ArrayList<Map<String, Object>>)((Map)burffer.get(parent)).get("items")).add(0, bNode);
            }
        }

        List<Map<String, Object>> returnList = new ArrayList<>();
        returnList.add(tree.get("r11111"));

        return returnList;
    }

    @Override
    public Map<String, Object> getUserInfo(Map<String, Object> params) {
        return approvalRepository.getUserInfo(params);
    }

    @Override
    @Transactional
    public void setApproveDocInfo(Map<String, Object> params, MultipartFile docFile, MultipartFile[] mpfList, String base_dir, String base_down_dir) {
        //setDocInfo(params, docFile, mpfList, base_dir);

        if(params.get("type").equals("draft")){
            params.put("approveStatCode", "10");
            params.put("approveStatCodeDesc", "상신");
        }

        if(!StringUtils.isEmpty(params.get("evalReqId").toString())) {
            evalDAO.setEvalDocInfoUpD(params);
        }
    }

    private void setDocInfo(Map<String, Object> params, MultipartFile docFile, MultipartFile[] mpfList, String base_dir){
        Map<String, Object> draftUser = getUserInfo(params);

        //결재상태 공통코드
        if(params.get("type").equals("draft")){
            Map<String, Object> cmCodeMap = approvalRepository.getCmCodeInfo(params);
            params.put("approveStatCode", cmCodeMap.get("CM_CODE"));
            params.put("approveStatCodeDesc", cmCodeMap.get("CM_CODE_NM"));
        }

        //결재라인 리스트
        Gson gson = new Gson();
        List<Map<String, Object>> approversRouteList = gson.fromJson((String) params.get("approversArr"), new TypeToken<List<Map<String, Object>>>() {}.getType());

        //협조라인 리스트
        List<Map<String, Object>> cooperationsRouteList = gson.fromJson((String) params.get("cooperationsArr"), new TypeToken<List<Map<String, Object>>>() {}.getType());

        // 결재문서 pdf 형식 파일 저장
        BlobToPdfConvert blobToPdfConvert = new BlobToPdfConvert();
        Map<String, Object> approveDocFileSaveMap = blobToPdfConvert.blobToPdfConverter(docFile, params, base_dir);
        if(params.get("type").equals("draft")) {
            approvalRepository.insOneFileInfo(approveDocFileSaveMap);
        }else{
            approveDocFileSaveMap.put("fileNo", params.get("atFileSn"));
            approvalRepository.updOneFileInfo(approveDocFileSaveMap);
        }

        //결재문서 정보 저장
        if(params.get("type").equals("draft") || params.get("approversRouteChange").equals("Y")){
            Map<String, Object> lastApproveInfo = approvalRepository.getApproveUserInfo(params.get("lastApproveEmpSeq").toString());
            params.put("lastApproveEmpName", lastApproveInfo.get("EMP_NAME"));
            params.put("lastApprovePositionName", lastApproveInfo.get("POSITION_NAME"));
            params.put("lastApproveDutyName", lastApproveInfo.get("DUTY_NAME"));
        }

        if(params.get("type").equals("draft")) {
            params.put("atfileSn", approveDocFileSaveMap.get("file_no"));
            params.put("draftEmpSeq", draftUser.get("EMP_SEQ"));
            params.put("draftEmpName", draftUser.get("EMP_NAME"));
            params.put("draftDeptSeq", draftUser.get("DEPT_SEQ"));
            params.put("draftDeptName", draftUser.get("DEPT_NAME"));
            params.put("draftPositionName", draftUser.get("POSITION_NAME"));
            params.put("draftDutyName", draftUser.get("DUTY_NAME"));

            approvalRepository.setApproveDocInfo(params);
        }else{
            //params.put("approveStatCodeDesc", params.get("approveStatCodeDesc").toString());
            approvalRepository.setReferDocInfoStatUp(params);
        }

        //결재문서 관련 파일 저장
        MainLib mainLib = new MainLib();
        if(mpfList.length > 0){
            List<Map<String, Object>> list = mainLib.multiFileUpload(mpfList, filePath(params, base_dir));
            for(int i = 0 ; i < list.size() ; i++){
                if(!params.get("type").equals("refer") && params.get("DOC_ID") != null) {
                    list.get(i).put("docId", params.get("DOC_ID"));
                }else if(params.get("type").equals("refer") && params.get("docId") != null) {
                    list.get(i).put("docId", params.get("docId"));
                }
                list.get(i).put("empSeq", params.get("empSeq"));
                list.get(i).put("fileCd", params.get("menuCd").toString());
                list.get(i).put("filePath", filePath(params, base_dir));
                list.get(i).put("fileOrgName", list.get(i).get("orgFilename").toString().split("[.]")[0]);
                list.get(i).put("fileExt", list.get(i).get("orgFilename").toString().split("[.]")[1]);
            }
            approvalRepository.insFileInfo(list);
        }

        //결재문서 결재라인 저장
        if(!params.get("type").equals("draft")){
            if(params.get("approversRouteChange").equals("Y")){
                approvalRepository.setReferDocApproveRouteDel(params);
            }

            if(params.get("cooperationsRouteChange").equals("Y")){
                approvalRepository.setReferDocCooperationRouteDel(params);
            }
        }

        for(Map<String, Object> approve : approversRouteList){
            Map<String, Object> approveInfo = approvalRepository.getApproveUserInfo(approve.get("approveEmpSeq").toString());
            approve.put("approveEmpName", approveInfo.get("EMP_NAME"));
            approve.put("approveDeptName", approveInfo.get("DEPT_NAME"));
            approve.put("approvePositionName", approveInfo.get("POSITION_NAME"));
            approve.put("approveDutyName", approveInfo.get("DUTY_NAME"));
            approve.put("empSeq", draftUser.get("EMP_SEQ"));

            //결재 상태 코드
            if(approve.get("approveOrder").equals("0")){
                approve.put("approveStatCode", params.get("approveStatCode"));
                approve.put("approveStatCodeDesc", params.get("approveStatCodeDesc"));
            }

            if(params.get("type").equals("draft")){
                approve.put("docId", params.get("DOC_ID"));
                approvalRepository.setDocApproveRoute(approve);
            }else{
                approve.put("docId", params.get("docId"));
                if(params.get("approversRouteChange").equals("Y")) {
                    approvalRepository.setDocApproveRoute(approve);
                }else{
                    approvalRepository.setReferDocApproveRouteUp(approve);
                }
            }
        }

        for(Map<String, Object> cooperation : cooperationsRouteList){
            Map<String, Object> cooperationInfo = approvalRepository.getApproveUserInfo(cooperation.get("cooperationEmpSeq").toString());
            cooperation.put("cooperationEmpName", cooperationInfo.get("EMP_NAME"));
            cooperation.put("cooperationDeptName", cooperationInfo.get("DEPT_NAME"));
            cooperation.put("cooperationPositionName", cooperationInfo.get("POSITION_NAME"));
            cooperation.put("cooperationDutyName", cooperationInfo.get("DUTY_NAME"));
            cooperation.put("empSeq", draftUser.get("EMP_SEQ"));

            //결재 상태 코드
            if(cooperation.get("cooperationOrder").equals("0")){
                cooperation.put("cooperationStatCode", params.get("cooperationStatCode"));
                cooperation.put("cooperationStatCodeDesc", params.get("cooperationStatCodeDesc"));
            }

            if(params.get("type").equals("draft")){
                cooperation.put("docId", params.get("DOC_ID"));
                approvalRepository.setDocCooperationRoute(cooperation);
            }else{
                cooperation.put("docId", params.get("docId"));
                if(params.get("cooperationsRouteChange").equals("Y")) {
                    approvalRepository.setDocCooperationRoute(cooperation);
                }else{
                    approvalRepository.setReferDocCooperationRouteUp(cooperation);
                }
            }
        }
    }

    @Override
    public Map<String, Object> getDocInfoApproveRoute(Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();

        result.put("docInfo", approvalRepository.getDocInfo(params));
        result.put("approveRoute", approvalRepository.getDocApproveAllRoute(params));
        result.put("cooperationRoute", approvalRepository.getDocCooperationAllRoute(params));

        return result;
    }

    @Override
    public Map<String, Object> getDocApproveNowRoute(Map<String, Object> params) {
        return approvalRepository.getDocApproveNowRoute(params);
    }

    @Override
    public Map<String, Object> getDocCooperationNowRoute(Map<String, Object> params) {
        return approvalRepository.getDocCooperationNowRoute(params);
    }

    @Override
    public List<Map<String, Object>> getDocApproveStatusHistList(Map<String, Object> params) {
        return approvalRepository.getDocApproveStatusHistList(params);
    }

    @Override
    public List<Map<String, Object>> getDocApproveHistOpinList(Map<String, Object> params) {
        return approvalRepository.getDocApproveHistOpinList(params);
    }

    @Override
    public Map<String, Object> getCmCodeInfo(Map<String, Object> params) {
        return approvalRepository.getCmCodeInfo(params);
    }

    @Override
    @Transactional
    public void setDocApproveNRefer(Map<String, Object> params, MultipartFile docFile) {
        // 결재문서 pdf 형식 파일 저장
        //BlobToPdfConvert blobToPdfConvert = new BlobToPdfConvert();
        //Map<String, Object> approveDocFileUpDMap = blobToPdfConvert.blobToPdfConverterApproveNRefer(docFile, params);
        //approvalRepository.updOneFileApproveNRefer(approveDocFileUpDMap);

        //approvalRepository.setDocInfoStatUp(params);
        //approvalRepository.setDocApproveRouteUp(params);

        params.put("approveStatCode", "100");
        params.put("approveStatCodeDesc", "최종결재");

        if(params.get("menuCd").equals("eval")){
            evalDAO.setEvalChangeDocApproveUp(params);
        }
    }

    @Override
    public void setDocApproveRouteReadDt(Map<String, Object> params) {
        approvalRepository.setDocApproveRouteReadDt(params);
    }

    @Override
    public void setApproveRetrieve(Map<String, Object> params) {
        //Map<String, Object> cmCodeInfo = approvalRepository.getCmCodeInfo(params);

        params.put("approveStatCode", "40");
        params.put("approveStatCodeDesc", "회수");
        params.put("approveOpin", "회수");

        //approvalRepository.setDocInfoStatUp(params);

        if(!StringUtils.isEmpty(params.get("evalReqId").toString())){
            evalDAO.setEvalDocApproveRetrieve(params);
        }
    }

    @Override
    public Map<String, Object> approveCheck(Map<String, Object> map) {
        return approvalRepository.approveCheck(map);
    }

    @Override
    public Map<String, Object> etaxApproveCheck(Map<String, Object> map) {
        Map<String, Object> djepis = approvalRepository.etaxEpisApproveCheck(map);
        if(djepis != null){
            return djepis;
        }else{
            Map<String, Object> neos = approvalRepository.etaxNeosApproveCheck(map);
            if(neos != null){
                return neos;
            }
        }
        return new HashMap<>();
    }
}
