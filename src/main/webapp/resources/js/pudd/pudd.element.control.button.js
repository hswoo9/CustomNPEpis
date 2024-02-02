/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.button.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control.Button = Pudd.invent({
	
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
			this.containerObj.addClass( Pudd.Config.className.PUDD_UI_Button );

			// 부모 객체 style 설정
			this.setupStyle();


			var iconClassCheck = false;

			var valueStr = this.attr("value");
			valueStr = ( null == valueStr ) ? "" : valueStr;

			var iconAlignStr = this.attr("pudd-icon-align");
			iconAlignStr = ( null == iconAlignStr ) ? "" : iconAlignStr.toLowerCase().trim();


			// 클래스(이미지) 버튼 여부 검사, 설정
			var iconClassStr = this.attr( "pudd-icon-class" );
			if( iconClassStr && ( typeof iconClassStr === "string" ) ) {

				iconClassStr = iconClassStr.toLowerCase().trim();
				if( "" != iconClassStr ) {

					iconClassCheck = true;
					this.addClass( "ico" );
					this.addClass( iconClassStr );

					if( "" == valueStr ) {

						this.containerObj.addClass( Pudd.Config.className.PUDD_UI_iconImgButton );

					} else {

						iconAlignStr = ( "right" == iconAlignStr ) ? "ico_ar" : "ico_al";
						this.addClass( iconAlignStr );

						this.containerObj.addClass( Pudd.Config.className.PUDD_UI_iconImgtextButton );
					}
				}
			}

			// svg 버튼 여부 검사, 설정
			if( ! iconClassCheck ) {

				if( "" == valueStr ) {

					var containerObj = this.containerObj;
					this.setupIconSvg( function() {

						containerObj.addClass( Pudd.Config.className.PUDD_UI_iconSvgButton );
					});

				} else {

					var svgStr = this.getCodeIconSvg();
					if( svgStr ) {

						var divTag = document.createElement( "div" );
						this.containerObj.append( divTag );

						var divObj = new Pudd.Element( divTag );
						divObj.insertHTML( svgStr, true );

						if( "right" == iconAlignStr ) {

							this.addClass( "ico_ar" );
							divObj.addClass( "svgR_box" );

						} else {

							this.addClass( "ico_al" );
							divObj.addClass( "svgL_box" );
						}

						this.containerObj.addClass( Pudd.Config.className.PUDD_UI_iconSvgtextButton );
					}
				}
			}

			// 툴팁 설정
			this.setupToolTip()


			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupEvent : function() {

			this.eventToolTip();
		}
	}
});
