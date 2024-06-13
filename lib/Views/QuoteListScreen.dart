import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quotesapp/models/quote.dart';

class QuoteListScreen extends StatefulWidget {
  @override
  _QuoteListScreenState createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  List<Quote> filteredQuotes = List.from(QuoteData.quoteList);
  bool isLoading = true;
  static const String baseUrl = 'https://quotesapp-838bd-default-rtdb.firebaseio.com'; // Adjust with your Firebase URL

  @override
  void initState() {
    super.initState();
    _getQuotesFromFirebase();
  }

  Future<void> _getQuotesFromFirebase() async {
    try {
      final List<Quote> fetchedQuotes = await _fetchQuotes();
      setState(() {
        QuoteData.quoteList.clear();
        QuoteData.quoteList.addAll(fetchedQuotes);
        filteredQuotes = List.from(QuoteData.quoteList);
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

  void _filterQuotes(String query) {
    setState(() {
      filteredQuotes = QuoteData.quoteList
          .where((quote) =>
              quote.quoteText.toLowerCase().contains(query.toLowerCase()) ||
              quote.authorName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote List'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search Quotes',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _filterQuotes,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredQuotes.length,
                      itemBuilder: (context, index) {
                        final quote = filteredQuotes[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[200], // Background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quote.quoteText,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '- ${quote.authorName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
