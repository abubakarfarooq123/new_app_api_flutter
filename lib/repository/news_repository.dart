import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:new_app/models/categories_news_model.dart';

import '../models/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetNewsChannelData()async{

    String url = 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=be2b7510dc734252b0f61c3d5dd44ba7';
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body.toString());
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String newsChannel) async {
    String newsUrl = 'https://newsapi.org/v2/top-headlines?sources=$newsChannel&apiKey=be2b7510dc734252b0f61c3d5dd44ba7';
    if (kDebugMode) {
      print(newsUrl);
    }
    final response = await http.get(Uri.parse(newsUrl));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }



  Future<CategoriesNewsModel> fetchCategoriesNewsModel(String category) async {
    String newsUrl = 'https://newsapi.org/v2/everything?q=$category&apiKey=be2b7510dc734252b0f61c3d5dd44ba7';
    if (kDebugMode) {
      print(newsUrl);
    }
    final response = await http.get(Uri.parse(newsUrl));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }
}