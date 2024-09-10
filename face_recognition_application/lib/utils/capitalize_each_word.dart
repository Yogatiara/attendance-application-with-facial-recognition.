String capitalizeEachWord(String text) {
  if (text.isEmpty) {
    return text;
  }

  List<String> words = text.split(' ');
  List<String> capitalizedWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).toList();

  return capitalizedWords.join(' ');
}
