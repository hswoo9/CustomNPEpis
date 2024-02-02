/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.checkbox.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.CheckBox = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.labelObj = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_checkbox );
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_ChkRadi );

			// 부모 객체 style 설정
			this.setupStyle();


			// checked 속성 - 속성값은 검사안함 - attr 메소드가 해당 속성 자체가 없는 경우면 null 리턴함
			var checkedStr = this.attr( "checked" );
			if( null != checkedStr ) {

				this.containerObj.addClass( Pudd.Config.className.UI_ON );
			}

			// disabled 속성 - 속성값은 검사안함 - attr 메소드가 해당 속성 자체가 없는 경우면 null 리턴함
			var disabledStr = this.attr( "disabled" );
			if( null != disabledStr ) {

				this.containerObj.addClass( Pudd.Config.className.UI_Disa );
			}



			// pudd-check-type 검사 : 기본, dash
			var svgStr = "";
			var typeStr = this.attr( "pudd-check-type" );
			if( typeStr && ( typeof typeStr === "string" ) && ( "dash" == typeStr.toLowerCase().trim() ) ) {

				if( null != disabledStr ) {

					svgStr = Pudd.Config.svgSet.DASH_DISABLE;

				} else {

					svgStr = Pudd.Config.svgSet.DASH;
				}

			} else {

				if( null != disabledStr ) {

					svgStr = Pudd.Config.svgSet.CHECK_DISABLE;

				} else {

					svgStr = Pudd.Config.svgSet.CHECK;
				}
			}
			this.insertHTML( svgStr );


			// label 객체 생성
			var labelStr = this.attr( "pudd-label" );
			this.setupLabel( labelStr );

			// checkbox 객체 자체에 class 셋팅
			this.addClass( Pudd.Config.className.PUDDCheckBox );


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupLabel : function( labelStr ) {

			if( ! this.containerObj ) return;

			var labelTag = document.createElement( "label" );
			this.containerObj.append( labelTag );

			this.labelObj = new Pudd.Element( labelTag );

			// label 문구열 셋팅
			if( labelStr && ( typeof labelStr === "string" ) && ( "" !== labelStr ) ) {

				var textNode = document.createTextNode( labelStr );
				this.labelObj.append( textNode );

			} else {

				this.containerObj.addClass( Pudd.Config.className.PUDD_UI_ONLY );
			}
		}

	,	setupEvent : function() {

			if( ! this.containerObj ) return;

			var thisObj = this;

			this.containerObj.on( "click", function( e ) {

				if( thisObj.containerObj.hasClass( "UI-Disa" ) ) return;

				thisObj.fire( "click", false, false );

				var checkedStr = thisObj.attr( "checked" );
				if( null != checkedStr ) {

					thisObj.attr( "checked", null );
					thisObj.containerObj.removeClass( Pudd.Config.className.UI_ON );

				} else {

					thisObj.attr( "checked", "true" );
					thisObj.containerObj.addClass( Pudd.Config.className.UI_ON );
				}

			});
		}
	}
});
