import 'package:artikel/models/wort.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class WorterRepository {
  static final WorterRepository instance =
      WorterRepository._privateConstructor();

  List<Word> _words = [];

  WorterRepository._privateConstructor() {
    if (_words.isEmpty) {
      rootBundle.loadString("assets/nouns.csv").then((data) => _words =
          const CsvToListConverter()
              .convert(data)
              .where((element) =>
                  !element[1].toString().contains('Abkürzung') &&
                  !element[1].toString().contains('Toponym'))
              .map((e) => Word.fromList(e))
              .toList());
    }
  }

  List<Word> getAll() {
    return _words;
  }

  List<Word> findWords(String searchString) {
    return _words
        .where((element) => element.word.toLowerCase().startsWith(searchString))
        .toList();
  }

  Word? findOne(String searchString) {
    return binarySearchWord(_words, searchString, 0, _words.length - 1);
  }

  Word? binarySearchWord(List<Word> words, String search, int min, int max) {
    if (max >= min) {
      // If the element is present at the middle
      int mid = ((max + min) / 2).floor();
      int result = search.compareTo(words[mid].word.toLowerCase());
      if (result == 0) {
        return words[mid];
      } else if (result > 0) {
        return binarySearchWord(words, search, mid + 1, max);
      } else {
        return binarySearchWord(words, search, min, mid - 1);
      }
    }
    return null;
  }
}
