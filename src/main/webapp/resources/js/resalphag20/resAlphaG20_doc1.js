/**
	지출결의서
 */
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
		var numKOR = "(" + numToKOR($("[name=TOTAL_AB_APPLY_AM]").html().toMoney2()) + "원정)";
		$("[name=TOTAL_AB_APPLY_AM_KOR]").html(numKOR);
		var tempRes = _g_outProcessDetailData.filter(function(obj){return obj.resResSeq != "" && obj.resResSeq != null});
		var tempBudget = _g_outProcessDetailData.filter(function(obj){return obj.budgetResSeq != "" && obj.budgetResSeq != null});
		var tempTrade = _g_outProcessDetailData.filter(function(obj){return obj.tradeResSeq != "" && obj.tradeResSeq != null});
		makeContents();
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
	
	function makeContents(){
		$("[name=_F_INTER_]").html("");
		
		var tempRes = _g_outProcessDetailData.filter(function(obj){return obj.resResSeq != "" && obj.resResSeq != null});
		var tempBudget = _g_outProcessDetailData.filter(function(obj){return obj.budgetResSeq != "" && obj.budgetResSeq != null});
		var tempTrade = _g_outProcessDetailData.filter(function(obj){return obj.tradeResSeq != "" && obj.tradeResSeq != null});
		
		var contents = '';
		contents += '	<table border="1" cellspacing="0"';
		contents += '		class="budgetTable"';
		contents += '		style="table-layout: fixed; word-break: break-all; text-align: center; width: 100%; font-size: 10pt; border-width:2px;">';
		contents += '		<colgroup>';
		contents += '			<col width="6%">';
		contents += '			<col width="9%">';
		contents += '			<col width="26%">';
		contents += '			<col width="14%">';
		contents += '			<col width="14%">';
		contents += '			<col width="14%">';
		contents += '			<col width="17%">';
		contents += '		</colgroup>';
		contents += '		<tbody>';
		contents += '			<tr>';
		contents += '				<td colspan="7"';
		contents += '					style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b> &lt; 사업별 지출 금액 &gt; </b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '			</tr>';
		contents += '			<tr>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>순번</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>코드</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>사업명</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>관</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>항</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>목</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">';
		contents += '						<b>금액</b>';
		contents += '					</p>';
		contents += '				</td>';
		contents += '			</tr>';
		
		var budgetSum = 0;
		var tempArr = new Array();
		var index = 1;
		$.each(tempBudget, function(inx){
			var abBgtCd = this.abBgtCd;
			var abMgtCd = this.abMgtCd;
			if(tempArr.filter(function(obj){return obj.abBgtCd == abBgtCd && obj.abMgtCd == abMgtCd}).length > 0){
				return;
			}
			var tempBudget2 = tempBudget.filter(function(obj){return obj.abBgtCd == abBgtCd && obj.abMgtCd == abMgtCd});
			var abApplyAm = 0;
			$.each(tempBudget2, function(){
				abApplyAm += parseInt(this.abApplyAm);
			});
			
			contents += '			<tr class="">';
			contents += '				<td style="height: 30px;" class="budgetBaseTd">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">' + index + '</p>';
			contents += '				</td>';
			contents += '				<td style="height: 30px;">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">' + this.abMgtCd + '</p>';
			contents += '				</td>';
			contents += '				<td style="height: 30px;">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">' + this.abMgtNm + '</p>';
			contents += '				</td>';
			contents += '				<td style="height: 30px;">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">' + this.abBgtNmA + '</p>';
			contents += '				</td>';
			contents += '				<td style="height: 30px;">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">' + this.abBgtNmB + '</p>';
			contents += '				</td>';
			contents += '				<td style="height: 30px;">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;">' + this.abBgtNmC + '</p>';
			contents += '				</td>';
			contents += '				<td style="height: 30px;">';
			contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;margin-right:2px;text-align:right;">' + abApplyAm.toString().toMoney() + '</p>';
			contents += '				</td>';
			contents += '			</tr>';
			
			budgetSum += parseInt(abApplyAm);
			tempArr.push({abBgtCd : abBgtCd, abMgtCd : abMgtCd});
			index++;
		});
		
		contents += '			<tr class="">';
		contents += '				<td style="height: 30px;" class="budgetBaseTd" colspan="6">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px; font-weight:bold;">합 계</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px;">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;margin-right:2px;font-weight:bold;text-align:right;">' + budgetSum.toString().toMoney() + '</p>';
		contents += '				</td>';
		contents += '			</tr>';
		
		contents += '		</tbody>';
		contents += '	</table>';
		contents += '<p style="font-family:돋움체;font-size:10pt;color:rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;"><br></p>';
		
		contents += '<table border="1" cellspacing="0" class="tradeTable"';
		contents += '	style="table-layout: fixed; word-break: break-all; text-align: center; width: 100%; font-size: 10pt; border-width:2px;">';
		contents += '	<colgroup>';
		contents += '		<col width="6%">';
		contents += '		<col width="25%">';
		contents += '		<col width="14%">';
		contents += '		<col width="8%">';
		contents += '		<col width="10%">';
		contents += '		<col width="20%">';
		contents += '		<col width="17%">';
		contents += '	</colgroup>';
		contents += '	<tbody>';
		contents += '		<tr>';
		contents += '			<td colspan="7"';
		contents += '				style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>세부내역</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '		</tr>';
		contents += '		<tr>';
		contents += '			<td rowspan="2"';
		contents += '				style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>순번</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td';
		contents += '				style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>거래처명</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>사업자번호</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td rowspan="2" style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>증빙<br/>유형</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td colspan="2"';
		contents += '				style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>예금주</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td rowspan="2"';
		contents += '				style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>금액</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '		</tr>';
		contents += '		<tr>';
		contents += '			<td colspan="2" style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>관 / 항 / 목</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>은행명</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '			<td style="height: 30px; background-color: rgb(229, 229, 229);">';
		contents += '				<p';
		contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">';
		contents += '					<b>계좌번호</b>';
		contents += '				</p>';
		contents += '			</td>';
		contents += '		</tr>';
		
		var index = 0;
		var rgb = 'rgb(0, 0, 0)';
		$.each(tempRes, function(){
			var resInfo = this;
			var tradeList = tempTrade.filter(function(obj){return obj.tradeResSeq == resInfo.resResSeq});
			
			if(tradeList.length > 0){
				
				var tradeSum = 0;
				$.each(tradeList, function(){
					index ++;
					var tradeBudgetSeqTemp = this.tradeBudgetSeq;
					var budgetInfo = tempBudget.filter(function(obj){return obj.budgetBudgetSeq == tradeBudgetSeqTemp})[0];
					
					var interfaceType = budgetInfo.abSetTypeNm;
					$.ajax({
						url : "/CustomNPEPIS/resAlphaG20/getResTrade",
						data : {trade_seq : this.tradeTradeSeq},
						type : 'POST',
						datatype : 'json',
						async : false,
						success : function(data) {
							if (data.resTrade) {
								if(data.resTrade.interface_type == 'etax'){
									interfaceType = '세금<br/>계산서';
								}else if(data.resTrade.interface_type == 'notax'){
									interfaceType = '계산서';
								}else if(data.resTrade.interface_type == 'card'){
									interfaceType = '법인<br/>카드';
								}else{
									interfaceType = '기타';
								}
							}
							console.log(data);
						}
					});
					
					if(index % 2 == 1){
						rgb = 'rgb(255, 255, 255)';
					}else{
						rgb = 'rgb(242, 242, 242)';
					}
					contents += '		<tr class="" style="background-color: ' + rgb + '">';
					contents += '			<td rowspan="2" style="height: 30px;" class="tradeBaseTd">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + index + '</p>';
					contents += '			</td>';
					contents += '			<td style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + this.atTrNm + '</p>';
					contents += '			</td>';
					contents += '			<td style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + this.atRegNb.toRegNb() + '</p>';
					contents += '			</td>';
					// 증빙
					contents += '			<td rowspan="2" style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + interfaceType + '</p>';
					contents += '			</td>';
					contents += '			<td colspan="2" style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + this.atDepositor + '</p>';
					contents += '			</td>';
					contents += '			<td rowspan="2" style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;margin-right: 2px;text-align:right;">' + this.atUnitAm.toMoney() + '</p>';
					contents += '			</td>';
					contents += '		</tr>';
					contents += '		<tr class="" style="background-color: ' + rgb + '">';
					contents += '			<td colspan="2" style="height: 30px;">';
					contents += '				<span';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + budgetInfo.abBgtNmA + '</span>';
					if(budgetInfo.abBgtNmB){
						contents += '				<span';
						contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">/ ' + budgetInfo.abBgtNmB + '</span>';
					}
					if(budgetInfo.abBgtNmC){
						contents += '				<span';
						contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">/ ' + budgetInfo.abBgtNmC + '</span>';
					}
					contents += '			</td>';
					contents += '			<td style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + this.atBtrNm + '</p>';
					contents += '			</td>';
					contents += '			<td style="height: 30px;">';
					contents += '				<p';
					contents += '					style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0); margin-top: 0px; margin-bottom: 0px;">' + this.atAccountNb + '</p>';
					contents += '			</td>';
					contents += '		</tr>';
					
					tradeSum += parseInt(this.atUnitAm);
				});
			
				contents += '			<tr class="" style="background-color: ' + rgb + '">';
				contents += '				<td style="height: 30px;" class="budgetBaseTd" colspan="6">';
				contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px; font-weight:bold;">(' + resInfo.aMgtCd + ') ' + resInfo.aMgtNm + ' 소계</p>';
				contents += '				</td>';
				contents += '				<td style="height: 30px;">';
				contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px; font-weight:bold;margin-right: 2px;text-align:right;">' + tradeSum.toString().toMoney() + '</p>';
				contents += '				</td>';
				contents += '			</tr>';
				
			}
		});
		contents += '			<tr class="">';
		contents += '				<td style="height: 30px;" class="budgetBaseTd" colspan="6">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px; font-weight:bold;">합&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</p>';
		contents += '				</td>';
		contents += '				<td style="height: 30px;">';
		contents += '					<p style="font-family: 돋움체; font-size: 10pt; color: rgb(0, 0, 0);margin-top:0px;margin-bottom:0px; font-weight:bold;margin-right: 2px;text-align:right;">' + budgetSum.toString().toMoney() + '</p>';
		contents += '				</td>';
		contents += '			</tr>';
		contents += '	</tbody>';
		contents += '</table>';
		
		contents += '<p style="font-family:돋움체;font-size:10pt;color:rgb(0, 0, 0);margin-top:0px;margin-bottom:0px;"><br></p>';
		
		$("[name=_F_INTER_]").html(contents);
	}