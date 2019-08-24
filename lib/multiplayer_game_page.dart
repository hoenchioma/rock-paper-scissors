import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rock_paper_scissors/fancy_button.dart';
import 'package:rock_paper_scissors/game_choice.dart';
import 'package:rock_paper_scissors/multiplayer_result_page.dart';
import 'package:rock_paper_scissors/simple_audio_player.dart';

class MultiplayerGamePage extends StatefulWidget {
  @override
  _MultiplayerGamePageState createState() => _MultiplayerGamePageState();
}

final _rockImageLoc = "images/rock_hand.png";
final _paperImageLoc = "images/paper_hand.png";
final _scissorImageLoc = "images/scissor_hand.png";
final _clickMp3Loc = "sounds/click_vol-1.mp3";

class _MultiplayerGamePageState extends State<MultiplayerGamePage> {
  int player = 1;

  GameChoice player1Choice;
  GameChoice player2Choice;

  final audioPlayer = SimpleAudioPlayer();
  final clickAudioFile = SimpleAudioFile();

  @override
  void initState() {
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
              Text(
                "Player $player's move:",
                style: TextStyle(fontSize: 30),
              ),
              LimitedBox(
                child: _buttonSection(),
                maxHeight: 350,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSection() {
    final radius = 1.0;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
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
      if (player == 1) { // if it was player 1 go to player 2
        player1Choice = choice;
        player++;
      } else if (player == 2) { // if it was player 2 go to results page
        player2Choice = choice;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MultiplayerResultPage(player1Choice, player2Choice),
          ),
        );
      }
    });
  }
}
