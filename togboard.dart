// https://dart.dev/tutorials/server/cmdline

import 'dart:math';


class ToguzBoard {
  static const TUZ = -1;

  List<int> _toguzFields = [];
  List<String> _gameMoves = [];
  bool _finished = false;
  int _gameResult = -2;

  ToguzBoard() {
    for (var i = 0; i < 23; i++) {
      if (i < 18) {
        _toguzFields.add(9);
      } else {
        _toguzFields.add(0);
      }
    }
  }

  int getCurrentColor() {
    return _toguzFields[22];
  }

  String getScore() {
    return _toguzFields[18].toString() + " - " + _toguzFields[19].toString();
  }

  bool isGameFinished() {
    return _finished;
  }

  void printPos() {
    String S = _toguzFields[19].toString().padLeft(3) + " ";

    for (var i = 17; i > 8; i--)
      if (_toguzFields[i] == ToguzBoard.TUZ) {
        S += "  X";
      } else {
        S += " " + _toguzFields[i].toString().padLeft(2);
      }

    S += "\n    ";
    for (var i = 0; i < 9; i++)
      if (_toguzFields[i] == ToguzBoard.TUZ) {
        S += "  X";
      } else {
        S += " " + _toguzFields[i].toString().padLeft(2);
      }
    S += "    " + _toguzFields[18].toString();
    print(S);
  }

  String printNotation(bool needPrint, bool needHeader) {
    String s = "";
    if (needHeader) {
      s += "[Count: $_toguzFields[18] - $_toguzFields[19]]\n\n";
    }

    for (var i = 0; i < _gameMoves.length; i++) {
      if (i == 0) {
        s += "1. " + _gameMoves[i];
      } else if (i % 2 == 0) {
        s += "${i ~/ 2 + 1}. " + _gameMoves[i];
      } else {
        s += " " + _gameMoves[i] + "\n";
      }
    }

    if (needPrint) {
      print(s);
    }
    
    return s;
  }

  void makeRandomMove() {
    int color = _toguzFields[22];
    int numMove;
    List<int> numMoves = [];

    int startRange = 0 + (color * 9);
    int finishRange = 8 + (color * 9);

    for (var i = startRange; i <= finishRange; i++) {
      if (_toguzFields[i] > 0) {
        numMoves.add(i);
      }
    }

    if (numMoves.length == 0) {
      print("No moves (random)!");
      print(_toguzFields);
      _finished = true;
      return;
    } else if (numMoves.length == 1) {
      numMove = numMoves[0];
    } else {
      int numChoice = Random().nextInt(numMoves.length);
      numMove = numMoves[numChoice];
    }

    if (numMove > 8) {
      numMove = numMove - 9 + 1;
    } else {
      numMove = numMove + 1;
    }

    makeMove(numMove);
  }

  void makeMove(int num) {
    int sow;
    int color = _toguzFields[22];
    bool capturedTuzdyk = false;
    int finished_otau;

    int numotau = num + (9 * color) - 1;
    int numkum = _toguzFields[numotau];

    if (numkum <= 0) return;

    if (numkum == 1) {
      _toguzFields[numotau] = 0;
      sow = 1;
    } else {
      _toguzFields[numotau] = 1;
      sow = numkum - 1;
    }

    for (var i = 0; i < sow; i++) {
      numotau++;
      if (numotau > 17) numotau = 0;
      if (_toguzFields[numotau] == ToguzBoard.TUZ) {
        if (numotau > 8) {
          _toguzFields[18]++;
        } else {
          _toguzFields[19]++;
        }
      } else {
        _toguzFields[numotau]++;
      }
    }

    if (_toguzFields[numotau] == 3) {
      if ((color == 0) &&
          (_toguzFields[20] == 0) &&
          (numotau > 8) &&
          (numotau < 17) &&
          (_toguzFields[21] != numotau - 8)) {
        _toguzFields[18] += 3;
        _toguzFields[numotau] = ToguzBoard.TUZ;
        _toguzFields[20] = numotau - 8;
        capturedTuzdyk = true;
      } else if ((color == 1) &&
          (_toguzFields[21] == 0) &&
          (numotau < 8) &&
          (_toguzFields[20] != numotau + 1)) {
        _toguzFields[19] += 3;
        _toguzFields[numotau] = ToguzBoard.TUZ;
        _toguzFields[21] = numotau + 1;
        capturedTuzdyk = true;
      }
    }

    if (_toguzFields[numotau] % 2 == 0) {
      if ((color == 0) && (numotau > 8)) {
        _toguzFields[18] += _toguzFields[numotau];
        _toguzFields[numotau] = 0;
      } else if ((color == 1) && (numotau < 9)) {
        _toguzFields[19] += _toguzFields[numotau];
        _toguzFields[numotau] = 0;
      }
    }

    if (numotau > 8) {
      finished_otau = numotau - 9 + 1;
    } else {
      finished_otau = numotau + 1;
    }

    String moveStr = num.toString() + finished_otau.toString();
    if (capturedTuzdyk) moveStr += "x";
    _gameMoves.add(moveStr);

    _toguzFields[22] = (_toguzFields[22] == 0 ? 1 : 0);
    checkPos();
  }

  void checkPos() {
    int whiteKum = 0, blackKum;

    for (var i = 0; i < 9; i++)
      if (_toguzFields[i] > 0) whiteKum += _toguzFields[i];
    blackKum = 162 - whiteKum - _toguzFields[18] - _toguzFields[19];

    if ((_toguzFields[22] == 0) && (whiteKum == 0)) {
      _toguzFields[19] += blackKum;
    } else if ((_toguzFields[22] == 1) && (blackKum == 0)) {
      _toguzFields[18] += whiteKum;
    }

    if (_toguzFields[18] >= 82) {
      _finished = true;
      _gameResult = 1;
    } else if (_toguzFields[19] >= 82) {
      _finished = true;
      _gameResult = -1;
    } else if ((_toguzFields[18] == 81) & (_toguzFields[19] == 81)) {
      _finished = true;
      _gameResult = 0;
    }
  }

  int playRandomGame() {
    while (!_finished) makeRandomMove();

    return _gameResult;
  }
}
