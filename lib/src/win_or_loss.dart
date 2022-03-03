import 'package:bludurdafdelurpurdurdle/src/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WinOrLoss extends StatelessWidget {
  const WinOrLoss({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;

    late Widget child;
    if (state.isWon) {
      child = const _YourDoneIt();
    } else if (state.isLost) {
      child = const _SadCowboy();
    } else {
      child = Container();
    }

    return AnimatedSwitcher(
      duration: const Duration(seconds: 3),
      child: child,
    );
  }
}

class _YourDoneIt extends StatelessWidget {
  const _YourDoneIt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'your done it',
      style: Theme.of(context).textTheme.headline1?.copyWith(
            color: Colors.green,
          ),
    );
  }
}

class _SadCowboy extends StatelessWidget {
  const _SadCowboy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'sad cowboy',
      style: Theme.of(context).textTheme.headline1?.copyWith(
            color: Colors.red,
          ),
    );
  }
}
