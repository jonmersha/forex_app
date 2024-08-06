import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CurrencyRatesTable extends StatefulWidget {
  @override
  _CurrencyRatesTableState createState() => _CurrencyRatesTableState();
}

class _CurrencyRatesTableState extends State<CurrencyRatesTable> {
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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Bank Name')),
              DataColumn(label: Text('Currency')),
              DataColumn(label: Text('Buying')),
              DataColumn(label: Flexible(child: Text('Buying Transaction'))),
              DataColumn(label: Text('Selling Cash')),
              DataColumn(label: Text('Selling Transaction')),
            ],
            rows: data.map((item) {
              return DataRow(cells: [
                DataCell(Text(item['bank_name'])),
                DataCell(Text(item['currency_name'])),
                DataCell(Text(item['buying_cash'].toString())),
                DataCell(Text(item['buying_transaction'].toString())),
                DataCell(Text(item['selling_cash'].toString())),
                DataCell(Text(item['selling_transaction'].toString())),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
