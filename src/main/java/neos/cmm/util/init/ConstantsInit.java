package neos.cmm.util.init;

import neos.cmm.util.NeosConstants;

public class ConstantsInit {
	public static void init() {
		String osType = System.getProperty("os.name") ;
		if(osType.length()>7 && osType.substring(0,7).equals("Windows")){
			NeosConstants.SERVER_OS = "windows" ;
		}else {
			NeosConstants.SERVER_OS = "linux" ;
		}
	}
}
