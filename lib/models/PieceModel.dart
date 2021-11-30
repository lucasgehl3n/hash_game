import 'package:flutter/material.dart';
import 'package:hash_game/models/PlayerModel.dart';

class PieceModel {
  final String name;
  final int line;
  final int column;
  final int idPiece;
  PlayerModel? playerSelectedPiece;
  Color? backgroundColor = Color(0xff6649c4);

  PieceModel(this.name, this.line, this.column, this.idPiece);
}
