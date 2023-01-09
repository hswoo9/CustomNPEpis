<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<html>
<head>

 <script type="text/javascript">
			/*팝업 위치설정*/
			$(document).ready(function() {
				 $('.top_box input[type=text]').on('keypress', function(e) {
						if (e.key == 'Enter') {
							$('#grid').data('kendoGrid').dataSource.read();
						};
					});
				 
				var myWindow = $("#popUp");
			     undo = $("#add");
				
				 undo.click(function() {
					 $('#groupSel').val('');
					 	$('#group_code').val('');
						$('#group_code_kr').val('');
						$('#group_code_desc').val('');
						$('#code').val('');
						$('#code_kr').val('');
						$('#code_desc').val('');
						$('#code_val').val('');
						$('#remark').val('');
						var groupCd = JSON.parse('${groupCd}');
						 groupCd.unshift({group_code : "", group_code : ""});
						 $("#groupSel").kendoComboBox({
						      
						      dataSource: groupCd,
						      dataTextField: "group_code",
								dataValueField: "group_code",
								index: 0,
						});
				     myWindow.data("kendoWindow").open();
				     undo.fadeOut();
				     
				 });
				
				 function onClose() {
				     undo.fadeIn();
				 }
				 
				 $("#cancle").click(function(){
					 myWindow.data("kendoWindow").close();
				 });
				 
				 myWindow.kendoWindow({
				     width: "440px",
				    height: "630px",
				     visible: false,
				     modal: true,
				     actions: [
				    	 "Close"
				     ],
				     close: onClose
				 }).data("kendoWindow").center();
				
				 
				 var myWindow2 = $("#ModPopUp");
			     undo2 = $("#modBtn");
			     
				 undo2.click(function() {
					var id = $('#common_code_id').val();
					if (id == '' || id == null) {
						alert('수정할 건을 선택해주세요.')
					} else {
						myWindow2.data("kendoWindow").open();
					    undo2.fadeOut();	
					}
				 });
				
				 function onClose2() {
					 $('#common_code_id').val('');
					 $('#group_code2').val('');
						$('#group_code_kr2').val('');
						$('#group_code_desc2').val('');
						$('#code2').val('');
						$('#code_kr2').val('');
						$('#code_desc2').val('');
						$('#code_val2').val('');
						$('#remark2').val('');
				     undo2.fadeIn();
				 }
				 
				 $("#modCancle").click(function(){
					 myWindow2.data("kendoWindow").close();
				 });
				 
				 myWindow2.kendoWindow({
				     width: "440px",
				    height: "630px",
				     visible: false,
				     modal: true,
				     actions: [
				    	 "Close"
				     ],
				     close: onClose2
				 }).data("kendoWindow").center();	
				 
				 var myWindow3 = $("#groupPop");
			     undo3 = $("#groupAdd");
			     
				 undo3.click(function() {
					 	$('#groupSel').val('').attr('disabled', true);					 	
					 	$('#group_code').val('');
						$('#group_code_kr').val('');
						$('#group_code_desc').val('');
						$('#code').val('');
						$('#code_kr').val('');
						$('#code_desc').val('');
						$('#code_val').val('');
						$('#remark').val('');
					 
						myWindow3.data("kendoWindow").open();
					    undo3.fadeOut();	
					
				     
				 });
			
				 function onClose3() {
					 $('#groupCdAdd').val('');
					 $('#groupKrAdd').val('');
					 $('#groupDescAdd').val('');
					 $('#groupSel').val('').attr('disabled', false);
				     undo3.fadeIn();
				 }
				 $("#cancle3").click(function(){
					 myWindow3.data("kendoWindow").close();
				 });
				 myWindow3.kendoWindow({
				     width: "500px",
				    height: "280px",
				     visible: false,
				     modal: true,
				     actions: [
				    	 "Close"
				     ],
				     close: onClose3
				 }).data("kendoWindow").center();	
				 
				 var groupCd = JSON.parse('${groupCd}');
				 groupCd.unshift({group_code : "", group_code : ""});
				 $("#groupSel").kendoComboBox({
				      
				      dataSource: groupCd,
				      dataTextField: "group_code",
						dataValueField: "group_code",
						index: 0,
				});
				 
				 var groupSel = $("#groupSel").data("kendoComboBox");
				 groupSel.input.attr("readonly", true)
	    		    .on("keydown", function(e) {
	    		      if (e.keyCode === 8) {
	    		        e.preventDefault();
	    		      }
	    		    });
				 
				 $('#groupSel').on('change', function(){	
					 
					 var data = {
						    group_code : $('#groupSel').val()
					 }
					 
						$.ajax({
							url: _g_contextPath_+"/commcode/getGroupCode",
							dataType : 'json',
							data : data,
							type : 'POST',
							success: function(result){
								console.log(result);
								$('#group_code').val(result[0].group_code);
								$('#group_code_kr').val(result[0].group_code_kr);
								$('#group_code_desc').val(result[0].group_code_desc);
								
							}
						});					 
				 });
				 
				 $('#repCheck').on('click', function(){
					 if ($('#groupCdAdd').val() == null || $('#groupCdAdd').val() == '') {
						 alert('그룹코드를 입력해주세요')
					 } else {
						 
						 var data = {
							group_code : $('#groupCdAdd').val()
						}
						
						 $.ajax({
								url: _g_contextPath_+"/commcode/getGroupCode",
								dataType : 'json',
								data : data,
								type : 'POST',
								success: function(result){
									if (result.length > 0) {
										alert('이미 존재하는 그룹코드입니다.');
										$('#groupCdAdd').val('');
									} else {
										alert('사용 가능한 그룹코드입니다.');
										$('#repYn').val('Y');
									}
									
									
								}
						});
					 }						 
				 });
				 
				 $('#groupAddBtn').on('click', function(){
					 
					 if ($('#groupCdAdd').val() == null || $('#groupCdAdd').val() == '') {
						 alert('그룹코드를 입력해주세요.');
					 } else if ($('#repYn').val() != 'Y') {
						 alert('중복체크를 해주세요.');
					 } else if ($('#groupKrAdd').val() == null || $('#groupKrAdd').val() == '') {
						 alert('그룹코드명를 입력해주세요.');
					 } else {
						 
						 var data = {
									group_code : $('#groupCdAdd').val(),
									group_code_kr : $('#groupKrAdd').val(),
									group_code_desc : $('#groupDescAdd').val()
								}
								
								 $.ajax({
										url: _g_contextPath_+"/commcode/addCommCode",
										dataType : 'json',
										data : data,
										type : 'POST',
										success: function(result){
											console.log(result);
											location.reload();
											
										}
								});						 
						 
					 }
				 });
				 
				 
				 
			});
			
			
			
			 
			
	</script> 
	
<title> 공통코드</title>

</head>
<style type="text/css">
.k-header .k-link{
   text-align: center;
 
}
.k-grid-content>table>tbody>tr
{
   text-align: center;
}  
</style>
<body>
	<!-- iframe wrap -->
	<div class="iframe_wrap" style="min-width:1100px">
	
		<!-- 컨텐츠타이틀영역 -->
		<div class="sub_title_wrap">
			
			<div class="title_div">
				<h4>공통코드</h4>
			</div>
		</div>
		
		<div class="sub_contents_wrap">
		<p class="tit_p mt5 mt20">공통코드 관리</p>
			<div class="top_box">
								<dl>
									<dt  class="ar" style="width:65px" >그룹코드명</dt>
									<dd>
										<input type="text" id="searchGCode" onkeyup="searchBtn();" style="width:150px;text-align: " placeholder="그룹코드명 입력"/>
									</dd>
									<dt  class="ar" style="width:65px" >코드명</dt>
									<dd>
										<input type="text" id="searchCode" onkeyup="searchBtn();" style="width:150px;text-align: " placeholder="코드명 입력"/>
									</dd>
									
								</dl>
								
							</div>
						<!-- 버튼 -->
							<div class="btn_div">	
								<div class="right_div">
									<div class="controll_btn p0">		
										
										<button type="button" id="groupAdd">그룹코드 추가</button>							
										<button type="button" id="add">추가</button>
										<button type="button" id="modBtn">수정</button>										
										<button type="button" id="delBtn"  onclick="delBtn();">삭제</button>
									</div>
								</div>
							</div>
														
							<div class="com_ta2 mt15">
							    <div id="grid"></div>
							</div>						
					
		</div><!-- //sub_contents_wrap -->
	</div><!-- iframe wrap -->
	
	
	
<!--// 팝업----------------------------------------------------- -->
	<!-- <div class="modal"></div> -->


	
	<script type="text/javascript">
	

var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: _g_contextPath_+'/commcode/codeList',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
        	data.group_code_kr = $('#searchGCode').val();
        	data.code_kr = $('#searchCode').val();
        	data.notIn = '';
     	return data;
     	}
    },
    schema: {
      data: function(response) {
    	console.log(response);
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      },
	      model: {
	          fields: {

	        	  common_code_id  : { type: "string" },
	       
	          }
	      }
    }
});


$(function(){
	
	mainGrid();

});

function gridReload(){
	$("#grid").data("kendoGrid").dataSource.page(1);
}

function mainGrid(){
	//캔도 그리드 기본
	var grid = $("#grid").kendoGrid({
        dataSource: dataSource,
        height: 500,
        
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes: true,
            buttonCount: 5
        },
        persistSelection: true,
        selectable: "multiple",
        columns: [
        	{ template: "<input type='checkbox' id='pk#=common_code_id#'  class='k-checkbox checkbox'/><label for='pk#=common_code_id#' class='k-checkbox-label'></label>",
        	width:50,	
        	},
        	 {
            field: "group_code",
            title: "그룹코드",
            width: "180px"
        }, {
            field: "group_code_kr",
            title: "그룹코드명",
        }, {
            field: "group_code_desc",
            title: "그룹코드설명",
        }, {
            field: "code",
            title: "코드",
            width: "100px"
        }, {
            field: "code_kr",
            title: "코드명",
        }, {
            field: "code_desc",
            title: "코드설명",
        }, {
            field: "code_val",
            title: "코드값",
            width: "100px"
        }, {
            field: "remark",
            title: "비고",
        }],
        change: function (e){
        	codeGridClick(e)
        }
    }).data("kendoGrid");
	
	grid.table.on("click", ".checkbox", selectRow);
	
	var checkedIds = {};
	
	// on click of the checkbox:
	function selectRow(){
		
		var checked = this.checked,
		row = $(this).closest("tr"),
		grid = $('#grid').data("kendoGrid"),
		dataItem = grid.dataItem(row);
		
		checkedIds[dataItem.CODE_CD] = checked;
		if (checked) {
			//-select the row
			row.addClass("k-state-selected");
		} else {
			//-remove selection
			row.removeClass("k-state-selected");
		}
		
	}
	function codeGridClick(){
		 var rows = grid.select();
		var record;
		rows.each( function(){
			record = grid.dataItem($(this));
			console.log(record);
		}); 
		subReload(record);
	}
}

function subReload(record){
	
	$('#common_code_id').val(record.common_code_id);
	$('#group_code2').val(record.group_code);
	
	$('#group_code_kr2').val(record.group_code_kr);
	$('#group_code_desc2').val(record.group_code_desc);
	$('#code2').val(record.code);
	$('#code_kr2').val(record.code_kr);
	$('#code_desc2').val(record.code_desc);
	$('#code_val2').val(record.code_val);
	$('#remark2').val(record.remark);
	
	$('#etc2_1').val(record.etc1);
	$('#etc2_2').val(record.etc2);
	$('#etc2_3').val(record.etc3);
	$('#etc2_4').val(record.etc4);
	$('#etc2_5').val(record.etc5);
	
	
} 
	

function delBtn(){
	
	
	var ch = $('.checkbox:checked');
	var data = new Array();
	grid = $('#grid').data("kendoGrid");
	$.each(ch, function(i,v){
		dataItem = grid.dataItem($(v).closest("tr"));
		data.push(dataItem.common_code_id);
	});
	
	if (ch.length < 1) {
		alert('삭제할 건을 체크하세요');
	} else {
		var result = confirm('삭제하시겠습니까?');
		if (result) {
			$.ajax({
				url: _g_contextPath_+"/commcode/delCommCode",
				dataType : 'text',
				data : {data : data.join(',')},
				type : 'POST',
				success : function(result){
					mainGrid();
				}
			})
		} else {
			
		}
		
	}
	
}

		 function saveBtn(){
				var data = {
						group_code : $('#group_code').val(),
						group_code_kr : $('#group_code_kr').val(),
						group_code_desc : $('#group_code_desc').val(),
						code : $('#code').val(),
						code_kr : $('#code_kr').val(),
						code_desc : $("#code_desc").val(),
						code_val : $('#code_val').val(),
						etc1 : $('#etc1').val(),
						etc2 : $('#etc2').val(),
						etc3 : $('#etc3').val(),
						etc4 : $('#etc4').val(),
						etc5 : $('#etc5').val(),
						remark : $('#remark').val()
						
				}
				
				$.ajax({
					url: _g_contextPath_+"/commcode/addCommCode",
					dataType : 'text',
					data : data,
					type : 'POST',
					success: function(result){
						
						
						gridReload();
					}
				});
				$("#popUp").data("kendoWindow").close();
			} 

		 function modBtn(){
			 	
				var data = {
						common_code_id : $('#common_code_id').val(),
						group_code : $('#group_code2').val(),
						group_code_kr : $('#group_code_kr2').val(),
						group_code_desc : $('#group_code_desc2').val(),
						code : $('#code2').val(),
						code_kr : $("#code_kr2").val(),
						code_desc : $('#code_desc2').val(),
						code_val : $('#code_val2').val(),
						etc1 : $('#etc2_1').val(),
						etc2 : $('#etc2_2').val(),
						etc3 : $('#etc2_3').val(),
						etc4 : $('#etc2_4').val(),
						etc5 : $('#etc2_5').val(),
						remark : $('#remark2').val()
						
				}
				
				$.ajax({
					url: _g_contextPath_+"/commcode/commonMod",
					dataType : 'json',
					data : data,
					type : 'POST',
					success: function(result){
						
						gridReload();
						
					}
				});
				$("#ModPopUp").data("kendoWindow").close();
				
				
			}
		 function searchBtn() {
				
			 gridReload();
			}
	</script>
	<div class="pop_wrap_dir" id="popUp" style="width:440px;">
		<div class="pop_head">
			<h1>공통코드</h1>
			
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
				<table>
					<colgroup>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					
					<tr>
						<th>그룹코드</th>
						<td class="le">
							
							<%-- <select id="groupSel" class="selectmenu" onchange="" style="width: 102px;height:24px ;margin-top:0px;margin-left: ">
									<option value="all">전체</option>
								<c:forEach items="${groupCd }" var="list">
									<option value="${list.group_code }">${list.group_code }</option>
								</c:forEach>
							</select> --%>
							<input type="text" id="groupSel" style="width: 300px" />
							<input type="hidden" name="group_code" id="group_code"  value="" style="width:100%;"/>
							
						</td>
					</tr>
					<tr>
						<th>그룹코드명</th>
						<td class="le">
							<input type="text" name="group_code_kr" id="group_code_kr"  value="" style="width:100%;"/>
						</td>
					</tr>
					<tr>
						<th>그룹코드설명</th>
						<td class="le">
							<input type="text" name="group_code_desc" id="group_code_desc"  value="" style="width:100%;"/>
						</td>
					</tr>
					<tr>
						<th>코드</th>
						<td class="le">
							
							<input type="text" name="code" id="code" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드명</th>
						<td class="le">
							
							<input type="text" name="code_kr" id="code_kr" value="" style="width:100%;" />
						</td>
					</tr>
					<tr>
						<th>코드설명</th>
						<td class="le">
							
							<input type="text" name="code_desc" id="code_desc" value="" style="width:100%;" />
						</td>
					</tr>
					<tr>
						<th>코드값</th>
						<td class="le">
							
							<input type="text" name="code_val" id="code_val" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(1)</th>
						<td class="le">
							
							<input type="text" name="etc1" id="etc1" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(2)</th>
						<td class="le">
							
							<input type="text" name="etc2" id="etc2" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(3)</th>
						<td class="le">
							
							<input type="text" name="etc3" id="etc3" etc1="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(4)</th>
						<td class="le">
							
							<input type="text" name="etc4" id="etc4" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(5)</th>
						<td class="le">
							
							<input type="text" name="etc5" id="etc5" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td class="le">
							<input type="text" name="remark" id="remark" value="" style="width:100%;"/>
						</td>
					</tr>					
				</table>
			</div>			
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="submit" id="saveBtn" onclick="saveBtn();" value="저장" />
				<input type="button" class="gray_btn" id="cancle" value="취소" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->	

	

		<div class="pop_wrap_dir" id="ModPopUp" style="width:440px;">
		<div class="pop_head">
			<h1>공통코드</h1>
			
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
				<table>
					<colgroup>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					
					<tr>
						<th>그룹코드</th>
						<td class="le">
							<input type="hidden" name="common_code_id" id="common_code_id" value="" style="width:40%;" />
							<input type="text" name="group_code" id="group_code2" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>그룹코드명</th>
						<td class="le">
							<input type="text" name="group_code_kr" id="group_code_kr2"  value="" style="width:100%;"/>
						</td>
					</tr>
					<tr>
						<th>그룹코드설명</th>
						<td class="le">
							<input type="text" name="group_code_desc" id="group_code_desc2"  value="" style="width:100%;"/>
						</td>
					</tr>
					<tr>
						<th>코드</th>
						<td class="le">
							
							<input type="text" name="code" id="code2" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드명</th>
						<td class="le">
							
							<input type="text" name="code_kr" id="code_kr2" value="" style="width:100%;" />
						</td>
					</tr>
					<tr>
						<th>코드설명</th>
						<td class="le">
							
							<input type="text" name="code_desc" id="code_desc2" value="" style="width:100%;" />
						</td>
					</tr>
					<tr>
						<th>코드값</th>
						<td class="le">
							
							<input type="text" name="code_val" id="code_val2" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(1)</th>
						<td class="le">
							
							<input type="text" name="etc1" id="etc2_1" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(2)</th>
						<td class="le">
							
							<input type="text" name="etc2" id="etc2_2" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(3)</th>
						<td class="le">
							
							<input type="text" name="etc3" id="etc2_3" etc1="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(4)</th>
						<td class="le">
							
							<input type="text" name="etc4" id="etc2_4" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>코드속성(5)</th>
						<td class="le">
							
							<input type="text" name="etc5" id="etc2_5" value="" style="width:40%;" />
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td class="le">
							<input type="text" name="remark" id="remark2" value="" style="width:100%;"/>
						</td>
					</tr>					
				</table>
			</div>			
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="submit" id="saveBtn" onclick="modBtn();" value="저장" />
				<input type="button" class="gray_btn" id="modCancle" value="취소" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
	
	<div class="pop_wrap_dir" id="groupPop" style="width:500px;">
		<div class="pop_head">
			<h1>그룹코드 추가</h1>
			
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
				<table>
					<colgroup>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					
					<tr>
						<th>그룹코드</th>
						<td class="le">
							
							<input type="text" name="groupCdAdd" id="groupCdAdd"  value="" style="width:70%;"/>
							<input type="hidden" id="repYn"  value="" style="width:70%;"/>
							<input type="button" id="repCheck" value="중복체크" />
						</td>
					</tr>
					<tr>
						<th>그룹코드명</th>
						<td class="le">
							<input type="text" name="groupKrAdd" id="groupKrAdd"  value="" style="width:100%;"/>
						</td>
					</tr>
					<tr>
						<th>그룹코드설명</th>
						<td class="le">
							<input type="text" name="groupDescAdd" id="groupDescAdd"  value="" style="width:100%;"/>
						</td>
					</tr>
									
				</table>
			</div>			
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="submit" id="groupAddBtn" value="저장" />
				<input type="button" class="gray_btn" id="cancle3" value="취소" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
	
</body>
</html>

