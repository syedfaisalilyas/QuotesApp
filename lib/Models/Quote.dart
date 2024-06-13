import 'package:flutter/material.dart';

class Quote {
  String quoteText;
  String authorName;
  Color backgroundColor;
  Color quoteColor;

  Quote({
    required this.quoteText,
    required this.authorName,
    required this.backgroundColor,
    required this.quoteColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'quoteText': quoteText,
      'authorName': authorName,
      'backgroundColor': backgroundColor.value,
      'quoteColor': quoteColor.value,
    };
  }

  static Quote fromJson(Map<String, dynamic> json) {
    return Quote(
      backgroundColor: Color(json['backgroundColor']),
      quoteColor: Color(json['quoteColor']),
      quoteText: json['quoteText'],
      authorName: json['authorName'],
    );
  }
}

class QuoteData {
  static List<Quote> favoriteQuotes = [];

  static List<Quote> quoteList = [
    Quote(
      backgroundColor: Colors.purple,
      quoteColor: Colors.white,
      quoteText: 'The only limit to our realization of tomorrow is our doubts of today.',
      authorName: 'Franklin D. Roosevelt',
    ),
    Quote(
      backgroundColor: Colors.blue,
      quoteColor: Colors.white,
      quoteText: 'The purpose of our lives is to be happy.',
      authorName: 'Dalai Lama',
    ),
    Quote(
      backgroundColor: Colors.green,
      quoteColor: Colors.white,
      quoteText: 'Life is what happens when you’re busy making other plans.',
      authorName: 'John Lennon',
    ),
    Quote(
      backgroundColor: Colors.orange,
      quoteColor: Colors.black,
      quoteText: 'Get busy living or get busy dying.',
      authorName: 'Stephen King',
    ),
    Quote(
      backgroundColor: Colors.purple,
      quoteColor: Colors.white,
      quoteText: 'You only live once, but if you do it right, once is enough.',
      authorName: 'Mae West',
    ),
    Quote(
      backgroundColor: Colors.yellow,
      quoteColor: Colors.black,
      quoteText: 'Many of life’s failures are people who did not realize how close they were to success when they gave up.',
      authorName: 'Thomas A. Edison',
    ),
    Quote(
      backgroundColor: Colors.pink,
      quoteColor: Colors.white,
      quoteText: 'If you want to live a happy life, tie it to a goal, not to people or things.',
      authorName: 'Albert Einstein',
    ),
    Quote(
      backgroundColor: Colors.cyan,
      quoteColor: Colors.black,
      quoteText: 'Never let the fear of striking out keep you from playing the game.',
      authorName: 'Babe Ruth',
    ),
    Quote(
      backgroundColor: Colors.teal,
      quoteColor: Colors.white,
      quoteText: 'Money and success don’t change people; they merely amplify what is already there.',
      authorName: 'Will Smith',
    ),
    Quote(
      backgroundColor: Colors.lime,
      quoteColor: Colors.black,
      quoteText: 'Your time is limited, don’t waste it living someone else’s life.',
      authorName: 'Steve Jobs',
    ),
  ];
}
