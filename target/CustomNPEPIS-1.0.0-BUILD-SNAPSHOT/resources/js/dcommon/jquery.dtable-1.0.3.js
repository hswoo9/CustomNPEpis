/*
단순하게, tr 과 td 로 구성
td 의 위치에 맞춰 textarea 가 함꼐 이동하는 형태
textarea 는 설정된 옵션에 따르 별도 이벤트 수행
*/

/* using jquery.mask.js : https://igorescobar.github.io/jQuery-Mask-Plugin/ */
(function ($) {
	var tableElem = {
		checkboxAll: '[CHECKBOX_ALL]',
		checkbox: '[CHECKBOX]',
		no: '[NO]'
	};
	var tableDef = {
		leftHeadTable: 'lht',
		rightHeadTable: 'rht',
		leftContentTable: 'lct',
		rightContentTable: 'rct',
		multiRow: 'mr',
		zero: 0,
		offsetDefault: 25
	};
	var tableFnc = {
		isLht: function (param) {
			return (param.indexOf(tableDef.leftHeadTable) > -1 ? true : false);
		},
		isRht: function (param) {
			return (param.indexOf(tableDef.rightHeadTable) > -1 ? true : false);
		},
		isLct: function (param) {
			return (param.indexOf(tableDef.leftContentTable) > -1 ? true : false);
		},
		isRct: function (param) {
			return (param.indexOf(tableDef.rightContentTable) > -1 ? true : false);
		},
		isMr: function (param) {
			return (param.indexOf(tableDef.multiRow) > -1 ? true : false);
		},
		num: function (value, defaultValue) {
			value = (value || '-');
			defaultValue = (defaultValue || tableDef.zero);
			return isNaN(Number(value.toString().replace(/,/g, ''))) ? defaultValue : Number(value.toString().replace(/,/g, ''));
		}
	};
	var methods = {
		/* [+] ## init ######################################################################################################################################################################################################## */
		init: function (options) {
			/* 기본 파라미터 정의 */
			var defaults = {
				/* lht : 왼쪽 헤더 테이블 / rht : 오른쪽 헤더 테이블 / lct : 왼쪽 본문 테이블 / rct : 오른쪽 본문 테이블 / mr : 다중행 */
				/* 헤더의 경우 상단 고정되며, 왼쪽 테이블이 틀고정 됩니다. */
				/* ex : 'layout': ['lht', 'rht', 'lct', 'rct', 'mr'] */
				'layout': [],
				/* 헤더의 타이틀을 정의합니다. ( 전체 크기에 영향이 있습니다. ) */
				/* [no] : 행번호를 반환합니다. / [checkbox_all] : 체크박스를 반환합니다. / [checkbox] : 체크박스를 반환합니다. */
				/* ex : 'colHeaders': ['No', '[checkbox_all]', '차량', '운행일자', '운행구분', '출발시간', '출발지'] */
				'colHeaders': [],
				'colNames': [], // TODO: 미구현
				/* 각 컬럼의 너비를 정의합니다. */
				/* colHeaders 와 lenth 가 동일해야 합니다. */
				/* ex : 'colWidth': [32, 34, 100, 100, 100, 100, 100] */
				'colWidth': [],
				/* 각 컬럼의 정렬을 정의합니다. */
				/* colHeaders 와 lenth 가 동일해야 합니다. */
				/* ex : 'colAlignments': ['cen', 'cen', 'cen', 'cen', 'cen', 'cen', 'cen'] */
				'colAlignments': [],
				/* 각 컬럼의 표현 여부를 정의합니다. */
				/* colHeaders 와 lenth 가 동일해야 합니다. */
				/* ex : 'colDisplays': ['block', 'block', 'block', 'block', 'block', 'block', 'block'] */
				// 'colDisplays': [], // TODO: 미구현
				// 'colFormats': [], // TODO: 미구현
				/* lht, lct 의 너비를 정의합니다. */
				/* colLeftFixed 가 2인 경우, colHeaders[0], colHeaders[1] 이 고정으로 적용된다. */
				/* ex : 'colLeftFixed': 2 */
				'colLeftFixed': 0,
				// 'contextMenu': '', // TODO: 미구현
				/* 수정 가능여부를 정의합니다. */
				/* true 인 경우 수정 가능 / false 인 경우 수정 불가 */
				/* ex : 'editable': true */
				'editable': true, // TODO: 미구현
				// 'columnSorting': false, // TODO: 미구현
				// 'columnResize': false, // TODO: 미구현
				'total': {
					title: '',
					colspan: [],
					sumCol: []
				},
				/* 바인딩 데이터 */
				/* 데이터는 배열로 전달 */
				/* ex : 'data': [['a', 'b', 'c', 'd', 'e', 'f', 'g'], ['a', 'b', 'c', 'd', 'e', 'f', 'g'], ['a', 'b', 'c', 'd', 'e', 'f', 'g'], ['a', 'b', 'c', 'd', 'e', 'f', 'g'], ['a', 'b', 'c', 'd', 'e', 'f', 'g']] */
				'data': [], // 최초 바인딩 데이터
				/* 컬럼 타입 및 이벤트등 정의 */
				/* 앞으로 추가될 기능이 정의될 수 있음 */
				'columns': [], // TODO:
				/* 테이블을 생성하기전 필요한 이벤트를 수행할 수 있도록 start 이벤트를 제공한다. */
				'renderStart': function () {
					console.log('renderStart >> ' + new Date());
				},
				/* 테이블 생성이 완료되면, 필요한  이벤트를 수행할 수 있도록 end 이벤트를 제공한다. */
				'renderEnd': function () {
					console.log('renderEnd >> ' + new Date());
				}
			};

			/* 수신된 파라미터와 기본 파라미터 통합 ( 기본 파라미터를 수신된 파라미터로 덮어쓰기 한다. ) */
			var options = $.extend(defaults, options);
			var sourceResult = [];

			/* 엘리먼트 정보 정의 */
			var id = ($(this).prop('id') === undefined ? '' : $(this).prop('id'));
			options.id = id;
			var main = $(this);

			/* 기본값 정의 - layout */
			if (options.layout.indexOf(tableDef.rightContentTable) < 0) {
				options.layout.push(tableDef.rightContentTable);
			}

			/* 크기 확인 - 행 */
			options.rowSize = 0;
			if (options.data.length > options.rowSize) {
				options.rowSize = options.data.length;
			}
			/* 크기 확인 - 열 */
			options.colSize = options.colHeaders.length;
			if (options.data.length > 0 && options.data[0].length > options.colSize) {
				options.colSize = options.data[0].length;
			}
			/* 크기 확인 - 고정 열 */
			options.colLeftFixed = tableFnc.isLht(options.layout) ? options.colLeftFixed : 0;

			/* 기본값 정의 */
			for (var c = 0; c < options.colSize; c++) {
				/* 기본값 정의 - 타이틀 */
				if (!options.colHeaders[c]) {
					options.colHeaders[c] = $.fn.dtable('getHeaderTitle', c);
				}

				/* 기본값 정의 - 컬럼 */
				if (!options.columns[c]) {
					if (!options.columns[c]) {
						options.columns[c] = {
							'type': 'text'
						};
					} else if (!options.columns[c].type) {
						options.columns[c].type = 'text';
					}

					/* 기본값 정의 - 소스 */
					if (!options.columns[c].source) {
						options.columns[c].source = [];
					}

					/* 기본값 정의 - 옵션 */
					if (!options.columns[c].options) {
						options.columns[c].options = [];
					}

					/* 기본값 정의 - 에디터 */
					if (!options.columns[c].editor) {
						options.columns[c].editor = null;
					}

					/* 기본값 정의 - 드롭다운리스트 소스 확인 */
					if (options.columns[c].type == 'autocomplete' || options.columns[c].type == 'dropdown') {
						// TODO:
						if (options.columns[c].url != '') {
							sourceResult.push(
								$.ajax({
									url: options.columns[c].url,
									index: c,
									success: function (result) {
										options.columns[c].source = (result.data || result);
									}
								}));
						}
					}

					/* 기본값 정의 - 캘린더 */
					if (options.columns[c].type === 'calendar') {
						if (!options.columns[c].options.format) {
							options.columns[c].options.format = 'YYYY-MM-DD';
						}
						// TODO:
					}
				}

				/* 기본값 정의 - 정렬 */
				if (!options.colAlignments[c]) {
					options.colAlignments[c] = 'cen';
				}

				/* 기본값 정의 - 너비 */
				if (!options.colWidth[c]) {
					options.colWidth[c] = '100';
				}
			}

			/* 테이블 생성 */
			createTable = function () {
				/* 옵션 저장 */
				if (!$.fn.dtable.options) {
					$.fn.dtable.options = new Array();
				}
				$.fn.dtable.options[id] = options;

				/* 히스토리 기록 >> TODO: 미구현 */
				$.fn.dtable.options[id].history = new Array();
				$.fn.dtable.options[id].historyIndex = -1;

				/* 데이터 초기화 */
				if (!options.data) {
					options.data = [];
				}

				/*입력 데이터 확인 */
				if (!$.fn.dtable.options[id].data.length) {
					$.fn.dtable.options[id].data = [[]];
				}

				main.dtable('createTable');
			};

			// JSON 로드 후 테이블 생성
			if (sourceResult.length > 0) {
				$.when.apply(this, sourceResult).done(function () {
					/* 테이블 생성 */
					createTable();
				});
			} else {
				/* 테이블 생성 */
				createTable();
			}

			return;
		},
		/* [-] ## init ######################################################################################################################################################################################################## */
		createTable: function () {
			/* 변수정의 */
			var options = $.fn.dtable.options[$(this).prop('id')];

			/* 테이블 레이아웃 정의 */
			var table = '';
			table += '<div class="cus_ta_ea">';
			table += '	<table>';
			table += '		<tr>';
			if (tableFnc.isLht(options.layout) || tableFnc.isLct(options.layout)) {
				table += '			<td width="' + $(this).dtable('getSum') + '" class="p0 scbg brn" valign="top">';
				if (tableFnc.isLht(options.layout)) {
					table += '				<div class="cus_ta_ea ovh leftHeader ta_bl ta_br">';
					table += '					<table id="' + options.id + '_lht">';
					table += '					</table>';
					table += '				</div>';
				}
				if (tableFnc.isLct(options.layout)) {
					table += '				<div class="cus_ta_ea rowHeight ovh leftContents scbg ta_bl ta_br" style="height: 135px;">';
					table += '					<table id="' + options.id + '_lct">';
					table += '					</table>';
					table += '				</div>';
				}
				table += '			</td>';
			}
			if (tableFnc.isRht(options.layout) || tableFnc.isRct(options.layout)) {
				table += '			<td width="*" class="p0 scbg posi_re brn" valign="top">';
				if (tableFnc.isMr(options.layout)) {
					table += '				<span class="' + (options.total.sumCol.length > 0 ? 'scy_head3' : 'scy_head1') + '"></span>';
				}
				if (tableFnc.isRht(options.layout)) {
					table += '				<div class="cus_ta_ea ovh mr17 rightHeader ta_bl">';
					table += '					<table id="' + options.id + '_rht">';
					table += '					</table>';
					table += '				</div>';
				}
				if (tableFnc.isRct(options.layout)) {
					table += '				<div class="cus_ta_ea rowHeight scroll_fix rightContents scbg ta_bl" style="height: 151px;">';
					table += '					<table id="' + options.id + '_rct">';
					table += '					</table>';
					table += '				</div>';
				}
				table += '			</td>';
			}
			table += '		</tr>';
			table += '	</table>';
			table += '	<div id="divAutoComplete" class="posi_ab"></div>'
			table += '</div>';
			$(this).append(table);

			/* 테이블 변수 정의 */
			$(this).dtable('setTableArea');

			/* 테이블 제목 정의 - lht */
			$(this).dtable('setTableLeftHeaderDef');

			/* 테이블 제목 정의 - rht */
			$(this).dtable('setTableRightHeaderDef');

			/* 테이블 제목 정의 - total */
			$(this).dtable('setTableTotalHeaderDef');

			/* 테이블 스크롤 이벤트 등록 */
			options.rct.parent().scroll(function (e) {
				options.rht.parent().scrollLeft($(this).scrollLeft());
				options.lct.parent().scrollTop($(this).scrollTop());

				var c = options.selectedCell.prop('id').toString().split('-')[1];
				/* 스크롤 이동에 따른 엘리먼트 위치 조정 */
				if (options.columns[c].type === 'autocomplete') {
					console.log('/* 스크롤 이동에 따른 엘리먼트 위치 조정 */');
					$('#divAutoComplete').offset({
						top: ($('.highLightIn').offset().top) - options.rct.scrollTop(),
						left: ($('.highLightIn').offset().left + $('.highLightIn').parent().width())
					});
				}

				e.preventDefault();
			});

			options.lct.parent().on('mousewheel DOMMouseScroll', function (e) {
				options.rct.parent().scrollTop($(this).scrollTop());

				var c = options.selectedCell.prop('id').toString().split('-')[1];
				/* 스크롤 이동에 따른 엘리먼트 위치 조정 */
				if (options.columns[c].type === 'autocomplete') {
					console.log('/* 스크롤 이동에 따른 엘리먼트 위치 조정 */');
					$('#divAutoComplete').offset({
						top: ($('.highLightIn').offset().top) - options.rct.scrollTop(),
						left: ($('.highLightIn').offset().left + $('.highLightIn').parent().width())
					});
				}

				e.preventDefault();
			});

			/* 행추가 */
			for (var r = tableDef.zero; r < options.data.length; r++) {
				$(this).dtable('addRow', r);
			}

			/* 테이블 행 기본 생성 */
			// if (options.editable) { $(this).dtable('addData', []); }

			/* 집계 수행 */
			$(this).dtable('setTotalRefresh');

			/* 마지막행의 첫번째 입력란에 포커스 주기. */
			for (var c = 0; c < options.colSize; c++) {
				if (options.columns[c].type != 'checkbox') {
					if (c < options.colLeftFixed) {
						options.selectedCell = options.lct.find('tr:last').find('td[id=col-' + c + ']');
					} else {
						options.selectedCell = options.rct.find('tr:last').find('td[id=col-' + c + ']');
						options.lct.parent().scrollTop($(this).scrollTop());
					}

					$(this).dtable('setInput');
					options.rct.parent().scrollTop(options.lct.parent().scrollTop());
					break;
				}
			}
		},
		getSum: function () {
			/* 변수정의 */
			var options = $.fn.dtable.options[$(this).prop('id')];
			var result = tableDef.zero;
			/* 왼쪽 고정 영역의 너비를 구하여 반환한다. */
			options.colWidth.slice(tableDef.zero, options.colLeftFixed).forEach(function (item) {
				result = (tableFnc.num(result) + tableFnc.num(item));
			});
			result = result + tableFnc.num(options.colLeftFixed);
			return result;
		},
		setTableArea: function () {
			/* 변수정의 */
			var options = $.fn.dtable.options[$(this).prop('id')];
			/* 각 테이블 정의 */
			$.fn.dtable.options[options.id].lht = $(this).find('#' + options.id + '_lht'); /* 왼쪽 제목 */
			$.fn.dtable.options[options.id].rht = $(this).find('#' + options.id + '_rht'); /* 오른쪽 제목 */
			$.fn.dtable.options[options.id].lct = $(this).find('#' + options.id + '_lct'); /* 왼쪽 본문 */
			$.fn.dtable.options[options.id].rct = $(this).find('#' + options.id + '_rct'); /* 오른쪽 본문 */
		},
		setTableLeftHeaderDef: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			var ltr = '';
			for (var c = tableDef.zero; c < options.colLeftFixed; c++) {
				ltr += '<th id="col-' + c + '" width="' + tableFnc.num(options.colWidth[c], 100) + '">' + $(this).dtable('getHeader', c) + '</th>';
			}
			options.lht.append('<tr>' + ltr + '</tr>');
		},
		setTableRightHeaderDef: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			var rtr = '';
			for (var c = options.colLeftFixed; c < options.colSize; c++) {
				rtr += '<th id="col-' + c + '" width="' + tableFnc.num(options.colWidth[c], 100) + '">' + $(this).dtable('getHeader', c) + '</th>';
			}
			options.rht.append('<tr>' + rtr + '</tr>');
		},
		setTableTotalHeaderDef: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			if (options.total.sumCol.length > tableDef.zero) {
				/* 'total': { title: '합계', colspan: [0, 5], sumCol: [10, 11, 12, 16] } */
				if (!options.total) {
					options.title = '';
					options.colspan = [];
					options.sumCol = [];
				}
				var colStartIndex = tableFnc.num(options.total.colspan[tableDef.zero]),
					colEndIndex = tableFnc.num(options.total.colspan[1]),
					fixIndex = tableFnc.num(options.colLeftFixed),
					colMaxIndex = tableFnc.num(options.colSize);
				/* 1. 생성 불가한 상황 확인 : 시작이 종료보다 큰 경우 */
				if (colEndIndex < colStartIndex) {
					$.error('집계행 생성 실패하였습니다. total.colspan의 시작과 종료 범위를 확인해주세요.');
				}
				/* 2. 생성 불가한 상황 확인 : 테이블을 넘나드는 경우 */
				if (colStartIndex < fixIndex && fixIndex < colEndIndex) {
					$.error('집계행 생성 실패하였습니다. total.colspan 과 colLeftFixed 를 확인해주세요.');
				}
				/* 3. 생성 불가한 상황 확인 : 테이블의 크기보다 큰 경우 */
				if (colMaxIndex < colEndIndex) {
					$.error('집계행 생성 실패하였습니다. 테입블 열의 최대크기보다 total.colspan[1] 이 큽니다.');
				}
				/* 집계행 생성 */
				var ltr = '',
					rtr = '';
				for (var c = tableDef.zero; c < options.colSize; c++) {
					var temp = '';
					if (colStartIndex == c) {
						if (colEndIndex != colStartIndex) {
							var colSpan = ((tableFnc.num(options.total.colspan[1]) - tableFnc.num(options.total.colspan[tableDef.zero])) + 1)
							temp = '<th id="col-' + c + '" colspan="' + colSpan + '">' + options.total.title + '</th>';
						} else {
							temp = '<th id="col-' + c + '">' + options.total.title + '</th>';
						}
					} else if (colStartIndex < c && c <= colEndIndex) {
						continue;
					} else {
						temp = '<th class="ri" id="col-' + c + '"></th>';
					}

					if (c < options.colLeftFixed) {
						ltr += temp;
					} else {
						rtr += temp;
					}
				}
				options.lht.append('<tr>' + ltr + '</tr>');
				options.rht.append('<tr>' + rtr + '</tr>');
			}
		},
		addRow: function (r) {
			var options = $.fn.dtable.options[$(this).prop('id')];
			r = (r === tableDef.zero ? r : tableFnc.num(r, -1));
			/* 데이터 검증 */
			if (r < 0) {
				$.error('신규행의 정보가 없습니다. 기본값을 설정하여 사용하세요. ( ex : $(elem).dtable("addData", []) )');
				return;
			}
			/* 행 추가 */
			var lct = '',
				rct = '';

			for (var c = 0; c < options.colSize; c++) {
				var temp = '';
				temp = '<td id="col-' + c + '" width="' + tableFnc.num(options.colWidth[c], 100) + '" class="' + (options.colAlignments[c] || 'cen') + '">' + $(this).dtable('getColData', r, c) + '</td>';
				if (c < options.colLeftFixed) {
					lct += temp;
				} else {
					rct += temp;
				}
			}
			/* 행 추가 */
			options.lct.append('<tr>' + lct + '</tr>');
			options.rct.append('<tr>' + rct + '</tr>');
			/* 이벤트 적용 */
			options.lct.find('tr:last td').click(function () {
				if (options.selectedCell) {
					options.beforeSelectedCell = options.selectedCell;
				}
				options.selectedCell = $(this);
				$('#' + options.id).dtable('setInput');
			});
			options.rct.find('tr:last td').click(function () {
				if (options.selectedCell) {
					options.beforeSelectedCell = options.selectedCell;
				}
				options.selectedCell = $(this);
				$('#' + options.id).dtable('setInput');
			});
		},
		getColData: function (r, c) {
			var options = $.fn.dtable.options[$(this).prop('id')];
			// var content = ((options.data[r][c] == undefined || options.data[r][c] == '') ? (options.data[r][c] = (options.columns[c].type === 'checkbox' ? tableElem.checkbox : (options.data[r][c] || ''))) : options.data[r][c]);
			var content = '';
			if (options.columns[c].type == 'text' || options.columns[c].type == 'autocomplete' || options.columns[c].type == 'date' || options.columns[c].type == 'time') {
				content = ((options.data[r][c] == undefined || options.data[r][c] == '') ? '' : options.data[r][c]);
			} else {
				content = options.columns[c].type;
			}

			/* 반환 정보 가공 */
			switch (content.toUpperCase()) {
				case 'CHECKBOX':
					var name = options.id + '_chk';
					var id = options.id + '_chk_col_' + r;
					var onClick = 'onclick="javascript:$(' + "'" + '#' + id + '' + "'" + ').dtable(' + "'" + 'chkCheck' + "'" + ', this);"';
					var checkbox = '<input type="checkbox" name="' + name + '" id="' + id + '" style="visibility: hidden;" ' + onClick + '>';
					var label = '<label for="' + id + '"></label>';
					return (checkbox + label);
				default:
					return '<span>' + content + '</span>';
			}
		},
		setTotalRefresh: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			/* 'total': { title: '합계', colspan: [0, 5], sumCol: [10, 11, 12, 16] } */
			options.total.sumCol.forEach(function (c) {
				var calc = tableDef.zero;
				for (var r = tableDef.zero; r < options.data.length; r++) {
					calc = (tableFnc.num(calc) + tableFnc.num(options.data[r][c]));
				}

				if (c < options.colLeftFixed) {
					options.lht.find('tr:eq(1) th[id=col-' + c + ']').empty();
					options.lht.find('tr:eq(1) th[id=col-' + c + ']').append(calc);
				} else {
					options.rht.find('tr:eq(1) th[id=col-' + c + ']').empty();
					options.rht.find('tr:eq(1) th[id=col-' + c + ']').append(calc);
				}
			});
		},
		getHeader: function (c) {
			var options = $.fn.dtable.options[$(this).prop('id')];
			switch (options.colHeaders[c].toString().toUpperCase()) {
				case tableElem.checkboxAll:
					var name = options.id + '_chk';
					var id = options.id + '_chkAll';
					var onClick = 'onclick="javascript:$(' + "'" + '#' + id + '' + "'" + ').dtable(' + "'" + 'chkAll' + "'" + ', this);"';
					var checkbox = '<input type="checkbox" name="' + name + '" id="' + id + '" style="visibility: hidden;" ' + onClick + '>';
					var label = '<label for="' + id + '"></label>';
					return (checkbox + label);
				default:
					return (options.colHeaders[c]).toString();
			}
		},
		getHeaderTitle: function (c) {
			var title = '';
			if (c > 701) {
				title += String.fromCharCode(64 + parseInt(c / 676));
				title += String.fromCharCode(64 + parseInt((c % 676) / 26));
			} else if (c > 25) {
				title += String.fromCharCode(64 + parseInt(c / 26));
			}
			title += String.fromCharCode(65 + (c % 26));

			return title;
		},
		setRowSelect: function (r) {
			var options = $.fn.dtable.options[$(this).prop('id')];
			options.lct.find('.rowOn').removeClass('rowOn');
			options.rct.find('.rowOn').removeClass('rowOn');

			if (!options.lct.find('tr:eq(' + r + ')').hasClass('rowOn')) {
				options.lct.find('tr:eq(' + r + ')').addClass('rowOn');
			}
			if (!options.rct.find('tr:eq(' + r + ')').hasClass('rowOn')) {
				options.rct.find('tr:eq(' + r + ')').addClass('rowOn');
			}
		},
		setColSelect: function (c) {
			var options = $.fn.dtable.options[$(this).prop('id')];
			options.rht.find('.colOn').removeClass('colOn');
			options.lht.find('.colOn').removeClass('colOn');
			options.lct.find('.colOn').removeClass('colOn');
			options.rct.find('.colOn').removeClass('colOn');

			if (c < options.colLeftFixed) {
				if (!options.lht.find('td[id=col-' + c + ']').hasClass('colOn')) {
					options.lht.find('th[id=col-' + c + ']').addClass('colOn');
				}
				if (!options.lct.find('td[id=col-' + c + ']').hasClass('colOn')) {
					options.lct.find('td[id=col-' + c + ']').addClass('colOn');
				}
			} else {
				if (!options.rht.find('td[id=col-' + c + ']').hasClass('colOn')) {
					options.rht.find('th[id=col-' + c + ']').addClass('colOn');
				}
				if (!options.rct.find('td[id=col-' + c + ']').hasClass('colOn')) {
					options.rct.find('td[id=col-' + c + ']').addClass('colOn');
				}
			}
		},
		setCellSelect: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			if (!options.selectedCell.hasClass()) {
				options.lct.find('highLight').remove('highLight');
				options.rct.find('highLight').remove('highLight');
				options.selectedCell.addClass('highLight');
			}
		},
		resetSelect: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			options.lht.find('.colOn').removeClass('colOn');
			options.rht.find('.colOn').removeClass('colOn');
			options.lct.find('.rowOn').removeClass('rowOn');
			options.rct.find('.rowOn').removeClass('rowOn');
		},
		addData: function (data) {
			/* 변수정의 */
			var options = $.fn.dtable.options[$(this).prop('id')];
			data = (data || []);
			/* 데이터 검증 */
			if (data.length < options.colSize) {
				for (var c = tableDef.zero; c < options.colSize; c++) {
					if (data[c] === undefined) {
						data.push('');
					}
				}
			}
			/* 데이터 추가 */
			options.data.push(data);
			/* 신규행 생성 */
			$(this).dtable('addRow', options.data.length - 1);
			/* 집계행 재계산 */
			$(this).dtable('setTotalRefresh');
			/* 테이블 크기 재계산 */
			options.rowSize = options.rowSize + 1;
		},
		removeData: function (r) {
			/* 변수정의 */
			var options = $.fn.dtable.options[$(this).prop('id')];
			row = tableFnc.num(r, -1);
			/* 데이터 검증 */
			if (row < tableDef.zero) {
				return;
			}
			options.data.splice(r, 1);
			options.lct.find('tr:eq(' + r + ')').unbind().remove();
			options.rct.find('tr:eq(' + r + ')').unbind().remove();
			/* 집계행 재계산 */
			$(this).dtable('setTotalRefresh');
		},
		getCheckedList: function () {
			/* 변수정의 */
			var options = $.fn.dtable.options[$(this).prop('id')];
			var resultCheckbox = function (c) {
				if (c < options.colLeftFixed) {
					return options.lct.find('input[type=checkbox]:checked');
				} else {
					return options.rct.find('input[type=checkbox]:checked');
				}
			};
			/* 데이터 검증 */
			for (var c = 0; c < options.colSize; c++) {
				if (options.columns[c].type === 'checkbox') {
					resultCheckbox(c);
					break;
				}
			}
		},
		chkAll: function (checkbox) {
			var chkElem = $('input[name=' + $(checkbox).attr('name') + ']').not('#' + $(checkbox).prop('id'));
			if ($(checkbox).prop('checked')) {
				chkElem.prop('checked', true);
			} else {
				chkElem.prop('checked', false);
			}
		},
		chkCheck: function (checkbox) {
			var chkIdInfo = $(checkbox).prop('id').toString().split('_');
			var chkAllId = $('#' + [chkIdInfo[0], chkIdInfo[1], 'chkAll'].join('_'));
			var chkElem = $('input[name=' + $(checkbox).attr('name') + ']').not('#' + $(checkbox).prop('id'));
			var checkedElem = $('input[name=' + $(checkbox).attr('name') + ']:checked').not(chkAllId);

			/* 전체 체크박스가 선택되면 자동으로 모든 체크박스 선택을 체크한다. */
			if (chkElem.length === checkedElem.length) {
				chkAllId.prop('checked', true);
			}
			/* 전체 체크박스가 선택되지 않으면 자동으로 모든체크박스 선택을 해제한다. */
			else {
				chkAllId.prop('checked', false);
			}
		},
		setInput: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			if (options.beforeSelectedCell != undefined) {
				$('#' + options.id).dtable('setCellRemoveMod');
			}
			var r = options.selectedCell.parent().index();
			var c = options.selectedCell.prop('id').split('-')[1];
			if (options.columns[c].type != 'checkbox') {
				$('#' + options.id).dtable('setRowSelect', r);
				$('#' + options.id).dtable('setColSelect', c);
				$('#' + options.id).dtable('setCellSelect', c);
				$('#' + options.id).dtable('setCellMod');
				options.selectedCell.find('input').focus().select();
			} else {
				$('#' + options.id).dtable('resetSelect');
			}

			var scrollElem = $('.highLight').parent().parent().parent().parent();
			var scrollWidth = scrollElem.innerWidth();
			var scrollPos = scrollElem.offset().left + scrollElem.innerWidth();
			var inputPos = $('.highLight').offset().left + $('.highLight').width();

			if (scrollPos < (inputPos + ($('.highLight').width() / 2))) {
				scrollElem.scrollLeft(scrollElem.scrollLeft() + (($('.highLight').width() / 2) + (inputPos - scrollPos)));
			}
		},
		setCellMod: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			var r = options.selectedCell.parent().index();
			var c = options.selectedCell.prop('id').split('-')[1];
			/* 체크박스 예외처리 */
			switch (options.columns[c].type.toString().toUpperCase()) {
				case 'CHECKBOX':
					return;
				case 'TEXT':
					options.selectedCell.empty().append('<div class="highLightIn"><input type="text" class="inpTextBox" value="' + (options.data[r][c] || '') + '"></div>');
					options.selectedCell.find('input').keydown(function (e) {
						/* key event ( 키입력 / 키 이벤트 ) */
						if (e.shiftKey && e.which == 13) {
							// Enter
							$('#' + options.id).dtable('setSelectedCellMove', -1);
							e.preventDefault();
						} else if (e.which == 13) {
							$('#' + options.id).dtable('setSelectedCellMove', 1);
							e.preventDefault();
						} else if (e.which == 37) {
							// Left arrow
							$('#' + options.id).dtable('setSelectedCellMove', -1);
							e.preventDefault();
						} else if (e.which == 39) {
							// Right arrow
							$('#' + options.id).dtable('setSelectedCellMove', 1);
							e.preventDefault();
						} else if (e.which == 113) {
							alert('code pop');
							e.preventDefault();
						}
					});

					if (options.selectedCell.find('input').attr('placeholder', '')) {
						if ((options.columns[c].mask || '') != '') {
							console.log('mask');
							options.selectedCell.find('input').mask(options.columns[c].mask.toString().replace(/_/g, '9'), {
								placeholder: options.columns[c].mask
							});
						}
					}

					// options.selectedCell.find('input').focus().select();
					break;
				case 'DATE':
					// <input type="text" value="2017-02-01" class="w113" readonly=""><a href="#n" class="button_dal"></a>
					// options.selectedCell.empty().append('<div class="highLightIn"><input type="date" class="inpTextBox" value="' + (options.data[r][c] || '') + '"></div>');
					options.selectedCell.empty().append('<div class="highLightIn"><input type="text" value="" class="brn inpDateBox" /></div>');

					var datePickerOptions = {
						altFormat: "yy-mm-dd",
						dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
						dateFormat: "yy-mm-dd",
						dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
						monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
						monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
						showOtherMonths: true,
						selectOtherMonths: true,
						showMonthAfterYear: true,
						nextText: "Next",
						prevTex: "Prev"

					};
					options.selectedCell.find('input').datepicker(datePickerOptions);

					options.selectedCell.find('input').keydown(function (e) {
						if (options.selectedCell.find('input').val().replace(/-/g, '').replace(/_/g, '') === '') {
							if (isNaN(Number(options.selectedCell.find('input')))) {
								var inst = $.datepicker._getInst(e.target);
								var isRTL = inst.dpDiv.is(".ui-datepicker-rtl");
								switch (e.keyCode) {
									case 37: // LEFT --> -1 day
										$('body').css('overflow', 'hidden');
										$.datepicker._adjustDate(e.target, (isRTL ? +1 : -1), "D");
										break;
									case 38: // UPP --> -7 day
										$('body').css('overflow', 'hidden');
										$.datepicker._adjustDate(e.target, -7, "D");
										break;
									case 39: // RIGHT --> +1 day
										$('body').css('overflow', 'hidden');
										$.datepicker._adjustDate(e.target, (isRTL ? -1 : +1), "D");
										break;
									case 40: // DOWN --> +7 day
										$('body').css('overflow', 'hidden');
										$.datepicker._adjustDate(e.target, +7, "D");
										break;
								}
							}
						} else {
							/* key event ( 키입력 / 키 이벤트 ) */
							if (e.shiftKey && e.which == 13) {
								// Enter
								$('#' + options.id).dtable('setSelectedCellMove', -1);
								e.preventDefault();
							} else if (e.which == 13) {
								$('#' + options.id).dtable('setSelectedCellMove', 1);
								e.preventDefault();
							} else if (e.which == 37) {
								// Left arrow
								$('#' + options.id).dtable('setSelectedCellMove', -1);
								e.preventDefault();
							} else if (e.which == 39) {
								// Right arrow
								$('#' + options.id).dtable('setSelectedCellMove', 1);
								e.preventDefault();
							} else if (e.which == 113) {
								alert('code pop');
								e.preventDefault();
							}
						}
					});

					if (options.selectedCell.find('input').attr('placeholder', '')) {
						if ((options.columns[c].mask || '') != '') {
							console.log('mask');
							options.selectedCell.find('input').mask(options.columns[c].mask.toString().replace(/_/g, '9'), {
								placeholder: options.columns[c].mask
							});
						}
					}
					break;
				case 'TIME':
					options.selectedCell.empty().append('<div class="highLightIn"><input type="time" class="inpTextBox" value="' + (options.data[r][c] || '') + '"></div>');
					options.selectedCell.find('input').keydown(function (e) {
						/* key event ( 키입력 / 키 이벤트 ) */
						if (e.shiftKey && e.which == 13) {
							// Enter
							$('#' + options.id).dtable('setSelectedCellMove', -1);
							e.preventDefault();
						} else if (e.which == 13) {
							$('#' + options.id).dtable('setSelectedCellMove', 1);
							e.preventDefault();
						} else if (e.which == 37) {
							// Left arrow
							$('#' + options.id).dtable('setSelectedCellMove', -1);
							e.preventDefault();
						} else if (e.which == 39) {
							// Right arrow
							$('#' + options.id).dtable('setSelectedCellMove', 1);
							e.preventDefault();
						} else if (e.which == 113) {
							alert('code pop');
							e.preventDefault();
						}
					});
					break;
				case 'AUTOCOMPLETE':
					options.selectedCell.empty().append('<div class="highLightIn"><input type="text" class="inpTextBox" value="' + (options.data[r][c] || '') + '"></div>');
					options.selectedCell.find('input').keydown(function (e) {
						if (e.which == 38) {
							// Top arrow
							orgItem = $('.inp_list li.on');
							if (orgItem.prev('li').length > 0) {
								orgItem.prev('li').addClass('on');
								orgItem.removeClass('on');
								options.selectedCell.find('input').val($('.inp_list li.on').text());
							}
							e.preventDefault();
						} else if (e.which == 40) {
							// Bottom arrow
							orgItem = $('.inp_list li.on');
							if (orgItem.next('li').length > 0) {
								orgItem.next('li').addClass('on');
								orgItem.removeClass('on');
								options.selectedCell.find('input').val($('.inp_list li.on').text());
							}
							e.preventDefault();
						} else if (e.which == 37) {
							// Left arrow
							$('#' + options.id).dtable('setSelectedCellMove', -1);
							e.preventDefault();
						} else if (e.which == 39) {
							// Right arrow
							$('#' + options.id).dtable('setSelectedCellMove', 1);
							e.preventDefault();
						} else if (e.shiftKey && e.which == 13) {
							// Enter
							$('#' + options.id).dtable('setSelectedCellMove', -1);
							e.preventDefault();
						} else if (e.which == 13) {
							$('#' + options.id).dtable('setSelectedCellMove', 1);
							e.preventDefault();
						} else {
							e.preventDefault();
						}
					});
					if (options.columns[c].type.toString() === 'autocomplete') {
						var list = '';
						$.each(options.columns[c].source, function (index, item) {
							list += '<li value="' + item.key + '.' + item.name + '">' + item.key + '.' + item.name + '</li >';
						});
						$('#divAutoComplete').empty().append('<ul class="inp_list">' + list + '</ul>');
						$('#divAutoComplete').css('width', 201);
						$('#divAutoComplete').offset({
							top: ($('.highLightIn').offset().top) - options.rct.scrollTop(),
							left: ($('.highLightIn').offset().left + $('.highLightIn').parent().width())
						});

						$('#divAutoComplete ul li:eq(0)').addClass('on');
						if (options.selectedCell.find('input').val() == '') {
							options.selectedCell.find('input').val($('#divAutoComplete ul li:eq(0)').text());
						}
					}

					options.selectedCell.find('input').focus();
					break;
			}
		},
		setCellRemoveMod: function () {
			var options = $.fn.dtable.options[$(this).prop('id')];
			var r = options.beforeSelectedCell.parent().index();
			var c = options.beforeSelectedCell.prop('id').split('-')[1];
			options.data[r][c] = options.beforeSelectedCell.find('input').val() || '';
			$('#divAutoComplete').offset({
				top: 0,
				left: 0
			});
			if (options.columns[c].type != 'checkbox') {
				options.beforeSelectedCell.contents().unbind().remove();
				options.beforeSelectedCell.removeClass('colOn highLight');
				options.beforeSelectedCell.append('<span>' + $(this).dtable('getColData', r, c) + '</span>');
			}
		},
		setSelectedCellMove: function (addCol) {
			var options = $.fn.dtable.options[$(this).prop('id')];
			var r = options.selectedCell.parent().index();
			var c = options.selectedCell.prop('id').split('-')[1];
			var nextCol = (tableFnc.num(c) + tableFnc.num(addCol));

			/* 다음 cell이 존재하는가? */
			if (nextCol >= tableDef.zero && nextCol < options.colSize) {
				switch (options.columns[nextCol].type.toUpperCase()) {
					case 'CHECKBOX':
						/* 다음 cell이 checkbox? */
						/* return $('#' + options.id).dtable('setSelectedCellMove', (addCol > 0 ? addCol + 1 : addCol - 1)); */
						options.selectedCell.find('input').focus();
						break;
					case 'HIDDEN':
						/* 다음 cell이 hidden인가? */
					default:
						if (nextCol < options.colLeftFixed) {
							options.beforeSelectedCell = options.selectedCell;
							options.selectedCell = options.lct.find('tr:eq(' + options.selectedCell.parent().index() + ')').find('td[id=col-' + nextCol + ']');
							$('#' + options.id).dtable('setInput');
						} else {
							options.beforeSelectedCell = options.selectedCell;
							options.selectedCell = options.rct.find('tr:eq(' + options.selectedCell.parent().index() + ')').find('td[id=col-' + nextCol + ']');
							$('#' + options.id).dtable('setInput');
						}
						break;
				}
			} else {
				if (nextCol >= options.colSize) {
					if (options.rowSize == r) {
						if (confirm('신규행을 생성하시겠습니까?')) {
							options.beforeSelectedCell = options.selectedCell;
							$(this).dtable('addData', []);

							/* 마지막행의 첫번째 입력란에 포커스 주기. */
							for (var c = 0; c < options.colSize; c++) {
								if (options.columns[c].type != 'checkbox') {
									if (c < options.colLeftFixed) {
										options.selectedCell = options.lct.find('tr:last').find('td[id=col-' + c + ']');
									} else {
										options.selectedCell = options.rct.find('tr:last').find('td[id=col-' + c + ']');
										options.lct.parent().scrollTop($(this).scrollTop());
									}

									$(this).dtable('setInput');
									options.rct.parent().scrollTop(options.lct.parent().scrollTop());
									break;
								}
							}
						}
					}
				} else {
					options.selectedCell.find('input').focus();
				}
			}
			return
		}
	};
	$.fn.dtable = function (method) {
		if (typeof method === 'object' || !method) {
			// console.log('call methods[' + method + '] >> ' + $(this).prop('id') || '');
			return methods.init.apply(this, arguments);
		} else if (methods[method]) {
			// console.log('call methods[' + method + '] >> ' + $(this).prop('id') || '');
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		} else {
			$.error('Method ' + method + ' does not exist on method..');
		}
	};
})(jQuery);
