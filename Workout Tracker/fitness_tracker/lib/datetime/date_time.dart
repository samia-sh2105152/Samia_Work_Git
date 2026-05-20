//return todays date yymmdd
String todaysDateDDMMYYYY() {
  var dateTimeObject = DateTime.now();
  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }
  String ddmmYYYY = day + month + year;
  return ddmmYYYY;
}

DateTime createDateTimeObject(String ddmmyyyy) {
  int dd = int.parse(ddmmyyyy.substring(0, 2));
  int mm = int.parse(ddmmyyyy.substring(2, 4));
  int yyyy = int.parse(ddmmyyyy.substring(4, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

//convert string to DateTime object
String convertDateTimeToYYYYMMDD(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }
  String ddmmYYYY = day + month + year;
  return ddmmYYYY;
}
