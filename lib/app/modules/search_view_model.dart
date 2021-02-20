import 'dart:async';

import 'package:book_app/app/api/book_api.dart';
import 'package:book_app/app/helper/debouncer.dart';
import 'package:book_app/app/models/book.dart';
import 'package:flutter/material.dart';

class SearchViewModel with ChangeNotifier {
  List<BookSnapshot> books = [];
  final _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  bool isSearching = false;
  bool isLoadingMoreData = false;
  int kLIMIT = 10;
  int _currentPage = 1;
  String searchString;

  /// fetch book data using query string and page
  Future<void> fetchBook(String query, String page) async {
    searchString = query;
    final res = await BookAPIClient.instance.searchBook(query, page: page);

    if (res != null) {
      if (page == "1")
        books = res.books;
      else
        books.addAll(res.books);
      notifyListeners();
    } else {
      searchString = "";
    }
  }

  /// Method to set Searching state of the model
  void setSearching(bool state) {
    isSearching = state;
    notifyListeners();
  }

  /// Method to set Loading state of the model
  void setLoading(bool state) {
    isLoadingMoreData = state;
    notifyListeners();
  }

  /// When User type in TextField, we will call the `fetchBook()` to search the book.
  /// Debouncer is used to prevent flooding the API everytime user type.
  void queryStringDebounce(String text) {
    _debouncer.run(() async {
      setSearching(true);
      await fetchBook(text, "1");
      setSearching(false);
    });
  }

  /// Use for infinite list,
  Future<void> handleItemCreated(int index) async {
    var itemPosition = index + 1;
    var requestMoreData = itemPosition % kLIMIT == 0 && itemPosition != 0;
    var pageToRequest = (itemPosition ~/ kLIMIT) + 1;
    print(pageToRequest);
    if (requestMoreData && pageToRequest > _currentPage) {
      _currentPage = pageToRequest;
      setLoading(true);
      await fetchBook(searchString, "$pageToRequest");
      setLoading(false);
    }
  }
}
