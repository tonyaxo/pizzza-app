

import 'package:flutter/material.dart';
import '../widgets/bottom_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Кусь Кусь')
        ),
      ),
      body: Text('Профиль'),
      bottomNavigationBar: BottomBar(),
    );
  }
}