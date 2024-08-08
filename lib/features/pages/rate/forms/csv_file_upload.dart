import 'package:currency/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';

class CsvUploadPage extends StatefulWidget {
  @override
  _CsvUploadPageState createState() => _CsvUploadPageState();
}

class _CsvUploadPageState extends State<CsvUploadPage> {
  final _formKey = GlobalKey<FormState>();

  // Lists to hold the fetched data
  List<Map<String, dynamic>> _banks = [];

  // Selected bank
  int? _selectedBankId;

  @override
  void initState() {
    super.initState();
    _fetchBankData();
  }

  Future<void> _fetchBankData() async {
    final response = await http.get(Uri.parse('${DATA}/0'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['Data'];
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

  Future<void> _pickAndUploadFile() async {
    if (_selectedBankId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a bank first')),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // Read CSV file and process it
      List<List<dynamic>> csvTable = await _readCsvFile(file);

      // Log or send CSV data
      print('CSV Data: $csvTable');

      // Upload CSV data to the server
      await _uploadCsvData(csvTable);
    } else {
      // User canceled the picker
      print('File selection canceled');
    }
  }

  Future<List<List<dynamic>>> _readCsvFile(File file) async {
    final input = file.openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
    return fields;
  }

  Future<void> _uploadCsvData(List<List<dynamic>> csvData) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/upload-csv'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'bank_id': _selectedBankId,
          'csv_data': csvData,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV data uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload CSV data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload CSV File')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_banks.isEmpty)
                Center(child: CircularProgressIndicator())
              else
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _pickAndUploadFile,
                child: Text('Select and Upload CSV File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
