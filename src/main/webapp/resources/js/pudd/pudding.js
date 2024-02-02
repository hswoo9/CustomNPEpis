/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudding.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var pudding = {

	// path 항목은 아래의 스크립트 경로 설정을 위한 부분에서만 사용됨
	path : "../../../Scripts/pudd/"
	//path : "/pudd/Scripts/pudd/"

	// 스킨명
,	skinName : "PUDD-COLOR-blue"

	// puddSetup 설정 없어도 페이지 전체에 있는 컨트롤 부분을 페이지 로딩시에 자동으로 변경 처리여부 설정
,	autoApply : false

};



// 개발용 script 로딩
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.config.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.textbox.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.password.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.checkbox.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.radio.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.button.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.filebox.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.combobox.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.textarea.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.control.datepicker.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.component.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.component.calendar.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.component.gridtable.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.element.component.pager.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.dateutil.js"></scrip' +'t>');
document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.portlet.js"></scrip' +'t>');

// 배포용 script 로딩
//document.write('<script type="text/javascript" src="' + pudding.path + 'pudd.min.js"></scrip' +'t>');
