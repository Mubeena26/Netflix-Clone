import 'package:flutter/material.dart';
import 'package:netflix_project/api/api.dart';
import 'package:netflix_project/models/models.dart';
import 'package:netflix_project/screens/search_result.dart'; // Import the custom widget

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';
  Future<List<Movie>>? searchResults;

  void searchMovies(String query) {
    setState(() {
      searchResults = Api().searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.07,
            decoration: BoxDecoration(color: Color.fromARGB(255, 46, 45, 45)),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.05,
                ),
                Icon(Icons.search, color: Colors.white),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search for a title, person, or genre",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      query = value;
                      searchMovies(query);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchResults == null
                ? Center(
                    child: Text('Search for movies',
                        style: TextStyle(color: Colors.white)))
                : FutureBuilder<List<Movie>>(
                    future: searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.white)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No movies found',
                                style: TextStyle(color: Colors.white)));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final movie = snapshot.data![index];
                            return SearchResultItem(
                                movie: movie); // Use custom widget
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
