var main = {};


$(function(){
	
});

  
 


main.userLogout = function() {
	location.href = "uat/uia/actionLogout.do";
};


// 기안작성 팝업 eaType => eap :  비영리, ea : 영리
main.fnEaFormPop = function(eaType) {

	if(eaType != "eap"){
		alert("영리전자결재 모듈 외는 준비중입니다.");
		return;
	}
	
	var kendoWin = $("#formWindow");
	var url = "/" + eaType + "/FormListPop.do";
	
	kendoWin.kendoWindow({
		iframe: true ,
		draggable: false,
		width : "400px",
		height: "500px",
		title : "양식함",
		visible : false,
		content : {
			url : url,
			type : "GET",
		},
		actions: [
	          "Minimize",
	          "Close",
	          "Refresh"
		          ]
	}).data("kendoWindow").center().open();
//	kendoWin.data("kendoWindow").refresh();
};

//기안작성 팝업 close 
main.fnEaFormClose = function()
{
   $("#formWindow").data("kendoWindow").close();
};