/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.component.gridtable.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Component.GridTable = Pudd.invent({

	// constructor
	init : function( node ) {

		// header 객체
		this.headerObj = null;

		// content 객체
		this.contentObj = null;

		// headerTable 객체
		this.headerTableObj = null;

		// contentTable 객체
		this.contentTableObj = null;


		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element.Component

	// class methods
,	extend : {

		setup : function() {

			// component class 설정
			this.setupContainer();
			this.addClass( Pudd.Config.className.PUDD_UI_GridTable );


			// header용, content용 테이블로 분리(1개 테이블 -> 2개 테이블)
			// 테이블이 1개가 아니면 리턴
			if( ! this.arrangeTable() ) return;

			// grid-header 설정
			this.setupHeader();

			// grid-content 설정
			this.setupContent();

			// event 설정
			this.setupEvent();

			return this;
		}

	,	arrangeTable : function() {

			var tableArr = this.node.getElementsByTagName( "table" );
			if( 1 != tableArr.length ) return false;

			var oriNode = tableArr[0];
			var newNode = oriNode.cloneNode( true );

			// header용 테이블로 설정하기 위해 tbody 부분은 제거
			while( true ) {

				var tbodyArr = oriNode.getElementsByTagName( "tbody" );
				if( tbodyArr.length > 0 ) {

					oriNode.removeChild( tbodyArr[ 0 ] );
					continue;
				}

				break;
			}

			// content용 테이블로 설정하기 위해 thead 부분은 제거
			while( true ) {

				var theadArr = newNode.getElementsByTagName( "thead" );
				if( theadArr.length > 0 ) {

					newNode.removeChild( theadArr[ 0 ] );
					continue;
				}

				break;
			}

			this.headerTableObj = new Pudd.Element( oriNode );
			this.contentTableObj = new Pudd.Element( newNode );

			return true;
		}

	,	setupHeader : function() {

			var divTag = document.createElement( "div" );
			this.append( divTag );

			this.headerObj = new Pudd.Element( divTag );
			this.headerObj.addClass( "grid-header" );

			this.headerObj.append( this.headerTableObj );
		}

	,	setupContent : function() {

			var divTag = document.createElement( "div" );
			this.append( divTag );

			this.contentObj = new Pudd.Element( divTag );
			this.contentObj.addClass( "grid-content" );

			// pudd-grid-scroll 유형
			var scrollStr = this.attr( "pudd-grid-scroll" );
			if( scrollStr && ( typeof scrollStr === "string" ) && ( "true" == scrollStr.toLowerCase().trim() ) ) {

				this.addClass( Pudd.Config.className.scrollable );

				this.contentObj.addClass( "HeiStyle" );

				// pudd-content-height 유형
				var heightStr = this.attr( "pudd-content-height" );
				if( heightStr && ( typeof heightStr === "string" ) ) {

					this.contentObj.style( "height", heightStr );
				}
			}

			this.contentObj.append( this.contentTableObj );
		}

	,	setupEvent : function() {

			var thisObj = this;

			var tdArr = Pudd.querySelectAll( "td", this.contentTableObj.node );
			tdArr.forEach( function( item, idx ) {

				var tdObj = Pudd.getInstance( item );
				tdObj.on( "click", function( e ) {

					thisObj.switchClick();

					var selfObj = Pudd.getInstance( item );
					var parentObj = selfObj.parent();
					parentObj.addClass("on");
				});
			});
		}

	,	switchClick : function() {

			var trArr = Pudd.querySelectAll( "tr", this.contentTableObj.node );
			trArr.forEach( function( item, idx ) {

				item.className = "";
			});
		}
	}
});
