
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/category.dart' as model;

/// https://www.didierboelens.com/2019/05/is-a-widget-inside-a-scrollable-visible/
class NavigationList extends StatelessWidget {

  final Set<_CategoryItemContext> _navItemsContexts = Set<_CategoryItemContext>();
  final ScrollController _controller = ScrollController();

  final Map<String, model.Category> _categories;

  final void Function(String) onSelect;

  final String activeItem;

  NavigationList(this._categories, this.activeItem, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return _build();
  }

  Widget _build() {
    return Observer(
      builder: (_) { 
        if (_categories.isEmpty) {
          return CircularProgressIndicator(
            backgroundColor: Colors.black,
          );
        }

        var items = _categories.entries.toList();
        return ListView.builder(
          controller: _controller,
          itemCount: _categories.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 0.0),
          itemBuilder: (ctx, index) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // save item context
                _navItemsContexts.add(_CategoryItemContext(context: context, index: index));

                var catItem = items[index].value;
                return GestureDetector(
                  onTap: () { 
                    onSelect(catItem.code);
                    _centerItem(index, context);
                  },
                  child: _NavigationItem(
                    title: catItem.name, 
                    isActive: activeItem == catItem.code
                  ),
                );
              },
            );
            
          }
        );
      }
    );
  }

  /// Makes item number [index] centered on screen.
  void _centerItem(int index, BuildContext context) {
    final _CategoryItemContext item = _navItemsContexts.elementAt(index);
    final RenderBox object = item.context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);

    final double screenWidth = MediaQuery.of(context).size.width;
    final RevealedOffset leftOffset = viewport.getOffsetToReveal(object, 0.0);
    // var rightOffset = viewport.getOffsetToReveal(object, 1.0);
    final double objectWidth = object?.size?.width ?? 0;
    // Offset of element center
    final double itemCenterOffset = leftOffset.offset + (objectWidth / 2);

    double resultOffset = itemCenterOffset - screenWidth / 2;
    if (resultOffset < _controller.position.minScrollExtent) {
      resultOffset = _controller.position.minScrollExtent;
    }

    _controller.jumpTo(resultOffset);
  }
  
}

class _NavigationItem extends StatelessWidget {
  final bool isActive;

  final String title;

  _NavigationItem({this.title, this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: isActive ? Colors.white : Colors.transparent,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Text(
        "$title menu",
        style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 16.0),
      ),
    );
  }
}

class _CategoryItemContext {
  final BuildContext context;
  final int index;

  _CategoryItemContext({this.context, this.index});

  @override
  bool operator ==(Object other) => other is _CategoryItemContext && other.index == index;

  @override
  int get hashCode => index.hashCode;
}