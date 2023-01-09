package neos.cmm.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class JsonUtil {
	public static List<Map<String,Object>> getJsonToArray(String jsonStr, String[] fields) {
//		System.out.println(jsonStr);
		 
		List<Map<String,Object>> listdata = new ArrayList<Map<String,Object>>();     
		JSONArray jArray = JSONArray.fromObject(jsonStr.toString());
		if (jArray != null) { 
			Map<String,Object> map = null;
		   for (int i=0;i<jArray.size();i++){
			   map = new HashMap<String, Object>();
			   
			   JSONObject json = JSONObject.fromObject(jArray.get(i));
			   
			   for(String s : fields) {
				   map.put(s, json.get(s));
				   
				   
			   }
			   listdata.add(map);
		   } 
		}
		
		return listdata;
		
	}
}
