import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dart_random_choice/dart_random_choice.dart';

import 'package:rock_paper_scissors/dashed_separator.dart';
import 'package:rock_paper_scissors/fancy_button.dart';
import 'package:rock_paper_scissors/game_choice.dart';
import 'package:rock_paper_scissors/simple_audio_player.dart';

final _rockImageLoc = "images/rock_hand.png";
final _paperImageLoc = "images/paper_hand.png";
final _scissorImageLoc = "images/scissor_hand.png";
final _clickMp3Loc = "sounds/click_vol-1.mp3";

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameChoice _myChoice;
  GameChoice _opponentChoice;

  int _myScore = 0;
  int _opponentScore = 0;
  bool _myWin = false;
  bool _opponentWin = false;

  final audioPlayer = SimpleAudioPlayer();
  final clickAudioFile = SimpleAudioFile();

  @override
  void initState() {
    _myScore = _opponentScore = 0;
    clickAudioFile.load(_clickMp3Loc);

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _resultSection(
                  _opponentChoice, _opponentScore, _opponentWin, "Computer"),
              DashedSeparator(color: Colors.grey),
              _resultSection(_myChoice, _myScore, _myWin, "You"),
              Expanded(child: _buttonSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultSection(
      GameChoice choice, int score, bool winner, String text) {
    String imageLoc;
    switch (choice) {
      case GameChoice.rock:
        imageLoc = _rockImageLoc;
        break;
      case GameChoice.paper:
        imageLoc = _paperImageLoc;
        break;
      case GameChoice.scissor:
        imageLoc = _scissorImageLoc;
        break;
      default:
        imageLoc = null;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 150,
      child: Stack(
        children: <Widget>[
          /** player type */
          Align(
            alignment: Alignment.centerLeft,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: winner ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
          /** player choice */ 
          Center(
            child: imageLoc != null
                ? Image.asset(
                    imageLoc,
                    color: winner ? Colors.blue : Colors.black,
                  )
                : null,
          ),
          /** player score */
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: 30,
                color: winner ? Colors.blue : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonSection() {
    final radius = 1.0;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
        /** Displays the buttons in a triangular fashion */
        children: <Widget>[
          Align(
            alignment: Alignment(radius * sin(pi / 3), -radius * cos(pi / 3)),
            child: _button(_rockImageLoc, GameChoice.rock),
          ),
          Align(
            alignment: Alignment(-radius * sin(pi / 3), -radius * cos(pi / 3)),
            child: _button(_paperImageLoc, GameChoice.paper),
          ),
          Align(
            alignment: Alignment(0.0, radius),
            child: _button(_scissorImageLoc, GameChoice.scissor),
          ),
        ],
      ),
    );
  }

  Widget _button(String imageLoc, GameChoice option) {
    return FancyButton(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox.fromSize(
          size: Size(80, 80),
          child: Image.asset(imageLoc),
        ),
      ),
      size: 10,
      curve: 50,
      color: Colors.grey[200],
      onPressed: () => _clickAction(option),
    );
  }

  void _clickAction(GameChoice choice) {
    audioPlayer.playSimpleAudio(clickAudioFile);
    setState(() {
      _myChoice = choice;
      _opponentChoice = randomChoice(GameChoice.values);
      if (_myChoice != _opponentChoice) {
        if (_win(_myChoice, _opponentChoice)) {
          _myScore++;
          _myWin = true;
          _opponentWin = false;
        } else {
          _opponentScore++;
          _myWin = false;
          _opponentWin = true;
        }
      } else {
        _myWin = false;
        _opponentWin = false;
      }
    });
  }

  bool _win(GameChoice choice1, GameChoice choice2) {
    return (choice1 == GameChoice.rock && choice2 == GameChoice.scissor) ||
        (choice1 == GameChoice.paper && choice2 == GameChoice.rock) ||
        (choice1 == GameChoice.scissor && choice2 == GameChoice.paper);
  }
}
