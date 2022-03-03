import 'dart:async';
import 'dart:math';

import 'package:bludurdafdelurpurdurdle/src/words_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState()) {
    on<Load>(_onLoad);
    on<KeyPress>(_onKeyPress);
    on<EnterKeyPress>(_onEnterKeyPress);
    on<DeleteKeyPress>(_onDeleteKeyPress);

    add(Load());
  }

  FutureOr<void> _onLoad(Load event, Emitter<GameState> emit) async {
    emit(
      GameState(
        secretWord: words[Random().nextInt(words.length)].toLowerCase(),
      ),
    );
  }

  FutureOr<void> _onKeyPress(KeyPress event, Emitter<GameState> emit) async {
    if (state.isWon || state.isLost) return;
    if (state.pendingGuess.length >= state.secretWord.length) return;

    emit(
      GameState(
        guessed: state.guessed,
        pendingGuess: '${state.pendingGuess}${event.letter}',
        secretWord: state.secretWord,
      ),
    );
  }

  FutureOr<void> _onEnterKeyPress(EnterKeyPress event, Emitter<GameState> emit) async {
    if (state.isWon || state.isLost) return;
    if (state.pendingGuess.length != state.secretWord.length) return;

    final result = <GuessedLetter>[];
    final guessedLetters = state.pendingGuess.split('');
    final secretLetters = state.secretWord.split('').toList();

    bool _isNotExcessive(String gL) {
      return result.where((i) => i.letter == gL).length <
          secretLetters.where((i) => i == gL).length;
    }

    for (var i = 0; i < guessedLetters.length; i++) {
      final gL = guessedLetters[i], sL = secretLetters[i];
      late Correctness correctness;
      if (gL == sL) {
        correctness = Correctness.inSpot;
      } else if (secretLetters.contains(gL) && _isNotExcessive(gL)) {
        correctness = Correctness.inWord;
      } else {
        correctness = Correctness.incorrect;
      }
      result.add(GuessedLetter(
        letter: guessedLetters[i],
        correctness: correctness,
      ));
    }

    emit(
      GameState(
        guessed: [
          ...state.guessed,
          result,
        ],
        pendingGuess: '',
        secretWord: state.secretWord,
      ),
    );
  }

  FutureOr<void> _onDeleteKeyPress(DeleteKeyPress event, Emitter<GameState> emit) async {
    if (state.isWon || state.isLost) return;
    if (state.pendingGuess.isEmpty) return;

    emit(
      GameState(
        guessed: state.guessed,
        pendingGuess: (state.pendingGuess.split('')..removeLast()).join(),
        secretWord: state.secretWord,
      ),
    );
  }
}

abstract class GameEvent {}

class Load extends GameEvent {}

class KeyPress extends GameEvent {
  final String letter;
  KeyPress(this.letter);
}

class EnterKeyPress extends GameEvent {}

class DeleteKeyPress extends GameEvent {}

class GameState with EquatableMixin {
  final List<List<GuessedLetter>> guessed;
  final String pendingGuess;
  final String secretWord;

  GameState({
    this.guessed = const [],
    this.pendingGuess = '',
    this.secretWord = '',
  });

  bool get isWon =>
      guessed.isNotEmpty && guessed.last.every((gl) => gl.correctness == Correctness.inSpot);

  bool get isLost => !isWon && guessed.length >= maxGuesses;

  int get maxGuesses => 5;

  @override
  List<Object?> get props => [
        guessed,
        pendingGuess,
        secretWord,
      ];

  Correctness getCorrectness(String letter) {
    const values = Correctness.values;

    var correctness = Correctness.none;
    for (final word in guessed) {
      for (final l in word) {
        if (l.letter == letter && values.indexOf(l.correctness) > values.indexOf(correctness)) {
          correctness = l.correctness;
        }
      }
    }
    return correctness;
  }
}

enum Correctness { none, incorrect, inWord, inSpot }

extension CorrectnessX on Correctness {
  Color? get color {
    switch (this) {
      case Correctness.incorrect:
        return Colors.red;
      case Correctness.inWord:
        return Colors.yellow;
      case Correctness.inSpot:
        return Colors.green;
      default:
        return null;
    }
  }
}

class GuessedLetter {
  final String letter;
  final Correctness correctness;
  GuessedLetter({required this.letter, required this.correctness});
}
