import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final int rating;
  final onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = 0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => new _TestState();
}

class _TestState extends State<Test> {
  int rating = 3;

  @override
  Widget build(BuildContext context) {
    return new StarRating(
      rating: rating,
      onRatingChanged: (rating) => setState(() => this.rating = rating),
    );
  }
}