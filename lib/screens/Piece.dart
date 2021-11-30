import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hash_game/models/HashGameModel.dart';
import 'package:hash_game/models/PieceModel.dart';
import 'package:provider/provider.dart';

class Piece extends StatelessWidget {
  final PieceModel piece;
  const Piece(this.piece);

  Widget build(BuildContext contextWidget) {
    return Consumer<HashGameModel>(
      builder: (context, providerGame, child) => Stack(
        children: [
          GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.29,
              child: returnWidget(context, providerGame),
            ),
            onTap: () {
              _selectPiece(context, providerGame);
            },
          ),
        ],
      ),
    );
  }

  Widget? returnWidget(context, providerGame) {
    if (providerGame.currentGameIn != null &&
        piece.playerSelectedPiece != null) {
      if (providerGame.gameInProgress()) {
        var player = piece.playerSelectedPiece;
        return Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Card(
            color: piece.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: Image.file(
                  File(player!.picturePlayer!.path),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      }
    }
    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        color: Color(0xff6649c4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(""),
        ),
      ),
      //   ),
    );
  }

  void _selectPiece(context, providerGame) {
    providerGame.setSelectedPiece(this.piece);
    if (providerGame.endTie) {
      _tieAlert(context, providerGame);
    } else if (providerGame.winningPlayerNumber == null) {
      providerGame.reverseCurrentMove();
    } else {
      _alertWinnerPlayer(context, providerGame);
    }
  }

  Future<String?> _alertWinnerPlayer(context, providerGame) {
    dynamic _context = context;
    Timer(Duration(seconds: 3), () {
      Navigator.of(_context).pop();
      providerGame.endGame();
    });
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          children: [
            Text('O jogador ${providerGame.winningPlayerNumber} venceu!'),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                color: piece.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: Image.file(
                      File(providerGame
                          .getPlayer(providerGame.winningPlayerNumber)!
                          .picturePlayer!
                          .path),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              providerGame.endGame();
              // providerGame.startGame();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  Future<String?> _tieAlert(context, providerGame) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Fim de jogo!'),
        content: Text('O jogo terminou em empate!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              providerGame.endGame();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
