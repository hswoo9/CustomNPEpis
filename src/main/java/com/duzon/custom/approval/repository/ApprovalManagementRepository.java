package com.duzon.custom.approval.repository;

import com.duzon.custom.common.dao.AbstractDAO;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
public class ApprovalManagementRepository extends AbstractDAO{
    public Map<String, Object> getEaManageDeptSeq(Map<String, Object> params) {
        return (Map<String, Object>) selectOne("approvalManage.getEaManageDeptSeq", params);
    }

    public String getTest(Map<String, Object> params) {
        return (String)selectOne("approvalManage.getTest", params);
    }
}
