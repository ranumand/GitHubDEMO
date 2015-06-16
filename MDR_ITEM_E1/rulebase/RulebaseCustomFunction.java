/**\
 ** ===========================================================================
 **
 ** Copyright (c) 2000 - 2008 - TIBCO Software Inc. All Rights Reserved.
 **
 ** This  work is  subject  to  U.S. and  international  copyright  laws  and
 ** treaties. No part  of  this  work may be  used,  practiced,  performed
 ** copied, distributed, revised, modified, translated,  abridged, condensed,
 ** expanded,  collected,  compiled,  linked,  recast, transformed or adapted
 ** without the prior written consent of TIBCO Software Inc. Any use or
 ** exploitation of this work without authorization could subject the
 ** perpetrator to criminal and civil liability.
 **
 ** ===========================================================================
 \**/

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import com.tibco.mdm.infrastructure.db.DBUtil;
import com.tibco.mdm.infrastructure.db.MqDebuggableStatement;
import com.tibco.mdm.infrastructure.logging.MqLog;
import com.tibco.mdm.infrastructure.propertymgr.MqPropertiesUtil;
import com.tibco.mdm.infrastructure.resourcebundle.MqResourceMgr;
import com.tibco.mdm.rulebase.IRulebase;
import com.tibco.mdm.repository.core.Catalog;
/**
 * Sample code which defines interface for custom rulebase functions
 */
public class RulebaseCustomFunction {

	
	private static final String CLASS_NAME = "RulebaseCustomFunction";
	
	
	
	/**
	 * Ems connection details
	 */

	private static final String ENVIORNMENT_NAME = "com.tibco.kroger.environment_name";
	private static final String ENVIORNMENT_PROD ="com.tibco.kroger.Skip_cyclic_chk_environment_name";

	// private static boolean initialized = false;
	private static HashMap<String, Method> rulebaseFunctions = new HashMap<String, Method>();

	/*
	 * An annotation to mark methods as valid rulebase functions. Only methods
	 * with this annotation will be callable from MDMs
	 */
	@Target( { ElementType.METHOD })
	@Retention(RetentionPolicy.RUNTIME)
	@Documented
	public @interface RulebaseFunction {
		String name();
	}

	public HashMap execCustomFunction(HashMap args) {
		String funcName = null;
		ArrayList argsList = null;
		Object retValue = null;
		HashMap retMap = new HashMap();
		HashMap inArgs = new HashMap();
		boolean isSuccess = true;
		String errorMsg = null;
		boolean isHelperClass = false;
		// get function name
		if (args.containsKey(IRulebase.FUNCTION_NAME)) {
			funcName = (String) args.get(IRulebase.FUNCTION_NAME);
		} else {
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG,
						"No custom function name found. ");
			retMap.put(IRulebase.FUNCTION_SUCCESS, new Boolean(false));
			retMap.put(IRulebase.FUNCTION_ERROR_MESSAGE,
					"No custom function name " + funcName + "found.");
			return retMap;
		}
		long st = System.currentTimeMillis();
		// get function arguments
		if (args.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argsList = (ArrayList) args.get(IRulebase.FUNCTION_ARGUMENTS);
			inArgs.put(IRulebase.FUNCTION_ARGUMENTS, argsList);
		} else {
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG,
						"No custom options arguments found");
		}

		// get function options
		if (args.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			HashMap options = (HashMap) args.get(IRulebase.FUNCTION_OPTIONS);
			inArgs.put(IRulebase.FUNCTION_OPTIONS, options);
		} else {
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG,
						"No custom function arguments found");
		}

		try {

			if (rulebaseFunctions.size() == 0) {
				synchronized (rulebaseFunctions) {
					if (rulebaseFunctions.size() == 0) {
						if (MqLog.active(MqLog.DEBUG))
							MqLog
									.log(CLASS_NAME, MqLog.DEBUG,
											"Initializing all custom rulebase functions.");
						initRulebaseFunctions();
					}
				}
			}
			Method m = rulebaseFunctions.get(funcName);
			if (m != null)
				retValue = m.invoke(this, inArgs);
			else {
				retMap = execNewCustomFunction(args);
				isHelperClass = true;
			}
			if (MqLog.active(MqLog.DEBUG))
				MqLog
						.log(
								CLASS_NAME,
								MqLog.DEBUG,
								"********************PERFORMANCE************************* Finished executing the function : "
										+ funcName
										+ " in time :"
										+ (System.currentTimeMillis() - st)
										+ " mSec");
		} catch (Exception e) {
			isSuccess = false;
			errorMsg = e.getMessage();
		}
		// Construct retMap
		if (!isHelperClass) {
			// Construct retMap
			retMap.put(IRulebase.FUNCTION_RETURN_VALUE, retValue);
			retMap.put(IRulebase.FUNCTION_SUCCESS, new Boolean(isSuccess));
			if (!isSuccess) {
				retMap.put(IRulebase.FUNCTION_ERROR_MESSAGE, errorMsg);
			}
		}
		if (MqLog.active(MqLog.DEBUG))
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"Finished calling the function isSucess: " + isSuccess
							+ " in time :" + (System.currentTimeMillis() - st)
							+ " mSec");
		return retMap;

	}

	/*
	 * Use introspection on this class to scan for valid rulebase functions
	 * (i.e. methods with the @RulebaseFunction annotation)
	 */
	protected void initRulebaseFunctions() {

		// hashmap with all valid rulebase function methods
		// rulebaseFunctions = new HashMap<String, Method>();

		// get all methods in this class first
		Method[] methods = this.getClass().getMethods();

		// now scan for methods with the @RulebaseFunction annotation
		for (Method m : methods) {
			String methodName = m.getName();
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG, "MethodName -- "
						+ methodName);
			Annotation a = m.getAnnotation(RulebaseFunction.class);
			if (a != null) {
				String rulename = ((RulebaseFunction) a).name();
				if (rulebaseFunctions.containsKey(rulename))
					throw new RuntimeException(
							"Duplicate function names are not allowed! ('"
									+ rulename + "'");

				// add the method and its name to the hashmap
				rulebaseFunctions.put(rulename, m);

				if (MqLog.active(MqLog.DEBUG))
					MqLog.log(CLASS_NAME, MqLog.DEBUG,
							"Found rulebase function by  Annotation: '"
									+ rulename + "'.");
				if (!methodName.equalsIgnoreCase(rulename))
					if (MqLog.active(MqLog.DEBUG))
						MqLog.log(CLASS_NAME, MqLog.DEBUG,
								"*****MISMATCH IN Annotation " + rulename
										+ " and Method name " + methodName
										+ ", please verify******");
			}
		}

	}

	/**
	 * 
	 * @param args
	 * @return
	 */
	private HashMap execNewCustomFunction(HashMap args) {

		HashMap result = null;
		try {
			String RULEBASE_LOCATION = "MDRITME1/rulebase";
			List argList = null;
			if (args.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
				argList = (ArrayList) args.get(IRulebase.FUNCTION_ARGUMENTS);
				if (argList != null && argList.size() > 0) {
					
					String enterpriseName = String.valueOf(argList.get(argList
							.size() - 1));
					RULEBASE_LOCATION = enterpriseName + "/rulebase";
				}
			} else {
				if (MqLog.active(MqLog.DEBUG))
					MqLog
							.log(
									CLASS_NAME,
									MqLog.DEBUG,
									"No custom function arguments found, setting Ruleabse helper to standard/rulebase");
			}
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG,
						"Start loading the Ruleabase helper from "
								+ RULEBASE_LOCATION);
			MqResourceMgr rMgr = MqResourceMgr
					.getResourceMgr(RULEBASE_LOCATION);
			// rMgr.refreshResources();
			String HELPER_CLASS_NAME = String.valueOf(argList.get(argList
					.size() - 2));
			Object myClass = rMgr.loadClass(HELPER_CLASS_NAME);
			// Object myClass =
			// Class.forName("D:/cim_code/commondir/hsb/rulebase/RulebaseCustomFunctionHelper.class");
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG, "begin executing "
						+ CLASS_NAME);
			Class[] parameterTypes = new Class[] { HashMap.class };
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"parameterTypes*** "
							+ parameterTypes.toString());
			Object[] argsNew = new Object[] { args };
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"argsNew*** "+args+"******88argsnew****"
							+ argsNew.toString());
			Method customFunction = null;
			customFunction = myClass.getClass().getDeclaredMethod(
					"execCustomFunction", parameterTypes);
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"customFunction*** "+customFunction.getName());
			result = (HashMap) customFunction.invoke(myClass, argsNew);
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG,
						"done executing NEW RulebaseCustomFunction. ");

		} catch (Exception e) {
			MqLog.log(CLASS_NAME, MqLog.ERROR,
					"Exception executing NEW RulebaseCustomFunction. "
							+ e.toString());
			e.printStackTrace();
		}
		return result;
	}
		@RulebaseFunction(name = "getEnviromentName")

    public String getEnviromentName(HashMap inArgs) throws Exception {
		String envName="";
		List argList = null;
        if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
              argList = (ArrayList)inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
              System.out.print("argList" +argList);
        } else {
              if (MqLog.active(MqLog.DEBUG))
                     MqLog.log(CLASS_NAME, MqLog.DEBUG,"No custom function arguments found");
        }
        
        String requestENV = String.valueOf(argList.get(0));
        System.out.print("requestENV " + requestENV);
		try { 
			if(requestENV.equalsIgnoreCase("ENVIORNMENT_NAME")){
				envName = MqPropertiesUtil.getStringProperty(ENVIORNMENT_NAME);
				System.out.print("envName " + envName);
			}else if(requestENV.equalsIgnoreCase("ENVIORNMENT_PROD")){
				envName = MqPropertiesUtil.getStringProperty(ENVIORNMENT_PROD);
			}
			System.out.print("envName end" +envName);
				if (MqLog.active(MqLog.DEBUG))
                    MqLog.log(CLASS_NAME, MqLog.DEBUG, "Environment Name: "+ envName);
							if(envName == null){
                                return "";
                            }

			}
		catch (Exception e) {
			if (MqLog.active(MqLog.ERROR))
				MqLog.log(CLASS_NAME, MqLog.ERROR, "Error while executing Property function: " + e.toString());
				throw e;
		}

		return envName;
	}
	@RulebaseFunction(name = "firstListContainsSec")
	public static boolean firstListContainsSec(HashMap inArgs) {
		String stringValue = "";
		List argList = null;
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"No custom function arguments found");
		}
		List<String> firstList = (ArrayList<String>) argList.get(0);
		Object obj = argList.get(1);
		// assuming that first list will always be populated..
		if (obj == null) {
			// as per req if second list is empty then return true;
			return true;
		}

		List<String> secondList = new ArrayList<String>();
		// check if its String or a List
		if (obj instanceof String) {
			if (obj.toString().isEmpty()) {
				return true;
			}
			secondList.add(obj.toString());
		} else {
			// it is list..
			// ideally this condition should never happen...
			if (((ArrayList) obj).isEmpty()) {
				return true;
			}
			secondList = (ArrayList<String>) obj;
		}

		for (String ele : secondList) {
			if (ele == null) {
				// assuming its bad data in list..have seen this while debugging
				// the function..
				continue;
			}
			if (!firstList.contains(ele)) {
				// if first list doesn't contains then return false..
				return false;
			}
		}
		// the above for loop is completed means all the elements for second
		// list contains is first
		return true;

	}
	@RulebaseFunction(name = "getAllItem")
	public List getAllItem(HashMap inArgs) {
		List<String> arrItem = new ArrayList<String>();
		List argList = null;
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"No custom function arguments found");
		}
		String strAllItem = (String) argList.get(0);
		String temp_arr[] = strAllItem.split(" ");
		for (int i = 0; i < temp_arr.length; i++) {
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG, "," + temp_arr[0]);
			arrItem.add(temp_arr[i]);
		}
		return arrItem;

	}
	@RulebaseFunction(name = "makeString")
	public String makeString(HashMap inArgs) {
		ArrayList argList = null;
		String retVal = new String("");
		List firstVal = null;
		try {
			// get function arguments
			if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
				argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
			} else {
				if (MqLog.active(MqLog.DEBUG))
					MqLog.log(CLASS_NAME, MqLog.DEBUG,
							"No custom function arguments found");
			}

			int argListSize = argList.size();
			// if (argListSize != 1) {
			// throw new Exception("Number of Arguments is wrong. ");
			// }

			if (argList.get(0) != null && argList.get(0) instanceof List) {
				firstVal = (List) argList.get(0);
				for (int i = 0; i < firstVal.size(); i++) {
					retVal = retVal + firstVal.get(i) + ",";
				}
				retVal = retVal.substring(0, retVal.length() - 1);
			} else if (argList.get(0) != null
					&& argList.get(0) instanceof String) {
				retVal = (String) argList.get(0);
			} else if (argList.get(0) != null && argList.get(0) instanceof Long) {
				retVal = ((Long) argList.get(0)).toString();
			}

			return retVal;

		} catch (Exception ex) {
			// TODO: handle exception
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG, ex.getMessage());
		}
		return null;
	}
	
	@RulebaseFunction(name = "UIValidation")
    
	public String UIValidation(HashMap inArgs) throws Exception {
		List argList = null;
		String decimalvalidationmsg= "";
		String hierarchyvalidationmsg="";
		
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log("UIValidation", MqLog.WARNING,
					"No custom function arguments found");
		}
 		
 		MqLog.log("UIValidation function", MqLog.DEBUG, "Entering UIValidation function");
 		
 		String ValueForDecimalValidate = (String) argList.get(0);
 		String ValueForHierarchyValidate = (String) argList.get(1);
 		MqLog.log("UIValidation function:", MqLog.DEBUG, ValueForDecimalValidate);
 		MqLog.log("UIValidation function:", MqLog.DEBUG, ValueForHierarchyValidate);
 		
 		String[] str_deci_array = ValueForDecimalValidate.split("_");
 		String decimalvalidationtype = str_deci_array[0]; 
 		
 		String[] str_hie_array = ValueForHierarchyValidate.split("_");
 		String hierarchyvalidationtype = str_hie_array[0]; 

 		
		// To check if the incoming string is of decimal type.
	 
		if  (decimalvalidationtype.equals("D")  )
		{
			// D_actualvalue_expecteddecimallength_Orignal		
			
			decimalvalidationmsg = decimalvalidation(str_deci_array);  
			MqLog.log("UIValidation function", MqLog.DEBUG, "Decimalvalidationmsg"+decimalvalidationmsg);				
		}	
		
		if  (hierarchyvalidationtype.equals("H")  )
		{
			// H_value_UOM_SV_PV_BaseUnit_Orignal				
			hierarchyvalidationmsg = HierarchyLevelvalidation(str_hie_array);	
			MqLog.log("UIValidation function", MqLog.DEBUG, "hierarchyvalidationmsg"+hierarchyvalidationmsg);	
			
		}
		    		
		
	return decimalvalidationmsg+" "+hierarchyvalidationmsg;
					
	}
	    
private String decimalvalidation(String[] str_array ) {
	//D_actualvalue_expecteddecimallength_Orignal	
	
	String validationmsg = "";
	String incomingvalue,  expecteddecimallength,mandatory;
	 
	incomingvalue = str_array[1].replaceFirst("\\.0*$|(\\.\\d*?)0+$", "$1");
	expecteddecimallength = str_array[2];
	mandatory = str_array[3];
		 
		 if (incomingvalue.isEmpty() && mandatory.equalsIgnoreCase("ALL"))
			{
				validationmsg = "Attribute should mandatory be defined" ;
				
				System.out.println("validationmsg:"+validationmsg);
				
				MqLog.log("UIValidation function", MqLog.DEBUG, "decimalyvalidationmsg"+validationmsg);	
			}
	
		 else if (incomingvalue.contains("."))
				
		 	{
		 		String[] actualdecimallength = incomingvalue.toString().split("\\.");	
				
				actualdecimallength[1].length();
														
				MqLog.log("UIValidation function", MqLog.DEBUG, "Actualdecimallength"+actualdecimallength[1].length());	
				
				int intactualdecimallength = Integer.valueOf(actualdecimallength[1].length());
				
				int intexpecteddecimallength = Integer.valueOf(expecteddecimallength);	
							
				if (intactualdecimallength>intexpecteddecimallength)
				{
				validationmsg = "Decimal Length of the attribute should not be more than "+expecteddecimallength ;
							
				}
		 	}
		 			
      return validationmsg; 
}

private String HierarchyLevelvalidation (String[] str_array ) {
	// H_value_UOM_SV_PV_BaseUnit_Orignal
	 String incomingvalue,uom,sv,pv,baseunit,original,root;
	 String validationmsg = ""; 
	 
	 incomingvalue = str_array[1]; 
	 uom = str_array[2];
	 sv = str_array[3];
	 pv = str_array[4];
	 baseunit = str_array[5];
	 root = str_array[6];
	 original = str_array[7];
	 
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "incomingvalue:"+incomingvalue);
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "uom:"+uom);
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "SV:"+sv);
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "PV:"+pv);
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "baseunit:"+baseunit);
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "root:"+root);
	 MqLog.log("UIValidation function:", MqLog.DEBUG, "original:"+original);
			
										
		 
	 	if(original.equalsIgnoreCase("ROOT") && root.equalsIgnoreCase("TRUE")&& incomingvalue.isEmpty() )
		{
			validationmsg="Please assign value at highest Item Hierarchy";
		}
		if(original.equalsIgnoreCase("PV") && pv.equalsIgnoreCase("TRUE")&& incomingvalue.isEmpty() )
		{
			validationmsg="Please assign value at PV level";
		}
		if(original.equalsIgnoreCase("SV") && sv.equalsIgnoreCase("TRUE") && incomingvalue.isEmpty() )
		{
			validationmsg="Please assign value at SV level";
		}
		if(original.equalsIgnoreCase("BU") && baseunit.equalsIgnoreCase("TRUE") && incomingvalue.isEmpty() )
		{
			validationmsg="Please assign value at BU level";
		}
		if(original.equalsIgnoreCase("PK") && uom.equalsIgnoreCase("PK") && incomingvalue.isEmpty() )
		{
			validationmsg="Please assign value at PK level";
		}
		if(original.equalsIgnoreCase("SVBU") )
		{
			if( sv.equalsIgnoreCase("TRUE") && incomingvalue.isEmpty() )
			{
				validationmsg="Please assign value at SV level";
			}
			else if( baseunit.equalsIgnoreCase("TRUE") && incomingvalue.isEmpty() )
			{
				validationmsg="Please assign value at BU level";
			}
		}
		if(original.equalsIgnoreCase("SVBUPK") )
		{
			if( sv.equalsIgnoreCase("TRUE") && incomingvalue.isEmpty() )
			{
				validationmsg="Please assign value at SV level";
			}
			else if( baseunit.equalsIgnoreCase("TRUE") && incomingvalue.isEmpty() )
			{
				validationmsg="Please assign value at BU level";
			}
			else if( uom.equalsIgnoreCase("PK") && incomingvalue.isEmpty() )
			{
				validationmsg="Please assign value at PK level";
			}
		}
		else if(original.equals("ALL") && incomingvalue.isEmpty() )
		{
			validationmsg="Please assign value at  "+uom+" level";
		}
		
	return validationmsg;  
}


		@RulebaseFunction(name = "matchPIDSVs")
	public String matchPIDSVs(HashMap inArgs)  throws Exception {
		List argList = null;
		
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"No custom function arguments found");
		}

		String orgName = (String) argList.get(0);
		String parentDSName = (String) argList.get(1);
		String childDSName = (String) argList.get(2);
		String PVItemID = (String) argList.get(3);
		MqLog.log("CustomFunction", MqLog.DEBUG,"****PVItemID 0 "+PVItemID);
		List<String> allBaseGtin = (ArrayList) argList.get(4);
		MqLog.log("CustomFunction", MqLog.DEBUG,"****allBaseGtin 0 "+allBaseGtin);
		String parentTable = getDFTableName(parentDSName, orgName);
		String childTable = getDFTableName(childDSName, orgName);
		String sql = "select citem_id from "
				+ ""
				+ parentTable
				+ " where citem_id in ("
				+ "                       select cchild_item_id from "
				+ childTable
				+ ""
				+ "                                           start with citem_id = "
				+ PVItemID
				+ " "
				+ "                                             connect by prior cchild_item_id = citem_id )"
				+ " and cSALES_VARIANT_FLG='Y'";

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		List<String> sVGTINList = new ArrayList<String>();
		try {
			con = DBUtil.getConnection();
			stmt = DBUtil.getStatement(con);
			rs = DBUtil.execSql(stmt, sql);
			while (rs != null && rs.next()) {
				sVGTINList.add(rs.getString(1));
				if (MqLog.active(MqLog.DEBUG))
					MqLog.log("CustomFunction", MqLog.DEBUG,
							" Sv For Logistic Variant " + PVItemID + " is :"
									+ rs.getString(1));
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			if (MqLog.active(MqLog.ERROR))
				MqLog.log("CustomFunction", MqLog.ERROR,
						" Error while getting DS name  : " + e.getMessage());
		} finally {
			DBUtil.closeResultSet(rs);
			DBUtil.closeStatement(stmt);
			DBUtil.closeConnection(con);
			
		}
		
		/* compare  sv start
		PID SV =1,2,3
		SV=1,2 
		AllCon=true
		someNotContains=false
		
		PID=1,2
		SV=1,2,3
		AllCon=false
		someNotContain=true*/
		
		
		boolean someNotContains=false,AllContains=false,someContains=false;	
		int baseGtinSize=allBaseGtin.size(),somenotcontain=0;
		MqLog.log("CustomFunction", MqLog.DEBUG,"****baseGtinSize 1 "+baseGtinSize);
		String reviewmsg;
				
		
		for(int i=0;i<baseGtinSize;i++)
		{
		MqLog.log("CustomFunction", MqLog.DEBUG,"****baseGtinSize 1 "+i);
			if(! sVGTINList.contains(allBaseGtin.get(i)))
			{
				somenotcontain+=1;				
			}
		}

		if(somenotcontain==0)
		{
			AllContains=true;
			reviewmsg ="The item submitted already exists in production. Please resubmit this item as a publication type of INITIAL LOAD";					
			
		}
		
		/* To Handle NPACK scenario for NEW Item */ 
		
		else if (baseGtinSize== 1 && allBaseGtin.get(0).toString().equals( PVItemID ))
		{
			reviewmsg ="The item submitted already exists in production. Please resubmit this item as a publication type of INITIAL LOAD";
		}
		
		else
		{
			/* if(somenotcontain==baseGtinSize)	
			{
				AllContains=false;				
			}
			*/
			someContains=true;
			AllContains=false;						
			reviewmsg = "The item submitted does not exactly match the GTIN we currently have on file. Please review and resubmit as a publication type of INITIAL LOAD. If you feel you have received this message by error, please send an email to KrogerProjectMercury@kroger.com";			
		}
				
		/* end */ 
		return reviewmsg;
	}
	
	
	@RulebaseFunction(name = "getHighestDesignation")
	public String getHighestDesignation(HashMap inArgs) throws Exception {
		List argList = null;
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"No custom function arguments found");
		}

		List<String> pkgDesignationList = (List) argList.get(0);
		List<String> lvItemIdList = (List) argList.get(1);
		String retParameter = (String) argList.get(2);
		int size = argList.size();

		String returnVal = "";
		try {
			if (pkgDesignationList != null && lvItemIdList != null) {
				// start from index 2 ..
				for (int i = 3; i < size; i++) {
					String incomingRec = (String) argList.get(i);
					if (lvItemIdList.indexOf(incomingRec) != -1) {
						if (retParameter.equalsIgnoreCase("LVID")) {
							returnVal = incomingRec;
						} else if (retParameter.equalsIgnoreCase("DESIGNATION")) {
							returnVal = pkgDesignationList.get(lvItemIdList
									.indexOf(incomingRec));
						}
						if (MqLog.active(MqLog.DEBUG))
							MqLog.log("CustomFunction", MqLog.DEBUG,
									" selected package designation is  "
											+ returnVal);
						break;
					}
				}
			} else {
				if (MqLog.active(MqLog.DEBUG))
					MqLog.log("CustomFunction", MqLog.DEBUG,
							" array provided in the inpt are blank  ");
			}
		} catch (Exception e) {
			e.printStackTrace();
			if (MqLog.active(MqLog.ERROR))
				MqLog.log("CustomFunction", MqLog.ERROR,
						" Error while getting Highest PID designation  : "
								+ e.getMessage());
		}
		return returnVal;
	}
	@RulebaseFunction(name = "readEventDescFromTable")
	public String readEventDescFromTable(HashMap inArgs) throws Exception {

		Connection con = null;
		MqDebuggableStatement stmt = null;
		ResultSet rs = null;
		ArrayList argList = null;
		String EventDesc = new String();
		String DocSubType = null;

		MqLog.log(CLASS_NAME, MqLog.DEBUG,
				"Inside readEventDescFromTable function..");
		Long temp;
		if (inArgs.containsKey("FUNC_ARGUMENTS")) {
			argList = (ArrayList) inArgs.get("FUNC_ARGUMENTS");
		} else {
			return null;
		}
		DocSubType = (String) argList.get(0);
		java.sql.Date date = new java.sql.Date(new Date().getTime());
		MqLog.log(CLASS_NAME, MqLog.DEBUG,
				"readEventDescFromTable..: DocSubType.." + DocSubType);

		try {
			con = DBUtil.getConnection();
			MqLog.log(CLASS_NAME, MqLog.DEBUG, "before execute " + stmt);
			String getString = "select description from domainentry where VALUE= ?";
			stmt = new MqDebuggableStatement(con, getString);
			stmt.setString(1, DocSubType);
			MqLog.log(CLASS_NAME, MqLog.DEBUG, "before execute2 " + stmt);
			rs = stmt.executeQuery();
			while (rs.next()) {
				EventDesc = rs.getString(1);
				MqLog.log(CLASS_NAME, MqLog.DEBUG, "in loop..EventDesc"
						+ EventDesc);
				break;
			}
			if (EventDesc != null && EventDesc != "") {
				MqLog.log(CLASS_NAME, MqLog.DEBUG, "before return..EventDesc"
						+ EventDesc);
				return EventDesc;
			}
			return null;
		} catch (Exception e) {
			if (MqLog.active(MqLog.ERROR))
				MqLog.log(CLASS_NAME, MqLog.ERROR,
						"Error while executing readEventDescFromTable function: "
								+ e.toString());
			throw e;
		} finally {
			DBUtil.closeResultSet(rs);
			DBUtil.closeStatement(stmt);
			DBUtil.closeConnection(con);
		}
	}
	@RulebaseFunction(name = "getCICReviewMessage")
	public String getCICReviewMessage(HashMap inArgs) throws Exception {

        ArrayList argList = null;

        // get function arguments
        if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
            argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
        } else {
            MqLog.log(this, MqLog.WARNING, "No custom function arguments found");
        }
        List<String> listOfGtins = (List) argList.get(0);
        List<String> listOfProductTypes = (List) argList.get(1);
        StringBuilder message = new StringBuilder("\nItem details:") ;
        int cnt=0;
        for(String productType:listOfProductTypes){
            message.append("\n").append(productType).append(" = ").append(listOfGtins.get(cnt++));
        }
        return message.toString();
    }
	/**
	 * This Method will get the Actual DataSource TableName
	 * 
	 * @param dsName
	 * @param OrgName
	 * @return
	 */
	@RulebaseFunction(name = "getDFTableName")
	public String getDFTableName(HashMap inArgs)
	{

		if (MqLog.active(MqLog.DEBUG))
			MqLog.log(CLASS_NAME, MqLog.DEBUG,"*******************getDFTableName():Invoked function*******************");
		
		try 
		{
			List argList = null;
			if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) 
			{
				argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
			} 
			else 
			{
				if (MqLog.active(MqLog.DEBUG))
					MqLog.log(CLASS_NAME, MqLog.DEBUG,"No custom function arguments found");
			}
			
			String dsName = String.valueOf(argList.get(0));
			String OrgName = String.valueOf(argList.get(1));
			if (MqLog.active(MqLog.DEBUG))
			{
				MqLog.log(CLASS_NAME, MqLog.DEBUG,"*******************getDFTableName():dsName *******************"+dsName);
				MqLog.log(CLASS_NAME, MqLog.DEBUG,"*******************getDFTableName():OrgName *******************"+OrgName);
			}
			
			return getDFTableName( dsName,  OrgName);
			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			if (MqLog.active(MqLog.ERROR))
				MqLog.log(CLASS_NAME, MqLog.ERROR," Error while getting getDFTableName  : " + e.getMessage());
		} 
		return null;
	}
	public String getDFTableName(String dsName, String OrgName) {

		if (MqLog.active(MqLog.DEBUG))
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"Inside getDFTableName  DataSource*********" + dsName);
		if (MqLog.active(MqLog.DEBUG))
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"Inside getDFTableName OrgName*********" + OrgName);

		String getDFSql = "select 'DF'||'_'||sourceorganizationid||'_'||id||'_TAB' from datafragment where name = '"
				+ dsName
				+ "'"
				+ " and SOURCEORGANIZATIONID=(select ID from organization where name='"
				+ OrgName + "')" + "AND ACTIVE='Y'";

		if (MqLog.active(MqLog.DEBUG))
			MqLog.log(CLASS_NAME, MqLog.DEBUG,
					"Inside getDFTableName *********getDFSql --" + getDFSql);

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String tableName = null;
		try {
			con = DBUtil.getConnection();
			stmt = DBUtil.getStatement(con);
			rs = DBUtil.execSql(stmt, getDFSql);
			if (rs != null && rs.next()) {
				tableName = rs.getString(1);
			}
			if (MqLog.active(MqLog.DEBUG))
				MqLog.log(CLASS_NAME, MqLog.DEBUG, "getDFTableName ***"
						+ tableName);
			return tableName;
		} catch (Exception e) {
			e.printStackTrace();
			if (MqLog.active(MqLog.ERROR))
				MqLog.log(CLASS_NAME, MqLog.ERROR,
						" Error while getting DS name  : " + e.getMessage());
		} finally {
			DBUtil.closeResultSet(rs);
			DBUtil.closeStatement(stmt);
			DBUtil.closeConnection(con);
		}
		return tableName;
	}
	@RulebaseFunction(name = "convertStringToArray")
	public ArrayList<String> convertStringToArray(HashMap inArgs) throws Exception {
		List argList = null;
		String strinput = null;
		String delimeter = null;
		ArrayList<String> objarrlist = new ArrayList<String>();
		
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"No custom function arguments found");
		}
		
		try
		{
		  strinput = String.valueOf(argList.get(0));
		  delimeter = String.valueOf(argList.get(1));
		  if((strinput != null) && (delimeter != null))
		  {
			  StringTokenizer stok = new StringTokenizer(strinput, delimeter);
	            
				while (stok.hasMoreElements()) {
					objarrlist.add(stok.nextElement().toString());
				}  
		  }
		}
		catch(Exception e)
		{
		  if (MqLog.active(MqLog.ERROR))
				MqLog.log(
						CLASS_NAME,
						MqLog.ERROR,
						" Error in converStringToArray func : "
								+ e.getMessage());
		}
		
		return objarrlist;
	}
	@RulebaseFunction(name = "mergeArrays")
	public List mergeArrays(HashMap inArgs) {
		List argList = null;
		if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
			argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
		} else {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"No custom function arguments found");
		}

		List retList = new ArrayList();
		// This function will merge all the arrays with unique values in it
		try {
			for (int cnt = 0; cnt < argList.size(); cnt++) {
				// assuming it will always be arraylist
				List list = (ArrayList) argList.get(cnt);
				if (list != null && list.size() > 0) {
					for (int innerCnt = 0; innerCnt < list.size(); innerCnt++) {
						String val = String.valueOf(list.get(innerCnt));
						if (!val.equalsIgnoreCase("null")
								&& !retList.contains(val)) {
							retList.add(val);
						}
					}
				}
			}
		} catch (Throwable e) {
			MqLog.log(CLASS_NAME, MqLog.WARNING,
					"error while executing mergerArray custom function"
							+ e.getCause());
		}
		return retList;
	}
	 @RulebaseFunction(name = "listContainsValue")
	    public boolean listContainsValue(HashMap inArgs) throws Exception {
	        List argList = null;
	        if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
	            argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
	        } else {
	            MqLog.log(CLASS_NAME, MqLog.WARNING,
	                    "No custom function arguments found");
	        }
	        List newList = null;

	        Object ob =   argList.get(0);
	        if(!(ob instanceof  List))
	        {
	            String value = (String)argList.get(0);
	            MqLog.log(CLASS_NAME, MqLog.DEBUG,
	                    "List has single Value " +value);
	            newList = new ArrayList();
	            newList.add(value);

	        }
	        else
	        {
	            newList = (List) argList.get(0);
	        }
	        MqLog.log(CLASS_NAME, MqLog.DEBUG,"List Value " +newList);
	        int compareSize = argList.size();
	        for(int i=1;i<compareSize;i++)
	        {
	            String value = (String)argList.get(i);
	            MqLog.log(CLASS_NAME, MqLog.DEBUG,"Values to compare in list" +value);
	            if(newList.contains(value))
	                return true;
	        }

	        return false;
	    }
		@RulebaseFunction(name = "getIndexValue")
		public static String getIndexValueFromArray(HashMap inArgs) {
			List argList = null;

			if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
				argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
			} else {
				MqLog.log(CLASS_NAME, MqLog.WARNING,
						"No custom function arguments found");
			}
			int index = Integer.parseInt(String.valueOf(argList.get(0)));
			List<String> array = (ArrayList) argList.get(1);
			if (array != null && !array.isEmpty()) {
				try {
					return array.get(index);
				} catch (Exception e) {
					// mostly this will have index out of bound exception.. ignore
					// it
					if (MqLog.active(MqLog.ERROR))
						MqLog.log(CLASS_NAME, MqLog.ERROR,
								"getIndexValueFromArray : exception : "
										+ e.getMessage());
				}
			}
			return "";
		}
		@RulebaseFunction(name = "isSubSetArray")
		public boolean isSubSetArray(HashMap inArgs) throws Exception
		{
			
			  if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "-----call isSubSetArray function ----");
			
			try 
			{			
				List argList = null;				
				List<String> listOfGtinsA ,listOfGtinsB;
				argList = (ArrayList) inArgs.get(0);
				
				if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) 
				{
					argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
				} else 
				{
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "No custom function arguments found");
				
					return false;
				}
				
				int argListSize = argList.size();
				
				if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "argListSize ****** "+argListSize);
				
				if (argListSize < 2)
				{
					throw new Exception("Number of Arguments is wrong. ");
				}
				
				if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "condition ****** ");
				
				if (argList.get(0) != null && argList.get(1) != null  )
				{
					
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "convert start ****** ");
					
					
					listOfGtinsA = (List) argList.get(0);
					
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "convert start 2****** ");
					
					listOfGtinsB = (List) argList.get(1);

					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "convert done ****** ");
					
					int count=0;
					
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, " listOfGtinsA ****** "+listOfGtinsA.size());
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, " listOfGtinsB ****** "+listOfGtinsB.size());
					
					
					
					for (String fval: listOfGtinsA) 
					{
						if (MqLog.active(MqLog.DEBUG))
							{
							MqLog.log(CLASS_NAME, MqLog.DEBUG, "loop Astart done ****** ");
							MqLog.log(CLASS_NAME, MqLog.DEBUG, "fval ****** "+fval);
							}
						
						for (String sval: listOfGtinsB) 
						{

							if (MqLog.active(MqLog.DEBUG))
								{
								MqLog.log(CLASS_NAME, MqLog.DEBUG, "loop Bstart done ****** ");
								MqLog.log(CLASS_NAME, MqLog.DEBUG, "sval ****** "+sval);
								MqLog.log(CLASS_NAME, MqLog.DEBUG, "sval | fval ****** "+sval+"*****|*****"+fval);
								
								}
							
							if(fval.equals(sval))
									count++;
							
							if (MqLog.active(MqLog.DEBUG))
								MqLog.log(CLASS_NAME, MqLog.DEBUG, "loop count ****** "+count);
							
						}
					}
					
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, " count ****** "+count);
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, " listOfGtinsA ****** "+listOfGtinsA.size());
					
					if(count==listOfGtinsA.size())
						return true;
					else
						return false;
				}
			}
			catch (Exception e)
			{
				
				if (MqLog.active(MqLog.ERROR))
				   MqLog.log(CLASS_NAME, MqLog.ERROR, "Error while executing isSubSetArray() : " + e.toString());
			
				throw e;
			}      
			return false; 
		}

		@RulebaseFunction(name = "fetchRecordState")
		public String fetchRecordState(HashMap inArgs) throws Exception
		{
			
			  if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "-----call fetchRecordState function ----");
			  String recordstate =null;
			try 
			{			
				List argList = null;	
				argList = (ArrayList) inArgs.get(0);				
				if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) 
				{
					argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
				} else 
				{
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "No custom function arguments found");
				
					return null;
				}
				
				int argListSize = argList.size();
				
				if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "argListSize ****** "+argListSize);
				
				if (argListSize < 3)
				{
					throw new Exception("Number of Arguments is wrong. ");
				}
				
				if (MqLog.active(MqLog.DEBUG)) MqLog.log(CLASS_NAME, MqLog.DEBUG, "condition ****** ");
				
			
					
				if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "convert start ****** ");
				
				String productID = (String) argList.get(0);
				String CatalogName= (String) argList.get(1);
				String orgId= (String) argList.get(2);
				Catalog catalog_detail = Catalog.getInstance(Integer.valueOf(orgId), CatalogName);
				if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "GET CATALOGDETAILS ****** ");
				
					
				MqLog.log("CustomFunction", MqLog.DEBUG,"****productID =  "+productID);
				String sql = "select PKEY1.state " +
						"FROM "+catalog_detail.getTableName() +" mct1, " +
						"mdmuser.principalKey pkey1   " +
						"WHERE " +
						"pkey1.catalogid = ? AND " +
						"pkey1.productkeyid = mct1.cproductkeyid AND " +
						"pkey1.modversion = mct1.cmodversion AND  " +
						"( pkey1.modversion IN  " +
						"	(" +
						"	SELECT max(modversion) " +
						"	from  " +
						"	mdmuser.principalkey pkey2  " +
						"	WHERE pkey2.catalogid = pkey1.catalogid AND " +
						"	pkey2.productkeyid = pkey1.productkeyid " +
						"	) " +
						") AND " +
						"pkey1.active = 'Y' and " +
						"cproductid = ?";

					Connection con = null;
					
					ResultSet rs = null;
					MqDebuggableStatement stmt = null;
					if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, " CATALOGDETAILS ****** ");
					try {
						
						con = DBUtil.getConnection();						
						stmt = new MqDebuggableStatement(con, sql);
						
						if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "catalog_detail.getID() ****** "+catalog_detail.getID());						
											
						stmt.setLong(1, catalog_detail.getID());
						
						if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "productID ****** "+productID);					
						stmt.setString(2, productID);
						rs = stmt.executeQuery();
						if (MqLog.active(MqLog.DEBUG))
							MqLog.log("CustomFunction", MqLog.DEBUG,
									"get recordstate = ");
						if (rs != null && rs.next()) 
						{
							recordstate=rs.getString(1);
							
							if (MqLog.active(MqLog.DEBUG))
								MqLog.log("CustomFunction", MqLog.DEBUG,
										" recordstate = " + recordstate);
						}
						
						
					} catch (Exception e) {
						e.printStackTrace();
						if (MqLog.active(MqLog.ERROR))
							MqLog.log("CustomFunction", MqLog.ERROR,
									" Error while getting fetchRecordState  : " + e.getMessage());
					} finally {
						DBUtil.closeResultSet(rs);
						DBUtil.closeStatement(stmt);
						DBUtil.closeConnection(con);
						
					}
				return recordstate;
			}
			catch (Exception e)
			{
				
				if (MqLog.active(MqLog.ERROR))
				   MqLog.log(CLASS_NAME, MqLog.ERROR, "Error while executing fetchRecordState() : " + e.toString());
			
				throw e;
			}     
			
		}
		@RulebaseFunction(name = "mergeValues")
		public List mergeValues(HashMap inArgs) {
			List argList = null;
			if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
				argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
			} else {
				MqLog.log(CLASS_NAME, MqLog.WARNING,
						"No custom function arguments found");
			}

			List retList = new ArrayList();
			// This function will merge all the arrays with unique values in it
			try {
				for (int cnt = 0; cnt < argList.size(); cnt++) 
				{
					MqLog.log(CLASS_NAME, MqLog.WARNING," mergeValues :  ");
					// assuming it will always be arraylist
					MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ..."+cnt);
					Object obj = argList.get(cnt);
					if(obj!=null)
					{
						MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ... "+obj.getClass());
						if (obj instanceof Long) 
						{
							
							MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...Long ");
							String val=((Long)argList.get(cnt)).toString();
							MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...val = "+val);
							
							if (!(val.isEmpty()) && !val.equalsIgnoreCase("null") && !retList.contains(val)) 
							{
								retList.add(val);
							}						
						}
						else if (obj instanceof String) 
						{
							MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...string ");
							String val=(String)argList.get(cnt);
							MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...val = "+val);
							if (!(val.isEmpty()) && !val.equalsIgnoreCase("null") && !retList.contains(val)) 
							{
								retList.add(val);
							}						
						}
						else if (obj instanceof ArrayList)
						{
							MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...strArrayListing ");
									List list = (ArrayList) argList.get(cnt);
									if (list != null && list.size() > 0) 
									{
										for (int innerCnt = 0; innerCnt < list.size(); innerCnt++)
										{
											String val = String.valueOf(list.get(innerCnt));
											MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...val = "+val);
											if (!val.equalsIgnoreCase("null") && !retList.contains(val)) 
											{
												retList.add(val);
											}
										}
									}
						}
					}
				}
			} catch (Throwable e) 
			{
							MqLog.log(CLASS_NAME, MqLog.WARNING,
									"error while executing mergerArray custom function"
											+ e.getCause());
			}
						MqLog.log(CLASS_NAME, MqLog.WARNING,"mergeArrays ...retList = "+retList);
						return retList;
			}
	}	