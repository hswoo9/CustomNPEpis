/**
 *
 * @title Neos Javascript Util
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 4. 28.
 * @version
 * @dscription Javascript를 쓰면서 유용하다고 생각되는 유틸을 작성
 * 			   jQuery가 기본적으로 선행 포함 되어야 한다.
 *
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용
 * -----------  -------  --------------------------------
 * 2012. 4. 25.  박기환        최초 생성
 *
 */

/**
 * 원하는 id의 tag 안의 input tag와 select의 값을 가져온다.
 * 파라미터의 갯수에 따라 값을 다르게 가져옴
 * 2개 --> select, textarea 의 값들을 가져올때 쓰인다
 * 3개 --> input 의 값들을 가져올때 쓰인다
 * 최초 값을 가져올때 쓰인다.
 *
 * @param id 			원하는 tag의 id
 * @param tag_type 		원하는 tag 종류
 * @param input_type	input tag의 type 종류
 * @return data			map형의 객체로 받아서 return
 *
 */

var _g_contextPath_ ;
var _g_aproval_width_ = 1000;
var _g_aproval_heigth_ = 700;
var NeosUtil = {};
function get_input_data(id, tag_type, input_type){

	var data = {};
	var input_data;

	if(arguments.length==2){

		input_data = $("#"+id+" "+tag_type);

	}else if(arguments.length==3){

		input_data = $("#"+id+" "+tag_type+"[type="+input_type+"]");

	}

	input_data.each(function(){
		data[$(this).attr("id")] = $(this).val();
	});

	return data;
}

/**
 * 원하는 id의 tag 안의 input tag와 select의 값을 가져온다.
 * 기존의 가져온 값이 있고 그 값을 합치고 싶을때 쓰인다.
 * select, textarea 의 값들을 가져올때 쓰인다
 *
 * @param id 			원하는 tag의 id
 * @param tag_type 		원하는 tag 종류
 * @param data			기존과 합치고 싶은 객체
 * @return data			map형의 객체로 받아서 return
 *
 */
function update_input_data(id, tag_type, data){
	var input_data;

	input_data = $("#"+id+" "+tag_type);

	input_data.each(function(){
		data[$(this).attr("id")] = $(this).val();
	});

	return data;
}

/**
 * 원하는 id의 tag 안의 input tag와 select의 값을 가져온다.
 * 기존의 가져온 값이 있고 그 값을 합치고 싶을때 쓰인다.
 * input 의 값들을 가져올때 쓰인다
 *
 * @param id 			원하는 tag의 id
 * @param tag_type 		원하는 tag 종류
 * @param data			기존과 합치고 싶은 객체
 * @return data			map형의 객체로 받아서 return
 *
 */
function update_input_data2(id, tag_type, input_type, data){


	var input_data;
	// input 태그에 type이 radio인 값 가져오는거 추가
	if(tag_type=="input" && input_type=="radio"){

		input_data = $("#"+id+" :radio");
		input_data.each(function(){
			data[$(this).attr("name")] = $(":radio[name="+$(this).attr("name")+"][checked=checked]").val();
		});

	}else{
		input_data = $("#"+id+" "+tag_type+"[type="+input_type+"]");

		input_data.each(function(){
			data[$(this).attr("id")] = $(this).val();
		});
	}

	return data;
}

function getLeftMenuWidth(){
	return 215;
}

//*----- 문자열 관련 함수 -----*//
/**
 *이름 : ncCom_Date()
 *설명 : 날짜를 린턴한다
 *인자 : 날짜형태 '/','-', '.'
 *리턴 : 날짜형태
*/
function ncCom_Date(argDate, argFlag){
	if(typeof(argDate) == "undefined") return "" ;
	if( ncCom_Empty(argDate) || ( argDate.length != 8 && argDate.length != 10 ) ) return "" ;
	
	if(typeof(argFlag) == "undefined") argFlag = ".";

	if( argDate.length == 10 ) {
		argDate = ncCom_Replace(argDate, '.', '');
		argDate = ncCom_Replace(argDate, '-', '');
		argDate = ncCom_Replace(argDate, '/', '');
	}
	argFlag = argFlag.toUpperCase() ;


	var day ="";

	var y =  (argDate.length>=4)? argDate.substr(0,4):"    ";
	var sy = (argDate.length>=4) ? argDate.substr(2,2): "  ";
	var m =(argDate.length>=6)? argDate.substr(4,2):"  ";
	var d = (argDate.length>=8)? argDate.substr(6,2):"  ";

	switch (argFlag) {
		case "Y" : day = y;  break;
		case "M" : day = m;  break;
		case "D" : day = d;  break;
		case "YM" : day=y + "." + m ; break;
		case "SYMD": day = sy + "." + m + "." + d; break ;
		default  : day = y + argFlag + m + argFlag + d;
	}
	return day;
}


function ncCom_Time(argTime, argFlag){
	if(typeof(argTime) == "undefined") return "" ;
	if( ncCom_Empty(argTime) || ( argTime.length != 4 && argTime.length != 5 && argTime.length != 6 && argTime.length != 8) ) return "" ;
	
	if(typeof(argFlag) == "undefined") argFlag = ":";

	if( argTime.length == 5 ) {
		argTime = ncCom_Replace(argDate, ':', '');
	}

	if( argTime.length == 2 ) {
		argFlag = "H";
	}
	
	if( argTime.length == 4 ) {
		argFlag = "HM";
	}

	argFlag = argFlag.toUpperCase() ;

	var stime ="";

	var h =  (argTime.length>=4)? argTime.substr(0,2):"  ";
	var m = (argTime.length>=4) ? argTime.substr(2,2): "  ";
	var s =(argTime.length>=6)? argTime.substr(4,2):"  ";

	switch (argFlag) {
		case "H" : stime = h;  break;
		case "M" : stime = m;  break;
		case "S" : stime = s;  break;
		case "HM" : stime = h + ":" + m ; break;
		case "HMS": stime = h + ":" + m + ":" + s; break ;
		default  : stime = h + argFlag + m + argFlag + s;
	}
	return stime;
}

/**
  *이름 : ncCom_Today()
  *설명 : 현재날짜를 린턴한다
  *인자 : 날짜형태 '/','-'
  *리턴 : 날짜형태
 */
function ncCom_Today(argFlag){
	if(typeof(argFlag) == "undefined") argFlag = "/";

	argFlag = argFlag.toUpperCase();

	//---- 호스트 날짜로 변경

	var day ="";
	var today= gv.sdate; // 스크립트로 생성

	var y = (today.length>=4)? today.substr(0,4):"    ";
	var m =(today.length>=6)? today.substr(4,2):"  ";
	var d = (today.length>=8)? today.substr(6,2):"  ";

	switch (argFlag) {
		case "Y" : day = y;  break;
		case "M" : day = m;  break;
		case "D" : day = d;  break;
		case "YM" : day=y + "." + m ; break;
		default  : day = y + argFlag + m + argFlag + d;
	}
	return day;
}

/**
  *이름 : ncCom_Empty()
  *설명 : 공백여부체크한다
  *인자 : 체크할 문자
  *리턴 : true ,false
 */
function ncCom_Empty(argStr){
	if (!argStr) return true;
	if (argStr.length == 0) return true;
	if(typeof(argStr) == "undefined")  return true ;
	if(argStr == "undefined")  return true ;	
	if(argStr == "null") return true ;
	
	for (var i = 0; i<argStr.length; i++) {
 		if ( (" " == argStr.charAt(i)) || ("　" == argStr.charAt(i)) )  {	}
		else return false;
	}
	return true;
}
/**
 *이름 : ncCom_EmptyToString()
 *설명 : 공백을 특정문자로 변경한다.
 *인자 : argStr : 체크할 문자,  conString: 변경할 문자
 *리턴 : 변경 문자
*/
function ncCom_EmptyToString(argStr,conString){
	if ( conString == undefined )  conString = "" ;
	if(ncCom_Empty(argStr+"") || argStr == "null" || argStr == null ) {

	}else{
		conString = argStr ;
	}
	return conString ;
}
/**
  *이름 : ncCom_DelBlank()
  *설명 : 공백을 제거한다
  *인자 : 제거할문자
  *리턴 : 문자열
 */
function ncCom_DelBlank(argStr){
	var len = argStr.length;
	var retStr = "";
	argStr += "";
	for(var i=0; i<len; i++) {
		if((argStr.charAt(i)!=" ") && (argStr.charAt(i)!="　"))
			retStr += argStr.charAt(i);
	}
	return retStr;
}

function ncCom_EmptyReplace(argStr, argConvert) {
	if(ncCom_Empty(argStr)) return argConvert ;
	else return argStr ;
}

/**
  *이름 : ncCom_SubstrHan()
  *설명 : 한글문자열길이만큼 가져옴
  *인자 : argStr : 문자열
  *		  argPos : 시작위치
  *          argLen : 종료위치
  *리턴 : 문자열
  *ex) ncCom_SubstrHan('가나다라마바사',2,3) = '다라마'
 */
function ncCom_SubstrHan(argStr, argPos, argLen){
	var p1 = sub_HanLen(argStr, argPos);
	var p2 = sub_HanLen(argStr, (argPos + argLen));
	return (argStr.substr(p1, p2-p1));
}

/**
  *이름 : ncCom_Replace()
  *설명 : 한글문자열길이만큼 가져옴
  *인자 : originalString : 문자열
  *		  findText : 찾을 문자열
  *          replaceText : 바꿔야할 문자열
  *리턴 : 문자열
  *ex) ncCom_Replace('테스트다','스','타') = ' 테타트다'
 */
function ncCom_Replace(originalString, findText, replaceText){

	originalString = ncCom_Trim(originalString);

	var pos = 0 ;

	pos = originalString.indexOf(findText);
	while (pos != -1) {
		preString = originalString.substr(0,pos);
		postString = originalString.substring(pos+findText.length);
		originalString = preString + replaceText + postString;
		pos = originalString.indexOf(findText);
	}

	return originalString;
}

/**
  *이름 : ncCom_Trim()
  *설명 : 문자열 공백제거
  *인자 : 문자열
  *리턴 : 문자열
  *ex) ncCom_Trim(' 테스트다 ') = '테스트다'
 */
function ncCom_Trim(argStr) {
	if(argStr == null)
		return "";

	argStr = argStr.toString();

	var pos1, pos2 ;
	for(pos1=0; (argStr.charAt(pos1) == ' ' || argStr.charAt(pos1) == '　') && pos1 < argStr.length ; pos1++) ;
		for(pos2=argStr.length-1; (argStr.charAt(pos2) == ' ' || argStr.charAt(pos2) == '　') && pos2 >= 0 ; pos2--) ;
			if(pos1 > pos2) return "" ;
	return argStr.substr(0,pos2+1).substring(pos1) ;
}

function fncConvertRegDate(dtRegDate){
 	var nd = new Date();

 	var regYear	= dtRegDate.substring(0,4);
 	var regMonth= dtRegDate.substring(5,7);
 	var regDate	= dtRegDate.substring(8,10);
 	var regTime	= dtRegDate.substring(11,16);

 	var nowYear	= nd.getFullYear();
 	var nowMonth= nd.getMonth()+1;
 	if(nowMonth<10){
 		nowMonth = "0" + nowMonth;
 	}
 	var nowDate	= nd.getDate();
 	if(nowDate<10){
 		nowDate = "0" + nowDate;
 	}

 	if(regYear == nowYear ){
    	if(regMonth+"/"+regDate == nowMonth+"/"+nowDate){
 			strRegDate = regTime;
 		}else{
 			strRegDate = regMonth+"/"+regDate;
 		}
     }else{
     	if(regMonth+"/"+regDate == nowMonth+"/"+nowDate){
 			strRegDate = regTime;
 		}else{
 			strRegDate = regMonth+"/"+regDate;
 		}
     }


 	return strRegDate;
 }

	//*----- 입력 필드 관련 함수 -----*//
/**
  *이름 : ncCom_ErrField()
  *설명 :  입력필드 입력여부확인
  *인자 :
			argObj : 입력필드명
			argTitle : 공백일경우 메세지
  *리턴 : true, false
  *ex) ncCom_ErrField(입력필드명)
 */

function ncCom_ErrField(argObj, argTitle){
	if (argTitle==null) argTitle = argObj.title;
	alert(argTitle);
	ncCom_ColorField(argObj);
	return false;
}

/**
  *이름 : ncCom_CheckDate()
  *설명 :  From ~ To 체크  , 시작날짜가 종료날짜보다 크면 false 를 리턴
  *인자 :
			argFrom : 시작날짜
			argTitle : 종료날짜
			argSign : 날짜 형태 ('-','.'...)
  *리턴 : true, false
  *ex) ncCom_CheckDate('2002-02-01','2003-03-01','-')
 */
function ncCom_CheckDate(argFrom,argTo,argSign){
	var intFrom = parseInt(ncCom_Replace(argFrom,argSign,""));
	var intTo = parseInt(ncCom_Replace(argTo,argSign,""));
	if((intFrom-intTo)>0) {
		return(false);
	}
	return(true);
}

/**
  *이름 : ncCom_DiffDate()
  *설명 : 날짜 차이를 일로계산 한다
  *인자 :
			fromDate : 시작날짜
			toDate : 종료날짜

  *리턴 : 날짜차이일
  *ex) ncCom_DiffDate('2002-02-01','2003-03-01')
 */
function ncCom_DiffDate(fromDate, toDate) {
	var MinMilli = 1000 * 60;
	var HrMilli = MinMilli * 60;
	var DyMilli = HrMilli * 24;

	var d1 = new Date(ncCom_Replace(fromDate, ".", "/"));
	var d2 = new Date(ncCom_Replace(toDate, ".", "/"));

	var d3 = d2-d1;
	var str = d3 /DyMilli ;

	return str;
}
/**
  *이름 : ncCom_DiffMonthDate()
  *설명 : 월 차이를  계산 한다
  *인자 :
			fromDate : 시작날짜
			toDate : 종료날짜

  *리턴 : 날짜개월수
  *ex) ncCom_DiffMonthDate('2002-02-01','2003-03-01')
 */
function ncCom_DiffMonthDate(fromDate, toDate) {
	var fromYear =  "";
	var toYear = "";
	var fromMonth = "";
	var toMonth = "";

	fromYear = parseInt( fromDate.substring(0,4) ) ;
	toYear = parseInt(toDate.substring(0,4) ) ;
	fromMonth =  fromDate.substring(5,7);
	toMonth  = toDate.substring(5,7);


	if (fromMonth.length == 2) {
		if(fromMonth.substring(0,1) == '0')  fromMonth = parseInt(fromMonth.substring(1,2));
		else fromMonth = parseInt(fromMonth);
	}else {
		fromMonth = parseInt(fromMonth);
	}
	if (toMonth.length == 2) {
		if(toMonth.substring(0,1) == '0')  toMonth = parseInt(toMonth.substring(1,2));
		else toMonth = parseInt(toMonth);
	}else {
		toMonth = parseInt(toMonth);
	}

	return ( (toYear - fromYear) * 12 ) + (  toMonth - fromMonth) ;
}
function ncCom_ColorField(argField) {

//	if (argField.tagName == "SELECT" ) {
//		argField.style.backgroundColor = '#DEFDD2'
//		argField.focus()
//		return;
//	}
//	argField.style.backgroundColor = '#DEFDD2'

	argField.select();
	argField.focus();
}

//*----- 날짜 계산 관련 함수 -----*//


/**
  *이름 : ncCom_CalcDate2()
  *설명 :  기준일자에서 특정 기간을 ±(하루,한달,일년
  *인자 :
			argDate : 기준날짜
			toDate : 특정기간

  *리턴 : 날짜차이일
  *ex) ncCom_CalcDate2('20030203','-d')  = 20030202
 */

function ncCom_CalcDate2(argDate, argFlag){
	var year	= argDate.substr(0,4);
	var month	= argDate.substr(4,2);
	var day		= argDate.substr(6,2);

	switch(argFlag) {
	case "-d" :
		day = parseInt(day,10)-1;
		if ( day == 0 ){
			month --;
			if ( month == 0 ){
				year --;
				month = 12;
			}
			day = ncCom_MaxDay(year, month);
		}
		break;
	case "+d" :
		day = parseInt(day,10)+1;
		if ( day > ncCom_MaxDay(year, month) ) {
			month ++;
			if ( month == 13 ){
				year ++;
				month=1;
			}
			day = 1;
		}
		break;
	case "-m" :
		month = parseInt(month,10)-1;
		if ( month == 0 ){
			year --;
			month = 12;
		}
		break;
	case "+m" :
		month = parseInt(month,10)+1;
		if ( month == 13 ){
			year ++;
			month=1;
		}
		break;
	case "-y" :
		year = parseInt(year)-1;
		month = parseInt(month,10);
		break;
	case "+y" :
		year = parseInt(year)+1;
		month = parseInt(month,10);
		break;
	}

	if ( (argFlag.substr(1,1) == 'm' ) || (argFlag.substr(1,1) == 'y' )) {
		tempmaxday = ncCom_MaxDay(year, month);
		if ( day > tempmaxday ) day = tempmaxday;
	}

	month = parseInt(month,10);
	if ( month < 10 ) month="0"+month;

	day = parseInt(day,10);
	if ( day < 10) day = "0" + day;

	return( year+""+month+""+day+"" );
}

function ncCom_MaxDay(argYear, argMonth){
	var cDate = new Array(29, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	var lastday = cDate[ argMonth-0 ];
	if( argMonth == 2 && ((argYear%4==0 && argYear%100!=0) || (argYear%400==0)) )
	lastday = cDate[0];

	return lastday;
}
 /**------------------------------------------------------------------------------------------
   년, 월, 일 유효성 체크 (윤년 체크 포함)
   입력항목 :
           - optionFlg : YMD가 필수 항목이면 1 ,
                                   선택항목: 0 이며, 모두 입력 또는 모두 공백
            -  year :  년을 표시하는 input 객체  (ex. MainForm.year)
            -  month: 월을 표시하는 input 객체
            -  day :    일을 표시하는 input 객체
    관련 함수
            - isNumber () :  숫자만 입력 받도록하는 함수
            - tabOrder()  :    정해진 숫자만큼 입력하면 자동으로 포커스 이동
--------------------------------------------------------------------------------------------*/
function checkYMD(optionFlg, year, month, day) {

     //----------------------------------------------------------
     // year, month, day 를 모두 입력했는지 조사
     // 년월일 이 필수 입력이 아니면 체크 불필요
     //----------------------------------------------------------
     if(optionFlg) {
        if(!year.value|| !month.value || !day.value) {
            alert(NeosUtil.getMessage("TX000009217","년월일은 필수 입력항목입니다"));
            year.focus();
            return false;
       }
     }else {

        //옵션사항인데 YMD가 하나도 입력되지 않으면 체크 하지않음
	    if( ncCom_Empty(year.value)  && ncCom_Empty(month.value) && ncCom_Empty(day.value) ) {
            return true;
        }else {
            if( ncCom_Empty(year.value) || ncCom_Empty(month.value) || ncCom_Empty(day.value) ) {
                alert(NeosUtil.getMessage("TX000011078","년월일이 모두 입력되거나 모두 생략되어야 합니다"));
                year.focus();
                return false;
            }
         }
     }

     //---------------------------------------------------------
     // year, month, day는 input 객체이다.
     //--------------------------------------------------------
     var total_days;            // 각 월별 총 일수  (30 | 31| 28| 29)
     var ckFlg=0;
    //--------------------------------------------------------------------
    // 숫자만 입력받도록 한다.  isNumber()를 사용하면
    //  생략해도 된다.
    //-------------------------------------------------------------------
     var  data1 = year.value;
     var data2 = month.value;
     var data3 = day.value;
     for ( var j=1; j< 4; j++ ) {
         var data = eval( "data"+j );
        for ( var i=0; i < data.length; i++)  {
            var ch = data.substring(i,i+1);
            if (ch<"0" | ch>"9") {
	    alert ( "\n"+NeosUtil.getMessage("TX000011077","일자를 바르게 입력하세요") );
	     year.focus();
	     year.select();
	     return false;
	 }
        }// end inner for
    } //end outter for


    //------------------------------------------------------------
    // 월 체크 ( 1 ~ 12)
    //-----------------------------------------------------------
     if( (1 > month.value) ||  (12 < month.value) ) {
	       ckFlg=1;
     }
     if(ckFlg) {
        alert ( "\n"+NeosUtil.getMessage("TX000011076","월을 바르게 입력하세요") );
         month.focus();
         month.select();
         return false;
      }

      //------------------------------------------------------------
      // 1. 각 달의 총 날수를 구한다.
      //----------------------------------------------------------
       if(month.value == 4||month.value == 6||month.value == 9||month.value == 11)  {
           total_days = 30;
        } else {
            total_days=31;
        }
       //--------------------------------------------------------
       // 1-1.윤년에 따른 2월 총 날수 구한다.
       //--------------------------------------------------------
       if(month.value ==2) {
            // 윤년조사
            if((year.value % 4 == 0) && (year.value % 100 != 0) || (year.value % 400 == 0)) {
                total_days = 29;
             } else{
    	    total_days = 28;
             }
         }

         //-------------------------------------------------------------------
         // 일자 체크 : 각년월별로 총 날수가 맞는지 조사
         //-------------------------------------------------------------------
         if( ( 1 > day.value ) || ( day.value > total_days ) ) {
            ckFlg=1;
          }
          if(ckFlg) {
            alert ( "\n"+NeosUtil.getMessage("TX000011077","일자를 바르게 입력하세요"));
            day.focus();
            day.select();
             return false;
            }

            //-----------------------------------------------------------
            // MM/DD 형식으로 입력해야 하지만,
            //  M 또는 D 형식으로 입력한 경우 앞에 0 추가
            //-------------------------------------------------------------
            if ( data2.length < 2 ) {
                 data2 = "0"+data2 ;
            }
            if ( data3.length < 2 ) {
                data3 = "0"+data3 ;
             }
            return true;

}

//-----------------------------------------------//
//*----- 관리자 사용 함수 (prefix : sub_ ) -----*//
//-----------------------------------------------//


//*--  한글의 길이 구하기 --*//
function sub_HanLen(argPos1, argPos2) {
	if(argPos2==0) return 0;
	var len=0;
	for(var i=0; i<argPos1.length; i++) {
		var str = "";
		str = escape(argPos1.charAt(i));
		if(str.length>3) len+=2;
		else len++;
	//	if(len==argPos2) break;
	}

	return (len);
}

/**
	파일 확장자 체크
	반드시 서버에서 다시확인해야함.
*/
function checkFileExt(obj,ext){
	var fileExt = obj.value.substr(obj.value.length-3,3);
	if(fileExt.toUpperCase() == ext.toUpperCase()) return true;
	else return false;
}

/**---------------------------------------------------------------------------
  주민번호 체크
  입력항목:
                 - preNoRes : 주민번호앞 6자리 필드
                 -postNoRes :주민번호뒤7자리필드
  ---------------------------------------------------------------------------*/
  function checkNoRes(arg){
    if (arg.length != 13){

        return false;
    } else {
        var str_serial1 = arg.substring(0,6);
        var str_serial2 = arg.substring(6,13);

        var digit=0;
        for (var i=0;i<str_serial1.length;i++){
            var str_dig=str_serial1.substring(i,i+1);
            if (str_dig<'0' || str_dig>'9'){
                digit=digit+1;
            }
        }

       if ((str_serial1 == '') || ( digit != 0 )){
            return false;
        }

        var digit1=0;
        for (var i=0;i<str_serial2.length;i++){
            var str_dig1=str_serial2.substring(i,i+1);
            if (str_dig1<'0' || str_dig1>'9'){
                digit1=digit1+1;
            }
        }

         if ((str_serial2 == '') || ( digit1 != 0 )){
            return false;
         }

         if (str_serial1.substring(2,3) > 1){
            return false;
         }

         if (str_serial1.substring(4,5) > 3){
            return false;
         }

         if (str_serial2.substring(0,1) > 4 || str_serial2.substring(0,1) == 0){
            return false;
         }

         var a1=str_serial1.substring(0,1);
         var a2=str_serial1.substring(1,2);
         var a3=str_serial1.substring(2,3);
          var a4=str_serial1.substring(3,4);
         var a5=str_serial1.substring(4,5);
          var a6=str_serial1.substring(5,6);

          var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7;

         var b1=str_serial2.substring(0,1);
         var b2=str_serial2.substring(1,2);
         var b3=str_serial2.substring(2,3);
         var b4=str_serial2.substring(3,4);
         var b5=str_serial2.substring(4,5);
         var b6=str_serial2.substring(5,6);
         var b7=str_serial2.substring(6,7);

         var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5;

         check_digit = check_digit%11;
         check_digit = 11 - check_digit;
         check_digit = check_digit%10;

         if (check_digit != b7){
            return false;
         } else{
            // alert('올바른 주민등록 번호입니다.');
            return true;
        }
    }
}
	//----------------------------------------------------------------------
	// 메일체크
	// 성공 true, 실패 false
	//----------------------------------------------------------------------
	function chkEmail(str) {
		var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
		var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");

		if ( r1.test(str) || !r2.test(str) ) {
			return false;
		}

		return true;
	}

	/**
	 * 체크박스 선택
	 * @param arg1 객체명
	 * @param arg2 선택여부
	 */
	function allCheckBox(arg1, arg2 ) {

		if (arg1 == undefined ) {
			return ;
		}
		var cnt = arg1.length ;
		if (cnt ==  undefined ) {
			arg1.checked =  arg2 ;
		} else {
			for ( var i = 0 ; i < cnt ; i++ ) {
				arg1[i].checked = arg2 ;
			}
		}
	}

	/**
	 * 체크박스 선택여부
	 * @param arg
	 * @returns {Boolean}
	 */
	function checkBoxSelected(arg) {
		if (arg == undefined ) {
			return false ;
		}
		var cnt = arg.length ;
		var result   = false ;
		if (cnt ==  undefined ) {
			if( arg.checked == true )  return  true;

		} else {
			for ( var i = 0 ; i < cnt ; i++ ) {
				if ( arg[i].checked == true ) return true ;
			}
		}

		return  false ;
	}

	/**
	 * 체크박스에 선택된 값
	 * @param arg
	 * @returns
	 */
	function optionBoxSelectedValue(arg) {
		if (arg == undefined ) {
			return "";
		}
		var cnt = arg.length ;
		var result  =  "" ;

		if (cnt ==  undefined ) {
			if( arg.checked == true )  return arg.value ;

		} else {
			for ( var i = 0 ; i < cnt ; i++ ) {

				if ( arg[i].checked == true )  return arg[i].value ;
			}
		}
		return "" ;
	}
	/**
	 * 체크박스에 선택된 갯수
	 * @param arg
	 * @returns {Number}
	 */
	function checkBoxSelectedCount(arg) {
		if (arg == undefined ) {
			return  0 ;
		}
		var len = arg.length ;

		var cnt = 0 ;
		if (len ==  undefined ) {
			if( arg.checked == true )   cnt  = cnt + 1 ;

		} else {
			for ( var i = 0 ; i < len ; i++ ) {
				if ( arg[i].checked == true ) {
					cnt = cnt + 1 ;
				}
			}
		}
		return cnt ;
	}

	/**
	 * 체크박스에 선택된 인덱스를 배열로 반환
	 * @param arg
	 * @returns
	 */
	function checkBoxSelectedIndex( arg ) {
		if (arg == undefined ) {
			return null  ;
		}
		cnt = checkBoxSelectedCount(arg) ;
		var arrIndex = new Array(cnt);
		var len = arg.length ;
		var index  = 0 ;
		if (len ==  undefined ) {
			if( arg.checked == true )  arrIndex[0] =  0 ;
		} else {
			for ( var i = 0 ; i < len ; i++ ) {
				if ( arg[i].checked == true )  {
					arrIndex[index] = i ;
					index = index + 1 ;
				}
			}
		}
		return arrIndex ;
	}

	/**
	 * 체크 박스에서 선택된 값을 배열로 반환
	 * @param arg
	 * @returns
	 */
	function checkBoxSelectedValue( arg ) {
		if (arg == undefined ) {
			return null  ;
		}
		cnt = checkBoxSelectedCount(arg) ;
		var arrValue = new Array(cnt);
		var len = arg.length ;
		var index  = 0 ;
		if (len ==  undefined ) {
			if( arg.checked == true )  arrValue[0] =  arg.value ;
		} else {
			for ( var i = 0 ; i < len ; i++ ) {
				if ( arg[i].checked == true )  {
					arrValue[index] = arg[i].value ;
					index = index + 1 ;
				}
			}
		}
		return arrValue ;
	}
	/**
	 *
	 * @param arg1
	 * @param arg2
	 * @returns
	 */
	function checkBoxSelectedValue2( arg1, arg2 ) {
		if (arg1 == undefined ) {
			return null  ;
		}
		cnt = checkBoxSelectedCount(arg1) ;
		var arrValue = new Array(cnt);
		var len = arg1.length ;
		var index  = 0 ;
		if (len ==  undefined ) {
			if( arg1.checked == true )  arrValue[0] =  arg2.value ;
		} else {
			for ( var i = 0 ; i < len ; i++ ) {
				if ( arg1[i].checked == true )  {
					arrValue[index] = arg2[i].value ;
					index = index + 1 ;
				}
			}
		}
		return arrValue ;
	}

	/**
	 * 배열여부
	 * @param arg
	 * @returns {Boolean}
	 */
	function isObjArray(arg) {
		var result = false ;
		try {
			if( arg.length  == undefined ) {
				result = false ;

			}else {
				result = true ;

			}
		}catch (E) {

			result = false;
		}

		return result ;
	}
//--- 현 시스템의 O/S(Windows) Version을 리턴한다.
function getAgent(){
	var KindAgent = navigator.userAgent;
	if(KindAgent.indexOf("Windows 95"))
		return("95");
	else if(KindAgent.indexOf("Windows 98"))
		return("98");
	else if(KindAgent.indexOf("Windows 2000"))
		return("2000");
}

//--- 웹 브라우저의 이름을 리턴한다.
function getNavigatorName(){
	return(navigator.appName);
}

//--- 웹 브라우저의 Version을 리턴한다.
function getNavigatorVer(){
	var ver  = parseInt(navigator.appVersion,10);
	return(ver);
}


	ie = document.all?1:0;

	function hL(E){
		if (ie){
			while (E.tagName!="TR"){E=E.parentElement;}
		}
		else{
			while (E.tagName!="TR"){E=E.parentNode;}
		}
		E.className = "H";
	}

	function dL(E){
		if (ie){
			while (E.tagName!="TR")	{E=E.parentElement;}
		}
		else{
			while (E.tagName!="TR")	{E=E.parentNode;}
		}
		E.className = "";
	}

/**
 * 체크박스 선택
 * @param checks
 * @param isCheck
 */
function checkAll(checks, isCheck){
	var fobj = document.getElementsByName(checks);
	var style = "";
	if(fobj == null) return;

  	if(fobj.length){
  		for(var i=0; i < fobj.length; i++){
  			if(fobj[i].disabled==false){
  				fobj[i].checked = isCheck;
  			}
  		}
  	}else{
  		if(fobj.disabled==false){
  			fobj.checked = isCheck;
  		}
  	}

}
	function openWindow(url,  width, height, strScroll ){
		var pop = "" ;
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		pop = window.open(url, "NeosMain", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll);
		try {pop.focus(); } catch(e){}
		
	}
	
	function openWindow1(url,  windowName, intWidth, intHeight, strScroll, strResize ){

		if(intWidth == undefined || intWidth == '') {
			intWidth = "1000";
		}
		
		if(intHeight == undefined || intHeight == '') {
			intHeight = screen.height - 100;
		}
        var agt = navigator.userAgent.toLowerCase();

        if (agt.indexOf("safari") != -1) {
            intHeight = intHeight - 70;
        }

        var intLeft = screen.width / 2 - intWidth / 2;
        var intTop = screen.height / 2 - intHeight / 2 - 40;

        if (agt.indexOf("safari") != -1) {
            intTop = intTop - 30;
        }
		if(strScroll == undefined || strScroll == '') {
			strScroll = 'no' ;
		}
		
		if(strResize == undefined || strResize == '') {
			strResize = 'no' ;
		}
        var pop = window.open(url, windowName, 'menubar=0,resizable='+strResize+',scrollbars='+strScroll+',status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
		try {pop.focus(); } catch(e){}
		return pop;
	}
	
	function openWindow2(url,  windowName, width, height, strScroll, strResize ){

		var pop = "" ;
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		if(strResize == undefined || strResize == '') {
			strResize = 0 ;
		}
		pop = window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);
		try {pop.focus(); } catch(e){}
		return pop;
	}
	
	function openWindow3(url,  windowName, strResize){
		var intWidth = "1000";
        var intHeight = screen.height - 100;

        var agt = navigator.userAgent.toLowerCase();

        if (agt.indexOf("safari") != -1) {
            intHeight = intHeight - 70;
        }

        var intLeft = screen.width / 2 - intWidth / 2;
        var intTop = screen.height / 2 - intHeight / 2 - 40;

        if (agt.indexOf("safari") != -1) {
            intTop = intTop - 30;
        }
		if(strResize == undefined || strResize == '') {
			strResize = 'yes' ;
		}
        var pop = window.open(url, windowName, 'menubar=0,resizable='+strResize+',scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
		try {pop.focus(); } catch(e){}
		return pop;
	}
	
	function checkLength(maxlen, obj) {
		    var temp;
		    var msglen = maxlen*2;
		    var value  = obj.value;

		    var len =  obj.value.length;
		    var txt = "" ;

		    if (len == 0) {
		        value = maxlen*2;
		    } else  {
		        for(var k=0; k<len; k++) {
		            temp = value.charAt(k);
		            if (escape(temp).length > 4){
		                msglen -= 2;
		            } else {
		                msglen--;
		            }
		            if(msglen < 0) {   
		               alert(NeosUtil.getMessage("TX000009215","영문은")+(maxlen*2)+ NeosUtil.getMessage("TX000009214","자 한글은") + NeosUtil.getMessage("TX000009915","{0}자 까지 입력할 수 있습니다").replace("{0}",maxlen));
		                obj.value = txt;
		                break;
		            } else {
		                txt += temp;
		            };
		        };
		    };
		}
		function updateChar(length_limit, objname,tobj) {

			var length = calculate_msglen(tobj.value);
			if( objname != "" )
				document.getElementById(objname).innerText = length;
			if (length > length_limit) {  
				alert(NeosUtil.getMessage("TX000011075","메세지는 최대 {0}byte까지 입력 가능합니다").replace("{0}",length_limit));
				tobj.value = tobj.value.replace(/\r\n$/, "");
				tobj.value = assert_msglen(tobj.value, length_limit,objname);
				length = calculate_msglen(tobj.value);
				if( objname != "" )
					document.getElementById(objname).innerText = length;
			}
		}
		function calculate_msglen(message) {
			var nbytes = 0;

        	for (var i=0; i<message.length; i++) {
            	var ch = message.charAt(i);
            	if (escape(ch).length > 4) {
                	nbytes += 2;
            	} else if (ch != '\r') {
                	nbytes++;
            	}
        	}
			return nbytes;
		}
		function assert_msglen(message, maximum,objname) {
			var inc = 0;
			var nbytes = 0;
			var msg = "";
			var msglen = message.length;

			for (var i=0; i<msglen; i++) {
				var ch = message.charAt(i);
				inc = 0 ;
				if (escape(ch).length > 4) {
					inc = 2;
				}else if(ch == '\n' ) {
					if (message.charAt(i-1) != '\r') {
						inc = 1;
					}

				}else {
					inc =  1;
				}
				if ((nbytes + inc) > maximum) {
					break;
				}
				nbytes += inc;
				msg += ch;
			}
			if(objname != "")
				document.getElementById(objname).innerText = nbytes;
			return msg;
		}
	function formSerialize(chkfrm){
		if(chkfrm==null) return "";
	 	var values="";
	 	chkFormElment = new Array();
		for(var i=0;i<chkfrm.length;i++){
			chkFormElment[chkFormElment.length]=chkfrm[i].name+"="+chkfrm[i].value;
		}
		values=chkFormElment.join('&');
		return values;
	}

	/**
	 *숫자여부
	 * @param arg
	 * @returns {Boolean}
	 */
	function isNumber(arg) {

		for(var i=0; i<arg.length; i++) {
			var chr = arg.substr(i, 1);
			if(chr < '0' || chr > '9') {
				return false;
			}
		}

		return true;
	}

	/**
	 * 포커스 자동이동
	 * @param nowID
	 * @param nextID
	 * @param autoLength
	 */
	function fncAutoFocus(nowID, nextID, autoLength) {
		var nowObjID = $("#" + nowID).val();
		var nextObjID = $("#" + nextID).val();

		if (nowObjID.length == autoLength) {
			$("#" + nextID).focus();
		}
	}

	/**
	 * 돈으로 변환
	 * @param data
	 * @param cipher
	 * @returns
	 */
    function getToPrice(data, cipher) {
    	if(data == null){
    		data = "0";
    	}
        var TempValue = data.toString();
        TempValue = TempValue.replace(/,/g, "");
        TempValue = parseInt(TempValue, 10);
        var sign = "";
        if(TempValue < 0){
        	sign = "-";
        	TempValue = Math.abs(TempValue);
        }

        if (isNaN(TempValue))
            return data;

        TempValue = TempValue.toString();
        var iLength = TempValue.length;

        if (iLength < 4)
            return data;

        if (cipher == undefined)
            cipher = 3;

        cipher = Number(cipher);
        count = iLength / cipher;

        var slice = new Array();

        for (var i = 0; i < count; i++)
        {
            if (i * cipher >= iLength) break;
            slice[i] = TempValue.slice((i + 1) * -cipher, iLength - (i * cipher));
        }

        var revslice = slice.reverse();

        return sign + revslice.join(',');
    }
	/**
	 * 엔터키 포함 여부
	 * @param str
	 * @returns {Boolean}
	 */
    function fc_isIncludeEnterKey(str) {
    	var strSplit = str.split("\r\n");
    	if(strSplit.length > 1) {
    		return true;
    	}
    	return false;
    }

    /**
     * 문서제목 제한 정규표현식
     */
    function getDocTitleExp() {
    	return ":";
    }

    /**
     * 기록물철 제목 제한 정규표현식
     */
    function getArchiveTitleExp() {
    	return "\"|'|<|>|~|!|@|#|%|&|{|}|/|-";
    }

    /**
     * 단위업무 제목 제한 정규표현식
     */
    function getWorkTitleExp() {
    	return "\"|'|<|>|~|!|@|#|%|&|{|}";
    }

    /**
     * 첨부제목 제한 정규표현식
     */
    function getAttachTitleExp() {
    	return "\"|'|<|>|~|!|@|#|%|&|{|}";
    }

    /**
     * 제한된 기호를 보여주기윈한 함수
     */
    function getExpKeyword(exp) {
    	var reg = /\|/g;
    	return exp.replace(reg,",");
    }

    /**
     * 문자열 html 제거
     * @param text
     * @returns
     */
    function removeHTML(text) {
        var objReg = new RegExp();  //  정규 표현식 객체를 생성한다
        objReg = /[<][^>]*[>]/gi;
         // <...> 태그를 대소문자 구분 없이[/gi 옵션](g=global / i=insensitive) 모두 찾는다.
         text= text.replace(objReg, "");
         return text;
    }

    function neosPopup(popType, param, popName) {
    	switch (popType) {
    		case 'POP_APPLINE' : //결재라인 보기
    			var uri = getContextPath()+"/edoc/eapproval/workflow/listApprovalLine.do?" +param ;
				openWindow2(uri,  "popDocApprovalLine", 824, 320, 0) ;
				break;
    		case 'POP_DOCWRITE' : //상신문서작성
				var uri = getContextPath()+"/edoc/eapproval/docCommonDrafWrite.do?" + param;
		        return openWindow3(uri,  "popDocTemplate", '') ;
				break;
    		case 'POP_DOCVIEW' : //상신문서보기
    		case 'POP_ONE_DOCVIEW' : //상신문서보기
    		case 'POP_DOCEDIT' : //상신문서수정
    			
    			if(ncCom_Empty(popName)) {
    				popName = "popDocApprovalEdit";
    			}
    			if(popType == "POP_ONE_DOCVIEW") {
    				param= "multiViewYN=N&"+param;
    			}else {
    				param= "multiViewYN=Y&"+param;
    			}
    			var np216 = NeosUtil.getOptionValue("np216", "");
    			if(np216 && np216 == '1'){
    				popName = '';
    			}
				var uri = getContextPath()+"/edoc/eapproval/docCommonDraftView.do?"+ param;
				return openWindow3(uri,  popName, '') ;
				break;
    		case 'POP_DOCREF' : //참조문서보기
    			var firstDiKeyCode = $("#firstDiKeyCode").val();
    			param= "firstDiKeyCode="+firstDiKeyCode+"&"+param;
    			var uri = getContextPath()+"/edoc/eapproval/docCommonDraftView.do?"+ param;
    			return openWindow3(uri,  popName,  '') ;
    			break;
    		case 'POP_DOCUSER' : //문서보기
    			if(ncCom_Empty(popName)) {
    				popName = "popDocApprovalEdit";
    			}
    			if(popType == "POP_ONE_DOCVIEW") {
    				param= "multiViewYN=N&"+param;
    			}else {
    				param= "multiViewYN=Y&"+param;
    			}
    			var uri = getContextPath()+"/edoc/eapproval/docCommonDraftUserView.do?"+ param;
    			openWindow2(uri,  popName,  _g_aproval_width_, _g_aproval_heigth_, 1,1) ;
    			break;
    		case 'POP_DOCCHARGE' : //문서보기
    			if(ncCom_Empty(popName)) {
    				popName = "popDocApprovalEdit";
    			}
    			if(popType == "POP_ONE_DOCVIEW") {
    				param= "multiViewYN=N&"+param;
    			}else {
    				param= "multiViewYN=Y&"+param;
    			}
    			var uri = getContextPath()+"/edoc/eapproval/docCommonDraftChargeView.do?"+ param;
    			openWindow2(uri,  popName,  _g_aproval_width_, _g_aproval_heigth_, 1,1) ;
    			break;
    		case 'POP_DOCCOPY' : //문서복사
				//var uri = "/edoc/eapproval/workflow/docApprovalCopyPopup.do?"+ param;
    			var uri = getContextPath()+"/edoc/eapproval/workflow/docReDraftViewPopup.do?"+ param;
				openWindow2(uri,  "popDocApprovalCopy",  200, 130, 1,0) ;
				break;
    		case 'POP_DOCEDITLIST' : //문서수정내역
				//var uri = "/edoc/eapproval/workflow/docApprovalCopyPopup.do?"+ param;
    			var isCompare = 'Y';
    			if('r_' == _g_prefixApproval || _g_nonElecYN == 'Y' || _g_tiFormGb == '1'){
    				isCompare = 'N';
    			}
    			var uri = getContextPath()+"/edoc/eapproval/workflow/listMyOrderKuljaeLine.do?"+ param+"&tiFormGb="+_g_tiFormGb+"&isCompare="+isCompare;
				openWindow2(uri,  "popDocEditList",  996, 345, 1,0) ;
				break;
    		case 'POP_HWPVIEW' : //hwp 파일 보기
				//var uri = "/edoc/eapproval/workflow/docApprovalCopyPopup.do?"+ param;
    			var uri = getContextPath()+"/edoc/eapproval/workflow/docApprovalView.do?"+ param;
				openWindow2(uri,  "popHwpView", _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
				break;
    		case 'POP_ERP_EXPENSES' : //기안문서 호출
    			var uri =  getContextPath()+"/edoc/eapproval/workflow/docG20DraftWrite.do?"+ param;
    			openWindow2(uri,  "popHwpErpExpenses", _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
    			break;
    		case 'POP_COMMON_DRAFT' : //근태 , 휴가
    			var uri =  getContextPath()+"/edoc/eapproval/workflow/docCommonDrafWrite.do?"+ param;
    			openWindow2(uri,  "popHwpCommon",  _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
    			break;
    		case 'POP_EDIT_VACATION' : //근태정보 수정
    			var uri =  getContextPath()+"/erp/g20/abdocu.do?"+ param;
    			openWindow2(uri,  "popEditErpExpenses",  968, 700, 0,0) ;
    			break;
    		case 'POP_EDIT_ERP_IU' : //KOFIA 예산회계정보 수정
    			var uri =  getContextPath()+"/kofia/ac/draftLoad.do?"+ param;
    			openWindow2(uri,  "popEditErpExpenses",  964, 670, 0,0) ;
    			break;
    		case 'POP_DOCLIST_DOWN': //
    			var uri =  getContextPath()+"/neos/edoc/document/record/board/common/DocListDown.do?"+ param;
				openWindow2(uri,  "popDocListDown",  335, 250, 0,0) ;
    			break;
    		case 'POP_OLD_DOCVIEW': //구문서함 조회시 기안 파일뷰어 
//    			var uri = getContextPath()+"/neos/edoc/document/olddoc/board/common/OldDocFileViewPopup.do?"+ param;
    			var uri = getContextPath()+"/neos/edoc/document/mig/MigDocViewPopup.do?"+ param;
//				openWindow2(uri,  "popHwpView", _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
				openWindow3(uri,  "popHwpView",  '') ;
				break;
//    		case 'POP_OLD_DOCKAITVIEW': //구문서함 조회시 기안 파일뷰어 
//    			var uri = getContextPath()+"/neos/edoc/document/olddoc/board/common/OldDocFileViewKAITPopup.do?"+ param;
//    			openWindow2(uri,  "popHwpView", _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
//    			break;
//    		case 'POP_OLD_HANDYDOCVIEW': //구핸디문서함 조회시 기안 파일뷰어 
//    			var uri = getContextPath()+"/neos/edoc/document/olddoc/board/common/OldHandyDocFileViewPopup.do?"+ param;
//				openWindow2(uri,  "popHwpView", _g_aproval_width_, _g_aproval_heigth_, 0,1) ;
//				break;
    		case 'POP_OLD_APPLINE' : //결재라인 보기
//    			var uri = getContextPath()+"/neos/edoc/document/olddoc/board/common/OldDocApprovalLineEx.do?" +param ;
    			var uri = getContextPath()+"/neos/edoc/document/mig/MigDocApprovalLinePopup.do?" +param ;
				openWindow2(uri,  "popOldDocApprovalLine", 887, 346, 0) ;
				break;
    		case 'POP_MEMOSUBJECT_OPINION' : //메모의견정보
    			var uri = getContextPath()+"/memoreport/memoReportSubjectOpinionList.do?" +param ;
    			openWindow2(uri,  "popMemoSubjectOpinion", 960, 546, 0) ;
    			break;
    		case 'POP_MEMOREFER' : //메모참조대상자조회
    			var uri = getContextPath()+"/memoreport/memoReportReferForMemoReportList.do?" +param ;
    			openWindow2(uri,  "popMemoReportRefer",620, 546, 0) ;
    			break;
    		case 'POP_DEPT' : //부서정보   
    			var uri = getContextPath()+"/cmm/system/selectOrganDeptView.do?" +param ;
    			openWindow2(uri,  "popOrganDept", 290, 520, 0) ;
    			break;
    		case 'POP_MEMBERFORDEPT' : //사용자조회   
    			var uri = getContextPath()+"/cmm/system/selectMemberViewPopup.do?" +param+"&searchDept=Y" ;
    			openWindow2(uri,  "popOrganDept", 569, 550, 0) ;
    			break;
    		case 'POP_EAMEMBERFORDEPT' : //사용자조회   
    			var uri = getContextPath()+"/neos/edoc/eapproval/popup/selectMemberViewPopup.do?" +param+"&searchDept=Y" ;
    			openWindow2(uri,  "popOrganDept", 569, 550, 0) ;
    			break;    			
    		case 'POP_MEMBER' : //사용자조회   
    			var uri = getContextPath()+"/cmm/system/selectMemberViewPopup.do?" +param ;
    			openWindow2(uri,  "popMember", 290, 650, 0) ;
    			break;
    		case 'POP_EAMEMBER' : //사용자조회   
    			var uri = getContextPath()+"/neos/edoc/eapproval/popup/selectOrganDeptUserView.do?" +param ;
    			openWindow2(uri,  "popMember", 290, 650, 0) ;
    			break;    			
    		case 'POP_WORKUNIT' : //단위업무조회   
    			var uri = getContextPath()+"/workcode/popup/WorkCodeListPopup.do?" +param ;
    			openWindow2(uri,  "popWorkUnit", 290, 520, 0) ;
    			break;
    		case 'POP_EAWORKUNIT' : //단위업무조회   
    			var uri = getContextPath()+"/workcode/popup/WorkCodeListPopup.do?" +param ;
    			openWindow2(uri,  "popWorkUnit", 430, 415, 0) ;
    			break;    			
    		case 'POP_TAKEOVERRESULT' : //인계결과   
    			var uri = getContextPath()+"/archive/archiveTakeOverResultList.do" ;
    			openWindow2("",  "popTakeOverResult", 920, 520, 0) ;
    			frmPop.action = uri ;
    			frmPop.method = "post" ;
    			frmPop.target = "popTakeOverResult";
    			frmPop.submit();
    			frmPop.target = "";
    			$("idTakeOverResult").html("");
    			break;
    		case 'POP_RECORD_TAKEOVERRESULT' : //기록물인계결과   
    			var uri = getContextPath()+"/record/recordTakeOverResultList.do" ;
    			openWindow2("",  "popTakeOverResult", 920, 520, 0) ;
    			frmPop.action = uri ;
    			frmPop.method = "post" ;
    			frmPop.target = "popTakeOverResult";
    			frmPop.submit();
    			frmPop.target = "";
    			$("idTakeOverResult").html("");
    			break;
    		case 'POP_EDIT_ERP_EXPENSES' : //회계정보 수정
    			var uri =  param;
    			openWindow2(uri,  "popEditErpExpenses",  968, 700, 0,0) ;
    			break;
    		case 'POP_EMAILWRITE' : //이메일WRITE POPUP 
    			var uri = getContextPath()+"/getMailWriteLink.do?" +param ;
    			openWindow2(uri,  "popEmailWrite",  968, 700, 0,0) ;
    			break;
    		case 'POP_AUDITVIEW' : // 감사보기 팝업
    			var uri = getContextPath()+"/edoc/eapproval/audit/docAuditView.do?" +param ;
                openWindow2(uri,  "popAuditOpinionView", 500, 450, 0) ;
				break;				
    	}
    }
NeosUtil.getLeftMenuWidth = function(){
	// edward ui 수정
	// 기존
	//left : 215 + 오른쪽 margin 여백 : 30
	//return 215  + 30;
	//  수정    /*+ 37 */
	//if($("#lnb_left").css("display")=="none"){

	var lnbLeft =$("#lnb_left").css("display");
	//alert('33  getLeftMenuWidth  lnbLeft : '+lnbLeft);
	if(lnbLeft ==undefined){//  frameset 사용시   ( frame page를 위해 )
		lnbLeft = $(top.document).find("#lnb_left").css("display");
	}
	//alert('$(top.document).find("#lnb_left").css("display") : '+$(top.document).find("#lnb_left").css("display"));
	//alert('$("#lnb_left").css("display") : '+$("#lnb_left").css("display"));

	if(lnbLeft=="none"){  //  frameset 사용시
		return 71;
	}
	else{
		return 281;
	}


};

NeosUtil.close = function(){
	window.open('', '_self', '');
	window.close();
};
//object -> a=a&c=c url 문자열 변경
NeosUtil.makeParam = function(obj){
	var arr = [];
	for(var item in obj){
		if(obj[item]){
			arr[arr.length] = encodeURIComponent(item.toString()) + "=" + encodeURIComponent(obj[item].toString());
		}
	}
	return arr.join("&");
};
NeosUtil.makeButonType01 = function(msg, fn, div_btn, id){
	/*if(!div_btn){
		div_btn = "div_btn";
	}
	if(!msg || !msg.length) return false;
	var html = "<ul style='display:inline'>";
	var btnArray = [];
	for(var i = 0;i< msg.length;i++){
		var tempHtml = "<li style='display:inline;padding-left:4px'>";
		if(fn && fn[i]){
			tempHtml+= "<a href='javascript:;' title='"+msg[i]+"' onclick='"+fn[i]+"' >"+msg[i]+"</a>";
		}
		else{
			tempHtml += "<a href='javascript:;' title='"+msg[i]+"' >"+msg[i]+"</a>";
		}
		tempHtml +="</li>";
		btnArray[btnArray.length] = tempHtml;
	}
	html +=btnArray.join(NeosUtil.makeButonType01_space());
	html += "</ul>";
	$("#" + div_btn).html(html);*/
	NeosUtil.makeButonType02(msg, fn, div_btn, id);
};
NeosUtil.makeButonType01_space = function(){
	var html = "";
	//html += "<span style='width:4px; display:block'></span>";
	return html;
};
NeosUtil.makeButonType02 = function(msg, fn, div_btn, id){
	if(!$.isArray(id)){
		id = [];
	}

	if(!div_btn){
		div_btn = "div_btn";
	}
	if(!msg /*|| !msg.length*/) return false;
	var html = "<div class='controll_btn'><p class='fR' >";
	var btnArray = [];
	for(var i = 0;i< msg.length;i++){
		var tempID = id[i] || "";
		var tempHtml = "";

		if(fn && fn[i]){
			tempHtml+= "<button type='button' id='"+tempID+"' href='javascript:;' onclick='"+fn[i]+"' title='"+msg[i]+"' style='margin-left:4px'>"+msg[i]+"</button>";
		}
		else{
			tempHtml += "<button type='button' id='"+tempID+"' href='javascript:;' title='"+msg[i]+"' >"+msg[i]+"</button>";
		}
		btnArray[btnArray.length] = tempHtml;
	}
	html +=btnArray.join(NeosUtil.makeButonType02_space());
	html += "</p></div>";
	$("#" + div_btn).html(html);
};
NeosUtil.makeButonType02_space = function(){
	var html = "";
	//html += "<span style='margin-right:4px; '></span>";
	return html;
};
NeosUtil.openPopArchive = function(obj)
{
	var openUrl = getContextPath()+"/neos/edoc/eapproval/popup/SelectArchiveWithMyFavorite.do";
	var options = "width=630,height=608";
	var param = NeosUtil.makeParam(obj);//"method=RegistArchiveDocDispatch.SelectArchiveValueSet";
	var fullUrl = openUrl +"?" + param;
	var name = "SelectArchive";
	var SelectArchive = window.open(fullUrl, name, options);
	if(!SelectArchive){
//		alert("<spring:message code='eaproval.pop.unlockPopup' />"/*팝업을 해제해 주세요.*/);
		alert(NeosUtil.getMessage("TX000011218","팝업을 해제해 주세요.")/*팝업을 해제해 주세요.*/);
	}
};

NeosUtil.openPopArchive2 = function(obj)
{
	var openUrl = getContextPath()+"/neos/edoc/eapproval/popup/SelectArchiveReMove.do";
	var options = "width=630,height=607";
	var param = NeosUtil.makeParam(obj);//"method=RegistArchiveDocDispatch.SelectArchiveValueSet";
	var fullUrl = openUrl +"?" + param;
	var name = "SelectArchive2";
	var SelectArchive = window.open(fullUrl, name, options);
	if(!SelectArchive){
//		alert("<spring:message code='eaproval.pop.unlockPopup' />"/*팝업을 해제해 주세요.*/);
		alert(NeosUtil.getMessage("TX000011218","팝업을 해제해 주세요.")/*팝업을 해제해 주세요.*/);
		
		
		
	}
};


NeosUtil.makeButonType03 = function(msg, fn, div_btn, id){
	if(!$.isArray(id)){
		id = [];
	}

	if(!div_btn){
		div_btn = "div_btn";
	}
	if(!msg /*|| !msg.length*/) return false;
	var html = "<div class='clearfx mT5'><p class='fR' >";
	var btnArray = [];
	for(var i = 0;i< msg.length;i++){
		var tempID = id[i] || "";
		var tempHtml = "";

		if(fn && fn[i]){
			tempHtml+= "<a id='"+tempID+"' class='btnArrow' href='javascript:;' onclick='"+fn[i]+"' title='"+msg[i]+"' style='margin-left:4px'><span>"+msg[i]+"</span></a>";
		}
		else{
			tempHtml += "<a id='"+tempID+"' class='btnArrow' href='javascript:;' title='"+msg[i]+"' ><span>"+msg[i]+"</span></a>";
		}
		btnArray[btnArray.length] = tempHtml;
	}
	html +=btnArray.join(NeosUtil.makeButonType02_space());
	html += "</p></div>";
	$("#" + div_btn).html(html);
};
/**
 *
 * @param strType : 공백: 대,소문자, 숫자, a: 소문자, A:대문자, a1:소문자+숫자, A1:대문자+숫자
 * @param strLength : 랜덤문자열 자리수
 * @returns
 */
function rndStr(strType, strLength) {
	var rndstr = new RndStr();
	rndstr.setType(strType);
	rndstr.setStr(strLength);
	return rndstr.getStr()  ;
}
function RndStr() {
	this.str = '';
	this.pattern = /^[a-zA-Z0-9]+$/;
	this.setStr =	function(n) {
						if(!/^[0-9]+$/.test(n)) n = 0x10;
						this.str = '';
						for(var i=0; i<n-1; i++) {
							this.rndchar();
						}

					};
	this.setType =  function(s) {
						switch(s) {
							case '1' : this.pattern = /^[0-9]+$/; break;
							case 'A' : this.pattern = /^[A-Z]+$/; break;
							case 'a' : this.pattern = /^[a-z]+$/; break;
							case 'A1' : this.pattern = /^[A-Z0-9]+$/; break;
							case 'a1' : this.pattern = /^[a-z0-9]+$/; break;
							default : this.pattern = /^[a-zA-Z0-9]+$/;

						}

					};
	this.getStr = function() {
		return this.str;
	};

	this.rndchar =  function() {
						var rnd = Math.round(Math.random() * 1000);
						if(!this.pattern.test(String.fromCharCode(rnd))) {
							this.rndchar();
						} else {
							this.str += String.fromCharCode(rnd);

						}

					};
};
function telePhoneParse(telNo) {
	var telNo1 = "" ;
	var arrTelNo = ["", "", ""];

	if(ncCom_Empty(telNo)) return "";

	telNo = ncCom_Replace(telNo, "-", "");

	if(ncCom_Empty(telNo)) return "";
	var count = telNo.length ;

	if(count < 9  ) {
		if( count == 2)  {
			arrTelNo[0] = telNo.substring(0, 2) ;
		}else if ( count  == 3 ) {
			arrTelNo[0] = telNo.substring(0, 3) ;
		}
	}else if (count == 9 ) {
		arrTelNo[0] = telNo.substring(0, 2) ;
		arrTelNo[1] = telNo.substring(2, 5) ;
		arrTelNo[2] = telNo.substring(5, 9) ;
	}else if (count == 10 ) {
		telNo1 = telNo.substring(0, 2) ;
		if(telNo1 == "02") {
			arrTelNo[0] = telNo.substring(0, 2) ;
			arrTelNo[1] = telNo.substring(2, 6) ;
			arrTelNo[2] = telNo.substring(6, 10) ;
		}else {
			arrTelNo[0] = telNo.substring(0, 3) ;
			arrTelNo[1] = telNo.substring(3, 6) ;
			arrTelNo[2] = telNo.substring(6, 10) ;
		}

	}else if (count == 11 ) {
		arrTelNo[0] = telNo.substring(0, 3) ;
		arrTelNo[1] = telNo.substring(3, 7) ;
		arrTelNo[2] = telNo.substring(7, 11) ;
	}else if (count == 12 ) {
		arrTelNo[0] = telNo.substring(0, 4) ;
		arrTelNo[1] = telNo.substring(4, 8) ;
		arrTelNo[2] = telNo.substring(8, 12) ;
	}
	return arrTelNo ;
}
function isMobile(telNo) {
	if( telNo == "011" || telNo == "017" || telNo == "016" || telNo == "019"  || telNo == "010" ) return  true ;
	return false ;


}
function getContextPath(){

    return _g_contextPath_;
}
//multiFile init
function initMultiFile(tabNumber) {

    $("#neosFile_"+tabNumber).MultiFile({
    	list : '#file-list_' + tabNumber,
        namePattern:'neosFile_'+tabNumber,
        STRING: {
            remove: "<img src= '"+_g_contextPath_ + "/Images/ico/sc_multibox_close.png' alt = '삭제'/>"   //삭제 이미지아이콘으로도 바꿀수 있다(이미지 태그 넣으면 됨).
        }
     });
}

function shoutCutTitleChange(title){
	if($("#conHead").length)
	{
		$("#conHead").html("<h2>" + title + "</h2>");
	//	parent.conHeight();
	}
/*
	var articleArea =  $("#articleArea", parent.document);
	$("#conHead", articleArea).remove();

	if(!title){
		try {
			parent.resizeWindow();
		} catch (e) {
			try {
				parent.parent.resizeWindow();
			} catch (e) {
				var message = e.message.toString();
				try {
					console.log(message);
				} catch (e) {
					// TODO: handle exception
				}
			}
		}
		return false;
	}

	$.conHead = 0;
	var conHead = $("<div>").attr("id", "conHead").addClass("conHead");
	var shoutCutTitle = $("<h2>").attr("id", "shoutCutTitle");
	conHead.append(shoutCutTitle);
	conHead.insertBefore($("#contents", parent.document));

	$("#shoutCutTitle", parent.document).html(title);
	try {
		parent.resizeWindow();
	} catch (e) {
		try {
			parent.parent.resizeWindow();
		} catch (e) {
			var message = e.message.toString();
			try {
				console.log(message);
			} catch (e) {
				// TODO: handle exception
			}
		}
	}
*/
    /* title -  문서제목 설정 */
/*
    $(function(){
    	try {
			$("title", parent.document).html("NEOS- " + title);
		} catch (e) {
			try {
				console.log(e.message);
			} catch (e) {
				// TODO: handle exception
			}
		}
    });
*/
}

editorConfig = function( config, bodyID, height ) {
	config.docType = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
	//config.font_defaultLabel = 'Gulim';
	//config.font_names = 'Gulim/Gulim;Dotum/Dotum;Batang/Batang;Gungsuh/Gungsuh;Arial/Arial;Tahoma/Tahoma;Verdana/Verdana';
	config.fontSize_defaultLabel = '12px';
	config.fontSize_sizes = '8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;';
	config.language = "ko";
	config.resize_enabled = false;
	config.enterMode = CKEDITOR.ENTER_P;
	config.shiftEnterMode = CKEDITOR.ENTER_P;
	config.startupFocus = true;
	//config.uiColor = '#EEEEEE';
	config.toolbarCanCollapse = false;
	config.menu_subMenuDelay = 0;
	//config.toolbar = [['Bold','Italic','Underline','Strike','-','Subscript','Superscript','-','TextColor','BGColor','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Link','Unlink','-','Find','Replace','SelectAll','RemoveFormat','-','Image','Flash','Table','SpecialChar'],'/',['Source','-','ShowBlocks','-','Font','FontSize','Undo','Redo','-','About']];
	config.bodyId =  bodyID;
	config.height = height;
    config.filebrowserUploadUrl = getContextPath()+'/edoc/eapproval/workflow/ckEditorImageUpload.do';
    config.filebrowserImageUploadUrl = getContextPath()+'/edoc/eapproval/workflow/ckEditorImageUpload.do';
};

/*월(2자리), 일(2자리), 시간(2자리), 초(2자리), 밀리초(3자리) 자리수 맞추기*/

NeosUtil.setNumTwo = function(num, isMilli)
{	var set = 2;
	if(isMilli)set = 3;
	var numStr = "" + num;
	if(numStr.length < set){
		if(!isMilli){
			return "0" + 	numStr;
		}
		else{
			if(("0" + 	numStr).length< set){
				return "00" + 	numStr;
			}else{
				return "0" + 	numStr;
			}
		}
	}
	else return numStr;
};
NeosUtil.getCalcImg = function(){
	return _g_contextPath_ + "/images/common/btn_callender.gif";
};


/**
 * @see 다중 사용자 선택을 지정해주는 팝업을 위한 함수
 * @param obj{root : root}
 * @author 김석환
 * @description
 * 

 1. 초기값 셋팅 함수 구현 예시
var getMultiSelectUser = function(obj){
	return {
			name : $("#joinUserNameList").val(), 
			id : $("#joinUserIDList").val(),
			dept : $("#joinUserDeptList").val()
		};
};

2. 팝업에서 사용자 리스트 받는 함수 구현 예시
var setMultiSelectUser = function(name, id, dept){
	$("#joinUserNameList").val(name);
	$("#joinUserIDList").val(id);
	$("#joinUserDeptList").val(dept);
};
3. 사용화면 : scheduleRegistry.jsp
 * 
 * */
NeosUtil.openMultiSelectUser = function(obj){
	var param = "";
	if(obj && typeof obj == "object" && obj.root && $.trim(obj.root)){
		param = NeosUtil.makeParam(obj);
	}
	var url =  _g_contextPath_ + "/cmm/popup/popMultiSelectUser.do?" + param; 
	var popup = window.open(url, "userSelect", 'toolbar=no, scrollbar=no, width=530, height=510, resizable=no, status=no');
	popup.focus();
};

/**
 * @see 다중 부서 선택을 지정해주는 팝업을 위한 함수
 * @param obj{root : root}
 * @author 김석환
 * @description
 * 

 1. 초기값 셋팅 함수 구현 예시
var getMultiSelectDept = function(obj){
	return {
			name : $("#joindeptListName").val(), 
			id : $("#joindeptListId").val()
		};
};

2. 팝업에서 부서 리스트 받는 함수 구현 예시
var setMultiSelectDept = function(name, id){
	$("#joindeptListName").val(name);
	$("#joindeptListId").val(id);
	
};
 * 
 * */
NeosUtil.openMultiSelectDept = function(obj){
	var param = "";
	if(obj && typeof obj == "object" && obj.root && $.trim(obj.root)){
		param = NeosUtil.makeParam(obj);
	}
	var url =  _g_contextPath_ + "/cmm/popup/popMultiSelectDept.do?" + param; 
	var popup = window.open(url, "userSelect", 'toolbar=no, scrollbar=no, width=530, height=510, resizable=no, status=no');
	popup.focus();
};

/**
 * @see 다중 사용자 선택을 지정해주는 팝업을 위한 함수(팀원, 부서원, 일반계약직, 일용계약직 제외)
 * 사용화면 : PimsAttendance.jsp
 * 2013.01.27 haxu sohn
*/
NeosUtil.openMultiSelectUser2 = function(obj){
	var param = "";
	if(obj && typeof obj == "object" && obj.root && $.trim(obj.root)){
		param = NeosUtil.makeParam(obj);
	}
	var url =  _g_contextPath_ + "/cmm/popup/popMultiSelectUser2.do?" + param; 
	var popup = window.open(url, "userSelect", 'toolbar=no, scrollbar=no, width=530, height=510, resizable=no, status=no');
	popup.focus();
};

/**
 * @param title  : 글자열
 * @param max_byte  : 최대글자열
 * @param last_word  : 자른뒤에 붙는 문자열
 * @return title  : 결과문자
 * @author 김성호
 * @description 
 * 
 * 
 * */
NeosUtil.disp_title  = function(title, max_byte, last_word){

    var title_len = title.length;  
    var title_byte = 0;
    var max_len = 0; 

    for(var i=0;i<title_len;i++){
        var one_char = title.charAt(i);   
        if(escape(one_char).length > 4){  //한글 
        	title_byte +=2;
        }else{  // 한글외
        	title_byte++; 
        }
        if(title_byte <= max_byte){
        	max_len = i + 1;
        }
    }

    // max_byte(제한길이)초과글 삭제, 연결문자열 추가
    if (parseInt(title_byte) > parseInt(max_byte)) {                     
    	title= title.substr(0, max_len)+last_word;          
    } 
    return title;
};

function textToHtmlConvert(strValue) {
	if(ncCom_Empty(strValue)) return "";
	strValue = ncCom_Replace(strValue, "&lt;", "<") ;
	strValue = ncCom_Replace(strValue, "&gt;", ">") ;
	strValue = ncCom_Replace(strValue, "&#40;", "(") ;
	strValue = ncCom_Replace(strValue, "&#41;", ")") ;
	strValue = ncCom_Replace(strValue, "&#39;", "'") ;
	strValue = ncCom_Replace(strValue, "&quot;", '"') ;
	strValue = ncCom_Replace(strValue, "&apos;", "'") ;
	strValue = ncCom_Replace(strValue, "<br>", "\r") ;
	strValue = ncCom_Replace(strValue, "<br/>", "\r") ;	
	strValue = ncCom_Replace(strValue, "&nbsp;", " ") ;
	return strValue ;
}
/**
 * os 체크 
 * @returns {String}
 */
function getOSInfoStr() {
    var ua = navigator.userAgent;

    if (ua.indexOf("NT 6.1") != -1) return "Windows 7";
    else if(ua.indexOf("NT 6.0") != -1) return "Windows Vista";
    else if(ua.indexOf("NT 5.2") != -1) return "Windows Server 2003";
    else if(ua.indexOf("NT 5.1") != -1) return "Windows XP";
    else if(ua.indexOf("NT 5.0") != -1) return "Windows 2000";
    else if(ua.indexOf("NT") != -1) return "Windows NT";
    else if(ua.indexOf("9x 4.90") != -1) return "Windows Me";
    else if(ua.indexOf("98") != -1) return "Windows 98";
    else if(ua.indexOf("95") != -1) return "Windows 95";
    else if(ua.indexOf("Win16") != -1) return "Windows 3.x";
    else if(ua.indexOf("Windows") != -1) return "Windows";
    else if(ua.indexOf("Linux") != -1) return "Linux";
    else if(ua.indexOf("Macintosh") != -1) return "Macintosh";
    else return "";
}

function localSaveFilePath() {
	var filePath = "";
	var osType = getOSInfoStr();
	if(osType == "Windows 7" || osType == "Windows Vista") {
		filePath = "C:\\Users\\Public\\Documents\\" ;
	}else if (osType == "Windows XP") {
		filePath = "C:\\Documents and Settings\\All Users\\Documents\\";
	}
	return filePath ;
}
/**
 * div dialog 가 필요할때 사용함
 * 작성자 : 김석환
 * 사용 : 
	$(window).resize(function(){
		NeosUtil.dialogStyleSet("id");
	});	
 * 참조페이지 : scheduleViewMonth.jsp
 * 
 */
NeosUtil.dialogStyleSet = function(id){
	$("#" + id)
	//.css("width", $("#contents").width()+15).css("height", $("#contents")
	.css("width", $("body").width()+15).css("height", $("body")
			.height()+15).addClass("erp-dialog-form-background")
	.css("position", "absolute")
	.css("left", "1px").css("top", "1px").css("zIndex", "700000").css("filter", "Alpha(Opacity=50)");	
}; 
  
/** IU 연동양식 TemplateKey 가져오기  **/
NeosUtil.getTemplateKey = function(childCode, detailCode, serviceName){

    var data = {childCode : childCode , detailCode :  detailCode , serviceName :  serviceName};
    var key = "";
    var opt = {
            type:"post",
            url:_g_contextPath_ + "/erp/iu/cmm/getTemplateKey.do",
            datatype:"json",
            data: data,
            async : false,
            success:function(data){
/*                if(data && data.result && data.result.C_TIKEYCODE){
                    key = data.result.C_TIKEYCODE;  
                }*/
            	
                if(data && data.result){
                    key = data.result; 
                }
            },
            error : function(e){
            }
        };
    $.ajax(opt); 
    
    return key;
};

function getFileSize(fileid) {
	try {
	    var fileSize = 0;
	    
	    if (navigator.userAgent.match(/msie/i)) {
	        //before making an object of ActiveXObject, 
	        //please make sure ActiveX is enabled in your IE browser
	    	
	    		    	
	        var objFSO = new ActiveXObject("Scripting.FileSystemObject"); 
	        var filePath = $("#" + fileid)[0].value;
	        var objFile = objFSO.getFile(filePath);
	        var fileSize = objFile.size; //size in kb
	        fileSize = fileSize / 1048576; //size in mb 
        
/*        
	    	var filePath = $("#" + fileid)[0].value;
	        var img = new Image();
	        img.dynsrc = filePath;
	        fileSize = img.fileSize ;        
	        fileSize = fileSize / 1048576; //size in m
*/	        
	        
	    }
	        //for FF, Safari, Opeara and Others
	    else {
	        fileSize = $("#" + fileid)[0].files[0].size //size in kb
	        fileSize = fileSize / 1048576; //size in mb 
	    }
	    fileSize =roundPrecision(fileSize,2);

	    return fileSize ;
	}
	catch (e) {
	    alert("Error is :" + e);
	}
}
function roundPrecision (val, precision) {
	 var p = Math.pow(10, precision);
	 return Math.round(val * p) / p;
}

function getDeptList(){
	var orgnzt = "";
    $.ajax({
        type: "POST",
        url: getContextPath()+"/neos/edoc/document/archive/getDeptList.do",
        async: false,
        datatype: "text",
        data: ({ id: "id" }),
        success: function (data) {
        	
        	orgnzt += "<option value=\"\">"+NeosUtil.getMessage("TX000000862","전체")+"</option>";
        	for(var i = 0; i < data.deptList.deptList.length; i ++){ 
        	orgnzt += "<option value="+data.deptList.deptList[i].ORGNZT_ID+">"+data.deptList.deptList[i].ORGNZT_NM+"</option>";
        	}
        	
        },
        error: function (XMLHttpRequest, textStatus) {
        }
    });
    return orgnzt;
}

function deleteAttach(attrname, size){
	var atsize = ($("#attachFileSize").text()*1 - size).toFixed(3);
	 $(attrname).parent().remove();
	 $("#attachFileCnt").text(parseInt($("#attachFileCnt").text()) - 1);
     $("#attachFileSize").text(atsize);
     $("#attachFileSize").val(atsize);

}

function deleteAttach(attrname, size, aiseq, pgcnt){
	lumpApproval.delFile(aiseq, pgcnt);
	var atsize = ($("#attachFileSize").text()*1 - size).toFixed(3);
	 $(attrname).parent().remove();
	 $("#attachFileCnt").text(parseInt($("#attachFileCnt").text()) - 1);
     $("#attachFileSize").text(atsize);
     $("#attachFileSize").val(atsize);
     
     
}
 
/*레이어팝업***************************************************************************************************/    

//팝업열기 
//- url : 호출 url
//- param : 호출 파라미터 
//- title : 팝업 title
//- width : 팝업 가로사이즈
//- height : 팝업 세로사이즈
//- opener : 팝업호출페이지유형 (컨텐츠 : 1 / 윈도우팝업 : 2 / 레이어 : 3 / iframe : 4)
//- parentId : 팝업호출페이지유형 3일경우, parent div id
//- childrenId : 팝업호출페이지유형 3일경우, children div id
function layerPopOpen(url, param, title, width, height, opener, parentId, childrenId, closeBtn) {
	$("html, body").scrollTop(0);
							
	$.ajax({
		type:"post",
		url: url,
		datatype:"json",
		data: param, 
		success:function(data){
			var $parent;		//modal과 레이어가 들어갈 div 
			var $children;		//레이어 div
			
			if (opener == "1") {
				// 1.컨텐츠영역에서 레이어팝업 띄울 경우
				$parent = $(".sub_contents_wrap");
     		
				$parent.append('<div id="modal" class="modal"></div>');
			} else if (opener == "2") {
				// 2.윈도우팝업에서 레이어팝업 띄울 경우
				$("body").css("overflow", "hidden");
     		
				if ($(".pop_wrap").size() > 0) {
					$parent = $(".pop_wrap");
				}
				if ($(".pop_sign_wrap").size() > 0) {
					$parent = $(".pop_sign_wrap");
				}    		        	
				if(childrenId){
					$parent.append('<div id="modal_'+childrenId+'" class="modal"></div>');   
				}else{
					$parent.append('<div id="modal" class="modal"></div>');   
				}	
	        	 		        
			} else if (opener == "4"){
				//iframe에서 팝업
				$parent = $('.pop_sign_wrap', parent.document);
				var modalHeight = $parent.height();
				$parent.append('<div id="modal" class="modal" style="height:'+modalHeight+'px;"></div>');
			} else {
				// 3.레이어팝업에서 레이어팝업 띄울 경우
				$parent = $("#" + parentId);
     		
				$parent.append('<div id="modal_' + childrenId + '" class="modal"></div>');
			}  
		    
			if(childrenId){
				$parent.after(data);
			}else
				$parent.append(data);
			
			if (opener == "1" || opener == "2") {
				
				if(childrenId){
					$children = $("#"+childrenId);
				}else{
					$children = $(".pop_wrap_dir");
					childrenId = "";  
				}	
			}else if (opener == "4") {
				$children = $parent.find("#"+parentId);
				childrenId = ""; 
			}else {
				$children = $("#" + childrenId);
			}
	
			if (width != "") {
				$children.css("width", width);
			}
			if (height != "") {
				$children.css("height", height);
			}
			$children.css("border", "1px solid #adadad");
			$children.css("z-index", "20");

			if(!closeBtn){
				var header = '<div class="pop_head">';
				header += '<h1>' + title + '</h1>';
				header += '<a href="javascript:layerPopClose(\'' + childrenId + '\');" class="clo" style="display:block;"><img src="'+_g_contextPath_+'/Images/btn/btn_pop_clo02.png" alt="" /></a>';
				header += '</div>';
				$children.prepend(header);
			}			
			var popWid = $children.outerWidth();
			var popHei = $children.outerHeight();

			$children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop",-popHei/2);

		},
		error : function(data){
			//alert(data.exMsg);
		}
	 }); 
}

//팝업닫기
function layerPopClose(childrenId) {
	if (childrenId) {
		$("#" + childrenId).remove();
		$("#modal_" + childrenId).remove();
	}
	else {
		$(".pop_wrap_dir").remove();
		$("#modal").remove();
		$("body").css("overflow", "auto");
	}
}


function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

/** 다국어 조회 **/
NeosUtil.getMessage = function(langPackCode,defaultValue){
	
	var result = "";
	/*
	var opt = {
		type:"post",
		url: "/gw/getBizboxAMessage.do",
		data:{"langPackCode":langPackCode,"defaultValue":defaultValue},
		datatype:"json",
		async:false,
		success:function(data){
			if(data && data.resultStr){
				result = data.resultStr; 
            }
		},
		error: function(xhr) {
			result = "fail : "+xhr;
	    }
	};
	
	$.ajax(opt);*/
	
	result = fnGetMessageJsonParsing(langPackCode,defaultValue);
	
	return result;
	
	//return result;

};

//js공통코드 Parsing
function fnGetMessageJsonParsing(Code, DefStr) {

    var rtnValue = DefStr;

    $.each(getMessageJson, function (i, t) {

        if (t.CD == Code) {

            switch (langCode.toUpperCase()) {
                case 'KR':
                    rtnValue = t.KR;
                    break;
                case 'JP':
                    rtnValue = t.JP;
                    break;
                case 'EN':
                    rtnValue = t.EN;
                    break;
                case 'CN':
                    rtnValue = t.CN;
                    break;
                default:
                    rtnValue = t.KR;
            }

            if (rtnValue == "") rtnValue = DefStr;

            return false;
        }
    });

    return rtnValue;
}

//js공통코드
var getMessageJson = [
				{"CD" : 'TX000000024', "KR" : '사업자번호', "EN" : 'Business license number', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000045', "KR" : '코드', "EN" : 'Code', "JP" : 'コード', "CN" : '编号'},
				{"CD" : 'TX000000068', "KR" : '부서명', "EN" : 'Dept NM', "JP" : '部署名', "CN" : '部门'},
				{"CD" : 'TX000000076', "KR" : '사원명', "EN" : 'name', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000078', "KR" : '확인', "EN" : 'Check', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000080', "KR" : '주민번호', "EN" : 'SSN', "JP" : '住民番号', "CN" : '身份证号码'},
				{"CD" : 'TX000000098', "KR" : '부서', "EN" : 'Department', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000262', "KR" : '메일', "EN" : 'Mail', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000286', "KR" : '사용자', "EN" : 'User', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000313', "KR" : '거래처명', "EN" : 'vendor name', "JP" : '取引先名', "CN" : '往来方名'},
				{"CD" : 'TX000000315', "KR" : '거래처코드', "EN" : 'vondor code', "JP" : '取引先コード', "CN" : '往来方编号'},
				{"CD" : 'TX000000329', "KR" : '담당자', "EN" : 'Person in charge', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000340', "KR" : '관리내역명', "EN" : 'The name of managing list', "JP" : '管理内容名', "CN" : '管理明细名'},
				{"CD" : 'TX000000341', "KR" : '계정과목', "EN" : 'A title of account ', "JP" : 'アカウント科目', "CN" : '会计科目'},
				{"CD" : 'TX000000357', "KR" : '사원코드', "EN" : 'An employee code', "JP" : '社員コード', "CN" : '员工编号'},
				{"CD" : 'TX000000420', "KR" : '시행자', "EN" : 'Executor', "JP" : '施行者', "CN" : '执行人'},
				{"CD" : 'TX000000421', "KR" : '수신참조', "EN" : 'cc', "JP" : '受信参照', "CN" : '抄送'},
				{"CD" : 'TX000000424', "KR" : '삭제', "EN" : 'Delete', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000435', "KR" : '년', "EN" : 'Year', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000436', "KR" : '월', "EN" : 'Month', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000437', "KR" : '일', "EN" : 'Day', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000479', "KR" : '전자결재', "EN" : 'E-approval', "JP" : '電子決裁', "CN" : '电子审批'},
				{"CD" : 'TX000000483', "KR" : '일정', "EN" : 'Schedule', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000516', "KR" : '공급가액', "EN" : 'Pur.Price', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000517', "KR" : '부가세', "EN" : 'VAT', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000519', "KR" : '프로젝트', "EN" : 'Project', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000520', "KR" : '거래처', "EN" : 'Vendor', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000526', "KR" : '카드번호', "EN" : 'Credit Card Number', "JP" : 'カード番号', "CN" : '卡号'},
				{"CD" : 'TX000000552', "KR" : '금액', "EN" : 'Amount  ', "JP" : '金額', "CN" : '金额'},
				{"CD" : 'TX000000626', "KR" : '원', "EN" : 'Won', "JP" : 'ウォン', "CN" : '元'},
				{"CD" : 'TX000000676', "KR" : '화', "EN" : 'Tuesday', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000677', "KR" : '수', "EN" : 'Wednesday', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000678', "KR" : '목', "EN" : 'Thursday', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000679', "KR" : '금', "EN" : 'Friday', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000680', "KR" : '토', "EN" : 'Saturday', "JP" : '', "CN" : ''},
				{"CD" : 'TX000000756', "KR" : '업무분류', "EN" : 'work type', "JP" : '業務分類', "CN" : '业务分类'},
				{"CD" : 'TX000000821', "KR" : '토요일', "EN" : 'Saturday', "JP" : '土曜日', "CN" : '周六'},
				{"CD" : 'TX000000862', "KR" : '전체', "EN" : 'All', "JP" : '', "CN" : ''},
				{"CD" : 'TX000001076', "KR" : '공개', "EN" : 'Open ', "JP" : '公開', "CN" : '公开'},
				{"CD" : 'TX000001123', "KR" : '오전', "EN" : 'A.m.', "JP" : '午前', "CN" : '上午'},
				{"CD" : 'TX000001124', "KR" : '오후', "EN" : 'P.m.', "JP" : '午後', "CN" : '下午'},
				{"CD" : 'TX000001179', "KR" : '수정', "EN" : 'Adjustment', "JP" : '', "CN" : ''},
				{"CD" : 'TX000001226', "KR" : '전결', "EN" : 'Decide arbitrarily', "JP" : '', "CN" : ''},
				{"CD" : 'TX000001236', "KR" : '입력', "EN" : 'Save', "JP" : '', "CN" : ''},
				{"CD" : 'TX000001314', "KR" : '결재 특이사항', "EN" : 'Particular question or comment', "JP" : '決裁特記事項', "CN" : '审批特别事项'},
				{"CD" : 'TX000001653', "KR" : '인쇄', "EN" : 'Printing', "JP" : '印刷', "CN" : '打印'},
				{"CD" : 'TX000001773', "KR" : '수신처', "EN" : 'Receiving office', "JP" : '受信先', "CN" : '收信人'},
				{"CD" : 'TX000001845', "KR" : '결재취소중 에러가 발생하였습니다. 다시 시도해 주십시오.', "EN" : 'The error occurred during cancel the Approval . try again ', "JP" : '決裁の取り消し中にエラーが発生しました。もう一度行ってください。', "CN" : '审批取消时发生错误，请重试。'},
				{"CD" : 'TX000001981', "KR" : '삭제 하시겠습니까?', "EN" : 'Do you want to delete?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000002003', "KR" : '작업이 실패했습니다.', "EN" : 'The operation failed.', "JP" : '作業が失敗しました。', "CN" : '作业失败。'},
				{"CD" : 'TX000002073', "KR" : '저장되었습니다.', "EN" : 'Has been saved.', "JP" : '保存されました。', "CN" : '已保存。'},
				{"CD" : 'TX000002106', "KR" : '삭제에 실패하였습니다.', "EN" : 'Delete is failed', "JP" : '', "CN" : ''},
				{"CD" : 'TX000002121', "KR" : '삭제 되었습니다.', "EN" : 'Removed', "JP" : '削除されました。', "CN" : '已删除'},
				{"CD" : 'TX000002286', "KR" : '제목을 입력하세요', "EN" : 'Enter the title', "JP" : '', "CN" : ''},
				{"CD" : 'TX000002522', "KR" : '에러가 발생되었습니다. 관리자에게 문의하세요.', "EN" : 'Find a error. request to the manager', "JP" : 'エラーが発生しました。管理者に問い合わせてください。', "CN" : '发生了错误，请向管理员问询。'},
				{"CD" : 'TX000002531', "KR" : '에러가 발생되었습니다!', "EN" : 'Error', "JP" : 'エラーが発生しました！', "CN" : '发生了错误！'},
				{"CD" : 'TX000002605', "KR" : '비밀번호가 일치하지 않습니다.', "EN" : 'Password is not correct', "JP" : 'パスワードが一致しません。', "CN" : '密码不一致'},
				{"CD" : 'TX000002866', "KR" : '회계단위', "EN" : 'Accounting unit', "JP" : '会計単位', "CN" : '会计主体'},
				{"CD" : 'TX000002947', "KR" : '취소', "EN" : 'Cancel', "JP" : '', "CN" : ''},
				{"CD" : 'TX000002948', "KR" : '시행자리스트', "EN" : 'The list of operator', "JP" : '施行者リスト', "CN" : '执行者名单'},
				{"CD" : 'TX000002949', "KR" : '대결', "EN" : 'Decide for ', "JP" : '代決', "CN" : '代批'},
				{"CD" : 'TX000002954', "KR" : '반려', "EN" : 'Return', "JP" : '', "CN" : ''},
				{"CD" : 'TX000002958', "KR" : '결의서', "EN" : 'An act ', "JP" : '承認書', "CN" : '决议书'},
				{"CD" : 'TX000002986', "KR" : '마이페이지', "EN" : 'My page', "JP" : 'マイページ', "CN" : '我的网页'},
				{"CD" : 'TX000003031', "KR" : '품의서', "EN" : 'Consultation', "JP" : '稟議書', "CN" : '申请书'},
				{"CD" : 'TX000003207', "KR" : '공문발송', "EN" : 'Sent an official letter', "JP" : '公文書送信', "CN" : '发送公文'},
				{"CD" : 'TX000003209', "KR" : '수신참조리스트', "EN" : 'The list of receive reference', "JP" : '受信参照リスト', "CN" : '收信参考一览'},
				{"CD" : 'TX000003211', "KR" : '기안작성', "EN" : 'Written draft', "JP" : '起案作成', "CN" : '创建草稿'},
				{"CD" : 'TX000003272', "KR" : '이상', "EN" : 'Greater', "JP" : '以上', "CN" : '异常'},
				{"CD" : 'TX000003402', "KR" : '비공개', "EN" : 'Classified', "JP" : '非公開', "CN" : '非公开'},
				{"CD" : 'TX000003515', "KR" : '지출', "EN" : 'Expense', "JP" : '支出', "CN" : '支出'},
				{"CD" : 'TX000003537', "KR" : '귀속년월', "EN" : 'Belonged mm/yy', "JP" : '帰属年月', "CN" : '所属年月'},
				{"CD" : 'TX000003541', "KR" : '지급총액', "EN" : 'Total payment', "JP" : '支給総額', "CN" : '支出总额'},
				{"CD" : 'TX000003620', "KR" : '계좌번호', "EN" : 'Account number', "JP" : '', "CN" : ''},
				{"CD" : 'TX000003621', "KR" : '예금주', "EN" : 'Depositor', "JP" : '預金者', "CN" : '户名'},
				{"CD" : 'TX000000026', "KR" : '대표자명', "EN" : 'CEO name', "JP" : '代表者名', "CN" : '代表名'},
				{"CD" : 'TX000000375', "KR" : '주소', "EN" : 'Address', "JP" : '住所', "CN" : '地址'},
				{"CD" : 'TX000000006', "KR" : '전화', "EN" : 'Telephone', "JP" : '電話', "CN" : '电话'},				
				{"CD" : 'TX000003625', "KR" : '관', "EN" : 'Level1', "JP" : '管', "CN" : '款  '},
				{"CD" : 'TX000003626', "KR" : '항', "EN" : 'Level2', "JP" : '項', "CN" : '项'},
				{"CD" : 'TX000003627', "KR" : '목', "EN" : 'Level3', "JP" : '目', "CN" : '目'},
				{"CD" : 'TX000003628', "KR" : '세', "EN" : 'Level4', "JP" : '細', "CN" : '细'},
				{"CD" : 'TX000003641', "KR" : '일', "EN" : 'Sunday', "JP" : '日', "CN" : '日'},
				{"CD" : 'TX000003642', "KR" : '월', "EN" : 'Monday', "JP" : '月', "CN" : '月'},
				{"CD" : 'TX000003801', "KR" : '표시', "EN" : 'Indicate', "JP" : '表示', "CN" : '显示'},
				{"CD" : 'TX000003814', "KR" : '승인예산', "EN" : 'Appoved budget', "JP" : '承認予算', "CN" : '批准预算'},
				{"CD" : 'TX000003863', "KR" : '처리 되었습니다.', "EN" : 'Process complete', "JP" : '処理が完了しました', "CN" : '已处理。'},
				{"CD" : 'TX000003977', "KR" : '결재취소되지 않았습니다. 다음결재자가 결재하셨습니다.', "EN" : 'Approval is not cancel. Next approver is done. ', "JP" : '決裁が取り消されませんでした。次の決裁者が決裁しました', "CN" : '没有取消审批。下一个审批人已经审批。'},
				{"CD" : 'TX000004025', "KR" : '메신저', "EN" : 'messenger', "JP" : 'メッセンジャー', "CN" : 'Messenger'},
				{"CD" : 'TX000004264', "KR" : '필요경비금액', "EN" : 'Expense amount', "JP" : '必要経費金額', "CN" : '所需经费额'},
				{"CD" : 'TX000004265', "KR" : '소득세액', "EN" : 'Income tax', "JP" : '所得税額', "CN" : '所得税额'},
				{"CD" : 'TX000004266', "KR" : '소득금액', "EN" : 'Income amount', "JP" : '所得金額', "CN" : '所得额'},
				{"CD" : 'TX000004267', "KR" : '주민세액', "EN" : 'Residence tax', "JP" : '住民税額', "CN" : '居民税额'},
				{"CD" : 'TX000004274', "KR" : '기타소득자', "EN" : 'Other income earners', "JP" : 'その他の所得者', "CN" : '其他所得者'},
				{"CD" : 'TX000004275', "KR" : '실수령액', "EN" : 'net receipts', "JP" : '実受領額', "CN" : '实际领取额'},
				{"CD" : 'TX000004276', "KR" : '원천징수액', "EN" : 'withholding amount', "JP" : '源泉徴収額', "CN" : '源泉扣缴额'},
				{"CD" : 'TX000004277', "KR" : '사업소득자', "EN" : 'business income earner', "JP" : '事業所得者', "CN" : '经营所得者'},
				{"CD" : 'TX000004385', "KR" : '상신취소 중 오류가 발생하였습니다. 다시 시도해 주세요.', "EN" : 'An error occurred while cancelling the report. Please try it again.', "JP" : '申請取り消し中エラーが発生しました。もう一度試みてください。', "CN" : '取消提交时发生错误。请重试。'},
				{"CD" : 'TX000004440', "KR" : '결재취소가 되었습니다.', "EN" : 'Approval is cancelled.', "JP" : '決裁を取り消しました。', "CN" : '已经取消了审批。'},
				{"CD" : 'TX000004441', "KR" : '결재취소 하시겠습니까?', "EN" : 'Do you want to cancel the approval?', "JP" : '決裁取り消しますか？', "CN" : '是否取消审批？'},
				{"CD" : 'TX000004447', "KR" : '회수처리 중 오류가 발생하였습니다. 다시 시도해 주세요.', "EN" : 'An error occurred during Collect process. Please try it again.', "JP" : '引戻し処理中にエラーが発生しました。再度試みてください。', "CN" : '回收处理时发生错误。请重试。'},
				{"CD" : 'TX000004610', "KR" : '은행명', "EN" : 'bank name', "JP" : '銀行名', "CN" : '银行名'},
				{"CD" : 'TX000004658', "KR" : '예산정보', "EN" : 'Budget information', "JP" : '予算情報', "CN" : '预算信息'},
				{"CD" : 'TX000004704', "KR" : '현금', "EN" : 'cash', "JP" : '現金', "CN" : '现金'},
				{"CD" : 'TX000004911', "KR" : '회수처리 하였습니다.', "EN" : 'Collect process is done.', "JP" : '回収処理しました。', "CN" : '回收处理。'},
				{"CD" : 'TX000005102', "KR" : '당초예산', "EN" : 'Initial budget', "JP" : '当初予算', "CN" : '期初预算'},
				{"CD" : 'TX000005103', "KR" : '최종예산', "EN" : 'Final budget', "JP" : '最終予算', "CN" : '最终预算'},
				{"CD" : 'TX000005104', "KR" : '품의결의금액', "EN" : 'consultation decision amount', "JP" : '稟議決裁金額', "CN" : '请示决议金额'},
				{"CD" : 'TX000005105', "KR" : '품의승인금액', "EN" : 'consultation approval amount', "JP" : '稟議承認金額', "CN" : '请示批准金额'},
				{"CD" : 'TX000005106', "KR" : '집행결의금액', "EN" : 'execution decision amount', "JP" : '執行決裁金額', "CN" : '执行决议金额'},
				{"CD" : 'TX000005107', "KR" : '집행승인금액', "EN" : 'execution approval amount', "JP" : '執行承認金額', "CN" : '执行审批金额'},
				{"CD" : 'TX000005263', "KR" : '예산계정', "EN" : 'budget account', "JP" : '予算アカウント', "CN" : '预算科目'},
				{"CD" : 'TX000005265', "KR" : '프로젝트 코드', "EN" : 'Project code', "JP" : 'プロジェクトコード', "CN" : '项目编码'},
				{"CD" : 'TX000005266', "KR" : '하위사업 코드', "EN" : 'children business code', "JP" : '下位事業コード', "CN" : '下级事业编码'},
				{"CD" : 'TX000005267', "KR" : '부서 코드', "EN" : 'department code', "JP" : '部署コード', "CN" : '部门编码'},
				{"CD" : 'TX000005269', "KR" : '예산사업장 코드', "EN" : 'budget workplace code', "JP" : '予算事業所コード', "CN" : '预算分公司编码'},
				{"CD" : 'TX000005270', "KR" : '거래처 코드', "EN" : 'client code', "JP" : '取引先コード', "CN" : '往来方编码'},
				{"CD" : 'TX000005271', "KR" : '사원 코드', "EN" : 'employee code', "JP" : '社員コード', "CN" : '职员编码'},
				{"CD" : 'TX000005272', "KR" : '기타소득자 코드', "EN" : 'other income eraner code', "JP" : 'その他所得者コード', "CN" : '其他所得者编码'},
				{"CD" : 'TX000005273', "KR" : '금융기관 코드', "EN" : 'Financial instiution code', "JP" : '金融機関コード', "CN" : '金融机构编码'},
				{"CD" : 'TX000005274', "KR" : '입출금계좌 코드', "EN" : 'deposit/withdraw account code', "JP" : '入出金口座コード', "CN" : '收付款账户编码'},
				{"CD" : 'TX000005280', "KR" : '은행코드', "EN" : 'Bank code', "JP" : '銀行コード', "CN" : '银行编码'},
				{"CD" : 'TX000005295', "KR" : '수입', "EN" : 'Income  ', "JP" : '収入', "CN" : '收入'},
				{"CD" : 'TX000005299', "KR" : '대표자성명', "EN" : 'name of CEO', "JP" : '代表者名', "CN" : '代表人姓名'},
				{"CD" : 'TX000005301', "KR" : '회계구분명', "EN" : 'Accounting type name', "JP" : '会計区分名', "CN" : '会计类型名'},
				{"CD" : 'TX000005306', "KR" : '소득자명', "EN" : 'income earner’s name', "JP" : '所得者名', "CN" : '所得者名'},
				{"CD" : 'TX000005330', "KR" : '소득구분', "EN" : 'Income type', "JP" : '所得区分', "CN" : '所得类型'},
				{"CD" : 'TX000005379', "KR" : '카드거래처', "EN" : 'Credit card client', "JP" : 'カード取引先', "CN" : '卡往来方'},
				{"CD" : 'TX000005400', "KR" : '기타', "EN" : 'others', "JP" : '', "CN" : ''},
				{"CD" : 'TX000005402', "KR" : '프로젝트를 선택해주세요.', "EN" : 'Select projects.', "JP" : 'プロジェクトを選択して下さい', "CN" : '请选择项目。'},
				{"CD" : 'TX000005457', "KR" : '승인일자', "EN" : 'date of approval', "JP" : '承認日', "CN" : '批准日期'},
				{"CD" : 'TX000005458', "KR" : '사용내역', "EN" : 'use details', "JP" : '使用内訳', "CN" : '使用内容'},
				{"CD" : 'TX000005488', "KR" : 'PDF문서를 보시려면 Acrobat Reader를 설치하셔야 합니다.', "EN" : 'Acrobat Reader to view PDF documents you will need to install.', "JP" : 'PDF文書を見ようとすれば Acrobat Readerを設置しなければなりません。', "CN" : '查看PDF文件需要安装Acrobat Reader。'},
				{"CD" : 'TX000005498', "KR" : '본문수정이력', "EN" : 'The body modification history', "JP" : '本文修正履歴', "CN" : '正文修改历史'},
				{"CD" : 'TX000005531', "KR" : '기타공제액', "EN" : 'other amount deducted', "JP" : 'その他控除額', "CN" : '其他抵扣额'},
				{"CD" : 'TX000005550', "KR" : '일정관리', "EN" : 'Calendar', "JP" : 'スケジュール管理', "CN" : '日程管理'},
				{"CD" : 'TX000005555', "KR" : '미결함', "EN" : 'In Tray box', "JP" : '未決トレイ', "CN" : '待批箱'},
				{"CD" : 'TX000005560', "KR" : '수신참조함', "EN" : 'Reference received', "JP" : '受信参照トレイ', "CN" : '抄送箱'},
				{"CD" : 'TX000005735', "KR" : '부가세구분', "EN" : 'VAT type', "JP" : '付加価値税区分', "CN" : '增值税类型'},
				{"CD" : 'TX000005771', "KR" : '초기화 되었습니다', "EN" : 'Initialization is completed.', "JP" : '初期化しました。', "CN" : '初始化成功。'},
				{"CD" : 'TX000005795', "KR" : '카드', "EN" : 'Card', "JP" : '', "CN" : ''},
				{"CD" : 'TX000005802', "KR" : '불공제구분', "EN" : 'no tax deduction type', "JP" : '不控除区分', "CN" : '不抵扣类型'},
				{"CD" : 'TX000005960', "KR" : '수신자', "EN" : 'receiver', "JP" : '', "CN" : ''},
				{"CD" : 'TX000006373', "KR" : '결재자가 결재하여 삭제할수 없습니다.', "EN" : 'You can not delete this because approvers already approved it.', "JP" : '決裁者が決裁したため削除することができません。', "CN" : '审批人已审批，不能删除。'},
				{"CD" : 'TX000006379', "KR" : '결재자가 문서를 열람하여 상신취소할수 없습니다.', "EN" : 'You can not cancel the report since approvers already read the documents.', "JP" : '決裁者が文書を閲覧したため、上申の取り消しをすることができません。', "CN" : '审批人已读文件，不能取消提交。'},
				{"CD" : 'TX000006380', "KR" : '결재자가 결재하여 상신취소할수 없습니다.', "EN" : 'You can not cancel the report since approvers already approved the documents.', "JP" : '決裁者が決裁して上申の取り消しをすることができません。', "CN" : '审批人已审批，不能取消提交。'},
				{"CD" : 'TX000006381', "KR" : '회수 하시겠습니까?', "EN" : 'Do you want to collect it?', "JP" : '回収しますか?', "CN" : '是否回收？'},
				{"CD" : 'TX000006382', "KR" : '접수확인 하시겠습니까?', "EN" : 'Do you want to check the acceptance?', "JP" : '受付確認しますか?', "CN" : '是否接收确认？'},
				{"CD" : 'TX000006383', "KR" : '접수반려 하시겠습니까?', "EN" : 'Do you want to return the acceptance?', "JP" : '受付返戻しますか?', "CN" : '是否接收退回？'},
				{"CD" : 'TX000006385', "KR" : '결재문서', "EN" : 'approval document', "JP" : '決裁文書', "CN" : '审批文件'},
				{"CD" : 'TX000006545', "KR" : '일요일', "EN" : 'Sunday', "JP" : '日曜日', "CN" : '星期日'},
				{"CD" : 'TX000006546', "KR" : '월요일', "EN" : 'Monday', "JP" : '月曜日', "CN" : '星期一'},
				{"CD" : 'TX000006547', "KR" : '화요일', "EN" : 'Tuesday', "JP" : '火曜日', "CN" : '星期二'},
				{"CD" : 'TX000006548', "KR" : '수요일', "EN" : 'Wednesday', "JP" : '水曜日', "CN" : '星期三'},
				{"CD" : 'TX000006549', "KR" : '목요일', "EN" : 'Thursday', "JP" : '木曜日', "CN" : '星期四'},
				{"CD" : 'TX000006550', "KR" : '금요일', "EN" : 'Friday', "JP" : '金曜日', "CN" : '星期五'},
				{"CD" : 'TX000006621', "KR" : '첨부파일보기', "EN" : 'view attached files', "JP" : '添付ファイル表示', "CN" : '查看附件'},
				{"CD" : 'TX000007033', "KR" : '시스템설정', "EN" : 'set system', "JP" : 'システム設定', "CN" : '系统设置'},
				{"CD" : 'TX000007046', "KR" : '시행처리 하시겠습니까?', "EN" : 'Do you wish to execute?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000007047', "KR" : '시행처리 하였습니다.', "EN" : 'Executed.', "JP" : '施行処理しました。', "CN" : '已执行处理。'},
				{"CD" : 'TX000007048', "KR" : '시행처리 중 오류가 발생하였습니다. 다시 시도해 주세요.', "EN" : 'An error has occurred during the execution. Please try again.', "JP" : '施行処理の中でエラーが発生しました。リトライしてください。', "CN" : '执行处理中发生错误。请重试。'},
				{"CD" : 'TX000007111', "KR" : '대면결재 요청', "EN" : 'Request for walk-in approval.', "JP" : '対面決裁要請', "CN" : '当面审批申请'},
				{"CD" : 'TX000007147', "KR" : '회람확인 하시겠습니까?', "EN" : 'Do you wish to check viewer?', "JP" : '回?確認しますか？', "CN" : '确认浏览吗?'},
				{"CD" : 'TX000007148', "KR" : '회람확인 하였습니다.', "EN" : 'Viewers have been checked.', "JP" : '回?確認しました。', "CN" : '已确认浏览。'},
				{"CD" : 'TX000007149', "KR" : '회람확인 중 오류가 발생하였습니다. 다시 시도해 주세요.', "EN" : 'An error has occurred while checking viewers. Please try again.', "JP" : '回?確認中にエラ?が?生しました。もう一度?行してください。', "CN" : '确认浏览过程中发生了错误，请重试。'},
				{"CD" : 'TX000007200', "KR" : '사업계획', "EN" : 'Business plan', "JP" : '', "CN" : ''},
				{"CD" : 'TX000007201', "KR" : '예산단위', "EN" : 'Budget unit', "JP" : '', "CN" : ''},
				{"CD" : 'TX000007424', "KR" : '협조전 리스트', "EN" : 'List of disposition form', "JP" : '', "CN" : ''},
				{"CD" : 'TX000007548', "KR" : '코스트센터', "EN" : 'Cost center', "JP" : '', "CN" : ''},
				{"CD" : 'TX000007942', "KR" : '분류선택', "EN" : 'Selection of classification', "JP" : '', "CN" : ''},
				{"CD" : 'TX000008120', "KR" : '오류가 발생하였습니다', "EN" : 'The error occurred', "JP" : '', "CN" : ''},
				{"CD" : 'TX000008177', "KR" : '반송', "EN" : 'Sending back', "JP" : '', "CN" : ''},
				{"CD" : 'TX000008484', "KR" : '보안문서', "EN" : 'Security document', "JP" : 'セキュリティ文書', "CN" : '安全文件'},
				{"CD" : 'TX000008627', "KR" : '문서', "EN" : 'Document', "JP" : '', "CN" : ''},
				{"CD" : 'TX000008634', "KR" : '필수 기본항목 닫기', "EN" : 'Closing the essential basic item', "JP" : '', "CN" : ''},
				{"CD" : 'TX000008635', "KR" : '필수 기본항목 열기', "EN" : 'Opening the essential basic item', "JP" : '', "CN" : ''},
				{"CD" : 'TX000008754', "KR" : '열람지정처리 실패하였습니다.', "EN" : 'It has been failed to process the designation of reading.', "JP" : '閲覧指定に失敗しました。', "CN" : '处理指定阅览失败。'},
				{"CD" : 'TX000008755', "KR" : '열람지정 처리 되었습니다.', "EN" : 'The designation of reading has been processed.', "JP" : '閲覧が指定されました。', "CN" : '已处理指定阅览。'},
				{"CD" : 'TX000008823', "KR" : '기록물철을 선택해 주세요', "EN" : 'Select document files.', "JP" : 'ファイリングを選択してください。', "CN" : '请选择记录物簿。'},
				{"CD" : 'TX000009031', "KR" : '문서를 선택해주세요', "EN" : 'Please select the document.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009192', "KR" : '외상', "EN" : 'Credit', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009199', "KR" : '감춤', "EN" : 'Hiding', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009200', "KR" : '입출일자', "EN" : 'Date of revenue and expenditure.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009201', "KR" : '결의서일자', "EN" : 'Date of resolution letter.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009202', "KR" : '현금집행', "EN" : 'Enforcement of cash', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009203', "KR" : '승인집행', "EN" : 'Enforcement of approval', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009204', "KR" : '결의집행', "EN" : 'Enforcement of resolution', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009208', "KR" : '부분공개/비공개 여부는 구분번호를 선택해야 합니다', "EN" : 'The disclosure, nondisclosure of part or not should select the classification number.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009209', "KR" : '반려의견', "EN" : 'Opinion of rejection', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009212', "KR" : '결재라인에', "EN" : 'In the approval line', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009214', "KR" : '자 한글은', "EN" : 'Charter Korean', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009215', "KR" : '영문은', "EN" : 'English', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009217', "KR" : '년월일은 필수 입력항목입니다', "EN" : 'The year, month and date are the essential input item.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009221', "KR" : '권장 버전', "EN" : 'Recommended version', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009223', "KR" : '보안해제 되었습니다', "EN" : 'The security has been released.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009224', "KR" : '보안설정 되었습니다', "EN" : 'The security has been set.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009225', "KR" : '보안설정 하시겠습니까?', "EN" : 'Would you set the security?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009226', "KR" : '보안설정된 문서입니다 보안해제 하시겠습니까?', "EN" : 'It is the document that the security has been set. Would you release the security?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009227', "KR" : '재편철 시도중 에러가 발생하였습니다', "EN" : 'The error occurred while trying the rekeeping on file.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009228', "KR" : '재편철 완료되었습니다', "EN" : 'The rekeeping on file has been completed.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009232', "KR" : '삭제된 문서는 열수 없습니다', "EN" : 'The removed document cannot be open.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009236', "KR" : '첨부파일 포함', "EN" : 'Inclusion of attached file', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009237', "KR" : '기존 결재선정보', "EN" : 'Information for the existing approval line.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009238', "KR" : '재기안', "EN" : 'Redraft', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009240', "KR" : '원본 기안문서정보', "EN" : 'Information for the original security document.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009241', "KR" : '문서는 1개만 선택해주세요', "EN" : 'Select 1 document.', "JP" : '文書を１本だけ選択してください。', "CN" : '请选择一个文件。'},
				{"CD" : 'TX000009230', "KR" : '긴급문서', "EN" : 'Urgent document', "JP" : '緊急文書', "CN" : '紧急文件'},
				{"CD" : 'TX000009378', "KR" : '카드가 선택되지 않았습니다', "EN" : 'The card has not been selected.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009394', "KR" : '표준적요 또는 증빙유형이 선택되지 않았습니다', "EN" : 'The standard abstract or evidence form has not been selected.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009395', "KR" : '결재 의견을 입력해주세요', "EN" : 'Please input the approval opinion.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009409', "KR" : '상신취소 되었습니다', "EN" : 'The report has been cancelled.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009413', "KR" : '필요경비율', "EN" : 'Necessary expenses rate', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009415', "KR" : '삭제 도중 오류가 발생하였습니다. 관리자에게 문의하세요', "EN" : 'The error occurred during the deletion. Please contact the manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009416', "KR" : '예산을 선택하세요', "EN" : 'Please select the budget.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009417', "KR" : '예산별 품의잔액 :', "EN" : 'Balance of consultation by the budget:', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009418', "KR" : '결의금액과 명세서금액이 다릅니다', "EN" : 'The resolved amount and the amount of statement are different.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009419', "KR" : '거래처 정보를 입력해주세요', "EN" : 'Please input the client information.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009420', "KR" : '금액이 없는 예산이 있습니다. 확인해주세요', "EN" : 'There is the budget without the amount. Please identify.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009421', "KR" : '예산 정보를 입력해주세요', "EN" : 'Please input the budget information.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009425', "KR" : '과세구분 변경시 채주의 공급가액부가세 데이터는 변경되지 않음으로 반드시 확인 바랍니다', "EN" : 'Please identify without fail as the additional tax data of supply value of creditor is not changed at time of changing the tax classification.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009426', "KR" : '채주값이 등록되어 성격이 다른 채주유형으로 변경이 불가능합니다. 채주값을 삭제후 변경바랍니다', "EN" : 'The change of character to the different creditor form is impossible as the value of creditor has been registered. Please change after deleting the value of creditor.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009427', "KR" : '{0}일자로 결의서 입력이 마감되었습니다', "EN" : 'The input of resolution letter has been closed as of {0} date.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009430', "KR" : '등록되지 않은 양식입니다. 관리자에게 문의 바랍니다', "EN" : 'It is not the registered form. Please contact the manager. ', "JP" : '未登録の形式です。管理者にお問い合わせください。', "CN" : '没有登录的格式，请咨询管理者。'},
				{"CD" : 'TX000009431', "KR" : '작성자정보를 선택해 주세요', "EN" : 'Please select the preparer information.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009449', "KR" : '신청예산', "EN" : 'Applied budget', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009543', "KR" : '증빙유형이 선택되지 않았습니다', "EN" : 'The evidence form  has not been selected.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009544', "KR" : '표준적요가 선택되지 않았습니다', "EN" : 'The standard abstract has not been selected.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009545', "KR" : '사용자가 선택되지 않았습니다', "EN" : 'The user has not been selected.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009638', "KR" : '데이터가 없습니다', "EN" : 'No Data', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009659', "KR" : '인쇄이력', "EN" : 'Printing career', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009711', "KR" : '오류 메시지 : {0}', "EN" : 'Error message: {0}', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009901', "KR" : '오류가 발생하였습니다. 관리자에게 문의하세요', "EN" : 'The error occurred. Please contact the manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000009915', "KR" : '{0}자 까지 입력할 수 있습니다', "EN" : 'It can be input up to {0} characters.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000010113', "KR" : '확장기능', "EN" : 'Extension function', "JP" : '', "CN" : ''},
				{"CD" : 'TX000010151', "KR" : '업무관리', "EN" : 'Task management', "JP" : '', "CN" : ''},
				{"CD" : 'TX000010608', "KR" : '데이터가 존재하지 않습니다', "EN" : 'Data don’t exist', "JP" : 'データがありません。', "CN" : '不存在数据。'},
				{"CD" : 'TX000010779', "KR" : '정상적으로 저장 되었습니다', "EN" : 'It has been saved normally.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000010930', "KR" : '업무', "EN" : 'Task', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011075', "KR" : '메세지는 최대 {0}byte까지 입력 가능합니다', "EN" : 'The input of message is possible up to maximum {0} bytes.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011076', "KR" : '월을 바르게 입력하세요', "EN" : 'Please input the month correctly.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011077', "KR" : '일자를 바르게 입력하세요', "EN" : 'Please input the date correctly.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011078', "KR" : '년월일이 모두 입력되거나 모두 생략되어야 합니다', "EN" : 'The year, month and date all should be input or should be omitted all.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011099', "KR" : 'HwpCtrlGetTextFile이 정상적으로 동작하지 않는 버젼입니다', "EN" : 'HwpCtrlGetTextFile is the version that doesn’t work normally.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011100', "KR" : '초기화 오류입니다', "EN" : 'It is the error of initialization.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011101', "KR" : '초기화 실패입니다', "EN" : 'It is the failure of initialization.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011102', "KR" : '초기화 성공입니다', "EN" : 'It is the success of initialization.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011103', "KR" : '회계정보가 존재하지 않습니다', "EN" : 'The accounting information doesn’t exist.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011104', "KR" : '참조품의 결의서는 재기안 할수 없습니다', "EN" : 'The resolution letter of consultation of reference cannot be redrafted.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011105', "KR" : '재기안 하시겠습니까?', "EN" : 'Would you redraft?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011107', "KR" : '완료되었습니다', "EN" : 'It has been completed.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011108', "KR" : '연동문서는 삭제가 불가능합니다', "EN" : 'The deletion of interlocking document is impossible.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011111', "KR" : '비전자', "EN" : 'Nonelectronic', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011112', "KR" : '삭제된 문서는 재기안 할 수 없습니다', "EN" : 'The deleted document cannot be redrafted.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011113', "KR" : '보안문서는 기안자와 결재라인의 사용자만 재기안 할수 있습니다', "EN" : 'The drafter and the user of approval line only redraft the security document.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011116', "KR" : '열람대상자', "EN" : 'Person of reading object', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011117', "KR" : '문서오류입니다', "EN" : 'It is the document error.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011118', "KR" : '대외문서는 첨부파일크기가 {0}M 이하여야 합니다', "EN" : 'The size of attached file of external document should be less than {0}M.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011119', "KR" : '기안문서가 없습니다. 관리자한테 문의하세요.', "EN" : 'There is no draft document. Please contact the manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011120', "KR" : '시스템 에러입니다. 관리자한테 문의 하세요.', "EN" : 'It is the system error. Please contact the manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011121', "KR" : '귀중', "EN" : 'Messrs.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011122', "KR" : '귀하', "EN" : 'Mr.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011123', "KR" : '경유지를 입력해주십시요', "EN" : 'Please input the land of stopover.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011124', "KR" : '민원인 Email은 {0}자이내로 입력해주십시요', "EN" : 'Please input the Email of civil petitioner within {0} characters.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011125', "KR" : '민원인명은 {0}자이내로 입력해주십시요', "EN" : 'Please input the number of people of civil complaint within {0} characters.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011126', "KR" : '민원인명을 입력해주십시요', "EN" : 'Please input the name of civil petitioner.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011127', "KR" : '주소를 지정해주십시요', "EN" : 'Please designate the address.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011128', "KR" : '우편번호를 지정해주십시요', "EN" : 'Please designate the zip code.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011129', "KR" : '문서취급을 선택해 주시기 바랍니다', "EN" : 'Please select the document handling.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011130', "KR" : '죄송합니다. 서비스 준비중입니다.', "EN" : 'Sorry. The service is in preparation.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011134', "KR" : '게시판', "EN" : 'Bulletin board', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011135', "KR" : '근태관리', "EN" : 'Management of diligence and laziness', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011137', "KR" : '대사우서비스', "EN" : 'Co-worker service', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011142', "KR" : '참조대상자', "EN" : 'Person of reference object', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011143', "KR" : '보고대상자', "EN" : 'Person of report object', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011147', "KR" : '법인카드연동', "EN" : 'Interlocking of corporate card.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011148', "KR" : '기록물 철을 선택하세요', "EN" : 'Please select the records folder.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011149', "KR" : '수신처를 지정해주십시요', "EN" : 'Please designate the destination.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011150', "KR" : '거래처 정보를 모두 보여줄 경우 시간이 오래 걸릴 수 있습니다. 계속 하시겠습니까?', "EN" : 'It may take a long time in case the information of client all is shown. Would you continue?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011151', "KR" : '사업장을 선택해주세요', "EN" : 'Please select the business place.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011160', "KR" : '프로젝트를 먼저 저장하세요', "EN" : 'Please save the project first.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011161', "KR" : '프로젝트를 저장하세요', "EN" : 'Please save the project.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011162', "KR" : '존재하지 않는 코드입니다', "EN" : 'It is the code that doesn’t exist.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011163', "KR" : '예산을 초과 하였습니다. 확인해주세요.', "EN" : 'It exceeded the budget. Please identify.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011165', "KR" : '사업소득자 코드', "EN" : 'Code of business income earner', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011166', "KR" : '사원코드 코드', "EN" : 'An employee code', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011167', "KR" : '관리내역 코드', "EN" : 'Code of management breakdown', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011168', "KR" : '부가세신고일을 8자리로 입력하세요(예 20161111 또는 20161112)', "EN" : 'Please input the declaration date of Value Added Tax as 8 characters. (e.g. 20161111 or 20161112)', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011172', "KR" : '분류3', "EN" : 'Classification 3', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011173', "KR" : '분류2', "EN" : 'Classification 2', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011174', "KR" : '분류1', "EN" : 'Classification 1', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011175', "KR" : '채주값이 등록되어 변경할수 없습니다. 채주값을 삭제후 변경바랍니다.', "EN" : 'The value of creditor cannot be changed. Please change after deleting the value of creditor.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011181', "KR" : '예금', "EN" : 'Deposit', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011187', "KR" : '거래처 명', "EN" : 'Name of client', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011188', "KR" : '하위사업 명', "EN" : 'Name of low rank business', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011191', "KR" : '사업장 명', "EN" : 'Name of business place', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011192', "KR" : '사업장 코드', "EN" : 'Code of business place', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011195', "KR" : '예산환원취소 하시겠습니까?', "EN" : 'Would you cancel the budget reduction?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011196', "KR" : '예산환원 하시겠습니까?', "EN" : 'Would you reduce the budget?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011197', "KR" : '{0}일자로 결의서 입력이 마감되었습니다. 마감일자 이후에 작성하세요', "EN" : 'The resolution letter has been closed as of {0} date. Please prepare after the closing date.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011208', "KR" : '상세정보를 입력해 주세요', "EN" : 'Please input the detailed information.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011209', "KR" : '입력되지 않은 값이 있습니다. 확인해주세요.', "EN" : 'There is the value that is not input. Please identify.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011210', "KR" : '권장 버전: {0} 이상', "EN" : 'Recommended version: more than {0}', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011213', "KR" : '현재 버전: {0}', "EN" : 'Current version: {0}', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011214', "KR" : '최신 버젼으로 업데이트하기를 권장합니다', "EN" : 'It is recommended to update as the latest version.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011215', "KR" : 'HwpCtrl의 버젼이 낮아서 정상적으로 동작하지 않을 수 있습니다', "EN" : 'It may not work normally as the version of HwpCtrl is low.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011217', "KR" : '처리 하였습니다', "EN" : 'It has been processed.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011218', "KR" : '팝업을 해제해 주세요', "EN" : 'Disable pop up.', "JP" : 'ポップアップを解除してください。', "CN" : '请解除弹出窗口。'},
				{"CD" : 'TX000011219', "KR" : '첨부파일 오류입니다', "EN" : 'It is the error of attached file.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011220', "KR" : '기록물철을 선택하세요', "EN" : 'Please select the records folder.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011221', "KR" : '협의자가 너무많습니다', "EN" : 'There are so many consulters.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011222', "KR" : '결재자가 너무많습니다', "EN" : 'There are so many approvers.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011223', "KR" : '사용자 속성값 오류입니다', "EN" : 'It is the error of property value of user.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011224', "KR" : '결재라인이 없습니다', "EN" : 'There is no approval line.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011225', "KR" : '문서명이 없습니다', "EN" : 'There is no name of document.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011226', "KR" : '처리하였습니다', "EN" : 'It has been processed.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011227', "KR" : '본인 의견만 삭제 가능합니다', "EN" : 'Deletion of his or her own opinion only may be possible.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011228', "KR" : '의견이 삭제되었습니다', "EN" : 'The opinion has been deleted.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011230', "KR" : '비밀번호 오류입니다', "EN" : 'It is the password error.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011231', "KR" : '다음 결재 문서가 있습니다. 결재 하시겠습니까?', "EN" : 'There is the approval document next. Would you approve?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011235', "KR" : '증명서가 없습니다. 관리자한테 문의하세요.', "EN" : 'There is no certificate. Please contact the manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011237', "KR" : '부분공개', "EN" : 'Partial disclosure', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011238', "KR" : '수신자 참조', "EN" : 'Reference of receiver', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011239', "KR" : '내부결재', "EN" : 'Internal approval', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011240', "KR" : '본문 수정내역이 있습니다. 수정내역을 입력하시고 결재하시겠습니까?', "EN" : 'There is the breakdown of revision of text. Would you input the breakdown of revision and approve?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011241', "KR" : '본문 수정내역이 있습니다. 수정내역을 입력하시고 저장하시겠습니까?', "EN" : 'There is the breakdown of revision of text. Would you input the breakdown of revision and save?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011242', "KR" : '대외문서는 첨부파일크기는 {0}M 이하여야 합니다', "EN" : 'The size of attached file of external document should be less than {0}M.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011244', "KR" : '사인 종류를 선택하세요', "EN" : 'Please select the kind of signature.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011245', "KR" : '의견있음', "EN" : 'There is the opinion.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011246', "KR" : '결재완료 전에는 관인삽입이 불가능합니다', "EN" : 'The insertion of official seal before the completed approval is impossible.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011247', "KR" : '관인을 삽입하시겠습니까?', "EN" : 'Would you insert the official seal?', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011248', "KR" : '(결재선소유자 열람)', "EN" : '(Reading of owner in the approval line)', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011249', "KR" : '결재비밀번호가 없습니다', "EN" : 'There is no password of approval.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011250', "KR" : '결재라인에 {0}은(는) 재직중이 아닙니다. 확인 해주세요.', "EN" : '{0} is not in office in approval line. Please identify.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011251', "KR" : '결재 특이 사항을 입력하세요', "EN" : 'Please input the peculiar point of approval.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011252', "KR" : '문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.', "EN" : 'The error occurred at time of saving the document. Please contact the system manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011253', "KR" : '파일 오픈실패', "EN" : 'Failure to open the file', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011254', "KR" : '메모명이 없습니다', "EN" : 'There is no name of memo.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011255', "KR" : '문서 코드가 없습니다', "EN" : 'There is no document code.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011256', "KR" : '의견이 저장되었습니다', "EN" : 'The opinion has been saved.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011257', "KR" : '첨부파일닫기', "EN" : 'Closing the attached file.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011258', "KR" : '공개여부를 체크해 주십시요', "EN" : 'Please check the disclosure or not.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011259', "KR" : '문서제목에 아래 예의 특수문자가 포함되어 있습니다 예) {0}', "EN" : 'The special character of below example is included in the title of document. Example) {0}', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011260', "KR" : '문서제목에 엔터키가 포함되어 있습니다', "EN" : 'The enter key is included in the title of document.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011261', "KR" : '문서제목을 입력하여 주십시오', "EN" : 'Please input the title of document.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011262', "KR" : '결재라인을 지정하세요', "EN" : 'Please designate the approval line.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000011947', "KR" : '감사', "EN" : "Auditor", "JP" : '監事', "CN" : '谢谢'},
				{"CD" : 'TX000011997', "KR" : '시행처리 중 오류가 발생하였습니다 다시 시도해 주세요', "EN" : 'The error occurred while processing the implementation. Please try again.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000012068', "KR" : '적요가 입력되지 않았습니다', "EN" : 'The abstract has not been input.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000014883', "KR" : '선택된 사용자가 없습니다.', "EN" : 'There is no selected user.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000015937', "KR" : '부서 명', "EN" : 'Name of department', "JP" : '', "CN" : ''},
				{"CD" : 'TX000015938', "KR" : '프로젝트 명', "EN" : 'Name of project', "JP" : '', "CN" : ''},
				{"CD" : 'TX000015980', "KR" : '수행중 오류가 발생하였습니다.', "EN" : 'The error occurred while performing.', "JP" : '遂行中、エラーが発生しました。', "CN" : '执行中发生错误。'},
				{"CD" : 'TX000016117', "KR" : '처리에 실패하였습니다.', "EN" : 'It has been failed to process.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016502', "KR" : '삭제후 복구할수 없습니다', "EN" : 'It cannot be restored after the deletion', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016504', "KR" : '본문 html파일을 확인해 주세요', "EN" : 'Please identify the html file of text.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016544', "KR" : '전자결재(영리)', "EN" : 'Electronic approval (profit)', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016545', "KR" : '영문은 {0}자, 한글은 {1}자 까지 입력할 수 있습니다.', "EN" : 'The English up to {0} character, Korean up to {1) character may be input.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016546', "KR" : '메일 ID변경시 오류가 발생하였습니다.　관리자에게 문의해주시기 바랍니다.', "EN" : 'The error occurred at time of changing mail ID. Please contact the manager.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016571', "KR" : '비공개대상정보', "EN" : 'Explanation on closed information', "JP" : '非公開対象情報説明', "CN" : '非公开对象信息说明'},
				{"CD" : 'TX000016603', "KR" : '찾는값은 존재하지 않는 값입니다', "EN" : 'The seeking value is the value that doesn’t exist.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016604', "KR" : '지출결의 설정 값이 존재하지 않으므로 미작동할 수 있습니다', "EN" : 'It may be non-functioned as the setting value of expenditure resolution doesn’t exist.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016606', "KR" : '이 전달되지 않았습니다.', "EN" : 'It has not been transmitted.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000016613', "KR" : 'type 구분을 다시 확인해 주세요', "EN" : 'Please identify the classification of type again.', "JP" : '', "CN" : ''},
				{"CD" : 'TX000017313', "KR" : '반려', "EN" : "Rejection", "JP" : '差し戻し', "CN" : '退回'},
				{"CD" : 'TX000017813', "KR" : 'ERP사원정보가 없습니다. 관리자에게 문의 바랍니다', "EN" : "There's no ERP staff information. Please contact the manager.", "JP" : 'ERP社員情報がありません。管理者にお問い合わせください。', "CN" : '没有ERP职员信息，请咨询管理者。'},
				{"CD" : 'TX000017814', "KR" : 'ERP사원정보가 올바르지 않습니다. 관리자에게 문의 바랍니다.', "EN" : 'ERP staff information is not proper. Pleasse contact the manager.', "JP" : 'ERP社員の情報が正しくありません。管理者にお問い合わせください。', "CN" : 'ERP职员信息不正确，请咨询管理者。'},
				{"CD" : 'TX000017824', "KR" : '명세서등록 금액', "EN" : 'Amount registered in the detailed statement', "JP" : '明細書登録の金額', "CN" : '明细表登录金额'},
				{"CD" : 'TX000019537', "KR" : '한글 양식은 ie 브라우져에서만 작성할수 있습니다.', "EN" : 'HWP format can only be create in ie browser.', "JP" : 'ハングル様式はieブラウザでのみ作成できます。', "CN" : '韩文样式只有在ie浏览器上才能编写。'},
				{"CD" : 'TX000019538', "KR" : '한글 ActiveX 설치되어 있지 않아 작성할수 없습니다.', "EN" : 'It is unable to create as HWP ActiveX is not installed. ', "JP" : 'ハングルActiveXが設置されてないため作成できます。', "CN" : '没有安装韩文ActiveX，因此无法编写。'},
				{"CD" : 'TX000019539', "KR" : '한글 ActiveX 설치되어 있지 않아 뷰어로 확인 됩니다.', "EN" : 'It can be viewed from a viewer as HWP ActiveX is not installed. ', "JP" : 'ハングルActiveXが設置されていないためビューアーで確認します', "CN" : '没有安装韩文ActiveX，只能以查看器确认。'},
				{"CD" : 'TX000019541', "KR" : '뷰어에서는 PC저장을 지원하지 않습니다.', "EN" : 'Viewer does not support saving in PC.', "JP" : 'ビューアーではPC保存をサポートしません。', "CN" : '在查看器上不支持PC保存。'},
				{"CD" : 'TX000019542', "KR" : 'Html 본문 파일이 없습니다. 확인해주시기 바랍니다.', "EN" : 'Html file does not exist. Please check.', "JP" : 'Htmlの本文ファイルがありません。確認してください。', "CN" : '没有Html本文文件，请确认。'},
				{"CD" : 'TX000020518', "KR" : '삭제된 문서는 열람지정 할수 없습니다', "EN" : 'You can not browse the deleted documents.', "JP" : '削除された文書は、閲覧指定できません', "CN" : '删除的文件不能指定阅览。'},
				{"CD" : 'TX000020519', "KR" : '한글문서는 ie 에서만 재기안할수있습니다.', "EN" : 'Select the name of sender.', "JP" : 'ハングルの文書は、ieのみ再起案できます。', "CN" : '韩文文件只能在ie上才可以再申请。'},
				{"CD" : 'TX000020840', "KR" : '발신인명을 선택해 주세요', "EN" : 'Select the name of sender.', "JP" : '発信人名を選択してください', "CN" : '请选择发件人名。'},
				{"CD" : 'TX000020861', "KR" : '무', "EN" : 'Not exist', "JP" : '', "CN" : ''},
				{"CD" : 'TX000020862', "KR" : '유', "EN" : 'Exist', "JP" : '', "CN" : ''},
				{"CD" : 'TX000020863', "KR" : '필수 기본항목 수정을 취소 하시겠습니까? \n변경된 내용은 저장 되지 않습니다.', "EN" : 'Will you cancel the changes in required basic items? \nThe changed content will not be saved.', "JP" : '必須の基本項目の修正をキャンセルしますか。 \n変更された内容は保存されません。', "CN" : ''},
				{"CD" : 'TX000020864', "KR" : '결재진행중인 문서는 삭제가 불가능합니다', "EN" : 'Document in the middle of approval process cannot be deleted.', "JP" : '決裁進行中の文書は削除できません', "CN" : ''},
				{"CD" : 'TX000020865', "KR" : '감사문서', "EN" : 'Audit documents', "JP" : '監査文書', "CN" : ''},
				{"CD" : 'TX000020866', "KR" : 'ie가 아닌 브라우저에서는 뷰어로 확인됩니다', "EN" : 'If you use a browser, not ie, you can check document with Viewer.', "JP" : 'ieではないブラウザではビューアーで確認されます', "CN" : ''},
				{"CD" : 'TX000021124', "KR" : '본문영역이 구분된 양식이 아닙니다.', "EN" : 'Choose official seals to discard.', "JP" : '廃棄処理する官人を選択してください。', "CN" : '请选择要废除的公章。'},
				{"CD" : 'TX000021125', "KR" : '전체 문서 보기로 제공됩니다.', "EN" : 'it will be provided as See All Documents.', "JP" : '文書全体を表示することに提供されます。', "CN" : '提供为查看全部文件形式。'}		
				
              ];
//console.log(langCode);
/** 
 * 옵션 value 가져오기 
 * @param optionId
 * @param compSeq
 * @returns {String}
 */
NeosUtil.getOptionValue = function( optionId, compSeq ) {
	var optionValue = "" ;

	try {
        $.ajax({
            type: "POST",
            url: "/ea/cmm/system/getOptionValue.do",
            async: false,
            datatype: "text",
            data: { optionId: optionId, compSeq: compSeq },
            success: function (data) {
            	optionValue =  data.optionValue;
            },
            error: function (XMLHttpRequest, textStatus) {

            }
        });
    }
    catch (e) {

    }
    return optionValue;
}

function activex_error_write(tabNumber){
  if(browser_check() != 'ie' || browser_check() == 'edge'){
	  alert(NeosUtil.getMessage("TX000019537", "한글 양식은 ie 브라우져에서만 작성할수 있습니다."));
  }else{
	  alert(NeosUtil.getMessage("TX000019538", "한글 ActiveX 설치되어 있지 않아 작성할수 없습니다."));
  }
//  NeosUtil.close();
  return;
}

function activex_error(tabNumber){ 
    isView = true;
    $("#isView").val("Y");
      
    activex_error_convert(tabNumber);  

}

//뷰어로 열기 
function activex_error_convert(tabNumber){
	
    if(tabNumber == "1"){
    	  if(browser_check() != 'ie' || browser_check() == 'edge'){
    		  alert(NeosUtil.getMessage("TX000020866", "ie가 아닌 브라우저에서는 뷰어로 확인됩니다."));
    	  }else{
    		  alert(NeosUtil.getMessage("TX000019539", "한글 ActiveX 설치되어 있지 않아 뷰어로 확인 됩니다."));
    	  }
    	  	
    }
    
	var url = "/ea/edoc/convert/convertFile.do";
	var data = { "diKeyCode": $("#diKeyCode_"+tabNumber).val() } ;
    $.ajax({
    		type: "POST",
    		url: url,
    		async: false,
    		data: data,
    		dataType:"json",
    		success:function(data){ 
    			if(data){
    				drawEditorHtml(data, tabNumber);
    			}
			}
    });
}

function drawEditorHtml(data, tabNumber){
	$("#edit_area_"+tabNumber).html("<center>"+data.convertStr+"</center>");
	$("#viewHtml_"+tabNumber).html(data.convertStr);
    isView = true;
}

function browser_check(){
	var agent = navigator.userAgent.toLowerCase(),
    name = navigator.appName,
    browser;

	// MS 계열 브라우저를 구분하기 위함.
	if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
	    browser = 'ie';
	    if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
	        agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
	        //browser += parseInt(agent[1]);
	        browser = 'ie';
	    } else { // IE 11+
	        if(agent.indexOf('trident') > -1) { // IE 11 
	            //browser += 11;
	            browser = 'ie';
	        } else if(agent.indexOf('edge/') > -1) { // Edge
	            browser = 'edge';
	        }
	    }
	} else if(agent.indexOf('safari') > -1) { // Chrome or Safari
	    if(agent.indexOf('opr') > -1) { // Opera
	        browser = 'opera';
	    } else if(agent.indexOf('chrome') > -1) { // Chrome
	        browser = 'chrome';
	    } else { // Safari
	        browser = 'safari';
	    }
	} else if(agent.indexOf('firefox') > -1) { // Firefox
	    browser = 'firefox';
	}
	return browser;
	// IE: ie7~ie11, Edge: edge, Chrome: chrome, Firefox: firefox, Safari: safari, Opera: opera
	//document.getElementsByTagName('html')[0].className = browser;

}

function eaMenuCntReFresh(){
    //LNB메뉴 카운트 갱신
	try {
	    if(opener != null && opener.parent != null && opener.parent.menu.refleshMenuCnt != null){
	    	opener.parent.menu.refleshMenuCnt("ea");
	    }
	    
	} catch (e) {}
	
	//포틀릿 상태값 변경
	try {
		if(opener != null && opener.parent != null && opener.parent.mainmenu != null) {
    		opener.parent.mainmenu.refleshPortletList();
    	}
	} catch (e) {}
}

function number_chk(obj){
	var val = obj.value.replace(/,/g, "");
	var val2 = val.substr(0, 1);
	var val3 = val.length;
	if(val2 == 0){
		val = val.substr(1, val3);
	}
	obj.value = num_format(val);
}

function num_format(n){
	var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
	n = String(n);    //숫자 -> 문자변환
	while(reg.test(n)){
		n = n.replace(reg, "$1" + "," + "$2");
	}
	return n;
}

function showKeyCode(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || keyID == 8 || keyID == 46 )
	{
		return;
	}
	else
	{
		return false;
	}
}

function replaceAll(str, searchStr, replaceStr) {

    return str.split(searchStr).join(replaceStr);
}

//체크박스 선택시 toggle
function chkAll(allChkName, chkName) {
	var chkDoc = document.getElementsByName(chkName);

	var allChkName = document.getElementsByName(allChkName);
    allCheckBox(chkDoc, allChkName[0].checked);
}

function ajaxPOSTTxt_(url, data, callback){
	$.ajax({
	   type: "POST",
	   url: url,
	   data: data,
	   success: callback,
	   error: function (request, status, error){
		   errorCallback();
	   },
	   dataType:"json"
	});
}

function errorCallback(){
	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
}

/* [노드 반환] 선택된 노드로 스크롤 이동---------------------------------------------------------*/
function fnSetScrollToNode(nodeId, treeId) {
	if(!treeId){
		treeId = 'treeview';
	}
	console.log('  nodeId : ' + nodeId);
	var jstree = document.getElementById(treeId);
	var toY = getPosition(document.getElementById(nodeId)).y;
	var offset = jstree.offsetHeight / 2;
	var topV = toY - offset;

	$(".jstreeSet").animate({
		scrollTop : (toY/2)
	}, 200); // 이동
}

	/* [노드 반환] 선택된 노드 포지션 반환---------------------------------------------------------*/
function getPosition(element) {
	var xPosition = 0;
	var yPosition = 0;

	while (element) {
		xPosition += (element.offsetLeft - element.scrollLeft + element.clientLeft);
		yPosition += (element.offsetTop - element.scrollTop + element.clientTop);
		element = element.offsetParent;
	}
	
	return {
		x : xPosition,
		y : yPosition
	};
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