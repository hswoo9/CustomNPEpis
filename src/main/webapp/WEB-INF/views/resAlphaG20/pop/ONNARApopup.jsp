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
<style>
	.k-header .k-link {text-align: center;}
	.k-grid-content>table>tbody>tr {text-align: center;}
	.k-grid th.k-header, .k-grid-header {background: #F0F6FD;}
	dt {	text-align : left; 	width : 10%; }
	dd {	width: 11.5%; }
	dd input { 	width : 80%; }
	.k-grid-toolbar { float : right; }
	#onnaraGrid { height: 100%; }
	.aming { color : blue; cursor : pointer; }
	.k-grid-content>table>tbody>tr { text-align: left; }
	#finalTable thead > tr > th { text-align: center; padding-right : 0px; !important}
	#finalTable tbody > tr > td { text-align: center; padding-left : 0px; !important; padding-right : 0px; !important}
	.k-datepicker { width : 110px; }
	.tb_box {
		max-height:210px;
		overflow-y:scroll;
		border-top:1px solid #dedede;
		border-bottom:1px solid #dedede;
	}
</style>

<script type="text/javascript">

	var pickedFinalOnnaraDatas = []; // 최종 반영 온나라 데이터 배열
	var savedEmpErpArray = []; // 부서별 ERP사원번호 배열
	var searchDocList = "";
	var allDept = JSON.parse('${allDept}');
	var deptSeq = ${deptSeq};
	var erpEmpSeq = ${erpEmpSeq};
	var loginParentDept = "";
	var deptParentDept = "";

	$(function() {

		if (window.opener.onnaraDocsStr.length > 0) {
			pickedFinalOnnaraDatas = eval('(' + window.opener.onnaraDocsStr + ')');

			pickedFinalOnnaraDatas.forEach(function(element) {
				makeRowUtil.addRow(element);
			});
		}

		kendoFunction();
		getErpEmpSeqInDept();

		onnaraGrid();
		empGrid();

		initEventListner();

		kendoTooltip();

	});

	var makeRowUtil = {
		addRow : function(row) {

			$('#finalTable tfoot > tr').remove();
			var html = "";

			html += '<tr data-docid="' + row.DOCID + '">';
			html += '<td>' + row.AUTHORDEPTNAME + '</td>';
			html += '<td>' + row.AUTHORNAME + '</td>';
			html += '<td>' + fn_formatDate(row.REPORTDT) + '</td>';
			html += '<td>' + "[" + row.AUTHORDEPTNAME + "-" + row.DOCNOSEQ + "] " + row.DOCTTL + '</td>';
			if(row.PROTECTFLAG === "Y") {
				html += '<td><input type="button" class="openHwpViewer" id="added_' + row.DOCID + '" value="보기" disabled/></td>';
				html += '<td><div class="controll_btn cen p0"><button type="button" class="attachIco2" disabled>첨부파일목록</button></div></td>';
			}else{
				html += '<td><input type="button" class="openHwpViewer" id="added_' + row.DOCID + '" value="보기" /></td>';
				html += '<td><div class="controll_btn cen p0"><button type="button" class="attachIco2">첨부파일목록</button></div></td>';
			}

			html += '<td>' + (row.usedGubun === "1" ?  '<span style="color : blue;">사용' : '<span style="">미사용') + '</span></td>';
			html += '<td onclick=makeRowUtil.deleteRow(\"' + row.DOCID + '\",this)><img class="closeIco" style="width:15px; height:15px;" src="' + _g_contextPath_ + '/Images/ico/close.png" alt="" /></td>';
			html += '</tr>';

			$('#finalTable tbody').append(html);
			kendoTooltip2();
		},

		deleteRow : function(DOCID, data) {

			pickedFinalOnnaraDatas = pickedFinalOnnaraDatas.filter(function(v, i) {
				return v.DOCID !== DOCID;
			});

			$(data).closest('tr').remove();

			if ($('#finalTable tbody > tr').length === 0) {
				makeRowUtil.addMsgRow();
			}
		},

		addMsgRow : function() {
			var html = "";
			html += '<tr>';
			html += '<td colspan="8" style="text-align: center;">문서를 추가해주세요.</td>';
			html += '</tr>';

			return html;
		}
	}

	function initEventListner() {

		$(document).on("click", ".openHwpViewer", function() {
			startLoading(openHwpViewer, $(this).attr("id"));
		});

		$(document).on("click", '#addOnnaraDocs', function() {

			$(".mainCheckBox:checked").each(function(i, v) {

				var row = $("#onnaraGrid").data("kendoGrid").dataItem($(v).closest("tr"));

				var filtered = pickedFinalOnnaraDatas.filter(function(v, i) {
					return v.DOCID === row.DOCID;
				});

				if (filtered.length === 0) {
					pickedFinalOnnaraDatas.push(row);
					makeRowUtil.addRow(row);
				}
			});

			$('.mainCheckBox').prop('checked', false);
		});

		$(document).on("click", "#pickOnnaraDocs", function() {

			if (pickedFinalOnnaraDatas.length === 0) {
				alert('선택된 데이터가 없습니다.');
				return;
			}

			pickedFinalOnnaraDatas.forEach(function(v, i) {

				$.ajax({
					url : "<c:url value='/resAlphaG20/downloadDocFileAjax' />",
					data : { "DOCID" : v.DOCID },
					type : 'POST',
					async : false,
					success : function(result) {

					}
				});
			});

			//IE 부모 자식 창간에 데이터 이슈를 해결하기 위해
			window.opener.setOnnaraDocs(JSON.stringify(pickedFinalOnnaraDatas));

			self.close();
		});

		$(document).on("mouseover", ".closeIco, .attachIco, .attachIco2", function(e) {
			$(this).addClass("aming");
		});

		$(document).on("mouseout", ".closeIco, .attachIco, .attachIco2", function(e) {
			$(this).removeClass("aming");
		});

		$(document).on("keyup", "#docTtl", function(e) {

			if (e.keyCode == 13) {
				searchDocsByTitle($(this).val());
			}
		});

		$(document).on("click", "#searchDocTtl", function(e) {
			getParentDept();
			searchDocsByTitle($("#docTtl").val());
		});

		$(document).on("mouseover", ".attachTooltip", function(e) {

			$(this).addClass("aming");

		});

		$(document).on("mouseout", ".attachTooltip", function(e) {

			$(this).removeClass("aming");
		});
	}

	function kendoTooltip() {

		// Tooltip
		$(".attachIco").kendoTooltip({
			position: "top",
			autoHide : false,
			showOn: "click",
			content : function(e) {
				var row = $("#onnaraGrid").data("kendoGrid").dataItem($(e.target.context).closest("tr"));

				return attachTooltipTemplate(row);
			},
		});
	}

	function kendoTooltip2() {

		// Tooltip
		$(".attachIco2").kendoTooltip({
			position: "top",
			autoHide : false,
			showOn: "click",
			content : function(e) {

				var docid = $(e.target).closest('tr').data('docid');
				var row = $("#onnaraGrid").data("kendoGrid").dataItem($('#' + docid).closest('tr'));

				return attachTooltipTemplate(row);
			},
		});
	}

	function kendoFunction() {

		$("#dept").kendoComboBox({
			dataSource: allDept,
			dataTextField: "dept_name",
			dataValueField: "dept_seq",
			height : 500,
			change : function() {
				getErpEmpSeqInDept();
				$('#empName').val('');
				$('#erpEmpSeq').val('');
			},
		});

		$('#dept').data('kendoComboBox').value(deptSeq);
// 	$('#dept').data('kendoComboBox').enable(false);

		$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
		$('#loadingPop').kendoWindow({
			width: "443px",
			visible: false,
			modal: true,
			actions: [],
			close: false
		}).data("kendoWindow").center();

		// Datepicker
		$("#fromDate").kendoDatePicker({
			start: "month",
			depth: "month",
			format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
			culture : "ko-KR",
			dateInput: true
		});

		var mm = '${mm}';
		var year = '${year}';
		if(mm == 01){
			mm = 12;
			year = year-1;
		}else{
			if(mm < 11){
				mm = '0'+ (mm-1);
			}else{
				mm = mm-1;
			}
		}
		$("#fromDate").val(year+"-"+mm+"-01");

		$("#toDate").kendoDatePicker({
			start: "month",
			depth: "month",
			format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
			culture : "ko-KR",
			dateInput: true
		});

		$("#toDate").val( '${nowDate}');

		$("#division").kendoDropDownList({
			dataTextField : "DIVISION_NM",
			dataValueField : "DIVISION_CD",
			dataSource : [{
				DIVISION_NM : "전체",
				DIVISION_CD : "0"
			}, {
				DIVISION_NM : "사용",
				DIVISION_CD : "1"
			}, {
				DIVISION_NM : "미사용",
				DIVISION_CD : "2"
			}],
			index: 2,
			change : function(e) {
				onnaraGridReload();
			}
		});

		/* $("#deptNm").kendoComboBox({
              dataSource: allDept,
              dataTextField: "dept_name",
              dataValueField: "dept_seq",
              select : onDeptSeqSelect,
        }); */

		//$("#deptNm").data('kendoComboBox').value(deptSeq);

		$("#empPopUpCancel").click(function(){
			$("#empPopUp").data("kendoWindow").close();
		});

		$("#empSearch").click(function(){
			$('#emp_name').val("");
			$("#empPopUp").data("kendoWindow").open();
			empGridReload();
		});

		//팝업 초기화
		$("#empPopUp").kendoWindow({
			width: "600px",
			height: "750px",
			visible: false,
			actions: ["Close"]
		}).data("kendoWindow").center();
	}

	// 온나라 보안 문서 권한 체크 PROTECTFLAG
	function checkAuth(data) {

		if (data.PROTECTFLAG === 'N' && data.READRANGETYPE !== 'DDEP5') { // 보안 문서가 아닐 경우
			return true;
		}

		isAuth = data.AUTHEMP.indexOf(erpEmpSeq);

		return isAuth > -1 ? true : false;
	}

	function attachTooltipTemplate(row) {

		var html = "";
		var attachVo = row.attachVo;

		attachVo.forEach(function(v, i) {
			html += '<div class="attachTooltip" onclick="downloadAttachFile(\'' + v.FLEID + '\', \'' + v.DOCID + '\');">' + v.FLETTL + "</div>";
		});

		return html;
	}

	function downloadAttachFile(fileId, docId) {

		$.ajax({
			url : "<c:url value='/resAlphaG20/downloadDocFileAjax' />",
			data : { "DOCID" : docId },
			type : 'POST',
			success : function(result) {

				downloadFileId(fileId);
			}
		});

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

	function getParentDept(){
		$.ajax({
			url : _g_contextPath_+"/budget/getParentDept",
			data : {
				"deptName" : JSON.parse('${orgnztNm}')
			},
			dataType : "json",
			type : 'post',
			async: false,
			success : function(result) {
				console.log("로그인 한 사용자의 상위부서::  " + result.list[0].HDEPT_NM);

				loginParentDept = result.list[0].HDEPT_NM;
			}
		});

		$.ajax({
			url : _g_contextPath_+"/budget/getParentDept",
			data : {
				"deptName" : $('#dept').data('kendoComboBox').text()
			},
			dataType : "json",
			type : 'post',
			async: false,
			success : function(result) {
				console.log("발의부서 상위부서::  " + result.list[0].HDEPT_NM);

				deptParentDept = result.list[0].HDEPT_NM;
			}
		});
	}

	function onnaraGrid(){
		getParentDept();

		var onnaraGrid =  $("#onnaraGrid").kendoGrid({
			dataSource: new kendo.data.DataSource({
				serverPaging: true,
				pageSize: 10,
				transport: {
					read:  {
						url: _g_contextPath_+'/resAlphaG20/getOnnaraGrid',
						dataType: "json",
						traditional: true,
						type: 'post'
					},
					parameterMap: function(data, operation){
						data.erpEmpSeqJson = $('#erpEmpSeq').val().length > 0 ? JSON.stringify({ paramArr : [$('#erpEmpSeq').val()] }) : JSON.stringify({ paramArr : savedEmpErpArray });
						data.fromDate = $("#fromDate").val().replace(/\-/g, '');
						data.toDate = $("#toDate").val().replace(/\-/g,'') + '235959';
						data.docTtl = $("#docTtl").val();
						data.usedGubun = $("#division").data("kendoDropDownList").value();
						return data;
					}
				},
				schema: {
					data: function(response) {

						var usedGubun = $("#division").data("kendoDropDownList").value();

						var resultList = response.list.filter(function(v, i) {

							return (usedGubun === v.usedGubun) || usedGubun === "0";
						});

						return resultList;
					},
					total: function(response) {

						var usedGubun = $("#division").data("kendoDropDownList").value();

						var resultList = response.list.filter(function(v, i) {

							return (usedGubun === v.usedGubun) || usedGubun === "0";
						});

						return resultList.length;
					}
				}
			}),
			height : 300,
			dataBound : dataBound,
			selectable : true,
			sortable : true,
			persistSelection : true,
			columns : [
				{
					template : function(dataItem) {

						if(dataItem.READRANGETYPE == 'DDEP3' && dataItem.AUTHORDEPTNAME == JSON.parse('${orgnztNm}') || JSON.parse('${orgnztNm}') == "국제통상협력실"){
							return '<input type="checkbox" class = "mainCheckBox">';
						} else if (dataItem.READRANGETYPE == 'DDEP2' && loginParentDept != deptParentDept){
							return "";
						} else if (dataItem.READRANGETYPE == 'DDEP3' && dataItem.AUTHORDEPTNAME != JSON.parse('${orgnztNm}')){
							return "";
						} else if (dataItem.PROTECTFLAG === 'Y'){
							return "";
						} else if (dataItem.attachVo.length > 0 && checkAuth(dataItem)) {
							return '<input type="checkbox" class = "mainCheckBox">';
						} else {
							return "";
						}
					},
					width : 2
				},
				{
					field : "AUTHORDEPTNAME",
					width : 4,
					title : "부서"
				},
				{
					field : "AUTHORNAME",
					width : 3,
					title : "작성자"
				},
				{
					template : function(dataItem) {
						return fn_formatDate(dataItem.REPORTDT);
					},
					field : "REPORTDT",
					width : 4,
					title : "작성날짜"
				},
				{
					template : function(dataItem) {
						return "[" + dataItem.AUTHORDEPTNAME + "-" + dataItem.DOCNOSEQ + "] " + dataItem.DOCTTL;
					},
					width : 23,
					title : "문서제목"
				},
				{
					template : function(dataItem) {
						if(dataItem.READRANGETYPE == 'DDEP3' && dataItem.AUTHORDEPTNAME == JSON.parse('${orgnztNm}')){
							return "<input type='button' class='openHwpViewer' id='" + dataItem.DOCID + "' value='보기' />";
						} else if (dataItem.READRANGETYPE == 'DDEP2' && loginParentDept != deptParentDept){
							return "<input type='button' class='openHwpViewer' id='" + dataItem.DOCID + "' value='보기' disabled />";
						} else if (dataItem.READRANGETYPE == 'DDEP3' && dataItem.AUTHORDEPTNAME != JSON.parse('${orgnztNm}')){
							return "<input type='button' class='openHwpViewer' id='" + dataItem.DOCID + "' value='보기' disabled />";
						} else if (dataItem.PROTECTFLAG === 'Y'){
							return "<input type='button' class='openHwpViewer' id='" + dataItem.DOCID + "' value='보기' disabled />";
						} else if (dataItem.attachVo.length > 0 && checkAuth(dataItem)) {
							return "<input type='button' class='openHwpViewer' id='" + dataItem.DOCID + "' value='보기' />";
						}  else {
							return "";
						}
					},
					width : 3.5,
					title : "문서보기"
				},
				{
					template : function(dataItem) {
						if(dataItem.READRANGETYPE == 'DDEP3' && dataItem.AUTHORDEPTNAME == JSON.parse('${orgnztNm}')){
							return '<div class="controll_btn cen p0"><button type="button" class="attachIco">첨부파일목록</button></div>';
						} else if (dataItem.READRANGETYPE == 'DDEP2' && loginParentDept != deptParentDept) {
							return '<div class="controll_btn cen p0"><button type="button" class="attachIco" disabled>첨부파일목록</button></div>';
						} else if (dataItem.READRANGETYPE == 'DDEP3' && dataItem.AUTHORDEPTNAME != JSON.parse('${orgnztNm}')){
							return '<div class="controll_btn cen p0"><button type="button" class="attachIco" disabled>첨부파일목록</button></div>';
						} else if (dataItem.PROTECTFLAG === 'Y'){
							return '<div class="controll_btn cen p0"><button type="button" class="attachIco" disabled>첨부파일목록</button></div>';
						} else if (dataItem.attachVo.length > 0 && checkAuth(dataItem)) {
							return '<div class="controll_btn cen p0"><button type="button" class="attachIco">첨부파일목록</button></div>';
						} else {
							return "";
						}
					},
					title : "첨부파일",
					width : 5
				},
				{
					template : function(dataItem) {
						if (dataItem.usedGubun === "1") { // 사용
							return '<span style="color : blue;">사용</span>';
						} else { // 미사용
							return '미사용';
						}
					},
					title : "사용여부",
					width : 3
				}
			],
			change : selectRow

		}).data("kendoGrid");

		function selectRow(e){		//row클릭시 data 전역변수 처리

			row = e.sender.select();
			grid = $('#onnaraGrid').data("kendoGrid");
			data = grid.dataItem(row);
			console.log(data);
			console.log(data.READRANGETYPE);

			// Checkbox on/off
			if (checkAuth(data)) {
				var checkFlag = row.find('.mainCheckBox').prop('checked') ? false : true;
				row.find('.mainCheckBox').prop('checked', checkFlag);
			};
		}
	};

	function onnaraGridReload(){

		$('#onnaraGrid').data('kendoGrid').dataSource.read();

	}

	function dataBound(e){

		kendoTooltip();

		var grid = e.sender;
		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td style="text-align: center;" colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	};

	var empDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
		transport: {
			read:  {
				url: _g_contextPath_+'/common/empInformation',
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation){
				data.emp_name = $('#emp_name').val();
				data.deptSeq = $('#dept').data('kendoComboBox').value();
				data.notIn = '';
				return data;
			}
		},
		schema: {
			data: function(response) {

				response.list.unshift({dept_name : '', dept_seq : '999', emp_name : '전체', emp_seq : '', erp_emp_num : '', duty : '', position : ''});

				return response.list;
			},
			total: function(response) {
				return response.totalCount + 1;
			}
		}
	});

	function empGridReload(){
		$('#empGrid').data('kendoGrid').dataSource.read();
	}

	function empGrid(){
		var grid = $("#empGrid").kendoGrid({
			dataSource: empDataSource,
			height: 500,
			sortable: true,
			pageable: {
				refresh: true,
				pageSizes: true,
				buttonCount: 5
			},
			persistSelection: true,
			selectable: "multiple",
			columns:[ {field: "emp_name",
				title: "이름",
			},{field: "dept_name",
				title: "부서",
			},{field: "position",
				title: "직급",
			}, {field: "duty",
				title: "직책",
			}, {title : "선택",
				template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
			}],
			change: function (e){
			}
		}).data("kendoGrid");

		grid.table.on("click", ".checkbox", selectRow);

		var checkedIds = {};

		//on click of the checkbox:
		function selectRow(){

			var checked = this.checked,
					row = $(this).closest("tr"),
					grid = $('#empGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
			console.log(dataItem);
			checkedIds[dataItem.CODE_CD] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
	}

	function empSelect(e){
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		$('#empName').val(row.emp_name);
		$('#erpEmpSeq').val(row.erp_emp_num);
		var empWindow = $("#empPopUp");
		empWindow.data("kendoWindow").close();
	}

	function startLoading(callback, docId) {

		$('html').css("cursor", "wait");
		$('#loadingPop').data("kendoWindow").open();

		if (typeof callback === 'function') {
			setTimeout(callback, 100, docId);
		}
	}

	function openHwpViewer(docId) {

		if (docId.startsWith('added_')) {
			docId = docId.split('_')[1];
		}

		if (checkBroswer().substring(0, 2) != "ie") { // IE 제와한 브라우저 -> PDF 뷰어

			$.ajax({
				url : "<c:url value='/resAlphaG20/downloadDocFileAjaxToPDF' />",
				data : { "DOCID" : docId },
				type : 'POST',
				async : false,
				success : function(result) {

					var fileFullPath = result.fileFullPath;

					//window.open(_g_contextPath_ + '/resAlphaG20/pdfViewerIE?fileFullPath=' + fileFullPath);
console.log()
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

	function searchDocsByTitle(searchWord) {

		onnaraGridReload();
	}

	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function getErpEmpSeqInDept() {

		$.ajax({
			url: _g_contextPath_+"/resAlphaG20/getErpEmpSeqInDept",
			dataType : 'json',
			data : { deptSeq : $('#dept').data('kendoComboBox').value() },
			type : 'POST',
			async : false,
			success: function(result){

				savedEmpErpArray = [];

				result.list.forEach(function(v, i) {
					savedEmpErpArray.push(v.erp_emp_num);
				});
			}
		});
	}

	function onDeptSeqSelect(e){
		var dataItem = this.dataItem(e.item.index());
		var selectDeptSeq = dataItem.dept_seq;
		$('#deptSeq').val(selectDeptSeq);

		$.ajax({
			url: _g_contextPath_+"/resAlphaG20/getErpEmpSeqInDept",
			dataType : 'json',
			data : { deptSeq : selectDeptSeq },
			type : 'POST',
			async : false,
			success: function(result){

				savedEmpErpArray = [];

				result.list.forEach(function(v, i) {
					savedEmpErpArray.push(v.erp_emp_num);
				});
			}
		});

		$('#empName').val('');
		$('#erpEmpSeq').val('');
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

<body>

<!-- 온나라 문서 검색 팝업 -->
<div class="pop_wrap_dir" id="onnaraPopup" style="width:1350px;">
	<div class="pop_head">
		<h1>문서 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt  class="ar" style="width:30px;" >기간</dt>
				<dd style="width: 250px;">
					<input type="text" id="fromDate" />
					<span>~</span>
					<input type="text" id="toDate" />
				</dd>
				<dt  class="ar" style="width:55px" >발의부서</dt>
				<dd>
					<input type="text" style="width:130px"  id="dept" value='' />
				</dd>
				<dt class="ar" style="width: 30px;">성명</dt>
				<dd style="width: 140px;">
					<input type="text" id="empName" style="width: 80px"  value="${loginVO.name }" disabled/>
					<input type="hidden" id="erpEmpSeq"  value="${loginVO.erpEmpCd }"/> <!--  160201001 -->
					<input type="button" style="width: 50px;" id="empSearch" value="선택" />
				</dd>
				<dt class="ar" style="width: 45px;">문서명</dt>
				<dd style="width:215px;">
					<input type="text" id="docTtl" style="width: 150px"  value="" />
					<button type="button" id="searchDocTtl" style="width:50px; height: 25px;">검색</button>
				</dd>
				<dt style="width: 35px;">구분</dt>
				<dd style="">
					<input type="text" style="width:100%" id ="division"/>
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="">
			<div id="onnaraGrid"></div>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="addOnnaraDocs" value="추가" />
		</div>
	</div>

	<div class='com_ta mt15 tb_box' style="padding : 0px 18px;">
		<table id="finalTable" style="width: 100%">
			<colgroup>
				<col width="9%"/>
				<col width="9%"/>
				<col width="8%"/>
				<col width="44%"/>
				<col width="8%"/>
				<col width="11%"/>
				<col width="7%"/>
				<col width="4%"/>
			</colgroup>
			<thead>
			<tr>
				<th style="background-color: #f0f6fd;">부서</th>
				<th style="background-color: #f0f6fd;">작성자</th>
				<th style="background-color: #f0f6fd;">작성날짜</th>
				<th style="background-color: #f0f6fd;">문서제목</th>
				<th style="background-color: #f0f6fd;">문서보기</th>
				<th style="background-color: #f0f6fd;">첨부파일</th>
				<th style="background-color: #f0f6fd;">사용여부</th>
				<th style="background-color: #f0f6fd;">삭제</th>
			</tr>
			</thead>
			<tbody>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="8" style="text-align: center;">문서를 추가해주세요.</td>
			</tr>
			</tfoot>
		</table>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="pickOnnaraDocs" value="선택" />
		</div>
	</div>
</div>

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;PDF 파일 변환 시간이 소요될 수 있습니다. </span>
				</td>
			</tr>
		</table>
	</div>
</div>

<!-- 사원검색팝업 -->
<div class="pop_wrap_dir" id="empPopUp" style="width:600px;">
	<div class="pop_head">
		<h1>사원 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px;">성명</dt>
				<dd>
					<input type="text" id="emp_name" style="width: 120px" />
				</dd>
				<dt class="ar" style=""></dt>
				<dd style="margin-left : 70px;">
					<input type="button" onclick="empGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="">
			<div id="empGrid"></div>
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="empPopUpCancel" value="닫기" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->

</body>