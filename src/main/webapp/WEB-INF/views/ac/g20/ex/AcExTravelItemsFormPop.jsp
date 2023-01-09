<%@ page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page import="main.web.BizboxAMessage"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<head>
<title>title</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20Items.js"></c:url>'></script>

<script type="text/javascript">

var callBack = "${param.callback}" || "";
var abdocu_no = "${param.abdocu_no}" || "";
var erp_co_cd = "${param.erp_co_cd}" || "";
var divId = "${param.divId}" || "";

$(function(){
	
	//기본버튼
    $(".controll_btn button").kendoButton();

    $("#btnSaveTH").click(function () { fnSetAbdocuTH(); return false; });
     
 	$("#btnDelTH").bind({
		click : function(event){
			fnDelAbdocuTH(); 
		}
	});
 	
     //시작날짜
     var start = $("#txt_TS_DT").kendoDatePicker({
    	 format: "yyyy-MM-dd",
    	 change : startChange
     }).data("kendoDatePicker");
     
     //종료날짜
     var end = $("#txt_TE_DT").kendoDatePicker({
    	 format: "yyyy-MM-dd",
    	 change : endChange
    }).data("kendoDatePicker");

     function startChange() {
         var startDate = start.value(),
         endDate = end.value();

         if (startDate) {
             startDate = new Date(startDate);
             startDate.setDate(startDate.getDate());
             end.min(startDate);
         } else if (endDate) {
             start.max(new Date(endDate));
         } else {
             endDate = new Date();
             start.max(endDate);
             end.min(endDate);
         }
     }

     function endChange() {
         var endDate = end.value(),
         startDate = start.value();

         if (endDate) {
             endDate = new Date(endDate);
             endDate.setDate(endDate.getDate());
             start.max(endDate);
         } else if (startDate) {
             end.min(new Date(startDate));
         } else {
             endDate = new Date();
             start.max(endDate);
             end.min(endDate);
         }
     }
          
    	/*개산급, 정산급*/
	$("#txt_RCOST_AM, #txt_SCOST_AM").bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){

				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var count = input.val();
			input.val(count.toString().toMoney());
		}
	});      
 	var th_div = $("#travelTH-Table"); 
	init(th_div);
	fnSaveClick(th_div);
	fnStateInit();
});

function fnStateInit(){	

    $("#abdocu_th_no").val('${abdocu_th.abdocu_th_no}');   //시퀀스
    $("#txt_TS_DT").data("kendoDatePicker").value(ncCom_Date('${abdocu_th.ts_dt}', '-'));//출장 시작일
    $("#txt_TE_DT").data("kendoDatePicker").value(ncCom_Date('${abdocu_th.te_dt}', '-'));// 출장종료일
    $("#txt_TDAY_CNT").val('${abdocu_th.tday_cnt}');     //출장일수
    $("#txt_SITE_NM").val('${abdocu_th.site_nm}');      //출장지
    $("#txt_ONTRIP_NM").val('${abdocu_th.ontrip_nm}');             //출장용무
    $("#txt_REQ_NM").val('${abdocu_th.req_nm}');      //청구인
    $("#txt_RSV_NM").val('${abdocu_th.rsv_nm}');             //영수인        			
    $("#txt_RCOST_AM").val('${abdocu_th.rcost_am}'.toMoney());      //개산급
    $("#txt_SCOST_AM").val('${abdocu_th.scost_am}'.toMoney());      //정산급

    fnGetAbdocuTDList();
    fnGetAbdocuTD2List();
};


function fnResetAbdocuTH(){

	$("#abdocu_th_no").val("");  //abdocu_th_no
	$("#txt_TS_DT").val("");   // 출장시작일
	$("#txt_TE_DT").val("");   // 출장종료일
	$("#txt_TDAY_CNT").val("");     //출장일수
	$("#txt_SITE_NM").val("");      //출장지
	$("#txt_ONTRIP_NM").val("");             //출장용무
	$("#txt_REQ_NM").val("");      //청구인
	$("#txt_RSV_NM").val("");             //영수인        			
	$("#txt_RCOST_AM").val("");      //개산급
	$("#txt_SCOST_AM").val("");      //정산급
};

function btnCancel(){
	
	acLayerPopClose(divId);	
}

function btnOk(){
// 	var obj = abdocu_d.Validation();
	parent.eval(callBack)();
	acLayerPopClose(divId);	
}
</script>
</head>
<body>
<div class="pop_wrap_dir" style="width:828px;" id="ItemsFormPop" onload="fnStateInit();">
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000009888","여비명세서 등록")%>
<%--                         <c:if test='${biztrip_link == "DOC"}'> --%>
<!--                      문서별리스트 -->
<!--                      <a href="javascript:abdocu_d.getBizTripReqDocList();" class="blueLineBtn fR mR5 mT10" id="BiztripBtnDoc"><span>출장신청내역</span></a> -->
<%--                 </c:if> --%>
<!--                      출장자별리스트        -->
<%--                 <c:if test='${biztrip_link == "USER"}'> --%>
<!--                      <a href="javascript:abdocu_d.getBizTripReqUserList();" class="blueLineBtn fR mR5 mT10" id="BiztripBtnUser"><span>출장신청내역</span></a> -->
<%--                 </c:if>                    --%>
        </h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png'/>" alt="" onclick="btnOk();" /></a>
    </div>    
    
    <div class="pop_con expense">   
        <div class="top_box" id="travelTH-Table">
            <input type="hidden" id="abdocu_th_no" />
            <dl>
                <dt><%=BizboxAMessage.getMessage("TX000009887","출장일")%></dt>
                <dd style="width:300px;"><input id="txt_TS_DT" class="dpWid non-requirement" tabindex="101"/> ~ <input class="dpWid non-requirement" id="txt_TE_DT"  tabindex="102"/></dd> 
                <dt><%=BizboxAMessage.getMessage("TX000009886","출장일수")%></dt>
                <dd><input id="txt_TDAY_CNT" type="text" class="ar pr5 non-requirement" style="width:100px;"  tabindex="103" /></dd>
            </dl>
            <dl>                                    
                <dt><%=BizboxAMessage.getMessage("TX000004662","출장지")%></dt>
                <dd style="width:300px;"><input id="txt_SITE_NM" type="text" style="width:275px;" class="non-requirement" tabindex="104"/></dd>
                <dt><%=BizboxAMessage.getMessage("TX000009885","출장용무")%></dt>
                <dd><input id="txt_ONTRIP_NM" type="text" style="width:275px;" class="non-requirement"  tabindex="105" /></dd>    
            </dl>
            <dl>
                <dt><%=BizboxAMessage.getMessage("TX000009884","청구인")%></dt>
                <dd style="width:300px;"><input id="txt_REQ_NM" type="text" style="width:105px;" class="non-requirement" tabindex="106"/></dd>
                <dt><%=BizboxAMessage.getMessage("TX000009883","영수인")%></dt>
                <dd><input id="txt_RSV_NM" type="text" style="width:105px;" class="non-requirement"  tabindex="107" part="state" /></dd>
            </dl>    
            <dl id="travelTH-Table_Tr">
                <dt><%=BizboxAMessage.getMessage("TX000009882","개산급")%></dt>
                <dd style="width:300px;"><input id="txt_RCOST_AM" type="text" class="ar pr5 non-requirement" style="width:100px;" tabindex="108"/></dd>
                <dt><%=BizboxAMessage.getMessage("TX000009881","정산급")%></dt>
                <dd><input id="txt_SCOST_AM" type="text" class="ar pr5 non-requirement" style="width:100px;" tabindex="109" part="state_th"/></dd>
                
                <div class="btn_cen" style="margin:5px 10px 0 0; text-align:right;">
                    <input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" id="btnSaveTH">
                    <input type="button" class="m0 gray_btn" value="삭제" id="btnDelTH" >
                </div>
            </dl>                                        
        </div>

        <div class="com_ta2 mt15">
        
            <table border="0">

            	<colgroup>
                    <col width=""/> 
                    <col width="150"/>
                    <col width="70"/>
                    <col width="125"/>
                    <col width="125"/>
                    <col width="125"/>       
                </colgroup>
                <tr>                   
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000010447","종별")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004734","거리")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000003756","등급")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000468","단가")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009880","총액")%></th>
                    <th scope="col"></th>
                </tr>
        </table>
        </div>
        
        <div class="com_ta2 ova_sc hover_no" style="height:148px;" id="travelTD">        
        	<table id="travelTD-Table">
            	<colgroup>
                    <col width=""/> 
                    <col width="150"/>
                    <col width="70"/>
                    <col width="125"/>
                    <col width="125"/>
                    <col width="125"/>                       
                </colgroup>
                <tbody>

                </tbody>    
            </table>
        </div>
		<table id="travelTD-Table-sample" style="display:none" >
                <tr>                    
                    <td><input type="text" style="width:92%;" class="ac requirement" id="txt_JONG_NM" tabindex="10001" code="empty"/></td>
                    <td><input type="text" style="width:92%;" class="ar non-requirement" id="txt_JKM_CNT" tabindex="10002"/></td>
                    <td><input type="text" style="width:92%;" class="ac non-requirement" id="txt_JGRADE" tabindex="10003"/></td>
                    <td><input type="text" style="width:92%;" class="ar non-requirement inPutRight" id="txt_JUNIT_AM" tabindex="10004"/></td>
                    <td><input type="text" style="width:92%;" class="ar requirement enter inPutRight" id="txt_JTOT_AM" tabindex="10005" part="state_td" code="empty"/></td>   
                    <td>
                            <div class="controll_btn ac" style="padding:0px;">
                                <button type="button" class="btnSaveRow" ><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
                                <button type="button" class="btnDeleteRow"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
                            </div>
                     </td>                
                </tr>    
		</table>
		<table id="travelTD-Table-sample-empty" style="display:none">
            <tr class="blank">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
		</table>

        <div class="com_ta2 hover_no mt15 ova_sc_all" style="height:186px;">
            <table style="width:2070px;">
            	<colgroup>
                    <col width="" />
                    <col width="130" />
                    <col width="100"/>
                    <col width="125"/>
                    <col width="70"/>
                    <col width="70"/>
                    <col width="130"/>
                    <col width="130"/>
                    <col width="130"/>
                    <col width="130"/>
                    <col width="100"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="100"/>
                    <col width="125"/>
                </colgroup>
				<tr>                    
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000011204","출장자")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009879","출장일자")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009878","야수")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000003214","일수")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004732","출발지")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009877","경유지")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004733","도착지")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000010447","종별")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004734","거리")%>(km)</th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009876","요금")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009875","일비")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000009874","식비")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004675","숙박비")%></th>
					<th scope="col"><%=BizboxAMessage.getMessage("TX000005400","기타")%></th>
					<th scope="col"><%=BizboxAMessage.getMessage("TX000009880","총액")%></th>
					<th scope="col"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
					<th scope="col"></th>
                </tr>
            </table>
        <div class="com_ta2 ova_sc hover_no" style="width:2070px;height:186px; border-top:none;" id="travelTD2">
            <table id="travelTD2-Table">
                <colgroup>
                    <col width="" />
                    <col width="130" />
                    <col width="100"/>
                    <col width="125"/>
                    <col width="70"/>
                    <col width="70"/>
                    <col width="130"/>
                    <col width="130"/>
                    <col width="130"/>
                    <col width="130"/>
                    <col width="100"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="90"/>
                    <col width="100"/>
                    <col width="125"/>
                </colgroup>
                <tbody>
  
                </tbody>    
            </table>
        </div>
                    </div>
<table id="travelTD2-Table-sample" style="display:none"  >
                <tr>                    
<%--                     <td><a href="javascript:;" id="btndeleteRow"><img src="<c:url value='/images/erp/ico_del.gif'/>" width="14" height="16" alt="" title="삭제" /></a></td>                        --%>
                    <td><input type="text" style="width:92%;" id="th2_DEPT_NM" tabindex="20001" class="ac non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_HCLS_NM" tabindex="20002" class="ac non-requirement"  /></td>
                    <td><input type="text" style="width:92%;" id="th2_EMP_NM" tabindex="20003" class="ac non-requirement" /></td>
                    <td>
                        <input style="width:92%;" id="th2_TRIP_DT" tabindex="20004" class="ac requirement" code="empty"/>
                        <input type="hidden" style="width:92%;" id="temp_th2_TRIP_DT" class="ac requirement"/>
                    </td>
                    <td><input type="text" style="width:92%;" id="th2_NT_CNT" tabindex="20005"  class="ar non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_DAY_CNT" tabindex="20006"  class="ar non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_START_NM" tabindex="20007" class="ac non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_CROSS_NM" tabindex="20008" class="ac non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_ARR_NM" tabindex="20009" class="ac non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_JONG_NM" tabindex="20010" class="ac non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_KM_AM" tabindex="20011" class="ar non-requirement" /></td>
                    <td><input type="text" style="width:92%;" id="th2_FAIR_AM" tabindex="20012" class="ar requirement tR inPutRight" code="empty"/></td>
                    <td><input type="text" style="width:92%;" id="th2_DAY_AM" tabindex="20013" class="ar non-requirement inPutRight" /></td>
                    <td><input type="text" style="width:92%;" id="th2_FOOD_AM" tabindex="20014" class="ar non-requirement inPutRight" /></td>
                    <td><input type="text" style="width:92%;" id="th2_ROOM_AM" tabindex="20015" class="ar non-requirement inPutRight" /></td>
                    <td><input type="text" style="width:92%;" id="th2_OTHER_AM" tabindex="20016" class="ar non-requirement inPutRight" /></td>
                    <td><input type="text" style="width:92%;" id="th2_TOTAL_AM" tabindex="" class="ar non-requirement inPutRight"/></td>
                    <td><input type="text" style="width:92%;" id="th2_TRMK_DC" tabindex="20018" class="ac non-requirement enter" part="state_td2"/></td>
                    <td>
                            <div class="controll_btn ac" style="padding:0px;">
                                <button type="button" class="btnSaveRow" ><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
                                <button type="button" class="btnDeleteRow"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
                            </div>
                     </td>                                        
                </tr>    
</table>
<table id="travelTD2-Table-sample-empty" style="display:none">
            <tr class="blank">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
<!--                 <td></td> -->
            </tr>
</table>

    </div><!-- //pop_con -->
    
    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" onclick="btnOk();" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
<!--             <input type="button" onclick="btnCancel();" class="gray_btn" value="취소" /> -->
        </div>
    </div><!-- //pop_foot -->
        
    </div>

    </div><!-- //pop_wrap -->

<!-- <div id="dialog-form-BizTripList" class="parent" style="display:none"> -->
<!-- <div id="erpPopWrap"> -->
<!--     <div class="erpPopHead"> -->
<!--         <h1>출장신청내역 </h1>   -->
        
<!--         <a href="javascript:;" class="popClose bizTripCloseBtn">닫기</a> -->
<!--     </div>  -->
<!--     <div class="erpPopContents"> -->
<!--         <div class="erpPopCon scroll" style="height:340px;" id="dialog-form-BizTripList-bind"> -->
<!--         </div> -->
<!--         <p class="tC mT8" id="btnP"></p>                      -->
<!--     </div> -->
<!-- </div> -->
<!-- </div> -->

<div id="dialog-form-background_dir" class="modal" style="display:none;"></div>
</body>
</html>
