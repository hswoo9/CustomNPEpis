<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<body>

	<input type="hidden" id="comp_seq" value="${userInfo.compSeq }" />
	<!-- 컨텐츠타이틀영역 -->

	<div class="pop_wrap_dir top_box" style="width: 1300px;">
		<p class="tit_p mt5 mt20"></p>

		<div class="com_ta">
			<div class="com_ta2 mt15">
				<div class="com_ta4 mt15">
					<div id="gridList2">
						<table>
							<thead>
								<tr>
									</th>
									<th style="text-align: center; width: 3%;"><input type="checkbox" id="headChk" style="margin-left: 7px;"><label for="headChk"> </th>
									<th style="text-align: center; width: 7%;">출장일</th>
									<th style="text-align: center; width: 8%;">부서명</th>
									<th style="text-align: center; width: 6%;">성명</th>
									<th style="text-align: center; width: 6%;">업무차량 사용여부</th>
									<th style="text-align: center; width: 15%;">목적</th>
									<th style="text-align: center; width: 5%;">비용</th>
								</tr>
							</thead>
							<tbody>
								<tr class="emptyClass">
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="btn_div">
				<div class="right_div">
					<div class="controll_btn p0">

						<button type="button" id="btn_ban0">반영</button>
					</div>
				</div>
			</div>
		</div>

	</div>





	<script>
		$(function() {
			
			 $('#btn_ban0').bind('click', function () {
				setParentRow();
			}); 
			
			$("#headChk").on('click',function() {
				
				if($("#headChk").is(':checked')){
					
				$("input:checkbox").each(function() {

					$(this).prop("checked", true);

				});
			} 
				else{
				$("input:checkbox").each(function() {

					$(this).prop("checked", false);

				});
					
				}
					

			});




			
			
			if($(".emptyClass").size() =='1'){
				$("#gridList2 tbody").empty();
			}
			
			var ch = window.opener.$('#gridList tbody tr').not(".used");
			console.log(ch);

			$.each(ch, function (index, v) {
				
				var pk 			=	 $(v).attr('id');
				var BTEmpNo 	= 	$(v).children('[name=BTEmpNo]').val();
				var BTTripNo 	= 	$(v).children('[name=BTTripNo]').val();
				var BTTimeFR	= 	$(v).children('[name=BTTimeFR]').val();
				var BTTimeEND	= 	$(v).children('[name=BTTimeEND]').val( );
				var BTLocation 	= 	$(v).children('[name=BTLocation]').val();
				var TRIP_DAY_FR	= 	$(v).children('[name=TRIP_DAY_FR]').text();
				var dept_name	= 	$(v).children('[name=dept_name]').text();
				var EP_NAME_KOR	= 	$(v).children('[name=EP_NAME_KOR]').text();
				var USE_CAR 	= 	$(v).children('[name=USE_CAR]').text();
				var TITLE		= 	$(v).children('[name=TITLE]').text();
				var accurate_amt= 	$(v).children('[name=accurate_amt]').text();
				
				
				var html= '';
				
				html += '<tr id="' + '">';
				html += '<input type="hidden" name="BTEmpNo" value="' + BTEmpNo+ '">';
				html += '<input type="hidden" name="BTTripNo" value="' + BTTripNo+ '">';
				html += '<input type="hidden" name="BTTimeFR" value="' + BTTimeFR+ '">';
				html += '<input type="hidden" name="BTTimeEND" value="' + BTTimeEND+ '">';
				html += '<input type="hidden" name="BTLocation" value="' + BTLocation+ '">';
				html += '<td><input type="checkbox" name="" id="'+pk+'"/> <label for="'+pk+'"></label></td>';
				html += '<td name="TRIP_DAY_FR">'+TRIP_DAY_FR+'</td>';
				html += '<td name="dept_name">'+dept_name+'</td>';
				html += '<td name="EP_NAME_KOR">'+EP_NAME_KOR+'</td>';
				html += '<td name="USE_CAR">'+USE_CAR+'</td>';
				html += '<td name="TITLE">'+TITLE+'</td>';
				html += '<td name="accurate_amt">'+accurate_amt+'</td>';
				html += '</tr>';
				
				$("#gridList2 tbody").append(html);
			
			});



		})
		function setParentRow() {
			
			var arr = $('#gridList2 tbody tr input:checked').closest('tr');

			if(arr.length == 0 ){
				alert('출장 정보를 선택해주세요');
				return;
			}
			
			 $('#btn_ban0').unbind('click'); 
			
			
			
			//혹여 부모자식간 data 전달이슈가 발생하면 array에 데이터를 가공해서 JSON.stringify 시켜서 넘겨주자

			window.opener.tripTradeProcess2(arr);

			self.close();
		}
	</script>
</body>

