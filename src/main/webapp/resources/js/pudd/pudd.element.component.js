/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.component.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element.Component = Pudd.invent({
	
	// constructor
	init : function( node ) {

		this.constructor.call( this, node );
	}

	// inherit
,	inherit : Pudd.Element

	// class methods
,	extend : {

		// 전체 공통
		setupContainer : function() {

			this.addClass( Pudd.Config.className.PUDD );
			this.addClass( pudding.skinName );// PUDD-COLOR-blue

			// puddSetup class 해제
			this.removeClass( "puddSetup" );
		}

	,	appendChildTextNode : function( parent, str ) {

			var textNode = document.createTextNode( str );
			parent.appendChild( textNode );

			return textNode;
		}
	}
});
