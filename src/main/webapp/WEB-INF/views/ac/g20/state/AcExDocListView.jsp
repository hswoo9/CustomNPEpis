<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="main.web.BizboxAMessage"%>

<%
 /**
  * @Class Name : AcExDocView.jsp
  * @Description : 품의서/결의서 문서 리스트
  * @Modification Information
  * @
  * @  수정일                 수정자            수정내용
  * @ ----------   --------    ---------------------------
  * @ 2016.10.16    이혜영             최초 생성
  */

%>

<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20State.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20Code.js"></c:url>'></script>

<style type="text/css">

.delLine { text-decoration:line-through;color:red;}

</style>

<script type="text/javascript">
var docList = {};
var langCode = "KR";

$(function(){
	
	$("#DIV_CD").data("kendoComboBox");
	acG20State.init();
	acG20State.fnStateInit();	
	
    /*조회버튼*/
    $(".btnSearch").click(function(){
    	docList.searchList();
    });
    
    $("#docStatus").kendoComboBox({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: [
            { text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value: "" },
            { text: "<%=BizboxAMessage.getMessage("TX000009184","결재중")%>", value: "002" },
            { text: "<%=BizboxAMessage.getMessage("TX000009183","결재완료")%>", value: "008" },
            { text: "<%=BizboxAMessage.getMessage("TX000009182","협조중")%>", value: "003" },
            { text: "<%=BizboxAMessage.getMessage("TX000009181","보류중")%>", value: "004" },
            { text: "<%=BizboxAMessage.getMessage("TX000000424","삭제")%>", value: "d" }
        ]   ,
        index: 0
    });
    
    docList.searchList();
    
    // 서브페이지 상세검색 slideToggle
    $("#SearchDetail").hide();
    $(".btn_Detail").click(function(){
      $("#SearchDetail").slideToggle("slow");
      
         if($('#all_menu_btn').attr('src')=='<c:url value="/Images/ico/ico_btn_arr_down01.png" />'){
            $('#all_menu_btn').attr('src','<c:url value="/Images/ico/ico_btn_arr_up01.png" />');
        }else{
            $('#all_menu_btn').attr('src','<c:url value="/Images/ico/ico_btn_arr_down01.png" />');
        }
   }); 
    
});


docList.searchList = function(){
//     if("${link_yn}" =="N"){
//         alert("ERP 연동되어 있지 않습니다. 관리자에게 문의 바랍니다. ");
//         return;
//     }

    var dataSource = new kendo.data.DataSource({
        serverPaging: true,
        pageSize: 10,
         transport: { 
             read:  {
            	 url:'<c:url value="/Ac/G20/State/getAcExDocList.do"/>',
                 dataType: "json",
                 type: 'post'
             },
             parameterMap: function(options, operation) {
            	 var formData = acG20State.getFormData();
				 // 페이징 정보 채우기 ( PIMS : M20170228048 ) >> 가공데이터 반환으로 페이징 정보 미전달 발생
            	 formData.page = options.page;
            	 formData.pageSize = options.pageSize;
            	 formData.skip = options.skip;
            	 formData.take = options.take;
            	 return formData ;
             }
         }, 
         schema:{
            data: function(response) {
              return response.list;
            },
            total: function(response) {
              return response.totalCount;
            }
          }
     });    
    
    //grid table
    $("#grid").kendoGrid({
    	dataSource: dataSource,
        sortable: false ,
        selectable: true,
        navigatable: true,
        pageable: {
          refresh: true,
          pageSizes: true
        },
        scrollable: true,
        columnMenu: false,
//         autoBind: true,     
//      navigatable: true,
        scrollable: true,
//         /*height:550,*/
        selectable: "single",
//         groupable: false,
//         editable: false,
//         dataBound: gridDataBound,
        columns: [
                 {  field:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", width:50
                	 ,headerAttributes: {style: "text-align:center;vertical-align:middle;"}
                	 ,template: '<input type="checkbox" name="chkActSel" id="#: C_DIKEYCODE #" class="k-checkbox"/><label class="k-checkbox-label chkSel2" for="#: C_DIKEYCODE #"></label>'
                	 ,attributes: {style: "text-align:center;vertical-align:middle;"},sortable: false
                 }
                ,{   field:"DOCU_MODE_NM",title: "<%=BizboxAMessage.getMessage("TX000000492","문서분류")%>",width:100,headerAttributes: {style: "text-align: center;"}
                     ,attributes: {style: "text-align: center;"}
                }
                ,{   field:"ERP_GISU_DT",title:"<%=BizboxAMessage.getMessage("TX000000506","결의일자")%>",width:100,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}}
                ,{   field:"ERP_GISU_SQ",title:"<%=BizboxAMessage.getMessage("TX000005100","결의번호")%>",width:70,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"}}
                ,{   field:"DOCU_FG_NM",title:"<%=BizboxAMessage.getMessage("TX000003616","결의구분")%>",width:120,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"} }
                ,{   field:"MGT_NM",title:"<%=BizboxAMessage.getMessage("TX000000519","프로젝트")%>",width:150,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"} }
                ,{   field:"APPLY_AM",title:"<%=BizboxAMessage.getMessage("TX000005056","집행액")%>",width:73,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: right;"} }
                ,{   field:"C_RIDOCFULLNUM",title:"<%=BizboxAMessage.getMessage("TX000000663","문서번호")%>",width:100,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"} }
                ,{   field:"USERNAME",title:"<%=BizboxAMessage.getMessage("TX000000499","기안자")%>",width:100,100: {style: "text-align: center;"},attributes: {style: "text-align: center;"} }
                ,{   field:"DOC_STATUS",title:"<%=BizboxAMessage.getMessage("TX000000490","결재상태")%>",width:100,headerAttributes: {style: "text-align: center;"},attributes: {style: "text-align: center;"} }
                ,{   field:"DOCTITLE", title: "<%=BizboxAMessage.getMessage("TX000003457","문서제목")%>", headerAttributes: {style: "text-align: center;"},template: "<a href=javascript:docList.docView('#=C_DIKEYCODE#');>#: data.DOCTITLE# </a>"   }
            ],
            dataBound: function(e){ 
            	gridDataBound(e);
                //마우스 커서 포인터로 변경 및 클릭이벤트 설정
                $("#grid tr[data-uid]").css("cursor","pointer").click(function () {
//                 	$("#grid tr[data-uid]").removeClass("k-state-selected");
//                 	$(this).addClass("k-state-selected");

                	detailInit();        // 프로세스 row 선택  	
                
                });
                gridDataRow(e);
            }
        }).data("kendoGrid");
    
    $("#grid").data("kendoGrid").table.on("click", ".k-checkbox" , selectRow);
    
    

};

//kendo grid 데이터 없음 표시 
function gridDataBound(e) {
	var grid = e.sender;
    if (grid.dataSource.total() == 0) {
        var colCount = grid.columns.length;
        var message = NeosUtil.getMessage("TX000010608","데이터가 존재하지 않습니다");
        $(e.sender.wrapper).find('tbody')
        .append('<tr class="kendo-data-row"><td colspan="' + colCount+ '" class="no-data" style="text-align: center;">'+message+'</td></tr>');
    }
};	

function gridDataRow(e){
	var grid = e.sender;
    if (grid.dataSource.total() == 0) {
    	  return;            
    }
	var columns = e.sender.columns;
    // iterate the table rows and apply custom row and cell styling
    var rows = grid.tbody.children();
    for (var j = 0; j < rows.length; j++) {
        var row = $(rows[j]);
        var dataItem = e.sender.dataItem(row);

        if(dataItem.APPR_STATUS == 'd'){
        	row.addClass("text_redline");
        }
    }
}

function selectRow(grid) {
    
    CommonKendo.setChecked($("#grid").data("kendoGrid"), this);     
}


function detailInit() {
	
	var grid = $("#grid").data("kendoGrid");
	var selectedItem = grid.dataItem(grid.select());
	
	$("#AcExDocDetail").html("");
	ctlDetailTrReset();
	var DOCU_MODE = selectedItem.DOCU_MODE;
	tblParam = {};
    tblParam.dikeycode = selectedItem.C_DIKEYCODE;
    tblParam.abdocu_no = selectedItem.ABDOCU_NO;
    tblParam.DOCU_MODE = DOCU_MODE;
    
    var opt = {  
    		type:"post",
    		url: "<c:url value='/Ac/G20/State/getAcExDocDetail.do'/>" ,
    		datatype:"json",
    		data: tblParam,
    		success:function(data){  
    			
    			var resultData = data.selectList;
    			var html = "";
    			    			
    			for(var i=0;i<resultData.length;i++){
    				html += '<tr id="'+ resultData[i].ABDOCU_B_NO +'" abdocu_no="'+ resultData[i].ABDOCU_NO +'" ';
    				if(resultData[i].APPR_STATUS == "d"){
    					html += '	style="text-decoration:line-through;color:red" ';
    				}
    				html += ' >';
    				html += '<td align="center" style="word-break:break-all ">' + ncCom_EmptyToString(resultData[i].ABGT_CD) + '</td>';
    				html += '<td align="center" style="word-break:break-all ">' + ncCom_EmptyToString(resultData[i].ABGT_NM) + '</td>';
    				html += '<td align="center" style="word-break:break-all ">' + ncCom_EmptyToString(resultData[i].ERP_BGT_NM1) + '</td>';
    				html += '<td align="center" style="word-break:break-all ">' + ncCom_EmptyToString(resultData[i].ERP_BGT_NM2) + '</td>';
    				html += '<td align="center" style="word-break:break-all ">' + ncCom_EmptyToString(resultData[i].ERP_BGT_NM3) + '</td>';
    				html += '<td align="center" style="word-break:break-all ">' + ncCom_EmptyToString(resultData[i].ERP_BGT_NM4) + '</td>';
    				html += '<td align="center">' + resultData[i].OPEN_AM + '</td>';
    				html += '<td align="center">' + resultData[i].APPLY_AM + '</td>';
    				html += '<td align="center">' + resultData[i].LEFT_AM + '</td>';
    				if(resultData[i].BUTTON == "rollBack"){
    					html += "<td><input type='button' onclick='returnConferBudgetRollBack(this);' value='<%=BizboxAMessage.getMessage("TX000009903","환원취소")%>'/> </td>";	
    				}else{
    					html += "<td><input type='button' onclick='returnConferBudget(this);' value='<%=BizboxAMessage.getMessage("TX000009902","환원")%>'/> </td>";	
    				}      					

    				html += '<td align="center">' + resultData[i].APPLY_AM + '</td>';
    				html += '<td align="center">' + ncCom_EmptyToString(resultData[i].REFFER_DOC) + '</td>';
    				html += '</tr>';
    			}
	             
    			if(resultData.length == 0){
            		html += "<tr><td colspan='12'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
            	}
    			$("#AcExDocDetail").html(html);
    			
    			if(DOCU_MODE=="0"){
    				ctlDetailTrHide(11);
    				ctlDetailTrHide(12);
    			}else{
    				ctlDetailTrHide(7);
    				ctlDetailTrHide(8);
    				ctlDetailTrHide(9);
    				ctlDetailTrHide(10);
    			}
    		}
	    };
	    $.ajax(opt); 
};


//입력한 컬럼 숨김
function ctlDetailTrHide(n){
	var Num = n;
	$("#AcExDocDetail_table tr th:nth-child("+Num+")").hide();
	$("#AcExDocDetail_table tr td:nth-child("+Num+")").hide();
// 	$("#AcExDocDetail tr td:nth-child("+Num+")").hide();
}


//컬럼 리셋
function ctlDetailTrReset(){
	$("#AcExDocDetail_table tr th").show();
	$("#AcExDocDetail_table tr td").show();
// 	$("#AcExDocDetail tr td").show();
}

/**
 * 
 *  예산환원 
 *  
 */
function returnConferBudget(e){
	
	var eventEle = $(e);
	var abdocu_b_no = eventEle.parents("tr").attr("id");
	var isAllDocView = $("#isAllDocView").attr("checked") ? "1" : "0";  // 전체문서보기
	
    var tblParam = {};
    tblParam.isAllDocView = isAllDocView;
    tblParam.CO_CD        = $("#CO_CD").val();
    tblParam.ABDOCU_B_NO  = abdocu_b_no;
    
	if(confirm("<%=BizboxAMessage.getMessage("TX000011196","예산환원 하시겠습니까?")%>")){
		var opt = {
	            url : _g_contextPath_ + "/Ac/G20/Ex/returnConferBudget.do",
	            stateFn : modal,
	            async : false,
	            data : tblParam,
	            successFn : function(result){
	            	if(result){
	            		if(result.result =="OK"){
// 	            			fnGetReferConferList();	
	            			detailInit();
	            		}
	            		else if(result.result =="ING"){
	                		alert("<%=BizboxAMessage.getMessage("TX000009900","결재중인 참조품의결의서가 존재합니다. 결재완료 후 환원처리해야합니다")%>");
	                	}
	            		else{
	            			alert("<%=BizboxAMessage.getMessage("TX000009899","처리중 오류가 발생하였습니다")%>");
	            		}
	            	}else{
	            		alert("<%=BizboxAMessage.getMessage("TX000009899","처리중 오류가 발생하였습니다")%>");
	            	}
	            },
	            failFn: function (request,status,error) {
	    	    	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>\n<%=BizboxAMessage.getMessage("TX000009711","오류 메시지 : {0}")%>".replace("{0}",error)+"\n");	    	    
	        	}
	    };
		
	    acUtil.ajax.call(opt);
	}
    
};

/**
 * 
 *  예산환원 취소 
 *  
 */
function returnConferBudgetRollBack(e){
	var eventEle = $(e);
	var abdocu_b_no = eventEle.parents("tr").attr("id");

    var tblParam = {};
    tblParam.ABDOCU_B_NO  = abdocu_b_no;
    
	if(confirm("<%=BizboxAMessage.getMessage("TX000011195","예산환원취소 하시겠습니까?")%>")){
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/returnConferBudgetRollBack.do",
            stateFn : modal,
            async : false,
            data : tblParam,
            successFn : function(result){
            	if(result){
            		if(result.result =="OK"){
            			detailInit();
            		}
            		else{
            			alert("<%=BizboxAMessage.getMessage("TX000009899","처리중 오류가 발생하였습니다")%>");
            		}
            	}else{
            		alert("<%=BizboxAMessage.getMessage("TX000009899","처리중 오류가 발생하였습니다")%>");
            	}
            },
            failFn: function (request,status,error) {
            	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>\n<%=BizboxAMessage.getMessage("TX000009711","오류 메시지 : {0}")%>".replace("{0}",error)+"\n");	    	    
        	}
    };
	
    acUtil.ajax.call(opt);
	}
};

docList.reset = function(){
    $("#MGT_CD").val("");
    $("#MGT_CD_NM").val("");
    $("#BGT_CD_FROM").val("");
    $("#BGT_NM_FROM").val("");
    $("#BGT_CD_TO").val("");
    $("#BGT_NM_TO").val("");
    $("#SYS_CD_FROM").val("");
    $("#SYS_CD_TO").val("");
    $("#BOTTOM_CD").val("");
    $("#BOTTOM_NM").val("");
};

docList.docView = function(dikeycode){
	var param = "diKeyCode="+dikeycode;
	neosPopup("POP_ONE_DOCVIEW",param, "popArchiveRegDoc");
    
};

docList.docDelete = function(){
	
    var grid = $("#grid").data("kendoGrid");
    var checkList = CommonKendo.getChecked(grid);
    if (checkList.length == 0) {
        alert("<%=BizboxAMessage.getMessage("TX000009178","문서를 선택하세요")%>");
        return;
    }
    else if (checkList.length > 1) {
        alert("<%=BizboxAMessage.getMessage("TX000009177","문서를 한개만 선택하세요")%>");
        return;
    } 
    
    if (checkList[0].APPR_STATUS < '008'){
    	alert('<%=BizboxAMessage.getMessage("TX000016514","결재완료된 문서만 삭제할수 있습니다.")%> \n  <%=BizboxAMessage.getMessage("TX000016608","삭제를 원하시면 결재회수 하시기 바랍니다")%>');  return;	
    }
    if (checkList[0].APPR_STATUS == 'd'){
        alert('<%=BizboxAMessage.getMessage("TX000009176","이미 삭제되었습니다")%>');  return; 
    }

//     if (checkList[0].DOCU_MODE == '0'){
//     	alert('결의서만 삭제할수 있습니다.');  return;	
//     }
    
    var tblParam = {};
    tblParam.c_dikeycode  = checkList[0].C_DIKEYCODE;
    tblParam.abdocu_no  = checkList[0].ABDOCU_NO;
    tblParam.docu_mode  = checkList[0].DOCU_MODE;
    
    
    if(confirm("<%=BizboxAMessage.getMessage("TX000013686", "삭제 시 사용자 데이터 복구는 불가능 합니다.　정말 삭제하시겠습니까?")%>".replace("　", "/n"))) {
    	$.ajax({
            type:"post",
            url:'<c:url value="/Ac/G20/State/delAcExDoc.do" />',
            datatype:"json",
            data: tblParam,
            success:function(data){
            	
                if(checkList[0].DOCU_MODE == '1' && data.result.StatChk > 0 ){
                    alert("<%=BizboxAMessage.getMessage("TX000016484","전표가 생성되었습니다.")%> \n <%=BizboxAMessage.getMessage("TX000016615","ERP 에서 전표삭제후 진행해 주세요")%>");
                    return;
                }
                if(checkList[0].DOCU_MODE == '0' && data.result.StatChk > 0 ){
                    alert("<%=BizboxAMessage.getMessage("TX000016492","이미 참조품의 결의서가 작성되었습니다.")%> \n <%=BizboxAMessage.getMessage("TX000016602","품의서를 삭제할수 없습니다")%>");
                    
                    

                    return;
                }
                
                if(data.result.rollbak){
                	alert("<%=BizboxAMessage.getMessage("TX000016478","참조품의서의 환원처리를 취소하였으니 확인바랍니다")%>")
                	docList.searchList();
                }
                
                if(data.result.returnValue > 0 ){
                	alert("<%=BizboxAMessage.getMessage("TX000012074","삭제되었습니다")%>");
                	docList.searchList();
                }
            },error:function(e){
                 alert("<%=BizboxAMessage.getMessage("TX000009307","처리중 오류가 발생하였습니다")%>");
            }
        });
    }
        
};

</script>
            
<body>

            <input type="hidden" id="CO_CD" name="CO_CD"  class="formData" />
            <input type="hidden" id="EMP_CD" name="EMP_CD"  class="formData"  />
            <input type="hidden" id="FR_DT" name="FR_DT"  class="formData"  />
            <input type="hidden" id="TO_DT" name="TO_DT"  class="formData"  />
            <input type="hidden" id="DIV_CDS" name="DIV_CDS"  class="formData" />
            <input type="hidden" id="MGT_CDS" name="MGT_CDS"  class="formData" />
            <input type="hidden" id="BOTTOM_CDS" name="BOTTOM_CDS"  class="formData" /> 
            
<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
<!-- contents -->  
         
                        <div class="top_box">
                            <dl>
                                <dt><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></dt>
<!--                                 <dd><input id="CO_CD"  name="CO_CD" style="width:160px;" class="formData" /></dd> -->
                                <dd><span id="coInfo"/></dd>
                                <dt><%=BizboxAMessage.getMessage("TX000009174","기수기준일")%></dt>
                                <dd><input id="GISU_DT"  name="GISU_DT" class="dpWid formData"/></dd>
                                <dt><%=BizboxAMessage.getMessage("TX000003640","기수")%></dt>
                                <dd><input type="text"name="GISU"  id="GISU"  style="width:40px;" class="formData" readonly="readonly"> <%=BizboxAMessage.getMessage("TX000009914","기")%></dd>
                            </dl>
                        </div>
         
            <input type="hidden" id="searchYN" name="searchYN" value=""/>
            <input type="hidden" id="EXCEL_YN" name="EXCEL_YN" value=""/>                               

<%--             <input type="hidden" name="pageIndex"  id="pageIndex"  value="${docListParamVO.paginationInfo.currentPageNo }"  /> --%>
                        <!-- 조회조건 -->
                        <div class="com_ta mt10">
                            <table id="searchTable">
                                <colgroup>
                                    <col width="93" class="en_w130"/>
                                    <col width="40%"/>
                                    <col width="93" class="en_w130"/>
                                    <col width=""/>
                                </colgroup>
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000000811","사업장")%></th>
                                    <td><input id="DIV_CD" name="DIV_CD" class="formData"  style="width:160px;"/> <!-- <select style='width:180px;' id='DIV_CD' name='DIV_CD' class="formData"> --></td>
                                    <th><%=BizboxAMessage.getMessage("TX000000861","조회기간")%></th>
                                    <td>
                                        <input id="DATE_FROM"  name="DATE_FROM" class="dpWid formData"/>
                                        ~
                                        <input id="DATE_TO"  name="DATE_TO" class="dpWid formData"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="FG_TYSpan"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></th>
                                    <td>
                                        <input type="text" style="width:135px;" id="MGT_CD_NM"  name="MGT_CD_NM"  readonly="readonly" class="requirement formData" />
                                        <input type="text" style="width:100px;" id="MGT_CD"  name="MGT_CD" class="requirement formData" />
                                        <a href="javascript:;" class="search-Event-H btn_search"></a>
<!--                                      <span class="bottonSpan" style="display:none;">  -->
<!--                                         <input type="text" style="width:135px;" id="BOTTOM_NM" name="BOTTOM_NM" readonly="readonly" class="requirement formData" /> -->
<!--                                         <input type="text" style="width:100px;" id="BOTTOM_CD"  name="BOTTOM_CD" class="formData"/> -->
<!--                                         <a href="javascript:;" class="search-Event-H btn_search"></a> -->
<!--                                      </span> -->
                                    </td>
                                    <th><%=BizboxAMessage.getMessage("TX000005362","하위사업")%></th>
                                    <td>
                                        <input type="text" style="width:135px;" id="BOTTOM_NM" name="BOTTOM_NM" readonly="readonly" class="requirement formData" />
                                        <input type="text" style="width:100px;" id="BOTTOM_CD"  name="BOTTOM_CD" class="formData"/>
                                        <a href="javascript:;" class="search-Event-H btn_search"></a>
                                     </span>
                                    </td>                                    
                                </tr>                 
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
                                    <td colspan="3">
                                        <div class="dp_ib" style="width:270px;">
                                            <input type="text" style="width:135px;" id="BGT_NM_FROM" name="BGT_NM_FROM" readonly="readonly" class="requirement BGT_CD formData"  target="FROM"/>
                                            <input type="text" style="width:100px;" id="BGT_CD_FROM" name="BGT_CD_FROM" readonly="readonly" class="requirement BGT_CD formData" target="FROM"/>
                                            <input type="hidden"  name="SYS_CD_FROM"  id="SYS_CD_FROM"  class="formData"  target="FROM"/>
<!--                                             <input class="k-textbox input_search" id="" type="text" value="" style="width:100px;" placeholder=""> -->
                                            <a href="#" class="btn_search search-Event-H"></a>
                                        </div>
                                        ~
                                        <div class="dp_ib" style="width:270px;">
                                            <input type="text" style="width:135px;" id="BGT_NM_TO" name="BGT_NM_TO" readonly="readonly"  value="${ErpBudgetVO.BGT_NM_TO}" class="requirement BGT_CD formData" target="TO"/> 
                                            <input type="text" style="width:100px;" id="BGT_CD_TO" name="BGT_CD_TO" value="${ErpBudgetVO.BGT_CD_TO}" readonly="readonly" class="requirement BGT_CD formData" target="TO"/>
                                            <input type="hidden"  name="SYS_CD_TO"  id="SYS_CD_TO"  class="formData" target="TO"/>
                                            <a href="javascript:;" class="btn_search search-Event-H"></a>
                                        </div>                               
                                    </td>
                                </tr>   
                                <tr>
                                    <th scope="row"><%=BizboxAMessage.getMessage("TX000007371","문서구분")%></th>
                                    <td><input id="DOCU_MODE" name="DOCU_MODE" style="width:100px;" class="formData"/></td>
                                    <th scope="row"><%=BizboxAMessage.getMessage("TX000011180","결제수단")%></th>
                                    <td><input id="SET_FG" name="SET_FG" style="width:100px;" class="formData"/>
                                        <span class="btn_Detail btn_Detail_no"><%=BizboxAMessage.getMessage("TX000000793","상세")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>"/></span>
                                    </td>
                                </tr>
                            </table>            
                        </div> 

                        <!-- 상단검색 -->   
<!--                         <div class="SearchDetail mb10"> -->
                        <div id="SearchDetail" class="com_ta mt-1">
                            <table>
                                <colgroup>
                                    <col width="93"/>
                                    <col width="40%"/>
                                    <col width="93"/>
                                    <col width=""/>
                                </colgroup>                        
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000003457","문서제목")%></th>
                                    <td><input  type="text"  id="docTitle" name="docTitle"  style="width:200px;" value="${docListParamVO.docTitle}" class="formData"/></td>
                                    <th><%=BizboxAMessage.getMessage("TX000000663","문서번호")%></th>
                                    <td><input  type="text"  id="docNum" name="docNum"  style="width:200px;" value="${docListParamVO.docNum}" class="formData"/> </td>
                                </tr>
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000000499","기안자")%></th>
                                    <td><input type="text" id="drafter" name="drafter" style="width:200px;" value="${docListParamVO.drafter}"  class="formData"/></td>
                                    <th><%=BizboxAMessage.getMessage("TX000000490","결재상태")%></th>
                                    <td><input id="docStatus"  name="docStatus"  style="width:100px;" class="formData"/></td>                                    
                                </tr>                   
                             </table>
                        </div>
        
                                <!-- 조회버튼 -->
                        <div class="btn_cen pt12">
                            <input type="button" class="btnSearch" value="<%=BizboxAMessage.getMessage("TX000000899","조회")%>">
                        </div>
                        
                        <div class="controll_btn" style="padding:0px;">
<%--                            <c:if test="${delAuthor == 'Y'}" > --%>
                           <button type="button"  onclick="docList.docDelete();"><%=BizboxAMessage.getMessage("TX000003809","문서삭제")%></button>
<%--                            </c:if> --%>
                        </div>                

                        <div class="g20_date_grid">
                            <!-- 테이블 -->
                            <div id="grid" class="data_grid"></div> 
                        </div>
                        
                        <div class="com_ta2 ova_sc cursor_p mt14">
                           <table border="0" id="AcExDocDetail_table" style="width: 100%" >
<%--                            <colgroup> --%>
<%-- 			                    <col width="90" /> --%>
<%-- 			                    <col width="" /> --%>
<%-- 			                    <col width="" /> --%>
<%-- 			                    <col width="" /> --%>
<%-- 			                    <col width="" /> --%>
<%-- 			                    <col width="" /> --%>
<%-- 			                    <col width="100" /> --%>
<%-- 			                    <col width="100" /> --%>
<%-- 			                    <col width="100" /> --%>
<%-- 			                    <col width="100" /> --%>
<%-- 			                    <col width="100" /> --%>
<%-- 			                    <col width="100" />			                     --%>
<%--                            </colgroup> --%>
             			   <thead>
          			          <tr>
                 			        <th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000003625","관")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000003626","항")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000003627","목")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000003628","세")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000005220","품의금액")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000003874","사용금액")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000005469","잔액")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000011194","예산환원")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000005056","집행액")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000009179","참조품의문서")%></th>
          			          </tr>
             			   </thead>                  
             			   <tbody id="AcExDocDetail">
             			      <tr>
             			            <td colspan="12"></td>
             			      </tr>
             			   </tbody>  
            </table>
        </div>                             

</div>

<!-- //contents -->

<div id="dialog-form-standard" style="display:none">
<div class="pop_wrap_dir" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" /></a>
    </div>
    <div class="pop_con">       
        <!-- 예산검색 -->     
        <div class="top_box" style="overflow:hidden;display:none;" id="Budget_Search">
            <dl class="">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005289","예산과목표시")%> :
                 </dt>
                 <dd>                         
                        <input type="radio" name="OPT_01" value="2"  id="OPT_01_2" class="k-radio" checked="checked" />
                        <label class="k-radio-label" for="OPT_01_2" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005290","당기 편성된 예산과목만 표시")%></label>
                        <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005112","모든 예산과목 표시")%></label>
                        <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_3" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005291","프로젝트 기간 예산 편성된 과목만 표시")%></label>
                </dd>
            </dl>
            <dl class="">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005486","사용기한")%> : 
                </dt>
                <dd> 
                        <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio"  checked="checked" />
                        <label class="k-radio-label"  for="OPT_02_1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000004225","모두표시")%></label>
                        <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" />
                        <label class="k-radio-label"  for="OPT_02_2" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000009907","사용기한경과분 숨김")%></label>
                </dt>                
            </dl>            
        </div>
                                        
        <div class="com_ta2 mt10 ova_sc_all cursor_p"  style="height:340px;" id="dialog-form-standard-bind">
        </div>
        

    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="dialog-form-background_dir" style="display:none;"></div>	
