function searchEmployeeByName(sheet_name, employee_name) {
  sheet_name = sheet_name || "ailove офис";
  employee_name = employee_name || "Екатерина";

  // WTF: http://stackoverflow.com/questions/35026731/pass-google-sheet-data-to-local-node-js-server-via-google-app-script
  //var ss = SpreadsheetApp.openById("1C8ucPY9a7u7kNIupjTWrwe4E1d8IHKjf3UNYm2sRzCk");
  var ss = SpreadsheetApp.open(DriveApp.getFileById("..."));
  
  var sheet = ss.getSheetByName(sheet_name);
  if(sheet == null) return "No sheet ", sheet_name;
  var column = 2; //column Index   
  var columnValues = sheet.getRange(2, 1, sheet.getLastRow(), sheet.getLastColumn()).getValues(); //1st is header row
  var result = [];
  for(var i=0; i<columnValues.length; i++) {
    //Logger.log(columnValues[i][0]);
    if(columnValues[i][column-1].indexOf(employee_name)>=0) {
      result.push("ФИО: "      +columnValues[i][1]+"\n"+
                  "Должность: "+columnValues[i][3]+"\n"+
                  "Почта: "    +columnValues[i][4]+"\n"+
                  "Скайп: "    +columnValues[i][6]+"\n"+
                  "Телефон: "  +columnValues[i][5]+"\n");
    }    
  }
  return result;
}
