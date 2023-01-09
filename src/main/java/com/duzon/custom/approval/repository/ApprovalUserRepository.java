package com.duzon.custom.approval.repository;

import com.duzon.custom.common.dao.AbstractDAO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ApprovalUserRepository extends AbstractDAO {
    public void setUserFavApproveRoute(Map<String, Object> params){ insert("approvalUser.setUserFavApproveRoute", params);}
    public void setUserFavApproveRouteUpdate(Map<String, Object> params){ update("approvalUser.setUserFavApproveRouteUpdate", params);}
    public void setUserFavApproveRouteActiveN(Map<String, Object> params) { update("approvalUser.setUserFavApproveRouteActiveN", params);}
    public void setUserFavApproveRouteDetail(Map<String, Object> params){ insert("approvalUser.setUserFavApproveRouteDetail", params);}
    public void setUserFavApproveRouteDetailDel(Map<String, Object> params){ delete("approvalUser.setUserFavApproveRouteDetailDel", params);}
    public void setUserFavApproveRouteDetailActiveN(Map<String, Object> params) { update("approvalUser.setUserFavApproveRouteDetailActiveN", params);}
    public List<Map<String, Object>> getUserFavApproveRouteList(Map<String, Object> params){ return selectList("approvalUser.getUserFavApproveRouteList", params);}
    public List<Map<String, Object>> getUserFavApproveRouteDetail(Map<String, Object> params){ return selectList("approvalUser.getUserFavApproveRouteDetail", params);}
}
