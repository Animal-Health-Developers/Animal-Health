import 'package:flutter/material.dart';

class Componente11 extends StatelessWidget {
  const Componente11({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff4ec8dd),
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(width: 1.0, color: const Color(0xff000000)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff080808),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
