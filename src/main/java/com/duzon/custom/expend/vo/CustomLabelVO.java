package com.duzon.custom.expend.vo;


import com.duzon.custom.expend.etc.CommonConvert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomLabelVO {

    private List<Map<String,Object>> source;
    private Map<String,Object> data;
    public CustomLabelVO(List<Map<String,Object>> source ) {
        this.source = source;
        /* aData 설정 */
        setData();
    }

    private void setData(){
        data = new HashMap<>( );

        for(Map<String, Object> item : this.source){
            String txt = "";
            String orgnTxt = item.get( "langName" ).toString( );
            if(!CommonConvert.CommonGetStr(item.get( "tooltip" )).toString( ).equals( "" )){
                // String get = item.get( "tooltip" ).toString( ).replaceAll( "\"", "\\\"" );
                txt = "<span title='"+item.get( "tooltip" )+"'>" +
                        item.get( "langName" ) +
                        "</span>";
            }else {
                txt = item.get( "langName" ).toString( );
            }
            data.put( item.get( "langCode" ).toString( ), txt );
            data.put( "orgn_" + item.get( "langCode" ).toString( ), orgnTxt );

        }
    }
    public Map<String, Object> getData(){
        return this.data;
    }

    @Override
    public String toString(){
        String returnStr = "CustomLabelVO.data : ";
        String mainData = "";
        for(Map<String, Object> item : this.source){
            mainData += ", \"" + item.get( "langCode" ).toString( ) + "\" : \"" + item.get( "langName" ).toString( ) + "\"";
        }
        mainData = mainData.substring( 1 );

        returnStr += "{";
        returnStr += mainData;
        returnStr += "}";
        return returnStr;
    }

}