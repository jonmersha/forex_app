import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
class CalculationPage extends StatefulWidget {
  final Map<String, dynamic> rate;
  CalculationPage({required this.rate});
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  final TextEditingController _amountController = TextEditingController();
  double _convertedAmountBuying = 0.0;
  double _convertedAmountSelling = 0.0;

  void _calculate() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final double buyingRate = double.parse(widget.rate['buying_cash'].toString()); // Use the buying cash rate for conversion
    final double sellingRate = double.parse(widget.rate['selling_cash'].toString()); // Use the buying cash rate for conversion

    setState(() {
      _convertedAmountBuying = amount * buyingRate;
      _convertedAmountSelling = amount * sellingRate;
      //print(_convertedAmount);
      //print(rate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate ${widget.rate['currency_name']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250,
             // width: 70,
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage('${staticContent}/${widget.rate['logo']}'),
                    fit: BoxFit.fitWidth
                  )
              ),
            ),
            Text('${widget.rate['bank_name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            Text('Currency: ${widget.rate['currency_name']}:[${widget.rate['description']}]',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            Text('Buying Rate:    [${widget.rate['buying_cash']}]',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            Text('Selling Rate:   [${widget.rate['selling_cash']}]',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            SizedBox(height: 20.0),
            Column(
              children: [
                Text('Total Buying',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Text('ETB: $_convertedAmountBuying',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                SizedBox(height: 20,),
                Text('Total Selling',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Text('ETB:$_convertedAmountSelling',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              ],
            ),
            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed:(){
                _calculate();
              } ,
              child: Text('Calculate',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}
