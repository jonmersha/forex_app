import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyRatesList extends StatefulWidget {
  @override
  _CurrencyRatesListState createState() => _CurrencyRatesListState();
}

class _CurrencyRatesListState extends State<CurrencyRatesList> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.11.243.236:3000/forex/rate/new')); // Replace with your API URL

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> rates = data['Data'];

      return rates.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(item['bank_name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Currency: ${item['currency_name']}'),
                    Text('Rate Date: ${item['rate_date']}'),
                    Text('Buying Cash: ${item['buying_cash']}'),
                    Text('Buying Transaction: ${item['buying_transaction']}'),
                    Text('Selling Cash: ${item['selling_cash']}'),
                    Text('Selling Transaction: ${item['selling_transaction']}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
