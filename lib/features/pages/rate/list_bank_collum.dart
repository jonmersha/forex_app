import 'dart:convert';
import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyRatesList extends StatefulWidget {
  @override
  _CurrencyRatesListState createState() => _CurrencyRatesListState();
}

class _CurrencyRatesListState extends State<CurrencyRatesList> {
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

      // Group by bank
      // final Map<String, List<Map<String, dynamic>>> groupedData = {};
      // for (var item in rates) {
      //   final bankName = item['bank_name'];
      //   if (groupedData.containsKey(bankName)) {
      //     groupedData[bankName]!.add(item as Map<String, dynamic>);
      //   } else {
      //     groupedData[bankName] = [item as Map<String, dynamic>];
      //   }
      // }
      // // Sort each bank's list by currency_id
      // groupedData.forEach((key, value) {
      //   value.sort((a, b) => a['currency_id'].compareTo(b['currency_id']));
      // });

      // Sort the entire list first by bank_id and then by currency_id
      rates.sort((a, b) {
        int bankComparison = a['bank_id'].compareTo(b['bank_id']);
        if (bankComparison != 0) return bankComparison;
        return a['currency_id'].compareTo(b['currency_id']);
      });

      // Group by bank
      final Map<String, List<Map<String, dynamic>>> groupedData = {};
      for (var item in rates) {
        final bankName = item['bank_name'];
        if (groupedData.containsKey(bankName)) {
          groupedData[bankName]!.add(item as Map<String, dynamic>);
        } else {
          groupedData[bankName] = [item as Map<String, dynamic>];
        }
      }

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
          children: groupedData.keys.map((bankName) {
            final rates = groupedData[bankName]!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black54, width: 1),
                color: Colors.white30,
              ),
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '$staticContent/${rates.first['logo']}'),
                                  fit: BoxFit.fitWidth)),
                        ),
                        const VerticalDivider(
                          color: Colors.yellow,
                        ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            bankName,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  alignment: Alignment.centerLeft,
                                  height: 40,
                                 // color: const Color(0x'${item['color_main'].toString()}'),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(

                                        children: [
                                          Container(
                                            height: 40,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        '$currencyLogo/${item['currency_logo']}'),
                                                    fit: BoxFit.fitWidth)),
                                          ),
                                          // Container(
                                          //     width: 40,
                                          //     child: buildText(item['currency_name'])),
                                        ],
                                      ),
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
      text,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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