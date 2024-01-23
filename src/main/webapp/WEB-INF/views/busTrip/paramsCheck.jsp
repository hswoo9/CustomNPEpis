<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<body>
<div class="iframe_wrap" style="min-width:1100px">
    <iframe src="" id="iframe" onload="" frameborder="0" scrolling="no" style="overflow-x:hidden; overflow:auto; width:250px; min-height:500px;"></iframe>
</div>
<script>
    var param = JSON.parse('${paramMap}');
    var parameter = {};
    if(param != ''){
        for(var key in param){
            parameter[key] = encodeURI(param[key]);
        }
    }
    var loginVO = '${loginVO}';

    var submitCount = 0;

    function insertEmpInfo(){
        $.ajax({
            type: "post",
            url: "/gw/cmm/systemx/empInfoSaveProc.do",
            datatype: "text",
            async: false,
            data: parameter,
            success: function (data) {
                console.log(data);
                if(data.resultCode != null && data.resultCode != null){
                    if(data.result == "권한이 없습니다" && data.resultCode == "fail"){
                        if(submitCount < 2){
                            $("#iframe").attr("src", "/gw/changeUserSe.do?userSe=ADMIN");
                            $("#iframe").load(function(){
                                insertEmpInfo();
                                submitCount++;
                            });
                        }
                    }else if(data.resultCode == "SUCCESS"){
                        alert("등록이 완료되었습니다.");
                        window.parent.postMessage(
                            {
                                func: "dataSet",
                                result: data
                            },
                            '*'
                        );
                        //window.close();
                    }
                }
            }
        });
    }

    $(function(){
        $("#iframe").attr("src", "/gw/adminMain.do");
        //$("#iframe").attr("src", "/gw/changeUserSe.do?userSe=ADMIN");
        $("#iframe").load(function(){
            //insertEmpInfo();
            if($(this).attr("src") == "/gw/adminMain.do"){
                insertEmpInfo();
            }
        });
        //
    });


</script>
</body>

