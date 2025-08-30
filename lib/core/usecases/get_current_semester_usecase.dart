String getCurrentSemester() {
  final now = DateTime.now();
  final month = now.month;
  int thaiYear;

  String semester;

  if (month >= 6 && month <= 9) {
    // Semester 1: June - September
    thaiYear = now.year + 543;
    semester = "1/$thaiYear";
  } else if (month >= 10 || month == 1) {
    // Semester 2: October - January
    thaiYear = (month == 1) ? now.year - 1 + 543 : now.year + 543;
    semester = "2/$thaiYear";
  } else {
    // Summer: February - May
    thaiYear = now.year - 1 + 543;
    semester = "3/$thaiYear";
  }

  return semester;
}
