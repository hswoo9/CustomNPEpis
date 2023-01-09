package com.duzon.custom.util;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;

public class FileDownload {
	 /**
     * Disposition 지정하기.
     * 
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
    public static void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);
		
		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;
		
		if (browser.equals("MSIE")) {
		    encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
		    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
		    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
		    StringBuffer sb = new StringBuffer();
		    for (int i = 0; i < filename.length(); i++) {
			char c = filename.charAt(i);
			if (c > '~') {
			    sb.append(URLEncoder.encode("" + c, "UTF-8"));
			} else {
			    sb.append(c);
			}
		    }
		    encodedFilename = sb.toString();
		} else {
		    //throw new RuntimeException("Not supported browser");
		    throw new IOException("Not supported browser");
		}
		
		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);
	
		if ("Opera".equals(browser)){
		    response.setContentType("application/octet-stream;charset=UTF-8");
		}else if (browser.equals("MSIE")) {
			response.setContentType( "application/x-msdownload" );
		}
    }

	public static void  getImageView(HttpServletResponse response, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				//e.printStackTrace();
			}
			String type = "";
			int point = fileName.lastIndexOf(".") ;
			String ext = fileName.substring(point+1, fileName.length() );
			if (ext != null && !"".equals(ext)) {
			    if ("jpg".equals(ext.toLowerCase())) {
			    	type = "image/jpeg";
			    } else {
			    	type = "image/" + ext.toLowerCase();
			    }
			} else {
			    //LOG.debug("Image fileType is null.");
			}
			response.setContentType( type );
			if(file != null)
				response.setHeader( "Content-Length", file.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
	}
	public static void  download(HttpServletResponse response, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				e.printStackTrace();
			}

			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(fileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null)
				response.setHeader( "Content-Length", file.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
	}
	
	public static void  downloadImg(HttpServletResponse response , HttpServletRequest request, String filePathName, String fileName ) throws UnsupportedEncodingException {
        File file = null;
        FileInputStream fis = null;

        BufferedInputStream in = null;
        ByteArrayOutputStream bStream = null;

        try {
            file = new File(filePathName);


            fis = new FileInputStream(file);

            in = new BufferedInputStream(fis);
            bStream = new ByteArrayOutputStream();

            int imgByte;
            while ((imgByte = in.read()) != -1) {
            	bStream.write(imgByte);
            }
            
            String type = "";
            int point = 0 ;
			point =  fileName.lastIndexOf(".") ;
			String ext = fileName.substring(point+1);
			
            if (!CustStringUtil.isEmpty(ext)) {
                if ("jpg".equals(ext.toLowerCase())) {
                	type = "image/jpeg";
                } else {
                	type = "image/" + ext.toLowerCase();
                }

            } else {
                //LOG.debug("Image fileType is null.");
            }

            response.setHeader("Content-Type", type);
            response.setContentLength(bStream.size());

            bStream.writeTo(response.getOutputStream());

            response.getOutputStream().flush();
            response.getOutputStream().close();

            // 2011.10.10 보안점검 후속조치 끝
        }
        catch (Exception e) {
        	e.printStackTrace() ;
		}
        finally {
            if (bStream != null) {
                try {
                    bStream.close();
                } catch (Exception ignore) {
                    //System.out.println("IGNORE: " + ignore);
                  
                }
            }
            if (in != null) {
                try {
                    in.close();
                } catch (Exception ignore) {
                    //System.out.println("IGNORE: " + ignore);
                  
                }
            }
            if (fis != null) {
                try {
                    fis.close();
                } catch (Exception ignore) {
                    //System.out.println("IGNORE: " + ignore);
                    
                }
            }
        }
	}
	public static void  download(HttpServletResponse response , HttpServletRequest request, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				//e.printStackTrace();
			}

			FileDownload.setDisposition(fileName,  request, response);
			
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null)
				response.setHeader( "Content-Length", file.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
	}
	
	public static void  download2(HttpServletResponse response, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				//e.printStackTrace();
			}

			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ URLEncoder.encode(fileName, "utf-8") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null)
				response.setHeader( "Content-Length", file.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
	}
	
	public static void outputStream(HttpServletResponse response,FileInputStream in ) throws Exception {
		ServletOutputStream binaryOut = response.getOutputStream();
		byte buffer[] = new byte[8 * 1024];
		
		try {
			IOUtils.copy(in, binaryOut);
			binaryOut.flush();
		} catch ( Exception e ) {
		} finally {
			if (in != null) {
				try {
				in.close();
				}catch(Exception e ) {}
			}
			if (binaryOut != null) {
				try {
					binaryOut.close();
				}catch(Exception e ) {}
			}
		}	
	}
	
	public static  String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "Firefox";
    }
}
