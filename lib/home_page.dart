import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movie_flix_app/custom_classes.dart';
import 'package:movie_flix_app/detailed_movie_info.dart';
import 'package:http/http.dart' as http;
import 'package:movie_flix_app/search_delegate.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  TextEditingController searchController = TextEditingController();
  String searchText = '';
  String title = '';
  String imageUrl = '';
  String overview = '';

  List<NowPlayingDataClass> nowPlayingMovies = [];
  List<TopRatedDataClass> topRatedMovies = [];

  late List<Widget> tabs;
  
  late Future<String> nowPlayingData;
  late Future<String> topRatedData;

  bool showSuffix = false;

  @override
  void initState() {
    super.initState();
    topRatedData = fetchTopRatedData();

     nowPlayingData = fetchNowPlayingData();
  }




  @override
  Widget build(BuildContext context) {

    tabs = [

      customNowPlayingWidget(),
      customTopRatedWidget(),

    ];

    return Scaffold(
      // appBar: AppBar(
      //   leadingWidth: 0,
      //   title: Container(
      //       height: 80,
      //       // color: Colors.pink,
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: TextFormField(
      //
      //           controller: searchController,
      //           onChanged: (value) {
      //             setState(() {
      //               searchText = value;
      //             });
      //           },
      //           decoration: InputDecoration(
      //               hintText: 'Search...',
      //
      //               focusedBorder: OutlineInputBorder(
      //                 // borderRadius: BorderRadius.circular(28),
      //                   borderSide: BorderSide(color: Colors.black)
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                 // borderRadius: BorderRadius.circular(28),
      //                   borderSide: BorderSide(color: Colors.black)
      //               )
      //           ),
      //         ),
      //       ),
      //     ),
      // ),
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
        backgroundColor: Colors.orange.shade400,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        // selectedIconTheme: const IconThemeData(color: Colors.black),
        // selectedLabelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }



 Widget customNowPlayingWidget(){
    return FutureBuilder(
      future: nowPlayingData,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading')
              ],
            ),
          );
        }
        else if(snapshot.hasError){
          return const Center(child: Text('Please check internet'),);
        }

        else if(snapshot.hasData){

          var data = snapshot.hasData;

          print('net work data is $data');

          return Container(
            color: Colors.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(
                  height: 50,
                ),

                SizedBox(
                  height: 80,
                  // color: Colors.pink,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            onTap: (){
                              setState(() {
                                showSuffix = !showSuffix;
                              });

                              Future.delayed(Duration(seconds: 2),(){
                                showSearch(context: context, delegate: MovieSearchDelegate(movies: nowPlayingMovies));

                              });
                            },
                            decoration: const InputDecoration(
                                hintText: 'Search...',

                                focusedBorder: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.black)
                                )
                            ),
                          ),
                        ),
                        showSuffix ? TextButton(onPressed: (){}, child: Text('Cancel')) : SizedBox.shrink()
                        
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: nowPlayingMovies.length,
                    padding: EdgeInsets.zero,
                    
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          customListCard(nowPlayingMovies[index]),
                          const Divider(
                            height: 0.5,
                            thickness: 0.5,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


  Widget customListCard(NowPlayingDataClass nowPlayingDataClass) {
    return Slidable(
      endActionPane: ActionPane(
        key: const ValueKey(0),
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (BuildContext? context){
              setState(() {
                nowPlayingMovies.remove(nowPlayingDataClass);

              });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),

        ],
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailedMovieInfo(nowPlayingDataClass.imageUrl,nowPlayingDataClass.title,nowPlayingDataClass.subTitle,nowPlayingDataClass.releaseDate  )));
        },
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 150,
                width: 125,
                decoration: const BoxDecoration(),
                clipBehavior: Clip.antiAlias,
                child: Image.network('https://image.tmdb.org/t/p/w200${nowPlayingDataClass.imageUrl}',fit: BoxFit.cover,),

              ),

              const SizedBox(
                width: 15,
              ),

              Expanded(
                child: Container(
                  // color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      

                      Text(nowPlayingDataClass.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      Expanded(
                        child: Text(nowPlayingDataClass.subTitle,
                          maxLines: 4,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget customTopRatedWidget(){
    return FutureBuilder(
      future: topRatedData,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading')
              ],
            ),
          );
        }
        else if(snapshot.hasError){

          print(snapshot.error);

          return const Center(child: Text('Please check internet'),);
        }

        else if(snapshot.hasData){

          var data = snapshot.hasData;

          print('net work data is $data');

          return Container(
            // height: 500,
            color: Colors.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 80,
                  // color: Colors.pink,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(

                            controller: searchController,
                            onTap: () {

                              setState(() {
                                showSuffix = !showSuffix;
                              });

                              Future.delayed(Duration(seconds: 2),(){
                                showSearch(context: context, delegate: MovieSearchDelegate(movies: topRatedMovies));

                              });
                            },
                            decoration: const InputDecoration(
                                hintText: 'Search...',

                                focusedBorder: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(color: Colors.black)
                                )
                            ),
                          ),
                        ),

                        showSuffix ? TextButton(onPressed: (){}, child: Text('Cancel')) : SizedBox.shrink()
                      ],
                    ),
                  ),
                ),


                Expanded(
                  child: ListView.builder(
                    itemCount: nowPlayingMovies.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return customTopRatedListCard(topRatedMovies[index]);
                    },
                  ),
                ),

              ],
            ),
          );
        }

        else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


  Widget customTopRatedListCard(TopRatedDataClass topRatedDataClass) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailedMovieInfo(topRatedDataClass.imageUrl,topRatedDataClass.title,topRatedDataClass.subTitle,topRatedDataClass.releaseDate)));
      },
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 150,
              width: 125,
              // color: Colors.blue,
              child: Image.network('https://image.tmdb.org/t/p/w200${topRatedDataClass.imageUrl}',fit: BoxFit.cover,),

            ),

            const SizedBox(
              width: 15,
            ),

            Expanded(
              child: Container(
                // color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topRatedDataClass.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    Expanded(
                      child: Text(topRatedDataClass.subTitle,
                        maxLines: 4,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String> fetchNowPlayingData() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> results = (responseData['results'] as List<dynamic>).cast<Map<String, dynamic>>();

      setState(() {
        nowPlayingMovies = results
            .map((movieData) => NowPlayingDataClass(
          movieData['backdrop_path'],
          movieData['original_title'],
          movieData['overview'],
          movieData['release_date'],
        ))
            .toList(growable: true);
      });

      print('load data: ${response.body}');


      return nowPlayingMovies[0].title;

      // return results;
    } else {
      // Request failed
      print('Failed to load data: ${response.statusCode}');

      return '';
    }
  }
  Future<String> fetchTopRatedData() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> results = (responseData['results'] as List<dynamic>).cast<Map<String, dynamic>>();

      setState(() {
        topRatedMovies = results
            .map((movieData) => TopRatedDataClass(
          movieData['backdrop_path'],
          movieData['original_title'],
          movieData['overview'],
          movieData['release_date'],

        ))
            .toList(growable: true);
      });

      print('load data: ${topRatedData}');


      return topRatedData;

      // return results;
    } else {
      // Request failed
      print('Failed to load data: ${response.statusCode}');

      return '';
    }
  }
  doDelete(NowPlayingDataClass nowPlayingDataClass) {
    nowPlayingMovies.remove(nowPlayingDataClass);
  }

}
