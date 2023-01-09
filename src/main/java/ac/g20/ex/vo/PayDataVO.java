package ac.g20.ex.vo;

/**
 * 
 * @title PayDataVO.java
 * @author doban7
 *
 * @date 2016. 10. 21.
 */

public class PayDataVO {

    private String abdocu_no = "";
    private String abdocu_b_no = "";
    private String abdocu_t_no = "";
    private String erp_co_cd = "";
    private String emp_cd = "";
    
    private String PKEY = "";
    private String EMP_TR_CD = "";  // EMP_CD
    private String KOR_NM = "";
    
    private String DEPT_NM = "";
    
    private String RVRS_YM = "";
    private String SQ = "";
    private String GISU_DT = "";
    private String PAY_DT = "";
    private String TPAY_AM = "";
    private String SUP_AM = "";
    private String VAT_AM = "";
    private String INTX_AM = "";
    private String RSTX_AM = "";
    private String ETC_AM = "";

    private String ACCT_NO = "";
    private String PYTB_CD = "";
    private String DPST_NM = "";
    private String BANK_NM = "";
    private String RSRG_NO = "";
    private String PJT_NM = "";

    private String strPKEY[];
    private String strEMP_TR_CD[];  // EMP_CD
    private String strKOR_NM[];
    private String strDEPT_NM[];
    private String strRVRS_YM[];
    private String strSQ[];
    private String strGISU_DT[];
    private String strPAY_DT[];
    private String strTPAY_AM[];
    private String strSUP_AM[];
    private String strVAT_AM[];
    private String strINTX_AM[];
    private String strRSTX_AM[];
    private String strETC_AM[];

    private String strACCT_NO[];
    private String strPYTB_CD[];
    private String strDPST_NM[];
    private String strBANK_NM[];
    private String strRSRG_NO[];
    private String strPJT_NM[];
    
    public String getAbdocu_no() {
        return abdocu_no;
    }
    public void setAbdocu_no(String abdocu_no) {
        this.abdocu_no = abdocu_no;
    }
    public String getAbdocu_b_no() {
        return abdocu_b_no;
    }
    public void setAbdocu_b_no(String abdocu_b_no) {
        this.abdocu_b_no = abdocu_b_no;
    }
    public String getAbdocu_t_no() {
        return abdocu_t_no;
    }
    public void setAbdocu_t_no(String abdocu_t_no) {
        this.abdocu_t_no = abdocu_t_no;
    }
    public String getErp_co_cd() {
        return erp_co_cd;
    }
    public void setErp_co_cd(String erp_co_cd) {
        this.erp_co_cd = erp_co_cd;
    }
    public String getEmp_cd() {
        return emp_cd;
    }
    public void setEmp_cd(String emp_cd) {
        this.emp_cd = emp_cd;
    }
    public String getPKEY() {
        return PKEY;
    }
    public void setPKEY(String pKEY) {
        PKEY = pKEY;
    }
    public String getEMP_TR_CD() {
        return EMP_TR_CD;
    }
    public void setEMP_TR_CD(String eMP_TR_CD) {
        EMP_TR_CD = eMP_TR_CD;
    }
    public String getKOR_NM() {
        return KOR_NM;
    }
    public void setKOR_NM(String kOR_NM) {
        KOR_NM = kOR_NM;
    }
    
    public String getDEPT_NM() {
        return DEPT_NM;
    }
    public void setDEPT_NM(String dEPT_NM) {
        DEPT_NM = dEPT_NM;
    }
    public String[] getStrDEPT_NM() {
        return strDEPT_NM;
    }
    public void setStrDEPT_NM(String[] strDEPT_NM) {
        this.strDEPT_NM = strDEPT_NM;
    }
    
    public String getRVRS_YM() {
        return RVRS_YM;
    }
    public void setRVRS_YM(String rVRS_YM) {
        RVRS_YM = rVRS_YM;
    }
    public String getSQ() {
        return SQ;
    }
    public void setSQ(String sQ) {
        SQ = sQ;
    }
    public String getGISU_DT() {
        return GISU_DT;
    }
    public void setGISU_DT(String gISU_DT) {
        GISU_DT = gISU_DT;
    }
    public String getPAY_DT() {
        return PAY_DT;
    }
    public void setPAY_DT(String pAY_DT) {
        PAY_DT = pAY_DT;
    }
    public String getTPAY_AM() {
        return TPAY_AM;
    }
    public void setTPAY_AM(String tPAY_AM) {
        TPAY_AM = tPAY_AM;
    }
    public String getSUP_AM() {
        return SUP_AM;
    }
    public void setSUP_AM(String sUP_AM) {
        SUP_AM = sUP_AM;
    }
    public String getVAT_AM() {
        return VAT_AM;
    }
    public void setVAT_AM(String vAT_AM) {
        VAT_AM = vAT_AM;
    }
    public String getINTX_AM() {
        return INTX_AM;
    }
    public void setINTX_AM(String iNTX_AM) {
        INTX_AM = iNTX_AM;
    }
    public String getRSTX_AM() {
        return RSTX_AM;
    }
    public void setRSTX_AM(String rSTX_AM) {
        RSTX_AM = rSTX_AM;
    }
    public String getETC_AM() {
        return ETC_AM;
    }
    public void setETC_AM(String eTC_AM) {
        ETC_AM = eTC_AM;
    }
    public String getACCT_NO() {
        return ACCT_NO;
    }
    public void setACCT_NO(String aCCT_NO) {
        ACCT_NO = aCCT_NO;
    }
    public String getPYTB_CD() {
        return PYTB_CD;
    }
    public void setPYTB_CD(String pYTB_CD) {
        PYTB_CD = pYTB_CD;
    }
    public String getDPST_NM() {
        return DPST_NM;
    }
    public void setDPST_NM(String dPST_NM) {
        DPST_NM = dPST_NM;
    }
    public String getBANK_NM() {
        return BANK_NM;
    }
    public void setBANK_NM(String bANK_NM) {
        BANK_NM = bANK_NM;
    }
    public String getRSRG_NO() {
        return RSRG_NO;
    }
    public void setRSRG_NO(String rSRG_NO) {
        RSRG_NO = rSRG_NO;
    }
    public String getPJT_NM() {
        return PJT_NM;
    }
    public void setPJT_NM(String pJT_NM) {
        PJT_NM = pJT_NM;
    }
    public String[] getStrPKEY() {
        return strPKEY;
    }
    public void setStrPKEY(String[] strPKEY) {
        this.strPKEY = strPKEY;
    }
    public String[] getStrEMP_TR_CD() {
        return strEMP_TR_CD;
    }
    public void setStrEMP_TR_CD(String[] strEMP_TR_CD) {
        this.strEMP_TR_CD = strEMP_TR_CD;
    }
    public String[] getStrKOR_NM() {
        return strKOR_NM;
    }
    public void setStrKOR_NM(String[] strKOR_NM) {
        this.strKOR_NM = strKOR_NM;
    }
    public String[] getStrRVRS_YM() {
        return strRVRS_YM;
    }
    public void setStrRVRS_YM(String[] strRVRS_YM) {
        this.strRVRS_YM = strRVRS_YM;
    }
    public String[] getStrSQ() {
        return strSQ;
    }
    public void setStrSQ(String[] strSQ) {
        this.strSQ = strSQ;
    }
    public String[] getStrGISU_DT() {
        return strGISU_DT;
    }
    public void setStrGISU_DT(String[] strGISU_DT) {
        this.strGISU_DT = strGISU_DT;
    }
    public String[] getStrPAY_DT() {
        return strPAY_DT;
    }
    public void setStrPAY_DT(String[] strPAY_DT) {
        this.strPAY_DT = strPAY_DT;
    }
    public String[] getStrTPAY_AM() {
        return strTPAY_AM;
    }
    public void setStrTPAY_AM(String[] strTPAY_AM) {
        this.strTPAY_AM = strTPAY_AM;
    }
    public String[] getStrSUP_AM() {
        return strSUP_AM;
    }
    public void setStrSUP_AM(String[] strSUP_AM) {
        this.strSUP_AM = strSUP_AM;
    }
    public String[] getStrVAT_AM() {
        return strVAT_AM;
    }
    public void setStrVAT_AM(String[] strVAT_AM) {
        this.strVAT_AM = strVAT_AM;
    }
    public String[] getStrINTX_AM() {
        return strINTX_AM;
    }
    public void setStrINTX_AM(String[] strINTX_AM) {
        this.strINTX_AM = strINTX_AM;
    }
    public String[] getStrRSTX_AM() {
        return strRSTX_AM;
    }
    public void setStrRSTX_AM(String[] strRSTX_AM) {
        this.strRSTX_AM = strRSTX_AM;
    }
    public String[] getStrETC_AM() {
        return strETC_AM;
    }
    public void setStrETC_AM(String[] strETC_AM) {
        this.strETC_AM = strETC_AM;
    }
    public String[] getStrACCT_NO() {
        return strACCT_NO;
    }
    public void setStrACCT_NO(String[] strACCT_NO) {
        this.strACCT_NO = strACCT_NO;
    }
    public String[] getStrPYTB_CD() {
        return strPYTB_CD;
    }
    public void setStrPYTB_CD(String[] strPYTB_CD) {
        this.strPYTB_CD = strPYTB_CD;
    }
    public String[] getStrDPST_NM() {
        return strDPST_NM;
    }
    public void setStrDPST_NM(String[] strDPST_NM) {
        this.strDPST_NM = strDPST_NM;
    }
    public String[] getStrBANK_NM() {
        return strBANK_NM;
    }
    public void setStrBANK_NM(String[] strBANK_NM) {
        this.strBANK_NM = strBANK_NM;
    }
    public String[] getStrRSRG_NO() {
        return strRSRG_NO;
    }
    public void setStrRSRG_NO(String[] strRSRG_NO) {
        this.strRSRG_NO = strRSRG_NO;
    }
    public String[] getStrPJT_NM() {
        return strPJT_NM;
    }
    public void setStrPJT_NM(String[] strPJT_NM) {
        this.strPJT_NM = strPJT_NM;
    }
 
}
 

