import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/categories_news_model.dart';

import '../view_model/news_channel_view_model.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<String> categoryName =[
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  NewsViewModel newsViewModel = NewsViewModel();

  String category = 'general';
  final format = DateFormat('MMMM, dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData.fallback(),
        backwardsCompatibility: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryName.length,
                  itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      category = categoryName[index];
                      setState(() {

                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: category == categoryName[index] ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                              child: Text(
                                categoryName[index].toString(),
                                style: GoogleFonts.poppins(
                            color: Colors.white,
                                fontSize: 13
                          ),)),
                        ),
                      ),
                    ),
                  );

                  }),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsModel(category),
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
      ),
    );
  }
}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
