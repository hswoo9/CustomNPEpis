
/**
 *	 Init 
 */
$(function() {
	/* 
	 * 숫자만 입력 가능 
	 *	Input Property = 'numberOnly' 
	 */
	$("input:text[numberOnly]").on("keyup", function() {
	    $(this).val($(this).val().replace(/[^0-9]/g,""));
	});
	
	/*
	 *  숫자 입력 시 금액 단위 , 표시
	 *  input class = 'amountUnit'
	 */
	$('.amountUnit').on('focus', function() {
		var val = $(this).val();
		if (!isEmpty(val)) {
			val = val.replace(/,/g, '');
			$(this).val(val);
		}
	});
	
	$('.amountUnit').on('blur', function() {
		var val = $(this).val();
		if (!isEmpty(val) && isNumeric(val)) {
			val = currencyFormatter(val);
			$(this).val(val);
		}
	})
	
})

/**
 * 예산 관련 화면 함수들 
 */
var Budget = {
		fn_formatMoney : function(str) {
			if (typeof str === 'undefined') {
				str = '';
			}
			
			str = String(str);
		    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		},
		fn_formatDate : function(str) {
			str = String(str);
			var result = str.substring(0, 4) + '/' + str.substring(4, 6);
			
			return str.length > 6 ? result + '/' + str.substring(6) : result; 
		}
}

/**
 *  Common Fn
 */
function isEmpty(value) {
	if (value.length == 0 || value == null) {
		return true;
	} else {
		return false;
	}
}

function isNumeric(value) {
	var regExp = /^[0-9]+$/g;
	return regExp.test(value);
}

function currencyFormatter(amount) {
	amount = amount.replace(/(^0+)/, "");
	
	return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

/**
 * Stirng ProtoType startsWtih polyfill
 */

// startsWith
if (!String.prototype.startsWith) {
	String.prototype.startsWith = function(search, pos) {
		return this.substr(!pos || pos < 0 ? 0 : +pos, search.length) === search;
	};
}

// endsWith
if (!String.prototype.endsWith) {
	  String.prototype.endsWith = function(searchString, position) {
	      var subjectString = this.toString();
	      if (typeof position !== 'number' || !isFinite(position) || Math.floor(position) !== position || position > subjectString.length) {
	        position = subjectString.length;
	      }
	      position -= searchString.length;
	      var lastIndex = subjectString.indexOf(searchString, position);
	      return lastIndex !== -1 && lastIndex === position;
	  };
	}