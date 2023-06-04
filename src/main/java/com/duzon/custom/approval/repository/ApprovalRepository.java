package com.duzon.custom.approval.repository;

import com.duzon.custom.common.dao.AbstractDAO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ApprovalRepository extends AbstractDAO{
    public List<Map<String, Object>> getArchiveTreeList(Map<String, Object> params){return selectList("approval.getArchiveTreeList", params);}

    public Map<String, Object> getUserInfo(Map<String, Object> params){ return (Map<String, Object>) selectOne("approval.getUserInfo", params);}

    public Map<String, Object> getCmCodeInfo(Map<String, Object> params){ return (Map<String, Object>) selectOne("approval.getCmCodeInfo", params);}

    public Map<String, Object> getDocInfo(Map<String, Object> params){ return (Map<String, Object>) selectOne("approval.getDocInfo", params);}

    public List<Map<String, Object>> getDocAttachmentList(Map<String, Object> params) { return selectList("approval.getDocAttachmentList", params);}

    public List<Map<String, Object>> getDocApproveAllRoute(Map<String, Object> params){ return selectList("approval.getDocApproveAllRoute", params);}

    public List<Map<String, Object>> getDocCooperationAllRoute(Map<String, Object> params){ return selectList("approval.getDocCooperationAllRoute", params);}

    public Map<String, Object> getDocApproveNowRoute(Map<String, Object> params) { return (Map<String, Object>) selectOne("approval.getDocApproveNowRoute", params);}

    public Map<String, Object> getDocCooperationNowRoute(Map<String, Object> params) { return (Map<String, Object>) selectOne("approval.getDocCooperationNowRoute", params);}

    public void setDocCooperationRouteReadDt(Map<String, Object> parama) { update("approval.setDocCooperationRouteReadDt", parama);}

    public List<Map<String, Object>> getDocApproveHistOpinList(Map<String, Object> params) { return selectList("approval.getDocApproveHistOpinList", params);}

    public List<Map<String, Object>> getDocCooperationHistOpinList(Map<String, Object> params) { return selectList("approval.getDocCooperationHistOpinList", params);}

    public List<Map<String, Object>> getDocApproveStatusHistList(Map<String, Object> params) { return selectList("approval.getDocApproveStatusHistList", params);}

    public List<Map<String, Object>> getDocCooperationStatusHistList(Map<String, Object> params) { return selectList("approval.getDocCooperationStatusHistList", params);}

    public void setDocInfoStatUp(Map<String, Object> params) { update("approval.setDocInfoStatUp", params);}

    public void setDocApproveRouteUp(Map<String, Object> params) { update("approval.setDocApproveRouteUp", params);}

    public void setDocCooperationRouteUp(Map<String, Object> params) { update("approval.setDocCooperationRouteUp", params);}

    public void insOneFileInfo(Map<String, Object> params) { insert("approval.insOneFileInfo", params);}
    public void updOneFileInfo(Map<String, Object> params) { update("approval.updOneFileInfo", params);}

    public Map<String, Object> getApproveUserInfo(String approveEmpSeq){ return (Map<String, Object>) selectOne("approval.getApproveUserInfo", approveEmpSeq);}

    public void setApproveDocInfo(Map<String, Object> params){ insert("approval.setApproveDocInfo", params);}
    public void setReferDocInfoStatUp(Map<String, Object> params) { update("approval.setReferDocInfoStatUp", params);}

    public void insFileInfo(List<Map<String, Object>> list) {
        insert("approval.insFileInfo", list);
    }

    public void setReferDocApproveRouteDel(Map<String, Object> params){ update("approval.setReferDocApproveRouteDel", params);}
    public void setReferDocCooperationRouteDel(Map<String, Object> params){ update("approval.setReferDocCooperationRouteDel", params);}

    public void setDocApproveRoute(Map<String, Object> params){ insert("approval.setDocApproveRoute", params);}

    public void setReferDocApproveRouteUp(Map<String, Object> params){ update("approval.setReferDocApproveRouteUp", params);}

    public void setDocCooperationRoute(Map<String, Object> params){ insert("approval.setDocCooperationRoute", params);}

    public void setReferDocCooperationRouteUp(Map<String, Object> params){ update("approval.setReferDocCooperationRouteUp", params);}

    public void updOneFileApproveNRefer(Map<String, Object> params) { update("approval.updOneFileApproveNRefer", params);}

    public void setDocApproveRouteReadDt(Map<String, Object> parama) { update("approval.setDocApproveRouteReadDt", parama);}

    public Map<String, Object> approveCheck(Map<String, Object> map){ return (Map<String, Object>) selectOne("approval.approveCheck", map);
    }


}
