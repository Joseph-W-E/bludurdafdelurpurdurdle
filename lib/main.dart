import 'package:bludurdafdelurpurdurdle/src/game.dart';
import 'package:bludurdafdelurpurdurdle/src/grid.dart';
import 'package:bludurdafdelurpurdurdle/src/keyboard.dart';
import 'package:bludurdafdelurpurdurdle/src/win_or_loss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('bludurdafdelurpurdurdle'),
        ),
        body: BlocProvider<GameBloc>(
          create: (_) => GameBloc(),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: const [
                    Expanded(child: Grid()),
                    Keyboard(),
                  ],
                ),
                const WinOrLoss(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
