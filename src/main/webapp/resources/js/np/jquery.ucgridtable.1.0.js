/* 
* =======================================================================================================================================
* UC GRID TABLE PLUG IN - 2017.06.15  TF 임헌용 연구원  
* 참고사항 :
*   1 차 수정 : 최상배 [2017-06-20]
*   1 차 완료 : 최상배 [2017-06-27]
* =======================================================================================================================================
*/

//           <!-- 그리드 생성 호출 예제 --!>

//            $("#divTestArea").GridTable({
//                'tTablename': 'tableName'      // [*] 자동 생성될 테이블 명 기준 코드 (사용자 입력)
//                , 'nTableType': 2              // [*] 테이블 타입 1. 기본 그리드, 2. 상세 보기 지원 그리드
//                , 'oPage': {                   // 사용자 페이징 정보
//                    'bPageOff': false               // 페이징 기능 감추기 여부
//                    , 'nItemSize': 10               // 페이지별 아이템 갯수
//                }
//                , 'oTotal': {                  // type 2 타이틀 정보     
//                    'nTitleCount': 3                // 소정컬럼 갯수
//                    , 'tTitle': '타이틀입니다.'     // 집계행 타이틀
//                    , 'aData': [                    // 집계행 표기 정보
//                        {                               // 집계행은 단일 행으로 사용자가 연산한뒤 해당 결과를 대입하여야 합니다.
//                        no: '0'                     // 그리드에서는 자동 집계를 지원 불가합니다.
//                            , render: '합계>'
//                    }, {
//                        no: '1'
//                            , render: '-'
//                    }, {
//                        no: '4'
//                            , render: '평균 : 2017-01-01 09:35:24'
//                    }, {
//                        no: '5'
//                    }
//                    ]
//                }
//                , 'oDetail': {                  // type 2 상세 페이지 정보
//                    'bDetailOff': false             // 상세 페이지 사용여부
//                    , 'aoHeaderInfo': [{            // 상세 페이지 테이블 헤더 정보
//                        no: '0'
//                        , renderValue: function () { // 파라미터 지원이 불가합니다.
//                            return "1번 제목";
//                        }
//                    }
//                        , {
//                            no: '1'
//                            , renderValue: '2번 제목'
//                        }]
//                    , 'aoDataRender': [{            // 상세 페이지 테이블 본문 정보
//                        no: '0',
//                        render: function (idx, item) {   // parameter idx와, item 사용이 가능합니다.
//                            return JSON.stringify(item);
//                        }
//                    }
//                        , {
//                            no: '1',
//                            render: 'column2'               // 데이터의 컬럼명 사용이 가능합니다.
//                        }]
//                }
//                , "data": resultData,               // 그리드를 구성할 실제 데이터입니다.
//                "aoHeaderInfo": [{                  // 테이블 헤더 정보입니다.
//                    no: '0',                        // 컬럼 시퀀스입니다.
//                    renderValue: function () {      // 테이블 헤더에 표현될 정보이며, 함수 혹은 텍스트 입력이 가능합니다.
//                        return "<input type='checkbox' name='checkAll' class='check2' onClick='javascript:fnCheckAll();' title='전체선택' id='checkAll' />";
//                    },
//                    colgroup: '5'
//                }, {
//                    no: '1',
//                    renderValue: "부서명",
//                    colgroup: '20'
//                }, {
//                    no: '2',
//                    renderValue: function () {
//                        return '사용자';
//                    },
//                    colgroup: '20'
//                }, {
//                    no: '3',
//                    renderValue: function () {
//                        return "출근여부";
//                    },
//                    colgroup: '20'
//                }, {
//                    no: '4',
//                    renderValue: function () {
//                        return "출근시간";
//                    },
//                    colgroup: '20'
//                }, {
//                    no: '5',
//                    renderValue: function () {
//                        return "퇴근시간";
//                    },
//                    colgroup: '20'
//                }, {
//                    no: '6',
//                    renderValue: function () {
//                        return "휴가여부";
//                    },
//                    colgroup: '20'
//                }, {
//                    no: '7',
//                    renderValue: function () {
//                        return "외근여부";
//                    },
//                    colgroup: '20'
//                }],

//                "aoDataRender": [{          // 실제 데이터 표기 방법에 대하여 지정합니다.
//                    no: '0',      // "//10.102.40.203/Web개발문서/2.2.Bizbox A/03.코딩/Views/Common/출장복명_그리드테스트/jquery.ucgridtable.1.0.js"     	
//                    render: function (idx, item) {
//                        // can use idx, item 
//                        return "<input type='checkbox' name='inp_chk' id='inp_chk" + idx + "' class=''></input>";
//                    },
//                    width: '',
//                    align: ''
//                }, {
//                    no: '1',
//                    render: 'deptNm'        // render 프로퍼티에는 동적으로 HTML을 함수로 그려주거나, data의 컬럼명을 지정가능합니다.
//                }, {
//                    no: '2',
//                    render: 'user_nm'
//                }, {
//                    no: '3',
//                    render: 'workStYN'
//                }, {
//                    no: '4',
//                    render: 'workStTime'
//                }, {
//                    no: '5',
//                    render: 'workEnTime'
//                }, {
//                    no: '6',
//                    render: 'vacationYN'
//                }, {
//                    no: '7',
//                    render: 'ExtWorkYN'
//                }]
//                , "fnRowCallBack": function (row, aData) {
//                    /* type 1 테이블 에서 사용, */
//                    /* 데이터 바인드 시점에서 로우 콜백 */
//                }
//                , "fnRowCallBackTotal": function (title, contents, aData) {
//                    /* type 2 테이블 에서 사용, */
//                    /* 총계 데이터 바인드 시점에서 로우 콜백 */
//                }
//                , "fnRowCallBackTitle": function (row, aData) {
//                    /* type 2 테이블 에서 사용, */
//                    /* 타이틀(좌) 데이터 바인드 시점에서 로우 콜백 */
//                }
//                , "fnRowCallBackContents": function (row, aData) {
//                    /* type 2 테이블 에서 사용, */
//                    /* 컨텐츠(우) 데이터 바인드 시점에서 로우 콜백 */
//                }
//                , "fnGetDetailInfo": function (param, callback) {
//                    /* type 2 디테일 테이블에서 사용 */
//                    /* [방법 1] ajax 통신이후 callback함수를 호출한다. */
//                    var result = {
//                        result: [{ 'column1': param.user_nm, 'column2': '됨??' }, { 'column1': '상배', 'column2': '됨!'}]
//                    }
//                    callback(result);
//                    /* [방법 2] ajax.success 사용-parameter에 result변수 존재 해야 함. */
//                    // ajax.success = callback;

//                }
//            });

(function ($) {
    /*  [jQuery] jquery prototype func set 'GridTable'
    ---------------------------------------------------------- */
    $.fn.GridTable = function (pJsonData) {
        console.log(' [notify] "GridTable" component start.');

        /* 그리드 옵션 널처리 진행 */
        pJsonData.tTablename = pJsonData.tTablename || 'NONE_NAME';
        pJsonData.aoaoHeaderInfo = pJsonData.aoaoHeaderInfo || [];
        pJsonData.aoDataRender = pJsonData.aoDataRender || [];
        pJsonData.nTableType = parseInt(pJsonData.nTableType) || 1;
        pJsonData.oPage = pJsonData.oPage || { 'bPageOff': true, 'nItemSize': 99999 };
        pJsonData.oPage.nItemSize = pJsonData.oPage.nItemSize || '10';
        pJsonData.oDetail = pJsonData.oDetail || {};
        pJsonData.nHeight = pJsonData.nHeight || '600';
        pJsonData.oTotal = pJsonData.oTotal || {};
        pJsonData.oTotal.aaData = pJsonData.oTotal.aaData || [];

        /* 영역 클래스 보정 */
        var agent = navigator.userAgent.toLowerCase();
        if (agent.indexOf("mac") != -1) {
            $('.rightHeader').removeClass('mr17');
            $('.ta_Header').removeClass('mr17');
        };

        /* 아이디 확인 */
        var tableArea = $(this).attr("id");
        pJsonData.divID = tableArea;
        if (!tableArea) {
            console.log(' [alert] Not found attribute "id" for DIV.');
            return;
        }

        /* 테이블 영역 생성 */
        $('#' + tableArea).empty();
        $.girdTable.create(pJsonData);

        /* 데이터 바인드 */
        $.girdTable.bind(pJsonData);

    };

    /*  [Grid management] 그리드 관리 객체 생성.
    Object name : $.gridTable
    Approach range : public
    -------------------------------------------------------- */
    $.girdTable = {

        /* 관리 테이블 생성. */
        create: function (orgnData) {
            //테이블 생성 타입 구분 
            switch (orgnData.nTableType) {
                case 1:
                	_gTable._PAGE_INDEX = 0;
                    _gTable._drawType1(orgnData);
                    if (!orgnData.oPage.bPageOff) {
                        _gTable._drawPage1(orgnData);
                    }
                    break;
                case 2:
                    _gTable._drawType2(orgnData);
                    if (!orgnData.oPage.bPageOff) {
                        _gTable._drawPage1(orgnData);
                    }
                    if (!orgnData.oDetail.bDetailOff) {
                        _gTable._drawDetail2(orgnData);
                    }
                    break;
                default:
                    console.log(' [alert] The type of table you want to work on is not checked. ');
                    break;
            }
        },

        /* 컬럼과 프로퍼티 연결. */
        bind: function (orgnData) {
            //테이블 생성 타입 구분 
            switch (orgnData.nTableType) {
                case 1:
                    // data bind
                    _gTable._bind1(orgnData);
                    break;
                case 2:
                    _gTable._bind2(orgnData);
                    _gTable._eventBind2(orgnData);
                    break;
                default:
                    console.log(' [alert] The type of table you want to work on is not checked. ');
                    break;
            }

            /* 그리드 리사이즈 */
            _gTable._resizeGrid(orgnData);
        },

        /* 관리 테이블 리셋. */
        reset: function () {
            // TODO: do reset management table
        }
    }
    
    /*  [Grid management] 그리드 관리 객체 생성.
    Object name : _gTable
    Approach range : private
    -------------------------------------------------------- */
    var _gTable = {
        /* local variable define area */
        _PAGE_INDEX: 0

        /* element make function object */
        , _elementMaker: {
            /* 전용 DIV 영역  */
            _topDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass("dal_Box");
                return elem;
            }
            , _topHeaderDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass("dal_BoxIn posi_re");
                return elem;
            }
            , _topTableDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass("posi_right");
                $(elem).css("left", "0");
                return elem;
            }
            , _headerDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass("com_ta2 rowHeight ovh rightHeader sc_head2");
                return elem;
            }
            , _headerDiv2: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass("com_ta2 rowHeight ovh rightHeader mr17");
                return elem;
            }

            , _contentDiv: function (bNoHover) {
                var elem = document.createElement("DIV");
                if (bNoHover) {
                    $(elem).addClass("hover_no com_ta2 rowHeight ova_sc2 bg_lightgray rightContents");
                } else {
                    $(elem).addClass("com_ta2 rowHeight ova_sc2 bg_lightgray rightContents");
                }
                $(elem).attr('onscroll', 'dalBoxScroll()');
                return elem;
            }
            , _pagingTopDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass('gt_paging');
                $(elem).addClass('mt20');
                return elem;
            }
            , _pagingDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass('gt_count');
                return elem;
            }
            , _countDiv: function () {
                var elem = document.createElement("DIV");
                $(elem).addClass('paging');
                return elem;
            }

            /* HTML 기본 테그 지원 */
            , _table: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("TABLE"), prop);
            }
            , _thead: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("THEAD"), prop);
            }
            , _colGroup: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("COLGROUP"), prop);
            }
            , _col: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("COL"), prop);
            }
            , _th: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("TH"), prop);
            }
            , _tbody: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("TBODY"), prop);
            }
            , _tr: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("TR"), prop);
            }
            , _td: function (prop) {
                prop.title = prop.AUTO_TITLE = true;
                return this._CUSTOM_ELEM(document.createElement("TD"), prop);
            }
            , _span: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("SPAN"), prop);
            }
            , _a: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("A"), prop);
            }
            , _ol: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("OL"), prop);
            }
            , _li: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("LI"), prop);
            }
            , _select: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("SELECT"), prop);
            }
            , _option: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("OPTION"), prop);
            }
            , _div: function (prop) {
                return this._CUSTOM_ELEM(document.createElement("DIV"), prop);
            }


            /*  [CUSTOM_ELEM] 엘리먼트 거스터마이즈 진행
            --------------------------------------------------- */
            , _CUSTOM_ELEM: function (elem, prop) {
                prop = prop || {};
                prop.item = prop.item || {};
                prop.aData = prop.aData || {};

                if (prop.href) {
                    $(elem).attr('href', prop.href);
                } if (prop.html) {
                    $(elem).html(prop.html);
                } if (prop.class) {
                    $(elem).addClass(prop.class);
                } if (prop.item.width) {
                    $(elem).css('width', prop.item.width);
                } if (prop.width) {
                    $(elem).css('width', prop.width);
                } if (prop.item.height) {
                    $(elem).css('height', prop.item.height);
                } if (prop.height) {
                    $(elem).css('height', prop.height);
                } if (prop.item.align) {
                    $(elem).attr('align', prop.item.align);
                } if (prop.item.style) {
                    $(elem).prop('style', prop.item.style);
                }
                if (prop.width) {
                    $(elem).css('width', prop.item.width);
                } if (prop.align) {
                    $(elem).attr('align', prop.item.align);
                } if (prop.id) {
                    $(elem).attr('id', prop.id);
                } if (prop.colgroup) {
                    $(elem).attr('width', prop.colgroup);
                } if (prop.display) {
                    $(elem).css('display', prop.display);
                } if (prop.value) {
                    $(elem).attr('value', prop.value);
                } if (prop.selected) {
                    $(elem).attr('selected', prop.selected);
                } if (prop.style) {
                    $(elem).prop('style', prop.style);
                } if (prop.onScroll) {
                    $(elem).scroll(prop.onScroll);
                } if (prop.title) {
                    $(elem).attr('title', prop.title);
                } if (prop.onclick) {
                    if (typeof prop.onclick == 'function') {
                        $(elem).click(prop.onclick);
                    }
                } if (prop.item) {
                    $(elem).attr('item', JSON.stringify(prop.item));
                } if (prop.colspan) {
                    $(elem).attr('colspan', prop.colspan);
                } if (prop.rowspan) {
                    $(elem).attr('rowspan', prop.rowspan);
                } if (prop.colspan) {
                    $(elem).attr('colspan', prop.colspan);
                }


                if (prop.item) {
                    $(elem).prop('item', prop.item);
                } if (prop.item.render && (typeof prop.item.render == 'function')) {
                    $(elem).html(prop.item.render(prop.idx, prop.aData));
                } if (prop.item.render && (typeof prop.item.render != 'function')) {
                    $(elem).html(prop.aData[prop.item.render]);
                } if (prop.renderValue && (typeof prop.renderValue == 'function')) {
                    $(elem).html(prop.renderValue(prop.idx, prop.aData));
                } if (prop.renderValue && (typeof prop.renderValue != 'function')) {
                    $(elem).html(prop.renderValue);
                } if (prop.render && (typeof prop.render == 'function')) {
                    $(elem).html(prop.render(prop.idx, prop.aData));
                } if (prop.render && (typeof prop.render != 'function')) {
                    $(elem).html(prop.render);
                }
                if (prop.AUTO_TITLE) {
                    if (prop.item.render && (typeof prop.item.render == 'function')) {
                        $(elem).attr('title', $(elem).title || ( prop.item.render(prop.idx, prop.aData) || '' ).toString().replace(/(<([^>]+)>)/ig, ""));
                    } if (prop.item.render && (typeof prop.item.render != 'function')) {
                        $(elem).attr('title', $(elem).title || ( prop.aData[prop.item.render] || '' ).toString().replace(/(<([^>]+)>)/ig, ""));
                    } if (prop.renderValue && (typeof prop.renderValue == 'function')) {
                        $(elem).attr('title', $(elem).title || ( prop.renderValue(prop.idx, prop.aData) || '' ).toString().replace(/(<([^>]+)>)/ig, ""));
                    } if (prop.renderValue && (typeof prop.renderValue != 'function')) {
                        $(elem).attr('title', $(elem).title || ( prop.renderValue || '' ).toString().replace(/(<([^>]+)>)/ig, ""));
                    } if (prop.render && (typeof prop.render == 'function')) {
                        $(elem).attr('title', $(elem).title || ( prop.render(prop.idx, prop.aData) || '' ).toString().replace(/(<([^>]+)>)/ig, ""));
                    } if (prop.render && (typeof prop.render != 'function')) {
                        $(elem).attr('title', $(elem).title || ( prop.render || '' ).toString().replace(/(<([^>]+)>)/ig, ""));
                    }
                }
                return elem;
            }
        }

        /*  [공용함수] no 값을 이용하여 객체 찾기.
        -------------------------------------------------- */
        , _getItemForNo: function (list, no) {
            var item = {};
            var length = list.length;
            for (var i = 0; i < length; i++) {
                var item = list[i];
                if (item.no == no) {
                    return item;
                }
            }
            return {};
        }

        /*  [type2] 2타입 그리드 생성
        -------------------------------------------------- */
        , _drawType2: function (orgnData) {

            /* [+] 1. 작업영역 클래스 보정 */
            $('#' + orgnData.divID).addClass('dal_Box');
            var dalBoxDiv = this._elementMaker._div({ 'class': 'dal_BoxIn posi_re' });
            /* [-] 1. 작업영역 클래스 보정 */



            /* [+] 2. 좌우측 테이블 영역 설정 */
            var titleSize = orgnData.nTitleSize || '300';
            var divLeft = this._elementMaker._div({ 'class': 'posi_left', 'style': 'width:' + titleSize + 'px;' });
            var divRight = this._elementMaker._div({ 'class': 'posi_right', 'style': 'left:' + titleSize + 'px;' });
            /* [-] 2. 좌우측 테이블 영역 설정 */



            /* [+] 3-1. 좌측 타이틀 헤더 설정 */
            var leftTableHeader = this._elementMaker._div({ 'class': 'com_ta2 rowHeight ovh leftHeader borderR' });
            var titleHeadTable = this._elementMaker._table();
            var titleHeadColgroup = this._elementMaker._colGroup();
            var titleHeadThead = this._elementMaker._thead();
            var titleHeadTr = this._elementMaker._tr();
            var lLength = orgnData.nTitleCount || '1';
            for (var i = 0; i < lLength; i++) {
                var item = orgnData.aoHeaderInfo[i];
                titleHeadTr.appendChild(this._elementMaker._th(item));
                item.renderValue = '';
                titleHeadColgroup.appendChild(this._elementMaker._col(item));
            }
            titleHeadTable.appendChild(titleHeadColgroup);
            titleHeadThead.appendChild(titleHeadTr);
            titleHeadTable.appendChild(titleHeadThead);
            leftTableHeader.appendChild(titleHeadTable);
            divLeft.appendChild(leftTableHeader);
            /* [-] 3-1. 좌측 타이틀 헤더 설정 */



            /* [+] 3-2. 우측 콘텐츠 헤더 설정 */
            var rightTableHeader = this._elementMaker._div({ 'class': 'com_ta2 rowHeight hover_no ovh rightHeader mr17' });
            var contentsHeadTable = this._elementMaker._table();
            var contentsHeadColgroup = this._elementMaker._colGroup();
            var contentsHeadThead = this._elementMaker._thead();
            var contentsHeadTr = this._elementMaker._tr();
            var rLength = orgnData.nTitleCount || '1';
            for (var i = rLength; i < orgnData.aoHeaderInfo.length; i++) {
                var item = orgnData.aoHeaderInfo[i];
                contentsHeadTr.appendChild(this._elementMaker._th(item));
                item.renderValue = '';
                contentsHeadColgroup.appendChild(this._elementMaker._col(item));
            }
            contentsHeadTable.appendChild(contentsHeadColgroup);
            contentsHeadThead.appendChild(contentsHeadTr);
            console.log(contentsHeadThead);


            contentsHeadTable.appendChild(contentsHeadThead);
            rightTableHeader.appendChild(contentsHeadTable);
            divRight.appendChild(rightTableHeader);
            /* [-] 3-2. 우측 콘텐츠 헤더 설정 */


            /* [+] 4-1 좌측 타이틀 본문 설정 */
            var leftTableContents = this._elementMaker._div({ 'class': 'com_ta2 rowHeight cursor_p ova_sc2 bg_lightgray ovh leftContents' });
            var titleContentsTable = this._elementMaker._table();
            var titleContentsColgroup = this._elementMaker._colGroup();
            var titleContentsTbody = this._elementMaker._tbody({ 'id': orgnData.tTablename + '_titleContents' });
            for (var i = 0; i < lLength; i++) {
                var item = orgnData.aoHeaderInfo[i];
                item.renderValue = '';
                titleContentsColgroup.appendChild(this._elementMaker._col(item));
            }
            titleContentsTable.appendChild(titleContentsColgroup);
            titleContentsTable.appendChild(titleContentsTbody);
            leftTableContents.appendChild(titleContentsTable);
            divLeft.appendChild(leftTableContents);
            /* [-] 4-1 좌측 타이틀 본문 설정 */



            /* [+] 4-2 우측 콘텐츠 본문 설정 */
            var rightTableContents = this._elementMaker._div({ 'class': 'com_ta2 rowHeight ova_sc2 hover_no bg_lightgray rightContents', 'onScroll': dalBoxScroll });
            var contentsContentsTable = this._elementMaker._table();
            var contentsContentsColgroup = this._elementMaker._colGroup();
            var contentsContentsTbody = this._elementMaker._tbody({ 'id': orgnData.tTablename + '_contentsContents' });
            for (var i = rLength; i < orgnData.aoHeaderInfo.length; i++) {
                var item = orgnData.aoHeaderInfo[i];
                item.renderValue = '';
                contentsContentsColgroup.appendChild(this._elementMaker._col(item));
            }
            contentsContentsTable.appendChild(contentsContentsColgroup);
            contentsContentsTable.appendChild(contentsContentsTbody);
            rightTableContents.appendChild(contentsContentsTable);
            divRight.appendChild(rightTableContents);
            /* [-] 4-2 우측 콘텐츠 본문 설정 */



            /* [+] 좌우측 영역 조합및 출력 */
            dalBoxDiv.appendChild(divLeft);
            dalBoxDiv.appendChild(divRight);
            $("#" + orgnData.divID).append(dalBoxDiv);



            return;
            /* [-] 좌우측 영역 조합및 출력 */
        }

        /*  [type2] 디테일 영역 그리기
        -------------------------------------------------- */
        , _drawDetail2: function (orgnData) {

            /* 상세 테이블 영역 생성 */
            var detailDiv = this._elementMaker._div({ 'class': 'dal_Box_detail' });

            /* [+] 상단 커스터마이징 영역 생성 */
            var customDiv = this._elementMaker._div({ 'class': 'btn_div' });
            var rightDiv = this._elementMaker._div({ 'class': 'right_div' });
            var a_class = orgnData.customDetail ? 'close' : 'close posi_re';

            var customDivSpace = this._elementMaker._div({ 'id': 'DivCustom_' + orgnData.divID });
            /* 커스텀 영역 옮기기 */
            if (orgnData.oDetail.tCustomDiv) {
                var customHtml = $('#' + orgnData.oDetail.tCustomDiv).show().html();
                $('#' + orgnData.oDetail.tCustomDiv).remove();
                $(customDiv).html(customHtml);
            }
            rightDiv.appendChild(customDivSpace);

            var closeBtn = this._elementMaker._a({ 'class': a_class, 'style': 'height:30px', 'onclick': dal_Box_detail });
            if (!orgnData.oDetail.noUseDetailClose) {
                rightDiv.appendChild(closeBtn);
            }
            customDiv.appendChild(rightDiv);
            detailDiv.appendChild(customDiv);
            /* [-] 상단 커스터마이징 영역 생성 */


            /* [+] 상세 테이블 영역 생성 */
            var dalboxDiv = this._elementMaker._div({ 'class': 'dal_Box_detail_in', 'id': 'divDetailDalBox' });
            detailDiv.appendChild(dalboxDiv);

            if ($('.gt_paging').length) {
                /* 페이징 영역이 있는 경우. */
                $(detailDiv).insertAfter('.gt_paging');
            } else {
                /* 페이징 영역이 없는 경우. */
                $(detailDiv).insertAfter('#' + orgnData.divID);
            }

            return;
        }

        /*  [type2] 2타입 데이터 바인드
        -------------------------------------------------- */
        , _bind2: function (orgnData) {
            /* [+] 로컬 변수 정의 */
            var dataLength = orgnData.data.length;
            var length = orgnData.aoDataRender.length;
            var lLength = orgnData.nTitleCount;
            /* [-] 로컬 변수 정의 */

            /* [+] TOTAL 영역 데이터 바인드 */
            if (orgnData.oTotal) {


                for (var totalIdx = 0; totalIdx < orgnData.oTotal.aaData.length; totalIdx++) {
                    var aData = orgnData.oTotal.aaData[totalIdx];

                    var totalTitleTr = this._elementMaker._tr({ 'class': 'total', 'title': orgnData.oTotal.tTitle });
                    var totalContentsTr = this._elementMaker._tr({ 'class': 'total', 'title': orgnData.oTotal.tTitle });
                    var rLength = orgnData.aoHeaderInfo.length;

                    for (var i = 0; i < lLength; i++) {
                        var prop = this._getItemForNo(aData, i);
                        i += ((prop.colspan - 1) || 0);

                        /*마지막 td 클래스 처리*/
                        if (i == lLength - 1) {
                            prop.class += ' borderR';
                        }
                        totalTitleTr.appendChild(this._elementMaker._td(prop));
                    }
                    for (var i = lLength; i < rLength; i++) {
                        var prop = this._getItemForNo(aData, i);
                        i += ((prop.colspan - 1) || 0);
                        totalContentsTr.appendChild(this._elementMaker._td(prop));
                    }

                    $('#' + orgnData.tTablename + '_titleContents').append(totalTitleTr);
                    $('#' + orgnData.tTablename + '_contentsContents').append(totalContentsTr);
                }

                /* 총계 영역 콜백이 있는경우 */
                if (orgnData.fnRowCallBackTotal) {
                    orgnData.fnRowCallBackTotal(totalTitleTr, totalContentsTr, orgnData.oTotal);
                }
            }


            /* [-] TOTAL 영역 데이터 바인드 */

            var dataStartIdx = 0;
            var dataEndIdx = 0;
            if (!orgnData.oPage.bPageOff) {
                dataStartIdx = this._PAGE_INDEX * orgnData.oPage.nItemSize;
                dataEndIdx = dataStartIdx + orgnData.oPage.nItemSize > orgnData.data.length ? orgnData.data.length : dataStartIdx + orgnData.oPage.nItemSize;
            } else {
                dataStartIdx = 0;
                dataEndIdx = orgnData.data.length;
            }

            /* [+] title 영역 데이터 바인드 */
            for (var dataIdx = dataStartIdx; dataIdx < dataEndIdx; dataIdx++) {
                var aData = orgnData.data[dataIdx];
                var nTR = this._elementMaker._tr({ 'item': aData });
                for (var i = 0; i < lLength; i++) {
                    var item = orgnData.aoDataRender[i];
                    var txtClass = item['class'] || '';
                    /*마지막 td 클래스 처리*/
                    if (item.colgroup) {
                        txtClass += ' ellipsis';
                    }
                    if (i == lLength - 1) {
                        txtClass += ' borderR';
                    }
                    /* TR 내부 td 생성. */
                    var nTD = this._elementMaker._td({ 'item': item, 'aData': aData, 'idx': dataIdx, 'class': txtClass, 'colgroup': item.colgroup });
                    nTR.appendChild(nTD);
                }
                $("#" + orgnData.tTablename + "_titleContents").append(nTR);

                /* 타이틀 영역 콜백이 있는경우 */
                if (orgnData.fnRowCallBackTitle) {
                    orgnData.fnRowCallBackTitle(nTR, aData);
                }
            }
            /* [-] title 영역 데이터 바인드 */



            /* [+] contents 영역 데이터 바인드 */
            for (var dataIdx = dataStartIdx; dataIdx < dataEndIdx; dataIdx++) {
                var aData = orgnData.data[dataIdx];
                var nTR = this._elementMaker._tr({ 'item': aData });
                for (var i = lLength; i < length; i++) {
                    var item = orgnData.aoDataRender[i];
                    var txtClass = item['class'] || '';
                    if (item.colgroup) {
                        txtClass += ' ellipsis';
                    }
                    /* TR 내부 td 생성. */
                    var nTD = this._elementMaker._td({ 'item': item, 'aData': aData, 'idx': dataIdx, 'class': txtClass, 'colgroup': item.colgroup });
                    nTR.appendChild(nTD);
                }
                $("#" + orgnData.tTablename + "_contentsContents").append(nTR);

                /* 컨텐츠 영역 콜백이 있는경우 */
                if (orgnData.fnRowCallBackContents) {
                    orgnData.fnRowCallBackContents(nTR, aData);
                }
            }
            /* [-] contents 영역 데이터 바인드 */


            /* 테이블 생성 콜백 실행 */
            if (orgnData.fnTableDraw) {
                orgnData.fnTableDraw();
            }

            return;
        }

        /*  [type2] 2타입 테이블 이벤트 바인드
        -------------------------------------------------- */
        , _eventBind2: function (orgnData) {

            /* 마우스 스크롤링 테이블 동기화 */
            var num = 0;
            $('.dal_BoxIn .leftContents').unbind().on('mousewheel DOMMouseScroll', function (e) {
                if (e.originalEvent.wheelDelta > 0 || e.originalEvent.detail < 0) {
                    var rightConScVal = $(".dal_BoxIn .rightContents").scrollTop();
                    if (num < rightConScVal) {
                        return false;
                    } else {
                        num -= 120;
                        $(".dal_BoxIn .rightContents").scrollTop(num);
                    };
                } else {
                    var rightConScVal = $(".dal_BoxIn .rightContents").scrollTop();
                    if (num > rightConScVal) {
                        return false;
                    } else {
                        num += 120;
                        $(".dal_BoxIn .rightContents").scrollTop(num);
                    };
                };
            });

            //리스트 클릭: 상세현황 도출
            $(".posi_left table td").on("click", function () {
                if ($(this).parent().hasClass('on')) {
                    $(this).parent().removeClass('on', function () {
                        //한번 클릭한 리스트 재클릭시 팝업닫기
                        dal_Box_detail();
                    });
                } else {
                    //리스트 클릭시 상세팝업 애니메이션 보여주기
                    var $DALBD = $(".dal_Box_detail");
                    $DALBD.removeClass("animated05s fadeOutRight").addClass("animated05s fadeInRight").show();
                    $(this).parent().siblings().removeClass('on');
                    $(this).parent().addClass("on");
                    //리스트 클릭시 상세팝업 사이즈 계산
                    var subHei = $('.sub_contents').height();
                    var btnDivHei = $('.dal_Box_detail .btn_div').height();
                    var dalHei = subHei - 200;
                    $('.dal_Box_detail .ta_Contents').height(dalHei - btnDivHei - 22);
                    $('.dal_Box_detail .ta_Contents2').height(dalHei - btnDivHei - 59);

                    /* 상세 정보 조회 */
                    orgnData.fnGetDetailInfo(JSON.parse($(this).parent('tr').attr('item')), function (data) {
                        if (!data.result) {
                            alert('조회중 에러가 발생하였습니다. ');
                            console.log(' [error] not found PARAMETER.result in "fnGetDetailInfo" ');
                            return;
                        }
                        $('#divDetailDalBox>.dal_Box').remove();
                        $('#divDetailDalBox').GridTable({
                            'tTablename': orgnData.tTablename + '_detailTable'
                            , 'nTableType': 1
                            , 'nHeight': orgnData.nHeigth - 25
                            , 'data': data.result
                            , 'aoHeaderInfo': JSON.parse(JSON.stringify( orgnData.oDetail.aoHeaderInfo))
                            , 'aoDataRender': orgnData.oDetail.aoDataRender
                            , 'oTotal': data.oTotal
                            , 'bNoHover': true
                            , 'aoAutoMerge': orgnData.oDetail.aoAutoMerge
                        });
                    });
                }
            });
            return;
        }
        

        /*  [type1] 1타입 그리드 생성
        -------------------------------------------------- */
        , _drawType1: function (orgnData) {
            var nTopDiv = this._elementMaker._topDiv();
            var nTopHeaderDiv = this._elementMaker._topHeaderDiv();
            var nTopTableDiv = this._elementMaker._topTableDiv();


            /******[+] 1. 헤더 테이블 영역 생성 시작. ******/
            var nHeaderDiv
            if (orgnData.aoAdvHeaderInfo) {
                nHeaderDiv = this._elementMaker._headerDiv();
            } else {
                nHeaderDiv = this._elementMaker._headerDiv2();
            }
            var nHeaderTable = this._elementMaker._table();
            var nHeaderColgroup = this._elementMaker._colGroup();

            /* 1-2. 헤더 colGroup/Tr 생성. */
            var length = orgnData.aoHeaderInfo.length;
            var nThead = this._elementMaker._thead();
            var nTR = this._elementMaker._tr();
            var nAdvTR = this._elementMaker._tr();

            var orgnAoHeaderInfo = JSON.parse(JSON.stringify(orgnData.aoHeaderInfo));
            for (var i = 0; i < length; i++) {
                var item = orgnData.aoHeaderInfo[i];
                /* tr 내부 th 생성. */
                nTR.appendChild(this._elementMaker._th(item));
                /* colgroup 내부 col 생성. */
                item.renderValue = '';
                nHeaderColgroup.appendChild(this._elementMaker._col(item));
            }
            orgnData.aoHeaderInfo = orgnAoHeaderInfo;
            /* 확장 TR 생성 */
            if (orgnData.aoAdvHeaderInfo) {
                for (var i = 0; i < orgnData.aoAdvHeaderInfo.length; i++) {
                    var item = orgnData.aoAdvHeaderInfo[i];
                    nAdvTR.appendChild(this._elementMaker._th(item));
                }
            }

            /* 1-3. 엘리먼트 조합 */
            nHeaderTable.appendChild(nHeaderColgroup);
            nThead.appendChild(nAdvTR);
            nThead.appendChild(nTR);

            nHeaderTable.appendChild(nThead);
            nHeaderDiv.appendChild(nHeaderTable);
            if (orgnData.fnTitleCallBack) {
                orgnData.fnTitleCallBack(nTR, orgnData.aoHeaderInfo);
            }
            /******[-] 1. 헤더 테이블 영역 생성 완료. ******/



            /******[+] 2. 컨텐츠 테이블 영역 생성 시작 ******/
            var nContentDiv = this._elementMaker._contentDiv(orgnData.bNoHover);
            var nContentTable = this._elementMaker._table();
            var nContentColgroup = this._elementMaker._colGroup();
            var orgnAoHeader = JSON.parse(JSON.stringify(orgnData.aoHeaderInfo));

            /* 2-2. 컨텐츠 colGroup 생성. */
            nContentTable.appendChild(nContentColgroup);
            for (var i = 0; i < length; i++) {
                var item = null;
                if (!orgnData.aoAdvHeaderInfo) {
                    item = orgnData.aoHeaderInfo[i];
                } else {
                    item = orgnData.aoDataRender[i];
                }
                /* colgroup 내부 col 생성. */
                item.renderValue = '';
                nContentColgroup.appendChild(this._elementMaker._col(item));
            }

            /* 2-3. 엘리먼트 조합. */
            nContentTable.appendChild(nContentColgroup);
            nContentTable.appendChild(this._elementMaker._tbody({ 'id': orgnData.tTablename + '_contents' }));
            nContentDiv.appendChild(nContentTable);
            /******[-] 2. 컨텐츠 테이블 영역 생성 완료 ******/


            

            /******[+] 3. 헤더 컨텐츠 영역 생성 시작 ******/
            nTopTableDiv.appendChild(nHeaderDiv);
            nTopTableDiv.appendChild(nContentDiv);
            nTopHeaderDiv.appendChild(nTopTableDiv);
            nTopDiv.appendChild(nTopHeaderDiv);
            /******[-] 3. 헤더 컨텐츠 영역 생성 완료 ******/


            /* 컨텐츠 적용 */
            $("#" + orgnData.divID).append(nTopDiv);


            return;

        }

        /*  [type1] 페이징 영역 그리기
        -------------------------------------------------- */
        , _drawPage1: function (orgnData) {

            /* 페이징 영역 시작 */
            var pagingTopDiv = this._elementMaker._pagingTopDiv();
            var pagingDiv = this._elementMaker._pagingDiv();
            var pagingContentDiv = this._elementMaker._countDiv();

            /* [<<] 버튼 구성 */
            var prepreSpan = this._elementMaker._span({ 'class': 'pre_pre' });
            var pre10A = this._elementMaker._a({ 'html': '10페이지 전', 'href': '#', 'class': 'ol_elem_paging', 'value': 'prepre' });
            prepreSpan.appendChild(pre10A);
            pagingContentDiv.appendChild(prepreSpan);

            /* [<] 버튼 구성 */
            var preSpan = this._elementMaker._span({ 'class': 'pre', 'style': 'margin-left:4px;' });
            var preA = this._elementMaker._a({ 'html': '이전', 'href': '#', 'class': 'ol_elem_paging', 'value': 'pre' });
            preSpan.appendChild(preA);
            pagingContentDiv.appendChild(preSpan);

            /* [OL] 구성 */
            var pagingOL = this._elementMaker._ol({ 'id': 'olPageNum', 'class': '', 'value': (i + 1) });
            var totalPage = parseInt((orgnData.data.length - 1) / orgnData.oPage.nItemSize) + 1;
            var startIndex = parseInt(this._PAGE_INDEX / 10) * 10;
            var endIndex = (startIndex + 10) > totalPage ? totalPage : (startIndex + 10);

            for (var i = startIndex; i < endIndex; i++) {
                var pagingLi = this._elementMaker._li({ 'class': 'ol_elem_paging ' + (i == this._PAGE_INDEX ? 'on' : ''), 'id': 'ol_elem_paging' + i, 'value': (i + 1) });
                var pagingA = this._elementMaker._a({ 'html': (i + 1), 'href': '#' });
                pagingLi.appendChild(pagingA);
                pagingOL.appendChild(pagingLi);
            }
            pagingContentDiv.appendChild(pagingOL)

            /* [>] 버튼 구성 */
            var nextSpan = this._elementMaker._span({ 'class': 'nex', 'style': 'margin-right:4px;' });
            var nextA = this._elementMaker._a({ 'html': '다음', 'href': '#', 'class': 'ol_elem_paging', 'value': 'nex' });
            nextSpan.appendChild(nextA);
            pagingContentDiv.appendChild(nextSpan);

            /* [>>] 버튼 구성 */
            var nextnextSpan = this._elementMaker._span({ 'class': 'nex_nex' });
            var nextnextA = this._elementMaker._a({ 'html': '10페이지 다음', 'href': '#', 'class': 'ol_elem_paging', 'value': 'nexnex' });
            nextnextSpan.appendChild(nextnextA);
            pagingContentDiv.appendChild(nextnextSpan);

            /* 카운트 영역 구성 */
            var selector = orgnData.oPage.anPageSelector || [10, 25, 50, 100];
            var menuUpSelect = this._elementMaker._select({ 'id': orgnData.divID + '_selectMenu', 'class': 'selectmenu up', 'width': '50px' });
            for (var i = 0; i < selector.length; i++) {
                var item = parseInt(selector[i]);
                var selectOption;
                if (isNaN(item)) {
                    console.log(' [error] Not a number  - GridTable.oPage.anPageSelector / index : ' + i + ' / value : ' + selector[i]);
                }
                if (selector[i] == orgnData.oPage.nItemSize) {
                    selectOption = this._elementMaker._option({ 'value': item, 'selected': 'selected', 'html': item });
                } else {
                    selectOption = this._elementMaker._option({ 'value': item, 'html': item });
                }
                menuUpSelect.appendChild(selectOption);
            }
            var countDiv = this._elementMaker._countDiv();
            countDiv.appendChild(menuUpSelect);

            /* 페이징, 카운트 셀렉트 영역 적용 */
            pagingTopDiv.appendChild(pagingContentDiv);
            pagingTopDiv.appendChild(countDiv);


            /* 영역 구성 완료. */
            $(pagingTopDiv).insertAfter("#" + orgnData.divID);

            /* 페이지 버튼 이벤트 바인드 */
            $('.ol_elem_paging').unbind().click(function () {
                _gTable._setPage(orgnData, $(this).attr('value'));
            });

            $('#' + orgnData.divID + '_selectMenu').unbind().change(function () {
                console.log($('#' + orgnData.divID + '_selectMenu' + " option:selected").length);
                $('#' + orgnData.divID + '_selectMenu' + " option:selected").each(function () {
                    orgnData.oPage.nItemSize = parseInt($(this).text());
                    _gTable._setPage(orgnData, 0);
                });
            });
            return;
        }
        , _setPage: function (orgnData, pageIndex) {
            /* 페이지 인덱스에 따른 동작 구분 설정 */
            var orgnPageIndex = this._PAGE_INDEX;
            if (pageIndex == 'prepre') {
                this._PAGE_INDEX = (this._PAGE_INDEX - 10) < 0 ? 0 : (this._PAGE_INDEX - 10);
            } else if (pageIndex == 'pre') {
                this._PAGE_INDEX = (this._PAGE_INDEX - 1) < 0 ? 0 : (this._PAGE_INDEX - 1);
            } else if (pageIndex == 'nex') {
                var maxSize = parseInt((orgnData.data.length - 1) / orgnData.oPage.nItemSize);
                this._PAGE_INDEX = (this._PAGE_INDEX + 1) > maxSize ? maxSize : (this._PAGE_INDEX + 1);
            } else if (pageIndex == 'nexnex') {
                var maxSize = parseInt((orgnData.data.length - 1) / orgnData.oPage.nItemSize);
                this._PAGE_INDEX = (this._PAGE_INDEX + 10) > maxSize ? maxSize : (this._PAGE_INDEX + 10);
            } else {
                this._PAGE_INDEX = parseInt(pageIndex || '1') - 1;
            }

            /* 페이지 텍스트 재 설정 */
            $('.ol_elem_paging>a').each(function () {
                var flag = parseInt(orgnPageIndex / 10) - parseInt(_gTable._PAGE_INDEX / 10);
                if (flag > 0) {
                    $(this).html(parseInt($(this).html()) - 10);
                } else if (flag < 0) {
                    $(this).html(parseInt($(this).html()) + 10);
                }
                $(this).parent().attr('id', 'ol_elem_paging' + parseInt($(this).html() - 1));
                $(this).parent().attr('value', $(this).html());

                var totalPage = parseInt((orgnData.data.length - 1) / orgnData.oPage.nItemSize) + 1;
                if (parseInt($(this).html()) > totalPage) {
                    $(this).parent().hide();
                } else {
                    $(this).parent().show();
                }
            });

            /* 선택 액션 */
            $('.ol_elem_paging').removeClass('on');
            $('#ol_elem_paging' + this._PAGE_INDEX).addClass('on');

            if (orgnData.nTableType == 1) {
                /* type 1 초기화 */
                $("#" + orgnData.tTablename + "_contents>tr").remove();
                this._bind1(orgnData);
            } else if (orgnData.nTableType == 2) {
                /* type 2 초기화 */
                $("#" + orgnData.tTablename + "_titleContents>tr").remove();
                $("#" + orgnData.tTablename + "_contentsContents>tr").remove();
                this._bind2(orgnData);
                this._eventBind2(orgnData);
            }
            return;
        }

        /*  [type1] 1타입 데이터 바인드
        -------------------------------------------------- */
        , _bind1: function (orgnData) {
            var dataLength = orgnData.data.length;
            var length = orgnData.aoDataRender.length;

            /* 데이터 범위 확인 */
            var dataStartIdx = 0;
            var dataEndIdx = 0;
            var nItemSize = parseInt(orgnData.oPage.nItemSize); // dataEndIdx 생성 시 숫자형 + 문자형 = 문자형 반환되어 nItemSize 숫자형으로 변환
            if (!orgnData.oPage.bPageOff) {
                dataStartIdx = this._PAGE_INDEX * nItemSize;
                dataEndIdx = dataStartIdx + nItemSize > orgnData.data.length ? orgnData.data.length : dataStartIdx + nItemSize;
            } else {
                dataStartIdx = 0;
                dataEndIdx = orgnData.data.length;
            }

            /* 데이터가 없는 경우. */
            if (orgnData.data.length == 0 && orgnData.oNoData) {
                var nTR = this._elementMaker._tr();
                var nTD = this._elementMaker._td({ 'colspan': orgnData.aoHeaderInfo.length, 'html': orgnData.oNoData.tText, 'style': orgnData.oNoData.tStyle });
                nTR.appendChild(nTD);
                $("#" + orgnData.tTablename + "_contents").append(nTR);
            }

            /* 집계 행 생성 */
            if (orgnData.oTotal) {
                for (var totalIdx = 0; totalIdx < orgnData.oTotal.aaData.length; totalIdx++) {
                    var aData = orgnData.oTotal.aaData[totalIdx];
                    var totalTr = this._elementMaker._tr({ 'class': 'total', 'title': orgnData.oTotal.tTitle });
                    for (var i = 0; i < length; i++) {
                        var prop = this._getItemForNo(aData, i);
                        i += ((prop.colspan - 1) || 0);
                        totalTr.appendChild(this._elementMaker._td(prop));
                    }
                    $('#' + orgnData.tTablename + '_contents').append(totalTr);
                    /* 총계 영역 콜백이 있는경우 */
                    if (orgnData.fnRowCallBackTotal) {
                        orgnData.fnRowCallBackTotal(totalTr, totalTr, orgnData.oTotal);
                    }
                }
            }


            /* 실제 데이터 바인드 */
            for (var dataIdx = dataStartIdx; dataIdx < dataEndIdx; dataIdx++) {
                var aData = orgnData.data[dataIdx];
                var nTR = this._elementMaker._tr({ 'item': aData, 'class': aData.RENDER_CLASS });
                for (var i = 0; i < length; i++) {
                    var item = orgnData.aoDataRender[i];
                    var txtClass = item['class'];
                    if (item.colgroup) {
                        txtClass += ' ellipsis';
                    }
                    /* TR 내부 td 생성. */
                    var nTD = this._elementMaker._td({ 'item': item, 'aData': aData, 'idx': dataIdx, 'class': txtClass });
                    nTR.appendChild(nTD);
                }
                /* nRow callback. */
                if (orgnData.fnRowCallBack) {
                    orgnData.fnRowCallBack(nTR, aData);
                }

                $("#" + orgnData.tTablename + "_contents").append(nTR);
            }

            /* 테이블 생성 콜백 실행 */
            if (orgnData.fnTableDraw) {
                orgnData.fnTableDraw();
            }

            // auto merge
            if (orgnData.aoAutoMerge) {
                _gTable._mergeTr(orgnData);
            }

            return;
        }
        /*  [type1] 공용 셀 병합
        -------------------------------------------------- */
        , _mergeTr: function (orgnData) {
            var mergeinfo = orgnData.aoAutoMerge;

            mergeinfo.sort(function (a, b) {
                //                var isIE = false || !!document.documentMode;
                //                var isEdge = !isIE && !!window.StyleMedia;
                //                if (isIE || isEdge) {
                //                    return a.no > b.no;
                //                }
                //                return a.no < b.no;
                if (a.no > b.no) {
                    return -1;
                } else {
                    return 1;
                }
            });
            /* 병합 정보 반복 수행(컬럼 별) */
            for (var mergeIndex = 0; mergeIndex < mergeinfo.length; mergeIndex++) {
                var merge = mergeinfo[mergeIndex];
                var maxIdx = $('#' + orgnData.tTablename + '_contents tr').length - 1;
                var minIdx = orgnData.oTotal.aaData.length - 1;

                /* 테이블 행별 순회 */
                var rowspan = 1;
                for (var trIdx = maxIdx; trIdx > minIdx; trIdx--) {
                    var item = JSON.parse($('#' + orgnData.tTablename + '_contents tr').eq(trIdx).attr('item'));
                    /* 최초행이 아닌 경우. */
                    if (trIdx != minIdx) {
                    	var preItem = {};
                    	if(trIdx == 0){
                    		preItem = {}
                    	}else{
                    		preItem = JSON.parse($('#' + orgnData.tTablename + '_contents tr').eq(trIdx - 1).attr('item'));	
                    	}
                        if ((item[merge.key] == preItem[merge.key]) && (preItem[merge.key] != undefined)) {
                            rowspan++;
                            $('#' + orgnData.tTablename + '_contents tr').eq(trIdx).find('td').eq(merge.no).remove();
                        } else {
                            $('#' + orgnData.tTablename + '_contents tr').eq(trIdx).find('td').eq(merge.no).attr('rowspan', rowspan);
                            rowspan = 1;
                        }
                    }

                        /* 최초행의 경우 */
                    else {
                        $('#' + orgnData.tTablename + '_contents tr').eq(trIdx).find('td').eq(merge.no).attr('rowspan', rowspan);
                    }
                }
            }
        }
        /*  [type1] 그리드 사이즈 재 조절
        -------------------------------------------------- */
        , _resizeGrid: function (orgnData) {

            if (!orgnData.aoAdvHeaderInfo) {
        	    $('#' + orgnData.divID).height(parseInt(orgnData.nHeight) - 22);
                $('#' + orgnData.divID + ' .leftContents').height(parseInt(orgnData.nHeight) - 57);
                $('#' + orgnData.divID + ' .rightContents').height(parseInt(orgnData.nHeight) - 36);
            } else {
                $('#' + orgnData.divID).height(parseInt(orgnData.nHeight) - (22 * 2));
                $('#' + orgnData.divID + ' .leftContents').height(parseInt(orgnData.nHeight) - (62 * 2));
                $('#' + orgnData.divID + ' .rightContents').height(parseInt(orgnData.nHeight) - (50 * 2));
            }
            $('.dal_Box_detail').height(parseInt(orgnData.nHeight) + 20);
            $('.dal_Box_detail .ta_Contents').height(parseInt(orgnData.nHeight) - 36);
            $('.dal_Box_detail .ta_Contents2').height(parseInt(orgnData.nHeight) - 36);
            
            
        }
    };
})(jQuery)

//상세현황 닫기 공통
function dal_Box_detail() {
    var $DALBD = $(".dal_Box_detail");
    $DALBD.removeClass("animated05s fadeInRight").addClass("animated05s fadeOutRight");
    $(".posi_left table td").parent().removeClass('on');
    setTimeout(function () { $DALBD.hide(); }, 500);
};

//현황 테이블 스크롤 동기화
function dalBoxScroll() {
    var rightTableContentsTop = $(".dal_BoxIn .rightContents").scrollTop();
    var rightTableContentsLeft = $(".dal_BoxIn .rightContents").scrollLeft();
    $(".dal_BoxIn .leftContents").scrollTop(rightTableContentsTop);
    $(".dal_BoxIn .rightHeader").scrollLeft(rightTableContentsLeft);
};
//상세현황 테이블 스크롤 동기화
function dalBoxDetailScroll() {
    var taContentsLeft = $(".dal_Box_detail .ta_Contents").scrollLeft();
    $(".dal_Box_detail .ta_Header").scrollLeft(taContentsLeft);
};

