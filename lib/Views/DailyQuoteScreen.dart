import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:quotesapp/models/quote.dart';

class DailyQuotePage extends StatefulWidget {
  @override
  _DailyQuotePageState createState() => _DailyQuotePageState();
}

class _DailyQuotePageState extends State<DailyQuotePage> {
  PageController _pageController = PageController();
  List<Quote> _quotes = [];
  late Quote currentQuote;
  bool isLoading = true;
  static const String baseUrl = 'https://quotesapp-838bd-default-rtdb.firebaseio.com'; // Adjust with your Firebase URL

  @override
  void initState() {
    super.initState();
    _getQuotesFromStorage();
  }

  Future<void> _getQuotesFromStorage() async {
    try {
      final List<Quote> localQuotes = await _fetchQuotes();
      setState(() {
        _quotes = localQuotes;
        currentQuote = _quotes.first;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching quotes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Quote>> _fetchQuotes() async {
    final List<Quote> quotes = [];

    try {
      final response = await http.get(Uri.parse('$baseUrl/quotes.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> quotesData = jsonDecode(response.body);
        if (quotesData.isNotEmpty) {
          quotesData.forEach((key, value) {
            Quote quote = Quote(
              quoteText: value['quoteText'],
              authorName: value['authorName'],
              backgroundColor: Color(value['backgroundColor']),
              quoteColor: Color(value['quoteColor']),
            );
            quotes.add(quote);
          });
        }
      } else {
        throw Exception('Failed to fetch quotes');
      }
    } catch (e) {
      print('Error fetching quotes: $e');
      throw Exception('Failed to fetch quotes');
    }

    return quotes;
  }

  Future<void> _addToFavorites() async {
    setState(() {
      if (!QuoteData.favoriteQuotes.contains(currentQuote)) {
        QuoteData.favoriteQuotes.add(currentQuote);
        _addQuoteToFavorites(currentQuote);
      } else {
        QuoteData.favoriteQuotes.remove(currentQuote);
        _removeQuoteFromFavorites(currentQuote);
      }
    });
  }

  Future<void> _addQuoteToFavorites(Quote quote) async {
    // Implement your logic to add quote to favorites
  }

  Future<void> _removeQuoteFromFavorites(Quote quote) async {
    // Implement your logic to remove quote from favorites
  }

  void _shareQuote(Quote quote) async {
    final whatsappUrl =
        "whatsapp://send?text=${Uri.encodeComponent('${quote.quoteText} - ${quote.authorName}')}";

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WhatsApp is not installed on your device'),
          ),
        );
      }
    } catch (e) {
      print('Error sharing quote: $e');
    }
  }

  void _getNewQuotes() {
    setState(() {
      _quotes.shuffle(); // Shuffle the list to get new random quotes
      currentQuote = _quotes.first; // Update currentQuote to the new first quote
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading Quotes...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentQuote.backgroundColor,
        title: Text('Quote of the Day'),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _quotes.length,
        onPageChanged: (index) {
          setState(() {
            currentQuote = _quotes[index];
          });
        },
        itemBuilder: (context, index) {
          final quote = _quotes[index];
          final isFavorite = QuoteData.favoriteQuotes.contains(quote);
          return Container(
            color: quote.backgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  quote.quoteText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: quote.quoteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '- ${quote.authorName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: quote.quoteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : quote.quoteColor,
                      ),
                      onPressed: _addToFavorites,
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: quote.quoteColor),
                      onPressed: () => _shareQuote(quote),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: quote.backgroundColor,
                    backgroundColor: quote.quoteColor,
                  ),
                  onPressed: _getNewQuotes,
                  child: Text('New Quotes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
