<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ page import="main.web.BizboxAMessage"%>

<body>
<style>
.com_ta table th{text-align: center;}
.com_ta table td{text-align: center;}

</style>
<script type="text/javascript" src='<c:url value="/js/ac/acBsUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20BsCode.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20BsForm.js"></c:url>'></script>

<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_contents_wrap">
	
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 8%;">
						부서/출장자
					</dt>
					<dd style="line-height: 25px; width: 20%;">
						<input type="text" id="txtDEPT_NM" ondblclick="getUserInfo('txtDEPT_NM');" style="width: 180px;" readonly="readonly" value="${userInfo.orgnztNm } / ${userInfo.name}" code="${abdocu.erp_dept_cd }" cocd="${abdocu.erp_co_cd }" ><a class="btn_search" onclick="getUserInfo('txtDEPT_NM');" style="margin-top: 1px;"></a>		
						<input type="hidden" id="txtKOR_NM" code="${abdocu.erp_emp_cd }" ep_nm="${userInfo.name }" dp_nm="${userInfo.orgnztNm }" pt_nm="${userInfo.positionNm }" value="${userInfo.uniqId }">
					</dd>
					<dt style="width: 8%;">
						직무대행
					</dt>
					<dd style="line-height: 25px; width: 20%;">
						<input type="text" id="dty_seq" ondblclick="getUserInfo('dty_seq');" style="width: 180px;" readonly="readonly"><a class="btn_search" onclick="getUserInfo('dty_seq');" style="margin-top: 1px;"></a>		
					</dd>
					<dt style="width: 8%;">
						신청일자
					</dt>
					<dd style="line-height: 25px; width: 20%;">
						<input type="text" id="txtGisuDate">
					</dd>
				</dl>	
				
				<dl>
					<dt style="width: 8%;">
						출장지
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<select class="selectMenu" id="bs_des" style="min-width: 70px;display: none;">
							<c:forEach var="list" items="${bsrp_area }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
						<input type="text" id="bs_des_txt" style="width: 100px;"/>
<!-- 						<a class="btn_search" onclick="farePopUpBtn();" style="margin-top: 1px;"></a> -->
					</dd>
					<dt style="width: 8%;">
						출장기간
					</dt>
					<dd style="line-height: 25px;width:30%;">
						<input type="text" id="startDt" onchange="dayCnt();" style="width: 120px;"> ~ <input type="text" id="endDt" onchange="dayCnt();" style="width: 120px;"><span id="dayCnt">(1 일간)</span>
						<input type="hidden" id="dayCntTemp" value="1">
					</dd>
					<dt style="width: 8%;">
						업무차량
					</dt>
					<dd style="line-height: 25px;width:20%">
						<input type="radio" name="car" id="car1" value="0"><label for="car1">사용</label>&emsp;&emsp;
						<input type="radio" name="car" id="car2" value="1" checked="checked"><label for="car2">미사용</label>
					</dd>
				</dl>	
				
				<dl>
					<dt style="width: 8%;">
						교통수단
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<select class="selectMenu" id="topSearchTfcmn" style="min-width: 80px;" onchange="changeTfcmn();">
<%-- 							<c:forEach var="list" items="${bsrp_tfcmn }"> --%>
<%-- 								<option value="${list.code }">${list.code_desc }</option> --%>
<%-- 							</c:forEach> --%>
							<option value="006">항공편</option>
						</select>
					</dd>
					<dt style="width: 8%;">
						숙박제공
					</dt>
					<dd style="line-height: 25px;width:8%;">
						<select id="topSearchRoom" style="min-width: 70px;">
							<option value="1">무제공</option>
							<option value="2">제공</option>
							<option value="3">일부제공</option>
						</select>
					</dd>
					<dt style="width: 8%;">
						식비제공
					</dt>
					<dd style="line-height: 25px;width:8%">
						<select id="topSearchFood" style="min-width: 70px;">
							<option value="1">무제공</option>
							<option value="2">제공</option>
							<option value="3">일부제공</option>
						</select>
					</dd>
					<dt style="width: 5%;">
						목적
					</dt>
					<dd style="width:30%;">
						<input type="text" id="rm" style="min-width: 100%;"/>
					</dd>
				</dl>			
				<dl style="display: none;" id="mileageArea">
					<dt style="width: 8%;">
						항공사
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<select class="selectMenu" id="topSearchAirline" style="min-width: 80px;" onchange="changeAirline();">
							<c:forEach var="list" items="${biztrip_airline }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</dd>
					<dt style="width: 8%;">
						누적마일리지
					</dt>
					<dd style="line-height: 25px;width:8%;">
						<input type="text" id="savedMileage" value="" style="width: 100px;" readonly="readonly" class="mileage"/>
					</dd>
					<dt style="width: 8%;">
						신규마일리지
					</dt>
					<dd style="line-height: 25px;width:8%;">
						<input type="text" id="newMileage" value="" style="width: 100px;" class="mileage"/>
					</dd>
					<dt style="width: 8%;">
						사용마일리지
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<input type="text" id="useMileage" value="" style="width: 100px;" class="mileage" onchange="checkMileage()"/>
					</dd>
				</dl>
			</div>
			</div>
		<br>
<!-- 		<input type="button" value="운임계산" onclick="farePopUpBtn();"> -->
<!-- 		<input type="button" value="자동계산" onclick="autoCalcBtn();"> -->
<!-- 		<p><br></p> -->
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 8%;">
						환율
					</dt>
					<dd style="line-height: 25px;">
						<input type="text" id="ex_rate" onchange="changeExRate();"> $
					</dd>
				</dl>
				<dl>
					<dt style="width: 8%;">
						운임
					</dt>
					<dd style="line-height: 25px; width:35%;">
						<input type="text" id="fare_dol" style="width: 80px;" class="userInput">원 *
						<input type="text" id="fare_cnt" style="width: 30px;" class="userInput" value="2">회 = 
						<input type="text" id="fare" style="width: 80px;" class="sumData" readonly="readonly">원
					</dd>
					<dt style="width: 8%;">
						일비
					</dt>
					<dd style="line-height: 25px;width:35%;">
						<input type="text" id="daily_dol" style="width: 80px;" class="userInput"> $ *
						<input type="text" id="daily_cnt" style="width: 30px;" class="userInput" value="1">일 =
						<input type="text" id="daily" style="width: 80px;" class="sumData" readonly="readonly">원
						<input type="text" id="daily_dol_sum" style="width: 80px;" class="" readonly="readonly"> $
					</dd>
				</dl>
				<dl>
					<dt style="width: 8%;">
						숙박비
					</dt>
					<dd style="line-height: 25px;width:35%;">
						<input type="text" id="room_dol" style="width: 80px;" class="userInput"> $ *
						<input type="text" id="room_cnt" style="width: 30px;" class="userInput" value="0">일 =
						<input type="text" id="room" style="width: 80px;" class="sumData" readonly="readonly">원
						<input type="text" id="room_dol_sum" style="width: 80px;" class="" readonly="readonly"> $
					</dd>
					<dt style="width: 8%;">
						식비
					</dt>
					<dd style="line-height: 25px;width:35%;">
						<input type="text" id="food_dol" style="width: 80px;" class="userInput"> $ *
						<input type="text" id="food_cnt" style="width: 30px;" class="userInput" value="1">일 =
						<input type="text" id="food" style="width: 80px;" class="sumData" readonly="readonly">원
						<input type="text" id="food_dol_sum" style="width: 80px;" class="" readonly="readonly"> $
						<div>
							<span style="color: red;line-height: 100%;position: absolute;">
								<br/>
								※ 출장지 식사 제공시 직접 식비감액 후 지급액 입력 :
								<br/>
								1식감액 6,600원, 2식감액 6,700원, 3식감액 6,700원
							</span>
						</div>
					</dd>
				</dl>
				<dl>
					<dt style="width: 8%;">
						합계
					</dt>
					<dd style="line-height: 25px;width:30%;">
						<input type="text" id="total" style="width: 200px;" class="requirement" readonly="readonly">원
					</dd>
				</dl>
			</div>
		</div>
		<br>
		<div class="com_ta">
			<div class="top_box">
				<table id="erpBudgetInfo-tablesample" style="width: 100%">
					<colgroup>
						<col width="40%">
						<col width="40%">
					<tr>
						<th>예산회계단위</th>
						<th>프로젝트</th>
					</tr>
					<tr>
						<td>
							<input type="text" style="width:85%;" id="txtDIV_NM" ondblclick="getErpInfo();" readonly="readonly" class="requirement txtDIV_NM" value="${abdocu.erp_div_nm}" code="${abdocu.erp_div_cd }">
							<a href="#n" class="search-Event-H" onclick="getErpInfo();"><img src="../Images/ico/ico_explain.png" alt=""></a>
						</td>
						<td>
							<input type="text" style="width:85%;" id="txt_ProjectName" ondblclick="getProject();" readonly="readonly" class="requirement txt_ProjectName">
							<a href="#n" class="search-Event-H" onclick="getProject();"><img src="../Images/ico/ico_explain.png" alt=""></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
<!-- 		<br> -->
<!-- 		<input type="button" value="추가"> -->
		<p><br></p>
		<div class="com_ta">
			<div class="top_box">
				<table style="width: 100%;">
				<colgroup>
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				</colgroup>				
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000003625","관")%></th>
                       	<td id="td_veiw_BGT01_NM" class="bbTxt"></td>
                       	<th><%=BizboxAMessage.getMessage("TX000003626","항")%></th>
                       	<td id="td_veiw_BGT02_NM" class="bbTxt"></td>
                       	<th class="en_w140" ><%=BizboxAMessage.getMessage("TX000003627","목")%></th>
                       	<td id="td_veiw_BGT03_NM" class="bbTxt"></td>
                       	<th><%=BizboxAMessage.getMessage("TX000003628","세")%></th>
                       	<td id="td_veiw_BGT04_NM" class="bbTxt"></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000003618","예산액")%></th>
                        <td id="td_veiw_OPEN_AM"  class="bbTxt" style="font-weight: bold;"></td>                    
                        <th><%=BizboxAMessage.getMessage("TX000005056","집행액")%></th>
                        <td id="td_veiw_APPLY_AM"  class="bbTxt" style="font-weight: bold;"></td>
                        <th class="en_w140" ><%=BizboxAMessage.getMessage("TX000009911","품의액")%></th>
                        <td id="td_veiw_REFER_AM"  class="bbTxt" style="font-weight: bold;"></td>
                        <th><%=BizboxAMessage.getMessage("TX000005686","예산잔액")%></th>
                        <td id="td_veiw_LEFT_AM"  class="bbTxt" style="font-weight: bold;"></td>
					</tr>
				
				</table>

			</div>
		</div>
		<br>
		<div class="com_ta">
			<div class="top_box">
				<table style="width: 100%;">
				<colgroup>
					<col width="15%">
					<col width="15%">
					<col width="10%">
					<col width="10%">
					<col width="">
				</colgroup>
					<tr>
						<th colspan="2">예산과목</th>
						<th>과세구분</th>
						<th>금액</th>
						<th>비고</th>
					</tr>
					<tr>
						<td id="budget-td">
							<input type="text" style="width:80%;" id="txt_BUDGET_LIST" ondblclick="budget_list();" readonly="readonly" class="requirement txt_BUDGET_LIST">
							<a href="#n" class="search-Event-B" onclick="budget_list();"><img src="../Images/ico/ico_explain.png" alt=""></a>
				            <input type="hidden" class="non-requirement" id="BGT01_NM"  />
				            <input type="hidden" class="non-requirement" id="BGT02_NM" />
				            <input type="hidden" class="non-requirement" id="BGT03_NM" />
				            <input type="hidden" class="non-requirement" id="BGT04_NM" />
				            <input type="hidden" class="non-requirement" id="ACCT_AM"  />
				            <input type="hidden" class="non-requirement" id="DELAY_AM"  />
				            <input type="hidden" class="non-requirement" id="APPLY_AM"  />
				            <input type="hidden" class="non-requirement" id="LEFT_AM"  />
				            <input type="hidden" class="non-requirement" id="CTL_FG"  />
				            <input type="hidden" class="non-requirement" id="LEVEL01_NM"  />
				            <input type="hidden" class="non-requirement" id="LEVEL02_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL03_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL04_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL05_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL06_NM" />
				            <input type="hidden" class="non-requirement" id="IT_SBGTCDLINK"/>
						</td>
						<td>
							<input type="text" id="BGT03_Txt" class="requirement" readonly="readonly">
						</td>
						<td>
							<select id="fg" style="width: 60px;" disabled="disabled">
								<option value="1">과세</option>
								<option value="2">면세</option>
								<option value="3" selected="selected">기타</option>
							</select>
						</td>
						<td class=""><span id="txt_total"></span></td>
						<td>
							<input type="text" class="requirement" id="rmk_dc" style="width: 90%">
						</td>
					</tr>
				</table>
			</div>
		</div>
		
	</div>
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="bsrpSave();" value="신청하기" />
		</div>
	</div>

</div>

<div class="pop_wrap_dir" id="farePopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 80px;">
						구분
					</dt>
					<dd style="line-height: 25px">
						<select id="popSearchTfcmn" style="width: 120px;" onchange="fareTopChange();">
							<c:forEach var="list" items="${bsrp_tfcmn }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</dd>
					<dt style="width: 70px; padding-left:40px;">
						도착지
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="popSearchAloc" onchange="fareTopChange();">
					</dd>
				</dl>	
				<dl>
					<dt style="width: 80px;">
						왕복구분
					</dt>
					<dd style="line-height: 25px">
						<select id="trafficType" style="width: 120px;">
							<option value="1">편도</option>
							<option value="2" selected="selected">왕복</option>
						</select>
					</dd>
					<dt style="width: 70px; padding-left:40px;">
						요금제
					</dt>
					<dd style="line-height: 25px">
						<select id="popSearchTrff" style="width: 120px;" onchange="fareTopChange();">
							<c:forEach var="list" items="${bsrp_trff }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</dd>
				</dl>	
			</div>
			
			<div id="fareList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div id="dialog-form-standard" style="display:none">
<div class="pop_wrap_dir" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" /></a>
    </div>
    <div class="pop_con">       
        
        <!-- 채주사원 등록  -->
        <div class="top_box" style="overflow:hidden;display:none;" id="EmpTrade_Search">
            <dl class="dl2">
                <dt class="mr0">
                        <%=BizboxAMessage.getMessage("TX000016505","범위")%>   :  
                         <input type="radio" name="B_use_YN2"  id="B_use_YN2_2"  value="2" />
                         <label  for="B_use_YN2_2" class="mR5"><%=BizboxAMessage.getMessage("TX000000862","전체")%></label>
                         <input type="radio" name="B_use_YN2" id="B_use_YN2_1"  value="1" checked="checked" /> 
                         <label  for="B_use_YN2_1" class="mR5"><%=BizboxAMessage.getMessage("TX000004252","기준일")%> </label>   
                         <input type="text" name="P_STD_DT"  id="P_STD_DT"  value="${basic_dt }"  style="width: 80px;"> 
                         <a href="javascript:;"  id="user_Search2" ><img src=" <c:url value='/Images/btn/search_icon2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000000899","조회")%>" /></a>
                </dt>                
            </dl>
        </div>
        
        <!-- 예산검색 -->     
        <div class="top_box" style="overflow:hidden;display:none;" id="Budget_Search">
            <dl class="next">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005289","예산과목표시")%> :
                 </dt>
                 <dd>                         
                        <input type="radio" name="OPT_01" value="2"  id="OPT_01_2" class="k-radio " checked="checked" />
                        <label class="k-radio-label" for="OPT_01_2" style=";"><%=BizboxAMessage.getMessage("TX000005290","당기 편성된 예산과목만 표시")%></label>
                  </dd>
                  <dd>      
                        <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_1" style=""><%=BizboxAMessage.getMessage("TX000005112","모든 예산과목 표시")%></label>
                  </dd>
                  <dd class="en_mt3">      
                        <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_3" style=""><%=BizboxAMessage.getMessage("TX000005291","프로젝트 기간 예산 편성된 과목만 표시")%></label>
                  </dd>
            </dl>
            <dl class="next2 en_mt0">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005486","사용기한")%> : 
                </dt>
                <dd> 
                        <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio"  checked="checked" />
                        <label class="k-radio-label"  for="OPT_02_1" style=""><%=BizboxAMessage.getMessage("TX000004225","모두표시")%></label>
                        <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" />
                        <label class="k-radio-label"  for="OPT_02_2" style=""><%=BizboxAMessage.getMessage("TX000009907","사용기한경과분 숨김")%></label>
                </dt>                
            </dl>
            <div class="mt14 ar text_blue posi_ab" id="deptEmp_SearchHint" style="bottom:10px;right:10px;display:none;" >※ 아래 (  ) 안에 명칭은 ERP 예산단계를 의미합니다.</div>            
        </div>
        
        <div class="top_box" style="overflow:hidden;display:none;" id="Trade_Search">
            <dl class="dl2">
                <dt class="mr0">
                <input type="checkbox" id="tradeAllview"/> <%=BizboxAMessage.getMessage("TX000016507","모든 거래처 보여주기")%> 
                </dt>
            </dl>
        </div>                                     
        <div class="com_ta2 mt10 ova_sc_all cursor_p"   style="height:340px;" id="dialog-form-standard-bind">
        </div>
        

    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<!-- 예산검색 -->     
<div class="top_box" style="overflow:hidden;display:none;" id="Budget_Search">
    <dl class="next">
        <dt style="width:100px;" class="en_w145">
        <%=BizboxAMessage.getMessage("TX000005289","예산과목표시")%> :
         </dt>
         <dd>                         
                <input type="radio" name="OPT_01" value="2"  id="OPT_01_2" class="k-radio" checked="checked" />
                <label class="k-radio-label" for="OPT_01_2" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005290","당기 편성된 예산과목만 표시")%></label>
                <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" />
                <label class="k-radio-label" for="OPT_01_1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005112","모든 예산과목 표시")%></label>
                <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" />
                <label class="k-radio-label" for="OPT_01_3" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005291","프로젝트 기간 예산 편성된 과목만 표시")%></label>
        </dd>
    </dl>
    <dl class="next2">
        <dt style="width:100px;" class="en_w145">
    <%=BizboxAMessage.getMessage("TX000005486","사용기한")%> : 
        </dt>
        <dd> 
                <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio"  checked="checked" />
                <label class="k-radio-label"  for="OPT_02_1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000004225","모두표시")%></label>
                <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" />
                <label class="k-radio-label"  for="OPT_02_2" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000009907","사용기한경과분 숨김")%></label>
        </dt>                
    </dl>            
<div class="mt14 ar text_blue posi_ab" id="deptEmp_SearchHint" style="bottom:10px;right:10px;display:none;" >※ 아래 (  ) 안에 명칭은 ERP 예산단계를 의미합니다.</div>
</div>

<div class="pop_wrap_dir" id="userPopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="userList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div id="addHtml"></div>

<form id="viewerForm" name="viewerForm" method="post" action="http://gw.jif.re.kr/gw/outProcessLogOn.do" target="viewer">
<%-- <form id="viewerForm" name="viewerForm" method="post" action="http://121.126.239.223/gw/outProcessLogOn.do" target="viewer"> --%>
<input type="hidden" id="outProcessCode" name="outProcessCode" value="BSRP">
<input type="hidden" id="mod" name="mod" value="W">
<input type="hidden" id="loginId" name="loginId" value="${userInfo.id}">
<input type="hidden" name="contentsEnc" value="O">
<input type="hidden" id="contentsStr" name="contentsStr">
<input type="hidden" id="subjectStr" name="subjectStr">
<input type="hidden" id="approKey" name="approKey">
</form>

<script>
var erpOption = {BgtMngType: "2", CauseUseYn: "1", BizGovUseYn: "0", BgtAllocatUseYn: "0", BottomUseYn: "0"};
var langCode = 'KR';
var abdocuInfo = {};
var template_key = 52;
var mode = 0;
var trafficArray = {}; //운임비용
var trafficType = 1; //왕복구분
var trafficTypeNm = '편도'; //왕복구분
var erpToEmpInfo = {}; //직급별 여비

var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/bsrp/getFareListSearch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.type = 'all';
      		data.tfcmn = $('#popSearchTfcmn').val();
      		data.trff = $('#popSearchTrff').val();
      		data.alocTxt = $('#popSearchAloc').val();
      		data.strtpnt = 'all';
      		data.aloc = 'all';
      		return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
});

var userDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getUserList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_name = $('#searchNm').val();
      		data.search_dept = $('#searchDp').val();
      		data.search_num = $('#searchNum').val();
      		return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
});

$.fn.noComma = function(){

	return $(this).val().replace(/,/g,"");
}

$(function(){
	
	
	//예산과목 조회
// 	Budget_Search();
	
	$('#OPT_01_2').prop('checked', true);
	$('#OPT_02_1').prop('checked', true);
	
	$('#txtGisuDate').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	}).attr("readonly", true);
	
	var startDate = $('#startDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	    change: startChange
	}).attr("readonly", true).data("kendoDatePicker");

	var endDate = $('#endDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	}).attr("readonly", true).data("kendoDatePicker");

	function startChange(){
		if(startDate.value() > endDate.value()){
			endDate.value('');
		}
		endDate.min(startDate.value());
	}
	//출장자 유저정보 조회
	erpInfoData();
	
	//운임팝업
	$('#farePopUp').kendoWindow({
		width: "600px",
	    title: '운임선택',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$('#userPopUp').kendoWindow({
		width: "600px",
	    title: '사용자 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#fareList").kendoGrid({
        dataSource: dataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
      	 {
             field: "strtpnt_kr",
             title: "출발지",
         }, {
             field: "aloc_kr",
             title: "도착지",
         }, {
        	 template : pymnTemp,
             field: "pymntamt",
             title: "금 액",
         }, {
             field: "rm",
             title: "비 고",
         }],
    }).data("kendoGrid");
	
	$("#userList").kendoGrid({
        dataSource: userDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "직원번호",
            columns: [{
                field: "erp_emp_num",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNum" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "이름",
            columns: [{
                field: "emp_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNm" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "부서",
            columns: [{
                field: "dept_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchDp" class="userHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$(document).on('dblclick', '#userList .k-grid-content tr', function(){
		var gData = $("#userList").data('kendoGrid').dataItem(this);
		
		if(popupId == 'txtDEPT_NM'){
			$('#txtDEPT_NM').val(gData.dept_name + ' / ' + gData.emp_name).attr('code', gData.comp_seq);
			$('#txtKOR_NM').val(gData.emp_seq).attr('code', gData.erp_emp_num).attr('dp_nm', gData.dept_name).attr('ep_nm', gData.emp_name).attr('pt_nm', gData.position_name);
			
			erpInfoData();
			
			$('#txt_ProjectName').val('').attr('code','');
        	$('.bbTxt').text('');
        	$('.non-requirement').val('').attr('code', '');
        	$('#txt_BUDGET_LIST').val('').attr('code', '');
        	$('#BGT03_Txt').val('').attr('code', '');

		}else{
			$('#dty_seq').val(gData.dept_name + ' / ' + gData.emp_name).attr('emp_seq', gData.emp_seq);
		}
		
		$('#userPopUp').data("kendoWindow").close();
		
		changeAirline();
	});
	
	$(document).on('dblclick', '#fareList .k-grid-content tr', function(){
		var gData = $("#fareList").data('kendoGrid').dataItem(this);
		
		trafficType = $('#trafficType').val();
		trafficTypeNm = $('#trafficType option:selected').text();
		//단순 운임비용만 필요한 걸까?
		trafficArray = gData;
		
		autoCalcBtn();
		
		$("#bs_des").val(gData.aloc);
		$("#bs_des_txt").val(gData.aloc_kr);
		$("#topSearchTfcmn").val($("#popSearchTfcmn").val());
		
		$('#farePopUp').data("kendoWindow").close();
		
		changeTfcmn();
	});
	
	$('.userHeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#userList").data('kendoGrid').dataSource.read();
        }
	});
	
	$('.userInput').on('change', function(){
		amtCalc($(this));
	});

	$("input[name=car]").on('click', function(){
		autoCalcBtn();
	});
	
	autoCalcBtn();
	
	$("#txtDIV_NM").val(abdocuInfo.erp_div_nm);
	$("#txtDIV_NM").attr("code", abdocuInfo.erp_div_cd);
	
	changeTfcmn();
	changeAirline();
	$(".mileage").bind("change", function(){
		$(this).val($(this).val().toMoney());
	});
})

var pymnTemp = function(row){
	return numberWithCommas(row.pymntamt) + '원';
}

function fareTopChange(){
	$("#fareList").data('kendoGrid').dataSource.read();
}

function farePopUpBtn(){
	$('#popSearchTfcmn').val($('#topSearchTfcmn').val());
	$('#popSearchAloc').val('');
	
	$("#fareList").data('kendoGrid').dataSource.read();
	$('#farePopUp').data("kendoWindow").open().center();
	
}

function dayCnt(){
	
	var s = moment( $('#startDt').val() );
	var e = moment( $('#endDt').val() );
	
	if(s._isValid && e._isValid){
		
		var datCnt = e.diff(s, 'days');
		
		$('#dayCntTemp').val(datCnt + 1);
		
		$('#dayCnt').text('('+(datCnt + 1)+' 일간)');
	}
	autoCalcBtn();
}


//출장자 정보를 가져오자
function erpInfoData(){
	
	var data = {
			CO_CD : 2000, //TODO 공통으로 쓰는것
			EMP_CD : $('#txtKOR_NM').attr('code'),
			GISU_DT : moment().format('YYYYMMDD'),
	}
	
	$.ajax({
		url : "<c:url value='/bsrp/erpInfoData' />",
		dataType : 'json',
		type : 'POST',
		data : data,
		async: false,
		success : function(result) {
			abdocuInfo = result.abdocu;
	
			erpToEmpInfo = result.erpToEmpInfo;
			
			//출장자가 변경되면 기존 입력 데이터를 초기화
			$('.requirement').val('').attr('code', '');
			$('.non-requirement').val('').attr('code', '');
			$('.bbTxt').text('');
			
			$("#txtDIV_NM").val(abdocuInfo.erp_div_nm);
			$("#txtDIV_NM").attr("code", abdocuInfo.erp_div_cd);
		}
	});
	
}

function amtCalc(obj){
	var fg = obj.attr("id").split("_")[0];
	var dol = $("#" + fg + "_dol").val();
	var cnt = $("#" + fg + "_cnt").val();
	var sum = dol.toMoney2() * cnt.toMoney2();
	$("#" + fg + "_dol").val(dol.toMoney());
	$("#" + fg + "_cnt").val(cnt.toMoney());
	if(fg == "fare"){
		$("#" + fg).val(sum.toString().toMoney());
	}else{
		var exRate = parseFloat($("#ex_rate").noComma());
		$("#" + fg + "_dol_sum").val(sum.toString().toMoney());
		$("#" + fg).val(parseInt(sum * exRate).toString().toMoney());
	}
	totalSum();
}

//자동계산
function autoCalcBtn(){
	var dayCntTemp = $("#dayCntTemp").val();
	$("#daily_cnt").val(dayCntTemp);
	$("#room_cnt").val(dayCntTemp - 1);
	$("#food_cnt").val(dayCntTemp);
	
	$.each($("#daily_cnt, #room_cnt, #food_cnt"), function(){
		amtCalc($(this));
	});
	
	totalSum();
}

function totalSum(){
	var sum = 0;
	$.each($('.sumData'), function(i, v){
		
		sum += Number($(v).val().replace(/[^0-9]/g,""));
		
	});
	
	$('#total').val(numberWithCommas(sum));
	$('#txt_total').html(numberWithCommas(sum));
	
}

function foodChange(e){
	$('#food_txt').val($(e).val().replace(/[^0-9]/g,""));
	$('#food').val(numberWithCommas($('#food_txt').val()));
}

function changeTfcmn(){
	if($("#topSearchTfcmn").val() == "006"){
		$("#mileageArea").show();
	}else{
		$("#mileageArea").hide();
	}
}

function changeAirline(){
	var saveObj = {};
	saveObj.applcnt_seq = $('#txtKOR_NM').val();
	saveObj.airline = $('#topSearchAirline').val();
	$.ajax({
		url : "<c:url value='/bsrp/getBsrpMileage' />",
		dataType : 'json',
		type : 'POST',
		data : saveObj,
		success : function(result) {
			$("#savedMileage").val(result.savedMileage.toString().toMoney());
			$("#useMileage").val("0");
			$("#newMileage").val("0");
		}
	});
}

function changeExRate(){
	var exRate = parseInt($("#ex_rate").noComma() * 1000)/1000;
	$("#ex_rate").val(numberWithCommas(exRate));
	autoCalcBtn();
}

function checkMileage(){
	var savedMileage = parseInt($("#savedMileage").val().toMoney2());
	var useMileage = parseInt($("#useMileage").val().toMoney2());
	if(savedMileage < useMileage){
		alert("사용마일리지는 누적마일리지를 초과 할 수 없습니다.");
		$("#useMileage").val("0");
	}
}

//프로젝트 호출
function getProject(){
	
	if($('#txtDIV_NM').attr('code') == null || $('#txtDIV_NM').attr('code') == ''){
		alert('예산회계단위를 선택해 주세요.');
		return
	}
	
	$("#budget-td input").val("");
	$("#budget-td input").attr("code", "");
	$("#BGT03_Txt").val("");
	$("#BGT03_Txt").attr("code", "");
	
	var dblClickparamMap =
        [{
			"id" : "txt_ProjectName",
            "text" : "PJT_NM",
            "code" : "PJT_CD"
		},
		{
			"id" : "txt_PJT_FR_DT",
			"text" : "PJT_FR_DT",
			"code" : "PJT_FR_DT"
		},
		{
			"id" : "txt_PJT_TO_DT",
			"text" : "PJT_TO_DT",
			"code" : "PJT_TO_DT"
		},
		{
			"id" : "txt_IT_BUSINESSLINK",
			"text" : "IT_BUSINESSLINK",
			"code" : "IT_BUSINESSLINK"
		}];

	var erp_dept_cd= $("#txtDEPT_NM").attr("CODE");
	var erp_emp_cd = $("#txtKOR_NM").attr("CODE");
	
    if(erp_dept_cd == "" || erp_emp_cd == ""){
        alert(NeosUtil.getMessage("TX000009431","작성자정보를 선택해 주세요"));
        return
	}
    var tblParam = { };
    tblParam.EMP_CD = erp_emp_cd;
    tblParam.FG_TY = erpOption.BgtMngType;
    tblParam.CO_CD = abdocuInfo.erp_co_cd;
    
    acUtil.util.dialog.dialogDelegate(getErpMgtList, dblClickparamMap, null, fnMgtCdSet, tblParam);
	
}

function fnMgtCdSet(sel, dblClickparamMap){
	console.log('Call fnMgtCdSet / callback project layer');
	
	if(dblClickparamMap == null){
		return
	}
	
	var PJT_CD = sel.PJT_CD;
	if(PJT_CD != $("#temp_PjtCd").val()){
		$("#temp_PjtCd").val(PJT_CD);
		var id = dblClickparamMap[0].id;
		var tr = $('#' + id).closest('tr');
		
		// 프로젝트에 연동된 거래처 있는경우 바로적용 
		if(sel.TR_CD && sel.ATTR_NM && sel.BA_NB){
			$(".txt_BankTrade", tr).attr("CODE" ,sel.TR_CD);
			$(".txt_BankTrade", tr).val(sel.ATTR_NM);
			$(".txt_BankTrade_NB", tr).val(sel.BA_NB);
		}else { 
			$(".txt_BankTrade", tr).attr("CODE" ,'');
			$(".txt_BankTrade", tr).val('');
			$(".txt_BankTrade_NB", tr).val('');
		}
		if(tr.attr('id') && tr.attr('id') != 0){
			var data = {abdocu_no : tr.attr('id'), purc_req_h_id : purcReqHId};
			/*ajax 호출할 파라미터*/
			var opt = {
					url : _g_contextPath_ + "/Ac/G20/Ex/delPurcReqH.do",
					stateFn : modal_bg,
					async : false,
					data  : data,
					successFn : function(result){
						abdocu.BudgetInfo.remove();
						$(".totalAM", "#erpBudgetInfo-table").html("");
						abdocu.TradeInfo.remove();
					}
			};
			acUtil.ajax.call(opt, null);
		}

	}
}

function budget_list(){

	if($('#txt_ProjectName').attr('code') == null || $('#txt_ProjectName').attr('code') == ''){
		alert('프로젝트를 선택해 주세요.');
		return
	}
	
	
	var context = $("#erpBudgetInfo-table");
	
	/*ajax 호출할 파라미터*/
    var GISU_DT = $("#txt_GisuDt").val();
    var GR_FG = "7"; /*예산과목의 수입/지출구분*/
    
    var DIV_CDS = $("#txtDIV_NM").attr("CODE") + "|";
    var MGT_CDS = $("#txt_ProjectName").attr("CODE") + "|";
    var BOTTOM_CDS = $("#txtBottom_cd").attr("CODE") || "";
    //    if(BOTTOM_CDS !=""){ BOTTOM_CDS + '|';   }; 
    if(!ncCom_Empty(BOTTOM_CDS)){ 
        BOTTOM_CDS = BOTTOM_CDS + "|";   
    };
   
    /* OPT_01(예산과목표시)   2 : 당기편성, 1 : 모든예산, 3 : 프로젝트기간 */
    var OPT_01 = $(":input[name=OPT_01]:checked").val() || "2";
    /* OPT_02(사용기한)   1 : 모두표시, 2 : 사용기한경과분 숨김 */
    var OPT_02 = $(":input[name=OPT_02]:checked").val() || "1";
    /* 상위과목표시( 1, 2 ) */
    var OPT_03 = "2";

    var tblParam = {}
    tblParam.GISU_DT = $('#txtGisuDate').val().replace(/-/gi,"");
    tblParam.GR_FG = 2;
    tblParam.DIV_CDS = DIV_CDS;
    tblParam.MGT_CDS = MGT_CDS;
    tblParam.BOTTOM_CDS = BOTTOM_CDS;
    tblParam.OPT_01 = OPT_01;
    tblParam.OPT_02 = OPT_02;
    tblParam.OPT_03 = OPT_03;
    tblParam.CO_CD  = abdocuInfo.erp_co_cd;
    tblParam.FR_DT  = abdocuInfo.erp_gisu_from_dt;
    tblParam.TO_DT  = abdocuInfo.erp_gisu_to_dt;
    tblParam.GISU   = abdocuInfo.erp_gisu;
    tblParam.BgtStep7UseYn = erpOption.BgtStep7UseYn;

    var id = $(this).attr("id");
    $.eventEle = id;
    var dblClickparamMap =
    	(function(ID, idx){
    		var returnObj =
                [{
					"id" : "txt_BUDGET_LIST",
                    "text" : "BGT_NM",
                    "code" : "BGT_CD"
				},
				{
					"id" : "IT_SBGTCDLINK" + idx,
                    "text" : "IT_SBGTCDLINK",
                    "code" : "IT_SBGTCDLINK"
				},
				{
					"id" : "BGT03_Txt",
                    "text" : "BGT03_NM",
                    "code" : "BGT03_CD"
				}];
			return returnObj;

    	})(id, null);

    acUtil.util.dialog.dialogDelegate(acG20Code.getErpBudgetList, dblClickparamMap, null, fnBgtCdSet, tblParam);
	
}

function getErpInfo(){
	
     var dblClickparamMap =
         [{
			"id" : "txtDIV_NM",
             "text" : "DIV_NM",
             "code" : "DIV_CD"
		}];

     acUtil.util.dialog.dialogDelegate(acG20Code.getErpDIVList, dblClickparamMap);
     $("#dialog-form-standard-bind-table tr[index=1]").hide();
     $("#dialog-form-standard-bind-table .searchLine").hide();
}

function getUserInfo(id){
	
	popupId = id;
	$('#userPopUp').data("kendoWindow").open().center();
	$("#userList").data('kendoGrid').dataSource.read();
	
// 	var dblClickparamMap =
//         [{
// 			"id" : id,
//             "text" : "DEPT_NM",
//             "code" : "DEPT_CD"
// 		},
// 		{
// 			"id" : "txtKOR_NM",
// 			"text" : "KOR_NM",
// 			"code" : "EMP_CD"
// 		}];
//     acUtil.util.dialog.dialogDelegate(acG20Code.getErpDeptUserList, dblClickparamMap);
	
}


function Budget_Search(){
	$('#Budget_Search input[type=radio]').click(function(){
		budget_list();
	});
}

function bsrpSaveVal(){
	if(!$("#bs_des_txt").val()){
		alert("출장지를 입력하세요.")
		return false;
	}
	if(!$("#fare").val()){
		alert("운임을 입력하세요.")
		return false;
	}
	if(!$("#daily").val()){
		alert("일비를 입력하세요.")
		return false;
	}
	if(!$("#txtDIV_NM").val()){
		alert("예산회계단위를 입력하세요.")
		return false;
	}
	if(!$("#txt_ProjectName").val()){
		alert("프로젝트를 입력하세요.")
		return false;
	}
	if(!$("#txt_BUDGET_LIST").val()){
		alert("예산과목을 입력하세요.")
		return false;
	}
	var total = parseInt($("#total").val().toMoney2());
	var leftAm = parseInt($("#td_veiw_LEFT_AM").text().toMoney2());
	if(total > leftAm){
		alert("예산을 초과 하였습니다. 확인해주세요.");
		return false;
	}
	
	return true;
}

function bsrpSave(){
	
	if(!bsrpSaveVal()){
		return;
	}
	
	if(!confirm("감액사유를 확인하셨습니까?")){
		return;
	}
	
	var saveObj = {
			bs_type			: '3',										//신청종류
			fare			: $('#fare').noComma(),						//운임
			daily			: $('#daily').noComma(),					//일비
			room			: $('#room').noComma(),						//숙박비
			food			: $('#food').noComma(),						//식비
			toll			: "0",						
			total			: $('#total').noComma(),					//합계
			bs_start		: $('#startDt').val(),						//출장시작일
			bs_end			: $('#endDt').val(),						//출장 종료일
			bs_des_txt		: $('#bs_des_txt').val(),					//출장지
			car_yn			: $('input[name=car]:checked').val(),		//업무차량유무
			tfcmn			: $('#topSearchTfcmn').val(),				//교통수단
			applcnt_seq		: $('#txtKOR_NM').val(),					//신청자
			rqstdt			: $('#txtGisuDate').val(),					//신청일
			room_yn			: $('#topSearchRoom').val(),				//숙박제공유무
			food_yn			: $('#topSearchFood').val(),				//식비제공유무
			dty_seq			: $('#dty_seq').val(),						//직무대행자
			bs_day			: $('#dayCntTemp').val(),					//출장기간
			app_user_seq	: '',										//승인권자
			fsse			: $('#txtDIV_NM').attr('code'),				//회계구분
			pjt_cd			: $('#txt_ProjectName').attr('code'),		//프로젝트코드
			pjt_nm			: $('#txt_ProjectName').val(),				//프로젝트명
			rm				: $('#rm').val(),							//비고
			budget_cd		: $('#txt_BUDGET_LIST').attr('code'),		//예산과목
			budget_nm		: $('#txt_BUDGET_LIST').val(),				//예산과목
			fg				: $('#fg').val(),							//과세구분
			dp_nm			: $('#txtKOR_NM').attr('dp_nm'),						
			ep_nm			: $('#txtKOR_NM').attr('ep_nm'),						
			pt_nm			: $('#txtKOR_NM').attr('pt_nm'),						
			ex_rate			: $('#ex_rate').val(),						
			
	}
	
	/*품의정보입력 프로젝트*/
	saveObj.abdocu_no       = '0';
	saveObj.docu_mode       = "0";
	saveObj.docu_fg         = "1";
	saveObj.docu_fg_text    = "구매품의서";
    saveObj.erp_co_cd       = abdocuInfo.erp_co_cd;
    saveObj.erp_co_nm       = abdocuInfo.erp_co_nm;
    saveObj.erp_dept_cd     = abdocuInfo.erp_dept_cd;
    saveObj.erp_dept_nm     = abdocuInfo.erp_dept_nm;
    saveObj.erp_emp_cd      = abdocuInfo.erp_emp_cd;
    saveObj.erp_emp_nm      = abdocuInfo.erp_emp_nm;
    saveObj.erp_div_cd      = $("#txtDIV_NM").attr("CODE");
    saveObj.erp_div_nm      = $("#txtDIV_NM").val();
    saveObj.mgt_cd          = $("#txt_ProjectName").attr("CODE");
	saveObj.mgt_nm_encoding = $("#txt_ProjectName").val();
	saveObj.rmk_dc          = $('#rmk_dc').val();
    saveObj.erp_gisu_dt     = $("#txtGisuDate").val().replace(/-/gi,"");
    saveObj.erp_gisu_from_dt= abdocuInfo.erp_gisu_from_dt;
    saveObj.erp_gisu_to_dt  = abdocuInfo.erp_gisu_to_dt;
    saveObj.erp_gisu        = abdocuInfo.erp_gisu;
    saveObj.erp_year        = acUtil.util.getUniqueTime().substring(0, 4);
    /*품의정보입력 프로젝트*/
    
    /*품의정보입력 예산*/
    saveObj.set_fg 			= "1";
    saveObj.vat_fg 			= $('#fg').val();
    saveObj.tr_fg 			= "1";
    saveObj.div_nm2			= $("#txtDIV_NM").val();
	saveObj.div_cd2			= $("#txtDIV_NM").attr("CODE");
	saveObj.erp_gisu_sq		= "0";
	saveObj.erp_bq_sq		= "0";
	saveObj.erp_bgt_nm1		= $("#BGT01_NM").val();
	saveObj.erp_bgt_nm2		= $("#BGT02_NM").val();
	saveObj.erp_bgt_nm3		= $("#BGT03_NM").val();
	saveObj.erp_bgt_nm4		= $("#BGT04_NM").val();
	saveObj.erp_open_am		= $("#OPEN_AM").val();
	saveObj.erp_acct_am		= $("#ACCT_AM").val();
	saveObj.erp_delay_am	= $("#DELAY_AM").val();
	saveObj.erp_term_am		= $("#APPLY_AM").val();
	saveObj.erp_left_am		= $("#LEFT_AM").val();
	saveObj.ctl_fg			= "4";
	saveObj.abgt_cd			= $("#txt_BUDGET_LIST").attr("CODE");
	saveObj.abgt_nm			= $("#txt_BUDGET_LIST").val();
	saveObj.apply_am		= $("#total").val().toMoney2() || "0";
    /*품의정보입력 예산*/
    
    /*품의정보입력 채주*/
    var unitAmt = $("#total").val().toMoney2() || "0";
    var supAmt = unitAmt;
    var vatAmt = "0";
    if(saveObj.vat_fg == "1"){
		var supAmt = ((Math.round(parseInt(unitAmt,10) / 1.1 * 10)) / 10);
		supAmt = Math.round(supAmt, 10);
		vatAmt = (parseInt(unitAmt,10) - supAmt).toString().toMoney() || 0;
		supAmt = supAmt.toString();
	}
    saveObj.tr_cd       = ""; /*거래처코드*/
    saveObj.tr_nm       = ""; /*거래처명*/
    saveObj.ceo_nm      = ""; /*대표자명*/
    saveObj.unit_am     = unitAmt; /*금액*/
    saveObj.sup_am      = supAmt; /*공급가액*/
    saveObj.vat_am      = vatAmt; /*부가세*/
    saveObj.btr_nm      = ""; /*금융기관*/
    saveObj.btr_cd      = "";/*금융기관*/
    saveObj.jiro_nm     = ""; /*금융기관*/
    saveObj.jiro_cd     = ""; /*금융기관*/
    saveObj.depositor   = ""; /*예금주*/
    saveObj.item_nm     = ""; /*품명*/
    saveObj.item_cnt    = "0"; /*수량*/
    saveObj.item_am     = "0"; /*단가*/
    saveObj.emp_nm      = ""; /*사원명*/
    saveObj.ba_nb       = ""; /*계좌번호*/
    saveObj.ctr_cd      = ""; /*카드거래처 코드*/
    saveObj.ctr_card_num = ""; /*카드거래처 코드*/
    saveObj.ctr_nm      = ""; /*카드거래처 이름*/    
    saveObj.reg_nb      = ""; /*사업자코드*/
    saveObj.tel         = ""; /*전화번호*/
    saveObj.ndep_am     = "0"; /*기타소득필요경비*/
    saveObj.inad_am     = "0";  /*소득금액*/
    saveObj.intx_am     = "0";  /*소득세액*/
    saveObj.rstx_am     = "0";  /*주민세액*/
    saveObj.wd_am       = "0"; 
    saveObj.etcrvrs_ym  = ""; /*기타소득귀속년월*/
    saveObj.etcdummy1   = ""; /*소득구분*/
    saveObj.etcdata_cd  = ""; /*소득구분*/
    saveObj.tax_dt      = ""; /*신고기준일*/
    saveObj.it_use_dt   = ""; 
    saveObj.it_use_no   = ""; 
    saveObj.it_card_no  = ""; 
    saveObj.et_yn       = ""; /*erp data*/
    saveObj.tr_fg       = "1"; // $(".txt_TR_FG", parentEle).val() || "";  /*erp data*/
    saveObj.tr_fg_nm    = "거래처"; // $(".txt_TR_FG_NM", parentEle).val() || ""; /*erp data*/
    saveObj.attr_nm     = ""; /*erp data*/
    saveObj.ppl_nb      = ""; /*erp data*/
    saveObj.addr        = ""; /*erp data*/
    saveObj.trcharge_emp = ""; /*erp data*/
    saveObj.etcrate     = ""; /*erp data*/
    /*품의정보입력 채주*/
    
    /*마일리지*/
    if($("#topSearchTfcmn").val() == "006"){
	    saveObj.airline = $("#topSearchAirline").val();
	    saveObj.saved_mileage = $("#savedMileage").val().toMoney2();
	    saveObj.new_mileage = $("#newMileage").val().toMoney2();
	    saveObj.use_mileage = $("#useMileage").val().toMoney2();
    }
    /*마일리지*/
    
	$.ajax({
		url : "<c:url value='/bsrp/bsrpSave' />",
		dataType : 'json',
		type : 'POST',
		data : saveObj,
		success : function(result) {
			
			$('#approKey').val("bsrp_" + result.bs_seq);
// 			$('#approKey').val(result.abdocu_no);
			
			approvalOpen(result);
		}
	});
	
}

function approvalOpen(result){
	$('#contentsStr').val(getContentsStr(result));
	var data = {};
	data.processId = $('#outProcessCode').val();
	data.approKey = $('#approKey').val();
	data.title = $("#rm").val();
	data.content = $('#contentsStr').val();
	$.ajax({
		type : 'POST',
		async: false,
		url : _g_contextPath_  + '/outProcess/outProcessTempInsert',
		data:data,
		dataType : 'json',
		success : function(data) {
			if(data.resultCode == "SUCCESS"){
				window.open("",  "viewer", "width=1000px, height=900px, resizable=no, scrollbars = yes, status=no, top=50, left=50", "newWindow");
				$("#viewerForm").submit();
			}
		}
	});
}

function getContentsStr(result){
	var contentsStr = "";
	contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' width='125' height='128' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.9pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>출장자</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' width='137' height='38' valign='middle' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>부 서 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' width='137' height='38' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>직위(직책)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' width='137' height='38' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>성&nbsp; 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' width='137' height='38' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>비고</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='4' width='137' height='90' valign='middle' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 2.3pt 1.4pt 2.3pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.dp_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' width='137' height='90' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 2.3pt 1.4pt 2.3pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.pt_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' width='137' height='90' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 2.3pt 1.4pt 2.3pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.ep_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' width='137' height='90' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.rmk_dc + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD width='125' height='55' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>출장기간</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' width='162' height='55' valign='middle' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.bs_start.replace(/-/g, ".") + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' width='27' height='55' valign='middle' style='border-left:none;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>~</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' width='148' height='55' valign='middle' style='border-left:none;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.bs_end.replace(/-/g, ".") + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' width='68' height='55' valign='middle' style='border-left:none;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.bs_day + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' width='143' height='55' valign='middle' style='border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>일간</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD width='125' height='56' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>출장목적</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='12' width='322' height='56' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.rm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' width='96' height='56' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>출장지</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' width='130' height='56' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>" + result.bs_des_txt + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD width='125' height='56' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양견고딕,한컴돋움';line-height:160%;'>프로젝트</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='19' width='130' height='56' valign='middle' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>　　" + result.mgt_nm_encoding + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='20' width='673' height='89' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:'bold';line-height:160%;'>위와 같이 신청코자 합니다.</SPAN><SPAN STYLE='font-size:14.0pt;line-height:160%;'>&nbsp;&nbsp; </SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='20' width='673' height='60' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;line-height:160%;'></SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='2' width='224' height='61' valign='middle' style='border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' width='86' height='61' valign='middle' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>신청일 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='12' width='362' height='61' valign='middle' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:14.0pt;font-family:'휴먼명조,한컴돋움';line-height:160%;'>" + result.rqstdt.replace(/-/g, ".") + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='3' width='225' height='59' valign='middle' style='border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:'bold';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' width='85' height='59' valign='middle' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' width='80' height='59' valign='middle' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' width='53' height='59' valign='middle' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:'한양중고딕,한컴돋움';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' width='229' height='59' valign='middle' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:'bold';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='20' width='673' height='59' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:'bold';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='20' width='448' height='59' valign='middle' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:'bold';line-height:160%;'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "</TABLE>";
	return contentsStr;
}

</script>

</body>