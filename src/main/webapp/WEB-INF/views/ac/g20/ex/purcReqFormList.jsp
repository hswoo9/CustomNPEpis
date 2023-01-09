<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>

<style type="text/css">
.sub_left {top:0px;}
.sub_con {}
.sub_left .k-tabstrip>.k-content {display:block;}
.top_box {margin:0px 0px 14px 0px;}
.sub_left .k-widget {margin-top:0px;}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		$("#treeview").kendoTreeView({
			/*전자결재*/
			dataSource:[
				{
					id: 1,
					name: "물품 구매계획",
					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqGoodsForm.do?form_id=58&form_tp=tpfPurcRq1&eaType=ea",
					expanded: "false",
					spriteCssClass: "file"
				},
				{
					id: 1,
					name: "언론진흥재단 구매요청서",
					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqServiceForm.do?form_id=51&form_tp=tpfPurcRq5&eaType=ea",
					expanded: "false",
					spriteCssClass: "file"
				},
				{
					id: 1,
					name: "지원(공모) 사업자협약요청",
					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqServiceForm.do?form_id=51&form_tp=tpfPurcRq6&eaType=ea",
					expanded: "false",
					spriteCssClass: "file"
				},
// 				{ 
// 					seq: "30",
// 					name: "물품(조달청-종합쇼핑몰) 구매계획",
// 					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqShopForm.do?form_id=51&form_tp=tpfPurcRq2&eaType=ea",
// 					expanded: "false",
// 					spriteCssClass: "file"
// 				},
				{ 
					seq: "31",
					name: "공사 구매계획",
					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqConstructForm.do?form_id=60&form_tp=tpfPurcRq3&eaType=ea",
					expanded: "false",
					spriteCssClass: "file"
				},
				{ 
					seq: "32",
					name: "용역 구매계획",
					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqServiceForm.do?form_id=61&form_tp=tpfPurcRq4&eaType=ea",
					expanded: "false",
					spriteCssClass: "file"
				},
				{ 
					seq: "44",
					name: "소액물품 구매계획",
					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqFormSmall.do?purcReqType=1&form_id=51&form_tp=tpfPurcRs1&eaType=ea",
					expanded: "false",
					spriteCssClass: "file"
				},
// 				{ 
// 					seq: "46",
// 					name: "소액공사 구매계획",
// 					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqFormSmall.do?purcReqType=3&form_id=51&form_tp=tpfPurcRs3&eaType=ea",
// 					expanded: "false",
// 					spriteCssClass: "file"
// 				},
// 				{ 
// 					seq: "47",
// 					name: "소액용역 구매계획",
// 					urlPath: _g_contextPath_ + "/Ac/G20/Ex/purcReqFormSmall.do?purcReqType=4&form_id=51&form_tp=tpfPurcRs4&eaType=ea",
// 					expanded: "false",
// 					spriteCssClass: "file"
// 				}
			],
			select:function(e){
				onSelect(e);
			},
			dataTextField: ["name"],
	        dataValueField: ["seq", "urlPath", "expanded", "spriteCssClass"]
		});
		
		$("#btnApproval").bind({
			click : function(){
				openWindow2(urlPath, "");
			}
		});
	});
	
	function onSelect(e){
		var item = e.sender.dataItem(e.node);
		urlPath = item.urlPath;
		$("#formNoSelect").hide();
		$("#formdetail").show();
		$("#formName").html(item.name);
	}
	
	var urlPath = "";
	
	function openWindow2(url,  windowName, width, height, strScroll, strResize ){
		
		var pop = "" ;
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		if(strResize == undefined || strResize == '') {
			strResize = 0 ;
		}
		pop = window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES");
		try {pop.focus(); } catch(e){}
		//return pop;
	}
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="height: 400px">
<input type="hidden" id="mng" value="${mng }" />
<input type="hidden" id="loginId" value="${loginVO.id }" />
	<div class="sub_contents_wrap">

		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">구매목록</p>
			</div>
		</div>
		
		<div class="twinbox npDocList">
			<table style="table-layout: fixed; height: 400px;">
				<colgroup>
					<col style="width:30%" />
					<col />
				</colgroup>
				<tr>
					<td class="twinbox_td p0">
						<div class="" id="tabstrip">
							<div id="treeview" class="tree_icon tree_auto"></div>
						</div>
					</td>
					<td class="twinbox_td">
						<div class="btn_div mt0">
							<div class="left_div">
								<h5>구매계획상세</</h5>
							</div>
						</div>
						<div class="text02" id="formNoSelect">
							<ul>
								<li>기안할 양식을 선택해주세요</li>
							</ul>
						</div>
						<div class="com_ta" id="formdetail" style="display: none;">
							<table>
								<colgroup>
									<col width="120"/>
									<col width=""/>
								</colgroup>
								<tr>
									<th>양식명</th>
									<td id="formName"></td>
								</tr>
								<tr>
									<th>양식종류</th>
									<td>품의서</td>
								</tr>
							</table>
							<div class="btn_cen mt20">
								<input type="button" id="btnApproval" value="기안하기"/>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
	<!-- //sub_contents_wrap -->
<!-- iframe wrap -->
