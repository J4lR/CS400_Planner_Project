import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
  
}
class MainApp extends StatelessWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("The App"),
        ),
      ),
    );
    
  }
}
class AppBarApp extends StatelessWidget{
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AppBarTest());
  }
}
class AppBarTest extends StatelessWidget{
  const AppBarTest({super.key});

  @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Planner"),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar'))
              );
            },),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Go to next page',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context){
                      return Scaffold(
                        appBar: AppBar(title: const Text('Next page')),
                        body: const Center(
                          child: Text(
                            'This is the next page',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    },
                  ),
                  );
              },
              ),
          ],
        ),
        body: const Center(
          child: Text('This is the Home Page', style: TextStyle(fontSize: 24)),
        ),
      );
    }
}