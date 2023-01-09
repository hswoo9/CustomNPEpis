package com.duzon.custom.kukgoh.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpVersion;
import org.apache.commons.httpclient.methods.PostMethod;

public class HttpClientSample {
	
	public Map<String, Object> setClient(String interfaceId, String transactionId, String url) {
		HttpClient httpClient = new HttpClient();
		Map<String, Object> resutMap = new HashMap<String, Object>();
		
		try {
			HttpClientSample httpClientSample = new HttpClientSample();
			// 업무용 WAS 번호(업무용 WAS가 다중화 구성일 경우 WAS의 순번)
			int wasNum = 1;
			// 시스템 코드 - 각 기관 시스템에 부여된 코드
			String systemCode = "EPIS";
			// 인터페이스 ID (사용할 인터페이스 ID를 확인하여 설정)
			//String interfaceId = "IF-EXE-IFR-0001";
			// 호출 url (ex. http://호출URL/esb/HttpListenerServlet")
			// url = "http://192.168.1.80:45000/esb/HttpListenerServlet";
			// 서블리 호출 응답대기 타임아웃(단위 : 1/1000 초)
			int timeout = 0; // ERP 기관에 맞게 수정 가능함. 0일 경우 무한대기함.
			// 송신 메시지 생성
			//Map<String, Object> dataStream = httpClientSample.makeMessage(interfaceId, systemCode, wasNum);
			Map<String, Object> dataStream = new HashMap<String, Object>();
			dataStream.put("intfId", interfaceId); // 인터페이스ID 설정
			dataStream.put("intfTrscId", transactionId); // 트랜잭션ID 설정

			// Map To JSON 변환
			String dataStreamStr = EsbUtils.map2Json(dataStream);
			
			// 국고보조금 전용 연계 에이전트 호출(연계 요청)
			String result = httpClientSample.call(url, timeout, dataStreamStr, httpClient);
			
			System.out.println("result: " + result);
			// 연계 호출 결과 확인
			if (result != null && !"".equals(result)) {
				 resutMap = EsbUtils.json2Map(result);
			} else { // 서블릿 호출 실패
				System.out.println("ERROR");
			}
		} catch (ConnectException e) { // 서블릿 호출 연결 실패
			// 실패 업무 로직 추가
			System.out.println("Connection ERROR: " + e.getMessage());
		} catch (SocketTimeoutException e) { // 서블릿 호출 응답 타임아웃
			// 실패 업무 로직 추가
			System.out.println("SocketTimeout ERROR: " + e.getMessage());
		} catch (Exception e) { // 서블릿 호출 실패
			// 실패 업무 로직 추가
			System.out.println("ERROR: " + e.getMessage());
		}
		return resutMap;
	}

	public String call(String url, int timeout, String dataStream, HttpClient httpClient) throws Exception {
		String result = "";
		PostMethod post = null;
		
		// http 호출
		try {
			post = new PostMethod(url);
			post.getParams().setParameter("http.protocol.version", HttpVersion.HTTP_1_1);
			post.getParams().setParameter("http.protocol.content-charset", "UTF-8");
			post.getParams().setParameter("http.socket.timeout", timeout);
			post.addParameter("dataStream", dataStream);
			int status = httpClient.executeMethod(post);
			if (status == 200) {
				BufferedReader reader = new BufferedReader(new InputStreamReader(post.getResponseBodyAsStream(), post.getResponseCharSet()));
				StringBuffer response = new StringBuffer();
				String line = "";
				while ((line = reader.readLine()) != null) {
				response.append(line);
				}
				result = response.toString();
				reader.close();
			}else {
				// http 호출 실패
				System.out.println("http status code = " + status);
			}
				} catch (Exception e) {
					throw e;
				} finally {
					try {
						post.releaseConnection();
					} catch (Exception e) {
						throw e;
					}
				}
					return result;
			}
	
	
	/**
	 * 송신 데이터 맵 생성(인터페이스ID, 트랜잭션ID를 설정함)
	 */
	private Map<String, Object> makeMessage(String interfaceId, String systemCode, int wasNum) {
		// 송신 맵 생성
		Map<String, Object> dataStream = new HashMap<String, Object>();
		dataStream.put("intfId", interfaceId); // 인터페이스ID 설정
		dataStream.put("intfTrscId", EsbUtils.getTransactionId(interfaceId, systemCode, wasNum)); // 트랜잭션ID 설정
		return dataStream;
	}
}
