// fun to classify user in groups based on test marks
class Classifier{
  String classGroup(int totalMarks, int aMark, int bMark, int cMark) {
    if (totalMarks < 81) {
      if (aMark <= 27 && bMark <= 27 && cMark <= 27) {
        return 'Alpha 1';
      } else if (aMark <= 27 && bMark <= 27 && cMark > 27) {
        return 'Alpha 2';
      } else if (aMark <= 27 && bMark > 27 && cMark <= 27) {
        return 'Alpha 3';
      } else if (aMark <= 27 && bMark > 27 && cMark > 27) {
        return 'Alpha 4';
      } else if (aMark > 27 && bMark <= 27 && cMark <= 27) {
        return 'Alpha 5';
      } else if (aMark > 27 && bMark <= 27 && cMark > 27) {
        return 'Alpha 6';
      } else if (aMark > 27 && bMark > 27 && cMark <= 27) {
        return 'Alpha 7';
      }
    } else if (totalMarks >= 81) {
      if (aMark <= 27 && bMark <= 27 && cMark > 27) {
        return 'Beta 1';
      } else if (aMark <= 27 && bMark > 27 && cMark <= 27) {
        return 'Beta 2';
      } else if (aMark <= 27 && bMark > 27 && cMark > 27) {
        return 'Beta 3';
      } else if (aMark > 27 && bMark <= 27 && cMark <= 27) {
        return 'Beta 4';
      } else if (aMark > 27 && bMark <= 27 && cMark > 27) {
        return 'Beta 5';
      } else if (aMark > 27 && bMark > 27 && cMark <= 27) {
        return 'Beta 6';
      } else if (aMark > 27 && bMark > 27 && cMark > 27) {
        return 'Beta 7';
      }
    }
    return 'Nothing Assigned';
  }

}
