/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.textarea.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.TextArea = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.hintObj = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_textArea );

			// 부모 객체 style 설정
			this.setupStyle();


			var hintStr = this.attr( "pudd-hint" );
			if( hintStr && ( typeof hintStr === "string" ) ) {

				this.setupHint( hintStr );
			}

			// 하단 안내문구 설정
			this.setupInfoMsg();


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupHint : function( hintStr ) {

			if( ! this.containerObj ) return;

			var spanTag = document.createElement( "span" );
			this.containerObj.append( spanTag );

			var textNode = document.createTextNode( hintStr );
			spanTag.appendChild( textNode );

			this.hintObj = new Pudd.Element( spanTag );
			this.hintObj.addClass( "hintText" );

			// 기존 placeholder 속성 제거
			this.attr( "placeholder", null );
		}

	,	setupEvent : function() {

			if( this.hintObj ) {

				this.on( "focusin", function( e ) {

					var hintObj = Pudd.getInstance( this ).hintObj;
					if( ! hintObj ) return;

					hintObj.hide();
				});

				this.on( "focusout", function( e ) {

					var thisObj = Pudd.getInstance( this );
					if( ! thisObj.hintObj ) return;

					if( "" == thisObj.node.value ) {

						thisObj.hintObj.show();
					}
				});
			}
		}
	}
});
