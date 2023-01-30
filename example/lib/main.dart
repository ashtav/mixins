import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:mixins/mixins.dart';

import 'pages/form_view.dart';

void main() {
  Mixins.setSystemUI(navBarColor: Colors.white);

  // set mixins config
  MixinConfig.setConfig = MixinConfig(widgets: {
    'confirm': {
      'cancel': 'Batal',
      'confirm': 'Ya',
    },
    'no_data': {
      'title': 'No Data Found',
      'subtitle': 'No Data Available',
    },
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to Mixins', theme: appTheme, home: const HomePage());
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
        actions: [
          IconButton(
              onPressed: () {
                MixinsDropdown.open(context,
                    options: List.generate(4, (index) => 'Option $index'),
                    offset: const Offset(20, 25),
                    disableds: [2],
                    dangers: [1], onSelect: (o, i) {
                  logg(o);
                });
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black87,
              ))
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: Maa.center,
        children: [
          Container(
            decoration: BoxDecoration(border: Br.only(['b'], color: Colors.black12)),
            child: Textr(
              'Hello World',
              padding: Ei.sym(v: 10, h: 25),
            ),
          ),
          InkW(
            onTap: () async {
              try {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) => const FormView(),
                ));

                // Confirm(
                //     icon: Icons.info_outline_rounded,
                //     title: 'Confirmation',
                //     message: 'Are you sure to confirm this?',
                //     onConfirm: (ok) {
                //       logg(ok);
                //     }).show(context);
              } catch (e, s) {
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
