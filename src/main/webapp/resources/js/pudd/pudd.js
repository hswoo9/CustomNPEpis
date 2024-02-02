/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 객체 초기화 즉시실행코드
( function( root, factory ) {

	if( typeof define === 'function' && define.amd ) {

		define( function() {

			return factory( root, root.document );
		});

	} else if( typeof exports === 'object' ) {

		module.exports = root.document ? factory( root, root.document ) : function( w ){ return factory( w, w.document ); };

	} else {

		root.Pudd = factory( root, root.document );
	}

}( typeof window !== "undefined" ? window : this, function( window, document ) {



// this.Pudd 에서의 this는 window 객체
var Pudd = this.Pudd = function( selector ) {

	var doc = new Pudd.Doc( selector );
	return doc;
};


Pudd.extend = function() {

	var modules, methods, key, i;

	// ex) modules[0] - initializer 객체
	// ex) modules[1] - extent:{...} 객체
	modules = [].slice.call( arguments );

	// 배열 pop() 함수 : 배열의 마지막 요소를 삭제, return 값은 삭제된 마지막 요소
	// methods에 할당되는 내용은 extent:{...} 부분
	methods = modules.pop();

	// for문으로 할당한 이유 - Pudd.extend( Pudd.Class1, Pudd.Class2, { funcName1 : function() {...}, funcName2 : function() {...} } )
	// 여러개의 객체 선언에 할당할 수 있도록 for문 이용
	for( i = modules.length - 1; i >= 0; i-- ) {

		if( modules[i] ) {

			for( key in methods ) {

				// methods에 할당된 extent:{...} 부분 또는 함수 선언 부분을 modules의 prototype 내용으로 할당
				// ex) initializer.prototype["size"] = methods["size"] ==> function size(){...}
				modules[i].prototype[key] = methods[key];
			}
		}
	}
};


Pudd.invent = function( config ) {

	// initializer constructor는 config.init로 설정됨
	var initializer = config.init;

	// config.inherit 객체의 속성과 프로토타입 속성을 모두 상속
	if( config.inherit ) {

		initializer.prototype = new config.inherit;
	}

	// extend with methods
	if( config.extend ) {

		Pudd.extend( initializer, config.extend );
	}

	return initializer;
};


Pudd.regex = {

	// jquery에서 사용하는 정규식 적용
	// Easily-parseable/retrievable ID or TAG or CLASS selectors
	rquickExpr : /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/

	// split at whitespace and comma
	// \s : Matches any whitespace character (spaces, tabs, line breaks)
	// \s, : whitespace character 뒤에 , 있는 문자열
	// [\s,] : Match any character in the set
	// [\s,]+ : set안의 문자열이 1회 이상 반복
,	delimiter : /[\s,]+/

	// Test css declaration
	// [^:] 는 ':' 문자를 제외하고 문자 하나를 찾기
	// [^:]+; 는 ':' 문자를 제외한 문자 하나 이후 다음 문자가 : 인 문자 찾기
	// ? 는 앞의 문자나 하위 식을 0 개나 1 개 찾음
,	isCss : /[^:]+:[^;]+;?/

	// Test for blank string
,	isBlank : /^(\s+)?$/

};


Pudd.define = {

	// customEvent - pagerClick
	eventList : [ "click", "blur", "mousedown", "mouseup", "mousemove", "mouseover", "mouseout", "mouseenter", "mousewheel",
				"change", "focusin", "focusout", "keydown", "keypress", "keyup", "scroll",
				"pagerClick" ]

	// Full Tag List
//,	tagList : [ "a", "abbr", "acronym", "address", "applet", "area", "b", "base", "basefont", "bdo", "big", "blockquote", "body", "br", "button", "caption", "center", "cite", "code", 
//				"col", "colgroup", "dd", "del", "dfn", "dir", "div", "dl", "dt", "em", "fieldset", "font", "form", "frame", "frameset", "h1", "h2", "h3", "h4", "h5", "h6", "head", "hr", "html",
//				"i", "iframe", "img", "input", "ins", "isindex", "kbd", "label", "legend", "li", "link", "listing", "map", "menu", "meta", "nextid", "noframes", "noscript", "object", "ol", "optgroup",
//				"option", "p", "param", "plaintext", "pre", "q", "rb", "rbc", "rp", "rt", "rtc", "ruby", "s", "samp", "script", "select", "small", "span", "strike", "strong", "style", "sub", "sup",
//				"table", "tbody", "td", "textarea", "tfoot", "th", "thead", "title", "tr", "tt", "u", "ul", "var", "xmp" ]
,	tagList : [ "a", "area", "b", "blockquote", "br", "button", "caption", "center", "col", "colgroup", "dd", "div", "dl", "dt", "em", "fieldset", "font", "form", "h1", "h2", "h3", "h4", "h5", "h6",
				"hr", "i", "img", "input", "label", "li", "ol", "option", "p", "pre", "s", "script", "select", "span", "strike", "strong", "style", "sub", "sup",
				"table", "tbody", "td", "textarea", "tfoot", "th", "thead", "title", "tr", "u", "ul" ]
};


Pudd.querySelectAll = function( selector, context ) {

	var nodes = [];
	var match, element, nodeType;

	if ( !selector || typeof selector !== "string" ) {

		// element node 인 경우만 셋팅
		if ( (element = selector) && ( 1 === (nodeType = element.nodeType) ) ) {

			nodes.push( selector );
		}

	} else {
	
		if ( (match = Pudd.regex.rquickExpr.exec( selector )) ) {

			if ( match[1] ) {

				// Speed-up: Sizzle("#ID")
				if ( (element = context.getElementById( match[1] )) && element.id === match[1] ) {
					nodes.push( element );
				}

			} else if ( match[2] ) {

				// Speed-up: Sizzle("TAG")
				[].push.apply( nodes, [].slice.call( context.getElementsByTagName( match[2] ) ) );

			} else if ( match[3] ) {

				// Speed-up: Sizzle(".CLASS")
				[].push.apply( nodes, [].slice.call( context.getElementsByClassName( match[3] ) ) );
			}

		} else {

			[].push.apply( nodes, [].slice.call( context.querySelectorAll( selector ) ) );
		}
	}

	return nodes;
};


Pudd.camelCase = function( s ) {

	// 카멜표기법 : 각 단어의 첫문자를 대문자로 표기하고 붙여쓰되, 맨처음 문자는 소문자로 표기함
	// replace(정규식, function(x){return x 변경문자열})
	// 정규식 /-(.)/ : '-'문자로 시작되는 문자열, (.) 는 개행문자를 제외한 어떤 하나의 문자를 기억(포획괄호)
	// ex) background-color ==> backgroundColor
	// 해당되는 문구열이 넘어오는 경우 아래의 function(m, g) 함수 호출
	// ex) background-color 경우 function(m, g) 매개변수 값은 m 값은 -c, g 값은 c
	return s.toLowerCase().replace(/-(.)/g, function(m, g) {
		return g.toUpperCase();
	});
}


Pudd.getInstance = function( node ) {

	if( node.instance ) return node.instance;

	return new Pudd.Element( node );
};


Pudd.Doc = Pudd.invent({
	
	// constructor
	init : function( selector ) {

		this.nodes = null;
		this.length = 0;

		if( selector && typeof selector === "string" ) {

			this.nodes = Pudd.querySelectAll( selector, document );
			this.length = this.nodes.length;

		} else if( selector && typeof selector === "object" ) {

			if( selector instanceof Array ) {

				this.nodes = selector;
				this.length = this.nodes.length;

			} else {

				var element, nodeType;
				if ( (element = selector) && ( 1 === ( nodeType = element.nodeType ) || 9 === ( nodeType = element.nodeType ) ) ) {

					this.nodes = [];
					this.nodes.push( selector );
					this.length = this.nodes.length;
				}
			}
		}
	}

	// class methods
,	extend : {

		// Iterate over all members
		each : function( block ) {

			for( var i=0; i < this.nodes.length; i++ ) {

				block.apply( this.nodes[ i ], [ this.nodes[ i ], i ] );
			}

			return this;
		}

	,	on : function( name, handler ) {

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodeObj.on( name, handler );
			});
		}

	,	parent : function() {

			var nodes = [];

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodes.push( nodeObj.parent().node );
			});

			return Pudd( nodes );
		}

	,	find : function( selector ) {

			var nodes = [];

			if( selector && typeof selector === "string" ) {

				this.each( function( item, idx ) {

					var nodeObj = Pudd.getInstance( item );

					[].push.apply( nodes, [].slice.call( Pudd.querySelectAll( selector, nodeObj.node ) ) );
				});
			}

			return Pudd( nodes );
		}

	,	hasClass : function( name ) {

			if( this.nodes.length > 0 ) {

				var nodeObj = Pudd.getInstance( this.nodes[ 0 ] );
				return nodeObj.hasClass( name );
			}

			return false;
		}

	,	addClass : function( name ) {

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodeObj.addClass( name );
			});

			return this;
		}

	,	removeClass : function( name ) {

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodeObj.removeClass( name );
			});

			return this;
		}

	,	show : function() {

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodeObj.show();
			});

			return this;
		}

	,	hide : function() {

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodeObj.hide();
			});

			return this;
		}

	,	append : function( child ) {

			if( child instanceof Pudd.Element ) {

				child = child.node;
			}

			this.each( function( item, idx ) {

				var nodeObj = Pudd.getInstance( item );
				nodeObj.append( child );
			});

			return this;
		}

	,	attr : function( a, v ) {

			if( a == null ) {

				if( this.nodes && ( this.nodes.length > 0 ) ) {

					var nodeObj = Pudd.getInstance( this.nodes[ 0 ] );
					return nodeObj.attr( a, v );
				}

				return null;

			} else if( v === null ) {

				this.each( function( item, idx ) {

					var nodeObj = Pudd.getInstance( item );
					nodeObj.attr( a, v );
				});

			} else if( v == null ) {

				if( this.nodes && ( this.nodes.length > 0 ) ) {

					var nodeObj = Pudd.getInstance( this.nodes[ 0 ] );
					return nodeObj.attr( a, v );
				}

				return null;

			} else {

				this.each( function( item, idx ) {

					var nodeObj = Pudd.getInstance( item );
					nodeObj.attr( a, v );
				});
			}

			return this;
		}

	,	val : function( v ) {

			if( null == v ) {

				if( this.nodes && ( this.nodes.length > 0 ) ) {

					var nodeObj = Pudd.getInstance( this.nodes[ 0 ] );
					return nodeObj.val( v );
				}

				return null;

			} else {

				this.each( function( item, idx ) {

					var nodeObj = Pudd.getInstance( item );
					nodeObj.val( v );
				});
			}

			return this;
		}

	,	text : function( v ) {

			if( null == v ) {

				if( this.nodes && ( this.nodes.length > 0 ) ) {

					var nodeObj = Pudd.getInstance( this.nodes[ 0 ] );
					return nodeObj.text( v );
				}

				return null;

			} else {

				this.each( function( item, idx ) {

					var nodeObj = Pudd.getInstance( item );
					nodeObj.text( v );
				});
			}

			return this;
		}

	,	create : function( htmlStr ) {

			this.each( function( item, idx ) {

				var divTag = document.createElement( "div" );
				divTag.innerHTML = htmlStr;

				var nodeObj = Pudd.getInstance( item );

				while( divTag.childNodes.length > 0 ) {

					nodeObj.append( divTag.childNodes[ 0 ] );
				}
			});

			Pudd.initControl();

			return this;
		}
	}
});


Pudd.initControl = function( autoApply ) {

	// grid 생성 부분은 thead, tbody DOM 조작이 있는 관계로 제일 먼저 변환 처리
	// 우선적으로 처리하지 않으면 grid 내부의 컨트롤이 DOM 위치가 변경되기 때문에 click 등의 event 설정이 무효가 됨
	var gridDoc;
	if( autoApply ) {

		gridDoc = new Pudd.Doc( "div" );

	} else {

		gridDoc = new Pudd.Doc( "div.puddSetup" );
	}

	gridDoc.each( function( item, idx ) {

		var typeStr = this.getAttribute("pudd-type");
		if( typeStr && typeof typeStr === "string" ) {

			typeStr = typeStr.toLowerCase().trim();

			if( "gridtable" == typeStr ) {

				var gridObj = new Pudd.Element.Component.GridTable( this );
				gridObj.setup();
			}
		}
	});



	var doc;
	if( autoApply ) {

		doc = new Pudd.Doc( "input, select, textarea, div" );

	} else {

		doc = new Pudd.Doc( ".puddSetup" );
	}

	doc.each( function( item, idx ) {

		// this 와 item 동일 객체
		var nodeNameStr = this.nodeName.toLowerCase();
		if( "input" == nodeNameStr ) {

			var typeStr = this.getAttribute("type");
			if( "text" == typeStr ) {

				var typeStr = this.getAttribute("pudd-type");
				if( typeStr && "datepicker" == typeStr.toLowerCase().trim() ) {

					var datepickerObj = new Pudd.Element.Control.DatePicker( this );
					datepickerObj.setup();

				} else {

					var textboxObj = new Pudd.Element.Control.TextBox( this );
					textboxObj.setup();
				}

			} else if( "password" == typeStr ) {

				var passwordObj = new Pudd.Element.Control.Password( this );
				passwordObj.setup();

			} else if( "checkbox" == typeStr ) {

				var checkBoxObj = new Pudd.Element.Control.CheckBox( this );
				checkBoxObj.setup();

			} else if( "radio" == typeStr ) {

				var radioObj = new Pudd.Element.Control.Radio( this );
				radioObj.setup();

			} else if( "button" == typeStr ) {

				var buttonObj = new Pudd.Element.Control.Button( this );
				buttonObj.setup();

			} else if( "file" == typeStr ) {

				var fileObj = new Pudd.Element.Control.FileBox( this );
				fileObj.setup();
			}

		} else if( "select" == nodeNameStr ) {

			var selectObj = new Pudd.Element.Control.ComboBox( this );
			selectObj.setup();

		} else if( "textarea" == nodeNameStr ) {

			var textAreaObj = new Pudd.Element.Control.TextArea( this );
			textAreaObj.setup();

		} else if( "div" == nodeNameStr ) {

			var typeStr = this.getAttribute("pudd-type");
			if( typeStr && typeof typeStr === "string" ) {

				typeStr = typeStr.toLowerCase().trim();

				if( "calendar" == typeStr ) {

					var calendarObj = new Pudd.Element.Component.Calendar( this );
					calendarObj.setup();

				} else if( "gridtable" == typeStr ) {

					// Do-Nothing : 상단에서 처리함

				} else if( "pager" == typeStr ) {

					var pagerObj = new Pudd.Element.Component.Pager( this );
					pagerObj.setup();

				} else if( "portlet" == typeStr ) {

					var portletObj = new Pudd.Portlet( this );
					portletObj.setup();
				}
			}
		}
	});
};



	return Pudd;
}));





// String trim 함수 정의
if( ! String.prototype.trim ) {

	String.prototype.trim = function() {
		return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
	};
}


// CustomEvent 정의 for IE, 참조 MDN
( function() {

	if( typeof window.CustomEvent === "function" ) return false;

	function CustomEvent( event, params ) {

		params = params || { bubbles : false, cancelable : false, detail : undefined };
	    var evt = document.createEvent( "CustomEvent" );
	    evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
		return evt;
	}

	CustomEvent.prototype = window.Event.prototype;

	window.CustomEvent = CustomEvent;
})();


// puddready 정의
! function( name, definition ) {

	if( typeof module != 'undefined' ) module.exports = definition();
	else if( typeof define == 'function' && typeof define.amd == 'object' ) define( definition );
	else this[ name ] = definition();

}( 'puddready', function() {

	var fns = [], listener;
	var doc = typeof document === 'object' && document;
	var hack = doc && doc.documentElement.doScroll;
	var domContentLoaded = 'DOMContentLoaded';
	var loaded = doc && ( hack ? /^loaded|^c/ : /^loaded|^i|^c/ ).test( doc.readyState );

	if( ! loaded && doc ) {

		doc.addEventListener( domContentLoaded, listener = function() {

			doc.removeEventListener( domContentLoaded, listener );
			loaded = 1;
			while( listener = fns.shift() ) listener();
		});
	}

	return function (fn) {
		loaded ? setTimeout(fn, 0) : fns.push(fn);
	};
});


puddready( function() {

	if( pudding && ( typeof pudding.autoApply === "boolean" ) && pudding.autoApply ) {

		pudding.autoApply = false;
		Pudd.initControl( true );

	} else {

		Pudd.initControl();
	}
});
