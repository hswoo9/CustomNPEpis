package com.duzon.custom.common.utiles;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.XML;

public class ParsingXML {
	
	public static List<Map<String, Object>> getTrainInfoService(String addr) {
		
		List<Map<String, Object>> param = new ArrayList<>();
		String line = "";
		
		try {
			
			URL url = new URL(addr);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setConnectTimeout(5000); //서버에 연결되는 Timeout 시간 설정
			con.setReadTimeout(5000); // InputStream 읽어 오는 Timeout 시간 설정
			con.setRequestMethod("GET");
			
			StringBuilder sb = new StringBuilder();
			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				//Stream을 처리해줘야 하는 귀찮음이 있음. 
				BufferedReader br = new BufferedReader(
						new InputStreamReader(con.getInputStream(), "utf-8"));
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
			} else {
				System.out.println(con.getResponseMessage());
			}
			
			org.json.JSONObject jsonObject = XML.toJSONObject(sb.toString());
			JSONArray jsonArray = jsonObject.getJSONObject("response").getJSONObject("body").getJSONObject("items").getJSONArray("item");
			param = new ArrayList<>();
			
			for (int i = 0; i < jsonArray.length(); i++) {
				
				Map<String, Object> map = new HashMap<>();
				Set<String> keys  = jsonArray.getJSONObject(i).keySet();
				Iterator<String> iter = keys.iterator();
				
				while (iter.hasNext()) {
					String key = iter.next();
					
					jsonArray.getJSONObject(i).get(key).toString();
					
					map.put(key, jsonArray.getJSONObject(i).get(key).toString());
				};
				
				param.add(map);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return param;
	}
}
