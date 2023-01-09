package com.duzon.custom.vacationApply.service.impl;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.map.HashedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.vacationApply.dao.vacationApplyDAO;
import com.duzon.custom.vacationApply.service.vacationApplyService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Service
public class vacationApplyServiceImpl implements vacationApplyService{
	
	private static final Logger logger = LoggerFactory.getLogger(vacationApplyServiceImpl.class);
	
	@Autowired
	private vacationApplyDAO vacationApplyDAO;
	
	@Autowired
	private CommonService commonService;
	
	@Value("#{bizboxa['BizboxA.fileRootPath']}")
	private String fileRootPath;
	
	@Override
	public List<Map<String, Object>> viewUserInfo(Object viewUserInfo){
		
		Map<String, Object> result = new HashMap<String,Object>();
		result.put("viewInfo", vacationApplyDAO.viewUserInfo(viewUserInfo));
		return vacationApplyDAO.viewUserInfo(viewUserInfo);
	}

	@Override
	public Map<String, Object> codeList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.codeList(map));
		result.put("totalCount", vacationApplyDAO.codeListTotal(map));
		
		return result;
	}
	
	@Override
	public boolean codeDuplChk( Map<String, Object> map) {
		boolean msg = false;
		
		if(vacationApplyDAO.codeDuplChk(map) == 0) {
			msg = true;
		}else {
			msg = false;
		}
		
		return msg;
	}
	
	@Override
	public void codeAdd( Map<String, Object> map) {
		
		if(map.get("tableName").equals("dj_cc_type")) {
			vacationApplyDAO.codeCCRegister(map);
		}else {
			vacationApplyDAO.codeRPRegister(map);
		}

	}
	
	@Override
	public void codeDelete( Map<String, Object> map) {
		
		if(map.get("tableName").equals("dj_cc_type")) {
			vacationApplyDAO.codeCCDelete(map);
		}else if(map.get("tableName").equals("dj_cc_type")){
			vacationApplyDAO.codeRPDelete(map);
		}else if(map.get("tableName").equals("dj_cc_type")){
			vacationApplyDAO.codeSCHDelete(map);
		}else{
			vacationApplyDAO.codeCFDelete(map);
		}
	}
	
	@Override
	public Map<String, Object> ccDetailList( Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.ccDetailList(map));
		result.put("totalCount", vacationApplyDAO.ccDetailListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> spDetailList( Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.spDetailList(map));
		result.put("totalCount", vacationApplyDAO.spDetailListTotal(map));
		
		return result;
	}
	
	@Override
	public void ccDetailRegister( Map<String, Object> map) {
		vacationApplyDAO.ccDetailRegister(map);
	}
	
	@Override
	public void ccDetailModify( Map<String, Object> map) {
		vacationApplyDAO.ccDetailModify(map);
	}
	
	@Override
	public void ccDetailDelete( Map<String, Object> map) {
		vacationApplyDAO.ccDetailDelete(map);
	}
	
	@Override
	public void spDetailRegister( Map<String, Object> map) {
		vacationApplyDAO.spDetailRegister(map);
	}
	
	@Override
	public void spDetailModify( Map<String, Object> map) {
		vacationApplyDAO.spDetailModify(map);
	}
	
	@Override
	public void spDetailDelete( Map<String, Object> map) {
		vacationApplyDAO.spDetailDelete(map);
	}
	
	@Override
	public Map<String, Object> ccApplyList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.ccApplyList(map));
		result.put("totalCount", vacationApplyDAO.ccApplyListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> ccApplySave( Map<String, Object> map) {
		
		if(map.get("status").equals("insert")) {
			return vacationApplyDAO.ccApplySaveInsert(map);
		}else {
			return vacationApplyDAO.ccApplySaveUpdate(map);
		}
		
	}
	
	@Override
	public void ccApplyDeleteRow( Map<String, Object> map) {
		vacationApplyDAO.ccApplyDeleteRow(map);
	}
	
	@Override
	public Map<String, Object> famliyApplyList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.famliyApplyList(map));
		result.put("totalCount", vacationApplyDAO.famliyApplyListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> scholarApplyList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.scholarApplyList(map));
		result.put("totalCount", vacationApplyDAO.scholarApplyListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> scholarApplyDetailList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.scholarApplyDetailList(map));
		
		return result;
	}

	@Override
	public Map<String, Object> scholarDetailList( Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.scholarDetailList(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> scholarApplySave( Map<String, Object> map) {
		
		Gson gson = new Gson(); 
//		List<Map<String, Object>> scholarApplyList = gson.fromJson((String) map.get("data"),new TypeToken<List<Map<String, Object>>>(){}.getType());
		
		
		if(map.get("status").equals("insert")) {
			Map<String, Object> result =  vacationApplyDAO.scholarApplySaveInsert(map);
			
//			for (Map<String, Object> vo : scholarApplyList) {
//				vo.put("education_expense_id", map.get("education_expense_id"));
//				vacationApplyDAO.scholarApplyDetailSave(vo);
//			}
			
			return result;
			
		}else {
			
			Map<String, Object> result =  vacationApplyDAO.scholarApplyUpdate(map);
//			vacationApplyDAO.scholarApplyDetailUpdate(map);
//			
//			for (Map<String, Object> vo : scholarApplyList) {
//				
//				vacationApplyDAO.scholarApplyDetailSave(vo);
//			}
			
			return result;
		}
		
	}
	
	@Override
	public void scholarApplyDeleteRow( Map<String, Object> map) {
		vacationApplyDAO.scholarApplyDeleteRow(map);
//		vacationApplyDAO.scholarApplyDeleteDetail(map);
	}
	
	@Override
	public Map<String, Object> scholarApprovalUpdate(Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> approData = gson.fromJson((String) map.get("approData"),new TypeToken<List<Map<String, Object>>>(){}.getType());

		for (Map<String, Object> vo : approData) {
			vacationApplyDAO.scholarApprovalUpdate(vo);
		}
		return map;
	}
	
	@Override
	public Map<String, Object> scholarApprovalCancle(Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> approData = gson.fromJson((String) map.get("approData"),new TypeToken<List<Map<String, Object>>>(){}.getType());

		for (Map<String, Object> vo : approData) {
			vacationApplyDAO.scholarApprovalCancle(vo);
		}
		return map;
	}
	
	@Override
	public Map<String, Object> scholarApplyFileSave(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception {
		// TODO Auto-generated method stub
		
		
		List<MultipartFile> fileList = multi.getFiles("file");
		int fileSeq = 0;
		int result = 0;
		for(MultipartFile mFile : fileList) {
			String fileName = mFile.getOriginalFilename();
			result = fileUploadService(fileSeq++, mFile, map);
			map.put("report_id", map.get("attach_file_id"));

		}

		map.put("code", "success");		
		return map;
	}
	
	@Override
	public Map<String, Object> getClubListOperated(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.getClubListOperated(map));
		result.put("totalCount", vacationApplyDAO.getClubListOperatedTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> getClubMemberList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.getClubMemberList(map));
		result.put("totalCount", vacationApplyDAO.getClubMemberListTotal(map));
		
		return result;
	}
	
	
	
	@Override
	public Map<String, Object> clubSave( Map<String, Object> map) {
		
		if(map.get("status").equals("insert")) {
			
			vacationApplyDAO.clubSaveInsert(map);
			return vacationApplyDAO.clubDetailSaveInsert(map);
		}else {
			return vacationApplyDAO.clubSaveUpdate(map);
		}
		
	}
	
	@Override
	public Map<String, Object> clubDetailSaveInsert( Map<String, Object> map) {
		
		return vacationApplyDAO.clubDetailSaveInsert(map);

	}
	
	@Override
	public Map<String, Object> getMedicalSubsidyApplyList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.getMedicalSubsidyApplyList(map));
		result.put("totalCount", vacationApplyDAO.getMedicalSubsidyApplyListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> medicalSubsidyApply(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception {
		// TODO Auto-generated method stub
		
		
		if(map.get("medical_id").equals("")||map.get("medical_id") == null) {
			List<MultipartFile> fileList = multi.getFiles("file");
			int fileSeq = 0;
			int result = 0;
			for(MultipartFile mFile : fileList) {
				String fileName = mFile.getOriginalFilename();
				if(fileName.equals("")) {
					continue;
				}else {
					map.put("file_yn", "Y");
					int n = vacationApplyDAO.medicalSubsidyApplyInsert(map);
					if(n>0) {
						map.put("target_id", map.get("medical_id"));
						result = fileUploadService(fileSeq++, mFile, map);
						map.put("report_id", map.get("attach_file_id"));
						
					}else {
						result = -1;
					}
				}
			}
		}else {
			vacationApplyDAO.medicalSubsidyApplyUpdate(map);
		}

		map.put("code", "success");		
		return map;
	}
	
	@Override
	public void medicalSubsidyDeleteRow( Map<String, Object> map) {
		vacationApplyDAO.medicalSubsidyDeleteRow(map);
	}
	
	@Override
	public Map<String, Object> medicalApprovalUpdate(Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> approData = gson.fromJson((String) map.get("approData"),new TypeToken<List<Map<String, Object>>>(){}.getType());

		for (Map<String, Object> vo : approData) {
			vacationApplyDAO.medicalApprovalUpdate(vo);
		}
		return map;
	}
	
	@Override
	public Map<String, Object> medicalApprovalCancle(Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> approData = gson.fromJson((String) map.get("approData"),new TypeToken<List<Map<String, Object>>>(){}.getType());

		for (Map<String, Object> vo : approData) {
			vacationApplyDAO.medicalApprovalCancle(vo);
		}
		return map;
	}
	
	@Override
	public void clubRegisterApproval(Map<String, Object> map) {
		
		String clubId = ((String)map.get("approKey")).substring(6);
		map.put("club_id", clubId);
		map.put("active", "Y");
		vacationApplyDAO.updateClubMainStatus(map);
//		vacationApplyDAO.updateClubDetailStatus(map);
		
	}
	
	@Override
	public void updateClubDetailStatus(Map<String, Object> map) {
		
		String club_detail_id = ((String)map.get("approKey")).substring(7);
		map.put("club_detail_id", club_detail_id);
		vacationApplyDAO.updateClubDetailStatus(map);
		if(map.get("member_status").equals("2")) {
			vacationApplyDAO.memberCountChange(map);
		}else {
			vacationApplyDAO.memberCountChange(map);
		}
		
	}
	
	@Override
	public int fileUploadService(int fileSeq, MultipartFile mFile, Map<String, Object> map) {
		String fileName = mFile.getOriginalFilename();
		Long fileSize = mFile.getSize();
		String orgFileName = fileName.substring(0, fileName.lastIndexOf("."));
		String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1);
		String subPath = String.valueOf(Calendar.getInstance().get(Calendar.YEAR))
				 + "/" + String.valueOf(Calendar.getInstance().get(Calendar.MONTH) + 1);
		String filePath = fileRootPath +"/vacationApply"+"/"+ subPath + "/";
		File dir = new File(filePath);
		try {
			if(!dir.isDirectory()) {
				dir.mkdirs();
			}
			map.put("file_seq", fileSeq++);
			vacationApplyDAO.fileUploadSave(map);
			mFile.transferTo(new File(filePath + map.get("attach_file_id") + "." +fileExtension));
			map.put("real_file_name", orgFileName);
			map.put("file_extension", fileExtension);
			map.put("file_path", filePath);
			map.put("file_size", fileSize);
			return vacationApplyDAO.fileUpload(map);
		}catch(Exception e) {
			logger.error(e.getMessage());
			return -2;
		}
	}
	
	@Override
	public Map<String, Object> famliyApplySave( Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> familyApplyList = gson.fromJson((String) map.get("data"),new TypeToken<List<Map<String, Object>>>(){}.getType());
		
		
		if(map.get("status").equals("insert")) {
			
			Map<String, Object> result =  vacationApplyDAO.famliyApplySaveInsert(map);
			
			if(map.get("apply_type").equals("1")) {
				for (Map<String, Object> vo : familyApplyList) {
					vo.put("family_apply_id", map.get("family_apply_id"));
					vacationApplyDAO.familyApplyDetailSave(vo);
				}
			}else {
				for (Map<String, Object> vo : familyApplyList) {
					vo.put("family_apply_id", map.get("family_apply_id"));
					vacationApplyDAO.familyDetailLoseApply(vo);
				}
			}

			return result;
			
		}else {
			
			Map<String, Object> result =  vacationApplyDAO.familyApplyUpdate(map);
//			vacationApplyDAO.scholarApplyDetailUpdate(map);
//			
//			for (Map<String, Object> vo : scholarApplyList) {
//				
//				vacationApplyDAO.scholarApplyDetailSave(vo);
//			}
			
			return result;
		}
		
	}
	
	@Override
	public Map<String, Object> famliyApplyFileSave(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception {
		// TODO Auto-generated method stub
		
		
		List<MultipartFile> fileList = multi.getFiles("file");
		int fileSeq = 0;
		int result = 0;
		for(MultipartFile mFile : fileList) {
			String fileName = mFile.getOriginalFilename();
			result = fileUploadService(fileSeq++, mFile, map);
			map.put("report_id", map.get("attach_file_id"));

		}

		map.put("code", "success");		
		return map;
	}
	
	@Override
	public Map<String, Object> familyApplyDetailList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.familyApplyDetailList(map));
		
		return result;
	}
	
	@Override
	public void familyApplyDeleteRow( Map<String, Object> map) {
		vacationApplyDAO.familyApplyDeleteRow(map);
		vacationApplyDAO.familyApplyDeleteDetail(map);
	}
	
	@Override
	public Map<String, Object> familyApprovalUpdate( Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> approData = gson.fromJson((String) map.get("approData"),new TypeToken<List<Map<String, Object>>>(){}.getType());
	
		for (Map<String, Object> vo : approData) {
			vacationApplyDAO.familyApplyApprovall(vo);
			if(vo.get("apply_type").equals("1")) {
				vacationApplyDAO.familyApplyDetailApproval(vo);
			}else {
				vacationApplyDAO.familyLoseDetailApproval(vo);
			}
			List<Map<String, Object>> list = vacationApplyDAO.benefitDeleteData(vo);
			vacationApplyDAO.benefitPreDataDelete(vo);
			for (Map<String, Object> map2 : list) {
				System.out.println(map2.get("payday"));
				vo.put("payday", map2.get("payday"));
				vacationApplyDAO.benefitRebatch(vo);
			}
		}
		return map;
		
	}
	
	@Override
	public Map<String, Object> benefitSave( Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		
		
		
		if(map.get("status").equals("insert")) {
			
			List<Map<String, Object>> benefitList = gson.fromJson((String) map.get("data"),new TypeToken<List<Map<String, Object>>>(){}.getType());
			
			Map<String, Object> result =  vacationApplyDAO.benefitSave(map);
			
			for (Map<String, Object> vo : benefitList) {
				vo.put("benefit_master_main_id", map.get("benefit_master_main_id"));
				vacationApplyDAO.benefitDetailSave(vo);
			}

			return result;
			
		}else {
			
			List<Map<String, Object>> insertData = gson.fromJson((String) map.get("insertData"),new TypeToken<List<Map<String, Object>>>(){}.getType());
			List<Map<String, Object>> updateData = gson.fromJson((String) map.get("updateData"),new TypeToken<List<Map<String, Object>>>(){}.getType());
			List<Map<String, Object>> deleteData = gson.fromJson((String) map.get("deleteData"),new TypeToken<List<Map<String, Object>>>(){}.getType());
			
			
			Map<String, Object> result =  vacationApplyDAO.benefitUpdate(map);
			for (Map<String, Object> vo : insertData) {
				vacationApplyDAO.benefitDetailSave(vo);
			}
			
			for (Map<String, Object> vo : updateData) {
				vacationApplyDAO.benefitDetailUpdate(vo);
			}
			
			for (Map<String, Object> vo : deleteData) {
				vacationApplyDAO.benefitDetailDelete(vo);
			}
			
//			vacationApplyDAO.scholarApplyDetailUpdate(map);
//			
//			for (Map<String, Object> vo : scholarApplyList) {
//				
//				vacationApplyDAO.scholarApplyDetailSave(vo);
//			}
			
			return result;
		}
		
	}
	
	@Override
	public Map<String, Object> benefitList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.benefitList(map));
		result.put("totalCount", vacationApplyDAO.benefitListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> benefitDetailList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.benefitDetailList(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> getBenefitTypeList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.getBenefitTypeList(map));
		result.put("totalCount", vacationApplyDAO.getBenefitTypeListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> getScholarshipManageList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.getScholarshipManageList(map));
		result.put("totalCount", vacationApplyDAO.getScholarshipManageListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> welfareApplyList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.welfareApplyList(map));
		result.put("totalCount", vacationApplyDAO.welfareApplyListTotal(map));
		
		return result;
	}
	
	@Override
	public Map<String, Object> welfareApplySave( Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> familyApplyList = gson.fromJson((String) map.get("data"),new TypeToken<List<Map<String, Object>>>(){}.getType());
		
		
		if(map.get("status").equals("insert")) {
			
			Map<String, Object> result =  vacationApplyDAO.welfareApplySaveInsert(map);
			
			if(map.get("apply_type").equals("1")) {
				for (Map<String, Object> vo : familyApplyList) {
					vo.put("welfare_apply_id", map.get("welfare_apply_id"));
					vacationApplyDAO.welfareApplyDetailSave(vo);
				}
			}else {
				for (Map<String, Object> vo : familyApplyList) {
					vo.put("welfare_apply_id", map.get("welfare_apply_id"));
					vacationApplyDAO.welfareDetailLoseApply(vo);
				}
			}

			return result;
			
		}else {
			
			Map<String, Object> result =  vacationApplyDAO.welfareApplyUpdate(map);
//			vacationApplyDAO.scholarApplyDetailUpdate(map);
//			
//			for (Map<String, Object> vo : scholarApplyList) {
//				
//				vacationApplyDAO.scholarApplyDetailSave(vo);
//			}
			
			return result;
		}
		
	}
	
	@Override
	public Map<String, Object> welfareApplyFileSave(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception {
		// TODO Auto-generated method stub
		
		
		List<MultipartFile> fileList = multi.getFiles("file");
		int fileSeq = 0;
		int result = 0;
		for(MultipartFile mFile : fileList) {
			String fileName = mFile.getOriginalFilename();
			result = fileUploadService(fileSeq++, mFile, map);
			map.put("report_id", map.get("attach_file_id"));

		}

		map.put("code", "success");		
		return map;
	}
	
	@Override
	public Map<String, Object> welfareApplyDetailList(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		result.put("list", vacationApplyDAO.welfareApplyDetailList(map));
		
		return result;
	}
	
	@Override
	public void welfareApplyDeleteRow( Map<String, Object> map) {
		vacationApplyDAO.welfareApplyDeleteRow(map);
		vacationApplyDAO.welfareApplyDeleteDetail(map);
	}
	
	@Override
	public Map<String, Object> welfareApprovalUpdate( Map<String, Object> map) {
		
		Gson gson = new Gson(); 
		List<Map<String, Object>> approData = gson.fromJson((String) map.get("approData"),new TypeToken<List<Map<String, Object>>>(){}.getType());
	
		for (Map<String, Object> vo : approData) {
			vacationApplyDAO.welfareApplyApprovall(vo);
			if(vo.get("apply_type").equals("1")) {
				vacationApplyDAO.welfareApplyDetailApproval(vo);
			}else {
				vacationApplyDAO.welfareLoseDetailApproval(vo);
			}
			List<Map<String, Object>> list = vacationApplyDAO.benefitDeleteData(vo);
			vacationApplyDAO.benefitPreDataDelete(vo);
			for (Map<String, Object> map2 : list) {
				System.out.println(map2.get("payday"));
				vo.put("payday", map2.get("payday"));
				vacationApplyDAO.welrfareBenefitRebatch(vo);
			}
		}
		return map;
		
	}
	
	@Override
	public void familyBenefitMonthBatch() {
		
		Map<String, Object> map = new HashedMap<String, Object>();
		
		vacationApplyDAO.familyBenefitMonthBatch(map);
	}
	
	@Override
	public void welfareBenefitMonthBatch() {
		
		Map<String, Object> map = new HashedMap<String, Object>();
		
		vacationApplyDAO.welfareBenefitMonthBatch(map);
	}
	
	
	
}
