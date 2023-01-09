package restful.service;

import java.util.List;
import java.util.Map;

public interface AttachFileService {
	
	public String insertAttachFile(List<Map<String,Object>> paramMap);
	
	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getAttachFileList(Map<String, Object> paramMap);

	public int updateAttachFile(Map<String, Object> paramMap);
	
	public int updateAttachFileDetail(Map<String, Object> paramMap);

	public int selectAttachFileMaxSn(Map<String, Object> paramMap);
	
}
