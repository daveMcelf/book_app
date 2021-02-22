import 'dart:async';

import 'package:book_app/app/api/book_api.dart';
import 'package:book_app/app/helper/note_pref_helper.dart';
import 'package:book_app/app/models/book.dart';
import 'package:book_app/app/models/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailViewModel with ChangeNotifier {
  BookDetail book;
  bool isLoading = false;
  String note = "";
  BookDetailViewModel(BookSnapshot book, BuildContext context) {
    note = Provider.of<NotePrefsNotifier>(context, listen: false)
        .notes[book.isbn13];
    fetchBookDetail(book.isbn13);
  }

  /// get the book detail using the ID
  Future<void> fetchBookDetail(String id) async {
    setLoadingState(true);
    final res = await BookAPIClient.instance.getBookDetail(id);
    setLoadingState(false);
    if (res != null) {
      book = res;
      notifyListeners();
    }
  }

  /// used for update the loading state of the application. If loading is True, CupertinoActivityIndicator will be shown.
  void setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

  /// Show a dialog for add a note to the book
  showMaterialDialog(BuildContext context) {
    final TextEditingController noteController = new TextEditingController();
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: Text("Note"),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Type your note here",
              ),
              TextFormField(
                autofocus: true,
                controller: noteController,
                maxLength: 50,
                decoration: new InputDecoration(
                  hintText: note,
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.indigo),
            ),
          ),
          TextButton(
            onPressed: () async {
              note = noteController.text;
              Provider.of<NotePrefsNotifier>(context, listen: false)
                  .addNewNote(book.isbn13, noteController.text);
              notifyListeners();
              Navigator.of(context).pop();
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ],
      ),
    );
  }
}
