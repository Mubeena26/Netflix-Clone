import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_project/api/api.dart';
import 'package:netflix_project/api/constants.dart';
import 'package:netflix_project/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> popularMovies;

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getPopular();
    popularMovies = Api().getTrendingMovie();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Header(size: size),
            Preview(size: size),
            WatchingUser(size: size, moviesFuture: trendingMovies),
            PopularOn(
              size: size,
              title: "Popular on Netflix",
              moviesFuture: popularMovies,
            ),
            PopularOn(
              size: size,
              title: "Trending Now",
              moviesFuture: trendingMovies,
            )
          ],
        ),
      ),
    );
  }
}

class PopularOn extends StatelessWidget {
  const PopularOn({
    Key? key,
    required this.size,
    required this.title,
    required this.moviesFuture,
  }) : super(key: key);

  final Size size;
  final String title;
  final Future<List<Movie>> moviesFuture;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .4,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            FutureBuilder<List<Movie>>(
              future: moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No movies found'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!
                          .map((movie) =>
                              Popular(size: size, image: movie.posterPath))
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Popular extends StatelessWidget {
  const Popular({
    super.key,
    required this.size,
    required this.image,
  });

  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: size.height * 0.26,
        width: size.width * 0.3,
        child: Image.network(
          '${Constants.imagepath}$image',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Preview extends StatelessWidget {
  const Preview({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.25,
      width: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previews',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            FutureBuilder<List<Movie>>(
              future: Api().getPreview(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No movies found'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!
                          .map((movie) => ScrollContent(
                                size: size,
                                image: movie.posterPath,
                              ))
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollContent extends StatelessWidget {
  const ScrollContent({
    Key? key,
    required this.size,
    required this.image,
  }) : super(key: key);

  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        radius: size.height * 0.07,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(
            '${Constants.imagepath}$image'), // Adjust Constants.imagePath as per your implementation
      ),
    );
  }
}

class WatchingUser extends StatelessWidget {
  const WatchingUser({
    super.key,
    required this.size,
    required this.moviesFuture,
  });

  final Size size;
  final Future<List<Movie>> moviesFuture;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Continue Watching For user',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            FutureBuilder<List<Movie>>(
              future: Api().getContinue(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No movies found'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!
                          .map((movie) => ContinuWatching(
                              size: size, image: movie.posterPath))
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContinuWatching extends StatelessWidget {
  const ContinuWatching({
    super.key,
    required this.size,
    required this.image,
  });

  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            height: size.height * 0.26,
            width: size.width * 0.3,
            color: Colors.white,
          ),
          Container(
            height: size.height * 0.26,
            width: size.width * 0.3,
            color: Colors.white,
            child: Image.network(
              '${Constants.imagepath}$image',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: size.height * 0.07,
              width: size.width * 0.4,
              color: Colors.grey.shade900,
              child: Column(
                children: [
                  Container(
                    height: 4,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.info,
                            color: Colors.white), // Example menu icon (info)
                        SizedBox(width: 25), // Adjust spacing as needed
                        Icon(Icons.more_vert,
                            color:
                                Colors.white), // Example menu icon (menu_book)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size.height * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/Bigil Movie Posters _ High Quality _ No Watermarks _ Studio Flicks.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: size.height * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: 10,
          right: 10,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 110)),
                      Text(
                        "TV Shows",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Text(
                        "Movies",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Text(
                        "My List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                    bottom: 65,
                  )),
                  Text(
                    '#2 in India today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Column(children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          'My List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ])
                    ],
                  ),
                  Container(
                    height: size.height * 0.05,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5),
                          Icon(Icons.play_circle_filled),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Play",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Column(children: [
                        Icon(Icons.info, color: Colors.white),
                        Text(
                          'Info',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
