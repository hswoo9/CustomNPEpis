/**
 * 
 */
var objFn = {		//메소드 객체
		fnInit : function () {			//초기화
			$(".cls_string").css('width', '200px');
//			$("#txt_result").css('width', '500px');
//			$("#tbl_random_result").width('50%')
//			$("#tbl_random_result").kendoGrid({
//                width: 10,
//                sortable: true
//            });			
		} ,
		
		fnSelectRandom : function (){		//랜덤숫자 추출
			
		}, 
};
var objEvent = {		//이벤트 객체,			//				$(src).val($(src).val().replace(/[^0-9]/gi,"") ); 			//숫자만 입력가능 정규식
		keyPressOnlyNum : function (e){
			var e = e || window.event,
				src = e.target || e.srcElement;	;                          	//이벤트

			
			var keyID = (event.which) ? event.which : event.keyCode;
//			if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) )
			if( ( keyID >=48 && keyID <= 57 ))
			{
//				console.log(keyID + " = 숫자키");
				return true;
			}
			else
			{
//				console.log(keyID + " = 숫자키 아님");
				return false;
			}
			/* 48~57:일반 숫자키 코드, 96~105:숫자키패드 숫자키 코드 */
		},
		keyupSetRange : function (e){
			var e = e || window.event,
			src = e.target || e.srcElement;	;                          			//이벤트
//			var trNum = $(this).closest('tr').prevAll().length;
			$(src).parents('td').next().next().html($(this).val());			//추첨번호 구간 설정
		},
		
		clickBtnRun : function (){
//			var iStartRange = Number($('#txt_start_num').val()),
//				iEndRange = Number($('#txt_end_num').val()),
//				iGroupCnt = Number($('#txt_group_count').val()),
//				iSelectCnt =  Number($('#txt_select_count').val()), 
//				iSelectedNum = 0,
//				arrSelectedNumbers = [],
//				arrCandidateNumbers = [],
//				idx = 0,
//				strResultVal = '',
//				i = 0,
//				j = 0;
//			
//			$('#dv_chk_group_area').html('');
//			for( j = 0; j <  iGroupCnt; ++j)
//			{	
//					for ( i = iStartRange; i < (iEndRange + 1); ++i) arrCandidateNumbers.push(i)		//후보군 숫자	
//
//							while (arrSelectedNumbers.length < iSelectCnt){		
//								iSelectedNum = arrCandidateNumbers[idx];
//								idx = Math.floor(Math.random()*arrCandidateNumbers.length);
//							    arrSelectedNumbers.push(arrCandidateNumbers[idx]);
//							    arrCandidateNumbers.splice(idx,1);							    
//							}
//					
//							strResultVal = $('#txt_result_area').val() + arrSelectedNumbers.sort(sortNumber) + '\n';
//							$('#dv_chk_group_area').append('<input type="checkbox" id="chk_group_' + j +' value="">&nbsp<input type="text" value="' + arrSelectedNumbers.sort(sortNumber)  + '" class="txt_result" ></br>');		
//							
//							arrSelectedNumbers = [];
//							arrCandidateNumbers = [];
//							k++;
//			}	
//			
//			$('.txt_result').width('200px');
//			
////			console.log(iStartRange, iEndRange, iGroupCnt, iSelectCnt, arrSelectedNumbers.length, arrCandidateNumbers.length, iEndRange + 1);			
//			function sortNumber(a, b) {
//			  return a - b;
//			}
			
			var strHtml = ''
				, iSampleGroup = 10			//표본그룹
				, iSelectCnt = 0				//위원수
				, iRandomStartNum = 0		//난수발생 범위 시작숫자				
				, iReserveCnt = 0				//인력풀인원수(난수발생 종료숫자)
				, iReserveSelectDbl = 0		//선정배수
				, arrCandidateNumbers = []		//후보군(인력풀인원수) 배열				
				, arrSelectedNumbers = []			//추첨번호 배열
			    , strItemGroup = ''
			    , strItemName = ''
			    , colEvalPart = 0
			    , colEvalName = 1
			    , colEvalPrsnNum = 2
			    , colEvalPool = 3
				, i = 0
				, j = 0;

			for( i = 1; i <  6; ++i)
			{
				iReserveCnt = 0;
				
				strItemGroup = $('#tbl_random_result tr:eq('+ i +')').children().eq(colEvalPart).text();
				strItemName = $('#tbl_random_result tr:eq('+ i +')').children().eq(colEvalName).children().val();
				iSelectCnt = $('#tbl_random_result tr:eq('+ i +')').children().eq(colEvalPrsnNum).children().val();
				iReserveCnt = $('#tbl_random_result tr:eq('+ i +')').children().eq(colEvalPool).children().val();
				
				console.log(strItemGroup, strItemName, iSelectCnt, iReserveCnt);
				
//				//난수발생
//				for( j = 0; j <  iSampleGroup; ++j)
//				{	
//						for ( i = iRandomStartNum; i < iReserveCnt; ++i) arrCandidateNumbers.push(i)		//후보군 숫자	
//	
//								while (arrSelectedNumbers.length < iSelectCnt){		
//									iSelectedNum = arrCandidateNumbers[idx];
//									idx = Math.floor(Math.random()*arrCandidateNumbers.length);
//								    arrSelectedNumbers.push(arrCandidateNumbers[idx]);
//								    arrCandidateNumbers.splice(idx,1);							    
//								}
//						
//								strResultVal = $('#txt_result_area').val() + arrSelectedNumbers.sort(sortNumber) + '\n';
//								$('#dv_chk_group_area').append('<input type="checkbox" id="chk_group_' + j +' value="">&nbsp<input type="text" value="' + arrSelectedNumbers.sort(sortNumber)  + '" class="txt_result" ></br>');		
//								
//								arrSelectedNumbers = [];
//								arrCandidateNumbers = [];
//								k++;
//				}	
//				
//				for( i = 0; j <  iGroupCnt; ++j)
//				{							
//					strHtml += strHtml + '<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>'				
//				};				
			}
						
//			$('#tbody_random_result').html(strHtml);
		},
		
};

$(document).ready(function(){
	objFn.fnInit();				//초기화 셋팅
	
	$('.cls_number').bind('keypress', objEvent.keyPressOnlyNum);					//숫자만 입력
	$('.cls_number').bind('keyup', objEvent.keyupSetRange);							//추첨번호 구간 설정	
	$('#btn_run').bind('click', objEvent.clickBtnRun);									//실행버튼 클릭		
	
    });
