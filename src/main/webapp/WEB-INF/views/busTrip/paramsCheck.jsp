<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<body>
<div class="iframe_wrap" style="min-width:1100px">
</div>
<script>
    var param = JSON.parse('${paramMap}');
    var parameter = {};
    if(param != ''){
        for(var key in param){
            parameter[key] = encodeURI(param[key]);
        }
    }
    $(function(){

        $.ajax({
            type: "post",
            url: "/gw/cmm/systemx/empInfoSaveProc.do",
            datatype: "text",
            async: false,
            data: parameter,
            success: function (data) {
                console.log(data);
            }
        });

    });


</script>
</body>

