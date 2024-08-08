import 'dart:convert';
import 'package:currency/features/methods/methods.dart';
import 'package:currency/features/pages/home/chield_page/calculation_page.dart';
import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyRatesCalculator extends StatefulWidget {
  @override
  _CurrencyRatesCalculatorState createState() => _CurrencyRatesCalculatorState();
}

class _CurrencyRatesCalculatorState extends State<CurrencyRatesCalculator> {
  late Future<Map<String, List<Map<String, dynamic>>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchData() async {
    final response = await http.get(Uri.parse(newRate)); // Replace with your API URL

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> rates = data['Data'];

      // Group by currency_name
      final Map<String, List<Map<String, dynamic>>> groupedData = {};
      for (var item in rates) {
        final currencyName = item['currency_name'];
        if (groupedData.containsKey(currencyName)) {
          groupedData[currencyName]!.add(item as Map<String, dynamic>);
        } else {
          groupedData[currencyName] = [item as Map<String, dynamic>];
        }
      }

      // Sort each currency group by buying_cash
      groupedData.forEach((key, value) {
        value.sort((a, b) => a['buying_cash'].compareTo(b['buying_cash']));
      });

      return groupedData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error: Check Your Connection'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final groupedData = snapshot.data!;

        return ListView(
          children: groupedData.keys.map((currencyName) {
            final rates = groupedData[currencyName]!;

            return Container(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${currencyName}:    ${rates.first['description']}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage('${currencyLogo}/${rates.first['currency_logo']}'),
                                fit: BoxFit.fitHeight
                              )
                          ),
                        ),

                      ],
                    ),
                    const Divider(),
                    Container(
                      child: Column(
                        children: rates.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color:Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child:
                              Container(
                                decoration: BoxDecoration(
                                  color:ColorConverter.fromHex('${item['color_back']}'),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Text(item['bank_name']),
                                    Container(
                                     height: 70,
                                      width: 70,
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        image: DecorationImage(
                                          image: NetworkImage('${staticContent}/${item['logo']}'),
                                          fit: BoxFit.fitWidth

                                        )
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CalculationPage(rate: item),
                                                ),
                                              );
                                            },

                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                //border: Border.all(color: Colors.black54,width: 1)
                                              ),
                                              width: 200,
                                              height: 60,
                                              child: buildText("Buying/Selling ${item['buying_cash']}/${item['selling_cash']}"),),
                                          ),
                                          // Text('Buying: Cash ${item['buying_cash']}'),
                                          // SizedBox(height: 10,),
                                          // Text('Selling: Cash ${item['selling_cash']} '),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
