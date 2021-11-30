import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PlayerModel {
  XFile? picturePlayer;
  int numberPlayer;
  Color? backgroundColor = Colors.white;
  bool selected = false;
  PlayerModel(this.numberPlayer);
}
