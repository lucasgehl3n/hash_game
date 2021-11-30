import 'package:flutter/material.dart';
import 'package:hash_game/models/HashGameModel.dart';
import 'package:provider/provider.dart';

class RestartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 100,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 80,
              child: Card(
                color: Color(0xff2a1c53),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'C',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("AlertDialog"),
              content: Text(
                  "Deseja descartar as informações atuais e reiniciar a partida?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    var _provider =
                        Provider.of<HashGameModel>(context, listen: false);
                    _provider.restartBoard();
                    Navigator.pop(context);
                  },
                  child: Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
