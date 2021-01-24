import 'dart:math' as math;

import 'package:tournnis_admin/utils/constants.dart';

class Utils {
  static double log2(num x) => math.log(x) / math.log(2);

  static int pow2(num x) => math.pow(2, x);

  // Returns the index of the match that the winner will play.
  static int getNextMatchIndex(int index) {
    return (index / 2).ceil() - 1;
  }

// Returns 0 if next match the name mast go on top, and 1 otherwise.
  static int getNextMatchPosition(int index) {
    return (index + 1) % 2;
  }

  static String formatDate(DateTime date) {
    final day = date.day;
    final month = date.month;
    final year = date.year;
    return "$day/$month/$year";
  }

  static int getPlayOffPointsFromIndex(int index) {
    if (index == -1) return Constants.kPlayOffPoints[0];
    if (index == 0) return Constants.kPlayOffPoints[1];
    if (index <= 2) return Constants.kPlayOffPoints[2];
    if (index <= 6) return Constants.kPlayOffPoints[3];
    return Constants.kPlayOffPoints[4];
  }
}
