import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/news_channel_headlines_model.dart';
import 'package:new_app/view/categoryScreen.dart';
import 'package:new_app/view/newsDetail.dart';
import 'package:new_app/view_model/news_channel_view_model.dart';

import '../models/categories_news_model.dart';

enum FilterList {
  bbcNews,
  // cnn,
  alJazeera,
  aryNews,
  // independent,
  // reuters,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;

  String name = 'bbc-news';
  final format = DateFormat('MMMM, dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen()));
          },
          icon: Image.asset(
            'assets/images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        elevation: 0.0, // Set elevation to 0.0 for no shadow
        backgroundColor: Colors.transparent, // Set a transparent color
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
              });

              // Update the 'name' variable based on the selected item
              switch (item) {
                case FilterList.bbcNews:
                  name = 'bbc-news';
                  break;
                case FilterList.aryNews:
                  name = 'ary-news';
                  break;
                case FilterList.alJazeera:
                  name = 'al-jazeera-english';
                  break;
              // Add more cases if needed for other enum values
              }

              // Fetch data with the updated 'name'
              newsViewModel.fetchNewChannelHeadlinesApi(name);
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text("BBC News"),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text("Ary News"),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.alJazeera,
                child: Text("AlJazeera News"),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime =
                      DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(
                              source: snapshot.data!.articles![index].source!.name.toString(),
                              author: snapshot.data!.articles![index].author.toString(),
                              date: snapshot.data!.articles![index].publishedAt.toString(),
                              content: snapshot.data!.articles![index].content.toString(),
                              desc: snapshot.data!.articles![index].description.toString(),
                              imageurl: snapshot.data!.articles![index].urlToImage.toString(),
                              newstitle: snapshot.data!.articles![index].title.toString()
                          )));
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * 0.9,
                                padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => spinkit2,
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline, color: Colors.red),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.22,
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot.data!.articles![index].title.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index].source!.name.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsModel('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime =
                      DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                fit: BoxFit.cover,
                                height: height * 0.18,
                                width: width * 0.3,
                                placeholder: (context, url) => spinkit2,
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline, color: Colors.red),
                              ),
                            ),
                            Expanded(
                                child:Container(
                                  height: height *0.18,
                                  padding : const EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,

                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,

                                            ),
                                          ),
                                          Text(format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ) ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
