// 이미지 롤오버 
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}


// 투명이미지
function setPng24(obj) {
         obj.width=obj.height=1;
         obj.className=obj.className.replace(/\bpng24\b/i,'');
         obj.style.filter =
         "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ obj.src +"',sizingMethod='image');"
         obj.src=''; 
        return '';
     }


$(document).ready(function(){	
	var cont = $("#content");
	

	//top menu
	$(function(){
		var topmn = $(".top_mn li");
		topmn.mouseover(function(){
			for(i=0;i<topmn.length;i++){
				var idx = topmn.index(this);
				if(i==idx){
					$(topmn[idx]).addClass("on");
					$("img",topmn[idx]).attr("src", function(){return $(this).attr("src").replace("_off.gif","_on.gif")});
				}else if(i!=idx){
					$(topmn[i]).removeClass("on");
					$("img",topmn[i]).attr("src", function(){return $(this).attr("src").replace("_on.gif","_off.gif")});
				}				
			}
		});
	});
	

    
	//balloon
	$(function(){
		$(".switch a").mouseover(function(){
			$(this).next().css("display","block");
			if($(this).attr("class")=="hide"){
				$(this).next().text("펼치기");
				$(this).removeClass("hide").addClass("show");
			}else if($(this).attr("class")=="show"){
				$(this).next().text("접기");
				$(this).removeClass("show").addClass("hide");
			}
		});
		$(".switch a").mouseout(function(){
			$(this).next().css("display","none");
		});
		//layer show/hide
		$(".switch a").toggle(function(){
			$(".cont_rnb").animate({width:"144px"}).css("overflow","visible");
			$(".cont_rnb ul").animate({width:"152px"});
			$(".cont_cen",cont).animate({width:$(".cont_cen",cont).width()});
			$("img",this).attr("src",function(){return $(this).attr("src").replace("show.gif","hide.gif");});
		},function(){
			$(".cont_rnb").animate({width:"32px"}).css("overflow","visible");
			$(".cont_rnb  ul").animate({width:"40px"});
			$(".cont_cen",cont).animate({width:$(".cont_cen",cont).width()});
			$("img",this).attr("src",function(){return $(this).attr("src").replace("hide.gif","show.gif");});
		});
	});
	//bar  Edward 불필요 코드 삭제.  css 에서 처리되고 있음.
	/*
	$(function(){
		$("#bar").mouseover(function(){
			 $(this).css({"background":"#f7e0c5","cursor":"e-resize"});
		}).mouseout(function(){
			$(this).css("background","#eeeeee");
		});		
	});
	*/
	

	
	
	//바로가기
	$(function(){
		$("#oth_list").click(function(){
			$(".sel_lay").css("display","block");
		});
		$(".sel_lay .close").click(function(){
			$(".sel_lay").css("display","none");
		});
	});
	//move
	$(function(){
		$(".move").click(function(){
			$(".m_list").css("display","block");
		});
		$(".move").mouseleave(function(){
			$(".m_list").css("display","none");
		});
	});

	//셀렉트 박스
	$(function(){
		var selObj = $(".selBox");
		var selCount = selObj.length;
		var count = selCount;
		selObj.each(function(idx){
			var selList = $(selObj[idx]).find("li");
			var selTxt = $(selObj[idx]).find("p.selTxt");
			//zindex 지정
			$(selObj[idx]).css("z-index",count--);

			// 리스트박스 open
			selTxt.click(function(){
				$(selObj[idx]).find("ul").css("display","block");
			});

			//마우스가 떠났을때 close.
			$(selObj).bind("mouseleave",function(){
				if($(selObj[idx]).find("ul").css("display") =="block"){$(selObj[idx]).find("ul").css("display", "none");}
			});
			
			//선택 항목 세팅
			selList.click(function(){
				var selIdx = selList.index(this);
				$("span", selTxt).text($("a", selList[selIdx]).text());
				$(selObj[idx]).find("ul").css("display", "none");
			});
		});
	});
});




// 이미지 롤오버 스크립트

function imageOver(imgEl) {
	imgEl.src = imgEl.src.replace(".gif", "_on.gif");
}
function imageOut(imgEl) {
	imgEl.src = imgEl.src.replace("_on.gif", ".gif");
}



// 문서발송 관인이미지(ZZ_ZA026)

function show_VoIP(fvalue) {
  if (fvalue == '1') {
    show_VoIP1.style.display = '';
    show_VoIP2.style.display = 'none';
		show_VoIP3.style.display = 'none';
  }
	if (fvalue == '2') {
		show_VoIP1.style.display = 'none';
    show_VoIP2.style.display = '';
		show_VoIP3.style.display = 'none';
  }
	if (fvalue == '3') {
    show_VoIP1.style.display = 'none';
    show_VoIP2.style.display = 'none';
		show_VoIP3.style.display = '';
  }
}


// 레이어 

function toggle_visibility(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'block')
          e.style.display = 'none';
       else
          e.style.display = 'block';
    }

//전자결재 팝업 이미지 alt값
function rib_alt_view(opt) {
    if (opt) {
        rib_alt.style.display = "block";
    }
    else {
        rib_alt.style.display = "none";
    }
}

function rib_alt_view01(opt) {
    if (opt) {
        rib_alt01.style.display = "block";
    }
    else {
        rib_alt01.style.display = "none";
    }
}
function rib_alt_view02(opt) {
    if (opt) {
        rib_alt02.style.display = "block";
    }
    else {
        rib_alt02.style.display = "none";
    }
}

//입력 텍스트 기본 설정
var bContentUse = 0;
var txtContent = "";
function clearContent(obj)
{
    if(bContentUse < 2)
    {
        if(bContentUse == 0)
        {
            txtContent = $(obj).val();  
        }
        bContentUse = 1;
        $(obj).val("");     
    }
    $(obj).css("color","#333");
}

function checkContent(obj)
{
    var text = $(obj).val();
    bContentUse = 2;
    if(text.replace(/(^\s*)|(\s*$)/gi, "") == "")
    {
        $(obj).val(txtContent);
        $(obj).css("color","#a5a5a5");              
        bContentUse = 1;
    }   
}

function getToday(dateFormat, split) {
	
	var date = new Date(); 

	  
    var year  	= date.getFullYear(); 
    var month 	= date.getMonth() + 1; 
    var day  	= date.getDate(); 

    if (("" + month).length == 1) { month = "0" + month; } 
    if (("" + day).length  == 1) { day  = "0" + day;  } 

    if(dateFormat=="yyyy")  return year ;
    else if(dateFormat=="mm")  return month ;
    else if(dateFormat=="dd")  return day ;
    else if(dateFormat=="yyyymm")  return year + split + month ;
    else if(dateFormat=="mmdd")  return month + split + day ;
    else return  year + split + month + split + day;
}

// 요일 구하기
function getDayLang(d, langCode) {
	
	var dayStr = "";
	
	if (langCode == 'kr') {
		var week = new Array('일', '월', '화', '수', '목', '금', '토');
		dayStr = week[d.getDay()] + "요일";
	}
	
	return dayStr;
}

function getParamsInputArr(inputArrObj) {
	var returnData = "";
	if (inputArrObj != null && inputArrObj.length > 0) {
		for (var i = 0; i < inputArrObj.length; i++) {
			if (inputArrObj[i] != null && inputArrObj[i].value != '' && inputArrObj[i].value != '&nbsp;') {
				returnData += inputArrObj[i].value + ";";
			}
		}
	}
	
	if (returnData != '') {
		return returnData.substring(0, returnData.length-1);
	} else {
		return '';
	}
}

function readyInfo() {
	alert("죄송합니다. 서비스 준비중입니다.");	
}

//kendo grid 데이터 없음 표시 
function gridDataBound(e) {
 var grid = e.sender;
 if (grid.dataSource.total() == 0) {
     var colCount = grid.columns.length;
     $(e.sender.wrapper)
         .find('tbody')
//         .append('<tr class="kendo-data-row"><td colspan="' + colCount+ '" class="no-data" style="text-align: center;">데이터가 존재하지 않습니다.</td></tr>');
     .append('<tr class="kendo-data-row"><td colspan="' + colCount+ '" class="no-data" style="text-align: center;">데이터가 존재하지 않습니다.</td></tr>');
 }
};	

// 절상
// 원, 절상 단위, 율, 자리수
function neosWonCeil(n, n2, r, s) {
	var v1 = parseFloat(parseFloat(n) * r).toFixed(s);
	var v2 = Math.ceil(v1/n2) * n2;
	return v2;
}

// 절삭
// 원, 절삭 단위, 율, 자리수
function neosWonFloor(n, n2, r, s) {
	var v1 = parseFloat(parseFloat(n) * r).toFixed(s);
	var v2 = Math.floor(v1/n2) * n2;
	return v2;
}

/*
String.prototype.toCommify = Number.prototype.toCommify = function()
{
	var n = String(this).replace(/\,/g,'');
	return n.match(RegExp('^[0-9]{'+(n.length%3||3)+'}|[0-9]{3}','g'))==null?'':n.match(RegExp('^[0-9]{'+(n.length%3||3)+'}|[0-9]{3}','g'));
};

String.prototype.onlyNumber = function()
{
	return String(this).replace(/\..*|[^\d]/g,'').toCommify();
};

String.prototype.MinusNumber = function()
{
	var pre = '';
	if(this.length>0)
	{
		if(this.charAt(0)=='-') pre = '-';
	}
	var num = this.replace(/\..*|[^\d]/g,'');
	return pre+num.toCommify();
};

String.prototype.trim = function()
{
	return this.replace(/(^\s*)|(\s*$)/g, "");
};

Object.prototype.minusNumber = function()
{
	$(this).keyup(function(e){this.value = this.value.MinusNumber();});
	$(this).blur(function(e){this.value = this.value.MinusNumber();});
};
*/