

function excel01(){

	debugger
	var data = {
			chKey1 : $('#chKey1').val(), //심사일정
	  		chKey2 : $('#chKey2').val(),
	}
	var sirData = {};
	var specKey = $('#specKey input');
	
	
	$.each(specKey, function(i, v){
		var id = $(v).val();
		sirData[id] = $(v).val();
		data.specKey = JSON.stringify(sirData);
	})
	
	$.ajax({
			url : "/kpc/planList/excel01",
			data : data,
			type : 'POST',
			success : function(result) {
				var specCd = new Array();
				specCd = result;
				excelDownKey01(specCd);
				
					
				
			}
		})
		
}

function excel02(){

	debugger
	var data = {
			chKey1 : $('#chKey1').val(), //심사일정
	  		chKey2 : $('#chKey2').val(),
	}
	var sirData = {};
	var specKey = $('#specKey input');
	
	
	$.each(specKey, function(i, v){
		var id = $(v).val();
		sirData[id] = $(v).val();
		data.specKey = JSON.stringify(sirData);
	})
	
	$.ajax({
			url : "/kpc/planList/excel02",
			data : data,
			type : 'POST',
			success : function(result) {
				var specCd = new Array();
				specCd = result;
				excelDownKey02(specCd);
				
					
				
			}
		})
		
}

function excel03(){

	debugger
	var data = {
			chKey1 : $('#chKey1').val(), //심사일정
	  		chKey2 : $('#chKey2').val(),
	}
	var sirData = {};
	var specKey = $('#specKey input');
	
	
	$.each(specKey, function(i, v){
		var id = $(v).val();
		sirData[id] = $(v).val();
		data.specKey = JSON.stringify(sirData);
	})
	
	$.ajax({
			url : "/kpc/planList/excel03",
			data : data,
			type : 'POST',
			success : function(result) {
				var specCd = new Array();
				specCd = result;
				excelDownKey03(specCd);
				
					
				
			}
		})
		
}

function excel04(){

	debugger
	var data = {
			chKey1 : $('#chKey1').val(), //심사일정
	  		chKey2 : $('#chKey2').val(),
	}
	var sirData = {};
	var specKey = $('#specKey input');
	
	
	$.each(specKey, function(i, v){
		var id = $(v).val();
		sirData[id] = $(v).val();
		data.specKey = JSON.stringify(sirData);
	})
	
	$.ajax({
			url : "/kpc/planList/excel04",
			data : data,
			type : 'POST',
			success : function(result) {
				var specCd = new Array();
				specCd = result;
				excelDownKey04(specCd);
				
					
				
			}
		})
		
}
function excelDownKey01(e){
	var chKey1 = $('#chKey1').val();
	var chKey2 = $('#chKey2').val();
	var specCd = new Array();
	var fileNm;
	specCd = e;
	for (var i = 0; i < specCd.length; i++) {
		console.log(specCd[i]);
		fileNm=(specCd[i]);
		var specKey = specCd[i];
		var dataSource = shield.DataSource.create({
	    	 remote: {
	    	        read: {
	    	            url: "/kpc/planList/excelType01",
	    	            dataType: "json",
	    	            async: false,
	    	            data: function(){
	    	            	
	    	            	return {
	    	            		chKey1 : $('#chKey1').val(),
	    	            		chKey2 : $('#chKey2').val(),
	    	            		specKey : specKey
	    	    			};
	    	            },
	    	        cache: true
	      		  }
	    	 }
	    });
		
	    dataSource.read().then(function (data) {
	        new shield.exp.OOXMLWorkbook({
	            author: "system",
	            worksheets: [
	                {
	                    name: "심사비 현황",
	                    columns: [
	                    	{ width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 550 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 550 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 }
	                            ],
	                    rows: [
	                        {
	                            cells: [
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "일련번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증일자"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증유효만료일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증기업명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "사업자등록번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "대표자명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "종업원코드"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "메인사업장여부"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "사업장명"
	                                },{
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "지역코드"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "우편번호"
	                                },
	                               
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "주소"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "전화"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "팩스"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증범위"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "산업분류코드1"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "산업분류코드2"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "산업분류코드3"
	                                },{
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사시작일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사종료일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원1"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원2"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원3"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원4"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사시작일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사종료일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원1"
	                                },{
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원2"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원3"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원4"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서시작MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서종료MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장시작MD"
	                                }, {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장종료MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "환경인증번호"
	                                }
	                                
	                            ]
	                        }
	                    ].concat($.map(data.rows, function(item) {

	                    	
	                    	
	                    	return {
	                            cells: [
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.seq
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_end_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.cmpy_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.cmpy_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.rprsnt_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.empr_cd
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.main_yn
	                                },
	                                { 	
	                                	style: { 
	                            		textAlign: "center" 
	                                	},
	                                     value: item.prt_nm
	                                },{ 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.ara_cd
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.pst_cd
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.ara_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.tel_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.fax_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_rng
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.kab_cd_1
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.kab_cd_2
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.kab_cd_3
	                                },
	                                { 	
	                                	style: { 
	                            		textAlign: "center" 
	                                	},
	                                     value: item.dc_start_dt
	                                },{ 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_end_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_1
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_2
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_3
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_4
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_start_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_end_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_1
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_2
	                                },
	                                { 	
	                                	style: { 
	                            		textAlign: "center" 
	                                	},
	                                     value: item.st_crt_prsn_nm_3
	                                },{ 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_4
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_start_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_end_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_start_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_end_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.gms_cd
	                                }
	                            ]
	                        };
	                    }))
	                }
	            ]
	        }).saveAs({
	            fileName:  '최초_'+specCd[i]
	        });
	    });
	}
}

function excelDownKey02(e){
	var chKey1 = $('#chKey1').val();
	var chKey2 = $('#chKey2').val();
	var specCd = new Array();
	var fileNm;
	specCd = e;
	for (var i = 0; i < specCd.length; i++) {
		console.log(specCd[i]);
		fileNm=(specCd[i]);
		var specKey = specCd[i];
		var dataSource = shield.DataSource.create({
	    	 remote: {
	    	        read: {
	    	            url: "/kpc/planList/excelType02",
	    	            dataType: "json",
	    	            async: false,
	    	            data: function(){
	    	            	
	    	            	return {
	    	            		chKey1 : $('#chKey1').val(),
	    	            		chKey2 : $('#chKey2').val(),
	    	            		specKey : specKey
	    	    			};
	    	            },
	    	        cache: true
	      		  }
	    	 }
	    });
		
	    dataSource.read().then(function (data) {
	        new shield.exp.OOXMLWorkbook({
	            author: "system",
	            worksheets: [
	                {
	                    name: "심사비 현황",
	                    columns: [
	                    	{ width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 }
	                          
	                            ],
	                    rows: [
	                        {
	                            cells: [
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "일련번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증기업명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "사업장명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사시작일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사종료일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "심사원1"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "심사원2"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "심사원3"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "심사원4"
	                                },{
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장시작MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장종료MD"
	                                }
	                                
	                            ]
	                        }
	                    ].concat($.map(data.rows, function(item) {

	                    	
	                    	
	                    	return {
	                            cells: [
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.seq
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.cmpy_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.prt_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.start_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.end_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_prsn_nm_1
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_prsn_nm_2
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_prsn_nm_3
	                                },
	                                { 	
	                                	style: { 
	                            		textAlign: "center" 
	                                	},
	                                     value: item.crt_prsn_nm_4
	                                },{ 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.start_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.end_md
	                                }
	                            ]
	                        };
	                    }))
	                }
	            ]
	        }).saveAs({
	            fileName:  '사후_'+specCd[i]
	        });
	    });
	}
}

function excelDownKey03(e){
	var chKey1 = $('#chKey1').val();
	var chKey2 = $('#chKey2').val();
	var specCd = new Array();
	var fileNm;
	specCd = e;
	for (var i = 0; i < specCd.length; i++) {
		console.log(specCd[i]);
		fileNm=(specCd[i]);
		var specKey = specCd[i];
		var dataSource = shield.DataSource.create({
	    	 remote: {
	    	        read: {
	    	            url: "/kpc/planList/excelType03",
	    	            dataType: "json",
	    	            async: false,
	    	            data: function(){
	    	            	
	    	            	return {
	    	            		chKey1 : $('#chKey1').val(),
	    	            		chKey2 : $('#chKey2').val(),
	    	            		specKey : specKey
	    	    			};
	    	            },
	    	        cache: true
	      		  }
	    	 }
	    });
		
	    dataSource.read().then(function (data) {
	        new shield.exp.OOXMLWorkbook({
	            author: "system",
	            worksheets: [
	                {
	                    name: "심사비 현황",
	                    columns: [
	                    	{ width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          
	                            ],
	                    rows: [
	                        {
	                            cells: [
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "일련번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증기업명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "사업장명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "갱신일자"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사시작일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사종료일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원1"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원2"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원3"
	                                },{
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서심사원4"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사시작일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사종료일"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원1"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원2"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원3"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장심사원4"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서시작MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "문서종료MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장시작MD"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "현장종료MD"
	                                }
	                                
	                            ]
	                        }
	                    ].concat($.map(data.rows, function(item) {

	                    	
	                    	
	                    	return {
	                            cells: [
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.seq
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.cmpy_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.prt_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.update_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_start_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_end_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_1
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_2
	                                },
	                                { 	
	                                	style: { 
	                            		textAlign: "center" 
	                                	},
	                                     value: item.dc_crt_prsn_nm_3
	                                },{ 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_crt_prsn_nm_4
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_start_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_end_dt
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_1
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_2
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_3
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_crt_prsn_nm_4
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_start_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.dc_end_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_start_md
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.st_end_md
	                                }
	                            ]
	                        };
	                    }))
	                }
	            ]
	        }).saveAs({
	            fileName:  '갱신_'+specCd[i]
	        });
	    });
	}
}

function excelDownKey04(e){
	var chKey1 = $('#chKey1').val();
	var chKey2 = $('#chKey2').val();
	var specCd = new Array();
	var fileNm;
	specCd = e;
	for (var i = 0; i < specCd.length; i++) {
		console.log(specCd[i]);
		fileNm=(specCd[i]);
		var specKey = specCd[i];
		var dataSource = shield.DataSource.create({
	    	 remote: {
	    	        read: {
	    	            url: "/kpc/planList/excelType04",
	    	            dataType: "json",
	    	            async: false,
	    	            data: function(){
	    	            	
	    	            	return {
	    	            		chKey1 : $('#chKey1').val(),
	    	            		chKey2 : $('#chKey2').val(),
	    	            		specKey : specKey
	    	    			};
	    	            },
	    	        cache: true
	      		  }
	    	 }
	    });
		
	    dataSource.read().then(function (data) {
	        new shield.exp.OOXMLWorkbook({
	            author: "system",
	            worksheets: [
	                {
	                    name: "심사비 현황",
	                    columns: [
	                    	{ width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 },
	                          { width: 140 }
	                         
	                          
	                            ],
	                    rows: [
	                        {
	                            cells: [
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "일련번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증번호"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "인증기업명"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "사유코드"
	                                },
	                                {
	                                    style: {
	                                        bold: true,
	                                        textAlign: "center",
	                                        background : "#80ffff"
	                                    },
	                                    value: "갱신일자"
	                                }
	                                
	                            ]
	                        }
	                    ].concat($.map(data.rows, function(item) {

	                    	
	                    	
	                    	return {
	                            cells: [
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.seq
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.crt_no
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.cmpy_nm
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.rsn_cd
	                                },
	                                { 
	                                	style: { 
	                                		textAlign: "center" 
	                                     },
	                                     value: item.cncl_dt
	                                }
	                            ]
	                        };
	                    }))
	                }
	            ]
	        }).saveAs({
	            fileName:  '취소_'+specCd[i]
	        });
	    });
	}
}