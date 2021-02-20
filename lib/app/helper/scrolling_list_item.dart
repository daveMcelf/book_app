import 'package:book_app/app/models/book.dart';
import 'package:flutter/material.dart';

/// Listitem Widget used in the Search View.
/// This listitem take a function `itemCreated` which is used for infinite scrolling.
class ScrollingListItem extends StatefulWidget {
  final Function itemCreated;
  final Function onItemTapped;
  final BookSnapshot book;
  const ScrollingListItem({
    Key key,
    this.itemCreated,
    this.onItemTapped,
    this.book,
  }) : super(key: key);

  @override
  _ScrollingListItemState createState() => _ScrollingListItemState();
}

class _ScrollingListItemState extends State<ScrollingListItem> {
  @override
  void initState() {
    super.initState();
    if (widget.itemCreated != null) {
      widget.itemCreated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onItemTapped,
      child: Card(
        child: Row(
          children: [
            Image.network(
              widget.book.image,
              width: 100,
              height: 150,
              cacheHeight: 150,
              cacheWidth: 100,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.book.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.book.subtitle),
                    Text(widget.book.price),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
