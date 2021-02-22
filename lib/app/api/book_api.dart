import 'dart:async';
import 'dart:convert';

import 'package:book_app/app/helper/api_exception.dart';
import 'package:book_app/app/helper/network_cache/file_cache.dart';
import 'package:book_app/app/models/book.dart';
import 'package:book_app/app/models/book_detail.dart';
import 'package:http/http.dart' as http;

class BookAPIClient {
  static const _baseUrl = 'https://api.itbook.store/1.0/';
  static BookAPIClient _instance;

  ICacheManager _cacheManager;
  static BookAPIClient get instance {
    if (_instance == null) _instance = BookAPIClient._init();
    return _instance;
  }

  BookAPIClient._init() {
    _cacheManager = FileCached();
  }

  Future<BookSearchRespnse> searchBook(String query,
      {String page = "1"}) async {
    String url = _baseUrl + "search/$query/$page";
    final cacheData = await _cacheManager.getCachedData("cache-$url");
    if (cacheData != null && cacheData.isNotEmpty) {
      print("From Cache");
      return BookSearchRespnse.fromJson(jsonDecode(cacheData));
    }

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        _checkResponse(response.statusCode);

        BookSearchRespnse res =
            BookSearchRespnse.fromJson(jsonDecode(response.body));

        _cacheManager.writeDataToCached(
            "cache-$url", response.body, Duration(hours: 1));
        return res;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<BookDetail> getBookDetail(String isbn13) async {
    String url = _baseUrl + "books/$isbn13";
    final cacheData = await _cacheManager.getCachedData("cache-$url");
    if (cacheData != null && cacheData.isNotEmpty) {
      print("From Cache");
      return BookDetail.fromJson(jsonDecode(cacheData));
    }

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        _checkResponse(response.statusCode);
        BookDetail res = BookDetail.fromJson(jsonDecode(response.body));
        _cacheManager.writeDataToCached(
            "cache-$url", response.body, Duration(hours: 1));
        return res;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  _checkResponse(int statusCode) {
    switch (statusCode) {
      case 200:
        return;
      case 400:
        throw BookAPIException(400, "Bad Request");
      case 401:
      case 403:
        throw BookAPIException(403, "Unauthorize");
      case 500:
        throw BookAPIException(500, "Server Error");
      default:
        throw BookAPIException(statusCode, 'Unknowd Error');
    }
  }
}
