import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/wort.dart';
import '../repository/words_repository.dart';

class WortFindenRoute extends StatefulWidget {
  WortFindenRoute({super.key});

  @override
  State<WortFindenRoute> createState() => WorterFindenState();
}

class WorterFindenState extends State<WortFindenRoute> {
  final WorterRepository worterRepository = WorterRepository.instance;
  final searchFieldController = TextEditingController();
  final labelController = TextEditingController();

  String word = 'Es gibt kein wort ' '';
  bool isLoading = false;
  List<DataRow> tableRows = [];
  List<DataRow> pluralTableRows = [];

  void setWord(String word) {
    setState(() {
      this.word = word;
    });
  }

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void setTableRows(Word? word) {
    setState(() {
      if (word == null) {
        tableRows = [];
      } else {
        tableRows = [
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Nom.')),
              DataCell(Text('${indefinitiveArtikel(word)}/${word.artikel}')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Akk.')),
              DataCell(Text(akkusativArtikel(word))),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Dat.')),
              DataCell(Text(dativArtikel(word))),
            ],
          ),
        ];
      }
    });
  }

  void setPluralTableRows(Word? word) {
    setState(() {
      if (word == null) {
        pluralTableRows = [];
      } else {
        pluralTableRows = [
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Nom.')),
              DataCell(Text('die ${word.pluralForm}')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Akk.')),
              DataCell(Text('die ${word.pluralForm}')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              const DataCell(Text('Dat.')),
              DataCell(Text('den ${word.pluralForm}')),
            ],
          ),
        ];
      }
    });
  }

  String indefinitiveArtikel(Word word) {
    if (word.artikel == 'der' || word.artikel == 'das') {
      return 'ein';
    } else {
      return 'eine';
    }
  }

  String akkusativArtikel(Word word) {
    if (word.artikel == 'der') {
      return 'einen/den';
    } else if (word.artikel == 'das') {
      return 'ein/das';
    } else {
      return 'eine/die';
    }
  }

  String dativArtikel(Word word) {
    if (word.artikel == 'der') {
      return 'einem/dem';
    } else if (word.artikel == 'das') {
      return 'einem/dem';
    } else {
      return 'einer/der';
    }
  }

  String pluralArtikel(Word word) {
    if (word.artikel == 'der') {
      return 'eine/dem';
    } else if (word.artikel == 'das') {
      return 'einem/dem';
    } else {
      return 'einer/der';
    }
  }

  void wordLoad() {
    setLoading(true);
    String searchText = searchFieldController.value.text;
    Word? word = worterRepository
        .findOne(searchFieldController.value.text.toLowerCase());
    if (word != null) {
      setWord("${word.artikel} ${word.word}");
    } else {
      setWord("Es gibt kein wort '$searchText'");
    }
    setTableRows(word);
    setPluralTableRows(word);
    setLoading(false);
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('die Viehseuche')),
      const DataColumn(label: Text('Artikel'))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wort finden'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          const SizedBox(height: 0),
          Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(".*")),
                  ],
                  controller: searchFieldController,
                  onChanged: (String str) {
                    if (str.length >= 3) {
                      List<Word> words =
                          worterRepository.findWords(str.toLowerCase());
                      print(words);
                    }
                  },
                  onSubmitted: (String str) {
                    wordLoad();
                  },
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Search...',
                    prefixIcon: IconButton(
                        onPressed: () {
                          wordLoad();
                        },
                        icon: const Icon(Icons.search)),
                    suffix:
                        isLoading ? const CircularProgressIndicator() : null,
                  ))),
          const SizedBox(height: 20),
          Text(
            word,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(5),
            child: DataTable(
                headingRowHeight:
                    !word.toLowerCase().startsWith('es gibt') ? 20 : 0,
                headingTextStyle:
                    const TextStyle(color: Colors.black, fontSize: 20),
                dataTextStyle:
                    const TextStyle(color: Colors.grey, fontSize: 15),
                columns: _createColumns(),
                rows: tableRows),
          ),
          const SizedBox(height: 40),
          Text(
            !word.toLowerCase().startsWith('es gibt') ? 'Plural ' : '',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(5),
            child: DataTable(
                headingRowHeight:
                    !word.toLowerCase().startsWith('es gibt') ? 20 : 0,
                headingTextStyle:
                    const TextStyle(color: Colors.black, fontSize: 20),
                dataTextStyle:
                    const TextStyle(color: Colors.grey, fontSize: 15),
                columns: _createColumns(),
                rows: pluralTableRows),
          ),
        ],
      )),
    );
  }
}
