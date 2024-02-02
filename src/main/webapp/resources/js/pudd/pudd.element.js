/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.element.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Element = Pudd.invent({

	// constructor
	init : function( node ) {

		this.node = null;

		var element, nodeType;

		// element node 인 경우만 셋팅 - 1 : element, 9 - document
		if ( (element = node) && ( 1 === ( nodeType = element.nodeType ) || 9 === ( nodeType = element.nodeType ) ) ) {

			this.node = element;
			this.node.instance = this;

		} else {

			var nodeStr;
			if( ( nodeStr = node ) && ( typeof nodeStr === "string" ) ) {

				 nodeStr = nodeStr.toLowerCase().trim();

	 			var idx = Pudd.define.tagList.indexOf( nodeStr );
				if( -1 != idx ) {

					this.node = document.createElement( nodeStr );
					this.node.instance = this;
				}
			}
		}
	}

	// class methods
,	extend : {

		attr : function( a, v ) {

			if( a == null ) {

				a = {};
				v = this.node.attributes;
				for( var i = v.length - 1; i >= 0; i-- ) {

					a[ v[ i ].nodeName ] = v[ i ].nodeValue;
				}

				return a;

			} else if( v === null ) {	// v 가 undefined 이면 false 임

				this.node.removeAttribute( a );

			} else if( v == null ) {	// v 가 undefined 이면 true 임

				return this.node.getAttribute( a );

			} else {

				this.node.setAttribute( a, v );
			}

			return this;
		}

	,	classes : function() {

			var attr = this.attr( "class" );

			return attr == null ? [] : attr.trim().split( Pudd.regex.delimiter );
		}

	,	hasClass : function( name ) {

			return this.classes().indexOf(name) != -1;
		}

	,	addClass : function( name ) {

			if( ! this.hasClass( name ) ) {

				var array = this.classes();
				array.push( name );
				this.attr( 'class', array.join(' ') );
			}

			return this;
		}

	,	removeClass : function( name ) {

			if( this.hasClass( name ) ) {

				this.attr( 'class', this.classes().filter( function( c ) {
					return c != name;
				}).join(' ') );
			}

			return this;
		}

	,	before : function( insertNode ) {

			if( this.node && this.node.parentNode ) {

				this.node.parentNode.insertBefore( insertNode, this.node );
			}
		}

	,	after : function( insertNode ) {

			if( this.node && this.node.parentNode ) {

				this.node.parentNode.insertBefore( insertNode, this.node.nextSibling );
			}
		}

	,	insertHTML : function( htmlStr, bAppend ) {

			if( typeof htmlStr !== "string" ) return;

			var tempDiv = document.createElement("div");
			tempDiv.innerHTML = htmlStr;

			if( bAppend ) {

				// 자식으로 추가
				while ( tempDiv.childNodes.length > 0 ) {
					this.append( tempDiv.childNodes[ 0 ] );
				}

			} else {

				// nextSibling 추가
				while ( tempDiv.childNodes.length > 0 ) {
					this.after( tempDiv.childNodes[ tempDiv.childNodes.length - 1 ] );
				}
			}
		}

	,	on : function( name, handler ) {

			var idx = Pudd.define.eventList.indexOf( name );
			if( -1 == idx ) return;

			if( this.node.addEventListener ) {

				this.node.addEventListener( name, handler, false );

			} else if( this.node.attachEvent ) {

				this.node.attachEvent( "on" + name, handler );
			}
		}

	,	off : function( name ) {

			// 향후에 필요한 경우 구현할 것
			// this.instance - addEventListener 등록시 함수 등록하고 remove 진행시에 instance 등록된 함수를 전달하여 remove 진행할 것
		}

	,	style : function( s, v ) {

			if( arguments.length == 0 ) {

				// get full style
				// style 속성 문구열 - The cssText property sets or returns the contents of a style declaration as a string
				return this.node.style.cssText || '';

			} else if( arguments.length < 2 ) {

				if( Pudd.regex.isCss.test(s) ) {

					// parse css string
					// \s* ==> 스페이스, 탭, 폼피드, 줄 바꿈 등의 문자 포함여부(0 개 이상)를 조사하여 ';' 문자로 split
					// filter 함수(Array객체 함수임) : split 진행된 배열에서 "" 값으로 추출된 배열은 Boolean 검사로 제거
					// map 함수(Array객체 함수임) : 각각의 배열값을 map 함수가 전달하는 값으로 새로운 배열값 설정함 - 여기서 map 함수는 ':' 문자로 style name과 value 추출함
					s = s.split(/\s*;\s*/)
							// filter out suffix ; and stuff like ;;
							.filter( function( e ) { return !!e; } )
								.map( function( e ) { return e.split(/\s*:\s*/); });

					// apply every definition individually
					// 할당하면서 검사하는 부분 - equal 아님
					// v 값이 undefined인 경우 if문의 안으로 진입하지 않음 - if(undefined) 즉, false 분기됨
					// v 값이 전달되는 경우만 if문 안으로 진입
					while( v = s.pop() ) {

						this.style( v[ 0 ], v[ 1 ] );
					}

				} else {

					// act as a getter if the first and only argument is not an object
					return this.node.style[ Pudd.camelCase( s ) ];
				}

			} else {

				this.node.style[ Pudd.camelCase( s ) ] = ( v === null || Pudd.regex.isBlank.test( v ) ) ? '' : v;
			}

			return this;
		}

	,	show : function() {

			this.style( "display:block;" );
			return this;
		}

	,	hide : function() {

			this.style( "display:none;" );
			return this;
		}

		// scroll 값을 반영한 offset 위치
	,	offset : function() {

			var rcPos = { left : 0, top : 0, right : 0, bottom : 0 };

			var rc = this.node.getBoundingClientRect();

			rcPos.left = parseInt( rc.left, 10 );
			rcPos.top = parseInt( rc.top, 10 );
			rcPos.right = parseInt( rc.right, 10 );
			rcPos.bottom = parseInt( rc.bottom, 10 );

			var scrollTop = parseInt( document.documentElement.scrollTop, 10 );
			var scrollLeft = parseInt( document.documentElement.scrollLeft, 10 );

			rcPos.left += scrollLeft;
			rcPos.top += scrollTop;
			rcPos.right += scrollLeft;
			rcPos.bottom += scrollTop;

			return rcPos;
		}

	,	text : function( s ) {

			if( null == s ) {

				return this.node.textContent || '';

			} else {

				if( typeof this.node.textContent === "string" ) {

					this.node.textContent = s;
				}
			}

			return this;
		}

	,	val : function( v ) {

			if( null == v ) {

				return this.node.value || '';

			} else {

				if( typeof this.node.value === "string" ) {

					this.node.value = v;
				}
			}

			return this;
		}

	,	append : function( child ) {

			if( child instanceof Pudd.Element ) {

				child = child.node;
			}

			this.node.appendChild( child );
		}

	,	fire : function( name, bubbles, cancelable ) {

			var evnt = document.createEvent( "Event" );
			//evnt.initEvent( name, true, true );
			evnt.initEvent( name, bubbles, cancelable );
			this.node.dispatchEvent( evnt );
		}

	,	parent : function() {

			return Pudd.getInstance( this.node.parentNode );
		}
	}
});
