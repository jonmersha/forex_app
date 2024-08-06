import 'dart:convert';
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
    final response = await http.get(Uri.parse('http://10.11.243.236:3000/forex/rate/new')); // Replace with your API URL

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> rates = data['Data'];

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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final groupedData = snapshot.data!;

        return ListView(
          children: groupedData.keys.map((bankName) {
            final rates = groupedData[bankName]!;

            return ExpansionTile(
              title: Text(bankName),
              children: rates.map((item) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(item['currency_name']),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${item['rate_date']}'),
                        Text('Buying Cash: ${item['buying_cash']}'),
                        //Text('Buying Transaction: ${item['buying_transaction']}'),
                        Text('Selling Cash: ${item['selling_cash']}'),
                        //Text('Selling Transaction: ${item['selling_transaction']}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}
