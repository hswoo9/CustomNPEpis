package com.duzon.custom.common.utiles;

import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class BlobToPdfConvert {

    public Map<String, Object> blobToPdfConverter(MultipartFile docFile, Map<String, Object> params, String base_dir){
        Map<String, Object> result = new HashMap<>();

        try {
            String fileUUID = randomUUID(params.get("docFileName").toString());
            String docFilepath = approveDocFilePath(params, base_dir);

            InputStream inputStream = new ByteArrayInputStream(docFile.getBytes());
            File newPath = new File(docFilepath);
            if (!newPath.exists()) {
                newPath.mkdirs();
            }

            Path path = Paths.get(docFilepath + fileUUID);
            Files.copy(inputStream, path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});

            result.put("empSeq", params.get("empSeq"));
            result.put("fileCd", params.get("menuCd"));
            result.put("fileUUID", fileUUID);
            result.put("filePath", docFilepath);
            result.put("fileOrgName", params.get("docFileName").toString().split("[.]")[0]);
            result.put("fileExt", params.get("docFileName").toString().split("[.]")[1]);
            result.put("fileSize", docFile.getBytes().length);

        } catch (IOException var6) {
            var6.printStackTrace();
        }

        return result;
    }

    public Map<String, Object> blobToPdfConverterApproveNRefer(MultipartFile docFile, Map<String, Object> params){
        Map<String, Object> result = new HashMap<>();

        try {
            String docFileName = params.get("docFileName").toString();
            String docFilepath = params.get("docFilePath").toString();

            CommonUtil2 commonUtil = new CommonUtil2();
            boolean isDelete = commonUtil.deleteFile(new String[]{params.get("docFileName").toString()}, params.get("docFilePath").toString());

            if(isDelete){
                InputStream inputStream = new ByteArrayInputStream(docFile.getBytes());
                Path path = Paths.get(docFilepath + docFileName);
                Files.copy(inputStream, path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});

                result.put("empSeq", params.get("approveEmpSeq"));
                result.put("fileNo", params.get("fileNo"));
                result.put("fileSize", docFile.getBytes().length);
            }else{
                throw new IOException();
            }
        } catch (IOException var6) {
            var6.printStackTrace();
        }

        return result;
    }

    public String randomUUID(String str) {
        String extension = str.substring(str.lastIndexOf("."), str.length());
        UUID uuid = UUID.randomUUID();
        String strUUID = uuid.toString().toString().replaceAll("-", "") + extension;
        return strUUID;
    }

    public String approveDocFilePath(Map<String, Object> params, String base_dir){
        LocalDate now = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        String fmtNow = now.format(fmt);
        String path = base_dir + "approveDocFile/" + params.get("menuCd").toString()+"/" + fmtNow + "/";

        return path;
    }
}
