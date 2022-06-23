import 'package:flutter/material.dart';
import 'package:mixins/mixins.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Mixins',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Mixins'),
        ),
        body: Center(
            child: Container(
          margin: Ei.all(15),
          padding: Ei.sym(v: 15),
          decoration: BoxDecoration(
              border: Br.only(['t'], color: Colors.white),
              borderRadius: Br.radius(5)),
          child: Column(
            children: [
              Textr(
                'Hello World',
                padding: Ei.sym(v: 10, h: 25),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
