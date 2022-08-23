/*
import 'package:flutter/material.dart';
import 'package:market_app/providers/list_data.dart';
import 'package:market_app/utility/constants.dart';
import 'package:market_app/widgets/futures_table.dart';
import 'package:market_app/widgets/product_table.dart';
import 'package:market_app/widgets/spot_table.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with TickerProviderStateMixin{

  final _tabList = [
    const Tab(text: AppConstant.all),
    const Tab(text: AppConstant.spot),
    const Tab(text: AppConstant.futures),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: _tabList
              /*[
                Tab(child: Text('All', style: TextStyle(fontSize: 20),),),
                Tab(child: Text('Spot', style: TextStyle(fontSize: 20),),),
                Tab(child: Text('Futures', style: TextStyle(fontSize: 20),),),
              ], */
            ),
            centerTitle: true,
            title: Text('Market'),
          ),
          body: TabBarView(
            children: [
              ProductTable(),
              Text('Fire'),
              Text('Tired'),
              //SpotTable(),
              //FuturesTable(),
            ],
          ),
        ),
      ),
    );
  }
}
*/