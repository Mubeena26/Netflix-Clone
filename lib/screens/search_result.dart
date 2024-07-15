import 'package:flutter/material.dart';
import 'package:netflix_project/api/constants.dart';
import 'package:netflix_project/models/models.dart';

class SearchResultItem extends StatelessWidget {
  final Movie movie;

  const SearchResultItem({required this.movie, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.3,
            height: size.height * 0.2,
            child: Image.network(
              '${Constants.imagepath}${movie.posterPath}',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5), // Add spacing between title and overview
                  Text(
                    movie.overview,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
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
