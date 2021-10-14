import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // names filtered by search text

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Welcome to Flutter',
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Icon _searchIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text('Search Example');
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  var names = []; // names we get from API
  var filteredNames = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        leading: GestureDetector(
          onTap: () {
            // ignore: avoid_print
            print("Tapped");
            _searchPressed();
          },
          child: _searchIcon,
        ),
      ),
      body: _buildSuggestions(),
    );
  }

  _RandomWordsState() {
    _suggestions.addAll(generateWordPairs().take(1000));
    filteredNames = _suggestions;
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = List.from(_suggestions);
          print(_suggestions.length);
          // debugPrint(_suggestions.length);
        });
      } else {
        setState(() {
          filteredNames.clear();
          _searchText = _filter.text;
          for (var suggestion in _suggestions) {
            if (suggestion.asLowerCase.contains(_searchText.toLowerCase())) {
              debugPrint(suggestion.asPascalCase);
              filteredNames.add(suggestion);
            }
          }

          debugPrint(_searchText);
        });
      }
    });
  }
  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close);
        appBarTitle = TextField(
          controller: _filter,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        appBarTitle = const Text('Search Example');
        filteredNames = _suggestions;
        _filter.clear();
      }
    });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        itemCount: filteredNames.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(filteredNames[i]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
