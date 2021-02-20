import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Note Class that will be stored in SharePreference
///
/// When user add a note to the book, a Key/Value pair of <BookID, Text> will be saved.
class NotePrefsState {
  Map<String, String> notes = {};

  NotePrefsState({this.notes});
}

/// Helper class for saving and accessing note.
/// When app first start, [NotePrefsNotifier] will load the notes that store in the SharePreference.
/// User can `addNewNote` and access the note that is saved
class NotePrefsNotifier with ChangeNotifier {
  NotePrefsState _currentPrefs = NotePrefsState(notes: {});

  NotePrefsNotifier() {
    _loadSharedPrefs();
  }

  /// Getter for access the Notes data
  Map<String, String> get notes => _currentPrefs.notes;

  /// function for adding new Note to SharePreference
  /// When called, it will add/update the current note, save to SharePreference, and update the UI if neccessary.
  addNewNote(String bookId, String text) async {
    _currentPrefs.notes[bookId] = text;
    notifyListeners();
    _saveNewPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var notesString = sharedPrefs.getString('notes') ?? null;
    if (notesString != null) {
      var s = json.decode(notesString);
      Map<String, String> newMap = Map<String, String>.from(s);
      _currentPrefs = NotePrefsState(notes: newMap);
      notifyListeners();
    }
  }

  Future<void> _saveNewPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('notes', json.encode(_currentPrefs.notes));
  }
}
