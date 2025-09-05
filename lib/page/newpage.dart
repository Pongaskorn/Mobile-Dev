import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key, required this.photo});

  final String photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: photo,
            createRectTween: (begin, end) =>
                MaterialRectArcTween(begin: begin, end: end),
            child: Material(

              child: Image.asset('assets/images/1.jpg'
                ,
                width: 300, // ขนาดใหญ่ตอนอยู่กลางจอ
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
