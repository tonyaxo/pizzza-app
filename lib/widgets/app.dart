import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/catalog_store.dart';
import '../screens/home_page.dart';
import '../screens/cart_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/profile_screen.dart';
import '../router/router.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCourt',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        canvasColor: Colors.white,
        // fontFamily: 'CoreSansD',
        primarySwatch: Colors.orange,
        buttonColor: Colors.orange[300],
      ),
      onGenerateRoute: Router.onGenerateRoute,
      initialRoute: '/catalog',
      routes: {
        '/catalog': (context) => Consumer<CatalogStore>(
          builder: (_, store, __) => HomePage(store),
        ),
        '/profile': (context) => ProfileScreen(),
        '/contacts': (context) => ContactsScreen(),
        '/cart': (context) => CartScreen(),
      },
    );
  }
}