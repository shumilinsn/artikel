import 'package:artikel/models/wort.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class WorterRepository {

  List<Word> words = [];

  Future<List<Word>> getAll() async {
    if (words.isEmpty) {
      final _rawData = await rootBundle.loadString("assets/nouns.csv");
      words = const CsvToListConverter()
          .convert(_rawData)
          .where((element) => !element[1].toString().contains('Abkürzung'))
          .map((e) => Word.fromList(e))
          .toList();
    }
    return words;
  }

  List<Word> findWords(String searchString) {
    return words
        .where((element) => element.word.startsWith(searchString))
        .toList();
  }

  Word? findOne(String searchString) {
    return binarySearchWord(
        words, searchString, 0, words.length - 1);
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
