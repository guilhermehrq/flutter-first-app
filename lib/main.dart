import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

// StatelessWidget torna o app um widget(component)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Retorna um app com md
        title: 'Welcome to the Jungle',
        theme: new ThemeData.dark(),
        home: RandomWords());
  }
}

class RandomWordState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // Guarda os nomes que foram favoritados, Set<>() não permite que sejam repetidas
  final Set<WordPair> _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
            new IconButton(icon: const Icon(Icons.list), onPressed: _saved.length > 0 ? _pushSaved : null)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        // Adiciona um "container" ao final, onde é colocado o icon
        trailing: new Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  void _pushSaved() {
      Navigator.of(context).push(
          new MaterialPageRoute<void>(
              builder: (BuildContext context) {
                  final Iterable<ListTile> tiles = _saved.map(
                      (WordPair pair) {
                          return new ListTile(
                              title: new Text(
                                  pair.asPascalCase,
                                  style: _biggerFont,
                              )
                          );
                      }
                  );

                  final List<Widget> divided = ListTile
                    .divideTiles(
                      context: context,
                      tiles: tiles
                  )
                  .toList();

                  return new Scaffold(
                    appBar: new AppBar(
                      title: const Text('Saved Suggestions')
                    ),
                    body: new ListView(children: divided)
                  );
              }
          )
      );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() => new RandomWordState();
}
