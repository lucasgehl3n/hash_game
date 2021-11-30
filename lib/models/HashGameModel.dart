import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hash_game/models/PieceModel.dart';
import 'package:hash_game/models/PlayerModel.dart';
import 'package:hash_game/screens/Piece.dart';
import 'package:hash_game/screens/Player.dart';

class HashGameModel extends ChangeNotifier {
  CameraDescription _camera;
  Player? jogador1Widget;
  Player? jogador2Widget;
  PlayerModel? player1Model;
  PlayerModel? player2Model;
  bool endTie = false;
  bool _gameInProgress = false;
  int? currentGameIn;
  int? winningPlayerNumber;
  List<Piece> board = [];
  final _selectedColor = Colors.orangeAccent.shade400;
  final _defaultColor = Color(0xff6649c4);

  HashGameModel(this._camera) {
    jogador1Widget = new Player(_camera, 1);
    jogador2Widget = new Player(_camera, 2);
    player1Model = new PlayerModel(1);
    player2Model = new PlayerModel(2);
    board = initBoard();
  }

  List<Piece> initBoard() {
    return [
      Piece(PieceModel('p1', 1, 1, 0)),
      Piece(PieceModel('p2', 1, 2, 1)),
      Piece(PieceModel('p3', 1, 3, 2)),
      Piece(PieceModel('p4', 2, 1, 3)),
      Piece(PieceModel('p5', 2, 2, 4)),
      Piece(PieceModel('p6', 2, 3, 5)),
      Piece(PieceModel('p7', 3, 1, 6)),
      Piece(PieceModel('p8', 3, 2, 7)),
      Piece(PieceModel('p9', 3, 3, 8))
    ];
  }

  void setModelPlayer(PlayerModel jogadorModel, {bool notify = true}) {
    if (jogadorModel.numberPlayer == 1) {
      this.player1Model = jogadorModel;
    } else if (jogadorModel.numberPlayer == 2) {
      this.player2Model = jogadorModel;
    }
    notifyListeners();
  }

  void setSelectedPiece(PieceModel piece) {
    piece.playerSelectedPiece = getPlayer(this.currentGameIn!);
    checkWinner();
    notifyListeners();
  }

  PlayerModel? getPlayer(int numberPlayer) {
    if (numberPlayer == 1) {
      return player1Model;
    } else if (numberPlayer == 2) {
      return player2Model;
    }
  }

  bool checkPlayerReady() {
    return (this.player1Model?.picturePlayer != null &&
        this.player2Model?.picturePlayer != null);
  }

  void _setWinningPlayer(List<Piece> pieces) {
    for (Piece item in pieces) {
      item.piece.backgroundColor = Colors.green;
    }
  }

  void checkWinner() {
    for (Piece item in board) {
      if (item.piece.playerSelectedPiece != null) {
        var linePieces = board
            .where((x) =>
                x.piece.line == item.piece.line &&
                x.piece.playerSelectedPiece == item.piece.playerSelectedPiece)
            .toList();

        if (linePieces.length == 3) {
          _setWin(linePieces.first.piece.playerSelectedPiece);
          _setWinningPlayer(linePieces);
          return;
        }

        var columPieces = board
            .where((x) =>
                x.piece.column == item.piece.column &&
                x.piece.playerSelectedPiece == item.piece.playerSelectedPiece)
            .toList();

        if (columPieces.length == 3) {
          _setWin(columPieces.first.piece.playerSelectedPiece);
          _setWinningPlayer(columPieces);
          return;
        }

        //Verificando diagonal A
        var diagonalA =
            board.where((x) => (x.piece.column == x.piece.line)).toList();
        //Se todas as pecas forem iguais, ganhou
        if (diagonalA.every((x) =>
                x.piece.playerSelectedPiece ==
                diagonalA.first.piece.playerSelectedPiece) &&
            diagonalA.every((x) => x.piece.playerSelectedPiece != null)) {
          _setWin(columPieces.first.piece.playerSelectedPiece);
          _setWinningPlayer(diagonalA);
          return;
        }

        var diagonalB = board
            .where((x) => ((x.piece.column == 3 && x.piece.line == 1) ||
                (x.piece.column == 1 && x.piece.line == 3) ||
                (x.piece.column == 2 && x.piece.line == 2)))
            .toList();

        //Se todas as pecas forem selecionadas pelo mesmo player, ganhou
        if (diagonalB.every((x) =>
                x.piece.playerSelectedPiece ==
                diagonalB.first.piece.playerSelectedPiece) &&
            diagonalB.every((x) => x.piece.playerSelectedPiece != null)) {
          _setWin(columPieces.first.piece.playerSelectedPiece);
          _setWinningPlayer(diagonalB);
          return;
        }

        if (!board.any((x) => x.piece.playerSelectedPiece == null)) {
          endTie = true;
        }
      }
    }
  }

  void _setWin(PlayerModel? winningPlayer) {
    if (winningPlayer != null) {
      winningPlayerNumber = winningPlayer.numberPlayer;
    }
    notifyListeners();
  }

  void setCurrentMove(int currentGameInPlayer) {
    this.currentGameIn = currentGameInPlayer;
    if (currentGameInPlayer == 1) {
      //Setar selecionado
      this.player1Model!.backgroundColor = _selectedColor;
      this.player1Model!.selected = true;

      //Setar desmarcado
      this.player2Model!.backgroundColor = _defaultColor;
      this.player2Model!.selected = false;
    } else if (currentGameInPlayer == 2) {
      //Setar selecionado
      this.player2Model!.backgroundColor = _selectedColor;
      this.player2Model!.selected = true;

      //Setar desmarcado
      this.player1Model!.backgroundColor = _defaultColor;
      this.player1Model!.selected = false;
    }

    notifyListeners();
  }

  void unsetPlayer(int jogadorJogadaAtual) {
    if (jogadorJogadaAtual == 1) {
      this.player1Model!.backgroundColor = _defaultColor;
      this.player1Model!.selected = false;
      this.currentGameIn = null;
    } else if (jogadorJogadaAtual == 2) {
      this.player2Model!.backgroundColor = _defaultColor;
      this.player2Model!.selected = false;
      this.currentGameIn = null;
    }
    notifyListeners();
  }

  void clearCurrentMove() {
    this.currentGameIn = null;
    player1Model!.selected = false;
    player2Model!.selected = false;
    this.player2Model!.backgroundColor = _defaultColor;
    this.player1Model!.backgroundColor = _defaultColor;
  }

  void reverseCurrentMove() {
    if (this.currentGameIn == 1) {
      setCurrentMove(2);
    } else if (this.currentGameIn == 2) {
      setCurrentMove(1);
    }
  }

  void startGame() {
    _gameInProgress = true;
  }

  void endGame() {
    clearCurrentMove();
    board = initBoard();
    currentGameIn = null;
    winningPlayerNumber = null;
    endTie = false;
    _gameInProgress = false;
    notifyListeners();
  }

  void restartBoard() {
    this.endGame();
    jogador1Widget = new Player(_camera, 1);
    jogador2Widget = new Player(_camera, 2);
    player1Model = new PlayerModel(1);
    player2Model = new PlayerModel(2);
  }

  bool gameInProgress() {
    return _gameInProgress;
  }
}
