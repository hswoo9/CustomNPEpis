<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<style>
.sub_contents_wrap{min-height:0px;}
.com_ta table th{text-align: center; padding-right: 0px;}
.com_ta table td {border: 1px solid #eaeaea;}
#evalItemDD td{text-align: center; padding-right: 0px;}
</style>


<div class="iframe_wrap" style="width:1500px">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 등록</h4>
		</div>
	</div>

	<form id="evalDataForm">
	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mt10">사업개요</p>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<input type="hidden" value="Y" name="join_select_type" id="join_select_type">
				<input type="hidden" value="${commDetail.committee_seq }" name="committee_seq" id="committee_seq">
				<input type="hidden" value="Y" name="bidding_type" id="bidding_type">
				<input type="hidden" value="${commDetail.req_state }" name="req_state" id="req_state">
				<input type="hidden" value="${commDetail.purc_req_id }" name="purc_req_id" id="purc_req_id">
				<input type="hidden" value="" name="step" id="step">
			
				<table style="width: 100%">
					<colgroup>
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="">
					</colgroup>
					
					<tr>
						<th>요구부서</th>
						<td>	
							<input type="text" name="req_dept_name" id="req_dept_name" readonly="readonly" value="${commDetail eq null ? userInfo.orgnztNm : commDetail.req_dept_name}">			
							<input type="hidden" name="req_dept_seq" id="req_dept_seq" value="${commDetail eq null ? userInfo.dept_seq : commDetail.req_dept_seq}">	
							<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="deptSearchPopup();">		
						</td>
						<th>감사실담당</th>
						<td>	
							<input type="text" name="major_dept" id="major_dept" readonly="readonly" value="${commDetail eq null ? userInfo.orgnztNm : commDetail.major_dept}">
							<input type="hidden" name="major_dept_seq" id="major_dept_seq" style="width: 70px;" value="${commDetail eq null ? userInfo.dept_seq : commDetail.major_dept_seq}">
							<input type="text" name="major_emp_name" id="major_emp_name" style="width: 70px;" readonly="readonly" value="${commDetail eq null ? userInfo.name : commDetail.major_emp_name}">
							<input type="hidden" name="major_emp_seq" id="major_emp_seq" style="width: 70px;" value="${commDetail eq null ? userInfo.uniqId : commDetail.major_emp_seq}">
							<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(1);">
						</td>
						<th>작성자</th>
						<td>	
							<input type="text" readonly="readonly" value="${commDetail eq null ? userInfo.orgnztNm : commDetail.create_dept_name}">
							<input type="text" style="width: 70px;" readonly="readonly" value="${commDetail eq null ? userInfo.name : commDetail.create_emp_name}">
							<input type="text" style="width: 70px;" readonly="readonly" value="${commDetail eq null ? userInfo.classNm : commDetail.create_duty_name}">
						</td>
						<th>작성일자</th>
						<td>	
							<input type="text" readonly="readonly" id="toDay">
						</td>
					</tr>
				
					<tr>
					<!--  20210827 phj
						<th>사업구분</th>
						<td>	
							<input type="hidden" name="biz_type_array" id="biz_type_array">
							<input type="hidden" name="biz_type_code_id" id="biz_type_code_id">
							<select id="biz_type_array_select" class="select_biz_type" style="width: 200px;">
								<c:forEach items="${btcList }" var="list">
									<option value="${list.code }" ${commDetail.biz_type_code_id eq list.code ? "selected='selected'" : ''} >${list.code_kr }</option>
								</c:forEach>
							</select>				
						</td>
					-->
						<th>사업명</th>
						<td>	
							<input type="text" id="title" name="title" value="${commDetail.title }" style="width: 250px;" readonly="readonly">	
							<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="titlePopupBtn();">	
						</td>
						<th>추정가격</th>
						<td>	
							<input type="text" id="budget" name="budget" value="<fmt:formatNumber type="number" maxFractionDigits="3" value="${commDetail.budget}" />" readonly="readonly">&nbsp;원
						</td>
						<th>환산점수</th>
						<td>
							<input type="text" name="rates" style="width: 30px;" maxlength="3" value="${commDetail.rates == null ? 90 : commDetail.rates }"> %
						</td>
                        <th>표준편차</th>
                        <td>
                            <input type="text" id="deviation" name="deviation" value="${commDetail.deviation == null ? 10 : commDetail.deviation }">
                        </td>
					</tr>
					
				</table>
			</div>
		</div>

	</div>


	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mb10">평가개요</p>
	
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<table style="width: 100%">
					<colgroup>
						<col width="80px;">
						<col width="160px;">
						<col width="410px;">
						<col width="80px;">
						<col width="">
					</colgroup>
					<tr>
						<th>평가일시</th>
						<td colspan="2">
							<input type="text" id="eval_s_date" name="eval_s_date" class="date_yyyymmdd" value="${commDetail.eval_s_date2 }"  style="width: 120px;">
							 ~ 
							<input type="text" id="eval_e_date" name="eval_e_date" class="date_yyyymmdd" value="${commDetail.eval_e_date2 }" style="width: 120px;">
							&emsp;&emsp;
							<input type="text" name="eval_s_time" class="eval_time" value="${commDetail.eval_s_time}" style="width: 80px;">
							~
							<input type="text" name="eval_e_time" class="eval_time" value="${commDetail.eval_e_time}" style="width: 80px;">
						</td>
						<th>평가장소</th>
						<td>
							<input type="text" name="eval_place" value="${commDetail.eval_place}" style="width: 400px;">
						</td>
					</tr>	
					
					<tr>
						<th>운영요원</th>
						<td colspan="5">
							<table style="width: 100%;">
								<tr>
									<td>
										<input type="text" name="opr_dept_1" id="opr_dept_1" readonly="readonly" value="${commDetail.opr_dept_1}">
										<input type="hidden" name="opr_dept_seq_1" id="opr_dept_seq_1" value="${commDetail.opr_dept_seq_1}">
										<input type="text" name="opr_emp_name_1" id="opr_emp_name_1" style="width: 70px;" readonly="readonly" value="${commDetail.opr_emp_name_1}">
										<input type="hidden" name="opr_emp_seq_1" id="opr_emp_seq_1" value="${commDetail.opr_emp_seq_1}">
										<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(2, 1);">
									</td>
									<td>
										<input type="text" name="opr_dept_2" id="opr_dept_2" readonly="readonly" value="${commDetail.opr_dept_2}">
										<input type="hidden" name="opr_dept_seq_2" id="opr_dept_seq_2" value="${commDetail.opr_dept_seq_2}">
										<input type="text" name="opr_emp_name_2" id="opr_emp_name_2" style="width: 70px;" readonly="readonly" value="${commDetail.opr_emp_name_2}">
										<input type="hidden" name="opr_emp_seq_2" id="opr_emp_seq_2" value="${commDetail.opr_emp_seq_2}">
										<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(2, 2);">
									</td>
									<td>
										<input type="text" name="opr_dept_3" id="opr_dept_3" readonly="readonly" value="${commDetail.opr_dept_3}">
										<input type="hidden" name="opr_dept_seq_3" id="opr_dept_seq_3" value="${commDetail.opr_dept_seq_3}">
										<input type="text" name="opr_emp_name_3" id="opr_emp_name_3" style="width: 70px;" readonly="readonly" value="${commDetail.opr_emp_name_3}">
										<input type="hidden" name="opr_emp_seq_3" id="opr_emp_seq_3" value="${commDetail.opr_emp_seq_3}">
										<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(2, 3);">
									</td>
									<td>
										<input type="text" name="opr_dept_4" id="opr_dept_4" readonly="readonly" value="${commDetail.opr_dept_4}">
										<input type="hidden" name="opr_dept_seq_4" id="opr_dept_seq_4" value="${commDetail.opr_dept_seq_4}">
										<input type="text" name="opr_emp_name_4" id="opr_emp_name_4" style="width: 70px;" readonly="readonly" value="${commDetail.opr_emp_name_4}">
										<input type="hidden" name="opr_emp_seq_4" id="opr_emp_seq_4" value="${commDetail.opr_emp_seq_4}">
										<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(2, 4);">
									</td>
									<td>
										<input type="text" name="opr_dept_5" id="opr_dept_5" readonly="readonly" value="${commDetail.opr_dept_5}">
										<input type="hidden" name="opr_dept_seq_5" id="opr_dept_seq_5" value="${commDetail.opr_dept_seq_5}">
										<input type="text" name="opr_emp_name_5" id="opr_emp_name_5" style="width: 70px;" readonly="readonly" value="${commDetail.opr_emp_name_5}">
										<input type="hidden" name="opr_emp_seq_5" id="opr_emp_seq_5" value="${commDetail.opr_emp_seq_5}">
										<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(2, 5);">
									</td>
								</tr>
							</table>
						</td>
					</tr>
                    <tr>
                        <th>평가위원장<br>추가수당</th>
                        <td>
                            <input type="text" id="evalCm" name="evalCm" onkeyup="evalCmChange(this);" onchange="evalCmChange(this);" value="<fmt:formatNumber type="number" maxFractionDigits="3" value="${commDetail.eval_cm}" />">&nbsp;원
                        </td>
                    </tr>
					<tr>
						<th>참여기관<br>(업체)</th>
						<td colspan="6">
							<input type="hidden" name="joinOrgList" id="joinOrgList">
							<input type="hidden" name="join_org_cnt" id="join_org_cnt">
							<table style="width: 100%;">
								<colgroup>
									<col width="147px;;">
									<col width="">
								</colgroup>
								<tbody id="joinOrgDD">
									<c:forEach items="${company}" var="list">
										<tr>
											<td><input type="hidden" id="company_name" value="${list.company_name }"><input type="hidden" id="company_type" value="${list.company_type }"><input type="hidden" id="company_seq" value="${list.company_seq}">${list.company_name }</td>								
											<td><input type="text" id="display_title" value="${list.display_title }" class="display_title"><img alt="삭제" style="padding-left:5px; cursor: pointer;" src="<c:url value="/Images/ico/close_btn01.png"/>" onclick="joinDelBtn(this);" ></td>								
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<th>평가분야</th>
						<td>
							<input type="hidden" name="evalItemList" id="evalItemList">
							<input type="button" value="등록" onclick="evalItemPopupBtn();">
							<input type="button" value="불러오기" onclick="evalCommPopupBtn();">
						</td>
						<td colspan="4">
							<table style="width: 100%;">
								<thead>
									<tr>
										<th>항목명</th>
										<th>배점</th>
										<th>100%</th>
										<th>90%</th>
										<th>80%</th>
										<th>70%</th>
										<th>60%</th>
									</tr>
								</thead>
								<tbody id="evalItemDD">
								</tbody>
							</table>
						</td>
					</tr>
				
				
				</table>
			
			</div>
		</div>
	</div>

	</form>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dd style="width: 45%;"></dd>
					<dd>
<!-- 						<input type="button" style="margin-bottom: 15px;" onclick="vcApplyTemp();" value="임시저장">&emsp;&emsp; -->
						<input type="button" style="margin-bottom: 15px;" id="applyBtn" onclick="vcApply();" value="등록하기">
					</dd>
				</dl>
			</div>
		</div>
	</div>
</div>

<div class="pop_wrap" id="joinOrgPopup" style="min-width:800px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div class="top_box gray_box">
				<dl>
					<dt style="margin-right: 25px;">
						기관 선택 
					</dt>
					<dd style="line-height: 25px">
						<select id="joinSelect"style="width: 100px;" onchange="joinSelectChange();">
							<option value="1">erp기관</option>
							<option value="2">신규</option>
						</select>
					</dd>
				</dl>
			</div>
		
		
			<div id="joinOrgGrid"></div>
		</div>
		
		<div class="top_box gray_box">
			<dl>
				<dd style="width: 45%;"></dd>
				<dd>
					<input type="button" style="margin-bottom: 15px;" onclick="addJoinOrgBtn();" value="등록">
				</dd>
			</dl>
		</div>
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

<div class="pop_wrap" id="evalItemPopup" style="min-width:1200px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div class="top_box gray_box">
				<dl>
					<dt style="margin-left: 55px; margin-right: 25px;">
						평가분야 수 <input type="text" id="evalItmeCnt" style="width: 50px;">&nbsp;개
					</dt>
					<dd style="line-height: 25px">
						<input type="button" onclick="evalItemAddBtn();" value="생성">
						<input type="button" onclick="evalItemAddSaveBtn();" value="등록">
					</dd>
				</dl>
			</div>
		
			<table>
				<thead>
					<tr>
						<th style="width: 60px;">순서</th>
						<th>항목명</th>
						<th style="width: 120px;">배점</th>
						<th style="width: 100px;">100%</th>
						<th style="width: 100px;">90%</th>
						<th style="width: 100px;">80%</th>
						<th style="width: 100px;">70%</th>
						<th style="width: 100px;">60%</th>
					</tr>
				</thead>
				<tbody id="evalAddBody" style="height: 150px;">
					<c:forEach items="${item}" var="list" varStatus="st">
						<tr style="height: 40px;">
							<td>${st.count }</td>
							<td><input type="text" id="addItemName" class="" tabindex="${st.count }" value="${list.item_name }" style="width: 80%;"></td>
							<td><input type="text" id="addScore" class="addScore" tabindex="${st.count + item.size()}" value="${list.score }" style="width: 100px;"></td>
							<td><input type="text" id="addScore_1" class="" value="${list.score_1 }" style="width: 50px;"></td>
							<td><input type="text" id="addScore_2" class="" value="${list.score_2 }" style="width: 50px;"></td>
							<td><input type="text" id="addScore_3" class="" value="${list.score_3 }" style="width: 50px;"></td>
							<td><input type="text" id="addScore_4" class="" value="${list.score_4 }" style="width: 50px;"></td>
							<td><input type="text" id="addScore_5" class="" value="${list.score_5 }" style="width: 50px;"></td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot id="evalAddFoot">
					<c:if test="${item.size() > 0}">
						<tr style="height: 40px;"><td>합계</td> <td></td> <td><input type="text" id="addScoreTotal" style="width: 100px;" value="100" readonly="readonly"></td><td colspan="5"></td></tr>
					</c:if>
				</tfoot>
			</table>
		</div>
		
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

<div class="pop_wrap" id="evalCommPopup" style="min-width:1200px; display:none;">
	<div class="pop_con">	
		
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div id="evalCommGrid"></div>
		</div>
		
		<div class="top_box gray_box">
			<dl>
				<dd style="width: 45%;"></dd>
				<dd>
					<input type="button" style="margin-bottom: 15px;" onclick="addEvalCommBtn();" value="등록">
				</dd>
			</dl>
		</div>
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

<div class="pop_wrap" id="titlePopup" style="min-width:1000px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div id="titleGrid"></div>
		</div>
		
		<div class="top_box gray_box">
			<dl>
				<dd style="width: 45%;"></dd>
				<dd>
					<input type="button" style="margin-bottom: 15px;" onclick="addTitleGridBtn();" value="추가">
				</dd>
			</dl>
		</div>
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='../Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;등록 중입니다.</span>		
				</td>
			</tr>
		</table>
	</div>
	<!-- //pop_con -->
</div>

<script>
var gridData1 = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: "<c:url value='/eval/getEvaCommListSearch' />",
            dataType: "json",
            type: "post",
        },
      	parameterMap: function(data, operation) {
      		data.search_major_emp_name = $('#search_major_emp_name').val();
      		data.search_biz_type_array = $('#search_biz_type_array').val();
      		data.search_title = $('#search_title').val();
      		data.search_YYYY = $('#search_YYYY').val();
      		return data;
     	}
    },
    schema: {
      data: function(response) {
    	  return response;
      },
    }
});

var gridData2 = new kendo.data.DataSource({
	serverPaging: false,
    transport: { 
        read:  {
            url: "<c:url value='/eval/joinOrgGridList' />",
            dataType: "json",
            type: "post",
        },
      	parameterMap: function(data, operation) {
      		data.joinType = $('#joinOrgPopup #joinSelect').val();
      		data.search_title = $('#joinOrgPopup  #title').val();
      		data.search_biz_reg_no = $('#joinOrgPopup  #biz_reg_no').val();
      		data.pageType = 'all';
      		return data;
     	}
    },
    schema: {
      data: function(response) {
    	  return response;
      },
    }
});

var gridData3 = new kendo.data.DataSource({
	serverPaging: false,
    transport: { 
        read:  {
            url: "<c:url value='/eval/purcListSearch' />",
            dataType: "json",
            type: "post",
        },
      	parameterMap: function(data, operation) {
      		return data;
     	}
    },
    schema: {
      data: function(response) {
    	  return response;
      },
    }
});


var startDate;
var endDate;
$(function(){
	
	$('#toDay').val(moment().format('YYYY-MM-DD'));
	
	$('#biz_type_array_select').kendoDropDownList();
	
	$('#joinSelect').kendoDropDownList();
	
	$('.eval_time').kendoTimePicker({
		format: "HH:mm",
		interval : 60,
		min:'06:00',
		max:'23:00',
	});
	
	startDate = $('#eval_s_date').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    change: startChange,
	}).data("kendoDatePicker");

	endDate = $('#eval_e_date').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	}).data("kendoDatePicker");
	
	$(".date_yyyymmdd").attr("readonly", true);
	$(".eval_time").attr("readonly", true);
	
	$('#joinOrgPopup').kendoWindow({
	    width: "800px;",
	    title: '참여기관',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
	$('#evalItemPopup').kendoWindow({
	    width: "1200px;",
	    height: "800px",
	    title: '평가분야',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
	$('#evalCommPopup').kendoWindow({
	    width: "1200px;",
	    title: '제안평가 목록',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
	$('#loadingPop').kendoWindow({
	     width: "443px",
	     visible: false,
	     modal: true,
	     actions: [],
	     close: false,
	     title: false,
	 }).data("kendoWindow").center();
	
	$('#titlePopup').kendoWindow({
	    width: "1000px;",
	    title: '구매계약 목록',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
	//평가분야 기존데이터
	$("#evalCommGrid").kendoGrid({
	    dataSource: gridData1,
	    height: 400,
	    sortable: false,
	    pageable: false,
	    selectable: "row",
	    columns: [
    	{
    		field: "major_emp_name",
	        title: "사업담당자",
	        width: "100px",
	        headerTemplate: function(){
				return '사업담당자<br><input type="text" style="width:90%;" id="search_major_emp_name" class="projectHeaderInput">';
	        },
    	},{
    		field: "biz_type_array",
	        title: "구분",
	        width: "200px",
	        headerTemplate: function(){
				return '구분<br><input type="text" style="width:90%;" id="search_biz_type_array" class="projectHeaderInput">';
	        },
    	},{
    		field: "title",
	        title: "사업명",
	        headerTemplate: function(){
				return '사업명<br><input type="text" style="width:90%;" id="search_title" class="projectHeaderInput">';
	        },
    	},{
    		field: "YYYY",
	        title: "년도",
	        width: "100px",
	        headerTemplate: function(){
				return '년도<br><input type="text" style="width:90%;" id="search_YYYY" class="projectHeaderInput">';
	        },
	    }],
	}).data("kendoGrid");
	
	//참여기관
// 	$("#joinOrgGrid").kendoGrid({
// 	    dataSource: gridData2,
// 	    height: 400,
// 	    sortable: false,
// 	    pageable: false,
// 	    selectable: "row",
// 	    change: function(e){
// 	    	$('#joinOrgGrid').getKendoGrid().select().find('input[type=checkbox]').click();
// 	    },
// 	    columns: [
//     	{
// 			width: "80px;",		
//     		template: function(row){
//     			return '<input type="checkbox" style="visibility: hidden;" id="item_'+row.company_seq+'"><label for="item_'+row.company_seq+'"></label>';
//     		}
//     	},{
//     		field: "title",
// 	        title: "회사명",
// 	        headerTemplate: function(){
// 				return '회사명<br><input type="text" style="width:90%;" id="title" class="joinHeaderInput">';
// 	        },
//     	},{
//     		field: "biz_reg_no",
// 	        title: "사업자등록번호",
// 	        headerTemplate: function(){
// 				return '사업자등록번호<br><input type="text" style="width:90%;" id="biz_reg_no" class="joinHeaderInput">';
// 	        },
// 	    }],
// 	}).data("kendoGrid");
	
	
	//g20구매계약 리스트
	$("#titleGrid").kendoGrid({
	    dataSource: gridData3,
	    height: 400,
	    sortable: false,
	    pageable: false,
	    selectable: "row",
	    columns: [
    	{
    		field: "purc_req_title",
	        title: "사업명",
	        headerTemplate: function(){
				return '사업명<br><input type="text" style="width:90%;" id="title" class="joinHeaderInput">';
	        },
    	},{
    		field: "cont_am",
	        title: "사업예산",
	        template: function(row){
    			return getNumtoCom(row.cont_am);
    		},
	        headerTemplate: function(){
				return '사업예산<br><input type="text" style="width:90%;" id="biz_reg_no" class="joinHeaderInput">';
	        },
	    }],
	}).data("kendoGrid");
	
	//불러오기 조회
	$('.projectHeaderInput').on('change', function(){
		$("#evalCommGrid").data("kendoGrid").dataSource.read();
	});

	//기관조회
	$('.joinHeaderInput').on('change', function(){
		joinSelectChange();
	});
	
	
	$(document).on('change', '.addScore', function(){
		var data = addScoreSum();
		
		if(data > 100){
			alert('배점의 합이 100점을 초과 하였습니다.');
			$(this).val('').focus();
			addScoreSum();
			return
		}
		
		addScorePercent();
	});
	
	evalItemAddSaveBtn();
	
	$(document).on('dblclick', '#titleGrid tbody tr', function(){
		addTitleGridBtn();
	});
	
	
});

function startChange(e){
	endDate.min(startDate.value());
	endDate.value(startDate.value());
}

function addScorePercent(){
	
	$.each($('.addScore'), function(i, v){
		$(v).closest('tr').find('#addScore_1').val(qksdhffla(Number(v.value)));
// 		$(v).closest('tr').find('#addScore_2').val(qksdhffla(Number(v.value) * 0.95));
// 		$(v).closest('tr').find('#addScore_3').val(qksdhffla(Number(v.value) * 0.9));
// 		$(v).closest('tr').find('#addScore_4').val(qksdhffla(Number(v.value) * 0.85));
// 		$(v).closest('tr').find('#addScore_5').val(qksdhffla(Number(v.value) * 0.8));
		$(v).closest('tr').find('#addScore_2').val(qksdhffla(Number(v.value) * 0.9));
		$(v).closest('tr').find('#addScore_3').val(qksdhffla(Number(v.value) * 0.8));
		$(v).closest('tr').find('#addScore_4').val(qksdhffla(Number(v.value) * 0.7));
		$(v).closest('tr').find('#addScore_5').val(qksdhffla(Number(v.value) * 0.6));
	});
	
}

function addScoreSum(){
	
	var scoreTotal = 0;	
	$.each($('.addScore'), function(i, v){
		scoreTotal += Number($(v).val());
	});
	$('#addScoreTotal').val(scoreTotal);
	return scoreTotal;
}

function deptSearchPopup(){
	window.open( _g_contextPath_ +'/common/deptPopup', '조직도', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=355, height=700');
}

function deptPopupClose(deptSeq, deptName){
	$('#req_dept_name').val(deptName);
	$('#req_dept_seq').val(deptSeq);
}

function userSearchPopup(code, no){
	window.open( _g_contextPath_ +'/common/userPopup?code='+code+'&no='+no , '조직도', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=875, height=700');
}

function userPopupClose(row, code, no){
	if(code == 1){
		$('#major_dept').val(row.dept_name);
		$('#major_dept_seq').val(row.dept_seq);
		$('#major_emp_name').val(row.emp_name);
		$('#major_emp_seq').val(row.emp_seq);
	
	}else if(code = 2){
		$('#opr_dept_' + no).val(row.dept_name);
		$('#opr_dept_seq_' + no).val(row.dept_seq);
		$('#opr_emp_name_' + no).val(row.emp_name);
		$('#opr_emp_seq_' + no).val(row.emp_seq);
	}
}

var itemArray = new Array();
function vcApply(){
	
	var joinArray = new Array();
	
	var joinOrgList = $('#joinOrgDD tr');
	var itemList = $('#evalItemDD tr');
	
	if(joinOrgList.length == 0){
		alert('참여기관을 선택해 주세요.');
		return
	}else{
		$('#join_org_cnt').val(joinOrgList.length);	
	}

	$.each(joinOrgList, function(i, v){
		
		var data = {
				company_seq : $(v).find('#company_seq').val(),
				display_title : $(v).find('#display_title').val(),
				company_name : $(v).find('#company_name').val(),
				company_type : 'A',
		}
		
		joinArray.push(data);
		
	});

	if(itemArray.length == 0){
		alert('평가분야를 선택해 주세요.');
		return
	}
	
	for (var i = 0; i < itemArray.length; i++) {
		
		if(itemArray[i].score == '' || itemArray[i].score <= 0){
			alert('배점을 입력해 주세요.');
			return
		}
		
	};

	if(confirm('등록 하시겠습니까?')){
	
		$('#biz_type_array').val($('#biz_type_array_select option:selected').text());
		$('#biz_type_code_id').val($('#biz_type_array_select').val());
		
		$('#evalItemList').val(JSON.stringify(itemArray));
		$('#joinOrgList').val(JSON.stringify(joinArray));
		
		$('#step').val('A');
		
		$.ajax({
				url: "<c:url value='/eval/evaluationProposalViewSave' />",
				data : $('#evalDataForm').serialize(),
				type : 'POST',
				success: function(result){
					alert('등록 하였습니다.');
					location.href = "<c:url value='/eval/evaluationProposalList'/>";
					
				},
				beforeSend: function () {
		        	$('#loadingPop').data("kendoWindow").open();
		        },
		        complete: function () {
		        	$('#loadingPop').data("kendoWindow").close();
		        },
		});
		
	} 
	
}

//임시저장
function vcApplyTemp(){
	
var joinArray = new Array();
	
	var joinOrgList = $('#joinOrgDD tr');
	var itemList = $('#evalItemDD tr');
	
	$('#join_org_cnt').val(joinOrgList.length);	

	$.each(joinOrgList, function(i, v){
		
		var data = {
				company_seq : $(v).find('#company_seq').val(),
				display_title : $(v).find('#display_title').val(),
				company_name : $(v).find('#company_name').val(),
				company_type : 'A',
		}
		
		joinArray.push(data);
		
	});

	$('#biz_type_array').val($('#biz_type_array_select option:selected').text());
	$('#biz_type_code_id').val($('#biz_type_array_select').val());
	
	$('#evalItemList').val(JSON.stringify(itemArray));
	$('#joinOrgList').val(JSON.stringify(joinArray));
	$('#step').val('I');
	
	$.ajax({
			url: "<c:url value='/eval/evaluationProposalViewSave' />",
			data : $('#evalDataForm').serialize(),
			type : 'POST',
			success: function(result){
				alert('임시 저장 하였습니다.');
				$('#committee_seq').val(result.committee_seq);
				//저장 후 키값이 필요할거 같다 화면은 그냥 현재 페이지 유지
			},
			beforeSend: function () {
	        	$('#loadingPop').data("kendoWindow").open();
	        },
	        complete: function () {
	        	$('#loadingPop').data("kendoWindow").close();
	        },
	});
	
}

function evalItemPopupBtn(){
	
	$('#evalItemPopup').data("kendoWindow").center().open();
}

function joinOrgBtn(){
	
	$('#joinOrgPopup').data("kendoWindow").center().open();
	$("#joinOrgGrid").data("kendoGrid").dataSource.read();
	
}

function addJoinOrgBtn(){
	
	$('#join_select_type').val($('#joinOrgPopup #joinSelect').val());
	
	$('#joinOrgDD').empty();
	
	var ss = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	var joinCnt = 0;
	
	$.each($('#joinOrgGrid input[type=checkbox]'), function(i, v){
		
		if($(v).prop('checked')){
			var row = $('#joinOrgGrid').data("kendoGrid").dataItem($(v).closest('tr'));
			
			var html = 	'<tr>        '
				+'	<td><input type="hidden" id="company_seq" value="'+row.company_seq+'">'+row.title+'</td>'								
				+'	<td><input type="text" id="display_title" value="기관-'+ss[joinCnt]+'"><img alt="삭제" style="padding-left:5px; cursor: pointer;" src="<c:url value="/Images/ico/close_btn01.png"/>" onclick="joinDelBtn(this);" ></td>'								
				+'</tr>       ';

			$('#joinOrgDD').append(html);
			
			joinCnt++;
			
		}
		
	});
	
	$('#joinOrgPopup').data("kendoWindow").close();
	
}

function joinDelBtn(e){
	
	$(e).closest('tr').remove();
	
}

function evalItemAddBtn(){
	
	var rowCnt = $('#evalItmeCnt').val();
	
	$('#evalAddBody').empty();
	$('#evalAddFoot').empty();
	                                                          
	for (var i = 1; i <= rowCnt; i++) {
		
		var itemTemp = '<tr style="height: 40px;">                                      '+
		'	<td>'+i+'</td>'+
		'	<td><input type="text" id="addItemName" class="" tabindex="'+i+'" style="width: 80%;"></td>'+
		'	<td><input type="text" id="addScore" class="addScore" tabindex="'+(i+rowCnt)+'" style="width: 100px;"></td>'+
		'	<td><input type="text" id="addScore_1" class="" style="width: 50px;"></td>'+
		'	<td><input type="text" id="addScore_2" class="" style="width: 50px;"></td>'+
		'	<td><input type="text" id="addScore_3" class="" style="width: 50px;"></td>'+
		'	<td><input type="text" id="addScore_4" class="" style="width: 50px;"></td>'+
		'	<td><input type="text" id="addScore_5" class="" style="width: 50px;"></td>'+
		'</tr>';
		
		$('#evalAddBody').append(itemTemp);
	}
	
	$('#evalAddFoot').append('<tr style="height: 40px;"><td>합계</td> <td></td> <td><input type="text" id="addScoreTotal" style="width: 100px;" readonly="readonly"></td><td colspan="5"></td></tr>');
	
}

function evalItemAddSaveBtn(){
	
	var sum = addScoreSum();
	var tr = $('#evalAddBody tr').length;
	
	if(tr > 0){
		if(sum < 100){
			alert('배점의 합이 100점 미만입니다.');	
			return
		}else if(sum > 100){
			alert('배점의 합이 100점을 초과 하였습니다.');
			return
		}
	}
	
	var addList = new Array();
	
	$.each($('#evalAddBody tr'), function(i, v){
		
		var data = {
				item_name : $(v).find('#addItemName').val(),
				score : $(v).find('#addScore').val(),
				score_1 : $(v).find('#addScore_1').val(),
				score_2 : $(v).find('#addScore_2').val(),
				score_3 : $(v).find('#addScore_3').val(),
				score_4 : $(v).find('#addScore_4').val(),
				score_5 : $(v).find('#addScore_5').val(),
		}
		
		addList.push(data);
		
	});
	
	evalItemAdd(addList);
	
	$('#evalItemPopup').data("kendoWindow").close();
	
}

//아이템 추가 그리기
function evalItemAdd(itemList){
	
	itemArray = new Array();
	
	$('#evalItemDD').empty();
	
	$.each(itemList, function(i, v){
		
		var html = '<tr>';
			html += '<td style="text-align: left; padding-left: 25px;">'+ v.item_name +'</td>';
			html += '<td>'+ v.score +'</td>';
			html += '<td>'+ v.score_1 +'</td>';
			html += '<td>'+ v.score_2 +'</td>';
			html += '<td>'+ v.score_3 +'</td>';
			html += '<td>'+ v.score_4 +'</td>';
			html += '<td>'+ v.score_5 +'</td>';
			html += '</tr>';
		
		$('#evalItemDD').append(html);

		var data = {
				item_name : v.item_name,
				score : v.score,
				score_1 : v.score_1,
				score_2 : v.score_2,
				score_3 : v.score_3,
				score_4 : v.score_4,
				score_5 : v.score_5,
		}
		
		itemArray.push(data);
		
	});
	
}

function evalCommPopupBtn(){
	$('#evalCommPopup').data("kendoWindow").center().open();
	$('.projectHeaderInput').val('');
	$("#evalCommGrid").data("kendoGrid").dataSource.read();
}

function addEvalCommBtn(){
   	var grid = $('#evalCommGrid').getKendoGrid();
   	var row = grid.dataItem(grid.select());
   	
   	if(row == null){
   		alert('제안평가를 선택해 주세요.');
   		return
   	}
   	
   	$.ajax({
		url: "<c:url value='/eval/getEvalCommItemList' />",
		data : {code : row.committee_seq},
		type : 'POST',
		success: function(result){
			evalItemAdd(result);
			$('#evalCommPopup').data("kendoWindow").close();
		}
	
   	});
   	
}

function joinSelectChange(){
	$("#joinOrgGrid").data("kendoGrid").dataSource.read();
}

function titlePopupBtn(){
	
	$('#titlePopup').data("kendoWindow").center().open();
	$("#titleGrid").data("kendoGrid").dataSource.read();
	
}

function addTitleGridBtn(){
	
 	var grid = $('#titleGrid').getKendoGrid();
   	var row = grid.dataItem(grid.select());
   	
   	if(row == null){
   		alert('사업을 선택해 주세요.');
   		return
   	}
   	
   	$('#title').val(row.purc_req_title);
   	$('#budget').val(getNumtoCom(row.cont_am));
   	$('#req_state').val(row.req_state);
   	$('#purc_req_id').val(row.purc_req_id);
   	
   	$.ajax({
		url: "<c:url value='/eval/getPurcBiddingList' />",
		data : {code : row.purc_req_id},
		type : 'POST',
		success: function(result){
			biddingAdd(result);
			$('#titlePopup').data("kendoWindow").close();
		}
	
   	});
	
}

function biddingAdd(list){
	$('#joinOrgDD').empty();
	
	var ss = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	var joinCnt = 0;
	
	$.each(list, function(i, v){
		
		var html = 	'<tr>        '
					+'	<td><input type="hidden" id="company_name" value="'+v.tr_nm+'"><input type="hidden" id="company_seq" value="'+v.tr_cd+'">'+v.tr_nm+'</td>'								
					+'	<td><input type="text" id="display_title" value="기관-'+ss[joinCnt]+'"><img alt="삭제" style="padding-left:5px; cursor: pointer;" src="<c:url value="/Images/ico/close_btn01.png"/>" onclick="joinDelBtn(this);" ></td>'								
					+'</tr>       ';
	
		$('#joinOrgDD').append(html);
		
		joinCnt++;
		
	});
}

//소수점 5자리 반올림
function qksdhffla(v){
	var txt = 0;
	
	if(v % 1 == 0) { 
		txt = v;
	}else{
		txt = v.toFixed(5);
		for (var i = 0; i < 5; i++) {
			txt = txt.replace(/0$/g, '');
		}
		
	}
	
	return txt;
}

function budgetChange(e){
	$('#budget').val(getNumtoCom( getComtoNum($($('#budget')).val()) ));
}

function evalCmChange(e){
    $('#evalCm').val(getNumtoCom( getComtoNum($($('#evalCm')).val()) ));
}

</script>


