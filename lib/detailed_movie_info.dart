import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailedMovieInfo extends StatefulWidget {

  String title;
  String imageUrl;
  String subTitle;
  String releaseDate;

  DetailedMovieInfo(this.imageUrl,this.title,this.subTitle,this.releaseDate);

  @override
  State<DetailedMovieInfo> createState() => _DetailedMovieInfoState();
}

class _DetailedMovieInfoState extends State<DetailedMovieInfo> {

  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orange,
        leadingWidth: 120,
        leading: ElevatedButton.icon(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,size: 30,),

          label: Text('Back',
            style: TextStyle(fontSize: 17)
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero
            )
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              child: Container(
                child: Image.network('https://image.tmdb.org/t/p/w200${widget.imageUrl}',fit: BoxFit.cover,),
              ),
            ),

            Positioned(
              bottom: 0,
              right: 40,
              left: 40,
              child: Container(
                height: 400,
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 200,
                      ),

                      Container(
                        height: 300,
                        color: Colors.black54,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(widget.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800
                                ),
                              ),
                            ),

                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(widget.releaseDate,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(widget.subTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                ),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: 'Now Playing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Top rated',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        // selectedIconTheme: const IconThemeData(color: Colors.black),
        // selectedLabelStyle: const TextStyle(color: Colors.black),
      ),

    );
  }
}
