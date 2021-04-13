import 'dart:io';
import 'togboard.dart';


void main() {
  stdout.write("Welcome to the Togyz Kumalak World!");
  stdout.write(
      "Enter the mode: (h - human play, m - random machine, r - against random AI) ");
  String mode = stdin.readLineSync().toString();

  if (mode == 'h') {
    bool cancelled = false;
    ToguzBoard tBoard = ToguzBoard();
    tBoard.printPos();

    while ((!cancelled) && (!tBoard.isGameFinished())) {
      stdout.write("Enter your move (1-9, 0 - exit): ");
      String move = stdin.readLineSync().toString();
      int num = int.tryParse(move) ?? 0;

      if (num == 0) {
        cancelled = true;
      } else if ((num > 0) && (num < 10)) {
        tBoard.makeMove(num);
        tBoard.printNotation(true, false);
        tBoard.printPos();
      }
    }

    stdout.write("Game over");
    print(tBoard.getScore());
  } else if (mode == 'm') {
    stdout.write("Enter number of Iterations: ");
    int numIterations = int.tryParse(stdin.readLineSync().toString()) ?? 5;
    final stopwatch = Stopwatch()..start();

    int win = 0;
    int draw = 0;
    int lose = 0;

    for (var i = 0; i < numIterations; i++) {
      ToguzBoard tBoard = ToguzBoard();
      int gRes = tBoard.playRandomGame();

      if (gRes == 1)
        win++;
      else if (gRes == 0)
        draw++;
      else if (gRes == -1) lose++;
    }

    stopwatch.stop();
    print("Win: $win, draw: $draw, lose: $lose");
    print("time ${stopwatch.elapsedMilliseconds / 1000} sec");
  } else if (mode == 'r') {
    stdout.write("AI color (0 - white, 1 - black): ");
    int compColor = int.tryParse(stdin.readLineSync().toString()) ?? 1;

    bool cancelled = false;
    int currentColor;

    ToguzBoard tBoard = ToguzBoard();
    tBoard.printPos();

    while ((!cancelled) && (!tBoard.isGameFinished())) {
      currentColor = tBoard.getCurrentColor();
      if (((currentColor == 0) && (compColor == 1)) ||
          ((currentColor == 1) && (compColor == 0))) {
        stdout.write("Enter your move (1-9, 0 - exit): ");
        int num = int.tryParse(stdin.readLineSync().toString()) ?? 0;

        if (num == 0) {
          cancelled = true;
        } else if ((num > 0) && (num < 10)) {
          tBoard.makeMove(num);
          tBoard.printNotation(true, false);
          tBoard.printPos();
        }
      } else {
        tBoard.makeRandomMove();
        tBoard.printNotation(true, false);
        tBoard.printPos();
      }
    }

    stdout.write("Game over: ${tBoard.getScore()}");
  }
}
