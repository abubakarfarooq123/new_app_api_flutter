import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class NewsDetail extends StatefulWidget {

  String imageurl, date, newstitle, author, desc, content, source;
   NewsDetail({super.key,
    required this.source,
    required this.author,
    required this.date,
    required this.content,
    required this.desc,
    required this.imageurl,
    required this.newstitle,
  });

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final format = DateFormat('MMMM, dd, yyyy');


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    DateTime dateTime = DateTime.parse(widget.date);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        backwardsCompatibility: true,
        iconTheme: const IconThemeData.fallback(),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          Container(
            child: Container(
              height: height * 0.45,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.imageurl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => spinkit2,
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * 0.4),
            padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Text(widget.newstitle,style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700
                ),),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.source,style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700
                      ),),
                    ),
                    Text(format.format(dateTime),style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500
                    ),),

                  ],
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(widget.desc,style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.blue,
  size: 50,
);
