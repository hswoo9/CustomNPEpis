/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.portlet.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Portlet = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element

	// class methods
,	extend : {

		setup : function() {

this.text( "portlet" );


			// event 설정
//			this.setupEvent();

			return this;
		}

	,	drawTable : function() {

		}

	,	setupEvent : function() {

		}
	}
});
