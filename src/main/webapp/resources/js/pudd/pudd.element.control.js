/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.control.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Control = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.containerObj = null;

		this.toolTipObj = null;
		this.infoMsgObj = null;

		// 공통 : textbox / select
		this.listObj = null;
		this.listUlObj = null;
		this.listChildrenObj = null;// 이 부분을 배열로 설정하였는데 생성자 호출될 때마다 누적되는 현상으로 변경 처리
		this.listHeight = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element

	// class methods
,	extend : {

		// 전체 공통
		setupContainer : function() {

			var divTag = document.createElement( "div" );
			this.before( divTag );
			divTag.appendChild( this.node );

			this.containerObj = new Pudd.Element( divTag );
			this.containerObj.addClass( Pudd.Config.className.PUDD );
			this.containerObj.addClass( pudding.skinName );// PUDD-COLOR-blue

			// 공통 : textbox / select
			this.listChildrenObj = [];

			// puddSetup class 해제
			this.removeClass( "puddSetup" );
		}

	,	setupStyle : function( targetObj ) {

			var styleStr = this.attr( "pudd-style" );
			if( styleStr && ( typeof styleStr === "string" ) && ( "" != styleStr ) ) {

				if( targetObj && typeof targetObj === "object" && targetObj instanceof Pudd.Element ) {

					targetObj.style( styleStr );
				
				} else {

					if( this.containerObj ) {

						this.containerObj.style( styleStr );
					}
				}
			}
		}

		// 공통 : textbox / password / button
	,	setupIconSvg : function( fnCallback ) {

			var svgStr = this.getCodeIconSvg();
			if( svgStr ) {

				this.insertHTML( svgStr );

				if( fnCallback && ( typeof fnCallback === "function" ) ) {

					fnCallback.call( this );
				}
			}
		}

	,	getCodeIconSvg : function() {

			var iconSvgStr = this.attr( "pudd-icon-svg" );
			if( iconSvgStr && ( typeof iconSvgStr === "string" ) && ( "" != iconSvgStr ) ) {

				iconSvgStr = iconSvgStr.toLowerCase().trim();

				if( "success" == iconSvgStr ) {

					return Pudd.Config.svgSet.SUCCESS;

				} else if( "error" == iconSvgStr ) {

					return Pudd.Config.svgSet.ERROR;

				} else if( "warning" == iconSvgStr ) {

					return Pudd.Config.svgSet.WARNING;

				} else if( "secure" == iconSvgStr ) {

					return Pudd.Config.svgSet.SECURE;

				} else if( "magnifier" == iconSvgStr ) {

					return Pudd.Config.svgSet.MAGNIFIER;

				} else if( "clip" == iconSvgStr ) {

					return Pudd.Config.svgSet.CLIP;
				}
			}

			return null;
		}

		// 공통 : textbox / button
	,	setupToolTip : function() {

			var tooltipStr = this.attr( "pudd-tooltip" );
			if( tooltipStr && ( typeof tooltipStr === "string" ) && ( "true" == tooltipStr.toLowerCase().trim() ) ) {

				var tooltipMsgStr = this.attr( "pudd-tooltip-msg" );
				if( null != tooltipMsgStr ) {

					this.processToolTip( tooltipMsgStr );

				} else {

					var valueStr = this.attr("value");
					valueStr = ( null == valueStr ) ? "" : valueStr;

					this.processToolTip( valueStr );
				}
			}
		}

	,	processToolTip : function( msgStr ) {

			if( ! this.containerObj ) return;

			var divTag = document.createElement( "div" );
			this.containerObj.append( divTag );

			var textNode = document.createTextNode( msgStr );
			divTag.appendChild( textNode );

			this.toolTipObj = new Pudd.Element( divTag );
			this.toolTipObj.addClass( "toolTip" );
			this.toolTipObj.addClass( "animated03s" );
			this.toolTipObj.addClass( "fadeInUp" );
			this.toolTipObj.hide();
		}

		// 공통 : textbox / textarea
	,	setupInfoMsg : function() {

			// pudd-info 검사 : success, error, warning
			var infoStr = this.attr( "pudd-info" );
			if( infoStr && ( typeof infoStr === "string" ) && ( "" != infoStr ) ) {

				var infomsgStr = this.attr("pudd-info-msg");
				infomsgStr = ( null == infomsgStr ) ? "" : infomsgStr;

				infoStr = infoStr.toLowerCase().trim();
				if( "success" == infoStr ) {

					this.containerObj.addClass( Pudd.Config.className.Success );

				} else if( "error" == infoStr ) {

					this.containerObj.addClass( Pudd.Config.className.Error );

				} else if( "warning" == infoStr ) {

					this.containerObj.addClass( Pudd.Config.className.Warning );

				} else {

					infomsgStr = "";
				}

				if( "" != infomsgStr ) {

					this.processInfoMsg( infomsgStr );
				}
			}
		}

	,	processInfoMsg : function( infomsgStr ) {

			if( ! this.containerObj ) return;

			var divTag = document.createElement( "div" );
			this.containerObj.append( divTag );

			var textNode = document.createTextNode( infomsgStr );
			divTag.appendChild( textNode );

			this.infoMsgObj = new Pudd.Element( divTag );
			this.infoMsgObj.addClass( "informationText" );
			this.infoMsgObj.addClass( "animated03s" );
			this.infoMsgObj.addClass( "fadeInRight" );
		}

		// 공통 : textbox / select
	,	setupListBox : function( classStr ) {

			// div
			var divTag = document.createElement( "div" );
			this.containerObj.append( divTag );

			this.listObj = new Pudd.Element( divTag );
			if( classStr && ( "" != classStr ) ) {

				this.listObj.addClass( classStr );
			}

			// div > ul
			var ulTag = document.createElement( "ul" );
			divTag.appendChild( ulTag );

			this.listUlObj = new Pudd.Element( ulTag );
		}

		// 공통 : textbox / select
	,	getLayerHeight : function( layerObj ) {

			var layerHeight = 0;

			layerObj.style( "top:-2000px" );
			layerObj.show();

			layerHeight = layerObj.node.offsetHeight;
			layerObj.hide();

			return layerHeight;
		}

		// 공통 : textbox / select
	,	showListBox : function( show, rcSource, sourceHeight ) {

			if( show ) {

				if( null == this.listHeight ) {

					this.listHeight = this.getLayerHeight( this.listObj );
				}

				this.showLayer( show, this.listObj, this.listHeight, rcSource, sourceHeight );

			} else {

				this.showLayer( show, this.listObj, null, null, null );
			}
		}

		// 공통 : textbox / select / calendar
	,	showLayer : function( show, layerObj, layerHeight, rcSource, sourceHeight ) {

			if( show ) {

				var bodyDisplayH = document.body.getBoundingClientRect().height;

				if( ( bodyDisplayH - rcSource.top - sourceHeight - layerHeight ) < 0 ) {

					layerObj.style( "left:" + rcSource.left + "px");
					layerObj.style( "top:" + ( rcSource.top - layerHeight ) + "px");
					layerObj.style( "width:" + ( rcSource.right - rcSource.left - 2 ) + "px");

				}else{

					layerObj.style( "left:" + rcSource.left + "px");
					layerObj.style( "top:" + rcSource.bottom + "px");
					layerObj.style( "width:" + ( rcSource.right - rcSource.left - 2 ) + "px");
				}

				layerObj.addClass( "animated03s" );
				layerObj.addClass( "fadeIn" );
				layerObj.show();

			} else {

				layerObj.removeClass( "animated03s" );
				layerObj.removeClass( "fadeIn" );
				layerObj.hide();
			}
		}

		// 공통 : textbox / select
	,	getHoverListBox : function() {

			return this.listObj.hover;
		}

		// 공통 : textbox / button
	,	eventToolTip : function() {

			var thisObj = this;

			if( this.toolTipObj && this.containerObj ) {

				this.containerObj.on( "mouseenter", function( e ) {

					var rc = thisObj.containerObj.node.getBoundingClientRect();

					thisObj.toolTipObj.style( "top:" + ( rc.bottom + 9 ) + "px");
					thisObj.toolTipObj.show();
				});

				this.containerObj.on( "mouseout", function( e ) {

					thisObj.toolTipObj.hide();
				});

				this.containerObj.on( "mousewheel", function( e ) {

					thisObj.toolTipObj.hide();
				});
			}
		}

		// 공통 : textbox / select
	,	eventListBox : function( fnCallback ) {

			// 대상 영역 안에 mouse 존재 여부 이벤트 설정
			this.eventHover( this.listObj );


			var thisObj = this;

			this.listChildrenObj.forEach( function( item, idx ) {

				item.on( "click", function( e ) {

					thisObj.listChildrenObj.forEach( function( itm, ix ) {

						itm.removeClass( "on" );
					});

					var liObj = Pudd.getInstance( this );
					liObj.addClass( "on" );

					thisObj.showListBox( false, null, null );

					if( fnCallback && ( typeof fnCallback === "function" ) ) {

						fnCallback.call( this, liObj.idx, liObj.text() );
					}
				});
			});
		}

	,	eventHover : function( targetObj ) {

			targetObj.hover = false;

			if( targetObj && typeof targetObj === "object" && targetObj instanceof Pudd.Element ) {

				targetObj.on( "mouseenter", function( e ) {

					Pudd.getInstance( this ).hover = true;
				});

				targetObj.on( "mousemove", function( e ) {

					Pudd.getInstance( this ).hover = true;
				});

				targetObj.on( "mouseout", function( e ) {

					Pudd.getInstance( this ).hover = false;
				});
			}
		}
	}
});
