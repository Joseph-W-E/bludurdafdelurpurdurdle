import 'package:bludurdafdelurpurdurdle/src/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Grid extends StatelessWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;

    final children = <Widget>[
      ...state.guessed.map(
        (word) => Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: word.map((letter) => Cell(letter: letter)).toList(),
        ),
      ),
      if (state.pendingGuess.isNotEmpty)
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(state.secretWord.length, (i) {
            if (i < state.pendingGuess.length) {
              return Cell(
                letter: GuessedLetter(
                  letter: state.pendingGuess.split('').toList()[i],
                  correctness: Correctness.none,
                ),
              );
            }
            return const Cell();
          }),
        ),
    ];

    if (children.length < state.maxGuesses) {
      children.addAll(List.generate(state.maxGuesses - children.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(state.secretWord.length, (i) {
            return const Cell();
          }),
        );
      }));
    }

    return ListView(
      children: children,
    );
  }
}

class Cell extends StatelessWidget {
  final GuessedLetter? letter;

  const Cell({Key? key, this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.center,
      width: 64,
      height: 64,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: letter?.correctness.color ?? Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        letter?.letter ?? '',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
