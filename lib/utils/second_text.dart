import 'package:flutter/widgets.dart';
import 'layouts.dart';

class SecondText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  TextOverflow overFlow;

  SecondText(
      {super.key,
      this.color = const Color(0xFFFFFFFF),
      required this.text,
      this.size = 0,
      this.overFlow = TextOverflow.ellipsis});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? Layouts.size25 : size,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w100,
      ),
    );
  }
}
