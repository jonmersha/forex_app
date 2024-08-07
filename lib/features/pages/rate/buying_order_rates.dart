import 'dart:convert';
import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuyingOrdered extends StatefulWidget {
  @override
  _BuyingOrderedState createState() => _BuyingOrderedState();
}

class _BuyingOrderedState extends State<BuyingOrdered> {
  late Future<Map<String, List<Map<String, dynamic>>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchData() async {
    final response = await http.get(Uri.parse(
        newRate)); // Replace with your API URL

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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final groupedData = snapshot.data!;

        return ListView(
          children: groupedData.keys.map((currency_name) {
            final rates = groupedData[currency_name]!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30, width: 1),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            image: DecorationImage(
                                image: NetworkImage(
                                    '$currencyLogo/${rates.first['currency_logo']}'),
                                fit: BoxFit.fitHeight)),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        '${currency_name}:-${rates.first['description']}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(width: 40, child: const Text('')),
                          Container(
                              width: 60, child: buildText('Buying')),
                          Container(width: 70, child: buildText('Selling')),
                          Container(width: 80, child: buildText('Diff')),
                        ],
                      ),
                      Column(
                        children: rates.map((item) {
                          return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                 // color: Colors.grey.shade200,
                                    color:  ColorConverter.fromHex('${item['color_main']}'),

                                    borderRadius: BorderRadius.circular(10)
                                ),
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '$staticContent/${item['logo']}'),
                                              fit: BoxFit.fitHeight)),
                                    ),
                                    // Container(
                                    //     width: 40,
                                    //     child: buildText(item['bank_name'])),
                                    Container(
                                        width: 60,
                                        child: buildTextNumeric('${item['buying_cash']}')),
                                    Container(
                                        width: 70,
                                        child: buildTextNumeric('${item['selling_cash']}')),
                                    Container(
                                        width: 80,
                                        child: buildTextNumeric(
                                            '${item['selling_cash'] - item['buying_cash']}')),
                                  ],
                                ),
                              ));
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Text buildTextNumeric(String text) {
    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,),
    );
  }
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