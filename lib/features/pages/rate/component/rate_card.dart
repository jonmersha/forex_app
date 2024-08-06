import 'package:flutter/material.dart';

class RateCard extends StatefulWidget {

  const RateCard({super.key});

  @override
  State<RateCard> createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      //height: 500,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.blue.shade300
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('http://10.11.243.236:3000/static/forex/coop.jpeg'),
              fit: BoxFit.fitWidth

            )
          ),
        ),
        Text("Bank Name"),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         Text('Selling',style: TextStyle(color: Colors.white,fontSize: 20),),
         SizedBox(width: 13,),
          Text('Buying',style: TextStyle(color: Colors.white,fontSize: 20),),


        ],
      )
      ],
    ),
    ) ;
  }
}
