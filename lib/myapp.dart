// import 'package:flutter/material.dart';
// import 'package:mobiledev/page/home.dart';
// import 'package:mobiledev/page/playersseletion.dart';
// import 'package:mobiledev/page/test.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
  
//   @override
  
//   Widget build(BuildContext context) {
    
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: PlayersSelection(),
//       // home: Test(),
      

//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobiledev/page/playersseletion.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // สำคัญมาก
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poke Team',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple,
),
      
      home: const PlayersSelection(),
      // home: Test(),
    );
  }
}
