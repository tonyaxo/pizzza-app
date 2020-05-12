
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../widgets/home_carousel.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/navigation_list.dart';
import '../store/catalog_store.dart';
import '../widgets/_product_list_item.dart';

/// List of categories and products with "affix" effect.
class HomePage extends StatefulWidget {

  final CatalogStore _store;

  HomePage(this._store);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScrollController _controller;

  /// The map provides connection of [Category.code] and offsets in products list.
  Map<String, _CategoryOffsetLimit> navigationMap;

  /// The current active item in [NavigationList] widget.
  String navigationActiveItem;

  /// Sets active item for [NavigationList] widget depends on this [_controller] offset.
  void _scrollListener() {
    String categoryCode = _findCategoryByOffset(_controller.offset);
    setState(() {
      navigationActiveItem = categoryCode;
    });
  }

  /// Returns [Category.code] by offset in products list.
  String _findCategoryByOffset(double offset) {
    for (var item in navigationMap.entries) {
      if (item.value.start <= offset && item.value.end >= offset) {
        return item.key;
      }
    }

    return null;
  }

  /// Callback to scrooll products list to selected navigation category. 
  void onCategorySelect(String code) {
    if (navigationMap.containsKey(code)) {
      _controller.animateTo(navigationMap[code].start, duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }
  
  /// Builds elements of [navigationMap]
  void _createNavigationMap() {
    double start = 0.0;

    widget._store.categories.forEach((code, category) {

      double end = start + (category.productsCount * ProductListItem.height);
      // First element offset adjutesment
      end = start == 0.0 ? end + 145.0 : end;
      navigationMap[code] = _CategoryOffsetLimit(start, end - 1);
    
      start = end;
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    navigationMap = Map<String, _CategoryOffsetLimit>();

    super.initState();
    widget._store.init();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Кусь Кусь')
        ),
      ),
      body: Observer(
        builder: (_) {

          _createNavigationMap();
          
          return CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: HomeCarousel(),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: false,
                pinned: true,
                flexibleSpace: NavigationList(widget._store.categories, navigationActiveItem, onCategorySelect),
              ),
              SliverFixedExtentList(
                itemExtent: ProductListItem.height,
                delegate: SliverChildListDelegate(
                  
                  widget._store.products.entries.map((product) => ProductListItem(product.value) ).toList()
                ),
              ),

            ],
          );
        }
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}


class _CategoryOffsetLimit {
  final start;
  final end;

  _CategoryOffsetLimit(this.start, this.end);
}