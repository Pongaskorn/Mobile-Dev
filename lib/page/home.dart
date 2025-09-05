import 'package:flutter/material.dart';
import 'newpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String photoPath = 'assets/images/1.jpg';

// void setImagePath(String )
  @override
  Widget build(BuildContext context) {
    // print('build Myhomepage : $_counter, $_imagePath'),
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text(' Hero Animation')),
      floatingActionButton: FloatingActionButton(
        heroTag: null, // ปิด Hero ของ FAB เอง (กัน conflict)
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 450),
              reverseTransitionDuration: const Duration(milliseconds: 350),
              pageBuilder: (_, __, ___) => const NewPage(photo: photoPath),
            ),
          );
        },
        child: Hero(
          tag: photoPath,
          child: ClipOval(
            child: Image.asset('assets/images/1.jpg',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}


