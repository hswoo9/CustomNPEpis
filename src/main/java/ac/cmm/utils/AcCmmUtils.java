/*
 * Copyright doban7 by Duzon Newturns.,
 * All rights reserved.
 */
package ac.cmm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 
 * @title AcCmmUtils.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
public class AcCmmUtils {
    
    public static String ConvertDate(String datestring)
    {       
        
        String returnDate = "";
        String dateFormat_input = "yyyy-MM-dd";
        String dateFormat_output = "yyyyMMdd";
        SimpleDateFormat format_input = new SimpleDateFormat(dateFormat_input);
        SimpleDateFormat format_output = new SimpleDateFormat(dateFormat_output);
        
        Date date = null;
        try {
            date = format_output.parse(datestring);  
        } catch (Exception e) {
            
        }
        
        if(date!=null)
        {
            returnDate = format_input.format(date);
        }

        return returnDate;  
    }
    
    public static String comma(String str)
    {
        String temp = new StringBuffer(str).reverse().toString();
        String result = "";

       for(int i = 0 ; i < temp.length() ; i += 3) {
            if(i + 3 < temp.length()) {
                result += temp.substring(i, i + 3) + ",";
            }
            else {
                result += temp.substring(i);
            }
        }
       return new StringBuffer(result).reverse().toString();
    }
   
}
 

