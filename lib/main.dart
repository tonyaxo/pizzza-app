import 'package:flutter/material.dart';
import 'package:foodcourt/router/router.dart';
import 'package:foodcourt/screens/product_screen.dart';
import 'package:foodcourt/store/bottom_bar_notifiler.dart';
import 'package:provider/provider.dart';

import 'screens/home_page.dart';
import 'screens/cart_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/profile_screen.dart';
import 'services/api_service.dart';
import 'store/catalog_store.dart';


void main() => runApp(MyApp());

const _shopBaseUrl = 'http://f0435516.xsph.ru.xsph.ru/shop-api';
// const _shopBaseUrl = 'http://localhost/shop-api';
// const _shopBaseUrl = 'http://10.0.2.2/shop-api'; // android

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService(_shopBaseUrl)),
        ProxyProvider<ApiService, CatalogStore>(
          update: (_, api, __) => CatalogStore(api),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomBarNotifiler(),
        ),
      ],
      child: MaterialApp(
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
          fontFamily: 'CoreSansD',
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
      ),
    );
  }
}

