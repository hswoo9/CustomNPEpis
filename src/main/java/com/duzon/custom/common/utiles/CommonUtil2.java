package com.duzon.custom.common.utiles;

import org.apache.commons.codec.binary.Base64;

import java.io.File;
import java.security.MessageDigest;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

public class CommonUtil2 {

    /**
     * 비밀번호를 암호화하는 기능(복호화가 되면 안되므로 SHA-256 인코딩 방식 적용)
     *
     * @param password 암호화될 패스워드
     * @param id salt로 사용될 사용자 ID 지정
     * @return
     * @throws Exception
     */
    public static String encryptPassword(String password, String id) throws Exception {

        if (password == null) {
            return "";
        }

        byte[] hashValue = null; // 해쉬값

        MessageDigest md = MessageDigest.getInstance("SHA-256");

        md.reset();
        md.update(id.getBytes());

        hashValue = md.digest(password.getBytes());

        return new String(Base64.encodeBase64(hashValue));
    }

    public static String filePath(Map<String, Object> params, String base_dir){
        LocalDate now = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        String fmtNow = now.format(fmt);

        String path = base_dir + params.get("menuCd").toString()+"/" + fmtNow + "/";

        return path;
    }

    public boolean deleteFile(String[] fileNames, String filePath) {
        boolean returnFlag = true;

        // 파일경로
        if(fileNames != null && fileNames.length > 0){
            for(int i = 0 ; i < fileNames.length; i++){
                File orifile = new File(filePath + fileNames[i]);
                // 파일이 있는경우 삭제
                if(orifile.exists()){
                    boolean deleteFlag = orifile.delete();
                    // 삭제 체크
                    if(!deleteFlag){
                        returnFlag = false;
                        break;
                    }
                }
            }
        }

        return returnFlag;
    }
}
