import 'package:chatapplicationforprojects/slpash%20screen%20/slpash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ConnectChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
var size,height,width;
class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(

      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   centerTitle: true,
      //   title: const Text(
      //     'ConnectChat',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search),
      //       onPressed: () {
      //         // Add search button functionality here
      //       },
      //     ),
      //     PopupMenuButton(
      //       itemBuilder: (context) => [
      //         const PopupMenuItem(
      //           child: Text('Option 1'),
      //         ),
      //         const PopupMenuItem(
      //           child: Text('Option 2'),
      //         ),
      //       ],
      //       icon: const Icon(Icons.more_vert),
      //     ),
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add_circle),),
      // body: slpash()
      body: slpash(),
    );
  }
}
