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

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

import com.tibco.mdm.infrastructure.db.DBUtil;
import com.tibco.mdm.infrastructure.db.MqDebuggableStatement;
import com.tibco.mdm.infrastructure.logging.MqLog;
import com.tibco.mdm.rulebase.IRulebase;
/**
 * Created with IntelliJ IDEA.
 * User: Hardeep Singh Bhatia
 * Date: 11/1/13
 * Time: 2:38 PM
 * To change this template use File | Settings | File Templates.
 */
/**
/**
 * Sample code which defines interface for custom rulebase functions
 */
public class RulebaseCustomFunctionHelper{

	private static final String CLASS_NAME="RulebaseCustomFunctionHelper";

    private static HashMap<String, Method> rulebaseFunctions;
    
    public HashMap execCustomFunction(HashMap args) {
        String funcName = null;
        ArrayList argsList = null;
        Object retValue = null;
        HashMap retMap = new HashMap();
        HashMap inArgs = new HashMap();
        boolean isSuccess = true;
        String errorMsg = null;

        // get function name
        if (args.containsKey(IRulebase.FUNCTION_NAME)) {
            funcName = (String) args.get(IRulebase.FUNCTION_NAME);
        } else {
            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME,MqLog.DEBUG, "No custom function name found. ");
            retMap.put(IRulebase.FUNCTION_SUCCESS, new Boolean(false));
            retMap.put(IRulebase.FUNCTION_ERROR_MESSAGE, "No custom function name " + funcName + "found.");
            return retMap;
        }

        // get function arguments
        if (args.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
            argsList = (ArrayList) args.get(IRulebase.FUNCTION_ARGUMENTS);
            inArgs.put(IRulebase.FUNCTION_ARGUMENTS, argsList);
        } else {
            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME,MqLog.DEBUG, "No custom options arguments found");
        }

        // get function options
        if (args.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
            HashMap options = (HashMap) args.get(IRulebase.FUNCTION_OPTIONS);
            inArgs.put(IRulebase.FUNCTION_OPTIONS, options);
        } else {
            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME,MqLog.DEBUG, "No custom function arguments found");
        }

        try {
            if (rulebaseFunctions == null) {
                if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "Initializing all custom rulebase functions.");
                initRulebaseFunctions();
            }
            else
                if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "Preloaded custom rulebase functions." + rulebaseFunctions);

            Method m = rulebaseFunctions.get(funcName.toUpperCase());

            if(m!=null)
                retValue = m.invoke(this,inArgs ) ;
            else {
                // can not find the function
                isSuccess = false;
                errorMsg = "Can not find the custom function " + funcName + " for enterprise. ";
            }

        } catch (Exception e) {
            isSuccess = false;
            errorMsg = e.getMessage();
        }
        // Construct retMap
        retMap.put(IRulebase.FUNCTION_RETURN_VALUE, retValue);
        retMap.put(IRulebase.FUNCTION_SUCCESS, new Boolean(isSuccess));
        if (!isSuccess) {
            retMap.put(IRulebase.FUNCTION_ERROR_MESSAGE, errorMsg);
        }
        if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "Finished calling the function isSucess: " + isSuccess);
        return retMap;

    }

    protected void initRulebaseFunctions() {

        // hashmap with all valid rulebase function methods
        rulebaseFunctions = new HashMap<String, Method>();

        // get all methods in this class first
        Method[] methods = this.getClass().getMethods();

        // now scan for methods with the @RulebaseFunction annotation
        for (Method m : methods) {
            String methodName   = m.getName().toUpperCase() ;
            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "MethodName -- " + methodName);

            if (rulebaseFunctions.containsKey(methodName))
            {
                if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG,"Duplicate function names are not allowed! ('" + methodName + "') skipping adding to the init List.");
            }
            else {
            // add the method and its name to the hashmap
            rulebaseFunctions.put(methodName, m);

            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "Adding rulebase function by  method name (ignoreCase): '(" + methodName + "') to the init List.");
            }
        }
    }
  /**
     * @param inArgs
     * @return
     */
    public List convertDelimitedStringToArray(HashMap inArgs){
    	
    	 List argList = null;
    	 String string = null;        
         if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
             argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
         } else {
             if (MqLog.active(MqLog.DEBUG)) MqLog.log(CLASS_NAME, MqLog.DEBUG,
                     "No custom function arguments found");
         }
         
         try {
			if (argList.get(0) != null && argList.get(0) instanceof String) {
				string = (String) argList.get(0);
				if (argList.get(1) != null && argList.get(1) instanceof String) {
					String delimiter = (String) argList.get(1);
					Object[] array = string.split(delimiter);
					List asList = new ArrayList();
					for (Object object : array) {
						asList.add(object);
					}									
					return asList;
				}
			}
		} catch (Exception e) {
			if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG,
                    "convertDelimitedStringToArray : Exception while converting array: "
                            + argList.get(0));
			e.printStackTrace();
		}
		return Arrays.asList(string);    	
    }
	 public boolean checkIsCyclicRelationship(HashMap inArgs) throws Exception{
        boolean retValue=false;
        Connection con = null;
        Statement stmt  = null;
        ResultSet rs  = null;
        MqDebuggableStatement stmtNew = null;
        if (MqLog.active(MqLog.DEBUG))
            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "-----check Is Cyclic Relationship ----");
        try {

            List argList = null;
            if (inArgs.containsKey(IRulebase.FUNCTION_ARGUMENTS)) {
                argList = (ArrayList) inArgs.get(IRulebase.FUNCTION_ARGUMENTS);
            } else {
                if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "No custom function arguments found");
            }
            int pk =   Integer.parseInt(String.valueOf(argList.get(0)));
            //int modversion =   Integer.parseInt(String.valueOf(argList.get(1)));
            String query = "SELECT leve1A.parentid," +
                    "  leve1A.childid, " +
                    "  leve1A.parentversion, " +
                    "  leve1A.childVersion " +
                    " FROM RELATIONSHIP leve1A, " +
                    "  RELATIONSHIP leve1B " +
                    " WHERE leve1A.active='Y' " +
                    " AND leve1B.active  ='Y' " +
                    " AND leve1A.parentid=leve1B.childid " +
                    " AND leve1B.parentid=leve1A.childid " +
                    " AND leve1A.parentversion=leve1B.parentversion " +
                    " AND leve1A.parentid=?  " +
                    " UNION " +
                    /* "-----Level 2 " +
                    "---- A-B A " +
                    "---- B-C B " +
                    "---- C-A C " +*/
                    " SELECT leve1A.parentid, " +
                    "  leve1A.childid, " +
                    "  leve1A.parentversion, " +
                    "  leve1A.childVersion " +
                    " FROM RELATIONSHIP leve1A, " +
                    "  RELATIONSHIP leve1B, " +
                    "  RELATIONSHIP leve1C " +
                    " WHERE leve1A.active='Y' " +
                    " AND leve1B.active  ='Y' " +
                    " AND leve1C.active  ='Y' " +
                    " AND leve1A.parentid=leve1C.childid " +
                    " AND leve1A.childid =leve1B.parentid " +
                    " AND leve1B.childid =leve1C.parentid " +
                    " AND leve1A.parentversion=leve1C.parentversion " +
                    " AND leve1A.parentid=? " +
                    " UNION  " +
                    /* "-----Level 3 " +
                    "---- A-B A " +
                    "---- B-C B " +
                    "---- C-D C " +
                    "---- D-A D " +*/
                    " SELECT leve1A.parentid, " +
                    "  leve1A.childid, " +
                    "  leve1A.parentversion, " +
                    "  leve1A.childVersion " +
                    " FROM RELATIONSHIP leve1A, " +
                    "  RELATIONSHIP leve1B, " +
                    "  RELATIONSHIP leve1C, " +
                    "  RELATIONSHIP leve1D " +
                    " WHERE leve1A.active='Y' " +
                    " AND leve1B.active  ='Y' " +
                    " AND leve1C.active  ='Y' " +
                    " AND leve1D.active  ='Y' " +
                    " AND leve1A.parentid=leve1D.childid " +
                    " AND leve1A.childid =leve1B.parentid " +
                    " AND leve1B.childid =leve1C.parentid " +
                    " AND leve1C.childid =leve1D.parentid " +
                    " AND leve1A.parentversion=leve1D.parentversion " +
                    " AND leve1A.parentid=? " +
                    " UNION  " +
                    /* "-----Level 3 " +
                    "---- A-B A " +
                    "---- B-C B " +
                    "---- C-D C " +
                    "---- D-E D " +
                    "---- E-A E " +*/
                    " SELECT leve1A.parentid, " +
                    "  leve1A.childid, " +
                    "  leve1A.parentversion, " +
                    "  leve1A.childVersion " +
                    " FROM RELATIONSHIP leve1A, " +
                    "  RELATIONSHIP leve1B, " +
                    "  RELATIONSHIP leve1C, " +
                    "  RELATIONSHIP leve1D, " +
                    "  RELATIONSHIP leve1E " +
                    " WHERE leve1A.active='Y' " +
                    " AND leve1B.active  ='Y' " +
                    " AND leve1C.active  ='Y' " +
                    " AND leve1D.active  ='Y' " +
                    " AND leve1E.active  ='Y' " +
                    " AND leve1A.parentid=leve1E.childid " +
                    " AND leve1A.childid =leve1B.parentid " +
                    " AND leve1B.childid =leve1C.parentid " +
                    " AND leve1C.childid =leve1D.parentid " +
                    " AND leve1D.childid =leve1E.parentid  " +
                    " AND leve1A.parentversion=leve1E.parentversion " +
                    " AND leve1A.parentid=?" ;

            query = DBUtil.setFirstParam(query, pk) ;
            query = DBUtil.setFirstParam(query, pk) ;
            query = DBUtil.setFirstParam(query, pk) ;
            query = DBUtil.setFirstParam(query, pk) ;
            if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "SQL query : " + query);
            con = DBUtil.getConnection() ;
            stmt = DBUtil.getStatement(con);
            rs = stmt.executeQuery(query) ;

            int noOfRecords=0;

            while (rs.next()){

                noOfRecords++;
                if(noOfRecords == 1)
                {
                    query = "update relationship set active='N' where parentid=? and childid=? and parentversion=? and childversion=?";
                    stmtNew = new MqDebuggableStatement(con, query);
                }
                int pid =   rs.getInt(1);
                int cid =   rs.getInt(2);
                int pVersion =   rs.getInt(3);
                int cVersion =   rs.getInt(4);
                if (MqLog.active(MqLog.DEBUG))  MqLog.log(CLASS_NAME, MqLog.DEBUG, "Found Cyclic relatiosnhip for pID:"+pid+" cid:"+cid+" pVersion:"+pVersion+" cVersion:"+cVersion);
                stmtNew.setInt(1,pid);
                stmtNew.setInt(2,cid);
                stmtNew.setInt(3,pVersion);
                stmtNew.setInt(4,cVersion);
                stmtNew.addBatch();
            }
            if(stmtNew!=null)
            {
                stmtNew.executeBatch();
                retValue=true;
            }
        } catch (Exception e) {
            if (MqLog.active(MqLog.ERROR))
                MqLog.log(CLASS_NAME, MqLog.ERROR, "Error while executing checkIsCyclicRelationship() : " + e.toString());
            throw e;
        }finally{
            DBUtil.closeStatement(stmtNew);
            DBUtil.closeResultSet(rs);
            DBUtil.closeStatement(stmt);
            DBUtil.closeConnection(con);
        }
        return  retValue ;
    }
	}	