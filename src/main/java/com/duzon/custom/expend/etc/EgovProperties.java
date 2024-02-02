package com.duzon.custom.expend.etc;

import egovframework.com.cmm.EgovWebUtil;
import org.apache.log4j.Logger;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.*;

public class EgovProperties {

    //프로퍼티값 로드시 에러발생하면 반환되는 에러문자열
    public static final String ERR_CODE = " EXCEPTION OCCURRED";
    public static final String ERR_CODE_FNFE = " EXCEPTION(FNFE) OCCURRED";
    public static final String ERR_CODE_IOE = " EXCEPTION(IOE) OCCURRED";
    //파일구분자
    static final char FILE_SEPARATOR = File.separatorChar;
    private static volatile Properties globalPropertis = null;
    //프로퍼티 파일의 물리적 위치
    /*
     * public static final String GLOBALS_PROPERTIES_FILE = System.getProperty("user.home") + System.getProperty("file.separator") + "egovProps" + System.getProperty("file.separator") + "globals.properties";
     */
    //    public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource("").getPath()
    //    + System.getProperty("file.separator") + ".." + System.getProperty("file.separator")
    //    + ".." + System.getProperty("file.separator") + ".." + System.getProperty("file.separator");
    public static final String RELATIVE_PATH_PREFIX = EgovProperties.class.getResource( "" ).getPath( ).substring( 0, EgovProperties.class.getResource( "" ).getPath( ).lastIndexOf( "neos" ) );
    public static final String GLOBALS_PROPERTIES_FILE = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty( "file.separator" ) + "globals.properties";

    //이중체크락. 1.5 버전 이상에만 사용가능, 1.5 버전 이하이면 사용하면안됨.
    private static void init ( ) {
        FileInputStream fis = null;
        try {
            if ( globalPropertis == null ) {
                synchronized ( EgovProperties.class ) {
                    if ( globalPropertis == null ) {
                        globalPropertis = new Properties( );
                        fis = new FileInputStream( EgovWebUtil.filePathBlackList( GLOBALS_PROPERTIES_FILE ) );
                        globalPropertis.load( new java.io.BufferedInputStream( fis ) );
                    }
                }
            }
        }
        catch ( FileNotFoundException fne ) {
            debug( fne );
        }
        catch ( IOException ioe ) {
            debug( ioe );
        }
        catch ( Exception e ) {
            debug( e );
        }
        finally {
            try {
                if ( fis != null )
                    fis.close( );
            }
            catch ( Exception ex ) {
                //ex.printStackTrace();
                //System.out.println("IGNORE: " + ex);	// 2011.10.10 보안점검 후속조치
                Logger.getLogger( EgovProperties.class ).debug( "IGNORED: " + ex.getMessage( ) );
            }
        }
    }

    /**
     * 인자로 주어진 문자열을 Key값으로 하는 상대경로 프로퍼티 값을 절대경로로 반환한다(Globals.java 전용)
     *
     * @param keyName
     *            String
     * @return String
     */
    public static String getPathProperty ( String keyName ) {
        String value = ERR_CODE;
        value = "99";
        debug( GLOBALS_PROPERTIES_FILE + " : " + keyName );
        try {
            init( );
            value = globalPropertis.getProperty( keyName ).trim( );
            value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty( "file.separator" ) + value;
        }
        catch ( Exception e ) {
            debug( e );
        }
        return value;
    }

    /**
     * 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다(Globals.java 전용)
     *
     * @param keyName
     *            String
     * @return String
     */
    public static String getProperty ( String keyName ) {
        String value = ERR_CODE;
        value = "99";
        debug( GLOBALS_PROPERTIES_FILE + " : " + keyName );
        try {
            init( );
            value = globalPropertis.getProperty( keyName ).trim( );
        }
        catch ( Exception e ) {
            debug( e );
        }
        return value;
    }

    /**
     * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 상대 경로값을 절대 경로값으로 반환한다
     *
     * @param fileName
     *            String
     * @param key
     *            String
     * @return String
     */
    public static String getPathProperty ( String fileName, String key ) {
        FileInputStream fis = null;
        try {
            java.util.Properties props = new java.util.Properties( );
            fis = new FileInputStream( EgovWebUtil.filePathBlackList( fileName ) );
            props.load( new java.io.BufferedInputStream( fis ) );
            fis.close( );
            String value = props.getProperty( key );
            value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty( "file.separator" ) + value;
            return value;
        }
        catch ( java.io.FileNotFoundException fne ) {
            return ERR_CODE_FNFE;
        }
        catch ( java.io.IOException ioe ) {
            return ERR_CODE_IOE;
        }
        finally {
            try {
                if ( fis != null )
                    fis.close( );
            }
            catch ( Exception ex ) {
                //ex.printStackTrace();
                debug( ex ); // 2011.10.10 보안점검 후속조치
            }
        }
    }

    /**
     * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다
     *
     * @param fileName
     *            String
     * @param key
     *            String
     * @return String
     */
    public static String getProperty ( String fileName, String key ) {
        FileInputStream fis = null;
        try {
            java.util.Properties props = new java.util.Properties( );
            fis = new FileInputStream( EgovWebUtil.filePathBlackList( fileName ) );
            props.load( new java.io.BufferedInputStream( fis ) );
            fis.close( );
            String value = props.getProperty( key );
            return value;
        }
        catch ( java.io.FileNotFoundException fne ) {
            return ERR_CODE_FNFE;
        }
        catch ( java.io.IOException ioe ) {
            return ERR_CODE_IOE;
        }
        finally {
            try {
                if ( fis != null )
                    fis.close( );
            }
            catch ( Exception ex ) {
                //ex.printStackTrace();
                //System.out.println("IGNORE: " + ex);	// 2011.10.10 보안점검 후속조치
                Logger.getLogger( EgovProperties.class ).debug( "IGNORED: " + ex.getMessage( ) );
            }
        }
    }

    /**
     * 주어진 프로파일의 내용을 파싱하여 (key-value) 형태의 구조체 배열을 반환한다.
     *
     * @param property
     *            String
     * @return ArrayList
     */
    @SuppressWarnings ( { "rawtypes", "unused", "unchecked" } )
    public static ArrayList loadPropertyFile (String property ) {
        // key - value 형태로 된 배열 결과
        ArrayList keyList = new ArrayList( );
        String src = property.replace( '\\', FILE_SEPARATOR ).replace( '/', FILE_SEPARATOR );
        FileInputStream fis = null;
        try {
            File srcFile = new File( EgovWebUtil.filePathBlackList( src ) );
            if ( srcFile.exists( ) ) {
                java.util.Properties props = new java.util.Properties( );
                fis = new FileInputStream( src );
                props.load( new java.io.BufferedInputStream( fis ) );
                fis.close( );
                int i = 0;
                Enumeration plist = props.propertyNames( );
                if ( plist != null ) {
                    while ( plist.hasMoreElements( ) ) {
                        Map map = new HashMap( );
                        String key = (String) plist.nextElement( );
                        map.put( key, props.getProperty( key ) );
                        keyList.add( map );
                    }
                }
            }
        }
        catch ( Exception ex ) {
            //ex.printStackTrace();
            debug( ex ); // 2011.10.10 보안점검 후속조치
        }
        finally {
            try {
                if ( fis != null )
                    fis.close( );
            }
            catch ( Exception ex ) {
                //ex.printStackTrace();
                //System.out.println("IGNORE: " + ex);	// 2011.10.10 보안점검 후속조치
                Logger.getLogger( EgovProperties.class ).debug( "IGNORED: " + ex.getMessage( ) );
            }
        }
        return keyList;
    }

    /**
     * 시스템 로그를 출력한다.
     *
     * @param obj
     *            Object
     */
    private static void debug ( Object obj ) {
        if ( obj instanceof java.lang.Exception ) {
            //((Exception)obj).printStackTrace();
            //System.out.println("DEBUG: " + obj);	// 2011.10.10 보안점검 후속조치
            Logger.getLogger( EgovProperties.class ).debug( "IGNORED: " + ((Exception) obj).getMessage( ) );
        }
    }

}
