import 'dart:convert';
import 'package:currency/features/methods/methods.dart';
import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroupByCuurency extends StatefulWidget {
  @override
  _GroupByCuurencyState createState() => _GroupByCuurencyState();
}

class _GroupByCuurencyState extends State<GroupByCuurency> {
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
          //return Center(child: Text('Error: ${snapshot.error}'));
          return const Center(child: Text('Error: Check Your Connection'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final groupedData = snapshot.data!;

        return ListView(
          children: groupedData.keys.map((currency_name) {
            final rates = groupedData[currency_name]!;
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),

                  //BorderRadius.circular(20),
                  color: ColorConverter.fromHex('FFFFFF'),
                  border: Border.all(color: Colors.black, width: 1),
                  ),
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContainerHeader(
                    color: Colors.grey.shade100,
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(
                                  '$currencyLogo/${rates.first['currency_logo']}'),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
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
                  ),
                  // const Divider(),
                  Column(
                    children: [
                      Column(
                        children: rates.map((item) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorConverter.fromHex(
                                        '${item['color_back']}'),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 100,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '$staticContent/${item['logo']}'),
                                              fit: BoxFit.fitHeight)),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 4),
                                          width: 230,
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                child: buildText('Buying'),
                                              ),
                                              Container(
                                                width: 120,
                                                child: buildTextNumeric(
                                                    '${item['buying_cash']}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 2),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child:
                                                    buildTextNumeric('Selling'),
                                              ),
                                              SizedBox(
                                                  width: 120,
                                                  child: buildTextNumeric(
                                                      '${item['selling_cash']}')),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 2),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                child: buildText('change'),
                                              ),
                                              Container(
                                                  width: 120,
                                                  child: buildTextNumeric(
                                                      '${item['selling_cash'] - item['buying_cash']}')),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
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
}
