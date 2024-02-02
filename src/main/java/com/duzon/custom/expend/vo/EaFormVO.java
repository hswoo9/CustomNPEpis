package com.duzon.custom.expend.vo;

import com.duzon.custom.expend.etc.CommonConvert;
import com.duzon.custom.expend.etc.CommonInterface.commonCode;
public class EaFormVO {

    String form_id = commonCode.emptySeq;
    String form_nm = commonCode.emptyStr;
    String form_nm_en = commonCode.emptyStr;
    String form_nm_jp = commonCode.emptyStr;
    String form_nm_cn = commonCode.emptyStr;
    String form_short_nm = commonCode.emptyStr;
    String form_tp = commonCode.emptyStr;
    String form_d_tp = commonCode.emptyStr;
    String form_size = commonCode.emptySeq;
    String form_mode = commonCode.emptyStr;
    String form_alert = commonCode.emptyStr;
    String interlock_url = commonCode.emptyStr;
    String interlock_width = commonCode.emptySeq;
    String interlock_height = commonCode.emptySeq;
    String interlock_yn = commonCode.emptyNo;

    public String getForm_id ( ) {
        return CommonConvert.CommonGetStr(form_id);
    }

    public void setForm_id ( String form_id ) {
        this.form_id = form_id;
    }

    public String getForm_nm ( ) {
        return CommonConvert.CommonGetStr(form_nm);
    }

    public void setForm_nm ( String form_nm ) {
        this.form_nm = form_nm;
    }

    public String getForm_nm_en ( ) {
        return CommonConvert.CommonGetStr(form_nm_en);
    }

    public void setForm_nm_en ( String form_nm_en ) {
        this.form_nm_en = form_nm_en;
    }

    public String getForm_nm_jp ( ) {
        return CommonConvert.CommonGetStr(form_nm_jp);
    }

    public void setForm_nm_jp ( String form_nm_jp ) {
        this.form_nm_jp = form_nm_jp;
    }

    public String getForm_nm_cn ( ) {
        return CommonConvert.CommonGetStr(form_nm_cn);
    }

    public void setForm_nm_cn ( String form_nm_cn ) {
        this.form_nm_cn = form_nm_cn;
    }

    public String getForm_short_nm ( ) {
        return CommonConvert.CommonGetStr(form_short_nm);
    }

    public void setForm_short_nm ( String form_short_nm ) {
        this.form_short_nm = form_short_nm;
    }

    public String getForm_tp ( ) {
        return CommonConvert.CommonGetStr(form_tp);
    }

    public void setForm_tp ( String form_tp ) {
        this.form_tp = form_tp;
    }

    public String getForm_d_tp ( ) {
        return CommonConvert.CommonGetStr(form_d_tp);
    }

    public void setForm_d_tp ( String form_d_tp ) {
        this.form_d_tp = form_d_tp;
    }

    public String getForm_size ( ) {
        return CommonConvert.CommonGetStr(form_size);
    }

    public void setForm_size ( String form_size ) {
        this.form_size = form_size;
    }

    public String getForm_mode ( ) {
        return CommonConvert.CommonGetStr(form_mode);
    }

    public void setForm_mode ( String form_mode ) {
        this.form_mode = form_mode;
    }

    public String getForm_alert ( ) {
        return CommonConvert.CommonGetStr(form_alert);
    }

    public void setForm_alert ( String form_alert ) {
        this.form_alert = form_alert;
    }

    public String getInterlock_url ( ) {
        return CommonConvert.CommonGetStr(interlock_url);
    }

    public void setInterlock_url ( String interlock_url ) {
        this.interlock_url = interlock_url;
    }

    public String getInterlock_width ( ) {
        return CommonConvert.CommonGetStr(interlock_width);
    }

    public void setInterlock_width ( String interlock_width ) {
        this.interlock_width = interlock_width;
    }

    public String getInterlock_height ( ) {
        return CommonConvert.CommonGetStr(interlock_height);
    }

    public void setInterlock_height ( String interlock_height ) {
        this.interlock_height = interlock_height;
    }

    public String getInterlock_yn ( ) {
        return CommonConvert.CommonGetStr(interlock_yn);
    }

    public void setInterlock_yn ( String interlock_yn ) {
        this.interlock_yn = interlock_yn;
    }

    @Override
    public String toString ( ) {
        return "EaFormVO [form_id=" + form_id + ", form_nm=" + form_nm + ", form_nm_en=" + form_nm_en + ", form_nm_jp=" + form_nm_jp + ", form_nm_cn=" + form_nm_cn + ", form_short_nm=" + form_short_nm + ", form_tp=" + form_tp + ", form_d_tp=" + form_d_tp + ", form_size=" + form_size + ", form_mode=" + form_mode + ", form_alert=" + form_alert + ", interlock_url=" + interlock_url + ", interlock_width=" + interlock_width + ", interlock_height=" + interlock_height + ", interlock_yn=" + interlock_yn + "]";
    }

}
