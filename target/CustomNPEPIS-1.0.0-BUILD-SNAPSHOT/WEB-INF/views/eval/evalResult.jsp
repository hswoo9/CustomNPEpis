<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
.sub_contents_wrap .com_ta th, td{text-align: center;}
.sub_contents_wrap .com_ta tfoot td {color: blue;}
.sub_contents_wrap .com_ta th {padding-right: 0;}
</style>


<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>평가결과 보기</h4>
		</div>
	</div>

	
	<div class="sub_contents_wrap" style="min-height:0px;">
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<dl>
					<dt style="">
						제안업체
					</dt>
					<dd style="line-height: 25px">
						<select id="company" style="width: 150px;" onchange="companySelect();">
							<c:forEach items="${company }" var="list">
								<option value="${list.eval_company_seq }">${list.display_title }</option>
							</c:forEach>
						</select>					
					</dd>
					<dt style="">
						사업명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" value="${commDetail.title}" style="width: 350px;" readonly="readonly"> 
					</dd>
					
					<dt style="">
						평가일자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" value="${commDetail.eval_s_date2}" readonly="readonly"> 
					</dd>

				</dl>
				
			</div>
			
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="left_div">
			<p class="tit_p fl mt20 mb0">업체 평가점수</p>
		</div>
		
		<div class="com_ta">
			<table style="width: 100%;">
				<thead>
					<tr>
						<th rowspan="2" style="width: 20%;">평가점수</th>				
						<th id="colTr" colspan="3">평가위원</th>	
						<th rowspan="2" style="width: 6%;">평균</th>			
					</tr>
					<tr id="addCol">
						<th>1</th>				
						<th>2</th>				
						<th>3</th>				
					</tr>
				</thead>
				
				<tbody id="addTbody">
				</tbody>

				<tfoot>
					<tr id="addTfoot">
					</tr>
				</tfoot>	
			</table>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<p class="tit_p fl mt10 mb10">총괄점수</p>
		
		<div class="com_ta">
		
			<table style="width: 100%;">
				<thead>
					<tr>
						<th rowspan="2" style="width: 20%;">평가점수</th>
						<th id="colTr2" colspan="3">제안업체</th>					
					</tr>
					<tr id="addCol2">
						<th>1</th>
						<th>2</th>
						<th>3</th>
					</tr>
				</thead>
				
				<tbody id="addTbody2">
				</tbody>
				
				<tfoot>
					<tr id="addTfoot2">
					</tr>
					<tr id="addTfoot3">
					</tr>
					<tr id="addTfoot4">
					</tr>
				</tfoot>
			
			</table>
					
		
		</div>
	</div>
	
	

</div>

<script>
var rates = '${commDetail.rates}';
$(function(){
	
	$('#company').kendoDropDownList();
	
	companySelect();
	
});

function companySelect(){
	
	var data = {
			COMMITTEE_SEQ : '${commDetail.committee_seq}',
			EVAL_COMPANY_SEQ : $('#company').val(),
	};
	
	$.ajax({
		url: "<c:url value='/eval/evalResultList' />",
		data : data,
		type : 'POST',
		success: function(result){

			$('#colTr').attr('colspan', result.list.length);
			$('#colTr2').attr('colspan', result.sumList.length);
			
			$('#addCol').empty();
			$('#addCol2').empty();

            $('#addTbody2').empty();
            $('#addTbody2Foot').empty();

            $('#addTbody').empty();
			$('#addTfoot').empty();
            $('#addTfoot2').empty();
            $('#addTfoot3').empty();
            $('#addTfoot4').empty();

			
			//$('#addTfoot2').append('<td>합계</td>');
			
			//th그리기
			var colWidth = 90 / result.colList.length;
			var col2Width = 80 / (result.colList.length + 2);

            var cnt = 0;
            var sumTotal = 0;
			$.each(result.colList, function(i, v){
				cnt++;
				var tos = "ITME_SCORE_"+v.item_seq;

				var defMaxNum = 0;
				var defMinNum = 100;

				var tem = "ITME_SCORE_"+v.item_seq;

				$.each(result.list, function(ii, vv){
					if(defMaxNum < vv[tem]){
						defMaxNum = vv[tem];
					}

					if(defMinNum > vv[tem]){
						defMinNum = vv[tem];
					}
				});

				// tbody start
				var tr = '<tr><th>'+v.item_name+'</th>'
				var flag = true;
				var replaceMinColor = "blue";
				var replaceMaxColor = "red";
				$.each(result.list, function(ii, vv){
					var color = vv["RANK_CODE_"+v.item_seq] == 'N' ? 'red' : 'black';

					if(vv.EVAL_SAVE == 'Y' && defMinNum == vv[tem]){
						tr += '<td style="color: '+replaceMinColor+';">'+qksdhffla(vv[tem])+'</td>';
						defMinNum = 0;
					}else if(vv.EVAL_SAVE == 'Y' && defMaxNum == vv[tem]){
						tr += '<td style="color: '+replaceMaxColor+';">'+qksdhffla(vv[tem])+'</td>';
						defMaxNum = 0;
					}else if(vv.EVAL_SAVE == 'Y'){
						tr += '<td style="color: '+color+';">'+qksdhffla(vv[tem])+'</td>';
					}else{
						tr += '<td style="background-color:skyblue;"></td>';
					}
				});
				tr += '<td style="font-weight: bold;">'+qksdhffla(result.total[tos]) +'</td>';
				tr += '</tr>';
				sumTotal += result.total[tos];

				if(result.colList.length == cnt){
					tr += ' <tr>' +
							'       <th>합 계</td>' +
							'       <td colspan="'+result.list.length + 1 +'">'+ qksdhffla(sumTotal) +'</td>' +
							'   </tr>';
				}

				$('#addTbody').append(tr);
				// tbody end
			});
			$.each(result.list, function(i, v){
				var contact = v.CONTACT == 'N' ? 'none' : 'line-through';
				var td = '<th>'+v.NAME+'</th>';
					
				$('#addCol').append(td);
				
			});
			
			$.each(result.sumList, function(i, v){
				var contact = v.CONTACT == 'N' ? 'none' : 'line-through';
				var td = '<th>'+v.DISPLAY_TITLE+'</th>';
				
				$('#addCol2').append(td);
			});
						
			$.each(result.colList, function(i, v){
				var trTemp = '<tr><th>'+v.item_name+'</th>';
				
				$.each(result.sumList, function(ii, vv){
					var itemSeq = "ITME_SCORE_"+v.item_seq;
					trTemp += '<td>'+qksdhffla(vv[itemSeq])+'</td>';
				});
				
				$('#addTbody2').append(trTemp);
			});	
			
			
			$('#addTfoot2').append('<th>합계</th>');
			$.each(result.sumList, function(i, v){
				$('#addTfoot2').append('<td>'+qksdhffla(v.TOTAL_SUM)+'</td>');
			});
			
			$('#addTfoot3').append('<th>환산점수</th>');
			$.each(result.sumList, function(i, v){
				var pro = rates / 100;
				var sspro = v.TOTAL_SUM * pro;
				
				$('#addTfoot3').append('<td>'+qksdhffla(sspro)+'</td>');
			});
			
			$('#addTfoot4').append('<th>적격판정</th>');
			$.each(result.sumList, function(i, v){
				var eval = v.TOTAL_SUM >= 85 ? '적격' : '부적격';
				
				$('#addTfoot4').append('<td>'+eval+'</td>');
			})
		}
	});
}

//소수점 5자리 반올림
function qksdhffla(v){
	var txt = 0;
	
	if(v % 1 == 0) { 
		txt = v;
	}else{
		txt = v.toFixed(4);
		for (var i = 0; i < 4; i++) {
			txt = txt.replace(/0$/g, '');
		}
	}
	
	return txt;
}

</script>