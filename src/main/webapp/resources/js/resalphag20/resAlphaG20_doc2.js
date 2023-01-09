/**
	입찰
 */
	var editorViewFlag = false;

	$(function(){
		String.prototype.toMoney  = function(){
			var val = (this.valueOf());
			var zero = val.charAt(0);

			var money = val.replace(/\D/g,"");
			var index = money.length - 3;
			while(index >0){
				money = money.substr(0,index) + "," + money.substr(index);
				index -=3;
			}
			if(zero == "-"){
				return "-" + money;
			}else{
				return money; 
			}
		};
		
		String.prototype.toMoney2  = function(){
			var val = (this.valueOf());
			var zero = val.charAt(0);

			var money = val.replace(/\D/g,"");
			
			if(zero == "-"){
				return "-" + money;
			}else{
				return money; 
			}
		};
		
		String.prototype.toRegNb  = function(){
			var val = (this.valueOf());

			var regNb = val.replace(/\D/g,"");
			
			if(val){
				regNb = regNb.substr(0,3) + "-" + regNb.substr(3,2) + "-" + regNb.substr(5);
			}
			return regNb; 
		};
		
		init();
	});

	function init(){
		editorViewInit();
	}
	
	function numToKOR(num){
		var minus = '';
		if(num.indexOf('-') != -1){
			minus = '-';
			num = num.replace('-','');
		}
		var hanA = new Array("","일","이","삼","사","오","육","칠","팔","구","십");
		var danA = new Array("","십","백","천","","십","백","천","","십","백","천","","십","백","천");
		var result = "";
		for(i=0; i<num.length; i++) {
			str = ""; han = hanA[num.charAt(num.length-(i+1))];
			if(han != "") str += han+danA[i];
			if(i == 4 && (num[num.length-1-i] !== '0' || num[num.length-1-i-1] !== '0' || num[num.length-1-i-2] !== '0' || num[num.length-1-i-3] !== '0')){
				str += "만";
			}
			if(i == 8 && (num[num.length-1-i] !== '0' || num[num.length-1-i-1] !== '0' || num[num.length-1-i-2] !== '0' || num[num.length-1-i-3] !== '0')){
				str += "억";
			}
			if(i == 12 && (num[num.length-1-i] !== '0' || num[num.length-1-i-1] !== '0' || num[num.length-1-i-2] !== '0' || num[num.length-1-i-3] !== '0')){
				str += "조";
			}
			result = str + result;
		}
		if(num != 0) 
			result = result + "";
		return minus + result ;
	}

	document.getElementById('editorView').onload = function(){
		editorViewInit();
	};
	
	function editorViewInit(){
		var cnt = 0;
		var editorView = document.getElementById('editorView').contentWindow.document;
		var repeat = setInterval(function(){
			if(editorViewFlag){
				return;
			}
			cnt++;
			if(cnt > 10){
				clearInterval(repeat);
			}else if($(editorView.getElementById('TB_TABMODE_SOURCE_0')).length > 0){
				$(editorView.getElementById('TB_TABMODE_SOURCE_0')).click();
				$(editorView.getElementById('dzeditorSource_0')).val($('td[name=_F_INTER_]').html());
				$(editorView.getElementById('TB_TABMODE_EDIT_0')).click();
				$('td[name=_F_INTER_]').html('');
				clearInterval(repeat);
				editorViewFlag = true;
			}
		}, 100);
	}
