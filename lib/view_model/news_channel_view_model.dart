import 'package:new_app/models/categories_news_model.dart';
import 'package:new_app/models/news_channel_headlines_model.dart';
import 'package:new_app/repository/news_repository.dart';

class NewsViewModel{
  final _repo = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetNewsChannelData() async{
    final response = await _repo.fetNewsChannelData() ;
    return response ;
  }
  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi(String channelName) async{
    final response = await _repo.fetchNewsChannelHeadlinesApi(channelName);
    return response ;
  }
  
  Future<CategoriesNewsModel> fetchCategoriesNewsModel(String category) async{
    final response = await _repo.fetchCategoriesNewsModel(category);
    return response ;
  }
}