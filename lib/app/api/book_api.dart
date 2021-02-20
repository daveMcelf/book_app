import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:book_app/app/helper/api_exception.dart';
import 'package:book_app/app/helper/network_cache/network_cache.dart';
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
      // Isolate.spawn(parseSearchResponse, cacheData).then((isolate) {
      //   return isolate.
      // });
      return BookSearchRespnse.fromJson(jsonDecode(cacheData));
    }

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var resBody = _response(response);
        BookSearchRespnse res = BookSearchRespnse.fromJson(resBody);
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
        var resBody = _response(response);
        BookDetail res = BookDetail.fromJson(resBody);
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

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BookAPIException(400, "Bad Request");
      case 401:
      case 403:
        throw BookAPIException(403, "Unauthorize");
      case 500:
        throw BookAPIException(500, "Server Error");
      default:
        throw BookAPIException(response.statusCode, 'Unknowd Error');
    }
  }

  static BookSearchRespnse parseSearchResponse(String response) {
    assert(response is String);
    var parse = json.decode(response);
    return BookSearchRespnse.fromJson(parse);
  }
}
