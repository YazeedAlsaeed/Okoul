import 'package:flutter/widgets.dart';

import 'layouts.dart';

class MainText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  TextOverflow overFlow;
  TextAlign textAlignment;

  MainText(
      {super.key,
      this.color = const Color(0xFF898181),
      required this.text,
      this.size = 0,
      this.overFlow = TextOverflow.ellipsis,
      this.textAlignment = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlignment,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? Layouts.size35 : size,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w100,
      ),
    );
  }
}
