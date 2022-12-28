import 'package:flutter/material.dart';
import 'package:mixins/mixins.dart';

void main() {
  Mixins.setSystemUI(navBarColor: Colors.white);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Welcome to Mixins', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome to Mixins',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: .5,
        backgroundColor: Colors.white,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: Maa.center,
        children: [
          Container(
            decoration:
                BoxDecoration(border: Br.only(['b'], color: Colors.black12)),
            child: Textr(
              'Hello World',
              padding: Ei.sym(v: 10, h: 25),
            ),
          ),
          InkW(
            onTap: () async {
              try {} catch (e, s) {
                Mixins.errorCatcher(e, s);
              }
            },
            // onTapDown: (details) => logg(details),
            color: Colors.white,
            padding: Ei.sym(v: 15, h: 20),
            child: const Text('Click Me'),
          ),
          const Skeleton(
            size: [200, 5],
          )
        ],
      )),
    );
  }
}
