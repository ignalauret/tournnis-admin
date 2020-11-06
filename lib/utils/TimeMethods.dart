class TimeMethods {

  static const List<String> days = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sáb", "Dom"];
  static const List<String> months = ["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"];

  static String parseDate(DateTime date) {
    final weekday = days[date.weekday];
    final day = date.day;
    final month = months[date.month];
    final hour = date.hour;
    final minutes = date.minute == 0 ? "00" : date.minute;
    return "$weekday $day $month, $hour:$minutes hs";
  }
}