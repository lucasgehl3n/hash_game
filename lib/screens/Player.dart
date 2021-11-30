import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hash_game/components/TakePictureScreen.dart';
import 'package:hash_game/models/HashGameModel.dart';
import 'package:provider/provider.dart';

class Player extends StatelessWidget {
  final CameraDescription _camera;
  final int playerNumber;
  Player(this._camera, this.playerNumber);
  @override
  Widget build(BuildContext context) {
    return Consumer<HashGameModel>(
      builder: (context, providerGame, child) => Stack(
        children: [
          GestureDetector(
            child: Container(
              height: 100,
              child: Column(
                children: _listaWidgetsPlayer(context, providerGame),
              ),
            ),
            onTap: () {
              _actionClickPlayer(context, providerGame);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _listaWidgetsPlayer(context, providerGame) {
    List<Widget> listaWidgets = [];
    var player = providerGame.getPlayer(playerNumber);
    if (player.picturePlayer != null) {
      listaWidgets.add(_returnPlayerWithPicture(context, player));
    } else {
      listaWidgets.add(_returnPlayerWithoutPicture(context));
    }
    return listaWidgets;
  }

  Widget _returnPlayerWithPicture(context, player) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        color: player.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.0),
            child: Image.file(
              File(player.picturePlayer!.path),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Widget _returnPlayerWithoutPicture(context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        color: Colors.purple.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Selecionar player',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _actionClickPlayer(context, providerGame) async {
    var player = providerGame.getPlayer(playerNumber);
    if (player.picturePlayer == null) {
      await _tirarFoto(context, providerGame);
    } else if (providerGame.checkPlayerReady() &&
        !providerGame.gameInProgress()) {
      _checkSelectionPlayer(context, player, providerGame);
    }
  }

  void _checkSelectionPlayer(context, player, providerGame) {
    if (player.selected == true) {
      unsetPlayer(player, providerGame);
    } else {
      setPlayer(context, providerGame);

      providerGame.startGame();
    }
  }

  void setPlayer(context, providerGame) {
    providerGame.setCurrentMove(playerNumber);
    var numero = providerGame.currentGameIn;
    var text = "Jogador $numero deve iniciar o jogo. Selecione uma peça.";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void unsetPlayer(player, providerGame) {
    providerGame.unsetPlayer(player.numeroplayer);
  }

  Future<void> _tirarFoto(context, providerGame) async {
    var player = providerGame.getPlayer(playerNumber);
    player.picturePlayer = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(_camera),
      ),
    );
    providerGame.setModelPlayer(player);
  }
}
