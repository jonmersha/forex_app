import 'package:currency/features/pages/home/currency_calculate.dart';
import 'package:currency/features/pages/rate/buying_order_rates.dart';
import 'package:currency/features/pages/rate/list_bank_collum.dart';
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
        title: Text('Forex App'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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
        return BuyingOrdered();
      case 1:
        return CurrencyRatesList();
      case 2:
        return CurrencyRatesCalculator();
      default:
        return Container();
    }
  }
}

class HistoricalRatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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