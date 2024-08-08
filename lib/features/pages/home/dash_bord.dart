import 'package:currency/features/pages/home/chield_page/currency_calculate.dart';
import 'package:currency/features/pages/home/chield_page/group_by_currency.dart';
import 'package:currency/features/pages/home/chield_page/group_by_currency_h.dart';
import 'package:currency/features/pages/rate/forms/csv_file_upload.dart';
import 'package:currency/features/pages/rate/forms/rate_rigistrations.dart';
import 'package:currency/features/pages/home/chield_page/group_by_bank.dart';
import 'package:flutter/material.dart';

class DashBord extends StatefulWidget {
  @override
  _DashBordState createState() => _DashBordState();
}

class _DashBordState extends State<DashBord> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Currency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Banks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return GroupByCurencyH();
      case 1:
        return GroupByBank();
      case 2:
        return CurrencyRatesCalculator();
      default:
        return RateRegistrationPage();
    }
  }
}

class HistoricalRatesPage extends StatelessWidget {
  const HistoricalRatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Historical Rates'),
    );
  }
}

class LowestRatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Lowest Rates'),
    );
  }
}

class ExchangeCalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Exchange Calculator'),
    );
  }
}