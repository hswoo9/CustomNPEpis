package com.duzon.custom.common.utiles;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Value;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class CommonUrl {
	@Value("#{bizboxa['BizboxA.domain']}")
	private String domain;
	
    private final String boundary =  "*****";
    private final String crlf = "\r\n";
    private final String twoHyphens = "--";
    
    private HttpPost post;
    private MultipartEntityBuilder meb;
    public CommonUrl() {
//    	System.out.println(domain);
    	post = new HttpPost("http://" + domain + "/gw/outProcessUpload.do");
    	//post = new HttpPost("http://" + "gw.st-tech.org" + "/gw/outProcessUpload.do");
    	meb = MultipartEntityBuilder.create();
    	meb.setBoundary(boundary);  
    	meb.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);  
    	meb.setCharset(Charset.forName("UTF-8"));
    	
    }
    public CommonUrl(String domain) {
//    	System.out.println(domain);
    	//post = new HttpPost("http://" +  "gw.st-tech.org" + "/gw/outProcessUpload.do");
    	post = new HttpPost("http://" +  domain + "/gw/outProcessUpload.do");
    	meb = MultipartEntityBuilder.create();
    	meb.setBoundary(boundary);  
    	meb.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);  
    	meb.setCharset(Charset.forName("UTF-8"));
    	
    }
    public void urlTxt(String fileNm, String txt) {
    	meb.addTextBody(fileNm, txt);
	}
    
    public void urlFile(String fileNm, File file) {
    	FileBody cbFile = new FileBody(file, ContentType.MULTIPART_FORM_DATA, fileNm);
    	meb.addPart(fileNm, cbFile);
	}
    public void _urlFile(String fileNm, File file) {
    	FileBody cbFile = new FileBody(file);
    	meb.addPart(fileNm, cbFile);
	}
    
    public String finish() {
    	HttpEntity entity = meb.build();  
    	post.setEntity(entity);
    	HttpResponse response;
    	String result = "";
    	
    	HttpClient client = HttpClientBuilder.create().build();
    	try {
    		response = client.execute(post);
    		result = EntityUtils.toString(response.getEntity());
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	Gson gson = new Gson(); 
		Map<String, Object> jsonObject = gson.fromJson((String) result,new TypeToken<Map<String, Object>>(){}.getType() );
    	
		if(jsonObject == null){
			return "";
		}else{
			return (String) jsonObject.get("fileKey");
		}
		
	}
    
    
    
    
    
    public static void main(String[] args) throws ClientProtocolException, IOException {
    	CommonUrl commonUrl = new CommonUrl();
    	
    	HttpPost post = new HttpPost("http://gwa.tpf.kro.kr/gw/CustEncLogOn.do");
    	
    	MultipartEntityBuilder meb = MultipartEntityBuilder.create();
    	
    	meb.setBoundary(commonUrl.boundary);  
    	meb.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);  
    	meb.setCharset(Charset.forName("UTF-8"));
    	meb.addTextBody("ssoKey", "Y");
    	
    	HttpEntity entity = meb.build();  
    	post.setEntity(entity);
    	
    	HttpClient client = HttpClientBuilder.create().build();
    	HttpResponse response = client.execute(post);
//    	System.out.println(EntityUtils.toString(response.getEntity()));
    	commonUrl.finish();
    }

}
