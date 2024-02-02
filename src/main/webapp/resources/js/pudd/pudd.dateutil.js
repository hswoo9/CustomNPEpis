/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.dateutil.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.DateUtil = Pudd.invent({

	// constructor
	init : function() {

		this.date = new Date();

		this.calendarMatrix = null;
		this.calendarCurMatrix = null;
	}

	// class methods
,	extend : {

		reset : function( year, month, day ) {

			this.date = new Date( year, month - 1, day );

			this.calendarMatrix = null;
			this.calendarCurMatrix = null;
		}

	,	getYear : function() {

			return this.date.getFullYear();
		}

	,	getYearString : function() {

			return ( "" + this.date.getFullYear() );
		}

	,	getMonth : function() {

			return this.date.getMonth() + 1;
		}

	,	getMonthString : function() {

			var monthStr = this.date.getMonth() + 1;
			if( monthStr < 10 ){

				monthStr = "0" + monthStr;
			}

			return monthStr;
		}

	,	getDate : function() {

			return this.date.getDate();
		}

	,	getFormatDateString : function( dateObj ) {

			var yearStr = dateObj.getFullYear();

			var monthStr = dateObj.getMonth() + 1;
			if( monthStr < 10 ){

				monthStr = "0" + monthStr;
			}

			var dateStr = dateObj.getDate();
			if( dateStr < 10 ){

				dateStr = "0" + dateStr;
			}

			return [ yearStr, monthStr, dateStr ].join( "-" );
		}

	,	getFormatMonthString : function( dateObj ) {

			var yearStr = dateObj.getFullYear();

			var monthStr = dateObj.getMonth() + 1;
			if( monthStr < 10 ){

				monthStr = "0" + monthStr;
			}

			return [ yearStr, monthStr ].join( "-" );
		}

	,	getPrevMonthLastDay : function() {

			var year = this.date.getFullYear();
			var month = this.date.getMonth();

			if( 0 == month ) {

				year--;
				month = 12;

			} else {

				month--;
			}

			// 매개변수 int 전달인 경우 month 항목은 -1 적용하여 전달하여야 함. 단, 여기서 3rd 변수가 0 이므로 아래처럼 적용한 것임
			return new Date( year, month + 1, 0 );
		}

	,	getCalendarMatrix : function() {

			var calendarMatrix = [];
			var calendarCurMatrix = [];

			var rowCnt = 6;
			var colCnt = 7;

			var yearVal = this.getYear();
			var monthVal = this.getMonth();

			var firstDateObj = new Date( yearVal, monthVal - 1, 1 );
			var lastDateObj = new Date( yearVal, monthVal, 0 );

			//var firstDay = 1;
			var lastDay = lastDateObj.getDate();

			var firstDayWeekNo = firstDateObj.getDay();
			var lastDayWeekNo = lastDateObj.getDay();

			var prevLastDateObj = this.getPrevMonthLastDay();
			var prevLastDay = prevLastDateObj.getDate();


			// 이전, 현재, 다음 날짜 카운터
			var prevDayCnt = prevLastDay - firstDayWeekNo + 1;
			var curDayCnt = 1;
			var nextDayCnt = 1;

			var curStart = false;

			for( var i=0; i<rowCnt; i++ ) {

				calendarMatrix[ i ] = [];
				calendarCurMatrix[ i ] = [];

				for( var j=0; j<colCnt; j++ ) {

					if( ! curStart ) {

						if( j == firstDayWeekNo ) {

							curStart = true;
							calendarMatrix[ i ][ j ] = curDayCnt;
							calendarCurMatrix[ i ][ j ] = curDayCnt;
							curDayCnt++;

						} else {

							calendarMatrix[ i ][ j ] = prevDayCnt++;
							calendarCurMatrix[ i ][ j ] = 0;
						}

					} else {

						if( lastDay < curDayCnt ) {

							calendarMatrix[ i ][ j ] = nextDayCnt++;
							calendarCurMatrix[ i ][ j ] = 0;

						} else {

							calendarMatrix[ i ][ j ] = curDayCnt;
							calendarCurMatrix[ i ][ j ] = curDayCnt;
							curDayCnt++;
						}
					}
				}
			}

			this.calendarMatrix = calendarMatrix;
			this.calendarCurMatrix = calendarCurMatrix;
		}
	}
});
