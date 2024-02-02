/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.radio.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.Radio = Pudd.invent({
	
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
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_radio );
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


			var svgStr = "";
			if( null != disabledStr ) {

				svgStr = Pudd.Config.svgSet.RADIO_DISABLE;

			} else {

				svgStr = Pudd.Config.svgSet.RADIO;
			}
			this.insertHTML( svgStr );


			// label 객체 생성
			var labelStr = this.attr( "pudd-label" );
			this.setupLabel( labelStr );


			// radio 객체 자체에 class 셋팅
			this.addClass( Pudd.Config.className.PUDDRadio );


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
			}
		}

	,	setupEvent : function() {

			if( ! this.containerObj ) return;

			this.containerObj.on( "click", function( e ) {

				var containerObj = Pudd.getInstance( this );

				if( containerObj.hasClass( "UI-Disa" ) ) return;


				// containerObj 하위의 radio 가져오기
				// 일단 radio 1개만 있다고 가정하고 진행함
				var result = Pudd.querySelectAll( "." + Pudd.Config.className.PUDDRadio, this );
				if( 1 != result.length ) return;

				var radioObj = Pudd.getInstance( result[0] );
				var nameStr = radioObj.attr( "name" );

				var radiioCollection = Pudd.querySelectAll( 'input[type="radio"][name='+ nameStr +']', document );
				radiioCollection.forEach( function( item, idx ) {

					var rObj = Pudd.getInstance( item );
					if( rObj.node.checked ) {

						rObj.attr( "checked", null );
						rObj.node.checked = false;
						rObj.containerObj.removeClass( Pudd.Config.className.UI_ON );
					}
				});

				radioObj.attr( "checked", "true" );
				radioObj.node.checked = true;
				containerObj.addClass( Pudd.Config.className.UI_ON );

				radioObj.fire( "click", true, true );

			});// end : click
		}
	}
});
