import 'dart:math' as math;

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
}
