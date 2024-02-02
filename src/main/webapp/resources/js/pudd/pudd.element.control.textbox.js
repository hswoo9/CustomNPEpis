/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.textbox.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.TextBox = Pudd.invent({

	// constructor
	init : function( node ) {

		this.anchorSearchObj = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();

			var inputTypeStr = this.attr( "pudd-input-type" );
			if( inputTypeStr && ( typeof inputTypeStr === "string" ) && ( "search" == inputTypeStr.toLowerCase().trim() ) ) {

				this.containerObj.addClass( Pudd.Config.className.PUDD_UI_searchField );

				var aTag = document.createElement( "a" );
				this.containerObj.append( aTag );

				this.anchorSearchObj = new Pudd.Element( aTag );
				this.anchorSearchObj.insertHTML( Pudd.Config.svgSet.MAGNIFIER, true );

				if( null == this.attr( "disabled" ) ) {

					this.anchorSearchObj.addClass( "btn" );
					this.anchorSearchObj.attr( "href", "javascript:;" );
				}

			} else {

				this.containerObj.addClass( Pudd.Config.className.PUDD_UI_inputField );

				// 아이콘 svg 설정
				this.setupIconSvg();
			}

			// 부모 객체 style 설정
			this.setupStyle();

			// 툴팁 설정
			this.setupToolTip();

			// 하단 안내문구 설정
			this.setupInfoMsg();

			// autoComplete listBox 설정
			this.setupAutoComplete();


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupAutoComplete : function() {

			var autoStr = this.attr( "pudd-auto-complete" );
			if( autoStr && ( typeof autoStr === "string" ) && ( "true" == autoStr.toLowerCase().trim() ) ) {

				this.setupListBox( "autoComplete" );

				// 임시 하드코딩
				for( var i=0; i<10; i++ ) {

					var liTag = document.createElement( "li" );
					this.listUlObj.append( liTag );

					var liObj = new Pudd.Element( liTag );
					this.listChildrenObj.push( liObj );

					liObj.text( "하드코딩_" + i );
					liObj.idx = i
				}
			}
		}

	,	setupEvent : function() {

			this.eventToolTip();

			if( this.anchorSearchObj && this.anchorSearchObj.hasClass( "btn" ) ) {

				var fnSearchStr = this.attr( "pudd-fn-search" );
				if( fnSearchStr && ( typeof fnSearchStr === "string" ) && ( "" != fnSearchStr.toLowerCase().trim() ) ) {

					this.anchorSearchObj.on( "click", function( e ) {

						eval( fnSearchStr );
					});
				}
			}

			if( this.listObj ) {

				var thisObj = this;

				this.on( "focusin", function( e ) {

					var rcSource = thisObj.containerObj.node.getBoundingClientRect();
					var sourceHeight = thisObj.containerObj.node.offsetHeight;

					thisObj.showListBox( true, rcSource, sourceHeight );
				});

				this.on( "focusout", function( e ) {

					if( ! thisObj.getHoverListBox() ) {

						thisObj.showListBox( false, null, null );
					}
				});

				this.eventListBox( function( idx, text ) {

					thisObj.node.value = text;
				});

				// pudding.control 멤버변수 직접 호출하여 사용
				this.listObj.on( "scroll", function( e ) {

					thisObj.node.focus();
				});

				var documentObj = Pudd.getInstance( document );
				documentObj.on( "scroll", function( e ) {

					thisObj.node.blur();
				});
			}
		}
	}
});
