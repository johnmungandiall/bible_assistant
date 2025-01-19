import 'dart:convert';

import 'package:bible_assistant/model.dart';
import 'package:bible_assistant/referencedata.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedVerse;
  late Future<List<String>> _booksFuture;
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    _booksFuture = _loadBooks();
  }

  Future<List<String>> _loadBooks() async {
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifest =
        Map<String, dynamic>.from(json.decode(manifestJson));
    return manifest.keys
        .where((String key) =>
            key.startsWith('assets/Bible-telugu-main/') &&
            key.endsWith('.json'))
        .map((String path) => path
            .replaceAll('assets/Bible-telugu-main/', '')
            .replaceAll('.json', ''))
        .toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Search Book',
            style: TextStyle(color: Color(0xFFE0E0E0))),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: referencedata.keys.length,
            itemBuilder: (context, index) {
              String letter = referencedata.keys.elementAt(index);
              return InkWell(
                onTap: () {
                  setState(() {
                    searchResults = referencedata[letter]!;
                  });
                  Navigator.pop(context);
                  _showSearchResults();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF90CAF9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSearchResults() {
    if (searchResults.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Search Results',
                  style: TextStyle(color: Color(0xFFE0E0E0))),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    searchResults[index],
                    style: const TextStyle(color: Color(0xFFE0E0E0)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Scroll to the selected book
                    // You'll need to implement the scrolling logic here
                  },
                );
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
              onPressed: () {
                Navigator.pop(context);
                _searchController.clear();
                _showSearchDialog();
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',
                  style: TextStyle(color: Color(0xFF90CAF9))),
            ),
          ],
        ),
      );
    }
  }  void _showVerseDialog(String verse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Selected Verse',
            style: TextStyle(color: Color(0xFFE0E0E0))),
        content: Text(verse, style: const TextStyle(color: Color(0xFFE0E0E0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Color(0xFF90CAF9))),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Color(0xFFEF5350)),
          const SizedBox(height: 16),
          Text('Error: $error',
              style: const TextStyle(color: Color(0xFFEF5350))),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF90CAF9)),
          SizedBox(height: 16),
          Text('Loading Bible content...',
              style: TextStyle(color: Color(0xFFE0E0E0))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text('Bible Assistant',
              style: TextStyle(color: Color(0xFFE0E0E0))),
          elevation: 2,
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E1E),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF90CAF9)),
              onPressed: _showSearchDialog,
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF90CAF9)),
              onPressed: () {
                // Implement settings
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF121212),
              ],
            ),
          ),
          child: FutureBuilder<List<String>>(
            future: _booksFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              }

              if (!snapshot.hasData) {
                return _buildLoadingWidget();
              }

              final books = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Welcome>(
                    future: DefaultAssetBundle.of(context)
                        .loadString(
                            'assets/Bible-telugu-main/${books[index]}.json')
                        .then((jsonStr) => welcomeFromJson(jsonStr)),
                    builder: (context, bookSnapshot) {
                      if (!bookSnapshot.hasData) {
                        return Card(
                          color: const Color(0xFF1E1E1E),
                          child: ListTile(
                            leading: const CircularProgressIndicator(
                                color: Color(0xFF90CAF9)),
                            title: Text('Loading ${books[index]}...',
                                style:
                                    const TextStyle(color: Color(0xFFE0E0E0))),
                          ),
                        );
                      }

                      final bookData = bookSnapshot.data!;
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: const Color(0xFF1E1E1E),
                        child: ExpansionTile(
                          leading:
                              const Icon(Icons.book, color: Color(0xFF90CAF9)),
                          title: Text(
                            bookData.book.telugu,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          subtitle: Text(
                            bookData.book.english,
                            style: const TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: 14,
                            ),
                          ),
                          children: bookData.chapters.map((chapter) {
                            return ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF90CAF9),
                                child: Text(
                                  chapter.chapter.toString(),
                                  style:
                                      const TextStyle(color: Color(0xFF1E1E1E)),
                                ),
                              ),
                              title: Text(
                                'Chapter ${chapter.chapter}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFE0E0E0)),
                              ),
                              children: chapter.verses.map((verse) {
                                return ListTile(
                                  leading: Text(
                                    verse.verse.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF90CAF9),
                                    ),
                                  ),
                                  title: Text(
                                    verse.text,
                                    style: const TextStyle(
                                      height: 1.5,
                                      color: Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  onTap: () {
                                    final verseText =
                                        '${bookData.book.english} ${chapter.chapter}:${verse.verse}\n${verse.text}';
                                    setState(() {
                                      selectedVerse = verseText;
                                    });
                                    _showVerseDialog(verseText);
                                  },
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ));
  }
}