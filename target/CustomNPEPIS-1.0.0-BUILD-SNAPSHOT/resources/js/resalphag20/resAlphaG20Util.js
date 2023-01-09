var resAlphaG20Util = {};

resAlphaG20Util.init = function(mode){
	var html = '';
	html += '<div>';
	html += '	<div class="btn_div">';
	html += '		<div class="left_div">';
	html += '			<p class="tit_p fl mt5 mb0">';
	html += '				온나라연동';
	html += '			</p>';
	html += '		</div>';
	html += '		<div class="right_div">';
	html += '			<div class="controll_btn p0 fr ml10 notView">';
	html += '				<button id="" onclick="findOnnaraDocs();">문서 선택</button>';
	html += '			</div>';
	html += '		</div>';
	html += '	</div>';
	html += '   	<div class="com_ta2 hover_no mt15">';
	html += '    	<table id="">';
	html += '        	<colgroup>';
	html += '        		<col width="100"/>';
	html += '        		<col width=""/>';
	html += '        		<col width="110"/>';
	html += '        		<col width="70" class="notView"/>';
	html += '        	</colgroup>';
	html += '            <tbody id="onnaraTbody">';
	html += '            	<tr>';
	html += '                    <th>문서제목</th>';
	html += '                    <td>';
	html += '                    	<input type="text" id="defaultInputBox" class="disabled" readonly="readonly" style="width: 90%;"/>';
	html += '                    </td>';
	html += '                    <td>';
	html += '	                    <div class="controll_btn cen p0"><button type="button" class="attachIco">첨부파일목록</button></div>';
	html += '                    </td>';
	html += '                    <td class="notView">';
	html += '	                    <img class="closeIco" style="width:15px; height:15px;" src="' + _g_contextPath_ + '/Images/ico/close.png" alt="" />';
	html += '                    </td>';
	html += '                </tr>';
	html += '            </tbody>';
	html += '        </table>';
	html += '    </div>  ';
	html += '</div>';
	$('#djOnnara').append(html);
	
	Init.event();
	Init.ajax();
	initEventListener();
	
	if(mode === 'v'){
		$('.notView').hide();
		$('#defaultInputBox').off('click');
	}
};

var onnaraDocs = "";
var onnaraAttach = {};
var onnaraDocsStr = '';

var targetType = '';
var targetSeq = '';

var Init = {
		
		event: function() {
		},
		ajax: function() { /* 온나라 맵핑 데이터 불러오기 */
			
			var paramObj = {};
			
			paramObj['targetType'] = targetType;
			paramObj['targetSeq'] = targetSeq;
			$.ajax({
				url : _g_contextPath_ + "/resAlphaG20/getDocMappingOnnara",
				data : paramObj,
				type : 'POST',
				async : false,
				success : function(data) {
					
					if (data.resultDocList.length > 0) {
						setOnnaraDocs(JSON.stringify(data.resultDocList));
					}
				}	
			});
			
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
	
	kendoFunction();
}

function openHwpViewer(docId) {
	
if (checkBroswer().substring(0, 2) != "ie") { // IE 제와한 브라우저 -> PDF 뷰어
		
		$.ajax({
			url : _g_contextPath_ + "/resAlphaG20/downloadDocFileAjaxToPDF",
			data : { "DOCID" : docId },
			type : 'POST',
			async : false,
			success : function(result) {
				
				var fileFullPath = result.fileFullPath;
				 $.ajax({
					url: _g_contextPath_+"/resAlphaG20/convertPdfToBase64",
					dataType : 'json',
					data : { fileFullPath : fileFullPath },
					type : 'POST',
					async : false,
					success: function(result){
						
						var base64 = result.base64Code;
						
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
			url : _g_contextPath_ + "/resAlphaG20/downloadDocFileAjaxToPDF",
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
	html += '<td>';
	html += '<input type="text" onclick="openHwpViewer(\'' + row.DOCID + '\');" class="inputTitle" readonly="readonly" value="[' + row.AUTHORDEPTNAME + '-' + row.DOCNOSEQ + '] ' + row.DOCTTL + '" style="width: 90%;"/>';
	html += '</td>';
	html += '<td>';
	html += '<div class="controll_btn cen p0"><button type="button" class="attachIco">첨부파일목록</button></div>';
	html += '<input type="hidden" value="' + row.DOCID + '">';
	html += '</td>';
	html += '<td class="notView">';
	html += '<span onclick="deleteOnnaraRow(\'' + row.DOCID + '\')">';
	html += '<img class="closeIco" style="width:15px; height:15px;" src="' + _g_contextPath_ + '/Images/ico/close.png" alt="" />';
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
	if (onnaraDocs.length > 0) {
		var params = [];
		
		onnaraDocs.forEach(function(v, i) {
			
			var obj = {};
			
			obj['targetType'] = targetType;
			obj['targetSeq'] = targetSeq;
			obj["docId"] = v.DOCID;
			obj["docRegDate"] = v.REPORTDT;
			
			params.push(obj);
		});
		
		$.ajax({
			url : _g_contextPath_+'/resAlphaG20/saveOnnaraMapping',
			data : { 
				data : JSON.stringify(params),
				targetSeq : targetSeq,
				targetType : targetType
			},		
			type : 'POST',
			success : function(result) {
				
			}
		});
	}
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

function makeDjFileKey(){
	var dj_fileKey = "";
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: _g_contextPath_ + "/resAlphaG20/makeFileKey"
        , async : false
	    , success: function (result) {
	    	dj_fileKey = result.dj_fileKey
	    }
	    , error: function(result){}
    });
	return dj_fileKey;
}

function onnaraFileToTemp(dj_fileKey){
	var attachs = onnaraAttach;
	var jsonData = [];
		
	for ( var key in attachs ) {
		jsonData.push(key);
	}
		
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: _g_contextPath_ + "/resAlphaG20/moveFileToTemp.do"
	    , data: {
        	params : JSON.stringify(jsonData),
        	dj_fileKey : dj_fileKey
        }
        , async : false
	    , success: function (result) {
	    	
	    	console.log("result : " + result);
	    }
	    , error: function(result){
	    }
    });
}