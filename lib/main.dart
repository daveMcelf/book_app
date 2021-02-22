import 'package:book_app/app/helper/note_pref_helper.dart';
import 'package:book_app/app/models/book.dart';
import 'package:book_app/app/modules/book_detail_page.dart';
import 'package:book_app/app/modules/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotePrefsNotifier(),
          lazy: false,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: "/",
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => SearchPage());
            break;
          case '/detail':
            final BookSnapshot book = setting.arguments;
            return MaterialPageRoute(builder: (context) {
              return BookDetailPage(
                book: book,
              );
            });
            break;
          default:
            return null;
        }
      },
    );
  }
}
