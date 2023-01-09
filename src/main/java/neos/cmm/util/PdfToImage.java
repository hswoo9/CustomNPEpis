package neos.cmm.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;

import egovframework.com.utl.fcc.service.EgovFormBasedFileUtil;

public class PdfToImage implements FileConvert {
    
    
    public boolean fileConvert(String filePathName, String destFilePathName) throws Exception {
        //임시주석
    	boolean result = false;
        try{
        	String filePath = filePathName.substring(0, filePathName.lastIndexOf(EgovFormBasedFileUtil.SEPERATOR)+1);
        	String keyCode = filePathName.substring(filePathName.lastIndexOf(EgovFormBasedFileUtil.SEPERATOR)+1, filePathName.lastIndexOf("."));
        	int point = destFilePathName.lastIndexOf('.') ;
        	String extS = ".";
        	String ext = destFilePathName.substring(point+1, destFilePathName.length() ) ;
//        	System.out.println("fileConvert :: " + filePathName + " :: " + destFilePathName + " :: " + filePath + " :: " + keyCode + " :: " + ext);
        	int width = 0;
        	int height = 0;
        
        	PDDocument document = PDDocument.load(new File(filePathName));
        
        	File file = new File(filePathName);
        	long size = file.length() ;  // 파일 사이즈
        	long pdfSize = document.getNumberOfPages();   //pdf총 페이지수 가져오기 
        
        	// 용량 체크 10MB 이하일떄만
	        if(size > 10240000){
	        	result = false;
	        	return result;
	        }
        	// 페이지 수 체크 20page 이하일때        
	        if(pdfSize > 20 ){
	        	result = false;
	        	return result;
	        }
        
	        PDFRenderer pdfRenderer = new PDFRenderer(document);
	        for (int page = 0; page < document.getNumberOfPages(); ++page)
	        { 
	            BufferedImage bim = pdfRenderer.renderImageWithDPI(page, 300, ImageType.RGB);
	            System.out.println("writeImage::" +keyCode + (page+1) + ".jpg");
	            ImageIOUtil.writeImage(bim, filePath + keyCode + (page+1) + ".jpg", 300);
	        }
            document.close();
            

            
            if(  size / pdfSize > 3800000  ) return false ;
            String fileName = "";
            List<String> list = new ArrayList<String>();
            for(int i=1; i <= pdfSize; i ++){
                fileName = keyCode + Integer.toString(i);
                list.add(filePath + fileName + extS +ext);
                System.out.println("ImageIO::" + filePath + fileName + extS +ext);
                BufferedImage img = ImageIO.read(new File(filePath+fileName+extS+ext));
                width = Math.max(width, img.getWidth());
                height += img.getHeight();
            }
            String[] tt = list.toArray(new String[list.size()]);
                
            try{
                result = imageMerge(tt, filePath+keyCode+extS+ext);
            }catch(Exception e){
                e.printStackTrace();
                result = false;
            }
            
        }catch(Exception e){
        	result = false;
            System.out.println("fileConvert::" + e);
            e.printStackTrace();
        }
        return result;
    	/**pdf등록***/
		
    	/**
		File file = new File(filePathName);
		RandomAccessFile raf = new RandomAccessFile(file, "r");
		FileChannel channel = raf.getChannel();
		ByteBuffer buf = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
		PDFFile pdffile = new PDFFile(buf);
		

		List<String> list = new ArrayList<String>();
		for(int i = 0; i < pdffile.getNumPages(); i ++){
			PDFPage page = pdffile.getPage(i+1, true);
			Rectangle rect = new Rectangle(0, 0,
                    (int) page.getBBox().getWidth(),
                    (int) page.getBBox().getHeight());
 
            Image img = page.getImage(
                    rect.width, rect.height, //width & height
                    rect, // clip rect
                    null, // null for the ImageObserver
                    true, // fill background with white
                    true // block until drawing is done
                    );
            
            BufferedImage bufferedImage = new BufferedImage(rect.width, rect.height, BufferedImage.TYPE_INT_RGB);
            Graphics g = bufferedImage.createGraphics();
            g.drawImage(img, 0, 0, null);
            g.dispose();
            
            String filePath = filePathName.substring(0, filePathName.lastIndexOf(EgovFormBasedFileUtil.SEPERATOR)+1);
            String keyCode = filePathName.substring(filePathName.lastIndexOf(EgovFormBasedFileUtil.SEPERATOR)+1, filePathName.lastIndexOf("."));
            File asd = new File(filePath + keyCode + "_" + i + ".jpg");
            list.add(filePath + keyCode + "_" + i + ".jpg");
            if (asd.exists()) {
                asd.delete();
            }
            ImageIO.write(bufferedImage, "jpg", asd);
		}
		String[] tt = list.toArray(new String[list.size()]);
        
        try{
        	result = imageMerge(tt, destFilePathName);
        }catch(Exception e){
            e.printStackTrace();
        }
        return result;
        **/
    }
    
    /*@Override
    public boolean fileConvert(String filePathName, String destFilePathName) throws Exception {
        boolean result = false;
        PDDocument pdfDocument = new PDDocument();
        try{
        //String filePathName = "d:/upload/ea/doc/documentDir/10007/2017/05/18/1815.pdf";
        String filePath = filePathName.substring(0, filePathName.lastIndexOf(EgovFormBasedFileUtil.SEPERATOR)+1);
        String keyCode = filePathName.substring(filePathName.lastIndexOf(EgovFormBasedFileUtil.SEPERATOR)+1, filePathName.lastIndexOf("."));
        int point = destFilePathName.lastIndexOf('.') ;
        String extS = ".";
        String ext = destFilePathName.substring(point+1, destFilePathName.length() ) ;
        System.out.println("fileConvert :: " + filePathName + " :: " + destFilePathName + " :: " + filePath + " :: " + keyCode + " :: " + ext);
        int width = 0;
        int height = 0;
        
        
        File file = new File(filePathName);
        long size = file.length() ;
        //너무 큰파일경우 OOM 막기위해  PDF 파일을 이미지 로 변환을 안함.
        if( size > 15480000)  {
            return false ;
        }
        
        pdfDocument =  PDDocument.load(file); //1. pdf파일 로드\
        
        String[] cmd = new String[]{"java", "-jar", "/home/neos/tomcat/webapps/ea/WEB-INF/classes/neos/cmm/utilpdfbox-app-2.0.6.jar", "PDFToImage", filePathName};
        
        CommonUtil.executeProcess(cmd, filePath);  //jar실행으로 페이지별 jpg생성
        
        
        int pdfSize = pdfDocument.getNumberOfPages();   //pdf총 페이지수 가져오기            
        if(  size / pdfSize > 3800000  ) return false ;
            
        String fileName = "";
        List<String> list = new ArrayList<String>();
        for(int i=1; i <= pdfSize; i ++){
            fileName = keyCode + Integer.toString(i);
            list.add(filePath + fileName + extS +ext);
            BufferedImage img = ImageIO.read(new File(filePath+fileName+ext));
            width = Math.max(width, img.getWidth());
            height += img.getHeight();
        }
        String[] tt = list.toArray(new String[list.size()]);
            
        try{
            result = imageMerge(tt, filePath+keyCode+extS+ext);
        }catch(Exception e){
            e.printStackTrace();
            result = false;
        }
        }catch(Exception e){
            System.out.println(e);
            result = false;
        }finally{
            if(pdfDocument != null) pdfDocument.close();
        }
        return result;
    }*/
    
    public boolean imageMerge( String[] imageFilePathName, String mergeImageFilePathName) throws Exception {
        boolean result = false;
        int rowNum = imageFilePathName.length ;
        BufferedImage[] arrBufferedImage = new BufferedImage[rowNum];
        int point = mergeImageFilePathName.lastIndexOf('.') ;
        String ext = mergeImageFilePathName.substring(point+1, mergeImageFilePathName.length()) ;
        BufferedImage mergedImage= null ;
        File file = null ;

        int width = 0;
        int height = 0;
        
        Graphics2D graphics =  null ;
        File mergeImageFile =  null ;
        List<Integer> widList = new ArrayList<Integer>();
        try {
            for(int inx =0 ; inx <rowNum; inx++) {
                System.out.println("imageMerge : " + imageFilePathName[inx] + " :: " + mergeImageFilePathName);
                file = new File(imageFilePathName[inx] ) ;
                arrBufferedImage[inx] = ImageIO.read(file);
                widList.add(inx, arrBufferedImage[inx].getWidth());
                width = Math.max(width, arrBufferedImage[inx].getWidth());
                height += arrBufferedImage[inx].getHeight();
                file.delete();
            }
            
            mergedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            graphics = (Graphics2D) mergedImage.getGraphics();
            graphics.setBackground(Color.WHITE);
            
            graphics.fillRect(0,0,width,height);
            
            
            height = 0 ;
            int pageWidth = 0;
            for( int inx = 0 ; inx < rowNum; inx++) {
                pageWidth = widList.get(inx);
                if(inx == 0) {
                    graphics.drawImage(arrBufferedImage[inx], (width - pageWidth)/2, 0, null);
                }else {
                    height += arrBufferedImage[inx-1].getHeight();
                    graphics.drawImage(arrBufferedImage[inx], (width - pageWidth)/2, height, null);
                }
            }
            
            mergeImageFile = new File(mergeImageFilePathName);
            if (mergeImageFile.isFile()) {
                mergeImageFile.delete() ;
            }
            result = ImageIO.write(mergedImage, ext, mergeImageFile);
            graphics.dispose();
        }catch(Exception e ) {
            result = false;
            e.printStackTrace() ;
            if(graphics != null ) {
                try {graphics.dispose();}catch(Exception ignore) {}
            }
            
        }finally{
            if(graphics != null ) {
                try {graphics.dispose();}catch(Exception ignore) {}
            }                
        }
        return result;
    }
    

	/*@Override
	public boolean fileConvert(String filePathName, String destFilePathName) throws Exception {

   	  int point = destFilePathName.lastIndexOf('.') ;
   	  String ext = destFilePathName.substring(point+1, destFilePathName.length() ) ;
   	  String nonExtFileName = destFilePathName.substring(0,point);
   	  
   	  String imageFormat = ext; //jpg와 png를 지원한다.
   	  String savePath = nonExtFileName+"_" ;
   	  
      File file = null ;
      RandomAccessFile raf = null ;
      PDFPage page= null ; 
      List<PDFPage> pageList = new ArrayList();
      Graphics2D g2 = null; 
      ByteBuffer buf = null ;
      boolean result = false ;
      int startPageNum =1  ;
      int endPageNum = 0 ;
      BufferedImage bi = null ;
      int convertWith = 1200 ;
      int convertHeight = 1400;
      try {
    	  file = new File(filePathName);
    	  long size = file.length() ;
       	  //너무 큰파일경우 OOM 막기위해  PDF 파일을 이미지 로 변환을 안함.
       	  if( size > 15480000)  {
       		  return false ;
       	  }
       	  
          raf = new RandomAccessFile(file, "r");
          byte[] b = new byte[(int)raf.length()];
          raf.readFully(b);
          buf = ByteBuffer.wrap(b);
          PDFFile pdfFile = new PDFFile(buf);
         
          endPageNum = pdfFile.getNumPages();
          
      	  //너무 큰파일경우 OOM 막기위해  PDF 파일을 이미지 로 변환을 안함.
          if(  size / endPageNum > 3800000  ) return false ;
       	 
          int height = 0 ;
          int width = 0 ;
          
          //startPageNum 이 0 또는 1 은 1page 가져온다.
          startPageNum =1 ;
	      for( ; startPageNum <= endPageNum; startPageNum ++) {
	    	  
	    	  page = pdfFile.getPage(startPageNum);

	    	  width = Math.max(width, (int)page.getBBox().getWidth());
	    	  height +=  (int)page.getBBox().getHeight();
	    	  pageList.add(page);
	      }
	      
//	      bi = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
	      bi = new BufferedImage(convertWith, convertHeight*endPageNum, BufferedImage.TYPE_INT_RGB);
	      g2 = bi.createGraphics();

	      height = 0;
	      //pageList은0 부터 시작.
	      startPageNum = 0 ;
	      for( ; startPageNum < endPageNum; startPageNum ++) {
		      
		      page =pageList.get(startPageNum) ;
		     
	          //get the width and height for the doc at the default zoom 
	          Rectangle rect = new Rectangle(0,0, (int)page.getBBox().getWidth(), (int)page.getBBox().getHeight());
	          
				int rotation=page.getRotation();

				Rectangle rect1=rect;
				if(rotation==90 || rotation==270)
					rect1=new Rectangle(0,0,rect.height,rect.width);
				
				Image image = page.getImage(
//	                  rect.width, rect.height, //width & height
					  convertWith, convertHeight, //width & height
	                  rect1, // clip rect
	                  null, // null for the ImageObserver
	                  true, // fill background with white
	                  true  // block until drawing is done
	                  );
              
	          g2.drawImage(image, 0,height,  null);
	         
	          height += convertHeight ;

	      }
	      
          g2.dispose();
          ImageIO.write(bi, imageFormat, new File(destFilePathName));
	      result  = true ;
      }catch(Exception e ) {
    	 
    	  e.printStackTrace() ;
      }finally {
    	  if (g2 != null )  try { g2.dispose() ; } catch(Exception ignore){ }
    	
    	  if(buf != null ) {
    		  try { buf.clear() ; } catch(Exception ignore) {}
    		  buf = null ;
    	  }
    	  if(bi != null ) {
    		  bi = null ;
    	  }
    	  if(raf != null )  try { raf.close() ; } catch(Exception ignore){}
      }
//      if(result == true ) {
//	   		 String[] imageFilePathName = new String[endPageNum] ;
//	   		 for(int inx = 0 ; inx < endPageNum ; inx++ ) {
//	   			imageFilePathName[inx] = savePath +(inx+1) +"." + ext ;
//	   		 }
//	   		 CommonUtil.imageMerge(imageFilePathName, destFilePathName) ;
//	   }
      return result ;
	}*/
	
}
