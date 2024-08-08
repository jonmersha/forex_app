import 'dart:convert';
import 'package:currency/features/methods/methods.dart';
import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroupByBank extends StatefulWidget {
  @override
  _GroupByBankState createState() => _GroupByBankState();
}

class _GroupByBankState extends State<GroupByBank> {
  late Future<Map<String, List<Map<String, dynamic>>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchData() async {
    final response =
        await http.get(Uri.parse(newRate)); // Replace with your API URL

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> rates = data['Data'];
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
          return const Center(child: Text('Error: Check Your Connection'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final groupedData = snapshot.data!;

        return ListView(
          children: groupedData.keys.map((bankName) {
            final rates = groupedData[bankName]!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),),
                color: ColorConverter.fromHex(rates.first['color_back']),
              ),
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),),
                      color: ColorConverter.fromHex(rates.first['color_main']),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '$staticContent/${rates.first['logo']}'),
                                  fit: BoxFit.fitWidth)),
                        ),
                        const VerticalDivider(
                            //color: Colors.yellow,
                            ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            bankName,
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(width: 40, child: const Text('')),
                            Container(
                                width: 60, child: buildTextTitle('Buying')),
                            Container(
                                width: 70, child: buildTextTitle('Selling')),
                            Container(width: 80, child: buildTextTitle('Diff')),
                          ],
                        ),
                        Column(
                          children: rates.map((item) {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        '$currencyLogo/${item['currency_logo']}'),
                                                    fit: BoxFit.fitHeight)),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          width: 60,
                                          child: buildText(
                                              '${item['buying_cash']}')),
                                      Container(
                                          width: 70,
                                          child: buildTextLabel(
                                              '${item['selling_cash']}')),
                                      Container(
                                          width: 80,
                                          child: buildTextLabel(
                                              '${item['selling_cash'] - item['buying_cash']}')),
                                    ],
                                  ),
                                ));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
