package restful.service.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import restful.service.AttachFileService;

import neos.cmm.db.CommonSqlDAO;

@Service("AttachFileService")
public class AttachFileServiceImpl implements AttachFileService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@SuppressWarnings("unchecked")
	@Override
	public String insertAttachFile(List<Map<String, Object>> paramMap) {
		Map<String,Object> vo = (Map<String,Object>) paramMap.get(0);
		String fileId = vo.get("fileId")+"";
		try {
			commonSql.insert("AttachFileUpload.insertAtchFile", vo);

			Iterator<?> iter = paramMap.iterator();
			while (iter.hasNext()) {
				vo = (Map<String,Object>) iter.next();

				commonSql.insert("AttachFileUpload.insertAtchFileDetail", vo);
			}
		} catch(Exception e) {
			e.printStackTrace();
			return null;
		}
		
		return fileId;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetail", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAttachFileList(Map<String, Object> paramMap) {
		return (List<Map<String, Object>>) commonSql.list("AttachFileUpload.selectAttachFileDetail", paramMap);
	}

	@Override
	public int updateAttachFile(Map<String, Object> paramMap) {
		return commonSql.update("AttachFileUpload.updateAttachFile", paramMap);
	}

	@Override
	public int updateAttachFileDetail(Map<String, Object> paramMap) {
		return commonSql.update("AttachFileUpload.updateAttachFileDetail", paramMap);
	}

	@Override
	public int selectAttachFileMaxSn(Map<String, Object> paramMap) {
		return (int) commonSql.select("AttachFileUpload.selectAttachFileMaxSn", paramMap);
	}

}
