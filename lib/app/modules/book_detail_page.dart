import 'package:book_app/app/helper/star_rating.dart';
import 'package:book_app/app/models/book.dart';
import 'package:book_app/app/modules/book_detail_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailPage extends StatelessWidget {
  final BookSnapshot book;

  const BookDetailPage({Key key, this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text("Detail"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => BookDetailViewModel(book),
          builder: (context, widget) {
            return Consumer<BookDetailViewModel>(builder: (context, model, _) {
              return Center(
                child: model.isLoading
                    ? CupertinoActivityIndicator()
                    : Container(
                        margin: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image.network(
                                  model.book.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.book.price,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            model.book.title,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            model.book.authors,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFb7b7a4),
                                              height: 1.6,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          StarRatingWidget(
                                            star: int.parse(model.book.rating),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RawMaterialButton(
                                      onPressed: () async {
                                        if (await canLaunch(model.book.url)) {
                                          await launch(model.book.url);
                                        } else {
                                          throw 'Could not launch ${model.book.url}';
                                        }
                                      },
                                      fillColor: Colors.white,
                                      child: Icon(
                                        Icons.link,
                                      ),
                                      shape: CircleBorder(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xFFe5e5e5),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Column(
                                        children: [
                                          Text("Year"),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${model.book.year}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Column(
                                        children: [
                                          Text("Number of pages"),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${model.book.pages}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Column(
                                        children: [
                                          Text("Language"),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${model.book.language}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                model.book.desc,
                                style: TextStyle(
                                  height: 1.6,
                                  color: Color(0xFF594236),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  child: MaterialButton(
                                    disabledColor: Colors.grey,
                                    // minWidth: double.infinity,
                                    onPressed: () {
                                      model.showMaterialDialog(context);
                                    },
                                    child: Text(
                                      "Take Note",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Color(0xFFfb8500),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
              );
            });
          },
        ),
      ),
    );
  }
}