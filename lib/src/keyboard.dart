import 'package:bludurdafdelurpurdurdle/src/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: 'qwertyuiop'.toLetterKeys(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: 'asdfghjkl'.toLetterKeys(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EnterKey(),
            ...'zxcvbnm'.toLetterKeys(),
            const DeleteKey(),
          ],
        ),
      ],
    );
  }
}

extension on String {
  List<Widget> toLetterKeys() => split('').map((l) => LetterKey(letter: l)).toList();
}

class LetterKey extends StatelessWidget {
  final String letter;

  const LetterKey({Key? key, required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;

    return _KeyBase(
      color: state.getCorrectness(letter).color,
      child: TextButton(
        onPressed: () => context.read<GameBloc>().add(KeyPress(letter)),
        child: Text(letter.toUpperCase()),
      ),
    );
  }
}

class EnterKey extends StatelessWidget {
  const EnterKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _KeyBase(
      isWide: true,
      child: TextButton(
        onPressed: () => context.read<GameBloc>().add(EnterKeyPress()),
        child: const Text('ENTER'),
      ),
    );
  }
}

class DeleteKey extends StatelessWidget {
  const DeleteKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _KeyBase(
      isWide: true,
      child: TextButton(
        onPressed: () => context.read<GameBloc>().add(DeleteKeyPress()),
        child: const Icon(Icons.backspace_outlined),
      ),
    );
  }
}

class _KeyBase extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool isWide;

  const _KeyBase({
    Key? key,
    required this.child,
    this.color = Colors.transparent,
    this.isWide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
      width: isWide ? 64 : 48,
      height: 64,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: child,
    );
  }
}
