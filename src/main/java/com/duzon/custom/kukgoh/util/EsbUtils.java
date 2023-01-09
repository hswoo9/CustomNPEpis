package com.duzon.custom.kukgoh.util;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;

import com.google.gson.Gson;

import net.sf.json.JSONObject;


public class EsbUtils {
	/**
	 * 트랜잭션ID를 생성한다.
	 */
	public static String getTransactionId(String intfId, String systemCode, int seq) {
		String transactionId = ""; // 43 자리
		// 시스템 정보(6자리)
		String instanceName = "E" // 인터넷망코드(1자리)
				+ ((systemCode.length() > 3) ? systemCode.substring(0, 3) : rpad(systemCode, 3, "0")) // 시스템코드(3자리)
				+ String.format("%02d", seq); // 서버 일련번호(2자리)
		// 인터페이스 ID (15자리)
		String interfaceId = intfId;
		// Thread 정보(6자리) : "T"(1자리) + Thread 번호(5자리. ex. 00001 ~ 99999)
		String threadID = "T" + String.format("%05d", Thread.currentThread().getId());
		// 시간 정보(13자리, long 형식의 현재 시간 값)
		Long currentTime = System.currentTimeMillis();
		transactionId = instanceName + "_";
		transactionId += interfaceId + "_";
		transactionId += threadID + "_";
		transactionId += currentTime;
		return transactionId;
	}

	/**
	 * Right Padding을 수행한다.
	 */
	public static String rpad(String str, int length, String addStr) {
		String result = str;
		int tempLen = length - str.length();
		for (int i = 0; i < tempLen; i++) {
			result += addStr;
		}
		return result;
	}

	/**
	 * JSON String을 Map으로 변환한다.
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> json2Map(String jsonString) throws Exception {
		Map<String, Object> result = null;
		Map<String, Object> map = new HashMap<String, Object>();

		try {
		ObjectMapper mapper = new ObjectMapper();
		map = mapper.readValue(jsonString, new TypeReference<Map<String, Object>>(){});
		System.out.println(map);

		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
/*		ContainerFactory containerFactory = new ContainerFactory() {
			public List<Object> creatArrayContainer() {
				return new LinkedList<Object>();
			}

			public Map<String, Object> createObjectContainer() {
				return new LinkedHashMap<String, Object>();
			}
		};
		try {
			result = (Map<String, Object>) new JSONParser().parse(jsonString, containerFactory);
		} catch (ParseException e) {
			throw e;
		}
		return result;*/
		return map;
	}

	/**
	 * Map을 JSON String으로 변환한다.
	 */
	@SuppressWarnings("rawtypes")
	public static String map2Json(Map<String, Object> map) {
		if (map == null)
			return "null";
		StringBuffer sb = new StringBuffer();
		boolean first = true;
		Iterator<Entry<String, Object>> iter = map.entrySet().iterator();
		sb.append('{');
		while (iter.hasNext()) {
			if (first)
				first = false;
			else
				sb.append(',');
			Map.Entry entry = (Map.Entry) iter.next();
			toJSONString(String.valueOf(entry.getKey()), entry.getValue(), sb);
		}
		sb.append('}');
		return sb.toString();
	}

	/**
	 * JSON String 으로 변환한다.
	 */
	private static String toJSONString(String key, Object value, StringBuffer sb) {
		sb.append('\"');
		if (key == null)
			sb.append("null");
		else
			replaceWildChar(key, sb);
		sb.append('\"').append(':');
		//sb.append(JSONValue.toJSONString(value));
		sb.append(new Gson().toJson(value));
		return sb.toString();
	}

	/**
	 * 문자열을 변환한다.
	 */
	private static void replaceWildChar(String s, StringBuffer sb) {
		for (int i = 0; i < s.length(); i++) {
			char ch = s.charAt(i);
			switch (ch) {
			case '"':
				sb.append("\\\"");
				break;
			case '\\':
				sb.append("\\\\");
				break;
			case '\b':
				sb.append("\\b");
				break;
			case '\f':
				sb.append("\\f");
				break;
			case '\n':
				sb.append("\\n");
				break;
			case '\r':
				sb.append("\\r");
				break;
			case '\t':
				sb.append("\\t");
				break;
			case '/':
				sb.append("\\/");
				break;
			default:
				// Reference: http://www.unicode.org/versions/Unicode5.1.0/
				if ((ch >= '\u0000' && ch <= '\u001F') || (ch >= '\u007F' && ch <= '\u009F')
						|| (ch >= '\u2000' && ch <= '\u20FF')) {
					String ss = Integer.toHexString(ch);
					sb.append("\\u");
					for (int k = 0; k < 4 - ss.length(); k++) {
						sb.append('0');
					}
					sb.append(ss.toUpperCase());
				} else {
					sb.append(ch);
				}
				break;
			}
		}
	}
}
