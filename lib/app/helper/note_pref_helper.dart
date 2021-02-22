import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

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

  Isolate _isolate;
  ReceivePort _receivePort; //main isolate for listening data

  NotePrefsNotifier() {
    _receivePort = ReceivePort();
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

  /// load all note data from sharePreferences.
  ///
  /// After receiving the note data, convert it to [NotePrefsState] in background using isolate
  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var notesString = sharedPrefs.getString('notes') ?? null;

    if (notesString != null) {
      //parse note data in isolate background here to have faster runtime
      _isolate = await Isolate.spawn(_isolateHandler,
          JsonParseThreadModel(_receivePort.sendPort, notesString));
      _receivePort.listen((message) {
        log("done parsing note data");
        _currentPrefs = NotePrefsState(notes: message);
        notifyListeners();
      }, onDone: () {
        /// kill isolate and close port
        _isolate.kill();
        _receivePort.close();
      });
    }
  }

  /// save note data into sharepreferences
  Future<void> _saveNewPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('notes', json.encode(_currentPrefs.notes));
  }

  static void _isolateHandler(JsonParseThreadModel param) async {
    assert(param.data is String);
    var parse = json.decode(param.data);
    Map<String, String> noteData = Map<String, String>.from(parse);
    param.sendPort.send(noteData);
  }
}

/// Model used for working with isolate.
///
/// This Model add additional data along with SendPort before passing to spawn isolate function
class JsonParseThreadModel {
  SendPort sendPort;
  String data;
  JsonParseThreadModel(this.sendPort, this.data);
}
