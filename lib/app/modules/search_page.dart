import 'package:book_app/app/helper/scrolling_list_item.dart';
import 'package:book_app/app/modules/search_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTapDown: (_) {
            FocusScope.of(context).unfocus();
          },
          child: ChangeNotifierProvider(
            create: (_) => SearchViewModel(),
            builder: (context, widget) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Search",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 38,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Material(
                        elevation: 0.75,
                        color: Colors.white,
                        shadowColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        child: TextField(
                          onChanged: (value) {
                            context
                                .read<SearchViewModel>()
                                .queryStringDebounce(value);
                          },
                          decoration: InputDecoration(
                            hintText: "Search book here",
                            border: InputBorder.none,
                            // contentPadding: EdgeInsets.only(top: 5),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {},
                            ),
                            suffixIcon:
                                context.watch<SearchViewModel>().isSearching
                                    ? CupertinoActivityIndicator()
                                    : null,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer<SearchViewModel>(
                        builder: (context, model, _) {
                          return ListView.builder(
                            itemCount: model.books.length,
                            itemBuilder: (ctx, index) {
                              return ScrollingListItem(
                                book: model.books[index],
                                onItemTapped: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/detail",
                                    arguments: model.books[index],
                                  );
                                },
                                itemCreated: () {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((duration) =>
                                          model.handleItemCreated(index));
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
