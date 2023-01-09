<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
  <title>Document</title>
 </head>
<script type="text/javascript">
var _pHwpCtrl;

var contentsHtml = "${params.contentsHtml}" || "" ;

var allParam = '';

_g_serverName = "<%=request.getServerName()%>" ;
_g_serverPort = "<%=request.getServerPort()%>" ;
var yyyyMM = "${hwpInfo.yyyyMM}";
var sFileName = "${hwpInfo.sFileName}";
var onnaraFileRootPath = "${onnaraFileSubPath}";

$(document).ready(function() {
	
	_pHwpCtrl = document.getElementById("HwpCtrl_1") ;
	
	//_VerifyVersion();
	
	$("#printBtn").click(function () { print(); return false; });
	$("#saveBtn").click(function () { save(); return false; });
	
	 var bRes = _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathChecker");
	 var resultPath = onnaraFileRootPath + "/" + yyyyMM + "/" + sFileName;
	 var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/resAlphaG20/annualSalaryViewDown?filePath=" + resultPath;
	 
	 _pHwpCtrl.Clear(1);               //문서 내용 지움
	_pHwpCtrl.Open(hwpPath,"HWP");
    _pHwpCtrl.EditMode=1;
    _pHwpCtrl.MovePos(2);             //캐럿을 문서 처음으로 이동

    hwpSetToolbar(); // 툴바 설정
	
	if(contentsHtml != ""){
		if(_pHwpCtrl.FieldExist('_F_CONTENTS_')) {
		_pHwpCtrl.MoveToField('_F_CONTENTS_',true,true,false);
    	_pHwpCtrl.SetTextFile(decodeURIComponent($("#contentHtml").val()),'HTML','insertfile');
		}
	}
	    
});

function hwpSetToolbar(){
	//사용자 정의 툴바인데 FileSaveAs 기능 미구현 , HwpCtrlFileSaveAs 도 안됨. 인쇄만 가능
	_pHwpCtrl.SetToolBar(0,"Print");
	_pHwpCtrl.ShowToolBar(true);
}

function saveBtn(args){
	
	//여기서부터는 ea와 세션 연동하여 hwp 로컬 저장->서버upload->서버에upload된 파일을 새 이름으로 저장할수 있도록 팝업이나 text field 있어야 함
	var filePath = "" ;
	var filePathName = _pHwpCtrl.Path() ;
	var point = filePathName.lastIndexOf("\\") ;
	filePath = filePathName.substring(0,point+1);

	var fileName = rndStr("",10);
	var fileNameBak = fileName+"_bak";
	fileName = fileName + ".hwp";
	fileNameBak = fileNameBak + ".hwp";
	var filePathName = filePath + fileName;
	var filePathNameBak = filePath + fileNameBak;
	var srcFilePathName = _pHwpCtrl.Path() ;
	
	//_pHwpCtrl.Save();
	
	var isSave = _pHwpCtrl.SaveAs(filePathName,"HWP");
	_pHwpCtrl.SaveAs(filePathNameBak,"HWP");
	
	if(args == '1'){	//0 : 일반 , 1 : 배포
		_pHwpCtrl.Open(filePathName,"HWP","versionwarning:true") ;
		var vAct = _pHwpCtrl.CreateAction("FileSetSecurity");
	    var vSet = vAct.CreateSet();
	    vAct.GetDefault(vSet);
	    vSet.SetItem("Password", rndStr("",8));       // 패스워드
	    vSet.SetItem("NoPrint", 0);       // 프린트
	    vSet.SetItem("NoCopy", 1);       // 복사
	    if(!vAct.Execute(vSet) ) {
	    	alert("실패");
	    }
		_pHwpCtrl.EditMode = 0 ;
		_pHwpCtrl.MovePos(2);
	}
	
	_pHwpCtrl.Open(filePathNameBak,"HWP","versionwarning:true") ;

	var uploader = document.getElementById('uploader');	
   	uploader.addFile("docFile_1", filePathName);		//서버에 올릴 파일 경로+파일명
	uploader.addParam("upload_file_cnt", 1);			//업로드 파일 갯수 1
	uploader.addParam("file_id", "${ISP_ESTMT_ID}");	//파일 업로드 경로	rootPath+/doc/documentDir/temp
	var uploadUri = _g_contextPath_+"/requestAdmin/tab1FileUpload";
	var result = uploader.sendRequest(_g_serverName, _g_serverPort, uploadUri);
	if(ncCom_Empty(result)) {
		alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
		return false ;
	}else{
		window.close();
	}

}

function cancelBtn(){
	window.close();
}

function print(){
	_pHwpCtrl.PrintDocument();
} 

function _VerifyVersion() {
    // 설치확인
    if(_pHwpCtrl.getAttribute("Version") == null) {
        alert(!"한글 2002 컨트롤이 설치되지 않았습니다.");
        return;
    }
    //버젼 확인
    CurVersion = _pHwpCtrl.Version;
    alert(CurVersion.toString(16));
    if(CurVersion < MinVersion) {
        alert(!"HwpCtrl의 버젼이 낮아서 정상적으로 동작하지 않을 수 있습니다.\n"+"최신 버젼으로 업데이트하기를 권장합니다.\n\n"
              + "현재 버젼: 0x"
              + CurVersion.toString(16)
              + "\n"
              + "권장 버젼: 0x"
              + MinVersion.toString(16) + " 이상");
    }
}

</script>
 <body>
<div class="pop_head">
			<h1>온나라 전자결재 문서</h1>
			<a href="#n" class="clo" style=""><img src="../Images/btn/btn_pop_clo01.png" alt="" /></a><!-- 윈도우팝업일 경우 btn_pop_clo02 -> btn_pop_clo01 -->
		</div>
<input type="hidden" id="contentHtml" name="contentHtml" /> 

<div id="printArea" class="" style="margin:0 auto; display:table;">
	<div id="divForm" class="div_form" style="width: 670px;">
		<div>&nbsp;</div>
	    <div id="divFormBind" class="div_form_bind" ></div>

	</div>
	<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/activeX/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >
</object>
	
	<OBJECT id="HwpCtrl_1" style="LEFT: 0px; TOP: 100px" height="670px" width="100%" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052 onError="activex_error(${status.count})">
    </OBJECT>
</div>
<div class="pop_foot">
	<div class="btn_cen pt12">
		<!-- <input type="button" value="인 쇄" onclick="print();" /> -->
		<input type="button" value="닫 기" class="gray_btn" onclick="cancelBtn();" />
	</div>
</div><!-- //pop_foot -->
 </body>
</html>