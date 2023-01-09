package ac.g20.ex.vo;

/**
 * 
 * @title BudgetVO.java
 * @author doban7
 *
 * @date 2016. 10. 26.
 */
public class StateVO {
    
    private String LANGKIND = "KR";
    
    private String searchKeyword = "";
    
    private String searchYN ="";
    
    private String DATE_FROM ="";
    
    private String DATE_TO = "";
    
    private String FR_DT ="";
    
    private String TO_DT ="";

    private String CO_CD = "";
    private String CO_NM = "";
    
    private String DIV_CD ="";
    
    private String DIV_CDS ="";
    
    private String MGT_CD ="";
    
    private String MGT_CDS ="";
    
    private String MGT_CD_NM = "";
    
    private String BGT_NM = "";
    
    private String BGT_CD;

    private String BGT_CD_FROM = "";
    
    private String BGT_NM_FROM = "";
    
    private String BGT_CD_TO = "";
    
    private String BGT_NM_TO = "";
    
    private String DIV_FG ="";
    
    private String GR_FG ="";
    
    private String OPT12 ="1";
    
    private String OPT13 ="1";
    
    private String OPT14 ="1";
    
    private String ZEROLINE_FG = "1";
    
    private String GISU = "";
    
    private String BASE_DT = "";
    
    private String JOT_OPTION1 = "2";
    
    private String BGT_DIFF_S = "2";
    
    private String BGT_DIFF_D = "6";
    
    private String EMP_CD = "";
    
    private String FG_TY = "";
    
    private String BOTTOM_YN = "";
    
    private String BOTTOM_CD = "";
    
    private String BOTTOM_CDS = "";
    
    private String BOTTOM_NM = "";
    
    private String EXCEL_YN = "";
    
    private String target = "";
    
    private String DATE_FROMS ="";
    
    private String DATE_TOS ="";
    
    private String FR_DT_origin ="";
    
    private String TO_DT_origin ="";
    
    private String GISU_DT = "";
    
    private String SYS_CD_FROM = "";
    
    private String SYS_CD_TO = "";            

    /** 차수 추가 2014.05.26 lhy **/
    private String BGT_CNT = "1";
    
    /** 11/11 추가 duckyo **/
    private String DIV_NM = "";
    private String PJT_NM = "";
    private String PJT_CD = "";
    private String DEPT_NM = "";
    private String DEPT_CD = "";
    private String EMP_NM = "";
    private String ASSET_NM = "";
    private String ASSET_CD = "";
    private String DEFP_NM = "";
    private String DEFP_CD = "";
    private String DEFA_NM = "";
    private String DEFA_CD = "";
    private String DEFB_NM = "";
    private String DEFB_CD = "";
    private String DEFC_NM = "";
    private String DEFC_CD = "";
    private String DEFD_NM = "";
    private String DEFD_CD = "";
    private String IN_DT_FR = "";
    private String IN_DT_TO = "";
    
    private String DOC_MODE = "";
    
    public String getDIV_NM() {
		return DIV_NM;
	}

	public void setDIV_NM(String dIV_NM) {
		DIV_NM = dIV_NM;
	}

	public String getPJT_NM() {
		return PJT_NM;
	}

	public void setPJT_NM(String pJT_NM) {
		PJT_NM = pJT_NM;
	}

	public String getPJT_CD() {
		return PJT_CD;
	}

	public void setPJT_CD(String pJT_CD) {
		PJT_CD = pJT_CD;
	}

	public String getDEPT_NM() {
		return DEPT_NM;
	}

	public void setDEPT_NM(String dEPT_NM) {
		DEPT_NM = dEPT_NM;
	}

	public String getDEPT_CD() {
		return DEPT_CD;
	}

	public void setDEPT_CD(String dEPT_CD) {
		DEPT_CD = dEPT_CD;
	}

	public String getEMP_NM() {
		return EMP_NM;
	}

	public void setEMP_NM(String eMP_NM) {
		EMP_NM = eMP_NM;
	}

	public String getASSET_NM() {
		return ASSET_NM;
	}

	public void setASSET_NM(String aSSET_NM) {
		ASSET_NM = aSSET_NM;
	}

	public String getASSET_CD() {
		return ASSET_CD;
	}

	public void setASSET_CD(String aSSET_CD) {
		ASSET_CD = aSSET_CD;
	}

	public String getDEFP_NM() {
		return DEFP_NM;
	}

	public void setDEFP_NM(String dEFP_NM) {
		DEFP_NM = dEFP_NM;
	}

	public String getDEFP_CD() {
		return DEFP_CD;
	}

	public void setDEFP_CD(String dEFP_CD) {
		DEFP_CD = dEFP_CD;
	}

	public String getDEFA_NM() {
		return DEFA_NM;
	}

	public void setDEFA_NM(String dEFA_NM) {
		DEFA_NM = dEFA_NM;
	}

	public String getDEFA_CD() {
		return DEFA_CD;
	}

	public void setDEFA_CD(String dEFA_CD) {
		DEFA_CD = dEFA_CD;
	}

	public String getDEFB_NM() {
		return DEFB_NM;
	}

	public void setDEFB_NM(String dEFB_NM) {
		DEFB_NM = dEFB_NM;
	}

	public String getDEFB_CD() {
		return DEFB_CD;
	}

	public void setDEFB_CD(String dEFB_CD) {
		DEFB_CD = dEFB_CD;
	}

	public String getDEFC_NM() {
		return DEFC_NM;
	}

	public void setDEFC_NM(String dEFC_NM) {
		DEFC_NM = dEFC_NM;
	}

	public String getDEFC_CD() {
		return DEFC_CD;
	}

	public void setDEFC_CD(String dEFC_CD) {
		DEFC_CD = dEFC_CD;
	}

	public String getDEFD_NM() {
		return DEFD_NM;
	}

	public void setDEFD_NM(String dEFD_NM) {
		DEFD_NM = dEFD_NM;
	}

	public String getDEFD_CD() {
		return DEFD_CD;
	}

	public void setDEFD_CD(String dEFD_CD) {
		DEFD_CD = dEFD_CD;
	}

	public String getIN_DT_FR() {
		return IN_DT_FR;
	}

	public void setIN_DT_FR(String iN_DT_FR) {
		IN_DT_FR = iN_DT_FR;
	}

	public String getIN_DT_TO() {
		return IN_DT_TO;
	}

	public void setIN_DT_TO(String iN_DT_TO) {
		IN_DT_TO = iN_DT_TO;
	}

	public String getLANGKIND() {
        return LANGKIND;
    }

    public void setLANGKIND(String lANGKIND) {
        LANGKIND = lANGKIND;
    }

    public String getSearchYN() {
        return searchYN;
    }

    public void setSearchYN(String searchYN) {
        this.searchYN = searchYN;
    }

    public String getZEROLINE_FG() {
        return ZEROLINE_FG;
    }

    public void setZEROLINE_FG(String zEROLINE_FG) {
        ZEROLINE_FG = zEROLINE_FG;
    }

    public String getDATE_FROM() {
        return DATE_FROM;
    }

    public void setDATE_FROM(String dATE_FROM) {
        DATE_FROM = dATE_FROM;
    }

    public String getBGT_CD_TO() {
        return BGT_CD_TO;
    }

    public String getBGT_NM_TO() {
        return BGT_NM_TO;
    }

    public void setBGT_CD_TO(String bGT_CD_TO) {
        BGT_CD_TO = bGT_CD_TO;
    }

    public void setBGT_NM_TO(String bGT_NM_TO) {
        BGT_NM_TO = bGT_NM_TO;
    }

    public String getDATE_TO() {
        return DATE_TO;
    }

    public void setDATE_TO(String dATE_TO) {
        DATE_TO = dATE_TO;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public String getFR_DT() {
        return FR_DT;
    }

    public void setFR_DT(String fR_DT) {
        FR_DT = fR_DT;
    }

    public String getTO_DT() {
        return TO_DT;
    }

    public void setTO_DT(String tO_DT) {
        TO_DT = tO_DT;
    }

    public String getCO_CD() {
        return CO_CD;
    }

    public void setCO_CD(String cO_CD) {
        CO_CD = cO_CD;
    }

    public String getDIV_CD() {
        return DIV_CD;
    }

    public void setDIV_CD(String dIV_CD) {
        DIV_CD = dIV_CD;
    }

    public String getMGT_CD() {
        return MGT_CD;
    }

    public void setMGT_CD(String mGT_CD) {
        MGT_CD = mGT_CD;
    }

    public String getMGT_CD_NM() {
        return MGT_CD_NM;
    }

    public void setMGT_CD_NM(String mGT_CD_NM) {
        MGT_CD_NM = mGT_CD_NM;
    }

    public String getBGT_CD() {
        return BGT_CD;
    }

    public void setBGT_CD(String bGT_CD) {
        BGT_CD = bGT_CD;
    }

    
    public String getBGT_NM() {
        return BGT_NM;
    }

    public void setBGT_NM(String bGT_NM) {
        BGT_NM = bGT_NM;
    }

    
    public String getBGT_CD_FROM() {
        return BGT_CD_FROM;
    }

    public void setBGT_CD_FROM(String bGT_CD_FROM) {
        BGT_CD_FROM = bGT_CD_FROM;
    }

    public String getBGT_NM_FROM() {
        return BGT_NM_FROM;
    }

    public void setBGT_NM_FROM(String bGT_NM_FROM) {
        BGT_NM_FROM = bGT_NM_FROM;
    }

    public String getDIV_FG() {
        return DIV_FG;
    }

    public void setDIV_FG(String dIV_FG) {
        DIV_FG = dIV_FG;
    }

    public String getGR_FG() {
        return GR_FG;
    }

    public String getEMP_CD() {
        return EMP_CD;
    }

    public void setEMP_CD(String eMP_CD) {
        EMP_CD = eMP_CD;
    }

    public void setGR_FG(String gR_FG) {
        GR_FG = gR_FG;
    }

    public String getOPT12() {
        return OPT12;
    }

    public void setOPT12(String oPT12) {
        OPT12 = oPT12;
    }

    public String getOPT13() {
        return OPT13;
    }

    public String getBGT_DIFF_S() {
        return BGT_DIFF_S;
    }

    public void setBGT_DIFF_S(String bGT_DIFF_S) {
        BGT_DIFF_S = bGT_DIFF_S;
    }

    public String getBGT_DIFF_D() {
        return BGT_DIFF_D;
    }

    public void setBGT_DIFF_D(String bGT_DIFF_D) {
        BGT_DIFF_D = bGT_DIFF_D;
    }

    public void setOPT13(String oPT13) {
        OPT13 = oPT13;
    }

    public String getOPT14() {
        return OPT14;
    }

    public void setOPT14(String oPT14) {
        OPT14 = oPT14;
    }

    public String getGISU() {
        return GISU;
    }

    public void setGISU(String gISU) {
        GISU = gISU;
    }

    public String getBASE_DT() {
        return BASE_DT;
    }

    public void setBASE_DT(String bASE_DT) {
        BASE_DT = bASE_DT;
    }

    public String getJOT_OPTION1() {
        return JOT_OPTION1;
    }

    public void setJOT_OPTION1(String jOT_OPTION1) {
        JOT_OPTION1 = jOT_OPTION1;
    }

    public String getFG_TY() {
        return FG_TY;
    }

    public void setFG_TY(String fG_TY) {
        FG_TY = fG_TY;
    }

    public String getBOTTOM_YN() {
        return BOTTOM_YN;
    }

    public void setBOTTOM_YN(String bOTTOM_YN) {
        BOTTOM_YN = bOTTOM_YN;
    }

    public String getBOTTOM_CD() {
        return BOTTOM_CD;
    }

    public void setBOTTOM_CD(String bOTTOM_CD) {
        BOTTOM_CD = bOTTOM_CD;
    }

    public String getBOTTOM_NM() {
        return BOTTOM_NM;
    }

    public void setBOTTOM_NM(String bOTTOM_NM) {
        BOTTOM_NM = bOTTOM_NM;
    }

	public String getEXCEL_YN() {
		return EXCEL_YN;
	}

	public void setEXCEL_YN(String eXCEL_YN) {
		EXCEL_YN = eXCEL_YN;
	}
	
	public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public String getDATE_FROMS() {
        return DATE_FROMS;
    }

    public void setDATE_FROMS(String dATE_FROMS) {
    	DATE_FROMS = dATE_FROMS;
    }

    public String getDATE_TOS() {
        return DATE_TOS;
    }

    public void setDATE_TOS(String dATE_TOS) {
    	DATE_TOS = dATE_TOS;
    }

    public String getFR_DT_origin() {
        return FR_DT_origin;
    }

    public void setFR_DT_origin(String fR_DT_origin) {
        FR_DT_origin = fR_DT_origin;
    }

    public String getTO_DT_origin() {
        return TO_DT_origin;
    }

    public void setTO_DT_origin(String tO_DT_origin) {
        TO_DT_origin = tO_DT_origin;
    }

    public String getGISU_DT() {
        return GISU_DT;
    }

    public void setGISU_DT(String gISU_DT) {
        GISU_DT = gISU_DT;
    }

    public String getSYS_CD_FROM() {
        return SYS_CD_FROM;
    }

    public void setSYS_CD_FROM(String sYS_CD_FROM) {
        SYS_CD_FROM = sYS_CD_FROM;
    }

    public String getSYS_CD_TO() {
        return SYS_CD_TO;
    }

    public void setSYS_CD_TO(String sYS_CD_TO) {
        SYS_CD_TO = sYS_CD_TO;
    }

    public String getDIV_CDS() {
        return DIV_CDS;
    }

    public void setDIV_CDS(String dIV_CDS) {
        DIV_CDS = dIV_CDS;
    }

    public String getMGT_CDS() {
        return MGT_CDS;
    }

    public void setMGT_CDS(String mGT_CDS) {
        MGT_CDS = mGT_CDS;
    }

    public String getBOTTOM_CDS() {
        return BOTTOM_CDS;
    }

    public void setBOTTOM_CDS(String bOTTOM_CDS) {
        BOTTOM_CDS = bOTTOM_CDS;
    }

    public String getBGT_CNT() {
        return BGT_CNT;
    }

    public void setBGT_CNT(String bGT_CNT) {
        BGT_CNT = bGT_CNT;
    }

    public String getDOC_MODE() {
        return DOC_MODE;
    }

    public void setDOC_MODE(String dOC_MODE) {
        DOC_MODE = dOC_MODE;
    }

	public String getCO_NM() {
		return CO_NM;
	}

	public void setCO_NM(String cO_NM) {
		CO_NM = cO_NM;
	}
}
 

