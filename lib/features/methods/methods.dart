
import 'package:flutter/material.dart';


Text buildText(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black),
  );
}

Text buildTextNumeric(String text) {
  return Text(
    overflow: TextOverflow.ellipsis,
    text,
    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20,color: Colors.black),
  );
}

Text buildTextLabel(String text) {
  return Text(
    overflow: TextOverflow.ellipsis,
    text,
    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.black),
  );
}

Text buildTextTitle(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black),
  );
}


class ColorConverter {
  // Method to convert a color string to a Color object
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Container ContainerHeader({required Widget child, required Color color}){
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color:color,
      borderRadius: BorderRadius.only(topLeft:Radius.circular(10) ,topRight:Radius.circular(10) )

    ),
    child: child,
  );


}
