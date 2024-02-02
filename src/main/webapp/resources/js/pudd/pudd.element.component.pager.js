/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.component.pager.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Component.Pager = Pudd.invent({

	// constructor
	init : function( node ) {

		this.firstBtnObj = null;
		this.prevBtnObj = null;
		this.nextBtnObj = null;
		this.lastBtnObj = null;

		this.numberObjArr = null;

		this.blockListObj = null;

		this.selectNoVal = null;
		this.refVal = null;

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Component

	// class methods
,	extend : {

		setup : function() {

			// component class 설정
			this.setupContainer();
			this.addClass( Pudd.Config.className.PUDD_UI_pager );

			// paging 설정
			this.numberObjArr = [];
			this.setupPagingNumber();

			// paging count 설정
			this.setupPagingCount();

			// ref 저장
			this.setupRefVal();

			// event 설정
			this.setupEvent();

			return this;
		}

	,	setupPagingNumber : function() {

			var divTag = document.createElement( "div" );
			divTag.className = "paging";
			this.append( divTag );


			// pudd-pager-btn-first
			if( true ) {

				var spanBtnTag = document.createElement( "span" );
				this.firstBtnObj = new Pudd.Element( spanBtnTag );

				var btnStr = this.attr( "pudd-pager-btn-first" );
				if( btnStr && ( typeof btnStr === "string" ) && ( "true" == btnStr.toLowerCase().trim() ) ) {

					spanBtnTag.className = "first";

				} else {

					spanBtnTag.className = "first disabled";
				}
				divTag.appendChild( spanBtnTag );

				// 내부 anchor 생성
				var aTag = document.createElement( "a" );
				aTag.textContent = "first";
				aTag.href = "javascript:;";
				spanBtnTag.appendChild( aTag );

				// 빈공간 추가
				this.appendChildTextNode( divTag, " " );
			}


			// pudd-pager-btn-prev
			if( true ) {

				var spanBtnTag = document.createElement( "span" );
				this.prevBtnObj = new Pudd.Element( spanBtnTag );

				var btnStr = this.attr( "pudd-pager-btn-prev" );
				if( btnStr && ( typeof btnStr === "string" ) && ( "true" == btnStr.toLowerCase().trim() ) ) {

					spanBtnTag.className = "pre";

				} else {

					spanBtnTag.className = "pre disabled";
				}
				divTag.appendChild( spanBtnTag );

				// 내부 anchor 생성
				var aTag = document.createElement( "a" );
				aTag.textContent = "prev";
				aTag.href = "javascript:;";
				spanBtnTag.appendChild( aTag );

				// 빈공간 추가
				this.appendChildTextNode( divTag, " " );
			}


			// pudd-pager-start-no, pudd-pager-end-no, pudd-pager-select-no
			if( true ) {

				var stratNo = null;
				var endNo = null;
				var selectNo = null;

				var startStr = this.attr( "pudd-pager-start-no" );
				if( startStr && ( typeof startStr === "string" ) ) {

					stratNo = parseInt( startStr, 10 );
				}

				var endStr = this.attr( "pudd-pager-end-no" );
				if( endStr && ( typeof endStr === "string" ) ) {

					endNo = parseInt( endStr, 10 );
				}

				var selectStr = this.attr( "pudd-pager-select-no" );
				if( selectStr && ( typeof selectStr === "string" ) ) {

					selectNo = parseInt( selectStr, 10 );
				}

				if( ( null != stratNo ) && ( null != endNo ) && ( null != selectNo ) ) {

					var olTag = document.createElement( "ol" );
					divTag.appendChild( olTag );

					for( var i=stratNo; i<=endNo; i++ ) {

						var liTag = document.createElement( "li" );
						olTag.appendChild( liTag );

						if( i == selectNo ) {

							liTag.className = "on";
							this.selectNoVal = i;
						}

						var aTag = document.createElement( "a" );
						liTag.appendChild( aTag );

						var anchorObj = new Pudd.Element( aTag );
						anchorObj.attr( "href", "javascript:;" );
						anchorObj.text( i );
						anchorObj.no = i;
						this.numberObjArr.push( anchorObj );
					}

					// 빈공간 추가
					this.appendChildTextNode( divTag, " " );
				}
			}


			// pudd-pager-btn-next
			if( true ) {

				var spanBtnTag = document.createElement( "span" );
				this.nextBtnObj = new Pudd.Element( spanBtnTag );

				var btnStr = this.attr( "pudd-pager-btn-next" );
				if( btnStr && ( typeof btnStr === "string" ) && ( "true" == btnStr.toLowerCase().trim() ) ) {

					spanBtnTag.className = "nex";

				} else {

					spanBtnTag.className = "nex disabled";
				}
				divTag.appendChild( spanBtnTag );

				// 내부 anchor 생성
				var aTag = document.createElement( "a" );
				aTag.textContent = "next";
				aTag.href = "javascript:;";
				spanBtnTag.appendChild( aTag );

				// 빈공간 추가
				this.appendChildTextNode( divTag, " " );
			}


			// pudd-pager-btn-last
			if( true ) {

				var spanBtnTag = document.createElement( "span" );
				this.lastBtnObj = new Pudd.Element( spanBtnTag );

				var btnStr = this.attr( "pudd-pager-btn-last" );
				if( btnStr && ( typeof btnStr === "string" ) && ( "true" == btnStr.toLowerCase().trim() ) ) {

					spanBtnTag.className = "last";

				} else {

					spanBtnTag.className = "last disabled";
				}
				divTag.appendChild( spanBtnTag );

				// 내부 anchor 생성
				var aTag = document.createElement( "a" );
				aTag.textContent = "last";
				aTag.href = "javascript:;";
				spanBtnTag.appendChild( aTag );

				// 빈공간 추가
				this.appendChildTextNode( divTag, " " );
			}
		}

	,	setupPagingCount : function() {

			var divTag = document.createElement( "div" );
			divTag.className = "gt_count";
			this.append( divTag );


			var blockCountStr = this.attr( "pudd-pager-block-count" );
			if( blockCountStr && ( typeof blockCountStr === "string" ) ) {

				blockCountStr = blockCountStr.toLowerCase().trim();
			}


			var blockListStr = this.attr( "pudd-pager-block-list" );
			if( blockListStr && ( typeof blockListStr === "string" ) ) {

				var arr = blockListStr.split( "," );
				if( arr.length > 0 ) {

					var selectTag = document.createElement( "select" );
					divTag.appendChild( selectTag );

					this.blockListObj = new Pudd.Element.Control.ComboBox( selectTag );
					this.blockListObj.style( "width:50px;" );

					var idx = 0;

					for( var i=0; i<arr.length; i++ ) {

						var val = arr[ i ].toLowerCase().trim();

						var optionTag = document.createElement( "option" );
						optionTag.value = val;
						optionTag.textContent = val;

						if( ( null != blockCountStr ) && ( blockCountStr == val ) ){

							idx = i;
						}

						this.blockListObj.append( optionTag );
					}

					this.blockListObj.node.selectedIndex = idx;

					this.blockListObj.setup();
				}
			}
		}

	,	setupRefVal : function() {

			var refStr = this.attr( "pudd-pager-ref" );
			if( refStr && ( typeof refStr === "string" ) ) {

				this.refVal = refStr.trim();
			}
		}

	,	setupEvent : function() {

			var thisObj = this;

			if( this.firstBtnObj ) {

				this.firstBtnObj.on( "click", function( e ) {

					var selfObj = Pudd.getInstance( this );
					if( ! selfObj.hasClass( "disabled" ) ) {

						thisObj.pagerCustomEvent( "first", null );
					}
				});
			}

			if( this.prevBtnObj ) {

				this.prevBtnObj.on( "click", function( e ) {

					var selfObj = Pudd.getInstance( this );
					if( ! selfObj.hasClass( "disabled" ) ) {

						thisObj.pagerCustomEvent( "prev", null );
					}
				});
			}

			if( this.nextBtnObj ) {

				this.nextBtnObj.on( "click", function( e ) {

					var selfObj = Pudd.getInstance( this );
					if( ! selfObj.hasClass( "disabled" ) ) {

						thisObj.pagerCustomEvent( "next", null );
					}
				});
			}

			if( this.lastBtnObj ) {

				this.lastBtnObj.on( "click", function( e ) {

					var selfObj = Pudd.getInstance( this );
					if( ! selfObj.hasClass( "disabled" ) ) {

						thisObj.pagerCustomEvent( "last", null );
					}
				});
			}

			this.numberObjArr.forEach( function( item, idx ) {

				item.on( "click", function( e ) {

					var selfObj = Pudd.getInstance( this );
					thisObj.pagerCustomEvent( null, selfObj.no );
				});
			});

			if( this.blockListObj ) {

				this.blockListObj.on( "change", function( e ) {

					var selfObj = Pudd.getInstance( this );
					var val = selfObj.val();
					thisObj.pagerCustomEvent( null, null, val );
				});
			}
		}

	,	pagerCustomEvent : function( btnVal, numberVal ) {

			var evntValue = {};
			evntValue.first = false;
			evntValue.prev = false;
			evntValue.next = false;
			evntValue.last = false;
			evntValue.selectNo = null;
			evntValue.blockCount = null;
			evntValue.ref = this.refVal;


			if( btnVal ) {

				evntValue.first = ( "first" == btnVal ) ? true : false;
				evntValue.prev = ( "prev" == btnVal ) ? true : false;
				evntValue.next = ( "next" == btnVal ) ? true : false;
				evntValue.last = ( "last" == btnVal ) ? true : false;

				evntValue.selectNo = this.selectNoVal;
			}

			if( numberVal ) {

				evntValue.selectNo = numberVal;
			}

			evntValue.blockCount = this.blockListObj.val();


			var evnt = new CustomEvent( "Event", { detail : evntValue } );
			evnt.initEvent( "pagerClick", true, true );
			this.node.dispatchEvent( evnt );
		}
	}
});
