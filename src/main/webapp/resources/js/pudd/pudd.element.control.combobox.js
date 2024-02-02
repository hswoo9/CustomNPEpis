/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.combobox.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.ComboBox = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.fieldObj = null;
		this.fieldSpanObj = null;
		this.fieldButtonObj = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_selectBox );

			// 부모 객체 style 설정
			this.setupStyle();

			// select 원본 객체 hidden 설정 class 추가
			this.addClass( "hiddenSelect" );

			// 콤보박스 선택된 영역 설정
			this.setupField();

			// 콤보박스 리스트 설정
			this.setupClone();

			// selectedIndex 설정
			this.setSelectedOption();


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupField : function() {

			// div
			var divTag = document.createElement( "div" );
			this.containerObj.append( divTag );

			this.fieldObj = new Pudd.Element( divTag );
			this.fieldObj.attr( "tabindex", "1" );
			this.fieldObj.addClass( "selectField" );

			var disabledStr = this.attr( "disabled" );
			if( null != disabledStr ) {

				this.fieldObj.addClass( "disabled" );
			}

			// div > span
			var spanTag = document.createElement( "span" );
			divTag.appendChild( spanTag );

			this.fieldSpanObj = new Pudd.Element( spanTag );
			this.fieldSpanObj.addClass( "selectText" );


			// div > button
			var buttonTag = document.createElement( "button" );
			divTag.appendChild( buttonTag );

			this.fieldButtonObj = new Pudd.Element( buttonTag );
			this.fieldButtonObj.addClass( "selectFieldBtn" );


			// div > button > span
			var buttonSpanTag = document.createElement( "span" );
			buttonTag.appendChild( buttonSpanTag );

			this.selectFieldButtonSpanObj = new Pudd.Element( buttonSpanTag );
			this.selectFieldButtonSpanObj.addClass( "arr" );
		}

	,	setupClone : function() {

			this.setupListBox( "cloneList" );

			// select 원본 객체 option 리스트 복사하기
			for( var i=0; i<this.node.options.length; i++ ) {

				var liTag = document.createElement( "li" );
				this.listUlObj.append( liTag );

				var liObj = new Pudd.Element( liTag );
				this.listChildrenObj.push( liObj );

				liObj.text( this.node.options[i].textContent );
				liObj.idx = i
			}
		}

	,	setSelectedOption : function() {

			var idx = this.node.selectedIndex;
			if( this.listChildrenObj.length <= idx ) return;

			this.listChildrenObj[ idx ].addClass( "on" );

			if( this.fieldSpanObj ) {

				this.fieldSpanObj.text( this.listChildrenObj[ idx ].text() );
			}
		}

	,	setupEvent : function() {

			// IE 10 이하 브라우저에서 fieldObj 처음 click시에 focus 처리되지 않고
			// 다시 click하여 toggle 처리하는 과정에서는 blur 이벤트가 다시 발생하여 toggle 되지 않는 현상 처리 부분
			if( window.attachEvent ) {

				// 대상 영역 안에 mouse 존재 여부 이벤트 설정
				this.eventHover( this.fieldObj );
			}

			var thisObj = this;

			this.fieldObj.on( "click", function( e ) {

				if( thisObj.fieldObj.hasClass( "disabled" ) ) return;

				if( thisObj.fieldObj.hasClass( "on" ) ) {

					thisObj.fieldObj.removeClass( "on" );
					thisObj.fieldObj.node.blur();

				} else {

					thisObj.fieldObj.addClass( "on" );

					if( window.attachEvent ) {

						// IE 10 이하 브라우저에 focus 설정
						thisObj.fieldObj.node.focus();
					}

					var rcSource = thisObj.fieldObj.node.getBoundingClientRect();
					var sourceHeight = thisObj.fieldObj.node.offsetHeight;

					thisObj.showListBox( true, rcSource, sourceHeight );
				}
			});

			this.eventListBox( function( idx, text ) {

				thisObj.fieldSpanObj.text( text );

				thisObj.node.selectedIndex = idx;

				thisObj.fire( "change", true, true );
			});

			this.fieldObj.on( "blur", function( e ) {

				// IE 10 이하 브라우저에서 fieldObj 선택된 상태에서 같은 영역을 다시 click 시 blur 이벤트 발생되고 click 이벤트 발생되지 않음
				if( window.attachEvent ) {

					if( thisObj.fieldObj.hover ) {

						thisObj.showListBox( false, null, null );
						return;
					}
				}

				thisObj.fieldObj.removeClass( "on" );

				if( ! thisObj.getHoverListBox() ) {

					thisObj.showListBox( false, null, null );
				}
			});

			// pudding.control 멤버변수 직접 호출하여 사용
			this.listObj.on( "scroll", function( e ) {

				thisObj.fieldObj.node.focus();
			});

			// combobox 갯수만큼 이벤트가 발생됨 - 수정할 것
			var documentObj = Pudd.getInstance( document );
			documentObj.on( "scroll", function( e ) {

				thisObj.showListBox( false, null, null );
				thisObj.fieldObj.node.blur();
			});
		}
	}
});
