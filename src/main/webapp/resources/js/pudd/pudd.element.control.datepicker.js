/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.datepicker.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.DatePicker = Pudd.invent({

	// constructor
	init : function( node ) {

		// display 유형 - basic (기본 - 별도 설정없으면 기본값 할당됨), month (월)
		this.displayType = 1;// 1 - basic, 2 - month

		this.anchorObj = null;
		this.dropCalWrapObj = null;
		this.dropCalWrapHeight = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_datePicker );

			// input 객체 readonly 속성 설정
			this.attr( "readonly", "readonly" );

			// pudd-type-display 검사 설정
			var displayTypeStr = this.attr( "pudd-type-display" );
			if( displayTypeStr && ( typeof displayTypeStr === "string" ) && ( "month" == displayTypeStr.toLowerCase().trim() ) ) {

				this.displayType = 2;
				this.containerObj.addClass( Pudd.Config.className.month );

			} else {

				this.containerObj.addClass( Pudd.Config.className.basic );
			}

			// anchor and 달력 icon 설정
			var aTag = document.createElement( "a" );
			this.containerObj.append( aTag );

			this.anchorObj = new Pudd.Element( aTag );
			this.anchorObj.addClass( "btn" );
			this.anchorObj.attr( "href", "javascript:;" );
			this.anchorObj.insertHTML( Pudd.Config.svgSet.CALENDAR, true );

			// dropCalWrap 영역 설정
			var divTag = document.createElement( "div" );
			this.containerObj.append( divTag );

			this.dropCalWrapObj = new Pudd.Element( divTag );
			this.dropCalWrapObj.addClass( "dropCalWrap" );
			this.dropCalWrapObj.hide();

			// calendar 태그 생성
			var calendarTag = document.createElement( "div" );
			this.dropCalWrapObj.append( calendarTag );

			calendarTag.setAttribute( "pudd-type", "calendar" );

			// value 값 설정
			var valueStr = this.attr( "value" );
			if( valueStr ) {

				calendarTag.setAttribute( "pudd-value", valueStr );
			}

			if( 1 == this.displayType ) {
			} else if( 2 == this.displayType ) {

				calendarTag.setAttribute( "pudd-type-display", "month" );
			}

			// calendar 객체 생성
			var calendarObj = new Pudd.Element.Component.Calendar( calendarTag );
			calendarObj.setup();

			// calendar callback 설정
			var thisObj = this;
			calendarObj.registerCallback( function( dateStr ) {

				thisObj.attr( "value", dateStr );

				window.setTimeout( function() {

					thisObj.removeClass( "on" );
					thisObj.showCalendar( false );
				}, 100);

				thisObj.fire( "change", true, true );
			});


			// 부모 객체 style 설정
			this.setupStyle();

			// 툴팁 설정
			this.setupToolTip();

			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupEvent : function() {

			this.eventToolTip();

			// 대상 영역 안에 mouse 존재 여부 이벤트 설정
			this.eventHover( this.dropCalWrapObj );


			var thisObj = this;

			this.on( "click", function( e ) {

				if( thisObj.hasClass( "on" ) ) {

					thisObj.removeClass( "on" );
					thisObj.node.blur();

				} else {

					thisObj.addClass( "on" );
					thisObj.showCalendar( true );
				}
			});

			this.on( "blur", function( e ) {

				if( ! thisObj.dropCalWrapObj.hover ) {

					thisObj.removeClass( "on" );
					thisObj.showCalendar( false );

				} else {

					// calendar 영역 안을 클릭하는 경우 blur 발생하는데
					// 외부 영역 document - click 이벤트를 조사하여 calendar 창을 닫아야 하는 과정을
					// 다시 focus를 주어 대체 처리함
					thisObj.node.focus();
				}
			});

			var documentObj = Pudd.getInstance( document );
			documentObj.on( "scroll", function( e ) {

				thisObj.removeClass( "on" );
				thisObj.showCalendar( false );

				thisObj.node.blur();
			});
		}

	,	showCalendar : function( show ) {

			if( show ) {

				if( null == this.dropCalWrapHeight ) {

					this.dropCalWrapHeight = this.getLayerHeight( this.dropCalWrapObj );
				}

				var rcSource = this.node.getBoundingClientRect();
				var sourceHeight = this.node.offsetHeight;

				this.showLayer( true, this.dropCalWrapObj, this.dropCalWrapHeight, rcSource, sourceHeight );

			} else {

				this.showLayer( false, this.dropCalWrapObj, null, null, null );
			}
		}
	}
});
