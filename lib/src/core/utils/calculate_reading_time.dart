int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\S+')).length;
  final readingTime = wordCount / 225;
  return readingTime.ceil();
}
