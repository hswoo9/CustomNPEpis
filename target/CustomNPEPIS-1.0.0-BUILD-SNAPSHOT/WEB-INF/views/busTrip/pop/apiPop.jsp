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

	<div class="pop_wrap_dir" style="width: 1300px;">
		<p class="tit_p mt5 mt20"></p>

		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 31px;">날짜</dt>
					<dd style="line-height: 25px">
						<input type="text" id="startDt">
					<dt style="width: 55px;">열차종류</dt>
					<dd style="line-height: 25px">
						<input type="text" id="vehicle">

					</dd>
					<dt style="width: 70px;">출발지 지역</dt>
					<dd style="line-height: 25px">
						<input type="text" id="cityFr" style="width: 100px;">
					</dd>
					<dt style="width: 55px;">출발역</dt>
					<dd style="line-height: 25px">
						<input type="text" id="nodeFr" style="width: 100px;">
					</dd>
					<dt style="width: 70px;">도착지 지역</dt>
					<dd style="line-height: 25px">
						<input type="text" id="cityTo" style="width: 100px;">
					</dd>
					<dt style="width: 55px;">도착역</dt>
					<dd style="line-height: 25px">
						<input type="text" id="nodeTo" style="width: 100px;">
					</dd>
					<div class="btn_div" style="margin-top: 15px;">
						<div class="right_div">
							<div class="controll_btn p0">

								<button type="button" onclick="getTrainApiInfo();">선택</button>
							</div>
						</div>
					</div>
				</dl>
			</div>


			<div class="com_ta2 mt15">
				<div class="com_ta4 mt15">
					<div id="gridList2">
						<table>
							<thead>
								<tr>
									</th>
									<th style="text-align: center; width: 10%;">날짜</th>
									<th style="text-align: center; width: 10%;">열차종류</th>
									<th style="text-align: center; width: 10%;">출발지</th>
									<th style="text-align: center; width: 10%;">도착지</th>
									<th style="text-align: center; width: 10%;">비용</th>
									<th style="text-align: center; width: 5%;">삭제</th>
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
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="btn_div">
				<div class="right_div">
					<div class="controll_btn p0">

						<button type="button" onclick="setParentRow('${sortId}');">반영</button>
					</div>
				</div>
			</div>
		</div>

	</div>





	<script>
	
	var bizDate ='${bizDate}';
		$(function() {

			var cityDataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getKorailCity' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							cityname : '선택',
							citycode : "999"
						})
						return response.list;
					},
				}
			});

			$("#cityFr").kendoDropDownList({
				dataTextField : "cityname",
				dataValueField : "citycode",
				dataSource : cityDataSource,
				index : 0,
				change : function(e) {
					$('#nodeFr').data("kendoDropDownList").dataSource.read();
					$('#nodeFr').data("kendoDropDownList").value('999');

				}
			});
			var nodeDataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getKorailNode' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						data.citycode = $('#cityFr').data("kendoDropDownList")
								.value();
						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							nodename : '선택',
							nodeid : "999"
						})

						return response.list;
					},
				}
			});

			$("#nodeFr").kendoDropDownList({
				autoWidth : true,
				dataTextField : "nodename",
				dataValueField : "nodeid",
				dataSource : nodeDataSource,
				index : 0,
				change : function(e) {

				}
			});
			var city2DataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getKorailCity' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							cityname : '선택',
							citycode : "999"
						})
						return response.list;
					},
				}
			});

			$("#cityTo").kendoDropDownList({
				dataTextField : "cityname",
				dataValueField : "citycode",
				dataSource : city2DataSource,
				index : 0,
				change : function(e) {
					$('#nodeTo').data("kendoDropDownList").dataSource.read();
					$('#nodeTo').data("kendoDropDownList").value('999');

				}
			});
			var node2DataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getKorailNode' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						data.citycode = $('#cityTo').data("kendoDropDownList")
								.value();
						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							nodename : '선택',
							nodeid : "999"
						})

						return response.list;
					},
				}
			});

			$("#nodeTo").kendoDropDownList({
				autoWidth : true,
				dataTextField : "nodename",
				dataValueField : "nodeid",
				dataSource : node2DataSource,
				index : 0,
				change : function(e) {

				}
			});
			var vehicleDataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getKorailVehicle' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							vehiclekndnm : '선택',
							vehiclekndid : "999"
						})

						return response.list;
					},
				}
			});

			$("#vehicle").kendoDropDownList({
				autoWidth : true,
				dataTextField : "vehiclekndnm",
				dataValueField : "vehiclekndid",
				dataSource : vehicleDataSource,
				index : 0,
				change : function(e) {

				}
			});

			var startDate = $('#startDt').kendoDatePicker({
				culture : "ko-KR",
				format : "yyyy-MM-dd",
				value : bizDate
			}).attr("readonly", true).data("kendoDatePicker");

			$(".dataInputNumber").bind(
					{
						keyup : function(event) {
							$(this).val(
									numberWithCommas($(this).val().replace(
											/[^0-9]/g, "")));
						},
						change : function(event) {
							$(this).val(
									numberWithCommas($(this).val().replace(
											/[^0-9]/g, "")));
						}
					});

			$(".inputNumber").bind({
				keyup : function(event) {
					$(this).val($(this).val().replace(/[^0-9]/g, ""));
				},
				change : function(event) {
					$(this).val($(this).val().replace(/[^0-9]/g, ""));
				}
			});

		});

		function numberWithCommas(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

		}

		function getTrainApiInfo() {

			if ($('#vehicle').val() == '999') {
				alert("열차종류를 선택해주세요");
				return;
			}
			if ($('#nodeFr').val() == '999') {
				alert("출발지를 선택해주세요");
				return;
			}
			if ($('#nodeTo').val() == '999') {
				alert("도착지를 선택해주세요");
				return;
			}

			var trainData = {

				depPlandTime : $('#startDt').val().replace(/-/gi, ''),
				trainGradeCode : $('#vehicle').val(),
				depPlaceId : $('#nodeFr').val(),
				arrPlaceId : $('#nodeTo').val(),

			};

			$.ajax({
				url : "<c:url value='/busTrip/trainApi' />",
				data : trainData,
				type : 'get',
				async : false,
				success : function(data) {
					console.log(data);

					var costArr = [];

					$.each(data.result, function(idx, item) {
						console.log(item.adultcharge);
						costArr.push(item.adultcharge);

					})

					trainData.topCost = Math.max.apply(null, costArr);

					trainData.trainGradeCode = $('#vehicle').data(
							'kendoDropDownList').text();
					trainData.depPlaceId = $('#nodeFr').data(
							'kendoDropDownList').text();
					trainData.arrPlaceId = $('#nodeTo').data(
							'kendoDropDownList').text();
				}
			});
			

			if(trainData.topCost ==0){
				alert("조회된 열차 정보가 없습니다.");
				dataReset();
				return;
			}

			rowAddd(trainData);
			dataReset();
			/*
			if (trainData.topCost == 0) {
				if (confirm('조회된 열차정보가 없습니다. 금액을 직접 입력하시겠습니까?')) {
					
				} else {
				rowAddd(trainData);
					dataReset();
				}
			}
			*/
		}

		function rowAddd(item) {
			
			if ($(".emptyClass").size() == '1') {
				$("#gridList2 tbody").empty();
			}

			var html = '';

			html += '<tr id="' + item.depPlandTime+item.depPlaceId+ '">';
			html += '<td name="depPlandTime">' + item.depPlandTime + '</td>';
			html += '<td name="trainGradeCode">' + item.trainGradeCode	+ '</td>';
			html += '<td name="depPlaceId">' + item.depPlaceId + '</td>';
			html += '<td name="arrPlaceId">' + item.arrPlaceId + '</td>';
			html += '<td name="topCost">' + item.topCost + '</td>';
			/* 박혜정
			html += '<td> <input id="topCostinput" name="topCost" type="text"> </td>';
			*/
			html += '<td name="cancelbtn">';
			html += '<span onclick="deleteTrainRow(\'' + item.depPlandTime	+ item.depPlaceId + '\')">';
			html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
			html += '<span></td>';
			html += '</tr>';

			$("#gridList2 tbody").append(html);

		}

		function deleteTrainRow(pk) {
			if ($("#gridList2 tbody tr").size() == '1'
					&& !$(".emptyClass").hasClass("emptyClass")) {
				var noRow = '';

				noRow += '<tr class="emptyClass"> ';
				noRow += '<td></td>               ';
				noRow += '<td></td>               ';
				noRow += '<td></td>               ';
				noRow += '<td></td>               ';
				noRow += '<td></td>               ';
				noRow += '<td></td>               ';
				noRow += '</tr>                   ';

				$("#gridList2 tbody").append(noRow);

			}
			$("#" + pk).remove();
		}

		function dataReset() {
			$('#vehicle').data('kendoDropDownList').value('999');
			$('#cityFr').data('kendoDropDownList').value('999');
			$('#cityTo').data('kendoDropDownList').value('999');
			$('#nodeFr').data('kendoDropDownList').value('999');
			$('#nodeTo').data('kendoDropDownList').value('999');

			$('#nodeFr').data("kendoDropDownList").dataSource.read();
			$('#nodeTo').data("kendoDropDownList").dataSource.read();

		}

		function setParentRow(id) {
			var costArray = $('#gridList2 tbody tr td[name=topCost]');
			var tc = 0;
			$.each(costArray, function(idx, item) {
				tc += Number($(item).text());
			})

			console.log(tc);

			window.opener.setRoww(tc, id);

			self.close();
			
			//var costArray = $('#gridList2 tbody tr input[name=topCost]');
			/* 박혜정
			for(var i=0; i < costArray.length; i++){
				if(Number(uncomma($(costArray).val())) == ''){
					alert("금액을 입력해 주세요")
					break;
				}else{			
					tc += Number(uncomma($(costArray).val()));

					console.log(tc);
					window.opener.setRoww(tc, id);

					self.close();
				}
			}
			*/
			
		}
		
		//금액 입력시 자동 콤마 찍기 
	    $("#gridList2").on('keyup', '#topCostinput',function(){
	        inputNumberFormat(this);
	    });
		
	    //콤마 찍은 문자열 전달
	    function inputNumberFormat(obj) {
	        obj.value = comma(uncomma(obj.value));
	    }
	    //콤마풀기
	    function uncomma(str) {
	        str = String(str);
	        return str.replace(/[^\d]+/g, '');
	    }
	    //콤마찍기
	    function comma(str) {
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	    }
	    
	</script>
</body>

