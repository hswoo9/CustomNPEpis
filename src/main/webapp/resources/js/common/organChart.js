/**
 * 
 */

'use strict';
(function($){
	$.extend(true, window, {
		"organChart": organChart
	});
	
	function organChart(array){
		
		//array btnName : 팝업활성화 버튼 id, inputParamSet : map형태로 key-데이터명 value-인풋아이디 
		
		var $datas;
		var $members;
		var $memberTemp;
		var $userInfo;
		var $btnName = array.btnName;
		var $inputParamSet = array.inputParamSet;
		
		$.ajax({
			url: _g_contextPath_ + '/common/getOrganChartDatas',
			type: 'post',
			dataType: 'json',
			data: {},
			async : false,
			success: function(result){
				
				$datas = JSON.parse(result.data);
				$members = JSON.parse(result.memberList);
				$userInfo = result.userInfo;
				$memberTemp =$members.filter(function(x){
					return x.path_name.includes($userInfo.orgnztNm);
				});
			}
		});
		
		var html = '<div id = "organChartPop" class="pop_wrap" style="min-width:898px;"><div class="pop_head"><h1>조직도</h1></div><div class="pop_con"><table cellspacing="0" cellpadding="0"><colgroup><col width="250"/><col width=""/></colgroup><tr><td class="vt"><div style="padding-top: 35px"><div id="organ_treeview" style="height: 600px;"></div></div></td><td class="pl10 vt"><div class="top_box"><div class="top_box_in"><div id="" class="dod_search posi_re"><select id="organ_searchSelectBox" class="selectmenu" style="width:100px;"><option value="emp_name" selected="selected">사원명(ID)</option><option value="dept_name">부서명</option><option value="position">직급</option><option value="duty">직책</option><option value="tel_num">전화번호</option><option value="phone">휴대전화</option></select><input type="text" class="kr" id="organ_searchText" style="width:250px;text-indent:4px;"/><input type="button" id="organ_searchButton" value="검색" /></div></div></div><div class="trans_top_btn mt10"><div class="option_top"><ul><li class="tit_li">사원목록<span id="empCount"></span></li></ul><div id="" class="controll_btn p0 fr"></div></div></div><div class="com_ta2" style="width:100%;"><div id = "organ_grid" style="width:100%;border-style : none;border-width : 0px;border-color :#fff;border-top:1px solid #eaeaea;"></div><div class="mt10" ><table cellpadding="0" cellspacing="0"><tr><td class="vt" style="padding:0px;"><div class="com_ta2"><table id ="userDetail" style="border:0px;"><colgroup><col width="19.4%"/><col width="30.6%"/><col width="19.4%"/><col width=""/></colgroup><tr><th>사원명(ID)</th><td id="name"></td><th>생년월일</th><td id="birth"></td></tr><tr><th>직급</th><td id="position"></td><th>직책</th><td id="duty"></td></tr><tr><th>전체부서</th><td colspan="3" id="dept"></td></tr><tr><th>휴대전화</th><td colspan="3" id="phone"></td></tr><tr><th>전화번호</th><td id="compNum"></td><th>팩스번호</th><td id="faxNum"></td></tr><tr><th>회사메일</th><td colspan="3" id="compMail"></td></tr><tr><th>개인메일</th><td colspan="3" id="myMail"></td></tr><tr><th>담당업무</th><td colspan="3" id="mainWork"></td></tr></table></div></td></tr></table></div></td></tr></table></div></div>'
		var style = '<style>.k-header .k-link {	text-align: center;}.k-grid-content>table>tbody>tr {	text-align: center;}.k-grid th.k-header, .k-grid-header {	background: #F0F6FD;}/*yh*/.k-treeview .k-minus{background: url("../Images/ico/ico_organ03_open.png")}/*yh*/.k-treeview .k-plus{background: url("../Images/ico/ico_organ03_close.png")}/*yh*/.k-treeview .k-top.k-bot .k-plus{background: url("../Images/ico/ico_organ01.png")}.k-treeview .k-top.k-bot .k-minus{background: url("../Images/ico/ico_organ01.png")}.k-treeview .k-plus-disabled, .k-treeview .k-minus-disabled {	cursor: default}/*yh*/.k-treeview .k-top,.k-treeview .k-mid,.k-treeview .k-bot {  background-image: url("../Images/bg/treeview-nodes.png");  background-repeat: no-repeat;  margin-left: -16px;  padding-left: 16px;}/*yh*/.k-treeview .k-item { background-image: url("../Images/bg/treeview-line.png"); }.k-treeview .k-last { background-image: none; }.k-treeview .k-top { background-position: -91px 0; }.k-treeview .k-bot { background-position: -69px -22px; }.k-treeview .k-mid { background-position: -47px -44px; }.k-treeview .k-last .k-top { background-position: -25px -66px; }.k-treeview .k-group .k-last .k-bot { background-position: -69px -22px; }.k-treeview .k-item {  background-repeat: no-repeat;}.k-treeview .k-top.k-bot{background: none;}/*yh*/.k-treeview .k-first {  background-repeat: no-repeat;  background-position: 0 16px;}#grid table {	border-style : none;	border-width : 0px;	border-color : #fff}    }</style>';
		$.each($(".iframe_wrap"), function(i,v){
			if(i == $(".iframe_wrap").length-1){
				$(this).append(style);
				$(this).append(html);
			}
		})
		
		$("#organChartPop").kendoWindow({
			width: "1100px",
			height: "700px",
			visible: false,
			modal: true,
			actions: [
				"Close"
			],
			close: function(){
				$('#'+$btnName).fadeIn();
				$("#userDetail td").text('');
				$("#organ_searchSelectBox").data("kendoDropDownList").select(0);
				$("#organ_searchText").val('');
				var tv = $('#organ_treeview').data('kendoTreeView'),
			    selected = tv.findByText($userInfo.orgnztNm);
			    tv.select(selected);
				$memberTemp =$members.filter(function(x){
					return x.path_name.includes($userInfo.orgnztNm);
				});
				mainGrid();
			}
		}).data("kendoWindow").center();
		
		$('#'+$btnName).click(function(){
			$("#organChartPop").data("kendoWindow").open();
			$("#organChartPop").data("kendoWindow").refresh();
			$('#'+$btnName).fadeOut();
		});
		
		$("#organ_treeview").kendoTreeView({
		    dataSource: $datas,
		    dataTextField:['dept_name'],
		    select: treeClick,
		});
		
		var tv = $('#organ_treeview').data('kendoTreeView'),
	    selected = tv.findByText($userInfo.orgnztNm),
	    item = tv.dataItem(selected);
		$('select').kendoDropDownList();
		mainGrid();
		
		function treeClick(e){
			var item = $("#organ_treeview").data("kendoTreeView").dataItem(e.node);
			var searchDept = item.dept_name;
			$('#organ_searchText').val('');
			$memberTemp = $members.filter(function(x){
				return x.path_name.includes(searchDept);
			})
			mainGrid();
		}
		
		function mainGrid(){
			
			var grid =  $("#organ_grid").kendoGrid({
				dataSource: $memberTemp,
				height : 185,
				persistSelection : true,
				selectable : "row",
				columns : [
					{
						width : "13%",
						field : "dept_name",
						title : "부서"
					},
					{
						width : "13%",
						field : "position",
						title : "직급"
					},
					{
						width : "13%",
						field : "duty",
						title : "직책"
					},
					{
						width : "22%",
						field : "emp_name",
						title : "사원명(ID)"
					},
					{
						width : "19%",
						field : "tel_num",
						title : "전화번호"
					},
					{
						width : "20%",
						field : "phone",
						title : "휴대전화"
					},
					
				],
				change : selectRow
			});
			
			function selectRow(e){		//row클릭시 data 전역변수 처리

				var row = e.sender.select();
				var grid = $('#organ_grid').data("kendoGrid");
				var data = grid.dataItem(row);
				$("#name").text(data.emp_name+"("+data.login_id+")");
				$("#birth").text(data.bday);
				$("#position").text(data.position);
				$("#duty").text(data.duty);
				$("#dept").text((data.path_name).replace(/\|/gi," > "));
				$("#phone").text(data.phone);
				$("#compNum").text(data.tel_num);
				$("#faxNum").text(data.fax_num);
				if(data.out_mail != undefined ){
					if(data.out_mail != "" && data.out_domain != "")
					$("#myMail").text(data.out_mail+"@"+data.out_domain);
				}
				$("#compMail").text(data.email_addr+"@"+data.homepg_addr);
				$("#mainWork").text(data.main_work);
				
//		 		$("#photoImage").attr("src", "/gw/commFile/fileDownloadProc.do?fileId="+ data.pic_file_id + "&fileSn=0");
			}
			
			$("#organ_grid").on("dblclick", "tr.k-state-selected", function () {
			    
			    var data = $('#organ_grid').data("kendoGrid").dataItem($(this).closest("tr"));
			    $.each($inputParamSet, function(i,v){
			    	$("#"+v).val(data[i]);
			    })
			    $("#organChartPop").data("kendoWindow").close();
			});
			$(".k-grid-content").height('148px');
		}
		
		$('#organ_searchButton').click(function(){
			var select = $("#organ_searchSelectBox").val();
			var text = $("#organ_searchText").val();
			$memberTemp =$members.filter(function(x){
				return x[select].includes(text);
			});
			mainGrid();
		});
		
		$.extend(this, {
//			  'setActiveButton': setActiveButton
//			, 'setCloseInputEventParam' : setCloseInputEventParam 
			
		});
	}
}(jQuery));