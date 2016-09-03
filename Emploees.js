// http://apps.timwhitlock.info/emoji/tables/unicode

var mail="\u2709 ";
var phone="📱 ";
var skype="📺 ";


var spreadsheet_id = "19Gz-krxdRX-9tIF2WQ0KTzK1OqKIxdozSgzuDVcRXus";
// var spreadsheet_id = "1C8ucPY9a7u7kNIupjTWrwe4E1d8IHKjf3UNYm2sRzCk";

function searchEmployeeByName(sheet_name, employee_name) {
  sheet_name = sheet_name || "ailove офис";
  employee_name = employee_name || "Екатерина";
  employee_name = employee_name.toLowerCase();
  
  var ss = SpreadsheetApp.open(DriveApp.getFileById(spreadsheet_id));
  
  var sheet = ss.getSheetByName(sheet_name);
  if(sheet == null) return "No sheet ", sheet_name;
  var column = 2; //column Index   
  var columnValues = sheet.getRange(2, 1, sheet.getLastRow(), sheet.getLastColumn()).getValues(); //1st is header row
  var result = [];
  for(var i=0; i<columnValues.length; i++) {
    //Logger.log(columnValues[i][0]);
    if(columnValues[i][column-1].toLowerCase().indexOf(employee_name)>=0) {
      result.push("<b>"+columnValues[i][1]+"</b>\n"+
                  "<i>"+columnValues[i][3]+"</i>\n"+
                  mail+columnValues[i][4]+"\n"+
                  phone+columnValues[i][5]+"\n"+
                  skype+columnValues[i][6]+"\n");
    }    
  }
  return result;
}

function searchEmployeeByDivision(sheet_name, division_name) {
  sheet_name = sheet_name || "ailove офис";
  division_name = division_name || "дизайн";
  division_name = division_name.toLowerCase();
  
  var ss = SpreadsheetApp.open(DriveApp.getFileById(spreadsheet_id));
  
  var sheet = ss.getSheetByName(sheet_name);
  if(sheet == null) return "No sheet ", sheet_name;
  var column = 8; //column Index   
  var columnValues = sheet.getRange(2, 1, sheet.getLastRow(), sheet.getLastColumn()).getValues(); //1st is header row
  var result = [];
  for(var i=0; i<columnValues.length; i++) {
    //Logger.log(columnValues[i][0]);
    if(columnValues[i][column-1].toLowerCase().indexOf(division_name)>=0) {
      result.push(""+columnValues[i][column-1]+"\n"+
                  "<b>"+columnValues[i][1]+"</b>\n"+
                  "<i>"+columnValues[i][3]+"</i>\n"+
                  mail+columnValues[i][4]+"\n"+
                  phone+columnValues[i][5]+"\n"+
                  skype+columnValues[i][6]+"\n");
    }    
  }
  return result;
}


function getListOfDivisions(sheet_name) {
  
  sheet_name = sheet_name || "ailove офис";
  
  var ss = SpreadsheetApp.open(DriveApp.getFileById(spreadsheet_id));
  
  var sheet = ss.getSheetByName(sheet_name);
  if(sheet == null) return "No sheet ", sheet_name;
  var column = 8; //column Index   
  var columnValues = sheet.getRange(2, 1, sheet.getLastRow(), sheet.getLastColumn()).getValues(); //1st is header row
  var set = {};
  for(var i=0; i<columnValues.length; i++) {
      set[columnValues[i][column-1].toLowerCase()] = "";
  }
  var result = [];
  for(var div in set) if (div.length >0) result.push(div);

  return result;
}


function searchEmployeeByPosition(sheet_name, position_name) {
  sheet_name = sheet_name || "ailove офис";
  position_name = position_name || "руков";
  position_name = position_name.toLowerCase();
  
  var ss = SpreadsheetApp.open(DriveApp.getFileById(spreadsheet_id));
  
  var sheet = ss.getSheetByName(sheet_name);
  if(sheet == null) return "No sheet ", sheet_name;
  var column = 4; //column Index   
  var columnValues = sheet.getRange(2, 1, sheet.getLastRow(), sheet.getLastColumn()).getValues(); //1st is header row
  var result = [];
  for(var i=0; i<columnValues.length; i++) {
    //Logger.log(columnValues[i][0]);
    if(columnValues[i][column-1].toLowerCase().indexOf(position_name)>=0) {
      result.push("<b>"+columnValues[i][1]+"</b>\n"+
                  "<i>"+columnValues[i][3]+"</i>\n"+
                  mail+columnValues[i][4]+"\n"+
                  phone+columnValues[i][5]+"\n"+
                  skype+columnValues[i][6]+"\n");
    }    
  }
  return result;
}

function searchEmployeeByPhone(sheet_name, employee_phone) {
  sheet_name = sheet_name || "ailove офис";
  employee_phone = employee_phone || "+7 (915) 000-00-00";
  employee_phone = employee_phone.replace(/[^\d]+/g,"")
  
  var ss = SpreadsheetApp.open(DriveApp.getFileById(spreadsheet_id));
  
  var sheet = ss.getSheetByName(sheet_name);
  if(sheet == null) return "No sheet ", sheet_name;
  var column = 5; //column Index   
  var columnValues = sheet.getRange(2, 1, sheet.getLastRow(), sheet.getLastColumn()).getValues(); //1st is header row
  var result = [];
  for(var i=0; i<columnValues.length; i++) {
    //Logger.log(columnValues[i][0]);
    var ph = columnValues[i][column-1].replace(/[^\d]+/g,"");
    if(ph.indexOf(employee_phone)>=0) {
      result.push("<b>"+columnValues[i][1]+"</b>\n"+
                  "<i>"+columnValues[i][3]+"</i>\n"+
                  mail+columnValues[i][4]+"\n"+
                  phone+columnValues[i][5]+"\n"+
                  skype+columnValues[i][6]+"\n");
      break;
    }    
  }
  Logger.log(result)
  return result;
}
