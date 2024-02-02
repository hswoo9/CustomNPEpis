/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.filebox.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.FileBox = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.fieldObj = null;
		this.anchorObj = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Control

	// class methods
,	extend : {

		setup : function() {

			// 부모 객체 설정
			this.setupContainer();
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_fileField );

			var typeStr = this.attr( "pudd-file-type" );
			if( typeStr && ( typeof typeStr === "string" ) && ( "union" == typeStr.toLowerCase().trim() ) ) {

				this.containerObj.addClass( Pudd.Config.className.UI_Union );
			}

			// file 원본 객체 hidden 설정 class 추가
			this.addClass( "hiddenField" );

			// input readonly 필드 추가 설정
			this.setupField();

			// file anchor 추가 설정
			this.setupAnchorButton();

			// 부모 객체 style 설정
			this.setupStyle( this.fieldObj );


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupField : function() {

			var inputTag = document.createElement( "input" );
			this.containerObj.append( inputTag );

			this.fieldObj = new Pudd.Element( inputTag );
			this.fieldObj.attr( "type", "text" );
			this.fieldObj.attr( "readonly", "true" );
			this.fieldObj.attr( "placeholder", "파일을 첨부해주세요" );
			this.fieldObj.addClass( "cloneField" );
		}

	,	setupAnchorButton : function() {

			var aTag = document.createElement( "a" );
			this.containerObj.append( aTag );

			this.anchorObj = new Pudd.Element( aTag );
			this.anchorObj.addClass( "btn_file" );
			this.anchorObj.attr( "href", "javascript:;" );
			this.anchorObj.text( "첨부파일" );
		}

	,	setupEvent : function() {

			var thisObj = this;

			this.anchorObj.on( "click", function( e ) {

				thisObj.node.click();
			});

			this.on( "change", function( e ) {

				thisObj.fieldObj.node.value = this.value;
			});
		}
	}
});
