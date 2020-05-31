import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/api_service.dart';
import 'store/catalog_store.dart';
import 'store/bottom_bar_notifiler.dart';
import 'store/cart_store.dart';
import 'widgets/app.dart';

const _shopBaseUrl = 'http://f0435516.xsph.ru.xsph.ru/shop-api';
// const _shopBaseUrl = 'http://localhost/shop-api';
// const _shopBaseUrl = 'http://10.0.2.2/shop-api'; // android

final ApiService apiService = ApiService(_shopBaseUrl);
final CartStore cartStore = CartStore(apiService);

void main() async {
  // TODO remove after Preferences implementation.
  const cartToken = '98dd7a6f-512b-406e-8471-52dfe6ddae5f';

  try {
    await cartStore.load(cartToken);
  } catch (e) {
    print(e);
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<CartStore>.value(value: cartStore),
        // Provider<ApiService>(create: (_) => ApiService(_shopBaseUrl)),
        ProxyProvider<ApiService, CatalogStore>(
          update: (_, api, __) => CatalogStore(api),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomBarNotifiler(),
        ),
      ],
      child: App(),
    )
  );
}

