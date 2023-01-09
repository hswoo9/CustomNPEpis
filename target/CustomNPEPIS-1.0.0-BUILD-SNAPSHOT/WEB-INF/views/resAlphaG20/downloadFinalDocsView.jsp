<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM-dd" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
<style>
.k-detail-cell .k-tabstrip .k-content {
    padding: 0.2em;
}
.downloadFiles { color : blue; }
</style>
</head>

<script type="text/javascript">

var sel_c_dikeycode = '';
var flag = true;

$(function() {
	
	$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
	
	Init.kendoFunction();
	Init.kendoGrid();
	Init.eventListener();
})
	
var Init = {
		kendoGrid : function() {
			var mainGrid = $("#mainGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({
					serverPaging : true,
					pageSize : 10,
					transport : {
						read : {
							url : _g_contextPath_+"/resAlphaG20/selectAdocuAndDailyDocs",
							dataType : "json",
							type : 'post'
						},
						parameterMap : function(data, operation) {
							data.fill_dt = $('#fillDate').val().replace(/\-/g,'');
							return data;
						}
					},
					schema : {
						data : function(response) {
							return response.list;
						},
						total : function(response) {
							return response.total;
						},
					}
				}),
				detailTemplate: kendo.template($("#template").html()),
				detailInit: detailInit,
				dataBound : mainGridDataBound,
				height : 650,
				sortable : true,
				persistSelection : true,
				selectable : "multiple",
		        columns: [
		        	{ 
		        		headerTemplate : function(dataItem){
		        				return '<input type="checkbox" id = "checkboxAll">';
		                },
		                template : function(dataItem){
		                  if (dataItem.final_pdf_path !== "") {
		                	  return '<input type="checkbox" class = "mainCheckBox">';
		                  } else {
		                	  return '';	                	  
		                  }
		                },
		                width : 15
		             },
		             {
		            	template: function(dataItem) {
		            		if (typeof dataItem.fill_dt == "undefined") {
		            			return '';
		            		} else {
			            		return dataItem.fill_dt + '-' + lpad(dataItem.fill_nb, 5, '0');
		            		}
		            	},
		            	title : "확정일자",
		            	width : 45
		             },
					{
						template: function(dataItem) {
							return dataItem.requ_date.substring(0, 4) + "-" + dataItem.requ_date.substring(4, 6) + "-" + dataItem.requ_date.substring(6, 8); 
						},
						title : "기안일자",
						width : 45
					},
					{
						field : 'c_dititle',
						title : "문서제목",
						width : 170
					},
					{
						template: function(dataItem) {
							
							var kbyte = Math.round((Number(dataItem.fileSize) / 1024)) + " KB"
							
							return kbyte;
						},
						title : "파일용량",
						width : 35
					},
					{
						field : 'emp_name',
						title : "기안자",
						width : 35
					},
					{
						template : function(dataItem) {
							var gubun = 0;
							var pdfName = '';
							if (typeof dataItem.fill_dt == "undefined") {
								gubun = 1;
								pdfName = dataItem.c_dititle;
							} else {
								gubun = 2;
								pdfName = '[회계전표] ' + dataItem.fill_dt + '-' + lpad(dataItem.fill_nb, 5, '0');
							}
							
							if (dataItem.final_pdf_path !== "") {
								return '';								
							} else {
								return '<button type="button" class="blue_btn" id="" onclick="savePDF(\'' + dataItem.c_dikeycode + '\',\'' + gubun + '\',\'' + pdfName + '\')">증빙보관</button>';
							}
						},
						title : "증빙 보관",
						width : 35
					},
					{
						template : function(dataItem) {
							if (dataItem.final_pdf_path !== "") {
								return '<button type="button" class="blue_btn" id="downLoadBtn" onclick="downloadFinal(\'' + dataItem.final_pdf_path + '\',\'' + dataItem.final_pdf_name + '\')">내려받기</button>';
							} else {
								return '';
							}
						},
						title : "증빙 <br/>다운로드",
						width : 35
					},
					]
		    }).data("kendoGrid");
		},
		
		
		kendoFunction : function() {
			
			$('#loadingPop').kendoWindow({
			     width: "443px",
			     visible: false,
			     modal: true,
			     actions: [],
			     close: false
			 }).data("kendoWindow").center();
			
			$("#fillDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : '2020-07-03' // TODO check
		    });
		},
		
		eventListener : function() {
			
			$("#downLoadBtn").on("click", function(e) {
				startLoading();
				
				setTimeout(function() {
					fn_downloadFiles();
				}, 500);
			});
			
			$(document).on("click", "#mainGrid tbody tr", function(e) {
				row = $(this)
				grid = $('#mainGrid').data("kendoGrid"),
				dataItem = grid.dataItem(row);
							
				console.log(dataItem);
			});
			
			$(document).on("mouseover", ".downloadFiles", function(e) {
				$(this).css("color","black");
			});
			
			$(document).on("mouseout", ".downloadFiles", function(e) {
				$(this).css("color","blue");
			});
			
			// 체크박스 전체선택
			$("#checkboxAll").click(function(e) {
				
		         if ($("#checkboxAll").is(":checked")) {
		            $(".mainCheckBox").prop("checked", true);
		         } else {
		            $(".mainCheckBox").prop("checked", false);
		         }
		      });
		}
}

function mainGridDataBound(e) {
	var grid = e.sender;
	
	if (grid.dataSource.total() == 0) {
		var colCount = grid.columns.length;
		$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
	}
	
}

function fn_searchBtn() {
	$('#mainGrid').data('kendoGrid').dataSource.read(0);
}

function fn_downloadFiles() {
	
	var iFrameCnt = 0;
	var fileList = [];
	
	$(".mainCheckBox:checked").each(function(i, v) {
		
		var rows = $("#mainGrid").data("kendoGrid").dataItem($(v).closest("tr"));
		
		var finalPdfName = rows.final_pdf_name;
		var finalPdfPath = rows.final_pdf_path;
		
		var fileName = finalPdfName + ".pdf";
		var fileFullPath = "/home" + finalPdfPath.split("Z:")[1] + "/" + fileName;
		
		fileList.push({ fileName : fileName, fileFullPath : fileFullPath, fillDate : $("#fillDate").val() });
	});
	
	if (fileList.length > 0) {
		$.ajax({
			type : 'post',
			url : '/CustomNPEPIS/resAlphaG20/makeZipFile',
			datatype : 'json',
			data : { param : JSON.stringify(fileList) },
			async : false,
			success : function(result) {
				endLoading();
				
				var url = _g_contextPath_ + "/common/fileDownLoad?fileName="+ encodeURI(encodeURIComponent($("#fillDate").val().replace(/-/g, '') + ".zip")) +'&fileFullPath='+encodeURI(encodeURIComponent(result.zipFileFullPath));
				
				fnCreateIframe(iFrameCnt);
				
				$("iframe[name=" + iFrameCnt + "]").attr("src", url);
			       
			       iFrameCnt++;
			       
			       fnSleep(1000);
				
				$('.downIframe').remove();
			},
			error : function(data) {
			}
		});
	} else {
		endLoading();
	}
	
}

function lpad(str, padLen, padStr) {
	
    if (padStr.length > padLen) {
        console.log("오류 : 채우고자 하는 문자열이 요청 길이보다 큽니다");
        return str;
    }
    str += ""; // 문자로
    padStr += ""; // 문자로
    while (str.length < padLen)
        str = padStr + str;
    str = str.length >= padLen ? str.substring(0, padLen) : str;
    return str;
}

function fnSleep(delay){
    
    var start = new Date().getTime();
    while (start + delay > new Date().getTime());

};

function fnCreateIframe(name){
    
    var frm = $('<iframe class="downIframe" name="' + name + '" style="display: none;"></iframe>');
    frm.appendTo("body");

}

function startLoading() {
	$('html').css("cursor", "wait");
	$('#loadingPop').data("kendoWindow").open();
}

function endLoading() {
	$('html').css("cursor", "auto");
	$('#loadingPop').data("kendoWindow").close();
}

function detailInit(e) {
    var detailRow = e.detailRow;
    
    var row = $("#mainGrid").data("kendoGrid").dataItem(detailRow.prev("tr"));
    
    $.ajax({
		type : 'post',
		url : '/CustomNPEPIS/resAlphaG20/getAttachInfo2',
		datatype : 'json',
		data : { C_DIKEYCODE : row.c_dikeycode },
		async : false,
		success : function(result) {
			
		    detailRow.find(".detailTemplate div").append('<input type="hidden" class="c_dikeycode" value="' + row.c_dikeycode + '"/>');
		    detailRow.find(".detailTemplate tbody").append(makeFileRow(result.list, row));
		}
	});
    
}

//mainDocDownFileName = row.fill_dt + '-' + lpad(row.fill_nb, 5, '0'); 회계전표

function makeFileRow(list, row) {
	
	var attachPrefix 					= "/home/upload/ea";
	var mainDocDownFilename 	= '';
	
	var html = '';
	
	if (typeof row.fill_dt === 'undefined') { 	// 일계표
		mainDocDownFileName = row.c_dititle;
	
	  	html  	+= '<tr><td style="width:415px; border-right: none; text-align: right;">'
	  	html	+= '<input type="button" style="margin-right: 20px;" onclick="upFile(this);" value="첨부파일 등록">'
	  	html  	+= '</td>'
	   	html	+= '<td style="text-align: left; border-left: none;">'
	   	html	+= '<span style="display: block;" class="mr20">'
		html 	+= '<img src="/CustomNPEPIS/Images/ico/ico_clip02.png" alt=""> &nbsp;'
		html	+= '<a href="#" class="downloadFiles" onclick="downloadFile(\'pdf\',\'' + mainDocDownFileName + '\',\'' + row.c_difilepath + '\',\'' + row.pdf_name + '\')">' + mainDocDownFileName + '.pdf</a> &nbsp;'
// 		html	+= '<a href="#" onclick="deleteFile(\'""\', \'' + row.c_dikeycode + '\', \'0\', this)">'
// 		html	+= '<img src="/CustomNPEPIS/Images/btn/btn_del_reply.gif">&nbsp;&nbsp;'
		html	+= '</a>'
		html	+= '</span>'
		html	+= '</td>'
		html	+= '</tr>';
	} 
	
	for (var i = 0; i < list.length; i++) {
		
		var map = list[i];
	  
		if (i === 0 && typeof row.fill_dt !== 'undefined') {
			html  	+= '<tr><td style="width:415px; border-right: none; text-align: right;">'
		  	html	+= '<input type="button" style="margin-right: 20px;" onclick="upFile(this);" value="첨부파일 등록">'
		} else {
		   	html  	+= '<tr><td style="width:415px; border-right: none; text-align: right;">'
		}
	   	html	+= '<td style="text-align: left; border-left: none;">'
	   	html	+= '<span style="display: block;" class="mr20">'
		html 	+= '<img src="/CustomNPEPIS/Images/ico/ico_clip02.png" alt=""> &nbsp;'
		html	+= '<a href="#" class="downloadFiles" onclick="downloadFile(\'' + map.file_extsn + '\',\'' + map.c_aititle + '\',\'' + attachPrefix + map.file_stre_cours + '\',\'' + map.stre_file_name + '\')">' + map.c_aititle + '.' + map.file_extsn + '</a> &nbsp;'
		if (i === 0 && typeof row.fill_dt !== 'undefined') {
			
		} else {
			html	+= '<a href="#" onclick="deleteFile(\'' + map.status + '\', \'' + row.c_dikeycode + '\', \'' + map.file_sn + '\' , this)">'
			html  	+= '<img src="/CustomNPEPIS/Images/btn/btn_del_reply.gif">'
		}
		html  	+= '</a>&nbsp;&nbsp;' 
		html	+= '</span>'
		html	+= '</td>'
		html	+= '</tr>';
	}
	
	return html;
}

function downloadFile(extsn, title, path, fileName) { // 개별 파일 다운로드
	
	var fullPath = path + "/" + fileName + "." + extsn;
	var downTitle = title + "." + extsn;
	
	var downWin = window.open('','_self');
	downWin.location.href = _g_contextPath_ + "/common/fileDownLoad?fileName="+ encodeURI(encodeURIComponent(downTitle)) +'&fileFullPath='+encodeURI(encodeURIComponent(fullPath));
	
}

function deleteFile(status, c_dikeycode, file_sn, thisObj) { // 개별 파일 삭제
	
	if (status === '') { // 기존 a_attachinfo 파일 처리
		deleteOrgFileAjax(c_dikeycode, file_sn, thisObj);
	} else if (status === 'ADD') { // 새로 추가된 파일 처리
		deleteAddFileAjax(c_dikeycode, file_sn, thisObj);
	}
}

// 기존 a_attachinfo 파일 삭제
function deleteOrgFileAjax(c_dikeycode, file_sn, thisObj) {
	
	var param = {
			C_DIKEYCODE 			: c_dikeycode
			,file_seq 				: file_sn
			,file_name 				: ''
			,real_file_name 		: ''
			,file_extension 		: ''
			,file_path 				: ''
			,file_size 				: ''
			,status 					: 'DEL'
	}
	
	$.ajax({
		url : _g_contextPath_+"/resAlphaG20/deleteOrgResalphaAttach",
		data : param,
		type : 'post',
		async: false,
		success : function(result) {
			afterDeleteFile(thisObj);
			alert("삭제되었습니다.");
		}
	});
}

//새로 추가된 파일 삭제
function deleteAddFileAjax(c_dikeycode, file_sn, thisObj) {
	
	var param = {
			c_dikeycode 	: c_dikeycode
			,file_sn 			: file_sn
	}
	
	$.ajax({
		url : _g_contextPath_+"/resAlphaG20/deleteResalphaAttach",
		data : param,
		type : 'post',
		async: false,
		success : function(result) {
			afterDeleteFile(thisObj);
			alert("삭제되었습니다.");
		}
	});
}

function upFile(thisObj) {
	
	sel_c_dikeycode = $(thisObj).closest("div").children(".c_dikeycode").val();
	
	$("#fileID").click();
}

function getFileNm(e) {
	var fileNm = $(e).val().substr($(e).val().lastIndexOf('\\') + 1, $(e).val().length);
	
	insertFile(fileNm);
}

function insertFile(fileNm){
	var form = new FormData($("#fileForm")[0]);
	
	form.append("C_DIKEYCODE", sel_c_dikeycode);
	form.append("fileNm",fileNm);
	
	$.ajax({
		url : _g_contextPath_+"/resAlphaG20/saveResalphaAttach",
		data : form,
		type : 'post',
		processData : false,
		async: false,
		contentType : false,
		success : function(result) {
			
			if (result.outYn == 'Y') {
				afterInsertFile(result);
			} else {
				
			}
		}
	});
}

function afterInsertFile(map) {
	var html = '';
	
	map.status = "ADD";
	
	html  	+= '<tr><td style="width:415px; border-right: none; text-align: right;">'
   	html	+= '<td style="text-align: left; border-left: none;">'
   	html	+= '<span style="display: block;" class="mr20">'
	html 	+= '<img src="/CustomNPEPIS/Images/ico/ico_clip02.png" alt=""> &nbsp;'
	html	+= '<a href="#" class="downloadFiles" onclick="downloadFile(\'' + map.file_extension + '\',\'' + map.file_name + '\',\'' + map.file_path + '\',\'' + map.real_file_name + '\')">' + map.fileNm + '</a> &nbsp;'
	html	+= '<a href="#" onclick="deleteFile(\'' + map.status + '\', \'' + map.C_DIKEYCODE + '\', \'' + map.file_seq + '\', this)">'
	html  	+= '<img src="/CustomNPEPIS/Images/btn/btn_del_reply.gif">'
	html	+= '</a>&nbsp;&nbsp;'
	html	+= '</span>'
	html	+= '</td>'
	html	+= '</tr>';
	
	$(".c_dikeycode[value=" + map.C_DIKEYCODE + "]").closest("div").find("tbody").append(html);
}

function afterDeleteFile(thisObj) {
	
	$(thisObj).closest("tr").remove();
	
}

// gubun : 1 일계표
// gubun : 2 회계전표
function savePDF(c_dikeycode, gubun, pdfName) {
	
	var param = {
			C_DIKEYCODE 	: c_dikeycode,
			c_dikeycode 	: c_dikeycode,
			gubun 			: gubun,
			pdfName			: pdfName
	}
	
	$.ajax({
		type : 'post',
		url : '/CustomNPEPIS/resAlphaG20/saveFinalPDF',
		datatype : 'json',
		data : param,
		async : false,
		success : function(result) {
			alert(result.resultMessage);
		},
	});
}

function downloadFinal(pdfPath, pdfName) { // pdfPath : "Z:/" 변환 작업 필요
	
	var fullPath = "/home" + pdfPath.split("Z:")[1] + "/" + pdfName + ".pdf";
	var downTitle = pdfName + ".pdf";
	
	var downWin = window.open('','_self');
	downWin.location.href = _g_contextPath_ + "/common/fileDownLoad?fileName="+ encodeURI(encodeURIComponent(downTitle)) +'&fileFullPath='+encodeURI(encodeURIComponent(fullPath));
	
}

</script>

<body>
<div class="iframe_wrap" style="min-width: 1070px;">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>전표, 일계표</h4>
		</div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20" style="width: 90%">일계표, 전표 리스트</p>
				<div class="top_box" style="width: 90%">
					<dl>
						<dt  class="ar" style="width:50px;" >기준일</dt>
						<dd>
							<input type="text" id="fillDate" />
						</dd>	
					</dl>
				</div>
				<div class="btn_div" style="width: 90%">	
					<div class="right_div">
						<div class="controll_btn p0">
							<button type="button" id="downLoadBtn" onclick="">다운로드</button>
							<button type="button" id="searchBtn" onclick="fn_searchBtn();">조회</button>
						</div>
					</div>
				</div>
				<div class="com_ta2 mt15" style="width: 90%;">
				    <div id="mainGrid"></div>
				</div>		
		</div>
	</div>
</div>	

<!-- 로딩 팝업 -->
<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class="" style="margin-right: 25px;"><img src="<c:url value='/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;선택한 파일을 압축중입니다. <br/> </span>		
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- 로딩 팝업 -->

<form id="fileForm" method="post" enctype="multipart/form-data" >
	<input type="file" id="fileID" name="fileNm" value="" onChange="getFileNm(this);" class="hidden" />
</form>

</body>
</html>

<script type="text/x-kendo-template" id="template">
       <div class="detailTemplate">
           <div>
			<table>
				<tbody>
				</tbody>
			</table>
          </div>
      </div>
</script>
    
    
    
    