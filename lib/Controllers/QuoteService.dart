import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';
import '../models/quote.dart' as quote_data;

class QuoteService {
  static const String baseUrl = 'https://quotesapp-838bd-default-rtdb.firebaseio.com'; 
 
  static Future<void> saveInitialQuotes() async {
    try {
      for (int i = 0; i < quote_data.QuoteData.quoteList.length; i++) {
        final quote = quote_data.QuoteData.quoteList[i];
        final jsonBody = jsonEncode(quote.toJson());

        final response = await http.post(
          Uri.parse('$baseUrl/quotes_$i.json'),
          body: jsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          print('Quote $i uploaded successfully');
        } else {
          throw Exception('Failed to upload quote $i');
        }
      }
    } catch (e) {
      print('Error saving quotes: $e');
    }
  }

  static Future<List<quote_data.Quote>> fetchQuotes() async {
    final List<quote_data.Quote> quotes = [];

    try {
      for (int i = 0; i < quote_data.QuoteData.quoteList.length; i++) {
        final response = await http.get(Uri.parse('$baseUrl/quotes_$i.json'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> quoteData = jsonDecode(response.body);
          final quote = quote_data.Quote.fromJson(quoteData);
          quotes.add(quote);
        } else {
          throw Exception('Failed to fetch quote $i');
        }
      }
    } catch (e) {
      print('Error fetching quotes: $e');
    }

    return quotes;
  }

  static Future<void> removeQuoteFromFavorites(String quoteText) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/favorites.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> favoritesData = jsonDecode(response.body);
        final List<String> keys = favoritesData.keys.toList();

        for (var key in keys) {
          if (favoritesData[key]['quoteText'] == quoteText) {
            final deleteResponse = await http.delete(Uri.parse('$baseUrl/favorites/$key.json'));

            if (deleteResponse.statusCode == 200) {
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

  static addQuoteToFavorites(Quote quote) {}

  static fetchQuotesFromFirebase() {}
}
