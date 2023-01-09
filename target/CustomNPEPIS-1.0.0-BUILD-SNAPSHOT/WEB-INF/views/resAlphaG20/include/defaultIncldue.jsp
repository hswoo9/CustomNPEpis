<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<%
 /**
  * @Class Name : defaultUrl.jsp
  * @Description : 기본
  * @Modification Information
  *
  */ 
%>

<style type="text/css">
.aming { color : blue; cursor : pointer; }
.disabled { cursor : pointer; background-color: #eee;   color: #555;   opacity: 1; }
</style>

<script type="text/javascript">
var onnaraDocs = "";
var onnaraAttach = {};
var onnaraDocsStr = '';

var outProcessInterfaceId = '${params.outProcessInterfaceId}';
var outProcessInterfaceMId = '${params.outProcessInterfaceMId}';
var outProcessInterfaceDId = '${params.outProcessInterfaceDId}';
var outProcessInterfaceVal = false;
var formFlag = "${params.formFlag}" === "RES" ? "resDocSeq" : "consDocSeq";
var docSeq = "${params.docSeq}";

$(function(){
	
	Init.event();
	Init.ajax();
	
	initEventListener();
});

var Init = {
		
		event 		: function() {
			$('.iframe_wrap').css('padding', '0');
		},
		
		fn_kendo 	: function() {},
		
		ajax 			: function(param) { /* 온나라 맵핑 데이터 불러오기 */
			
			var paramObj = {};
			
			if (typeof param === 'undefined') {
// 				paramObj[formFlag] = (formFlag === "resDocSeq") ? parent.resDocSeq : parent.consDocSeq;
				paramObj['targetType'] = formFlag;
				paramObj['targetSeq'] = (formFlag === "resDocSeq") ? parent.resDocSeq : parent.consDocSeq;
			} else {
// 				paramObj['consDocSeq'] = param.consDocSeq;
				paramObj['targetType'] = 'consDocSeq';
				paramObj['targetSeq'] = param.consDocSeq;
			}
			$.ajax({
				url : "<c:url value='/resAlphaG20/getDocMappingOnnara' />",
				data : paramObj,
				type : 'POST',
				success : function(data) {
					
					if (data.resultDocList.length > 0) {
						setOnnaraDocs(JSON.stringify(data.resultDocList));
					}
				}	
			});
			
			if(parent.resDocSeq && parent.outProcessInterfaceId == "dj_bizFee"){
				$.ajax({
					url : "<c:url value='/resAlphaG20/getWorkFee' />",
					data : {resDocSeq : parent.resDocSeq},
					type : 'POST',
					success : function(data) {
						parent.workFeeData = data.workFee;
					}
				});
			}
			if(parent.resDocSeq && parent.outProcessInterfaceId == "dj_dailyExp"){
				$.ajax({
					url : "<c:url value='/resAlphaG20/getDailyExp' />",
					data : {resDocSeq : parent.resDocSeq},
					type : 'POST',
					success : function(data) {
						if(data.dailyExp == null) {
							
							parent.dailyExpData = [];
						}else{
							parent.dailyExpData = data.dailyExp;
							
						}
					}
				});
			}
			
		}
}

function initEventListener() {
	
	$(document).on("mouseover", ".attachTooltip, .inputTitle", function(e) {
		$(this).addClass("aming");
	});
	
	$(document).on("mouseout", ".attachTooltip, .inputTitle", function(e) {
		$(this).removeClass("aming");
	});
	
	$(document).on("mouseover", ".closeIco, .attachIco", function(e) {
		$(this).addClass("aming");
	});
	
	$(document).on("mouseout", ".closeIco, .attachIco", function(e) {
		$(this).removeClass("aming");
	});
	
	$("#defaultInputBox").on("click", function() {
		findOnnaraDocs();
	});
}

function setOnnaraDocs(arr) {
	onnaraDocs = eval('(' + arr + ')');
	
	$("#onnaraTbody").empty();
	
	onnaraDocs.forEach(function(element) {
		onnaraAttach[element.DOCID] = element;
		
	    $("#onnaraTbody").prepend(onnaraTemplate(element));
	});
	
	//$("#djIframe", parent.document).css("height", 100 + (40 * (onnaraDocs.length - 1)));
	//	parent.djIframeResize();
	
	kendoFunction();
}

// 결재작성 시 호출
function djApproval(){
	console.log("djApproval");
	
	if (onnaraDocs.length > 0) {
		saveOnnaraMapping();
	} 
	
	return djCustApproval();
}

function openHwpViewer(docId) {
	
if (checkBroswer().substring(0, 2) != "ie") { // IE 제와한 브라우저 -> PDF 뷰어
		
		$.ajax({
			url : "<c:url value='/resAlphaG20/downloadDocFileAjaxToPDF' />",
			data : { "DOCID" : docId },
			type : 'POST',
			async : false,
			success : function(result) {
				
				var fileFullPath = result.fileFullPath;
				
				//window.open(_g_contextPath_ + '/resAlphaG20/pdfViewerIE?fileFullPath=' + fileFullPath);
				
				 $.ajax({
					url: _g_contextPath_+"/resAlphaG20/convertPdfToBase64",
					dataType : 'json',
					data : { fileFullPath : fileFullPath },
					type : 'POST',
					async : false,
					success: function(result){
						
						var base64 = result.base64Code;
						
						// == 0 ==
						//window.open("data:application/pdf; base64, " + encodeURI(result.base64Code), '_blank');
						
						// == 1 ==
					     /* let pdfWindow = window.open("");
						pdfWindow.document.write(
						    "<iframe width='100%' height='100%' src='data:application/pdf;base64, " +
						    encodeURI(result.base64Code) + "'></iframe>"
						) */
						
						// == 2 ==
						/* var win = window.open("","_blank");
						var html = '';
						var datas = 'data:application/pdf;base64, '+base64;
						
						html += '<html>';
						html += '<body style="margin:0!important">';
						//html += "<a download=pdfTitle href=" + datas + " title='Download pdf document' />";
						html += '<embed width="100%" height="100%" src="data:application/pdf;base64, '+base64+'" type="application/pdf" />';
						html += '</body>';
						html += '</html>';

						setTimeout(function() {
						  win.document.write(html);
						}, 0); */
						
						var objbuilder = '';
						objbuilder += ('<object width="100%" height="100%" data="data:application/pdf;base64,');
						objbuilder += (base64);
						objbuilder += ('" type="application/pdf" class="internal">');
						objbuilder += ('<embed src="data:application/pdf;base64,');
						objbuilder += (base64);
						objbuilder += ('" type="application/pdf"  />');
						objbuilder += ('</object>');

						var win = window.open("#","_blank");
						var title = "my tab title";
						win.document.write('<html><title>'+ title +'</title><body style="margin-top: 0px; margin-left: 0px; margin-right: 0px; margin-bottom: 0px;">');
						win.document.write(objbuilder);
						win.document.write('</body></html>');
						
						setTimeout(function() {
							layer = jQuery(win.document);
							}, 2000);
					},
					beforeSend: function() {
						
				    },
				    complete: function() {
				        //마우스 커서를 원래대로 돌린다
				        $('html').css("cursor", "auto");
				    	$('#loadingPop').data("kendoWindow").close();
				    }
				});
			},	
			beforeSend: function() {
				
		    },
		    complete: function() {    }
		});
	} else { // IE 실행 -> 한글 뷰어

		$.ajax({
			url : "<c:url value='/resAlphaG20/downloadDocFileAjaxToPDF' />",
			data : { "DOCID" : docId },
			type : 'POST',
			async : false,
			success : function(result) {
				
				var fileFullPath = result.fileFullPath;
				
				window.open(_g_contextPath_ + '/resAlphaG20/pdfViewerIE?fileFullPath=' + fileFullPath);
			},	
			beforeSend: function() {
				
		    },
		    complete: function() {
		        //마우스 커서를 원래대로 돌린다
		        $('html').css("cursor", "auto");
		    	$('#loadingPop').data("kendoWindow").close();
		    }
		});
	}
}

// 온나라 템플릿
function onnaraTemplate(row) {
	var html = '<tr id="' + row.DOCID + '">';
	html += '<th>문서제목</th>';
	html += '<td style="width: 71%;">';
	html += '<input type="text" onclick="openHwpViewer(\'' + row.DOCID + '\');" class="inputTitle" readonly="readonly" value="[' + row.AUTHORDEPTNAME + '-' + row.DOCNOSEQ + '] ' + row.DOCTTL + '" style="width: 90%;"/>';
	html += '</td>';
	html += '<td>';
	html += '<div class="controll_btn cen p0"><button type="button" class="attachIco">첨부파일목록</button></div>';
	html += '<input type="hidden" value="' + row.DOCID + '">';
	html += '</td>';
	html += '<td>';
	html += '<span onclick="deleteOnnaraRow(\'' + row.DOCID + '\')">';
	html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
	html += '<span>';
	html += '</td>';
	html += '</tr>';
	
	return html;
}

function deleteOnnaraRow(docId) {
	
	var tmpDocs = [];
	$("#" + docId).remove();
	delete onnaraAttach[docId];
	
	onnaraDocs.forEach(function(v, i) {
		
		if (v.DOCID != docId) {
			tmpDocs.push(v);
		}
	});
	
	onnaraDocs = tmpDocs;
	
	//$("#djIframe", parent.document).css("height", 100 + (40 * (onnaraDocs.length - 1)));
	
	parent.djIframeResize();
}

function findOnnaraDocs(e) {
	
	if (onnaraDocs.length > 0) {
		onnaraDocsStr = JSON.stringify(onnaraDocs);
	}
	
	var url = _g_contextPath_ + "/resAlphaG20/findOnnaraPopup";
	
	window.name = "parentForm";
	var openWin = window.open(url,"childForm","width=1400, height=800, resizable=no , scrollbars=no, status=no, top=200, left=350","newWindow");
}

// 파일 첨부 툴팁 생성
function kendoFunction() {
	$(".attachIco").kendoTooltip({
		position: "top",
		autoHide : false,
		showOn: "click",
        content : function(e) {
        	var docId = $(e.target.context).parent().next("input").val();
        	
			return attachTooltipTemplate(onnaraAttach[docId]);
        }
      });
}

function attachTooltipTemplate(row) {
	
	var html = "";
	var attachVo = row.attachVo;
	
	attachVo.forEach(function(v, i) {
		html += '<div class="attachTooltip" onclick="downloadFileId(\'' + v.FLEID + '\');">' + v.FLETTL + "</div>";
	});
	
	return html;
}

function downloadFileId(fileId) {
	
	 $.ajax({
		url : _g_contextPath_+'/resAlphaG20/fileDownLoad?fileId=' + fileId,
		type : 'get',
	}).success(function(data) {
		
		var downWin = window.open('','_self');
		downWin.location.href = _g_contextPath_+"/resAlphaG20/fileDownLoad?fileId="+fileId;
		
	});
}

function saveOnnaraMapping() {
	
	var params = [];
	
	onnaraDocs.forEach(function(v, i) {
		
		var obj = {};
		
// 		obj[formFlag] = formFlag === "resDocSeq" ? parent.resDocSeq : parent.consDocSeq;
		obj['targetType'] = formFlag;
		obj['targetSeq'] = formFlag === "resDocSeq" ? parent.resDocSeq : parent.consDocSeq;
		obj["docId"] = v.DOCID;
		obj["docRegDate"] = v.REPORTDT;
		
		params.push(obj);
	});
	
	$.ajax({
		url : _g_contextPath_+'/resAlphaG20/saveOnnaraMapping',
		data : { 
			data : JSON.stringify(params),
			targetSeq : (formFlag === "resDocSeq") ? parent.resDocSeq : parent.consDocSeq,
			targetType : formFlag
		},		
		type : 'POST',
		success : function(result) {
			
		}
	});
}

/**
 * 브라우저 종류
 * 
 * function	:	checkBroswer();
 * return browser : 브라우저 종류	
 */
function checkBroswer(){

    var agent = navigator.userAgent.toLowerCase(),
        name = navigator.appName,
        browser = '';
 
    // MS 계열 브라우저를 구분
    if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
        browser = 'ie';
        if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
            agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
            browser += parseInt(agent[1]);
        } else { // IE 11+
            if(agent.indexOf('trident') > -1) { // IE 11
                browser += 11;
            } else if(agent.indexOf('edge/') > -1) { // Edge
                browser = 'edge';
            }
        }
    } else if(agent.indexOf('safari') > -1) { // Chrome or Safari
        if(agent.indexOf('opr') > -1) { // Opera
            browser = 'opera';
        } else if(agent.indexOf('chrome') > -1) { // Chrome
            browser = 'chrome';
        } else { // Safari
            browser = 'safari';
        }
    } else if(agent.indexOf('firefox') > -1) { // Firefox
        browser = 'firefox';
    }

    return browser;
}

</script>
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }"/>
<div>
	<div class="btn_div mt20">
		<div class="left_div">
			<p class="tit_p fl mt5 mb0">
				온나라연동
			</p>
		</div>
		<div class="right_div">
			<div class="controll_btn p0 fr ml10">
				<button id="" onclick="findOnnaraDocs();">문서 선택</button>
			</div>
		</div>
	</div>
   	<div class="com_ta2 hover_no mt15">
    	<table id="">
        	<colgroup>
        		<col width="200"/>
        	</colgroup>
            <tbody id="onnaraTbody">
            	<tr>
                    <th>문서제목</th>
                    <td style="width: 71%;">
                    	<input type="text" id="defaultInputBox" class="disabled" readonly="readonly" style="width: 80%;"/>
                    </td>
                    <td>
	                    <%-- <img class="attachIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/AttachIco.png'/>" alt="" /> --%>
	                    <div class="controll_btn cen p0"><button type="button" class="attachIco">첨부파일목록</button></div>
                    </td>
                    <td>
	                    <img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>  
</div>
