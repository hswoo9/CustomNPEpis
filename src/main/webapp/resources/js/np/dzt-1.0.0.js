var DztAlign = {
    center: 'CENTER', /* 가운데 정렬 */
    left: 'LEFT', /* 왼쪽 정렬 */
    right: 'RIGHT' /* 오른쪽 정렬 */
};

var DztType = {
    text: 'text', /* input[type=text] */
    combobox: 'combobox', /* select */
    datepicker: 'datepicker', /* datepicker */
    readonly: 'readonly' /* input[type=text].attr('readonly', 'readonly') */
};

var DztIsNumeric = { yes: true, no: false };

var DztYN = { yse: 'Y', no: 'N' };

(function ($) {
    /* 1.0.0 : 기본 element 표시 정의
               - [CHECKBOX]
               - [BOOKMARK] */

    var dztVars = {
        defElement: {
            checkbox: {
                /* 1.0.0 : 에디터블 테이블 정의 체크박스 명 */
                name: '[CHECKBOX]'
            },
            bookmark: {
                /* 1.0.0 : 에디터블 테이블 정의 즐겨찾기 명 */
                name: '[BOOKMARK]'
            }
        },
        defKeyEvent: {
            /* 1.0.0 : 에디터블 테이블 정의 기본 키이벤트 명 */
            defaultName: '[KeyEventDefault]',
            /* 1.0.0 : 키이벤트 지원 정의 범위 */
            supportKeys: ['ESC', 'F2', 'F3', 'F4', 'F12', 'TAB', 'ARROWLEFT', 'ARROWRIGHT', 'ARROWUP', 'ARROWDOWN', 'ENTER']
        },
        defType: ['text', 'readonly', 'datepicker', 'combobox', 'checkbox'],
        defAlign: ['LEFT', 'CENTER', 'RIGHT'],
        defTableId: {
            rightHeaderDiv: 'right_header_div',
            rightHeaderTable: 'right_header_table',
            rightHeaderColgroup: 'right_header_colgroup',
            rightHeaderThead: 'right_header_thead',
            rightHeaderTbody: 'right_header_tbody',
            rightHeaderTr: 'right_header_tr',
            rightHeaderTd: 'right_header_td',
            /* -------------------------------------------------- */
            rightContentDiv: 'right_content_div',
            rightContentTable: 'right_content_table',
            rightContentColgroup: 'right_content_colgroup',
            rightContentThead: 'right_content_thead',
            rightContentTbody: 'right_content_tbody',
            rightContentTr: 'right_content_tr',
            rightContentTd: 'right_content_td'
        },
        keyMap: {
            /* 기능키 */
            Backspace: { Firefox: '8', IE: '8', Edge: '8', Chrome: '8' },
            Tab: { Firefox: '9', IE: '9', Edge: '9', Chrome: '9' },
            Enter: { Firefox: '13', IE: '13', Edge: '13', Chrome: '13' },
            Shift: { Firefox: '16', IE: '16', Edge: '16', Chrome: '16' },
            Control: { Firefox: '17', IE: '17', Edge: '17', Chrome: '17' },
            Alt: { Firefox: '18', IE: '18', Edge: '18', Chrome: '18' },
            PauseBreak: { Firefox: '19', IE: '19', Edge: '19', Chrome: '19' },
            CapsLock: { Firefox: '20', IE: '20', Edge: '20', Chrome: '20' },
            ESC: { Firefox: '27', IE: '27', Edge: '27', Chrome: '27' },
            Space: { Firefox: '32', IE: '32', Edge: '32', Chrome: '32' },
            PageUp: { Firefox: '33', IE: '33', Edge: '33', Chrome: '33' },
            PageDown: { Firefox: '34', IE: '34', Edge: '34', Chrome: '34' },
            End: { Firefox: '35', IE: '35', Edge: '35', Chrome: '35' },
            Home: { Firefox: '36', IE: '36', Edge: '36', Chrome: '36' },
            ArrowLeft: { Firefox: '37', IE: '37', Edge: '37', Chrome: '37' },
            ArrowUp: { Firefox: '38', IE: '38', Edge: '38', Chrome: '38' },
            ArrowRight: { Firefox: '39', IE: '39', Edge: '39', Chrome: '39' },
            ArrowDown: { Firefox: '40', IE: '40', Edge: '40', Chrome: '40' },
            Insert: { Firefox: '45', IE: '45', Edge: '45', Chrome: '45' },
            Delete: { Firefox: '46', IE: '46', Edge: '46', Chrome: '46' },
            NumLock: { Firefox: '144', IE: '144', Edge: '144', Chrome: '144' },
            ScrollLock: { Firefox: '145', IE: '145', Edge: '145', Chrome: '145' },
            /* FUNCTION 키 */
            F1: { Firefox: '112', IE: '112', Edge: '112', Chrome: '112' },
            F2: { Firefox: '113', IE: '113', Edge: '113', Chrome: '113' },
            F3: { Firefox: '114', IE: '114', Edge: '114', Chrome: '114' },
            F4: { Firefox: '115', IE: '115', Edge: '115', Chrome: '115' },
            F5: { Firefox: '116', IE: '116', Edge: '116', Chrome: '116' },
            F6: { Firefox: '117', IE: '117', Edge: '117', Chrome: '117' },
            F7: { Firefox: '118', IE: '118', Edge: '118', Chrome: '118' },
            F8: { Firefox: '119', IE: '119', Edge: '119', Chrome: '119' },
            F9: { Firefox: '120', IE: '120', Edge: '120', Chrome: '120' },
            F10: { Firefox: '121', IE: '121', Edge: '121', Chrome: '121' },
            F11: { Firefox: '122', IE: '122', Edge: '122', Chrome: '122' },
            F12: { Firefox: '123', IE: '123', Edge: '123', Chrome: '123' },
            /* 키패드 */
            PAD0: { Firefox: '96', IE: '96', Edge: '96', Chrome: '96' },
            PAD1: { Firefox: '97', IE: '97', Edge: '97', Chrome: '97' },
            PAD2: { Firefox: '98', IE: '98', Edge: '98', Chrome: '98' },
            PAD3: { Firefox: '99', IE: '99', Edge: '99', Chrome: '99' },
            PAD4: { Firefox: '100', IE: '100', Edge: '100', Chrome: '100' },
            PAD5: { Firefox: '101', IE: '101', Edge: '101', Chrome: '101' },
            PAD6: { Firefox: '102', IE: '102', Edge: '102', Chrome: '102' },
            PAD7: { Firefox: '103', IE: '103', Edge: '103', Chrome: '103' },
            PAD8: { Firefox: '104', IE: '104', Edge: '104', Chrome: '104' },
            PAD9: { Firefox: '105', IE: '105', Edge: '105', Chrome: '105' },
            /* 숫자 */
            0: { Firefox: '48', IE: '48', Edge: '48', Chrome: '48' },
            1: { Firefox: '49', IE: '49', Edge: '49', Chrome: '49' },
            2: { Firefox: '50', IE: '50', Edge: '50', Chrome: '50' },
            3: { Firefox: '51', IE: '51', Edge: '51', Chrome: '51' },
            4: { Firefox: '52', IE: '52', Edge: '52', Chrome: '52' },
            5: { Firefox: '53', IE: '53', Edge: '53', Chrome: '53' },
            6: { Firefox: '54', IE: '54', Edge: '54', Chrome: '54' },
            7: { Firefox: '55', IE: '55', Edge: '55', Chrome: '55' },
            8: { Firefox: '56', IE: '56', Edge: '56', Chrome: '56' },
            9: { Firefox: '57', IE: '57', Edge: '57', Chrome: '57' }
        },
        dateOptions: {
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
            prevTex: "Prev",
            onSelect: function(){
                if(typeof window['fnDatepickerOnSelect'] === 'function'){
                    window['fnDatepickerOnSelect']();
                }
            }
        }
    };

    var methods = {
        /* init */
        init: function (OPTIONS) {
            /* 기본값 정의 */
            var defaults = {
                title: ['품의구분', '품의일자', '프로젝트', '품의내역', '금액', '[BOOMARK]'],
                display: ['Y', 'Y', 'Y', 'Y', 'Y', 'Y'],
                width: ['100', '100', '100', '100', '100', '100'],
                req: ['Y', 'Y', 'Y', 'Y', 'Y', 'Y'],
                height: '135px',
                columns: [
                    {
                        /* 키 */
                        column: 'consType',
                        /* 입력 타입 */
                        type: 'text',
                        /* 키 이벤트 정의 */
                        keyEvent: ['ESC', 'F2', 'F3', 'F4', 'F12', 'TAB', 'ARROWLEFT', 'ARROWRIGHT', 'ARROWUP', 'ARROWDOWN', 'ENTER'],
                        /* 필수입력 여부 ( Y : 필수 입력 / N : 필수 입력 아님 ) */
                        req: 'Y',
                        /* 표시 여부 ( Y : 표시 / N : 미표시 ) */
                        displayYN: 'Y',
                        /* 정렬 ( LEFT, CENTER, RIGHT ) */
                        align: 'CENTER',
                        /* 호출 합수 모음 */
                        methods: {
                            /* 1.0.0 : 키 이벤트 ( 'keyEvent' + KEY ) */
                            keyEventESC: function () { },
                            keyEventF2: function () { },
                            keyEventF3: function () { },
                            keyEventF4: function () { },
                            keyEventF12: function () { },
                            keyEventTAB: function () { },
                            keyEventARROWLEFT: '[KeyEventDefault]',
                            keyEventARROWRIGHT: '[KeyEventDefault]',
                            keyEventARROWUP: '[KeyEventDefault]',
                            keyEventARROWDOWN: '[KeyEventDefault]',
                            keyEventENTER: '[KeyEventDefault]'
                        }
                    }
                ],
                /* 자동 바인딩 할 데이터 */
                data: [],
                /* 에디터블 테이블 정의 */
                id: '',
                rowSize: 0,
                colSize: 0
            };

            /* 옵션 정의 */
            OPTIONS = $.extend(defaults, OPTIONS);

            /* 대상 DIV 정보 */
            var main = $(this);
            var id = main.prop('id');
            OPTIONS.id = id;

            /* 에디터블 테이블 크기 확인 */
            OPTIONS.rowSize = Number((isNaN(OPTIONS.data.length) ? 0 : OPTIONS.data.length)); /* 행 */
            OPTIONS.colSize = Number((isNaN(OPTIONS.columns.length) ? 0 : OPTIONS.columns.length)); /* 열 */

            /* 에디터블 테이블 생성 */
            var createDzt = function () {
                /* 기존 내역 초기화 */
                main.contents().unbind().remove();

                /* 옵션 저장 */
                $.fn.dzt.options = (!$.fn.dzt.options ? [] : $.fn.dzt.options);
                $.fn.dzt.options[id] = OPTIONS;

                /* 에디터블 테이블 생성 - 헤더 */
                apis.setTable.main(main);
                apis.setTable.header.table(main);

                /* 에디터블 테이블 생성 - 컨텐츠 */
                apis.setTable.content.table(main);

                /* 에디터블 테이블 공통 설정 ( 헤더, 컨텐츠 ) */
                apis.setTable.display(main);
                apis.setTable.colgroup(main);

                /* 필수입력 설정 */
                apis.setTable.header.setReq(main);

                /* 기존 데이터 바인딩 */
                $.each(OPTIONS.data, function (idx, item) {
                    /* 행 추가 */
                    var uid = $(apis.setTable.content.addRow(main)).attr('uid');
                    /* 사용자 정의 데이터 반영 */
                    apis.setTable.updateValue(main, uid, item);
                });
            };

            createDzt();

            return;
        },
        /* 행추가 이벤트 */
        setAddRow: function () {
            /* 사용 변수 정의 */
            var main = $(this);

            /* 행추가 */
            var uid = $(apis.setTable.content.addRow(main)).attr('uid');

            /* 생성된 uid 반환처리 */
            return uid;
        },
        /* 행삭제 이벤트 */
        setRemoveRow: function (TR) {
            /* 사용 변수 정의 */
            var main = $(this);

            /* 행 삭제 */
            apis.setTable.content.removeRow(main, TR);

            /* 반환 처리 */
            return;
        },
        /* 현재 행 */
        getSelectedRow: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');
            var UID = $.fn.dzt.options[mainId].selectUID;

            /* tr 조회 */
            var tr = $('#' + apis.setTable.content.getId('tr', mainId, UID));

            /* 반환 처리 */
            return tr;
        },
        /* 포커스 지정 이벤트 */
        setFocus: function (UID, KEY) {
            /* parameters 정의 */
            /* - UID : 행에 존재하는 UID 값 */
            /* - KEY : columns.column 값 */
            if ((UID || '') === '') {
                console.error('UID 변수의 값이 누락되었습니다.');
                return;
            }
            if ((KEY || '') === '') {
                console.error('KEY 변수의 값이 누락되었습니다.');
                return;
            }

            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* 포커스 이동할 td 확인 */
            $('#' + apis.setTable.content.getId('td', mainId, [KEY, UID].join('_'))).click();
        },
        /* 특정 위치의 정보를 커밋하고 테스트 박스를 지운다. ( 포커스 유지 ) */
        setCommitTarget: function (UID, KEY) {
            /* parameters 정의 */
            /* - UID : 행에 존재하는 UID 값 */
            /* - KEY : columns.column 값 */
            if ((UID || '') === '') {
                console.error('UID 변수의 값이 누락되었습니다.');
                return;
            }
            if ((KEY || '') === '') {
                console.error('KEY 변수의 값이 누락되었습니다.');
                return;
            }

            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* commit element 처리 */
            $.each($.fn.dzt.options[mainId].columns, function (idx, item) {
                if (item.column === KEY) {
                    apis.setTable.commit[item.type](main, UID, KEY);
                    return false;
                }
            });
        },
        setValue: function (UID, VALUE, CALLBACK) {
            /* parameters 정의 */
            /* - UID : 행에 존재하는 UID 값 */
            /* - VALUE : 반열될 JSON 값 */
            /* - CALLBACK : CALLBACK 호출여부 [true, false] */
            if ((UID || '') === '') {
                console.error('UID 변수의 값이 누락되었습니다.');
                return;
            }
            
            CALLBACK = (typeof CALLBACK === 'undefined' ? true : CALLBACK);

            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* 사용자 정의 데이터 반영 */ /* dj 커스텀 값 입력 */
            apis.setTable.updateValue(main, UID, VALUE);

            /* 데이터 변경 callback 호출 */
            if (CALLBACK && typeof $.fn.dzt.options[mainId].commitCallback === 'function') {
                $.fn.dzt.options[mainId].commitCallback(UID, '');
            }

            return;
        },
        setDefaultFocusKey: function (TYPE, KEY) {
            if ((TYPE || '') === '') {
                console.error('TYPE 변수의 값이 누락되었습니다.');
                return;
            }
            if ((TYPE || '').toString().toUpperCase() != 'FIRST' &&
                (TYPE || '').toString().toUpperCase() != 'LAST') {
                console.error('TYPE 변수의 값은 "FIRST" 또는 "LAST"만 지정이 가능합니다.');
                return;
            }

            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            if ($('#' + apis.setTable.content.getId('tbody', mainId) + ' tr:' + ((TYPE || '').toString().toUpperCase() === 'LAST' ? 'last' : 'first')).length > 0) {
                /* UID 설정 */
                var UID = $('#' + apis.setTable.content.getId('tbody', mainId) + ' tr:' + ((TYPE || '').toString().toUpperCase() === 'LAST' ? 'last' : 'first')).attr('uid');
                return main.dzt('setFocus', UID, KEY);
            } else {
                return;
            }
        },
        setDefaultFocusReRes : function (TYPE) {
            /* parameters 정의 */
            /* - TYPE : FIRST / LAST */
            /*   > FIRST : 첫번째 행, 첫번째 열 ( 보이는 기준 ) */
            /*   > LAST : 마지막 행, 첫번째 열 ( 보이는 기준 ) */
            if ((TYPE || '') === '') {
                console.error('TYPE 변수의 값이 누락되었습니다.');
                return;
            }
            if ((TYPE || '').toString().toUpperCase() != 'FIRST' &&
                (TYPE || '').toString().toUpperCase() != 'LAST') {
                console.error('TYPE 변수의 값은 "FIRST" 또는 "LAST"만 지정이 가능합니다.');
                return;
            }

            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            if ($('#' + apis.setTable.content.getId('tbody', mainId) + ' tr:' + ((TYPE || '').toString().toUpperCase() === 'LAST' ? 'last' : 'first')).length > 0) {
                /* UID 설정 */
                var UID = $('#' + apis.setTable.content.getId('tbody', mainId) + ' tr:' + ((TYPE || '').toString().toUpperCase() === 'LAST' ? 'last' : 'first')).attr('uid');

                /* KEY 설정 */
                var KEY = '';
                $.each($.fn.dzt.options[mainId].display, function (idx, item) {
                    if ((item || 'N').toString().toUpperCase() === 'Y') {
                        KEY = ($.fn.dzt.options[mainId].columns[ $.fn.dzt.options[mainId].columns.length - 1 ].column || '');
                        return false;
                    }
                });

                return main.dzt('setFocus', UID, KEY);
            } else {
                return;
            }
        },
        setDefaultFocus: function (TYPE) {
            /* parameters 정의 */
            /* - TYPE : FIRST / LAST */
            /*   > FIRST : 첫번째 행, 첫번째 열 ( 보이는 기준 ) */
            /*   > LAST : 마지막 행, 첫번째 열 ( 보이는 기준 ) */
            if ((TYPE || '') === '') {
                console.error('TYPE 변수의 값이 누락되었습니다.');
                return;
            }
            if ((TYPE || '').toString().toUpperCase() != 'FIRST' &&
                (TYPE || '').toString().toUpperCase() != 'LAST') {
                console.error('TYPE 변수의 값은 "FIRST" 또는 "LAST"만 지정이 가능합니다.');
                return;
            }

            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            if ($('#' + apis.setTable.content.getId('tbody', mainId) + ' tr:' + ((TYPE || '').toString().toUpperCase() === 'LAST' ? 'last' : 'first')).length > 0) {
                /* UID 설정 */
                var UID = $('#' + apis.setTable.content.getId('tbody', mainId) + ' tr:' + ((TYPE || '').toString().toUpperCase() === 'LAST' ? 'last' : 'first')).attr('uid');

                /* KEY 설정 */
                var KEY = '';
                $.each($.fn.dzt.options[mainId].display, function (idx, item) {
                    if ((item || 'N').toString().toUpperCase() === 'Y') {
                        KEY = ($.fn.dzt.options[mainId].columns[0].column || '');
                        return false;
                    }
                });

                return main.dzt('setFocus', UID, KEY);
            } else {
                return;
            }
        },
        /* 키입력 이벤트 */
        setKeyIn: function (TYPE) {
            /* parameters 정의 */
            /* - TYPE : LEFT, RIGHT */
            /*   > LEFT : 왼쪽으로 이동 */
            /*   > RIGHT : 오른쪽으로 이동 */
            if ((TYPE || '') === '') {
                console.error('TYPE 변수의 값이 누락되었습니다.');
                return;
            }
            if ((TYPE || '').toString().toUpperCase() != 'LEFT' &&
                (TYPE || '').toString().toUpperCase() != 'RIGHT') {
                console.error('TYPE 변수의 값은 "LEFT" 또는 "RIGHT"만 지정이 가능합니다.');
                return;
            }

            /* 사용 변수 정의 */
            var main = $(this);

            /* 이벤트 수행 */
            switch ((TYPE || '').toString().toUpperCase()) {
                case 'LEFT': return apis.event.ArrowLeft(main);
                case 'RIGHT': return apis.event.ArrowRight(main);
            }
        },
        /* combobox resize */
        setResize: function () {
            /* 현재 표시되는 combobox의 width 조정 */
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* UID 정의 */
            var UID = ($.fn.dzt.options[mainId].selectUID || '');

            /* KEY 정의 */
            var KEY = ($.fn.dzt.options[mainId].selectKEY || '');

            if (UID !== '' && KEY !== '') {
                var column = fnc.getColumn(main, KEY);
                var td = $('#' + apis.setTable.content.getId('td', mainId, [KEY, UID].join('_')));

                /* AutoComplete width 설정 */
                $('#' + mainId + 'AutoComplete').css('width', td.css('width'));

                /* AutoComplete offset 설정 */
                var tdTop = td.offset().top + 25;
                var tdLeft = td.offset().left;
                var tblBottom = main.offset().top + $('#' + mainId).height() - 2;
                if (tdTop > tblBottom) { tdTop = tblBottom; }

                $('#' + mainId + 'AutoComplete').offset({ top: 0, left: 0 });
                $('#' + mainId + 'AutoComplete').offset({ top: tdTop, left: tdLeft });

                /* datepicker 위치 조정 */
                if ($('#ui-datepicker-div').css('display') != 'none') {
                    $('#ui-datepicker-div').offset({
                        top: td.offset().top + 25,
                        left: td.offset().left
                    });
                }
            }
        },
        /* 현재 행의 UID 조회 */
        getUID: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* 현재 UID 조회 및 반환 */
            if($.fn.dzt.options){
                if($.fn.dzt.options[mainId]){
                    return $.fn.dzt.options[mainId].selectUID;
                }
            }
            
            return "";
        },
        getKEY: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* 현재 KEY 조회 및 반환 */
            return $.fn.dzt.options[mainId].selectKEY;
        },
        /* 현재 포커스 값 조회 */
        getValue: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* UID 정의 */
            var UID = ($.fn.dzt.options[mainId].selectUID || '');

            /* 현재 행 정보(JSON) 반환 */
            if (UID != '') { return $('#' + apis.setTable.content.getId('tr', mainId, UID)).data([mainId, 'data'].join('_')); }
            else { return {}; }
        },
        /* 현재 행 값 조회 */
        getValueRow: function (UID) {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* UID 행 정보(JSON) 반환 */
            if (UID != '') { return $('#' + apis.setTable.content.getId('tr', mainId, UID)).data([mainId, 'data'].join('_')); }
            else { return {}; }
        },
        /* 현재 테이블 값 조회 */
        getValueAll: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* TABLE 정보(Array) 반환 */
            var resultArr = [];
            $.each($('#' + apis.setTable.content.getId('tbody', mainId)).find('tr'), function (idx, tr) {
                var trJson = {};
                trJson = $(tr).data([mainId, 'data'].join('_'));
                resultArr.push(trJson);
            });

            return resultArr;
        },
        /* 현재 입력중인 정보를 커밋하고 테스트 박스를 지운다. ( 포커스 유지 ) */
        setCommit: function (CALLBACK) {
            /* 사용 변수 정의 */
            CALLBACK = (typeof CALLBACK === 'undefined' ? true : CALLBACK);
            var main = $(this);
            var mainId = main.prop('id');

            /* column 정보 확인 */
            var column = fnc.getColumn(main, $.fn.dzt.options[mainId].selectKEY);

            /* commit 처리 */
            if(Object.keys(column).length > 0){
                apis.setTable.commit[column.type](main, $.fn.dzt.options[mainId].selectUID, $.fn.dzt.options[mainId].selectKEY, CALLBACK);
            }

            return;
        },
        getInputValue: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* UID, KEY 정의 */
            if($.fn.dzt.options[mainId]){
                var UID = $.fn.dzt.options[mainId].selectUID;
                var KEY = $.fn.dzt.options[mainId].selectKEY;
                
                /* input 확인 */
                var input = $('#' + apis.setTable.content.getId('td', mainId, [KEY, UID].join('_')) + ' span input');
    
                return input.val();
            } else {
                return null;
            }
        },
        /* 현재 포커스 값 반영 */
        setDisplayCol: function () { },
        /* 테이블 초기화 */
        setReset: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* 기존 옵션 정보 저장 */
            var options;
            options = $.extend({}, $.fn.dzt.options[mainId]);
            options.selectUID = '';
            options.selectKEY = '';

            /* 옵션 초기화 */
            $.fn.dzt.options[mainId] = {};

            /* AutoComplete 미표현 처리 */
            $('#' + mainId + 'AutoComplete').hide();

            /* init */
            main.dzt(options);

            return;
        },
        setTableRemove: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* 옵션 초기화 */
            $.fn.dzt.options[mainId] = {};

            /* 테이블 초기화 */
            main.unbind().empty();

            return;
        },
        setColRemoveSelect: function () {
            /* 사용 변수 정의 */
            var main = $(this);
            var mainId = main.prop('id');

            /* UID, KEY 정의 */
            var UID = $.fn.dzt.options[mainId].selectUID;
            var KEY = $.fn.dzt.options[mainId].selectKEY;

            /* 현재 선택된 td 찾기 */
            $('#' + apis.setTable.content.getId('td', mainId, [KEY, UID].join('_'))).removeClass('colOn');
        }
    };

    /* ## -=============================================================================================================- ## */
    /* ## -================================================== 내부 API ==================================================- ## */
    /* ## -=============================================================================================================- ## */
    /* ## -=============================================================================================================- ## */
    /* ## -=============================================================================================================- ## */

    var fnc = {
        getUID: function () {
            function s4() { return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1); }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        },
        getWebMode: function () {
            var isFirefox = typeof InstallTrigger !== 'undefined';
            var isIE = /*@cc_on!@*/ false || !!document.documentMode;
            var isEdge = !isIE && !!window.StyleMedia;
            var isChrome = !!window.chrome && !!window.chrome.webstore;

            if (isFirefox) { return 'Firefox'; }
            else if (isIE) { return 'IE'; }
            else if (isEdge) { return 'Edge'; }
            else if (isChrome) { return 'Chrome'; }
            else { return 'IE'; }
        },
        getColumn: function (main, key) {
            /* 사용 변수 정의 */
            var mainId = main.prop('id');

            /* columns 조회 */
            var resultColumn = {};
            $.each($.fn.dzt.options[mainId].columns, function (idx, item) {
                if (item.column === key) {
                    resultColumn = item;
                    return false;
                }
            });

            return resultColumn;
        },
        getNumeric: function (value) {
            var oldValue = value.toString().split('.');
            oldValue[0] = oldValue[0].toString().split(',').join('');
            oldValue[1] = ((value.toString().indexOf('.') > -1) ? '.' + (oldValue[1] || '').toString() : '');

            var newValue = '';
            newValue += (oldValue[0] || '').replace(/\B(?=(\d{3})+(?!\d))/g, ",").toString();
            return newValue;
        },
        getFloat: function (value){
        	value = value.toString().replace(/[^0-9.]/gi, '');
        	var lValue = value.toString().split('.')[0];
        	var rValue = value.toString().split('.')[1];
        	
        	lValue = (lValue || '').replace(/\B(?=(\d{3})+(?!\d))/g, ",").toString();
        	if(value.toString().indexOf('.') > -1 ){
        		return lValue + '.' + (rValue || '');	
        	}else{
        		return lValue; 
        	}
        },
        getDate: function (value) {
            var newValue = '';
            if (value.match(/^\d{4}$/) !== null) { newValue = value + '-'; }
            else if (value.match(/^\d{4}\-\d{2}$/) !== null) { newValue = value + '-'; }
            else { newValue = value; }

            newValue = newValue.toString().substring(0, (newValue.length < 10 ? newValue.length : 10));
            return newValue;
        }
    };

    var apis = {
        event: {
            setFocus: function (main, event) {
                /* 사용 변수 정의 */
                var mainId = main.prop('id');

                /* 행 선택 해제 처리 */
                apis.event.setRemoveFocus(main, event);

                /* 행 선택 처리 */
                var UID = apis.event.setAppendFocus(main, event);

                /* 데이트피커 미표시 처리 */
                /* $('#ui-datepicker-div').hide(); */
            },
            setAppendFocus: function (main, event) {
                if (['SPAN', 'TD'].indexOf(event.target.tagName) > -1) {
                    /* 사용 변수 정의 */
                    var mainId = main.prop('id');
                    var target = (event.target.tagName === 'SPAN' ? $(event.target).parent() : $(event.target));
                    var tr = $(target).parent();
                    var td = target;
                    var span = $(target.find('span'));
                    
                    /* edit element 생성 */
                    var uid = tr.attr('uid');
                    var key = (td.prop('id').split('_')[td.prop('id').split('_').length - 2]);
                	
                	/* tr class 추가 */
                	tr.addClass('rowOn');
                	/* td class 추가 */
                	td.addClass('colOn');
                	td.addClass('highLight');
                	/* span class 추가 */
                	span.addClass('highLightIn');

                    /* 현재 행, 열 기록 */
                    $.fn.dzt.options[mainId].selectUID = uid;
                    $.fn.dzt.options[mainId].selectKEY = key;

                    $.each($.fn.dzt.options[mainId].columns, function (idx, item) {
                        if (item.column === key) {
                        	if(formSeq =='64'){
                        		
                        		apis.setTable.edit['readonly'](main, uid, key);
                        	} else{
                        		
                        		apis.setTable.edit[item.type](main, uid, key);
                        	}
                        	

                            /* 데이터 피커가 아닌 경우 데이트피커 미표시 처리 */
                            if (item.type !== 'datepicker') { $('#ui-datepicker-div').hide(); }
                            return false;
                        }
                    });

                    /* tooltip 처리 */
                    var column = fnc.getColumn(main, key);
                    if (typeof column.tooltip === 'function') { column.tooltip(); }

                    /* 반환처리 */
                    return uid;
                }

                /* 반환처리 */
                return '';
            },
            setRemoveFocus: function (main, event) {
                if (['SPAN', 'TD'].indexOf(event.target.tagName) > -1) {
                    /* 사용 변수 정의 */
                    /* 사용 변수 정의 */
                    var mainId = main.prop('id');
                    var rightContentTable = $('#' + apis.setTable.content.getId('table', mainId));

                    /* 기존 선택된 행이 존재하는 경우만 처리 */
                    if (rightContentTable.find('.rowOn').length > 0) {
                        /* commit element 처리 */
                        if (rightContentTable.find('.rowOn').length > 0 && rightContentTable.find('.colOn').length > 0) {
                            var uid = rightContentTable.find('.rowOn').attr('uid');
                            var key = (rightContentTable.find('.colOn').prop('id').split('_')[rightContentTable.find('.colOn').prop('id').split('_').length - 2]);
                            $.each($.fn.dzt.options[mainId].columns, function (idx, item) {
                                if (item.column === key) {
                                    apis.setTable.commit[item.type](main, uid, key);
                                    return false;
                                }
                            });
                        }

                        /* tr class 제거 */
                        rightContentTable.find('.rowOn').removeClass('rowOn');
                        /* td class 제거 */
                        rightContentTable.find('.colOn').removeClass('colOn');
                        rightContentTable.find('.highLight').removeClass('highLight');
                        /* span class 제거 */
                        rightContentTable.find('.highLightIn').removeClass('highLightIn');
                    }
                }

                return;
            },
            /* 기본 이벤트 : ArrowLeft */
            ArrowLeft: function (main) {
                /* 사용 변수 정의 */
                var mainId = main.prop('id');

                /* 현재 행의 uid */
                var uid = $.fn.dzt.options[mainId].selectUID;
                /* 현재 열의 key */
                var key = $.fn.dzt.options[mainId].selectKEY;

                /* 이벤트 수행 */
                if ((uid || '') === '' || (key || '') === '') {
                    /* 현재 선택된 값이 없는 경우 예외처리 */
                    return;
                } else {
                    /* 기준 입력 위치 정의 : td */
                    var baseTd = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));

                    /* column key array */
                    var keys = [];
                    $.each($.fn.dzt.options[mainId].columns, function (idx, item) { keys.push(item.column); });

                    /* 현재 선택 위치 */
                    var selectIdx = keys.indexOf(key);

                    /* 다음 포커스 위치 찾기 */
                    var nextTd = null;
                    for (i = (selectIdx - 1) ; i > -1; i--) {
                        if ($.fn.dzt.options[mainId].display[i] == 'Y') {
                            var column = fnc.getColumn(main, keys[i]);
                            if (column.type != 'readonly') {
                                nextTd = $('#' + apis.setTable.content.getId('td', mainId, [keys[i], uid].join('_')));
                                break;
                            }
                        }
                    }

                    if (nextTd === null) {
                        for (i = (keys.length - 1) ; i > -1; i--) {
                            if ($.fn.dzt.options[mainId].display[i] == 'Y') {
                                var column = fnc.getColumn(main, keys[i]);
                                if (column.type != 'readonly') {
                                    nextTd = $('#' + apis.setTable.content.getId('td', mainId, [keys[i], uid].join('_')));
                                    break;
                                }
                            }
                        }
                    }

                    /* 다음 td focus */
                    nextTd.click();
                    
                    console.log("@@");
                }
            },
            
            /**
             *  dj 커스텀 컬럼 입력 시 흐름
             *  ArrowRight -> setFocus -> remove -> setAppendFocus (call setTable.edit[type])
             */
            
            /* 기본 이벤트 : ArrowRight */
            ArrowRight: function (main) {
            	
                /* 사용 변수 정의 */
                var mainId = main.prop('id');
                /* 현재 행의 uid */
                var uid = $.fn.dzt.options[mainId].selectUID;
                /* 현재 열의 key */
                var key = $.fn.dzt.options[mainId].selectKEY;
                
                /* dj 커스텀 */
                var inputText = $('#' + uid + '_' + key).val();
                var idx = 0;
                
                if (inputText === '미사용') {
                	$.fn.dzt.options['tradeTbl'].columns[2].type = 'readonly';
                	$('#tradeTbl').dzt('setValue', uid, {
                		'bojoReasonText' : '',
                	});
                	idx = 1;
                } else if (inputText === '사용') {
                	$.fn.dzt.options['tradeTbl'].columns[2].type = 'combobox';
                }
                /* dj 커스텀 */
                
                /* 이벤트 수행 */
                if ((uid || '') === '' || (key || '') === '') {
                    /* 현재 선택된 값이 없는 경우 예외처리 */
                    return;
                } else {
                    /* 기준 입력 위치 정의 : td */
                    var baseTd = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));

                    /* column key array */
                    var keys = [];
                    $.each($.fn.dzt.options[mainId].columns, function (idx, item) { keys.push(item.column); });

                    /* 현재 선택 위치 */
                    var selectIdx = keys.indexOf(key) + idx;

                    /* 다음 포커스 위치 찾기 */
                    var nextTd = null;
                    for (i = (selectIdx + 1) ; i < keys.length; i++) {
                        if ($.fn.dzt.options[mainId].display[i] == 'Y') {
                            var column = fnc.getColumn(main, keys[i]);
                            if (column.type != 'readonly') {
                                nextTd = $('#' + apis.setTable.content.getId('td', mainId, [keys[i], uid].join('_')));
                                break;
                            }
                        }
                    }

                    /* 마지막 컬럼 입력 후 이벤트가 존재할 경우 이벤트 호출 처리 */
                    var columns = fnc.getColumn(main, key);
                    if (columns.lastCallback && typeof columns.lastCallback == 'function') {
                        /* update 필요 ( 최근 입력 정보까지 반영 후 호출 - 상겸 ) */
                        apis.setTable.commit[columns.type](main, uid, key);
                        apis.setTable.edit[columns.type](main, uid, key);
                        if (!columns.lastCallback()) { return false; }
                    }

                    if (nextTd === null) {
                        for (i = 0; i < keys.length; i++) {
                            if ($.fn.dzt.options[mainId].display[i] == 'Y') {
                                var column = fnc.getColumn(main, keys[i]);
                                if (column.type != 'readonly') {
                                    nextTd = $('#' + apis.setTable.content.getId('td', mainId, [keys[i], uid].join('_')));
                                    break;
                                }
                            }
                        }
                    }

                    /* 다음 td focus */
                    nextTd.click();
                }
            },
            /* 기본 이벤트 : ArrowUp */
            ArrowUp: function (main) { },
            /* 기본 이벤트 : ArrowDown */
            ArrowDown: function (main) { },
            /* 기본 이벤트 : Enter */
            Enter: function (main, type) {
                /* parameters 정의 */
                /* - type : 반대동작 여부 ( REVERSE ) */

                /* 파라미터 기본값 정의 */
                type = (type || '');

                /* Enter 기본동작은 ArrowLeft or ArrowRight와 같이 동작한다. */
                if (type.toString().toUpperCase() === 'REVERSE') { apis.event.ArrowLeft(main); }
                else { apis.event.ArrowRight(main); }
            },
            /* 기본 이벤트 : Tab */
            Tab: function (main, type) {
                /* parameters 정의 */
                /* - type : 반대동작 여부 ( REVERSE ) */

                /* 파라미터 기본값 정의 */
                type = (type || '');

                /* Tab 기본동작은 ArrowLeft or ArrowRight와 같이 동작한다. */
                if (type.toString().toUpperCase() === 'REVERSE') { apis.event.ArrowLeft(main); }
                else { apis.event.ArrowRight(main); }
            }
        },
        setTable: {
            main: function (main) {
                /* 1.0.0 : main.div.class : cus_ta_ea scbg posi_re */
                main.addClass((main.hasClass('cus_ta_ea') ? '' : 'cus_ta_ea'));
                main.addClass((main.hasClass('scbg') ? '' : 'scbg'));
                main.addClass((main.hasClass('posi_re') ? '' : 'posi_re'));
            },
            colgroup: function (main) {
                /* 사용 변수 정의 */
                var mainId = main.prop('id');
                var rightHeaderColgroup = $('#' + apis.setTable.header.getId('colgroup', mainId));
                var rightContentColgroup = $('#' + apis.setTable.content.getId('colgroup', mainId));

                /* colgroup 초기화 */
                rightHeaderColgroup.empty();
                rightContentColgroup.empty();

                /* colgroup 설정 */
                var colgoup = '';
                $.each($.fn.dzt.options[mainId].width, function (idx, item) {
                    /* 표현되는 컬럼 기준으로만 colgroup 설정 >> 크기 자동조정을 처리하기 위함 */
                    if ($.fn.dzt.options[mainId].display[idx] == 'Y') { colgoup += '<col width="' + item + '">'; }
                });
                rightHeaderColgroup.append(colgoup);
                rightContentColgroup.append(colgoup);
            },
            display: function (main) {
                /* 사용 변수 정의 */
                var mainId = main.prop('id');
                
                /* display 설정 */
                $.each($.fn.dzt.options[mainId].display, function (idx, item) {
                    if (item == 'Y') {
                        $('#' + apis.setTable.header.getId('th', mainId, idx)).css('display', ''); /* header */
                        $.each($('#' + apis.setTable.content.getId('tbody', mainId)).find('tr'), function (trIdx, tr) {
                            $(tr).find('td:eq(' + idx + ')').css('display', ''); /* content */
                        });
                    } else {
                        $('#' + apis.setTable.header.getId('th', mainId, idx)).css('display', 'none'); /* header */
                        $.each($('#' + apis.setTable.content.getId('tbody', mainId)).find('tr'), function (trIdx, tr) {
                            $(tr).find('td:eq(' + idx + ')').css('display', 'none'); /* content */
                        });
                    }
                });
            },
            header: {
                table: function (main) {
                    /* 사용 변수 정의 */
                    var mainId = main.prop('id');

                    /* 1.0.0 : main.div.scrollHeader */
                    var scrollHeader = document.createElement('span');
                    $(scrollHeader).addClass(($(scrollHeader).hasClass('scy_head1') ? '' : 'scy_head1'));
                    main.append(scrollHeader);

                    /* 1.0.0 : main.div.right_header.div */
                    var rightHeaderDiv = document.createElement('div');
                    $(rightHeaderDiv).attr('id', apis.setTable.header.getId('div', mainId));
                    $(rightHeaderDiv).addClass('cus_ta_ea ovh mr17 scbg ta_bl');
                    main.append(rightHeaderDiv);

                    /* 1.0.0 : main.div.right_header.div.table */
                    var rightHeaderTable = document.createElement('table');
                    $(rightHeaderTable).attr('id', apis.setTable.header.getId('table', mainId));
                    $(rightHeaderDiv).append(rightHeaderTable);


                    /* 1.0.0 : main.div.right_header.div.table.colgroup */
                    var rightHeaderColgroup = document.createElement('colgroup');
                    $(rightHeaderColgroup).attr('id', apis.setTable.header.getId('colgroup', mainId));
                    $(rightHeaderTable).append(rightHeaderColgroup);

                    /* 1.0.0 : main.div.right_header.div.table.tbody */
                    var rightHeaderTbody = document.createElement('tbody');
                    $(rightHeaderTbody).attr('id', apis.setTable.header.getId('tbody', mainId));
                    $(rightHeaderTable).append(rightHeaderTbody);

                    /* 1.0.0 : main.div.right_header.div.table.tbody.tr */
                    var rightHeaderTr = document.createElement('tr');
                    $(rightHeaderTr).attr('id', apis.setTable.header.getId('tr', mainId, 0));
                    $(rightHeaderTbody).append(rightHeaderTr);

                    /* 1.0.0 : main.div.right_header.div.table.tbody.tr.td */
                    $.each($.fn.dzt.options[mainId]['columns'], function (idx, item) {
                        var rightHeaderTh = document.createElement('th');
                        $(rightHeaderTh).attr('id', apis.setTable.header.getId('th', mainId, idx));
                        var align = item.align;
                        align = (dztVars.defAlign.indexOf(align) < 0 ? 'CENTER' : align);
                        switch (align) {
                            case 'LEFT': $(rightHeaderTh).addClass(''); break;
                            case 'CENTER': $(rightHeaderTh).addClass(''); break;
                            case 'RIGHT': $(rightHeaderTh).addClass(''); break;
                        }
                        var title = $.fn.dzt.options[mainId].title[idx];
                        $(rightHeaderTh).html(title);
                        $(rightHeaderTr).append(rightHeaderTh);
                    });
                },
                getId: function (type, mainId, seq) {
                    type = (type || '');
                    seq = (seq || '0');

                    switch (type) {
                        case 'div': return [mainId, dztVars.defTableId.rightHeaderDiv].join('_');
                        case 'table': return [mainId, dztVars.defTableId.rightHeaderDiv, dztVars.defTableId.rightHeaderTable].join('_');
                        case 'colgroup': return [mainId, dztVars.defTableId.rightHeaderDiv, dztVars.defTableId.rightHeaderTable, dztVars.defTableId.rightHeaderColgroup].join('_');
                        case 'thead': return [mainId, dztVars.defTableId.rightHeaderDiv, dztVars.defTableId.rightHeaderTable, dztVars.defTableId.rightHeaderThead].join('_');
                        case 'tbody': return [mainId, dztVars.defTableId.rightHeaderDiv, dztVars.defTableId.rightHeaderTable, dztVars.defTableId.rightHeaderTbody].join('_');
                        case 'tr': return [mainId, dztVars.defTableId.rightHeaderDiv, dztVars.defTableId.rightHeaderTable, dztVars.defTableId.rightHeaderTr].join('_');
                        case 'th': return [mainId, dztVars.defTableId.rightHeaderDiv, dztVars.defTableId.rightHeaderTable, dztVars.defTableId.rightHeaderTd, seq].join('_');
                        default: return '';
                    }
                },
                setReq: function (main) {
                    /* 사용 변수 정의 */
                    var mainId = main.prop('id');

                    /* 필수값 표시 */
                    $.each($.fn.dzt.options[mainId].req, function (idx, item) {
                        item = ((item || '') === '' ? 'N' : item);
                        var th = $('#' + apis.setTable.header.getId('th', mainId, idx));
                        var text = '';

                        /* trim : https://www.w3schools.com/jsref/jsref_trim_string.asp */
                        /* trim : 문자열 중간의 공백은 제거되지 않음. */
                        if (item === 'Y') { text = (th.find('img').length === 0 ? '<img src="../../../images/ico/ico_check01.png" alt="">&nbsp;' : '') + th.text(); }
                        else { text = th.text().trim(); }

                        th.empty();
                        th.append(text);
                    });
                }
            },
            content: {
                table: function (main) {
                    /* 사용 변수 정의 */
                    var mainId = main.prop('id');

                    /* 1.0.0 : main.div.right_content.div */
                    var rightContentDiv = document.createElement('div');
                    $(rightContentDiv).attr('id', apis.setTable.content.getId('div', mainId));
                    $(rightContentDiv).addClass('cus_ta_ea rowHeight scroll_y_fix rightContents scbg ta_bl');
                    $(rightContentDiv).css('height', $.fn.dzt.options[mainId].height);
                    main.append(rightContentDiv);

                    /* 1.0.0 : main.div.right_content.div.table */
                    var rightContentTable = document.createElement('table');
                    $(rightContentTable).attr('id', apis.setTable.content.getId('table', mainId));
                    $(rightContentDiv).append(rightContentTable);

                    /* 1.0.0 : main.div.right_content.div.table.colgroup */
                    var rightContentColgroup = document.createElement('colgroup');
                    $(rightContentColgroup).attr('id', apis.setTable.content.getId('colgroup', mainId));
                    $(rightContentTable).append(rightContentColgroup);

                    /* 1.0.0 : main.div.right_content.div.table.tbody */
                    var rightContentTbody = document.createElement('tbody');
                    $(rightContentTbody).attr('id', apis.setTable.content.getId('tbody', mainId));
                    $(rightContentTable).append(rightContentTbody);
                },
                addRow: function (main) {
                    /* 사용 변수 정의 */
                    var mainId = main.prop('id');
                    var rightContentTbody = $('#' + apis.setTable.content.getId('tbody', mainId));
                    var UID = fnc.getUID();

                    /* tr 추가 */
                    var tr = document.createElement('tr');
                    $(tr).attr('id', apis.setTable.content.getId('tr', mainId, UID));
                    $(tr).attr('uid', UID);
                    rightContentTbody.append(tr);

                    /* td 추가 */
                    $.each($.fn.dzt.options[mainId]['columns'], function (idx, item) {
                        var td = document.createElement('td');
                        $(td).attr('id', apis.setTable.content.getId('td', mainId, [item.column, UID].join('_')));
                        $(td).attr('uid', UID);
                        $(td).addClass('cen');
                        $(tr).append(td);

                        var span = document.createElement('span');
                        $(td).append(span);

                        /* TODO: 이벤트 정의 필요 */
                        $(td).click(function (event) {
                        	
                        	if (['SPAN', 'TD', 'INPUT'].indexOf(event.target.tagName) > -1) { /* dj 커스텀 보조금 */
                        		
                        		apis.event.setFocus(main, event); 
                    		} 
                        	
                        	return; 
                    	});
                    });

                    /* 행 추가 후 display 처리 */
                    apis.setTable.display(main);

                    /* 추가된 행 반환 */
                    return tr;
                },
                removeRow: function (main, tr) {
                    /* tr 삭제 */
                    tr.remove();
                },
                rowIdx: function (main) { },
                getId: function (type, mainId, seq) {
                    type = (type || '');
                    seq = (seq || '0');

                    switch (type) {
                        case 'div': return [mainId, dztVars.defTableId.rightContentDiv].join('_');
                        case 'table': return [mainId, dztVars.defTableId.rightContentDiv, dztVars.defTableId.rightContentTable].join('_');
                        case 'colgroup': return [mainId, dztVars.defTableId.rightContentDiv, dztVars.defTableId.rightContentTable, dztVars.defTableId.rightContentColgroup].join('_');
                        case 'thead': return [mainId, dztVars.defTableId.rightContentDiv, dztVars.defTableId.rightContentTable, dztVars.defTableId.rightContentThead].join('_');
                        case 'tbody': return [mainId, dztVars.defTableId.rightContentDiv, dztVars.defTableId.rightContentTable, dztVars.defTableId.rightContentTbody].join('_');
                        case 'tr': return [mainId, dztVars.defTableId.rightContentDiv, dztVars.defTableId.rightContentTable, dztVars.defTableId.rightContentTr, seq].join('_');
                        case 'td': return [mainId, dztVars.defTableId.rightContentDiv, dztVars.defTableId.rightContentTable, dztVars.defTableId.rightContentTd, seq].join('_');
                        default: return '';
                    }
                }
            },
            edit: {            	
                text: function (main, uid, key) {
                    /* 사용변수 정의 */
                    var mainId = main.prop('id');
                    var td = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));
                    var span = $(td).find('span');
                    var value = span.text();
                    var column = fnc.getColumn(main, key);

                    /* 데이터 변경 callback 호출 */
                    if (typeof $.fn.dzt.options[mainId].changeCallback === 'function') {
                        if (!$.fn.dzt.options[mainId].changeCallback(uid, key)) {
                            main.dzt('setColRemoveSelect'); /* colOn 제거 */
                            return;
                        }
                    }

                    /* td 수정 모드 확인 */
                    if (td.find('input').length > 0) { return; }

                    /* td input 생성 */
                    var input = document.createElement('input');
                    
                    /* dj 커스텀 */
                    
                    //	입출금계좌 컬럼 작업
                    if (column.column === "btrNb" || column.column === "amt") {
                    	$(input).attr('readonly', true);
                    }
                    
                    // 프로젝트, 예산과목, 거래처 더블 클릭 시 팝업창 호출
                    if (column.column === "erpMgtName" || column.column === "erpBudgetName" || column.column === "trName" || column.column === "erpDivName" || column.column === 'btrName') { 
                    	
                    	$(input).dblclick(function() {
                    		column.methods['keyEvent' + 'F2']();
                    	});
                    }
                    
                    /* dj 커스텀 */
                    
                    $(input).attr('type', 'text');
                    // $(input).css('ime-mode', 'active');
                    $(input).attr('id', [uid, key].join('_'));
                    $(input).addClass('inpTextBox');
                    $(input).val(value);

                    /* input event 생성 [ keydown : ESC / F2 / F3 / F4 / F12 / TAB / ENTER / BACKSPACE ] */
                    $(input).keydown(function () {
                        var keyCode = event.keyCode ? event.keyCode : event.which;

                        switch (keyCode.toString()) {
                            case dztVars.keyMap.ArrowLeft[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 왼쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowLeft']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowLeft'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowLeft']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                    apis.event.ArrowLeft(main);
                                }

                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowRight[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowRight']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowRight'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowRight']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                    apis.event.ArrowRight(main);
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowUp[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 위쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowUp']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowUp'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowUp']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowDown[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 아래쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowDown']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowDown'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowDown']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Tab[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'Tab']) {
                                    if (typeof column.methods['keyEvent' + 'Tab'] == 'function') {
                                        column.methods['keyEvent' + 'Tab']();
                                    }
                                } else {
                                    /* 기본기능 수행 ( Shift 키 조합시 반대로 동작 ) */
                                    apis.event.Tab(main, (event.shiftKey ? 'reverse' : ''));
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Enter[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'Enter']) {
                                    if (typeof column.methods['keyEvent' + 'Enter'] == 'function') {
                                        column.methods['keyEvent' + 'Enter']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                    apis.event.Enter(main, (event.shiftKey ? 'reverse' : ''));
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Backspace[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'Backspace']) {
                                    if (typeof column.methods['keyEvent' + 'Backspace'] == 'function') {
                                        column.methods['keyEvent' + 'Backspace']();
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.Space[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'Space']) {
                                    if (typeof column.methods['keyEvent' + 'Space'] == 'function') {
                                        column.methods['keyEvent' + 'Space']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F2[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F2']) {
                                    if (typeof column.methods['keyEvent' + 'F2'] == 'function') {
                                        column.methods['keyEvent' + 'F2']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F3[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F3']) {
                                    if (typeof column.methods['keyEvent' + 'F3'] == 'function') {
                                        column.methods['keyEvent' + 'F3']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F4[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F4']) {
                                    if (typeof column.methods['keyEvent' + 'F4'] == 'function') {
                                        column.methods['keyEvent' + 'F4']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F12[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F12']) {
                                    if (typeof column.methods['keyEvent' + 'F12'] == 'function') {
                                        column.methods['keyEvent' + 'F12']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.Backspace[fnc.getWebMode()]:
                                /* Backspace */
                                if (column.methods && column.methods['keyEvent' + 'Backspace']) {
                                    if (typeof column.methods['keyEvent' + 'Backspace'] == 'function') {
                                        column.methods['keyEvent' + 'Backspace']();
                                    }
                                }
                                break;
                            case dztVars.keyMap.Delete[fnc.getWebMode()]:
                                /* Delete */
                                if (column.methods && column.methods['keyEvent' + 'Delete']) {
                                    if (typeof column.methods['keyEvent' + 'Delete'] == 'function') {
                                        column.methods['keyEvent' + 'Delete']();
                                    }
                                }
                                break;
                            default:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 공통코드 호출의 경우 사용자 입력이 발생되면, 연관된 코드도 초기화가 진행되어야 하므로 default를 활용할 수 있도록 구현 */
                                if (column.methods && column.methods['keyEvent' + 'Default']) {
                                    if (typeof column.methods['keyEvent' + 'Default'] == 'function') {
                                        column.methods['keyEvent' + 'Default']();
                                        // return false;
                                    }
                                }
                                break;
                        }
                    });

                    /* isNumeric 값이 true 인 경우 3자리 콤마 처리 */
                    $(input).keyup(function () { 
                        if (column.isNumeric) {
                            
                            /* 수치 제외 모든 문자 제거  
                             * 마이너스(-) 금액 입력 금지
                             * */
                            var dispSign = this.value.indexOf('-') > -1 ? -1 : 1;
                            var dispValue = '';
                            var advDot = '';
                            if(!!optionSet.customOption['CUST_002']){
                            	/* 금액 소숫점 입력 사용 */
                                if(this.value.indexOf('.') > -1){
                                	advDot = '.' + this.value.split('.')[1].replace(/[^0-9]/g,'') || '';
                                	dispValue = parseInt( ( this.value.split('.')[0].replace(/[^0-9]/g,'') || '0' ) ) + advDot;
                                }else{
                                	dispValue = parseFloat( ( this.value.replace(/[^0-9]/g,'') || '0' ) );
                                }
                            }else{
                            	/* 금액 입력 기본 모드 */
                            	dispValue = parseInt( ( this.value.replace(/[^0-9]/g,'') || '0' ) );
                            }
                            
                            if(optionSet.formInfo.formDTp.indexOf('RES') > -1){
                                var docuFgCode = $('#resTbl').dzt('getValue').docuFgCode;
                                if(!!optionSet.customOption['CUST_002']){
                                	/* 금액 소숫점 입력 사용 */
                                	
                                    if(this.value.indexOf('.') > -1){
                                    	advDot = '.' + this.value.split('.')[1].replace(/[^0-9]/g,'') || '';
                                    	dispValue = parseInt( ( this.value.split('.')[0].replace(/[^0-9]/g,'') || '0' ) );
                                    	
    	                                /* [여입결의서 / 반납결의서] 처리 
    	                                 * 모든 금액에 대하여 마이너스(-) 금액 처리
    	                                 * */
    	                                if( (docuFgCode == '6') || (docuFgCode == '7') ){
    	                                    dispValue = Math.abs( parseInt( dispValue.replace(/[^0-9]/g,'') ) ) * -1 + advDot;
    	                                }
    	                                /*
    	                                 * [결의서] 기본 - 금액 입력 허용
    	                                 * */
    	                                else{
    	                                    dispValue = Math.abs( parseInt( dispValue.replace(/[^0-9]/g,'') ) ) * dispSign + advDot;
    	                                }
                                    	
                                    	
                                    }else{
    	                                /* [여입결의서 / 반납결의서] 처리 
    	                                 * 모든 금액에 대하여 마이너스(-) 금액 처리
    	                                 * */
    	                                if( (docuFgCode == '6') || (docuFgCode == '7') ){ 
    	                                    dispValue = Math.abs( parseInt( dispValue.replace(/[^0-9]/g,'') ) ) * -1 + advDot;
    	                                }
    	                                /*
    	                                 * [결의서] 기본 - 금액 입력 허용
    	                                 * */
    	                                else{
    	                                    dispValue = Math.abs( parseInt( dispValue.replace(/[^0-9]/g,'') ) ) * dispSign + advDot;
    	                                }
                                    }
                                	
                                }else{
                                	/* 금액 입력 기본 모드 */
                                	
	                                /* [여입결의서 / 반납결의서] 처리 
	                                 * 모든 금액에 대하여 마이너스(-) 금액 처리
	                                 * */
	                                if( (docuFgCode == '6') || (docuFgCode == '7') ){
	                                    dispValue = Math.abs( parseInt( this.value.replace(/[^0-9]/g,'') ) ) * -1 + advDot;
	                                }
	                                /*
	                                 * [결의서] 기본 - 금액 입력 허용
	                                 * */
	                                else{
	                                    dispValue = Math.abs( parseInt( this.value.replace(/[^0-9]/g,'') ) ) * dispSign + advDot;
	                                }
                                }
                            }
                            
                            /* dispValue 예외처리 */
                            if(!dispValue || dispValue == 'NaN'){
                                dispValue = 0;
                            }
                            
                            
                            /* 소숫점 옵션 사용 */
                            if(!!optionSet.customOption['CUST_002']){
                            	/* 천단위 콤마(,) 설정 */
                                console.log(fnc.getFloat( dispValue ));
                                this.value = fnc.getFloat( dispValue );
                            }else{
                            	/* 천단위 콤마(,) 설정 */
                                console.log(fnc.getNumeric( dispValue ));
                                this.value = fnc.getNumeric( dispValue );
                            }
                            
                            
                            
                            /* -0 입력 예외처리 */
                            if(this.value == 0 && dispSign == -1){
                                this.value = '-';
                            }

                            /* 예외처리 (this.value = NaN 인경우.) 진행 */
                            if( (!this.value) ){
                                this.value = '0';
                            }
                        } 
                    });

                    /* td append input */
                    span.empty();
                    span.append(input);

                    /* focus 정의 */
                    td.addClass((td.hasClass('colOn') ? '' : 'colOn'));
                    td.addClass((td.hasClass('highLight') ? '' : 'highLight'));
                    $(input).focus().select();
                },
                combobox: function (main, uid, key) {
                	
                	/* 콤보박스 그려질 때 보조금 이체여부 보고 판단 
                	 * 미사용 일시 그 다음셀로 이동 ( 없음 고정에 ) */
                	
                    /* 사용변수 정의 */
                    var mainId = main.prop('id');
                    var tr = $('#' + apis.setTable.content.getId('tr', mainId, uid));
                    var td = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));
                    var span = $(td).find('span');
                    var value = span.text();

                    /* 데이터 변경 callback 호출 */
                    if (typeof $.fn.dzt.options[mainId].changeCallback === 'function') {
                        if (!$.fn.dzt.options[mainId].changeCallback(uid, key)) {
                            main.dzt('setColRemoveSelect'); /* colOn 제거 */
                            return;
                        }
                    }

                    /* td 수정 모드 확인 */
                    if (td.find('input').length > 0) { return; } /* dj 커스텀 보조금 */
                    
                    /* td input 생성 */
                    var input = document.createElement('input');
                    $(input).attr('type', 'text');
                    // $(input).css('ime-mode', 'active');
                    $(input).attr('id', [uid, key].join('_'));
                    $(input).attr('readonly', 'readonly');
                    $(input).addClass('inpTextBox');
                    $(input).val(value);
                    
                    /* input event 생성 [ keydown : ESC / F2 / F3 / F4 / F12 / TAB / ENTER / BACKSPACE ] */
                    $(input).keydown(function () {
                        var keyCode = event.keyCode ? event.keyCode : event.which;
                        var column = fnc.getColumn(main, key);

                        switch (keyCode.toString()) {
                            case dztVars.keyMap.ArrowLeft[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 왼쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowLeft']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowLeft'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowLeft']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                    apis.event.ArrowLeft(main);
                                }

                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowRight[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowRight']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowRight'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowRight']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                    apis.event.ArrowRight(main);
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowUp[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 위쪽 셀로 이동 */
                                if ($('#' + mainId + 'AutoComplete').length > 0) {
                                    if ($('#' + mainId + 'AutoComplete ul li.on').length > 0) {
                                        if ($('#' + mainId + 'AutoComplete ul li.on').prev('li').length > 0) {
                                            $('#' + mainId + 'AutoComplete ul li.on').prev('li').click();
                                        } else {
                                            $('#' + mainId + 'AutoComplete ul li:last').click();
                                        }
                                    } else {
                                        $('#' + mainId + 'AutoComplete ul li:last').click();
                                    }
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowDown[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 아래쪽 셀로 이동 */
                                if ($('#' + mainId + 'AutoComplete').length > 0) {
                                    if ($('#' + mainId + 'AutoComplete ul li.on').length > 0) {
                                        if ($('#' + mainId + 'AutoComplete ul li.on').next('li').length > 0) {
                                            $('#' + mainId + 'AutoComplete ul li.on').next('li').click();
                                        } else {
                                            $('#' + mainId + 'AutoComplete ul li:first').click();
                                        }
                                    } else {
                                        $('#' + mainId + 'AutoComplete ul li:first').click();
                                    }
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Tab[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                apis.event.Tab(main, (event.shiftKey ? 'reverse' : ''));
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Enter[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                //                              if ($('#' + mainId + 'AutoComplete').length > 0) {
                                //                                  if ($('#' + mainId + 'AutoComplete ul li.on').length > 0) {
                                //                                      var li = $('#' + mainId + 'AutoComplete ul li.on');
                                //                                      var uid = $(li).attr('uid');
                                //                                      var key = $(li).attr('key');
                                //                                      apis.setTable.commit.combobox(main, uid, key)
                                //                                  }
                                //                              }
                                apis.event.Tab(main, (event.shiftKey ? 'reverse' : ''));
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Backspace[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.Space[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F2[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F3[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F4[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F12[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 없음 */
                                break;
                            case '49':
                            case '50':
                            case '51':
                            case '52':
                            case '53':
                                column.methods['keyEventKeycode'](keyCode.toString());
                                event.preventDefault();
                            	break;
                            default:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 공통코드 호출의 경우 사용자 입력이 발생되면, 연관된 코드도 초기화가 진행되어야 하므로 default를 활용할 수 있도록 구현 */
                                //                              $.each($('#' + mainId + 'AutoComplete ul li'), function (idx, elem) {
                                //                                  if (JSON.stringify($(elem).data('value')).indexOf(this.val()) > -1) {
                                //                                      $(elem).click();
                                //                                      return false;
                                //                                  }
                                //                              });
                                break;
                        }
                    });

                    /* td append input */
                    span.empty();
                    span.append(input);

                    /* div 생성 */
                    var autoCompleteDiv = null;
                    if ($('#' + mainId + 'AutoComplete').length > 0) {
                        $('#' + mainId + 'AutoComplete').remove();
                    }
                    autoCompleteDiv = document.createElement('div');
                    $(autoCompleteDiv).attr('id', mainId + 'AutoComplete');
                    $(autoCompleteDiv).addClass('posi_ab AutoCompleteClass');
                    $(autoCompleteDiv).css('z-index', '2');
                    $('body').append(autoCompleteDiv);

                    $(autoCompleteDiv).unbind();
                    $(autoCompleteDiv).empty();

                    /* ul 정의 */
                    var ul = document.createElement('ul');
                    $(ul).addClass('inp_list');
                    $(autoCompleteDiv).append(ul);

                    /* li 정의 */
                    var column = fnc.getColumn(main, key);
                    if (column.combobox) {
                        $.each(column.combobox.data, function (idx, item) {
                            var displayName = '';
                            $.each(column.combobox.display, function (dispIdx, key) {
                                displayName += (item[key] ? item[key] : key);
                            });

                            var li = document.createElement('li');
                            $(li).data('value', item);
                            $(li).html(displayName);
                            $(li).click(function () {
                                $('#' + mainId + 'AutoComplete ul li').removeClass('on');
                                $(input).val(item[key]);
                                $(this).addClass('on');
                                $(input).focus();
                            });
                            
                            $(li).dblclick(function () {
                                $('#' + mainId + 'AutoComplete ul li').removeClass('on');
                                $(input).val(item[key]);
                                $(this).addClass('on');
                                apis.event.ArrowRight(main);
                            });
                            $(li).attr('uid', uid);
                            $(li).attr('key', key);

                            /* 사용자가 이미 선택한 내역을 자동 선택 처리 */
                            if (tr.data([mainId, 'data'].join('_')) &&
                                tr.data([mainId, 'data'].join('_'))[key] != undefined &&
                                tr.data([mainId, 'data'].join('_'))[key] === item[key]) {
                                // $(li).addClass('on');
                            } else {
                                $(li).addClass(idx === 0 ? 'on' : '');
                            }
                            $(ul).append(li);
                        });
                    } else {
                        console.error('column.combobox 가 정의되지 않았습니다. { column: {combobox: { display: [], data: [] } } }');
                    }

                    /* AutoComplete offset 설정 */
                    var tdTop = td.offset().top + 25;
                    var tdLeft = td.offset().left;
                    var tblBottom = main.offset().top + $('#' + mainId).height() - 2;
                    if (tdTop > tblBottom) {
                        tdTop = tblBottom;
                    }

                    $('#' + mainId + 'AutoComplete').offset({ top: 0, left: 0 });
                    $('#' + mainId + 'AutoComplete').offset({ top: tdTop, left: tdLeft });

                    /* AutoComplete width 설정 */
                    $('#' + mainId + 'AutoComplete').css('width', td.css('width'));

                    /* AutoComplete display 설정 */
                    $('#' + mainId + 'AutoComplete').show();

                    /* focus 정의 */
                    td.addClass((td.hasClass('colOn') ? '' : 'colOn'));
                    td.addClass((td.hasClass('highLight') ? '' : 'highLight'));
                    $(input).focus().select();
                },
                datepicker: function (main, uid, key) {
                    /* 사용변수 정의 */
                    var mainId = main.prop('id');
                    var td = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));
                    var span = $(td).find('span');
                    var value = span.text();

                    /* 데이터 변경 callback 호출 */
                    if (typeof $.fn.dzt.options[mainId].changeCallback === 'function') {
                        if (!$.fn.dzt.options[mainId].changeCallback(uid, key)) {
                            main.dzt('setColRemoveSelect'); /* colOn 제거 */
                            return;
                        }
                    }


                    /* td 수정 모드 확인 */
                    if (td.find('input').length > 0) { return; }

                    /* td input 생성 */
                    var input = document.createElement('input');
                    $(input).attr('type', 'text');
                    // $(input).css('ime-mode', 'active');
                    $(input).attr('id', [uid, key].join('_'));
                    $(input).attr('maxlength', 10);
                    $(input).addClass('inpTextBox');
                    $(input).val(value);

                    /* input event 생성 [ keydown : ESC / F2 / F3 / F4 / F12 / TAB / ENTER / BACKSPACE ] */
                    $(input).keydown(function () {
                        var keyCode = event.keyCode ? event.keyCode : event.which;
                        var column = fnc.getColumn(main, key);

                        switch (keyCode.toString()) {
                            case dztVars.keyMap.ArrowLeft[fnc.getWebMode()]:
                                /* 데이트피커의 단축키는 컨트롤키를 입력해야하므로, 컨트롤 키 기준으로 이벤트 분기 */
                                if (!event.ctrlKey) {
                                    /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                    /* 기본 기능 : 왼쪽 셀로 이동 */
                                    if (column.methods && column.methods['keyEvent' + 'ArrowLeft']) {
                                        if (typeof column.methods['keyEvent' + 'ArrowLeft'] == 'function') {
                                            column.methods['keyEvent' + 'ArrowLeft']();
                                        }
                                    } else {
                                        /* 기본기능 수행 */
                                        apis.event.ArrowLeft(main);
                                    }
                                    /* 기본 기능이 존재하므로 return false 처리 */
                                    return false;
                                }
                                break;
                            case dztVars.keyMap.ArrowRight[fnc.getWebMode()]:
                                /* 데이트피커의 단축키는 컨트롤키를 입력해야하므로, 컨트롤 키 기준으로 이벤트 분기 */
                                if (!event.ctrlKey) {
                                    /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                    /* 기본 기능 : 오른쪽 셀로 이동 */
                                    if (column.methods && column.methods['keyEvent' + 'ArrowRight']) {
                                        if (typeof column.methods['keyEvent' + 'ArrowRight'] == 'function') {
                                            column.methods['keyEvent' + 'ArrowRight']();
                                        }
                                    } else {
                                        /* 기본기능 수행 */
                                        apis.event.ArrowRight(main);
                                    }
                                    /* 기본 기능이 존재하므로 return false 처리 */
                                    return false;
                                }
                                break;
                            case dztVars.keyMap.ArrowUp[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 위쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowUp']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowUp'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowUp']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.ArrowDown[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 아래쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'ArrowDown']) {
                                    if (typeof column.methods['keyEvent' + 'ArrowDown'] == 'function') {
                                        column.methods['keyEvent' + 'ArrowDown']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Tab[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 기본 기능 : 오른쪽 셀로 이동 */
                                if (column.methods && column.methods['keyEvent' + 'Tab']) {
                                    if (typeof column.methods['keyEvent' + 'Tab'] == 'function') {
                                        column.methods['keyEvent' + 'Tab']();
                                    }
                                } else {
                                    /* 기본기능 수행 */
                                    apis.event.Tab(main);
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Enter[fnc.getWebMode()]:
                                /* 데이트피커가 표현되지 않은 경우에만 이동, 표현시는 데이트피커 이벤트 적용 */
                                if ($('#ui-datepicker-div').css('display') == 'none') {
                                    if ($(this).val() != '') {
                                        /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                        /* 기본 기능 : 오른쪽 셀로 이동 */
                                        if (column.methods && column.methods['keyEvent' + 'Enter']) {
                                            if (typeof column.methods['keyEvent' + 'Enter'] == 'function') {
                                                column.methods['keyEvent' + 'Enter']();
                                            }
                                        } else {
                                            /* 기본기능 수행 */
                                            apis.event.Enter(main);
                                        }
                                        /* 기본 기능이 존재하므로 return false 처리 */
                                        return false;
                                    }
                                }
                                /* 기본 기능이 존재하므로 return false 처리 */
                                return false;
                            case dztVars.keyMap.Backspace[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'Backspace']) {
                                    if (typeof column.methods['keyEvent' + 'Backspace'] == 'function') {
                                        column.methods['keyEvent' + 'Backspace']();
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.Space[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'Space']) {
                                    if (typeof column.methods['keyEvent' + 'Space'] == 'function') {
                                        column.methods['keyEvent' + 'Space']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F2[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* datepicker 위치 조정 */
                                if (column.methods && column.methods['keyEvent' + 'F2']) {
                                    if (typeof column.methods['keyEvent' + 'F2'] == 'function') {
                                        column.methods['keyEvent' + 'F2']();
                                        return false;
                                    }
                                } else {
                                    /* 기본 기능 : 데이트피커 입력 보이고, 안보이고 처리 */
                                    if ($('#ui-datepicker-div').css('display') == 'block' || $('#ui-datepicker-div').css('display') == '') {
                                        $('#ui-datepicker-div').hide();
                                    } else {
                                        $('#ui-datepicker-div').show();
                                    }
                                }

                                $(this).focus().select();
                                return false;
                            case dztVars.keyMap.F3[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F3']) {
                                    if (typeof column.methods['keyEvent' + 'F3'] == 'function') {
                                        column.methods['keyEvent' + 'F3']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F4[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F4']) {
                                    if (typeof column.methods['keyEvent' + 'F4'] == 'function') {
                                        column.methods['keyEvent' + 'F4']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.F12[fnc.getWebMode()]:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                if (column.methods && column.methods['keyEvent' + 'F12']) {
                                    if (typeof column.methods['keyEvent' + 'F12'] == 'function') {
                                        column.methods['keyEvent' + 'F12']();
                                        return false;
                                    }
                                }
                                /* 기본 기능 : 없음 */
                                break;
                            case dztVars.keyMap.Backspace[fnc.getWebMode()]:
                                /* Backspace */
                                if (column.methods && column.methods['keyEvent' + 'Backspace']) {
                                    if (typeof column.methods['keyEvent' + 'Backspace'] == 'function') {
                                        column.methods['keyEvent' + 'Backspace']();
                                    }
                                }
                                break;
                            case dztVars.keyMap.Delete[fnc.getWebMode()]:
                                /* Delete */
                                if (column.methods && column.methods['keyEvent' + 'Delete']) {
                                    if (typeof column.methods['keyEvent' + 'Delete'] == 'function') {
                                        column.methods['keyEvent' + 'Delete']();
                                    }
                                }
                                break;
                            default:
                                /* 이벤트 정의 판단 기준 : keyEvent methods 기준으로 판단 - function 판단 */
                                /* 공통코드 호출의 경우 사용자 입력이 발생되면, 연관된 코드도 초기화가 진행되어야 하므로 default를 활용할 수 있도록 구현 */
                                if (column.methods && column.methods['keyEvent' + 'Default']) {
                                    if (typeof column.methods['keyEvent' + 'Default'] == 'function') {
                                        column.methods['keyEvent' + 'Default']();
                                        // return false;
                                    }
                                }
                                break;
                        }
                    });

                    $(input).keyup(function () { this.value = fnc.getDate(this.value); });

                    /* input datepicker 설정 */
                    $(input).datepicker(dztVars.dateOptions);
                    /* datepicker 옵션 적용 */
                    if (typeof $.fn.dzt.options[mainId].configDatepicker === 'function') {
                        input = $.fn.dzt.options[mainId].configDatepicker(input, uid, key);
                    }
                    $(input).datepicker('option', 'onClose', function(){
                        if (typeof $.fn.dzt.options[mainId].configDatepickerClose === 'function') {
                            $.fn.dzt.options[mainId].configDatepickerClose(input, uid, key);
                        }
                    });
                    
                    $(input).datepicker().keydown(function (event) {
                        if (event.which === $.ui.keyCode.ENTER) {
                            // apis.event.ArrowRight(main);
                        }
                    });

                    /* td append input */
                    span.empty();
                    span.append(input);

                    /* focus 정의 */
                    td.addClass((td.hasClass('colOn') ? '' : 'colOn'));
                    td.addClass((td.hasClass('highLight') ? '' : 'highLight'));
                    $(input).focus().select();

                    /* 입력된 정보가 있는 경우에는 데이트피커를 표시하지 않는다. */
                    if ($(input).val() !== '') { $('#ui-datepicker-div').hide(); }
                },
                readonly: function (main, uid, key) {
                    /* 사용변수 정의 */
                    var mainId = main.prop('id');

                    /* 데이터 변경 callback 호출 */
                    if (typeof $.fn.dzt.options[mainId].changeCallback === 'function') {
                        if (!$.fn.dzt.options[mainId].changeCallback(uid, key)) {
                            main.dzt('setColRemoveSelect'); /* colOn 제거 */
                            return;
                        }
                    }
                }
            },
            commit: {
                text: function (main, uid, key, callback) {
                    /* 사용변수 정의 */
                    callback = (typeof callback === 'undefined' ? true : callback);
                    var mainId = main.prop('id');
                    var tr = $('#' + apis.setTable.content.getId('tr', mainId, uid));
                    var td = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));
                    var span = $(td).find('span');
                    var value = '';
                    if (span.find('input').length > 0) { value = span.find('input').val(); }
                    else { value = span.html(); }

                    /* span empty */
                    span.empty();
                    /* span text 반영 */
                    span.html(value);
                    /* data 반영 */
                    apis.setTable.update(main, uid);

                    /* 데이터 변경 callback 호출 */
                    if (callback && typeof $.fn.dzt.options[mainId].commitCallback === 'function') { $.fn.dzt.options[mainId].commitCallback(uid, key); }
                },
                combobox: function (main, uid, key, callback) {
                    /* 사용변수 정의 */
                    callback = (typeof callback === 'undefined' ? true : callback);
                    var mainId = main.prop('id');
                    var tr = $('#' + apis.setTable.content.getId('tr', mainId, uid));
                    var td = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));
                    var span = $(td).find('span');
                    var value = '';

                    if (span.find('input').length > 0) { value = span.find('input').val(); }
                    else { value = span.html(); }

                    /* span empty */
                    span.empty();
                    /* span text 반영 */
                    span.html(value);
                    /* AutoComplete 미표시 처리 */
                    var data = $('#' + mainId + 'AutoComplete ul li.on').data('value');
                    $('#' + mainId + 'AutoComplete').unbind().empty().hide();
                    /* data 반영 */
                    if (data != null) { apis.setTable.updateValue(main, uid, data); }

                    /* 데이터 변경 callback 호출 */
                    if (callback && typeof $.fn.dzt.options[mainId].commitCallback === 'function') { $.fn.dzt.options[mainId].commitCallback(uid, key); }
                },
                datepicker: function (main, uid, key, callback) {
                    /* 사용변수 정의 */
                    callback = (typeof callback === 'undefined' ? true : callback);
                    var mainId = main.prop('id');
                    var tr = $('#' + apis.setTable.content.getId('tr', mainId, uid));
                    var td = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_')));
                    var span = $(td).find('span');
                    var value = '';

                    if (span.find('input').length > 0) { value = span.find('input').val(); }
                    else { value = span.html(); }

                    /* span empty */
                    span.empty();
                    /* span text 반영 */
                    span.html(value);
                    /* data 반영 */
                    apis.setTable.update(main, uid);

                    /* 데이터 변경 callback 호출 */
                    if (callback && typeof $.fn.dzt.options[mainId].commitCallback === 'function') { $.fn.dzt.options[mainId].commitCallback(uid, key); }
                },
                readonly: function (main, uid, key) {
                    console.log('commit readonly');
                }
            },
            update: function (main, uid) {
                /* 사용변수 정의 */
                var mainId = main.prop('id');
                var tr = $('#' + apis.setTable.content.getId('tr', mainId, uid));

                /* data 반영 */
                var updateData = (tr.data([mainId, 'data'].join('_')) || {});
                $.each(tr.find('td'), function (idx, item) {
                    var updateKey = $(item).prop('id').split('_')[$(item).prop('id').split('_').length - 2];
                    if ($(item).find('span').find('input').length > 0) { updateData[updateKey] = $(item).find('span').find('input').val(); }
                    else { updateData[updateKey] = $(item).find('span').text(); }
                });
                tr.data([mainId, 'data'].join('_'), updateData);
            },
            updateValue: function (main, uid, value) {
                /* 사용변수 정의 */
                var mainId = main.prop('id');
                var tr = $('#' + apis.setTable.content.getId('tr', mainId, uid));

                /* 데이터 갱신 진행 */
                apis.setTable.update(main, uid);
                
                /* 사용자 정의 데이터 반영 */
                var updateData = (tr.data([mainId, 'data'].join('_')) || {});

                if (value !== null || value !== undefined) {
                    $.each(Object.keys(value), function (idx, key) { updateData[key] = value[key]; });
                }
                
                tr.data([mainId, 'data'].join('_'), updateData);

                /* display update */
                $.each(Object.keys(updateData), function (idx, key) {
                    var span = $('#' + apis.setTable.content.getId('td', mainId, [key, uid].join('_'))).find('span');
                    if (span) {
                        if (span.find('input').length > 0) { span.find('input').val(updateData[key]); }
                        else { span.html(updateData[key]); } /* dj 커스텀 텍스트 입력 */
                    }
                });
            }
        }
        /* ## -================================================== 외부 API ==================================================- ## */
    };

    $.fn.dzt = function (method) {
        if (typeof method === 'object' || !method) { return methods.init.apply(this, arguments); }
            /* 이벤트 수행 */
        else if (methods[method]) { return methods[method].apply(this, Array.prototype.slice.call(arguments, 1)); }
        else { $.error('Method ' + method + ' does not exist on method..'); }
    };
})(jQuery);
