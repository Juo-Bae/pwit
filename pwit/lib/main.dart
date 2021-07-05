import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     title: 'Navigation Basics',
//     home: MyApp(),
//   ));
// }

void main() => runApp(MaterialApp(title: 'MyApp', home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var grey = Colors.grey;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.grey[700],
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex, //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '오늘의기도',
            icon: Icon(Icons.today),
          ),
          BottomNavigationBarItem(
            label: '나의 기도',
            icon: Icon(Icons.volunteer_activism_outlined),
          ),
          BottomNavigationBarItem(
            label: '중보자 되기',
            icon: Icon(Icons.supervisor_account),
          ),
          BottomNavigationBarItem(
            label: '설정',
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }

  List _widgetOptions = [
    Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          // height: 50,
          padding: EdgeInsets.all(10),
          color: Colors.grey[300],
          child: Text(
            '오늘의 기도',
            style: TextStyle(fontSize: 20, fontFamily: 'DoHyeonRegular'),
          ),
        ),
        Container(
          width: double.infinity,
          // height: 50,
          padding: EdgeInsets.all(10),
          color: Colors.grey[200],
          child: Text(
            'Juo',
            style: TextStyle(fontSize: 20, fontFamily: 'DoHyeonRegular'),
          ),
        ),
        Container(
          width: double.infinity,
          // height: 50,
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Text(
            '1. 건강할 수 있게',
            style: TextStyle(fontSize: 20, fontFamily: 'DoHyeonRegular'),
          ),
        ),
        Container(
          width: double.infinity,
          // height: 50,
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Text(
            '2. 무사할 수 있게',
            style: TextStyle(fontSize: 20, fontFamily: 'DoHyeonRegular'),
          ),
        ),
      ],
    ),
    Text(
      'Music',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
    Text(
      'Places',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
    Text(
      'News',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
  ];
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center, // 주 축 기준 중앙
//           // crossAxisAlignment: CrossAxisAlignment.center, // 교차 축 기준 중앙
//           children: <Widget>[
//             // Title
//             Column(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
//                   child: Text(
//                     '말씀카드',
//                     style: TextStyle(
//                       fontSize: 32,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ]),
//     ));
//   }
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pray With',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Pray With'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
