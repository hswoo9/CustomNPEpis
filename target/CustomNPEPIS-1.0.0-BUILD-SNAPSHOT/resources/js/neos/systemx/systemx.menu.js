var menu = {};

menu.topMenuInfo = {};

menu.leftMenuList = [];

menu.edmsDomain = null;

menu.isFirstMenu = true;

menu.callMenuInfo = {};

var mainmenu = {};

var pageFlag = true;

/** top 메뉴 클릭 **/
mainmenu.clickTopBtn = function(no, name, url, urlGubun, isForward){
	
	$("#no").val(no);
	$("#name").val(name);
	$("#url").val(url);
	$("#urlGubun").val(urlGubun);
	
	if (urlGubun == 'mail') {
		form.action="bizboxMail.do";
	} else {
		form.action="bizbox.do";
	}
	
	form.submit();
	
};


/** 초기화 **/
menu.init = function() {
	
	console.log('menu.init');
	
	menu.leftMenuList = [];
	menu.isFirstMenu = true;
	menu.callMenuInfo = {};
	
};


/** top 메뉴 클릭 **/
menu.clickTopBtn = function(no, name, url, urlGubun, menuGubun) {

	if (urlGubun == 'mail') {
		menu.go(urlGubun, url);
		return;
	}
	
	
	menu.init();
	
	menu.topMenuInfo = {};	
	menu.topMenuInfo.name = name;
	menu.topMenuInfo.menuNo = no;
	
	/* 왼쪽메뉴 상단 제목 */
	$(".sub_nav_title").html(name);
	
	/* 왼쪽메뉴 상단 아이콘 */
	/* ma 메일
	   ea 전자결재
	   dc 문서
	   st 시스템설정
	   sc 일정
	   ds 대사우서비스		
	   wk 업무
	   gt 근태관리	
	   bd 게시판	
	   mp 마이페이지	
	   mg 메신저
	   et 확장기능
	   nt 노트 */
	/* 현재 메뉴를 구분할 수 있는 값이 name밖에 없어 일단 name으로 처리합니다. */
	$(".side_wrap").removeClass("ma ea dc st sc ds wk gt bd mp mg et nt");
	if (name == "메일") {
		$(".side_wrap").addClass("ma");
	} else if (name == "전자결재" || name == "전자결재(영리)") {
		$(".side_wrap").addClass("ea");
	} else if (name == "문서") {
		$(".side_wrap").addClass("dc");
	} else if (name == "시스템설정") {
		$(".side_wrap").addClass("st");
	} else if (name == "일정" || name == "일정관리") {
		$(".side_wrap").addClass("sc");
	} else if (name == "대사우서비스") {
		$(".side_wrap").addClass("ds");
	} else if (name == "업무" || name == "업무관리") {
		$(".side_wrap").addClass("wk");
	} else if (name == "근태관리") {
		$(".side_wrap").addClass("gt");
	} else if (name == "게시판") {
		$(".side_wrap").addClass("bd");
	} else if (name == "마이페이지") {
		$(".side_wrap").addClass("mp");
	} else if (name == "메신저") {
		$(".side_wrap").addClass("mg");
	} else if (name == "확장기능") {
		$(".side_wrap").addClass("et");
	} else {
		$(".side_wrap").addClass("nt");
	}
	
	menu.topMenuInfo.url = url;
	menu.topMenuInfo.urlGubun = urlGubun;
	menu.setLeftMenu(no);
	
};


menu.timeline = function(target){
	
	menu.leftMenuList = [];
	menu.isFirstMenu = false;
	menu.callMenuInfo = {};
	
	if (target == "timeline") {
		form.action="timeline.do";
	}
	else {
		form.action="userMain.do";
	}
	
	form.submit();
	
};


/** 메인에서 페이지 이동 **/
menu.mainforwardPage = function(url) {
	
	if (url == null || url == '') {
		//alert('1');
		//alert("죄송합니다. 서비스 준비중입니다.");
		return;
	}
	
	if (forwardType == 'main') {
		$("#mainForward").val("mainForward");
		$("#url").val(url);
		form.submit();
	}
	
};


/** 한글 기안 팝업 **/
menu.approvalPopup = function(popType, param, popName) {
	
	if(ncCom_Empty(popName)) {
		popName = "popDocApprovalEdit";
	}
	if(popType == "POP_ONE_DOCVIEW") {
		param= "multiViewYN=N&"+param;
	}else {
		param= "multiViewYN=Y&"+param;
    }
	
	var uri = "/ea/edoc/eapproval/docCommonDraftView.do?"+ param;
	
	return openWindow2(uri,  popName,  _g_aproval_width_, _g_aproval_heigth_, 1,1) ;
	
};


/** 알림 데이터 조회 폴링방식 **/
menu.alertPolling = function() {
	
	setTimeout(function(){
		$.ajax({ 
			type:"post",
			url: _g_contextPath_ + "/alertInfo.do", 
			datatype:"text",
			complete: menu.alertPolling,
			success:function(data){								
				$("#alertBox").html(data); 
			},
			error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
		});
	}, 300000); // 5분 
	
}; 


/** 1회용 알림 데이터 조회 **/
menu.alertInfo = function() {
	$.ajax({ 
		type:"post",
		url: _g_contextPath_ + "/alertInfo.do", 
		datatype:"text",
		success:function(data){								
			$("#alertBox").html(data); 
		},
		error: function(xhr) { 
	      console.log('FAIL : ', xhr);
		}
	});
};


/** 알림 읽음 처리 및 페이지 이동 처리 
 * 
 * alertSeq 	: 알림 seq -> t_co_alert
 * forwardType  : 메인, 서브
 * type  		: 페이지 이동 종류(NOTICE 또는 메뉴 구분 MENU001 ..)
 * gnbMenuNo	: 상단 메뉴 번호
 * lnbMenuNo	: 왼쪽 메뉴 번호(선택 할 메뉴)
 * url			: iframe 보여질 페이지 url
 * urlGubun		: 컨네이터명(edms,gw, project, schedule)
 * seq			: 게시판 번호 -> 게시판 메뉴는 DB 없고, 게시판 솔루션에서 개발한 API를 호출하여 즉시 만들기 때문에 메뉴번호가 아닌 seq를 소분류 메뉴와 합산하여 정하기 위한 seq
 * name			: 메뉴명
 * 
 * */
menu.moveAndReadCheck = function(alertSeq, forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
	
	if (alertSeq != null && alertSeq.length > 0) {
		menu.alertReadCheck(alertSeq);
	}
	
	menu.move(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name);
	
	menu.hideGbnPopup();
	
}

menu.moveAndReadCheck2 = function(alertSeq, forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
	
	if (alertSeq != null && alertSeq.length > 0) {
		menu.alertReadCheck(alertSeq);
	}
	
	menu.clickTimeline(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name)
	
	menu.hideGbnPopup();
	
}


/** 알림 읽첨 처리 db  **/
menu.alertReadCheck = function(alertSeq) {
	$.ajax({
	    url: _g_contextPath_ + "/alertReadCheckProc.do",
	    dataType: 'json',
	    data:{alertSeq:alertSeq},
	    success: function(data) { 
	    	//console.log(data);
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
};


/** 페이지 이동 */
menu.move = function(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name) {
	
	// 공지사항은 게시판으로 선택될 메뉴 시퀀스를 만들어줘야함(2단메뉴 + 시퀀스)
	if (type == 'NOTICE' || type == 'MENU005') {
		
		if (seq != null && seq != '') {
			lnbMenuNo = parseInt(lnbMenuNo)+parseInt(seq);
		}
		
		name = "게시판";
		
		urlGubun = "edms";
	}
	
	if (forwardType == 'main') {
		$("#mainForward").val("mainForward");
		$("#url").val(url);
		$("#urlGubun").val(urlGubun);
		$("#gnbMenuNo").val(gnbMenuNo);
		$("#no").val(gnbMenuNo);
		$("#name").val(name);
		$("#lnbMenuNo").val(lnbMenuNo);
		
		form.submit();
	} else {
		// bixbox.do
		menu.forwardFromMain(type, gnbMenuNo, lnbMenuNo, url, urlGubun, name);
	}
	
};

menu.clickTimeline = function(forwardType, type, gnbMenuNo, lnbMenuNo, url, urlGubun, seq, name){
	
	$("#mainForward").val(forwardType);
	$("#url").val(url);
	$("#urlGubun").val(urlGubun);
	$("#gnbMenuNo").val(gnbMenuNo);
	$("#no").val(gnbMenuNo);
	$("#name").val(name);
	$("#lnbMenuNo").val(lnbMenuNo);
	
	if (urlGubun == 'mail') {
		form.action="bizboxMail.do";
	} else {
		form.action="bizbox.do";
	}
	
	form.submit();
	
};


/** 메인에서 페이지 이동 신규 **/
menu.mainMove = function(type, urlPath, seq) {
	
	$.ajax({
	    url: _g_contextPath_ + "/mainPortletData.do",
	    dataType: 'json',
	    data:{langCode:'kr', portletType:type},
	    success: function(data) { 
	      var portlet = data.portletInfo;
	       
	      
	      $("#mainForward").val("mainForward");
		  $("#url").val(urlPath);
		  $("#urlGubun").val(portlet.lnbMenuGubun);
		  $("#gnbMenuNo").val(portlet.gnbMenuNo);
		  $("#no").val(portlet.gnbMenuNo);
		  $("#portletType").val(type);
		  $("#name").val(portlet.gnbMenuNm);
		   
		  var lnbMenuNo = portlet.lnbMenuNo;
		  // 공지사항은 게시판으로 선택될 메뉴 시퀀스를 만들어줘야함(2단메뉴 + 시퀀스)
		  if (type == 'NOTICE') {
			  
			  if (seq != null && seq != '') {
				  lnbMenuNo = parseInt(lnbMenuNo)+parseInt(seq);
			  }
		  }
		  
		  $("#lnbMenuNo").val(lnbMenuNo);
		  if (portlet.lnbMenuGubun == 'mail') {
			  form.action="bizboxMail.do";
		  } else {
			  form.action="bizbox.do";
		  }
		  form.submit();
	      
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
	
};


/** 메인 iframe에서 페이지 이동 **/         
menu.forwardFromMain = function(portletType, gnbMenuNo, lnbMenuNo, url, urlGubun, menuNm) {
	
	// 왼쪽 메뉴 붙이기
	$("#sub_nav").html(""); 
	$.ajax({
		type:"post",
		url: _g_contextPath_ + "/cmm/system/getMenuTreeList.do",
		data:{startWith : gnbMenuNo}, 
		datatype:"json",			 
		success:function(data){			
			//alert("왼쪽 메뉴 붙이기 : " + JSON.stringify(data));
			if (data.treeList) {
				/* 왼쪽 메뉴 리스트 셋팅 */
				var inline = new kendo.data.HierarchicalDataSource({
		                data: data.treeList,
		                schema: {
	                        model: {
	                        	id: "seq", 
	                            children: "items"
	                    } 
	                  }  
		        });
				  
				$("#sub_nav").kendoTreeView({
			        dataSource: inline,
			        select: menu.onSelect,
			        dataTextField: ["name"],
			        dataValueField: ["seq", "url"]
			    }); 
				
				menu.callMenuInfo = {menuNo:lnbMenuNo, urlGugun:urlGubun, urlPath:url};
				
				menu.menuSelect(menu.callMenuInfo);
				
				
				menu.topMenuInfo = {};
	
				menu.topMenuInfo.name = menuNm;
				
				menu.topMenuInfo.menuNo = gnbMenuNo;
				
				/* 왼쪽메뉴 상단 제목 */
				$(".sub_nav_title").html(menuNm);
				
				menu.go(urlGubun, url);
				
			} else { 
				$("#_content").attr("src", "");
				//alert('2');
				//alert("죄송합니다. 서비스 준비중입니다.");
			}
		}   
	}); 
	
};


/** 
 * 왼쪽 메뉴 히스토리 가져오기 위한 ajax
 * 
 * 번호  메뉴명
 * 100 전자결재
 * 110  ㄴ문서함
 * 111    ㄴ결대대시함
 * 
 */
menu.getMenuHistoryOfMenuNo = function(no, callbackFunction) {
	
	$.ajax({
	    url: _g_contextPath_ + "/cmm/system/getMenuListOfMenuNo.do",
	    dataType: 'jsonp',
	    data:{menuNo:no},
	    jsonpCallback: "myCallback",
	    success: function(data) { 
	      console.log('SUCESS : ', data);  
	      
	      if (data.length > 0) {  
	    	  
	    	  if (callbackFunction != null && callbackFunction != undefined) {
	    		callbackFunction(data);  
	    	  } else {
	    	  
		    	  var jsonArr = data[0];
		    	  
		    	  if (jsonArr != [] && jsonArr.length > 0) {
		    		  
		    		  var topMenu = jsonArr[0];
		    		  
		    		  var callMenu = jsonArr[jsonArr.length-1];
		    		  
		    		  // LNB 동일
		    		  if (menu.topMenuInfo.menuNo != null && menu.topMenuInfo.menuNo != '' 
		    			  && menu.topMenuInfo.menuNo == topMenu.menuNo) {
		    			  
		    			  menu.menuSelect(callMenu);
		    			  
		    			  
		    			  menu.getLeftMenuHistory(callMenu.menuNo);
		    			  
		    			   
		    		  } 
		    		  // LNB 다름. GNB 이동후 LNB 호출하고 page view 처리
		    		  else {
		    			  
		    			  menu.init();
		    			  
		    			  menu.isFirstMenu = false;
		    			  
		    			  menu.topMenuInfo.menuNo = topMenu.menuNo;
		    			  
		    			  menu.callMenuInfo = callMenu;
		    			 
		    			  menu.setLeftMenu(topMenu.menuNo);
		    			  
		    		  }
		    		  
		    		  menu.go(callMenu.urlGubun, callMenu.urlPath);
		    	  }
		      } 
	      }
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
	
};


/** contents 페이지 이동 **/
menu.forward = function(url) {
	
	if (url == null || url == '') {
		//alert('3');
		//alert("죄송합니다. 서비스 준비중입니다.");
		return;
	}
	
	$.ajax({
	    url: _g_contextPath_ + "/cmm/system/getMenuListOfUrl.do",
	    dataType: 'jsonp',
	    data:{langCode:'kr', urlPath:url},
	    jsonpCallback: "myCallback",
	    success: function(data) { 
	    	//alert("contents 페이지 이동 : " + JSON.stringify(data));
	      //console.log('SUCESS : ', data);  
	      
	      if (data.length > 0) {  
	    	  
	    	  var jsonArr = data[0];
	    	  
	    	  if (jsonArr != [] && jsonArr.length > 0) {
	    		  
	    		  var topMenu = jsonArr[0];
	    		  
	    		  var callMenu = jsonArr[jsonArr.length-1];
	    		  
	    		  // LNB 동일
	    		  if (menu.topMenuInfo.menuNo != null && menu.topMenuInfo.menuNo != '' 
	    			  && menu.topMenuInfo.menuNo == topMenu.menuNo) {
	    			  
	    			  menu.menuSelect(callMenu);
	    			  
	    			  
	    			  menu.getLeftMenuHistory(callMenu.menuNo);
	    			  
	    			   
	    		  } 
	    		  // LNB 다름. GNB 이동후 LNB 호출하고 page view 처리
	    		  else {
	    			  
	    			  menu.init();
	    			  
	    			  menu.isFirstMenu = false;
	    			  
	    			  menu.topMenuInfo.menuNo = topMenu.menuNo;
	    			  
	    			  menu.callMenuInfo = callMenu;
	    			 
	    			  menu.setLeftMenu(topMenu.menuNo);
	    			  
	    		  }
	    		  
	    		  menu.go(callMenu.urlGubun, callMenu.urlPath);
	    	  }
	      } 
	    },
	    error: function(xhr) { 
	      console.log('FAIL : ', xhr);
	    }
   });
	
};


/** 페이지 이동후 kendo tree 메뉴에서 선택하기(버튼이 선택된 형태로 하기 위해) **/
menu.menuSelect = function(item) {
	
	var treeview = $("#sub_nav").data("kendoTreeView");
				 	
	/* treeview에서 select 처리하여 선택처리*/
	console.log("item.seq : " + item.menuNo);
		
	/* 전부 펼치기(펼치지 않으면 데이터를 못받아옴) */
	treeview.expand(".k-item");
			
	var dataItem = treeview.dataSource.get(item.menuNo);
	var node = treeview.findByUid(dataItem.uid);
	treeview.select(node);
	
	/* 메뉴히스토리 남기기 */
	//menu.getLeftMenuHistory(item.menuNo);
	menu.topMenuInfo.url = item.urlPath;
	menu.topMenuInfo.urlGubun = item.urlGubun;
	
	/* 선택된 메뉴를 제외한 나머지 닫기 */
	var parentNode = treeview.dataItem(treeview.parent(node));
	if (parentNode != null) {
		menu.menuClose(parentNode);
	}
	
};


/** 선택된 메뉴를 제왼 나머지 소분류 메뉴 닫기 **/
menu.menuClose = function(node) {
	
	var treeview = $("#sub_nav").data("kendoTreeView");
	var view = treeview.dataSource.view();
	
	var nodes = menu.getTreeChildNodes(view);	
	
	for(var i = 0; i < nodes.length; i++) {
		var n = nodes[i];
		if (n.seq != node.seq) {
			treeview.collapse(treeview.findByText(n.name));
		}
	}
	
}


/** iframe forward url **/
menu.go = function(urlGubun, url) {
	
	if (urlGubun != 'mail') {
		   menu.getLeftMenuHistory(menu.callMenuInfo.menuNo);
	}
	   
    if (urlGubun != null && urlGubun != '' && urlGubun != 'mail') {
		var params = "";
		if(url != null && url != '') {
			var len = url.indexOf("?");
			if (len > -1) {
				params = "&menu_no="+menu.callMenuInfo.menuNo;
			} else {
				params = "?menu_no="+menu.callMenuInfo.menuNo;
			}
		}
		
		$("#_content").attr("src","/"+urlGubun + url +params);
	} else {
		$("#_content").attr("src", url);
	} 
	
};  


menu.contentReload = function() {
	$("#_content").attr("src",$("#_content").attr("src"));
};  
 

/** 
 * LNB 메뉴 트리구조로 가져와 kendo treeview에 붙이기
 * 
 * */
menu.setLeftMenu = function(no) {
	
	$("#sub_nav").html(""); 
	$.ajax({
		type:"post",
		url: _g_contextPath_ + "/cmm/system/getMenuTreeList.do",
		data:{startWith : no}, 
		datatype:"json",			 
		success:function(data){			
			//alert("getMenuTreeList : " + JSON.stringify(data));

			if (data.treeList) {
				
				/* 왼쪽 메뉴 리스트 셋팅 */
				var inline = new kendo.data.HierarchicalDataSource({
		                data: data.treeList,
		                schema: {
	                        model: {
	                        	id: "seq", 
	                            children: "items",
	                            hasChildren: function (node) {
	                            	return (node.items && node.items.length > 0);
	                            }
	                    } 
	                  }  
		        });
				  
				var treeview = $("#sub_nav").kendoTreeView({
			        dataSource: inline,
			        select: menu.onSelect,
			        dataTextField: ["name"],
			        dataValueField: ["seq", "url"]
			    }); 
				
				/** treeview click 처리 
				 * kendo treeview 자체에서 재클릭 이벤트를 처리 안해서
				 * 기본 이벤트 등록으로 처리
				 * */
				treeview.on("click", ".k-in", function(e) {
					
					// kendo treeview 클릭시 2중 select 되는 버그로 인해 시간차 추가
					setTimeout("menu.onclickLnb()", 100);
					//menu.onclickLnb();
					
				});
				
				//alert(JSON.stringify(menu.topMenuInfo));
				// GNB 클릭
				if (menu.isFirstMenu) {
					//alert("topMenuInfo : " + menu.topMenuInfo.url)
					/* 첫번째 url 찾아서 iframe으로 포워딩하기 */
					if (menu.topMenuInfo.url != null && menu.topMenuInfo.url != '') {
						//alert('a');
					} else {
						//alert('b');
						menu.getFirstMenuUrl();
					}
					
					if (menu.topMenuInfo.url != null && menu.topMenuInfo.url != '') {
						//alert('c');
						//menu.getMenuHistoryOfMenuNo(no, menu.setSideWrapClass);
						
						menu.go(menu.topMenuInfo.urlGubun, menu.topMenuInfo.url);
					} else {
						//alert(menu.topMenuInfo.url);
						$("#_content").attr("src", "/gw/cmm/cmmPage/CmmPageView.do?menuNm=" + menu.topMenuInfo.name);
						//alert('4');
						//alert("죄송합니다. 서비스 준비중입니다.");
					}
				} 
				
				// 페이지 forward
				else {
					 menu.menuSelect(menu.callMenuInfo); 
				}
				
			} else { 
				$("#_content").attr("src", "");
				//alert('5');
				//alert("죄송합니다. 서비스 준비중입니다.");
			}
		}   
	}); 
	
};


/** treeview에서 현재 위치한 메뉴 재클릭시 
 * 이벤트 실행이 안되어(페이지 리로드) 일반 이벤트 등록으로 처리
 *  
*/
menu.onclickLnb = function() {
	
	var tv = $("#sub_nav").data("kendoTreeView");
					
	var selectedNode = tv.select();
					
	var item = tv.dataItem(selectedNode);

	if (item != null && item != 'undifind') {
		var urlPath = item.urlPath;
		
		if (urlPath != null && urlPath != '') {
			var iframeUrl = $("#_content").attr("src");
			if (iframeUrl.indexOf(urlPath) > 0) {
				menu.contentReload();
			}
		}
	}
	
}


/** 왼쪽 메뉴명 이미지 설정 **/
menu.setSideWrapClass = function(data) {
	
	var jsonArr = data[0];
	if (jsonArr[0] != null) {
		var className = jsonArr[0].menuImgClass;
 		$(".side_wrap").attr("class", "side_wrap " + className + " k-pane k-scrollable");
	}
	
}


/** 탑메뉴 선택시에는 왼쪽 메뉴중 url 유효한 첫번째 node를 선택처리 및 URL 정보를 return **/
menu.getFirstMenuUrl = function() {
	//alert('d');
	var treeview = $("#sub_nav").data("kendoTreeView");
	
	//alert("treeview : " + JSON.stringify(treeview));
	
	/*
	if(treeview == null){
		return;
	}
	if(treeview.dataSource == null){
		return;
	}*/
	if(treeview.dataSource.view() == null){
		return;
	}
	
	var view = treeview.dataSource.view();
	
	var nodes = menu.getTreeChildNodes(view);
	
	//alert("node : " + JSON.stringify(nodes));
	
	if (nodes != null && nodes.length > 0) {
		var node = nodes[0]; 
		if (node != null) {
			
			 /*  상위메뉴 펼치기 */ 
			 if(node.name != null && node.name != '' && node.depth<2) {
				 //alert('여기로 오겠지?');
				 //alert(node.name);
				 // 팩스 예외처리
				 //alert(JSON.stringify(node.items));
//				 if(node.name == "웹팩스" && JSON.stringify(node.items) == "[]" ) {
//					 alert("팩스 설정을 확인해주세요");
//				 }
				 treeview.expand(treeview.findByText(node.name));
			 } 
			 
			 if (node != null) {
				 if (node.hasChildren) {
					 node = node.items[0];
				 }
				 
				 var url = node.urlPath;
				 console.log("url : " + url);
				 if (url != null && url != '') {
			 	  
					 /* treeview에서 select 처리하여 선택처리*/
					 console.log("node.seq : " + node.seq);
					 
					 var dataItem = treeview.dataSource.get(node.seq);
					 treeview.select(treeview.findByUid(dataItem.uid));
					/* 메뉴히스토리 남기기 */
					menu.getLeftMenuHistory(node.seq);
					menu.topMenuInfo.url = url;
					menu.topMenuInfo.urlGubun = node.urlGubun;
						 
				} 
			} 
		}
	}
	
};


/** 사용자 이미지 업로드 **/
menu.userImgUpload = function(data, className) {
	
	$.ajax({ 
        type: "POST",
        url: "cmm/file/fileUploadProc.do",  
        //enctype: 'multipart/form-data', 
        processData: false,
	    contentType: false,
        data: data, 
        success: function (e) {  
           var fileId = e.fileId;
		   if (fileId != null && fileId != '') {
			   var data = {picFileId : fileId};
			   menu.userImgUpdate(data);
			   $("."+className).attr("src", "cmm/file/fileDownloadProc.do?fileId="+fileId+"&fileSn=0");
			   
			   setTimeout('menu.reloadUserInfoIframe()',500);
			    
		   }  
        },  
        error:function (e) { 
        	console.log(e); 
        }
	});
	
};


/** 사용자 이미지 변경시 iframe 페이지는 리로드 **/
menu.reloadUserInfoIframe = function() {
	
	 $("#iframeUserInfo").attr("src",$("#iframeUserInfo").attr("src"));
	 
};


/** 겸직 변경하기 */
menu.changePosition = function(seq) {
	
	$.ajax({ 
        type: "POST", 
        url: "systemx/changeUserPositionProc.do", 
        data: {seq : seq}, 
        success: function (e) {  
         if (e.result == 1) {
        	 location.href = 'userMain.do';
         } 
        },  
        error:function (e) {   
        	console.log(e); 
        } 
	});
	
};
 

/** 사용자 이미지 DB 업데이트 **/ 
menu.userImgUpdate = function(data) {
	
	 $.ajax({ 
        type: "POST",
        url: "cmm/systemx/userPicUpdateProc.do", 
        data: data, 
        success: function (e) {  
          //console.log(e);
        },  
        error:function (e) { 
        	console.log(e);
        } 
    });
  
}; 


/** 나의메뉴설정 조회 **/
menu.myMenu = function() {
	
	 $.ajax({ 
        type: "POST",
        url: "myMenu.do", 
        success: function (e) {  
          console.log(e);
          
          $("#myMenu").html(e);
          
          
        },  
        error:function (e) { 
        	console.log(e);
        } 
    });
  
};


/** 하위 자식 노드 가져오기 **/
menu.getTreeChildNodes = function (nodes) {
	
	var node, childNodes;
    var _nodes = [];

    for (var i = 0; i < nodes.length; i++) {
		node = nodes[i];
		_nodes.push(node);
		
		if (node.hasChildren) {
			childNodes = menu.getTreeChildNodes(node.items);
			
			if (childNodes.length > 0){
				_nodes = _nodes.concat(childNodes);
			} 
		} 
	}

    return _nodes;

};


/** 왼쪽 메뉴 히스토리  **/
menu.getLeftMenuHistory = function(no) {

	var treeview = $("#sub_nav").data("kendoTreeView");
	var datasource = treeview.dataSource;
	var dataItem = datasource.get(no);
	
	if (dataItem != null) {
		var node = treeview.findByUid(dataItem.uid);
		//console.log('dataItem.uid : ' + dataItem.uid);
		//var selectedNode = treeview.select(node);
		//menu.init();
		
		// 왼쪽 메뉴에서 선택한 노드는 먼저 push
		//treeview.select(node);
		var lastNode = treeview.dataItem(node);
		
		menu.leftMenuList = [];
		
		menu.leftMenuList.splice(0,0,{name:lastNode.name, url:lastNode.urlPath});
		
		
		// 현재 레벨이 1 이상인경우
		if (lastNode.depth > 1) {
		 
			while(true) { 
				
				// 히스토리 리스트 변수에 push
				node = treeview.dataItem(treeview.parent(node));
				
				// 임시 !!!  depth 일때 오류 방생 수정 필요함 
				try {
				
				var menuClass = node.menuClass;
				
				console.log("menuClass : " + menuClass);
				
				/*if (menuClass != null && menuClass != '' && menuClass != 'null') {
					$(".side_wrap").attr("class", "side_wrap " + menuClass);
				}*/
				
				menu.leftMenuList.push({name:node.name, url:node.urlPath});
				 
				// 부모 레벨이 2 이상이면, 중분류이므로 종료
				if (node.depth == null || node.depth == '' || node.depth < 2) {
					break;
				}
				} catch(exception) {
					break;
				} finally {
					break;
				}
			} 
		}  
	} 
	
};


/** 왼쪽 메뉴 선택 **/
menu.onSelect = function(e) {
	
	var treeview = $("#sub_nav").data("kendoTreeView");//트리데이터 가져오기
	//선택활성
	treeview.expand(e.node);
	
	var item = e.sender.dataItem(e.node);
	var url = item.urlPath;
	var urlGubun = item.urlGubun;
	var seq = item.seq;
	
	//alert("menu.onSelect : " + JSON.stringify(item));
	

	
	menu.callMenuInfo = {menuNo:seq, urlGugun:urlGubun, urlPath:url};
// 원본	
//	if (url != null && url != '') {
//		/* iframe에 출력 */
//		menu.go(urlGubun, url); 
//	} else {
//		if (item.depth > 1) {
//			$("#_content").attr("src", "");
//			alert('6');
//			//alert("죄송합니다. 서비스 준비중입니다.");
//		}
//	}

	// 수정본
	if (url != null && url != '') {
		/* iframe에 출력 */
		// 보안관리 솔루션 예외처리
		if(seq == "993010000") {
			window.open(url, '보안관리솔루션');
			menu.go("gw", "/cmm/cmmPage/CmmPageView.do?menuNm=" + menu.topMenuInfo.name);
		} else {
			menu.go(urlGubun, url);
		}
		 
	} else {
		if (item.depth > 1) {
			//alert('6');
			if(pageFlag){
				$("#_content").attr("src", "/gw/cmm/cmmPage/CmmPageView.do?menuNm=" + menu.topMenuInfo.name);
				pageFlag = false;
			} else {
				return;
			}
			
			
			//alert("죄송합니다. 서비스 준비중입니다.");
		}
	}	
	
	$(".k-in").removeClass('k-state-selected');
	
};


/** 알림 팝업(div) 숨기기 **/
menu.hideGbnPopup = function(popType) {
	
	var profile_box = $(".profile_box").css("display");
	if (profile_box == 'block' && popType != 1) {
		$(".profile_box").css("display", "none");
	}
	
	var alert_box = $(".alert_box").css("display");
	if (alert_box == 'block' && popType != 2) {
		$(".alert_box").css("display", "none");
	}
	
	var mymenu_box = $(".mymenu_box").css("display");
	if (mymenu_box == 'block' && popType != 3) {
		$(".mymenu_box").css("display", "none");
	}
	
};
