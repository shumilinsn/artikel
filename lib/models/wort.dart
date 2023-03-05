class Word {
  final String word;
  final String artikel;
  final String pluralForm;

  Word(this.word, this.artikel, this.pluralForm);

  static Word fromList(List<dynamic> data) {
    String articleCode = data[2].toString();
    String article;
    if (articleCode == 'm') {
      article = 'der';
    } else if (articleCode == 'f') {
      article = 'die';
    } else {
      article = 'das';
    }
    String word = data[0].toString();
    String plural = data[16].toString();
    return Word(word, article, plural.isNotEmpty ? plural : word);
  }
}
