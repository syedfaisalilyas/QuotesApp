import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotesapp/models/quote.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Quote> favoriteQuotes = [];
  bool isLoading = true;
  static const String baseUrl = 'https://quotesapp-838bd-default-rtdb.firebaseio.com';

  @override
  void initState() {
    super.initState();
    _getFavoritesFromStorage();
  }

  Future<void> _getFavoritesFromStorage() async {
    try {
      final List<Quote> fetchedFavorites = await _fetchFavorites();
      setState(() {
        favoriteQuotes = fetchedFavorites;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching favorites: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Quote>> _fetchFavorites() async {
    final List<Quote> favorites = [];

    try {
      final response = await http.get(Uri.parse('$baseUrl/favorites.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> favoritesData = jsonDecode(response.body);
        if (favoritesData.isNotEmpty) {
          favoritesData.forEach((key, value) {
            Quote quote = Quote(
              quoteText: value['quoteText'],
              authorName: value['authorName'],
              backgroundColor: Color(value['backgroundColor']),
              quoteColor: Color(value['quoteColor']),
            );
            favorites.add(quote);
          });
        }
      } else {
        throw Exception('Failed to fetch favorites');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      throw Exception('Failed to fetch favorites');
    }

    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading Favorites...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteQuotes.isEmpty
          ? Center(
              child: Text(
                'No favorite quotes yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = favoriteQuotes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        quote.quoteText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '- ${quote.authorName}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeFromFavorites(quote.quoteText, index),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _removeFromFavorites(String quoteText, int index) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/favorites.json'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> favoritesData = jsonDecode(response.body);
        final List<String> keys = favoritesData.keys.toList();

        for (var key in keys) {
          if (favoritesData[key]['quoteText'] == quoteText) {
            final deleteResponse =
                await http.delete(Uri.parse('$baseUrl/favorites/$key.json'));

            if (deleteResponse.statusCode == 200) {
              setState(() {
                favoriteQuotes.removeAt(index);
              });
              print('Quote removed from favorites');
              return;
            } else {
              throw Exception('Failed to remove quote from favorites');
            }
          }
        }
      } else {
        throw Exception('Failed to fetch favorites');
      }
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }
}
