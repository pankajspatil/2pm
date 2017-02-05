package com.org.twopm.generic;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class Utils {
	
	public static String getString(Object param){
		return param == null ? "" : param.toString();
		
	}
	
	public static Integer getInt(Object param){
		return (param == null || param =="") ? new Integer(0) : Integer.parseInt(param.toString());
	}
	
	
	public static Double getFloat(Object param){
		return (param == null || param =="") ? new Double(0) : Double.parseDouble(param.toString());
	}
	
	public static Double getDouble(Object param){
		return (param == null || param =="") ? new Double(0) : Double.parseDouble(param.toString());
	}
	
	public static String[] getStringArray(Object param){
		return param == null ? new String[0] : (String[])param;
		
	}
	
	public static Integer[] getIntegerArray(Object param){
		Integer[] intArray = new Integer[0];
		String[] strArray = (String[])param;
		
		if(param != null){
			intArray = new Integer[((String[])param).length];
			for(int i=0; i < strArray.length; i++){
				intArray[i] = Integer.parseInt(strArray[i]); 
			}
		}
		return intArray;
	}
	
	public static String getValidCharge(Object param){
		return param != null ? (Float.parseFloat(param.toString()) > 0 ? param.toString() : "") : "";
		
	}
	
	public static String convertArrayToString(Object param){
		String ids = "";
		if(param != null){
			for(String paramValue : (String[])param){
				ids += paramValue + ",";
			}
			ids = ids.replaceAll(",$", "");
		}
		
		return ids;
	}
	
	public static String getWeekStartDate(Integer weekNumber){
		
		String weekDate;
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yy");
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.WEEK_OF_YEAR, weekNumber);        
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);		
		weekDate = sdf.format(cal.getTime());
		//System.out.println(weekDate);
		
		return weekDate;
	}
	
	public static Integer getWeekNumner(String date){
		
		Integer weekNumber = 0;
		
		try{
		if(date.equals("")){
			return weekNumber;
		}
			
		DateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
		Date passedDate = formatter.parse(date);

		Calendar cal = Calendar.getInstance();
		cal.setTime(passedDate);
		weekNumber = cal.get(Calendar.WEEK_OF_YEAR);
		}catch(Exception ex){
			ex.printStackTrace();
			System.out.println("Error While fetching week number for " + date);
		}
		return weekNumber;
	}

	public static JsonObject getJSONObjectFromString(String data){
		JsonParser jsonParser = new JsonParser();
		JsonObject jsonObject = (JsonObject)jsonParser.parse(data);
		
		return jsonObject;
	}
}
