import 'dart:async';
import 'package:hash_game/models/HashGameModel.dart';
import 'package:hash_game/screens/HashGame.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: _retornarCameras(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CameraDescription>> snapshot) {
        if (snapshot.hasData && snapshot.data?.first != null) {
          var camera = snapshot.data!.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front);

          if (camera == null) {
            snapshot.data!.first;
          }

          return ChangeNotifierProvider(
              create: (context) => HashGameModel(camera),
              child: MaterialApp(
                title: 'Flutter Jogo da Velha',
                home: HashGame(),
              ));
        } else {
          return MaterialApp(home: Text('Camera não encontrada'));
        }
      },
    );
  }

  Future<List<CameraDescription>>? _retornarCameras() {
    // Obtain a list of the available cameras on the device.
    return availableCameras();
  }
}
