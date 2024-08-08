import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RateRegistrationPage extends StatefulWidget {
  @override
  _RateRegistrationPageState createState() => _RateRegistrationPageState();
}

class _RateRegistrationPageState extends State<RateRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _buyingCashController = TextEditingController();
  final TextEditingController _buyingTransactionController = TextEditingController();
  final TextEditingController _sellingCashController = TextEditingController();
  final TextEditingController _sellingTransactionController = TextEditingController();

  // Lists to hold the fetched data
  List<Map<String, dynamic>> _banks = [];
  List<Map<String, dynamic>> _currencies = [];

  // Selected values
  int? _selectedBankId;
  int? _selectedCurrencyId;

  @override
  void initState() {
    super.initState();
    _fetchBankData();
    _fetchCurrencyData();
  }

  Future<void> _fetchBankData() async {
    final response = await http.get(Uri.parse('${DATA}/0'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['Data'];
      print(data);
      setState(() {
        _banks = data.map((item) => {
          "id": item['id'],
          "bank_name": item['bank_name'],
        }).toList();
      });
    } else {
      // Handle server error
      print('Failed to load bank data');
    }
  }

  Future<void> _fetchCurrencyData() async {
    final response = await http.get(Uri.parse('$DATA/2'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['Data'];
      print(data);
      setState(() {
        _currencies = data.map((item) => {
          "id": item['id'],
          "name":'${item['name']}--${item['description']}',
        }).toList();
      });
    } else {
      // Handle server error
      print('Failed to load currency data');
    }
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     // Collect data
  //     final int bankId = _selectedBankId!;
  //     final int currencyId = _selectedCurrencyId!;
  //     final double buyingCash = double.parse(_buyingCashController.text);
  //     final double buyingTransaction = double.parse(_buyingTransactionController.text);
  //     final double sellingCash = double.parse(_sellingCashController.text);
  //     final double sellingTransaction = double.parse(_sellingTransactionController.text);
  //
  //     // Process or send data
  //     print('Bank ID: $bankId');
  //     print('Currency ID: $currencyId');
  //     print('Buying Cash: $buyingCash');
  //     print('Buying Transaction: $buyingTransaction');
  //     print('Selling Cash: $sellingCash');
  //     print('Selling Transaction: $sellingTransaction');
  //
  //     // Add your submission logic here, such as sending the data to a backend
  //
  //     // Show confirmation
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Rate registered successfully')),
  //     );
  //   }
  // }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Collect data
      final int bankId = _selectedBankId!;
      final int currencyId = _selectedCurrencyId!;
      final double buyingCash = double.parse(_buyingCashController.text);
      final double buyingTransaction = double.parse(_buyingTransactionController.text);
      final double sellingCash = double.parse(_sellingCashController.text);
      final double sellingTransaction = double.parse(_sellingTransactionController.text);

      // Create a map to hold the form data
      final Map<String, dynamic> formData = {
        'bank_id': bankId,
        'currency_id': currencyId,
        'buying_cash': buyingCash,
        'buying_transaction': buyingTransaction,
        'selling_cash': sellingCash,
        'selling_transaction': sellingTransaction,
      };

      // Send data to the server
      try {
        final response = await http.post(
          Uri.parse('https://api.example.com/register-rate'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(formData),
        );

        if (response.statusCode == 200) {
          // Success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rate registered successfully')),
          );
        } else {
          // Error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register rate')),
          );
        }
      } catch (e) {
        // Network error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Currency Rate')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_banks.isEmpty || _currencies.isEmpty)
                Center(child: CircularProgressIndicator())
              else ...[
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Bank Name'),
                  value: _selectedBankId,
                  items: _banks.map((bank) {
                    return DropdownMenuItem<int>(
                      value: bank['id'],
                      child: Text(bank['bank_name']),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBankId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a bank';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Currency Name'),
                  value: _selectedCurrencyId,
                  items: _currencies.map((currency) {
                    return DropdownMenuItem<int>(
                      value: currency['id'],
                      child: Text(currency['name']),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCurrencyId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a currency';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _buyingCashController,
                  decoration: InputDecoration(labelText: 'Buying Cash Rate'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Please enter a valid buying cash rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _buyingTransactionController,
                  decoration: InputDecoration(labelText: 'Buying Transaction Rate'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Please enter a valid buying transaction rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sellingCashController,
                  decoration: InputDecoration(labelText: 'Selling Cash Rate'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Please enter a valid selling cash rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sellingTransactionController,
                  decoration: InputDecoration(labelText: 'Selling Transaction Rate'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Please enter a valid selling transaction rate';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Register Rate'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
