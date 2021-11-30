import 'package:flutter/material.dart';
import 'package:hash_game/components/RestartButton.dart';
import 'package:hash_game/models/HashGameModel.dart';
import 'package:provider/provider.dart';

class HashGame extends StatelessWidget {
  const HashGame();

  @override
  Widget build(BuildContext context) {
    return Consumer<HashGameModel>(
      builder: (context, providerGame, child) => Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: Color(0xff342185),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: providerGame.board[0],
                        ),
                        Expanded(
                          flex: 3,
                          child: providerGame.board[1],
                        ),
                        Expanded(
                          flex: 3,
                          child: providerGame.board[2],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: providerGame.board[3],
                        ),
                        Expanded(
                          flex: 3,
                          child: providerGame.board[4],
                        ),
                        Expanded(
                          flex: 3,
                          child: providerGame.board[5],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: providerGame.board[6],
                        ),
                        Expanded(
                          flex: 3,
                          child: providerGame.board[7],
                        ),
                        Expanded(
                          flex: 3,
                          child: providerGame.board[8],
                        ),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                        child: providerGame.jogador1Widget!,
                        flex: 3,
                      ),
                      Expanded(
                        child: providerGame.jogador2Widget!,
                        flex: 3,
                      ),
                      Expanded(
                        child: RestartButton(),
                        flex: 3,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
