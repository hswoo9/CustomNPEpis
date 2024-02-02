/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.password.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.Password = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_passwordField );

			// 부모 객체 style 설정
			this.setupStyle();

			// 아이콘 svg 설정
			this.setupIconSvg();

			// 툴팁 설정
			this.setupToolTip();

			// 하단 안내문구 설정
			this.setupInfoMsg();


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupEvent : function() {

			this.eventToolTip();
		}
	}
});
