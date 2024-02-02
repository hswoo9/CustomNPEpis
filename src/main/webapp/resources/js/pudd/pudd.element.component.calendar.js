/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.component.calendar.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Component.Calendar = Pudd.invent({

	// constructor
	init : function( node ) {

		this.dateUtilObj = null;

		this.selectYear = null;
		this.selectMonth = null;
		//this.selectDate = null;

		this.curDateObj = null;// Date() 기본 객체

		// 사용자가 선택한 yyyy-mm-dd
		this.userSelectedYear = null;
		this.userSelectedMonth = null;
		this.userSelectedDate = null;

		// 날자 선택 전달용 callback
		this.fnCallback = null;

		// display 유형 - basic (기본 - 별도 설정없으면 기본값 할당됨), month (월), period (범위), complexPeriod (버튼 + 범위)
		this.displayType = 1;// 1 - basic, 2 - month, 3 - period, 4 - complexPeriod

		// display 1 anchor 객체 collection
		this.dateAnchorCollection = null;

		// display 2 anchor 객체 collection
		this.monthAnchorCollection = null;
	

		// 최상위 wrapper 객체
		this.wrapperObj = null;

		// 상단부분 YYYY, MM 선택 영역
		this.selectAreaObj = null;
		this.dateTextObj = null;

		// 상단부분 YYYY, MM 선택 Anchor 관련
		this.selectDateArr = [ "prevYear", "prevMonth", "nextMonth", "nextYear" ];
		this.selectDateObjArr = null;

		// calendar 요일
		this.weekName = [ "일", "월", "화", "수", "목", "금", "토" ];

		// calendar week count
		this.weekCnt = 6;

		// calendar table
		this.calendarTableObj = null;

		// month group
		this.monthGroupObj = null;

		// 하단 info 영역
		this.infoBtnObj = null;


		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Component

	// class methods
,	extend : {

		setup : function() {

			// component class 설정
			this.setupContainer();
			this.addClass( Pudd.Config.className.PUDD_UI_calendar );


			// display 유형 - basic (기본 - 별도 설정없으면 기본값 할당됨), month (월), period (범위), complexPeriod (버튼 + 범위)
			var displayStr = this.attr( "pudd-type-display" );
			if( displayStr && ( typeof displayStr === "string" ) ) {

				if( "month" == displayStr.toLowerCase().trim() ) {

					this.displayType = 2;// 2 - month

				} else {

					this.displayType = 1;// 1 - basic
				}
			}

			// value 조사
			var valueStr = this.attr( "pudd-value" );
			if( valueStr && ( typeof valueStr === "string" ) ) {

				valueStr = valueStr.toLowerCase().trim();

			} else {

				valueStr = "";
			}

			// DateUtil 설정
			this.initDateUtil( this.displayType,  valueStr );

			// wrapper 설정
			this.setupWrapper();

			// 년,월 선택영역 설정
			this.selectDateObjArr = [];
			this.setupSelectArea( this.displayType );

			// 달력영역 설정
			this.setupCalendarArea( this.displayType );

			// 하단 info 영역
			this.setupInfoArea( this.displayType );

			// event 설정
			this.setupEvent( this.displayType );

			return this;
		}

	,	initDateUtil : function( displayType, valueStr ) {

			if( ! this.dateUtilObj ) {

				this.dateUtilObj = new Pudd.DateUtil();
			}

			if( valueStr ) {

				var arr = valueStr.split( "-" );
				if( 1 == displayType ) {

					if( 3 == arr.length ) {

						this.dateUtilObj.reset( parseInt( arr[0], 10 ), parseInt( arr[1], 10 ), parseInt( arr[2], 10 ) );

						this.userSelectedYear = this.dateUtilObj.getYear();
						this.userSelectedMonth = this.dateUtilObj.getMonth();
						this.userSelectedDate = this.dateUtilObj.getDate();
					}

				} else if( 2 == displayType ) {

					if( 2 == arr.length ) {

						this.dateUtilObj.reset( parseInt( arr[0], 10 ), parseInt( arr[1], 10 ), 1 );

						this.userSelectedYear = this.dateUtilObj.getYear();
						this.userSelectedMonth = this.dateUtilObj.getMonth();
						this.userSelectedDate = 1;
					}
				}
			}

			this.selectYear = this.dateUtilObj.getYear();
			this.selectMonth = this.dateUtilObj.getMonth();
			//this.selectDate = this.dateUtilObj.getDate();

			if( 1 == displayType ) {

				this.dateUtilObj.getCalendarMatrix();
			}

			this.curDateObj = new Date();
		}

	,	setupWrapper : function() {

			var divTag = document.createElement( "div" );
			this.append( divTag );

			this.wrapperObj = new Pudd.Element( divTag );
			this.wrapperObj.addClass( "calendarWrap" );
		}

	,	setupSelectArea : function( displayType ) {

			// div
			var divTag = document.createElement( "div" );
			this.wrapperObj.append( divTag );

			this.selectAreaObj = new Pudd.Element( divTag );
			this.selectAreaObj.addClass( "selectDate" );

			// div > span
			var spanTag = document.createElement( "span" );
			this.selectAreaObj.append( spanTag );

			this.dateTextObj = new Pudd.Element( spanTag );
			this.dateTextObj.addClass( "dateText" );

			if( 2 == displayType ) {

				this.dateTextObj.text( this.dateUtilObj.getYearString() );

			} else {

				this.dateTextObj.text( this.dateUtilObj.getYearString() + "." + this.dateUtilObj.getMonthString() );
			}


			// div > a - 상단부분 YYYY, MM 선택 영역
			var thisObj = this;
			this.selectDateArr.forEach( function( item, idx ) {

				var aTag = document.createElement( "a" );
				aTag.className = item;

				var spanTag = document.createElement( "span" );
				spanTag.className = "arr";

				aTag.appendChild( spanTag );

				thisObj.selectAreaObj.append( aTag );
				thisObj.selectDateObjArr[ idx ] = new Pudd.Element( aTag );

				if( 2 == displayType ) {

					// month 형태인 경우 prevYear, nextYear 버튼을 감추고 해당 기능은 prevMonth, nextMonth 가 실행하도록 함
					// 버튼 표시 위치와 아이콘 모양 때문에 이렇게 처리함
					if( ( "prevYear" == item ) || ( "nextYear" == item ) ) {

						thisObj.selectDateObjArr[ idx ].hide();
					}
				}
			});
		}

	,	setupCalendarArea : function( displayType ) {

			// div
			var divTag = document.createElement( "div" );
			this.wrapperObj.append( divTag );

			if( 1 == displayType ) {

				divTag.className = "calendarTable";

				// div > table
				var tableTag = document.createElement( "table" );
				divTag.appendChild( tableTag );

				this.calendarTableObj = new Pudd.Element( tableTag );

				// 월,화,수,목,금,토 설정 부분
				this.setupCalendarArea_week_name( tableTag, displayType );

				// calrendar 출력용 empty td 테이블 생성 설정
				this.setupCalendarArea_table( tableTag, displayType );

				// 일자 설정 부분
				this.mappingCalendarArea_date( tableTag, displayType );

			} else if( 2 == displayType ) {

				divTag.className = "monthBtn";

				this.monthGroupObj = new Pudd.Element( divTag );

				this.setupCalendarArea_month( displayType );

				this.userSelectedYear = this.selectYear;
				this.userSelectedMonth = this.selectMonth;
				this.mappingCalendarArea_month( displayType );
			}
		}

		// 월,화,수,목,금,토 설정 부분
	,	setupCalendarArea_week_name : function( tableTag, displayType ) {

			if( 1 != displayType ) return;

			// div > table > tr
			var trTag = document.createElement( "tr" );
			tableTag.appendChild( trTag );

			// div > table > tr > th
			for( var i=0; i<this.weekName.length; i++ ) {

				var thTag = document.createElement( "th" );
				trTag.appendChild( thTag );

				thTag.textContent = this.weekName[i];
				if( 0 == i ) {

					thTag.className = "sun";
				}
			}
		}

		// calrendar 출력용 테이블 생성 설정
	,	setupCalendarArea_table : function( tableTag, displayType ) {

			if( 1 != displayType ) return;

			for( var i=0; i<this.weekCnt; i++ ) {

				// div > table > tr
				var trTag = document.createElement( "tr" );
				tableTag.appendChild( trTag );

				for( var j=0; j<this.weekName.length; j++ ) {

					// div > table > tr > td
					var tdTag = document.createElement( "td" );
					trTag.appendChild( tdTag );

					// div > table > tr > td > a
					var aTag = document.createElement( "a" );
					tdTag.appendChild( aTag );

					aTag.style.height = "24px";
					aTag.style.lineHeight = "24px";
					aTag.setAttribute( "href", "javascript:;" );

					var aObj = new Pudd.Element( aTag );
					aObj.row = i;
					aObj.col = j;
				}
			}
		}

	,	mappingCalendarArea_date : function( tableTag, displayType ) {

			if( 1 != displayType ) return;

			var yearInt = this.curDateObj.getFullYear();
			var monthInt = this.curDateObj.getMonth() + 1;
			var dateInt = this.curDateObj.getDate();

			// 첫번째 행은 요일 표시하는 th 영역이라서 skip
			for( var i=1; i<tableTag.rows.length; i++ ) {

				var cellLength = tableTag.rows[ i ].cells.length;
				for( var j=0; j<cellLength; j++ ) {

					var tdTag = tableTag.rows[ i ].cells[ j ];
					var aTag = tdTag.childNodes[ 0 ];

					tdTag.className = "";

					var row = i - 1;
					var col = j;

					aTag.textContent = this.dateUtilObj.calendarMatrix[ row ][ col ];
					if( 0 == j ) {

						if( ! this.dateUtilObj.calendarCurMatrix[ row ][ col ] ) {

							tdTag.className = "sun otherMonth";

						} else {

							if( ( dateInt == this.dateUtilObj.calendarCurMatrix[ row ][ col ] ) && ( this.selectYear == yearInt ) && ( this.selectMonth == monthInt ) ) {

								tdTag.className = "sun today";

							} else {

								tdTag.className = "sun";
							}
						}

					} else {

						if( ! this.dateUtilObj.calendarCurMatrix[ row ][ col ] ) {

							tdTag.className = "otherMonth";

						} else {

							if( ( dateInt == this.dateUtilObj.calendarCurMatrix[ row ][ col ] ) && ( this.selectYear == yearInt ) && ( this.selectMonth == monthInt ) ) {

								tdTag.className = "today";
							}
						}
					}

					if( ( this.selectYear == this.userSelectedYear ) && ( this.selectMonth == this.userSelectedMonth ) && ( this.dateUtilObj.calendarCurMatrix[ row ][ col ] == this.userSelectedDate ) ) {

						aTag.className = "selected";

					} else {

						aTag.className = "";
					}
				}
			}
		}

	,	setupCalendarArea_month : function( displayType ) {

			if( 2 != displayType ) return;

			var yearInt = this.curDateObj.getFullYear();
			var monthInt = this.curDateObj.getMonth() + 1;

			var groupRowCnt = 3;
			var groupColCnt = 4;
			var monthCnt = 1;

			for( var i=0; i<groupRowCnt; i++ ) {

				// div > div
				var fnBtnTag = document.createElement( "div" );
				this.monthGroupObj.append( fnBtnTag );

				fnBtnTag.className = "fnBtn";

				// div > div > div
				var groupTag = document.createElement( "div" );
				fnBtnTag.appendChild( groupTag );

				groupTag.className = "group";

				for( var j=0; j<groupColCnt; j++ ) {

					// div > div > div > a
					var aTag = document.createElement( "a" );
					groupTag.appendChild( aTag );

					aTag.className = "Btn";

					var aObj = new Pudd.Element( aTag );
					aObj.idx = monthCnt;


					// div > div > div > a > span
					var spanTag = document.createElement( "span" );
					aTag.appendChild( spanTag );

					spanTag.textContent = monthCnt++ + "월";
				}
			}
		}

	,	mappingCalendarArea_month : function( displayType ) {

			if( 2 != displayType ) return;

			this.getAnchorCollection( displayType );
			for(var i=0; i<this.monthAnchorCollection.length; i++ ) {

				if( ( this.selectYear == this.userSelectedYear ) && ( this.selectMonth == this.userSelectedMonth ) && ( i == (this.userSelectedMonth - 1) ) ) {

					this.monthAnchorCollection[ i ].className = "Btn on";

				} else {

					this.monthAnchorCollection[ i ].className = "Btn";
				}
			}
		}

	,	setupInfoArea : function( displayType ) {

			if( 1 != displayType ) return;

			// div
			var divTag = document.createElement( "div" );
			this.wrapperObj.append( divTag );

			divTag.className = "fnBottom";

			// div > a
			var aTag = document.createElement( "a" );
			divTag.appendChild( aTag );

			this.infoBtnObj = new Pudd.Element( aTag );

			aTag.className = "todayBtn";
			aTag.setAttribute( "href", "javascript:;" );

			// div > a > span
			var spanTag = document.createElement( "span" );
			aTag.appendChild( spanTag );

			spanTag.textContent = "오늘";

			// div > span
			var spanTextTag = document.createElement( "span" );
			divTag.appendChild( spanTextTag );

			spanTextTag.className = "infoText";
			spanTextTag.textContent = this.dateUtilObj.getFormatDateString( this.curDateObj );
		}

	,	setupEvent : function( displayType ) {

			var thisObj = this;

			// 상단부분 YYYY, MM 선택 Anchor 관련
			this.selectDateObjArr.forEach( function( item, idx ) {

				item.on( "click", function( e ) {

					var fadeName = "fadeInRight";
					if( ( 0 == idx ) || ( 1 == idx ) ) {
						fadeName = "fadeInLeft";
					}

					if( 1 == displayType ) {

						thisObj.calendarTableObj.addClass( "animated05s" );
						thisObj.calendarTableObj.addClass( fadeName );
					}

					thisObj.changeYearMonth( idx, displayType );

					if( 1 == displayType ) {

						window.setTimeout( function(){

							thisObj.calendarTableObj.removeClass( "animated05s" );
							thisObj.calendarTableObj.removeClass( fadeName );
						}, 500 );
					}
				});
			});

			if( 1 == displayType ) {

				this.getAnchorCollection( displayType );
				this.dateAnchorCollection.forEach( function( item, idx ) {

					var aObj = Pudd.getInstance( item );
					aObj.on( "click", function( e ) {

						thisObj.switchAnchorClass( this, displayType );
					});
				});

				if( this.infoBtnObj ) {

					this.infoBtnObj.on( "click", function( e ) {

						var year = thisObj.curDateObj.getFullYear();
						var month = thisObj.curDateObj.getMonth() + 1;
						var date = thisObj.curDateObj.getDate();

						thisObj.userSelectedYear = year;
						thisObj.userSelectedMonth = month;
						thisObj.userSelectedDate = date;

						if( ( year == thisObj.selectYear ) && ( month == thisObj.selectMonth ) ) {

							thisObj.mappingCalendarArea_date( thisObj.calendarTableObj.node, displayType );

						} else {

							thisObj.calendarTableObj.addClass( "animated05s" );
							thisObj.calendarTableObj.addClass( "fadeInRight" );

							thisObj.dateUtilObj.reset( year, month, 1 );

							thisObj.initDateUtil( displayType );

							thisObj.dateTextObj.text( thisObj.dateUtilObj.getYearString() + "." + thisObj.dateUtilObj.getMonthString() );

							thisObj.mappingCalendarArea_date( thisObj.calendarTableObj.node, displayType );

							window.setTimeout( function(){

								thisObj.calendarTableObj.removeClass( "animated05s" );
								thisObj.calendarTableObj.removeClass( "fadeInRight" );
							}, 500 );
						}

						// 날자 선택 전달용 callback
						if( thisObj.fnCallback && ( typeof thisObj.fnCallback === "function" ) ) {

							var selectDate = new Date( thisObj.userSelectedYear, thisObj.userSelectedMonth - 1, thisObj.userSelectedDate );
							var dateStr = thisObj.dateUtilObj.getFormatDateString( selectDate );

							thisObj.fnCallback.call( thisObj, dateStr );
						}
					});
				}

			} else if( 2 == displayType ) {

				this.getAnchorCollection( displayType );
				this.monthAnchorCollection.forEach( function( item, idx ) {

					var aObj = Pudd.getInstance( item );
					aObj.on( "click", function( e ) {

						thisObj.switchAnchorClass( this, displayType );
					});
				});
			}
		}

	,	getAnchorCollection : function( displayType ) {

			if( 1 == displayType ) {

				if( ! this.dateAnchorCollection ) {

					this.dateAnchorCollection = Pudd.querySelectAll( '.calendarTable table td a', this.wrapperObj.node );
				}

			} else if( 2 == displayType ) {

				if( ! this.monthAnchorCollection ) {

					this.monthAnchorCollection = Pudd.querySelectAll( '.monthBtn div div a', this.wrapperObj.node );
				}
			}
		}

	,	switchAnchorClass : function( node, displayType ) {

			if( 1 == displayType ) {

				var aObj = Pudd.getInstance( node );

				var dateInt = this.dateUtilObj.calendarMatrix[ aObj.row ][ aObj.col ];
				if( 0 == this.dateUtilObj.calendarCurMatrix[ aObj.row ][ aObj.col ] ) {

					if( aObj.row < 2 ) {

						if( 1 == this.selectMonth ) {

							this.userSelectedYear = this.selectYear - 1;
							this.userSelectedMonth = 12;
							this.userSelectedDate = dateInt;

						} else {

							this.userSelectedYear = this.selectYear;
							this.userSelectedMonth = this.selectMonth - 1;
							this.userSelectedDate = dateInt;
						}

					} else if( aObj.row > 4 ) {

						if( 12 == this.selectMonth ) {

							this.userSelectedYear = this.selectYear + 1;
							this.userSelectedMonth = 1;
							this.userSelectedDate = dateInt;

						} else {

							this.userSelectedYear = this.selectYear;
							this.userSelectedMonth = this.selectMonth + 1;
							this.userSelectedDate = dateInt;
						}

					} else {

						// 이곳으로 진입하지는 않음
					}

				} else {

					this.userSelectedYear = this.selectYear;
					this.userSelectedMonth = this.selectMonth;
					this.userSelectedDate = dateInt;
				}


				this.getAnchorCollection( displayType );
				this.dateAnchorCollection.forEach( function( item, idx ) {

					var aObj = Pudd.getInstance( item );
					aObj.removeClass( "selected" );
				});

				aObj.addClass( "selected" );

				// 날자 선택 전달용 callback
				if( this.fnCallback && ( typeof this.fnCallback === "function" ) ) {

					var selectDate = new Date( this.userSelectedYear, this.userSelectedMonth - 1, this.userSelectedDate );
					var dateStr = this.dateUtilObj.getFormatDateString( selectDate );

					this.fnCallback.call( this, dateStr );
				}

			} else if( 2 == displayType ) {

				var aObj = Pudd.getInstance( node );

				this.userSelectedYear = this.selectYear;
				this.userSelectedMonth = aObj.idx;

				// 년도만 변경되는 구조라서 month 값은 강제로 셋팅
				this.selectMonth = aObj.idx;

				this.getAnchorCollection( displayType );
				this.monthAnchorCollection.forEach( function( item, idx ) {

					var aObj = Pudd.getInstance( item );
					aObj.removeClass( "on" );
				});

				aObj.addClass( "on" );

				// 날자 선택 전달용 callback
				if( this.fnCallback && ( typeof this.fnCallback === "function" ) ) {

					var selectDate = new Date( this.userSelectedYear, this.userSelectedMonth - 1, 1 );
					var monthStr = this.dateUtilObj.getFormatMonthString( selectDate );

					this.fnCallback.call( this, monthStr );
				}
			}
		}

	,	changeYearMonth : function( idx, displayType ) {

			if( 1 == displayType ) {

				if( 0 == idx ) {// prevYear

					this.dateUtilObj.reset( this.selectYear - 1, this.selectMonth, 1 );

				} else if( 1 == idx ) {// prevMonth

					if( 1 == this.selectMonth ) {

						this.dateUtilObj.reset( this.selectYear - 1, 12, 1 );

					} else {

						this.dateUtilObj.reset( this.selectYear, this.selectMonth - 1, 1 );
					}

				} else if( 2 == idx ) {// nextMonth

					if( 12 == this.selectMonth ) {

						this.dateUtilObj.reset( this.selectYear + 1, 1, 1 );

					} else {

						this.dateUtilObj.reset( this.selectYear, this.selectMonth + 1, 1 );
					}				

				} else if( 3 == idx ) {// nextYear

					this.dateUtilObj.reset( this.selectYear + 1, this.selectMonth, 1 );
				}

				this.initDateUtil( displayType );

				this.dateTextObj.text( this.dateUtilObj.getYearString() + "." + this.dateUtilObj.getMonthString() );
				this.mappingCalendarArea_date( this.calendarTableObj.node, displayType );

			} else if( 2 == displayType ) {

				// month 형태인 경우 prevYear, nextYear 버튼을 감추고 해당 기능은 prevMonth, nextMonth 가 실행하도록 함
				// 버튼 표시 위치와 아이콘 모양 때문에 이렇게 처리함
				if( 0 == idx ) {// prevYear
					return;
				} else if( 1 == idx ) {// prevMonth -> prevYear 기능

					this.dateUtilObj.reset( this.selectYear - 1, this.selectMonth, 1 );

				} else if( 2 == idx ) {// nextMonth -> nextYear 기능

					this.dateUtilObj.reset( this.selectYear + 1, this.selectMonth, 1 );

				} else if( 3 == idx ) {// nextYear
					return;
				}

				this.initDateUtil( displayType );

				this.dateTextObj.text( this.dateUtilObj.getYearString() );
				this.mappingCalendarArea_month( displayType );
			}
		}

	,	registerCallback : function( fnCallback ) {

			this.fnCallback = fnCallback;
		}
	}
});
