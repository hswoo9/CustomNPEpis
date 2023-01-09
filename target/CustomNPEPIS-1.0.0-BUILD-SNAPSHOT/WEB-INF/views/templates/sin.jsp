<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>


<script>

var teamType;

$(function(){
	
	
	$('#screeningSearchPopup').kendoWindow({
	    width: "1000px",
	    title: '심사원 검색',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	
});

function screeningSearchPopupPoen(type){
	teamType = type;
	$('#screeningSearchPopup').data("kendoWindow").open();
	
}

<%--팀장 --%>
function screeningTeamLeader(){
	screeningSearchPopupPoen('tl');
	screeningSearchPopupGrid();
	
}

<%--팀원 --%>
function screeningTeam(){
	screeningSearchPopupPoen('t');
	screeningSearchPopupGrid();
	
}

function screeningSearchPopupGrid(){
	
	$('#screeningSearchPopupGrid').kendoGrid({
        dataSource: screeningSearchPopupGridDataSource,
        height: 350,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes: true,
            buttonCount: 5
        },
        persistSelection: true,
        columns: [
        {
            field: "CMPY_NM",
            title: "이름",
            width: 170,
        }, {
            field: "BSNS_NO",
            title: "부서",
            width: 90,
        },{
            field: "RPST_NM",
            title: "직위",
            width: 70,
        },{
            field: "CMPY_TEL",
            title: "적격성",
            width: 90,
        },{
            title: "구분",
        },{
            title: "심사코드",
        },{
            title: "심사규격",
        },{
            title: "MD",
        },{
            title: "선택",
            template: choiceBtn
        }]
    }).data("kendoGrid");
	
	
}


var screeningSearchPopupGridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/common/screeningSearchPopupGridSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {

      		return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
    
});


var choiceBtn = function(row){
	
	return '';
}

function screeningSearchPopupGridCancel(){
	$('#screeningSearchPopup').data("kendoWindow").close();
	
}







</script>
<input type="button" onclick="screeningTeamLeader();" value="심사팀장검색">
<input type="button" onclick="screeningTeam();" value="심사팀원검색">

<div class="pop_wrap_dir" style="width:1000px;" id="screeningSearchPopup">
	    <div class="pop_con">
	        <div class="top_box">
	            <dl>
	                <dt class="ar" style="width:49px">심사규격</dt>
	                <dd><input type="text" style="width:130px;" placeholder="" /></dd>
	                <dt class="ar" style="width:49px">인증심사코드</dt>
	                <dd><input type="text" style="width:130px;" placeholder="" /></dd>
	                <dt>심사원명</dt>
	                <dd><input type="text" style="width:130px;" placeholder="" /></dd>
	                <dt>부서</dt>
	                <dd><input type="text" style="width:130px;" placeholder="" /></dd>
	            </dl>
	            <dl class="next2">
	                <dt>구분</dt>
	                <dd><input type="text" style="width:130px;" placeholder="" /></dd>
	                <dd><input type="button" id="searchButton" value="검색" /></dd>
	            </dl>
	        </div>
	
	        <!-- 등록 테이블 -->
	        <div class="com_ta2 mt14" id="screeningSearchPopupGrid">
	        </div>

        </div><!-- //pop_con -->
        
        <div class="pop_foot">
            <div class="btn_cen pt12">
                <input type="button" onclick="screeningSearchPopupGridCancel();" value="닫 기" />
            </div>
        </div><!-- //pop_foot -->
    </div><!-- //pop_wrap -->
    
    
    
    