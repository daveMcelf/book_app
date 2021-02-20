class BookSearchRespnse {
  String error;
  String total;
  String page;
  List<BookSnapshot> books;

  BookSearchRespnse({this.error, this.total, this.page, this.books});

  BookSearchRespnse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    total = json['total'];
    page = json['page'];
    if (json['books'] != null) {
      books = new List<BookSnapshot>();
      json['books'].forEach((v) {
        books.add(new BookSnapshot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['total'] = this.total;
    data['page'] = this.page;
    if (this.books != null) {
      data['books'] = this.books.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookSnapshot {
  String title;
  String subtitle;
  String isbn13;
  String price;
  String image;
  String url;

  BookSnapshot(
      {this.title,
      this.subtitle,
      this.isbn13,
      this.price,
      this.image,
      this.url});

  BookSnapshot.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    isbn13 = json['isbn13'];
    price = json['price'];
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['isbn13'] = this.isbn13;
    data['price'] = this.price;
    data['image'] = this.image;
    data['url'] = this.url;
    return data;
  }
}
