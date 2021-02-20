import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int star;
  StarRatingWidget({this.star = 0});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 1; i <= 5; i++)
            Icon(
              i > star ? Icons.star_border : Icons.star,
              size: 18,
              color: Colors.amberAccent,
            ),
        ],
      ),
    );
  }
}
