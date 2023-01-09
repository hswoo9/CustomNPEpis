<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<P CLASS=HStyle0 STYLE='text-align:center;line-height:120%;'></P>
<TABLE border="1" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
<TR>
	<TD rowspan="2" valign="middle" style='width:125px;height:128px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.9pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>출장자</SPAN></P>
	</TD>
	<TD colspan="4" valign="middle" style='width:137px;height:38px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>부 서 명</SPAN></P>
	</TD>
	<TD colspan="6" valign="middle" style='width:137px;height:38px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>직위(직책)</SPAN></P>
	</TD>
	<TD colspan="6" valign="middle" style='width:137px;height:38px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>성&nbsp; 명</SPAN></P>
	</TD>
	<TD colspan="3" valign="middle" style='width:137px;height:38px;border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>비고</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="4" valign="middle" style='width:137px;height:90px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 2.3pt 1.4pt 2.3pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${data.dp_nm }</SPAN></P>
	</TD>
	<TD colspan="6" valign="middle" style='width:137px;height:90px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 2.3pt 1.4pt 2.3pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${data.pt_nm }</SPAN></P>
	</TD>
	<TD colspan="6" valign="middle" style='width:137px;height:90px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 2.3pt 1.4pt 2.3pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${data.ep_nm }</SPAN></P>
	</TD>
	<TD colspan="3" valign="middle" style='width:137px;height:90px;border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${data.rm }</SPAN></P>
	</TD>
</TR>
<TR>
	<TD valign="middle" style='width:125px;height:55px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>출장기간</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:162px;height:55px;border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${fn:replace(data.bs_start, '-', '.')}</SPAN></P>
	</TD>
	<TD colspan="3" valign="middle" style='width:27px;height:55px;border-left:none;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>~</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:148px;height:55px;border-left:none;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${fn:replace(data.bs_end, '-', '.')}</SPAN></P>
	</TD>
	<TD colspan="2" valign="middle" style='width:68px;height:55px;border-left:none;border-right:none;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:right;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${data.bs_day }</SPAN></P>
	</TD>
	<TD colspan="4" valign="middle" style='width:143px;height:55px;border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>일간</SPAN></P>
	</TD>
</TR>
<TR>
	<TD valign="middle" style='width:125px;height:56px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>출장목적</SPAN></P>
	</TD>
	<TD colspan="12" valign="middle" style='width:322px;height:56px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'></SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:96px;height:56px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>출장지</SPAN></P>
	</TD>
	<TD colspan="2" valign="middle" style='width:130px;height:56px;border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>${data.bs_des_txt }</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="20" valign="middle" style='width:673px;height:89px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:bold;line-height:160%'>위와 같이 신청코자 합니다.</SPAN><SPAN STYLE='font-size:14.0pt;line-height:160%'>&nbsp;&nbsp; </SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="20" valign="middle" style='width:673px;height:60px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="10" valign="middle" style='width:224px;height:61px;border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><P CLASS=HStyle0 STYLE='text-align:right;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>신청일 :</SPAN></P>
	</TD>
	<TD colspan="10" valign="middle" style='width:362px;height:61px;border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:14.0pt;font-family:"휴먼명조";line-height:160%'>${fn:replace(data.rqstdt, '-', '.')}</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="20" valign="middle" style='width:673px;height:118px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="20" valign="middle" style='width:673px;height:59px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD rowspan="5" colspan="4" valign="middle" style='width:244px;height:170px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:14.0pt;font-family:"휴먼명조";line-height:160%'><A NAME="FieldStart:"></A></SPAN><SPAN STYLE='font-size:14.0pt;font-family:"휴먼명조";font-style:italic;color:#ff0000;line-height:160%'>MIS등록프로젝트명기재</SPAN><SPAN STYLE='font-size:14.0pt;font-family:"휴먼명조";line-height:160%'><A NAME="FieldEnd:"></A></SPAN></P>
	</TD>
	<TD rowspan="5" colspan="3" valign="middle" style='width:52px;height:170px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:18.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>결</SPAN></P>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:6.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>&nbsp;</SPAN></P>
	<P CLASS=HStyle0 STYLE='margin-left:1.7pt;text-align:center;text-indent:-1.7pt;'><SPAN STYLE='font-size:18.0pt;font-family:"한양견고딕,한컴돋움";line-height:160%'>재</SPAN></P>
	</TD>
	<TD colspan="3" valign="middle" style='width:94px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:0.0pt 0.0pt 0.0pt 0.0pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>asd</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:94px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:0.0pt 0.0pt 0.0pt 0.0pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="4" valign="middle" style='width:94px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:0.0pt 0.0pt 0.0pt 0.0pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD valign="middle" style='width:94px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:0.0pt 0.0pt 0.0pt 0.0pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="3" valign="middle" style='width:94px;height:32px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:7.6pt;font-family:"휴먼명조";letter-spacing:-5%;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:94px;height:32px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:7.6pt;font-family:"휴먼명조";letter-spacing:-5%;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="4" valign="middle" style='width:94px;height:32px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:7.6pt;font-family:"휴먼명조";letter-spacing:-5%;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD valign="middle" style='width:94px;height:32px;border-left:solid #000000 0.9pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:7.6pt;font-family:"휴먼명조";letter-spacing:-5%;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="3" valign="middle" style='width:94px;height:52px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:94px;height:52px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="4" valign="middle" style='width:94px;height:52px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD valign="middle" style='width:94px;height:52px;border-left:solid #000000 0.9pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD rowspan="2" colspan="3" valign="middle" style='width:94px;height:52px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:14.0pt;font-family:"한양중고딕,한컴돋움";line-height:160%'>협조</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:94px;height:26px;border-left:solid #000000 0.9pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:none;padding:0.0pt 0.0pt 0.0pt 0.0pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:188px;height:26px;border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";font-weight:bold;line-height:160%'>&nbsp;&nbsp;</SPAN></P>
	</TD>
</TR>
<TR>
	<TD colspan="5" valign="middle" style='width:94px;height:26px;border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:solid #000000 1.1pt;padding:0.0pt 0.0pt 0.0pt 0.0pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>&nbsp;</SPAN></P>
	</TD>
	<TD colspan="5" valign="middle" style='width:188px;height:26px;border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>&nbsp;</SPAN></P>
	</TD>
</TR>
</TABLE>
