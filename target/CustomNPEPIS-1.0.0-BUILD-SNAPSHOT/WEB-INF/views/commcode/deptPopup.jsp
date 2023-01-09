<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
/*yh*/
.k-treeview .k-minus{background: url("../Images/ico/ico_organ03_open.png")}
/*yh*/
.k-treeview .k-plus{background: url("../Images/ico/ico_organ03_close.png")}

/*yh*/
.k-treeview .k-top.k-bot .k-plus{background: url("../Images/ico/ico_organ01.png")}
.k-treeview .k-top.k-bot .k-minus{background: url("../Images/ico/ico_organ01.png")}

.k-treeview .k-plus-disabled, .k-treeview .k-minus-disabled {
	cursor: default
}
/*yh*/
.k-treeview .k-top,
.k-treeview .k-mid,
.k-treeview .k-bot {
  background-image: url('../Images/bg/treeview-nodes.png');
  background-repeat: no-repeat;
  margin-left: -16px;
  padding-left: 16px;
}
/*yh*/
.k-treeview .k-item { background-image: url('../Images/bg/treeview-line.png'); }
.k-treeview .k-last { background-image: none; }
.k-treeview .k-top { background-position: -91px 0; }
.k-treeview .k-bot { background-position: -69px -22px; }
.k-treeview .k-mid { background-position: -47px -44px; }
.k-treeview .k-last .k-top { background-position: -25px -66px; }
.k-treeview .k-group .k-last .k-bot { background-position: -69px -22px; }
.k-treeview .k-item {
  background-repeat: no-repeat;
}
.k-treeview .k-top.k-bot{background: none;}


/*yh*/
.k-treeview .k-first {
  background-repeat: no-repeat;
  background-position: 0 16px;
}

</style>

<div class="pop_head">
	<h1>조직도</h1>
	<a href="#n" class="clo"><img src="../Images/btn/btn_pop_clo01.png" alt=""></a>
</div>
<div id="treeview" style="background-color:#FCFCFA; padding-top:30px; padding-left:10px; float: left; width: 300px; height: 600px; border: 1px solid #dbdbde">
</div>

<script>
var datas = JSON.parse('${data}');
var deptSeq = '${userInfo.deptSeq}';
var deptName = '${userInfo.orgnztNm}';
$(function(){
	
	$("#treeview").kendoTreeView({
	    dataSource: datas,
	    dataTextField:['dept_name'],
	    select: treeClick,
	});
	
	$(document).on('dblclick', '.k-in', function(){
		opener.deptPopupClose(deptSeq, deptName);
		window.close();
	});
});

/**조직도 클릭이벤트*/
function treeClick(e){
	var item = $("#treeview").data("kendoTreeView").dataItem(e.node);
	deptSeq = item.dept_seq;
	deptName = item.dept_name;
}

function dataresource(datas){
	if('${userInfo.bizSeq}' != '10000101') {
		$.each(datas[0].items, function(i, v){
			if(v.biz_seq == '${userInfo.bizSeq}'){
				datas[0].items = [v];
			}
		});
	}
	return datas;
}

</script>