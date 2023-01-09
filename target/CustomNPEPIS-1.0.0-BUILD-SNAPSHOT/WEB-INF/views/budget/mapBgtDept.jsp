<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<%
 /** 
  * @Class Name : budgetList.jsp
  * @Description : 예실대비
  * @Modification Information
  * @
  * @  수정일                 수정자             수정내용
  * @ ----------      --------    ---------------------------
  * @ 2018.05.24      이철중             최초 생성
  *
  * @author 이철중
  * @since 2018.05.24
  * @version 1.0
  * @see
  *
  */
%>

<html>
<head>
</head>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>

<style type="text/css">
.k-header .k-link{
   text-align: center;
}
</style>

<script type="text/javascript">
    $(document).ready(function() {
    	var pjtWin = $("#pjtPopUp");
    	var btmWin = $("#btmPopUp");
    	
    	$("#deptSearch").on("click", function() {
    		callOrgPop();
    	});

		$("#deptSeq").val("${deptSeq}");
		$("#deptName").val("${deptNm}");
    	
		pjtWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onPjtClose
		}).data("kendoWindow").center();
		
		$("#pjtCncl").click(function() {
	    	pjtWin.data("kendoWindow").close();
		});
		
		$("#pjtOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			
			$('input[name=chkPjtCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + ",";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#pjtCd").val(checkedIds);
			$("#pjtNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	pjtWin.data("kendoWindow").close();
		});
    	
    	$("#btmSearch").on("click", function() {
			btmWin.data("kendoWindow").open();
			$("#btmSearch").fadeOut();
			
			$("#btmGrid").kendoGrid({
				dataSource: btmDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkBtmCd' type='checkbox' id='btmCd#=BOTTOM_CD#' class='k-checkbox rightCheck' value='#=BOTTOM_CD#:#=BOTTOM_NM#' /><label for='btmCd#=BOTTOM_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "BOTTOM_CD",
		            title: "하위사업코드",
		            width: 150
		        },
				{
		            field: "BOTTOM_NM",
		            title: "하위사업명"
		        }]
		    }).data("kendoGrid");
    	});
		
		btmWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onBtmClose
		}).data("kendoWindow").center();
		
		$("#btmCncl").click(function() {
	    	btmWin.data("kendoWindow").close();
		});
		
		$("#btmOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			
			$('input[name=chkBtmCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + ",";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#btmCd").val(checkedIds);
			$("#btmNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	btmWin.data("kendoWindow").close();
		});
		
		$("#deptSearchCncl").click(function() {
	    	$("#deptSeq").val("");
	    	$("#deptNm").val("");
		});
		
		$("#pjtSearchCncl").click(function() {
	    	$("#pjtCd").val("");
	    	$("#pjtNm").val("");
		});
		
		$("#btmSearchCncl").click(function() {
	    	$("#btmCd").val("");
	    	$("#btmNm").val("");
		});
    });
	
	function numberFormatStr(str) {
		var reg = /(\-?\d+)(\d{3})($|\.\d+)/;
		var param = str.toString();
		
		if (reg.test(param)) {
			return param.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
	    }
		else {
			return param;
		}
	}
    
	var pjtDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getPjtList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.pjtNm = $('#keyVal').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.pjtList;
			}
		}
	});
	
    function onPjtClose() {
    	$("#pjtSearch").fadeIn();
	}
    
	var btmDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getBtmList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.pjtCd = $('#pjtCd').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.btmList;
			}
		}
	});
	
    function onBtmClose() {
    	$("#btmSearch").fadeIn();
	}
    
	// 사용자 선택 팝업
	function callOrgPop() {
    	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "${pageContext.request.contextPath}/budget/pop/cmmOrgPop";
		frmPop.submit();
		pop.focus();
	}
	
	function callbackSel(data) {
		var deptSeq  = [];
		var deptName = [];
		
		for (var i = 0; i < data.returnObj.length; i++) {
			deptSeq.push(data.returnObj[i].deptSeq);
			deptName.push(data.returnObj[i].deptName);
		}
		
		$("#deptSeq").val(deptSeq.join(","));
		$("#deptName").val(deptName.join(","));
	}
	
	function gridSave() {
		if (confirm("저장하시겠습니까?")) {
			var deptSeq = "";
			
			$('select[name=deptCd]').each(function () {
				 deptSeq += $(this).val() + ",";
			});
			
			var data = {deptSeq : deptSeq}
	
			$.ajax({
				url: "${pageContext.request.contextPath}/budget/saveDept",
				dataType : "json",
				data : data,
				type : "POST",
				success: function(result) {
					alert("저장되었습니다.");	
				}
			});
		}
	}
</script>

<body>

	<!-- 조직도 호출하기 위한 기본값 -->
	<form id="frmPop" name="frmPop">
		<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="/gw/systemx/orgChart.do">
		<input type="hidden" name="selectMode" width="500" value="d" />
		<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
		<input type="hidden" name="selectItem" width="500" value="m" />
		<input type="hidden" name="compSeq" id="compSeq"  value="" />
		<input type="hidden" name="compFilter" id="compFilter" value="" />
		<input type="hidden" name="initMode" id="initMode" value="true" />
		<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="true" />
		<input type="hidden" name="selectedItems" id="selectedItems" value="" />
		<input type="hidden" name="callbackUrl" id="callbackUrl" value="${pageContext.request.contextPath}/budget/pop/cmmOrgPopCallback">
		<input type="hidden" name="callback" id="callback" value="callbackSel"/>
	</form>

	<div class="iframe_wrap" style="min-width: 1070px;">
		<!-- 컨텐츠타이틀영역 -->
	    <div class="sub_title_wrap">       
	        <div class="title_div">
	            <h4>하위사업 부서매핑</h4>
	        </div>
	    </div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">하위사업 부서매핑</p>
<!--
			<div class="top_box">
				<dl>				    
					<dt class="ar" style="width:103px" >부서</dt>
					<dd>
						<input type="text" id="deptName" style="width: 300px" readonly />
						<input type="button" id="deptSearch" value="선택" />
						<input type="button" id="deptSearchCncl" value="선택취소" />
						<input type="hidden" name="deptSeq" id="deptSeq">
					</dd>
					<dl>
						<dt class="ar" style="width:103px" >프로젝트</dt>
						<dd>
							<input type="text" id="pjtNm" style="width: 500px" readonly />
							<input type="button" id="pjtSearch" value="선택" />
							<input type="button" id="pjtSearchCncl" value="선택취소" />
							<input type="hidden" id="pjtCd" name="divCd" />
						</dd>
					</dl>
					<dl>
						<dt class="ar" style="width:103px" >하위사업</dt>
						<dd>
							<input type="text" id="btmNm" style="width: 500px" readonly />
							<input type="button" id="btmSearch" value="선택" />
							<input type="button" id="btmSearchCncl" value="선택취소" />
							<input type="hidden" id="btmCd" name="divCd" />
						</dd>
					</dl>
				</dl>
			</div>
-->
		    <!--신청 버튼 -->
			<div class="btn_div">	
				<div class="right_div">
					<div class="controll_btn p0">
						<button type="button" onclick="gridSave();">저장</button>
					</div>
				</div>
			</div>
			
			<div class="com_ta2">		    
		       <table id="grid">
		           <colgroup>
		           	   <col style="width:50px" />
		               <col style="width:100px" />
		               <col style="width:50px" />
		               <col style="width:100px" />
		               <col style="width:100px" />
		           </colgroup>
		           <thead>
		               <tr>
		                   <th>프로젝트 코드</th>
		                   <th>프로젝트 명</th>
		                   <th>하위사업 코드</th>
		                   <th>하위사업 명</th>		                   
		                   <th>부서명</th>
		               </tr>
		           </thead>
		           <tbody>
					<c:forEach var="mainList" items="${mainList}" varStatus="mainStatus">
		               <tr>
		                   <!-- 체크박스 -->
		               	   <td align="center">${mainList.pjtCd}</td>
		               	   <td align="center">${mainList.pjtNm}</td>
		               	   <td align="center">${mainList.btmCd}</td>
		               	   <td align="center">${mainList.btmNm}</td>
		               	   <td align="center">
								<select id="deptCd_${mainStatus.index}" name="deptCd" style="width:180px;">
							     <option value="">선택</option>
								 <c:forEach items="${allDept}" var="list">
								 	<option value="${mainList.pjtCd}_${mainList.btmCd}_${list.dept_seq}" 
								 	<c:if test="${mainList.deptSeq == list.dept_seq}">
							 			selected
									</c:if>
									>${list.dept_name}</option>
								 </c:forEach>
								</select>
		               	   </td>
		               </tr>
					</c:forEach>
		           </tbody>
		       </table>
		   </div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="pjtPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>프로젝트</h1>
		</div>
		<div id="pjtGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="pjtOk"   value="적용" />
				<input type="button" class="blue_btn" id="pjtCncl" value="취소" />
			</div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="btmPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>하위사업</h1>
		</div>
		<div id="btmGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="btmOk"   value="적용" />
				<input type="button" class="blue_btn" id="btmCncl" value="취소" />
			</div>
		</div>
	</div>
</body>
</html>