import 'package:flutter/material.dart';
import 'package:market_app/providers/list_data.dart';
import 'package:market_app/providers/products.dart';
import 'package:market_app/utility/constants.dart';
import 'package:market_app/utility/volume_generator.dart';

class ProductTable extends StatefulWidget {

  const ProductTable( {Key? key}) : super(key: key);

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> with TickerProviderStateMixin{

  final _tabList = [
    const Tab(text: AppConstant.all),
    const Tab(text: AppConstant.spot),
    const Tab(text: AppConstant.futures),
  ];
  int _selectedTabIndex = 0;
  int? sortColumnIndex;
  bool isAscending = true;
  bool noSearch = false;
  late List<List_data> dataList;
  late TabController _tabController;
  List<List_data> onSearch = [];

  void get _tabControllerListener =>
      _tabController.addListener(() {
        setState(() {
          _selectedTabIndex = _tabController.index;
          switch (_selectedTabIndex) {
            case 0:
              dataList = allProducts;
              isAscending = true;
              break;
            case 1:
              dataList = getSpotList;
              isAscending = true;
              break;
            case 2:
              dataList = getFuturesList;
              isAscending = true;
              break;

          }
        });
      });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);

   dataList = allProducts;
    _tabControllerListener;
  }

final TextEditingController? _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
            controller: _tabController,
            tabs: _tabList
        ),
        toolbarHeight: 1,
      ),
     body:
     Column(
       children: [
         Container(
           decoration: BoxDecoration(color: Colors.blue.shade200,
               borderRadius: BorderRadius.circular(30)),
           child: TextField(
             onChanged: onSearchOnChanged,
             controller: _textEditingController,
             decoration: const InputDecoration(
               border: InputBorder.none,
               errorBorder:InputBorder.none,
               enabledBorder: InputBorder.none,
               focusedBorder: InputBorder.none,
               contentPadding: EdgeInsets.all(15),
               hintText: 'Search',
             ),
           ),
          ),
           noSearch ?
            Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: const [
                 Icon(Icons.search_off),
                 Text('No results found', style: TextStyle(
                     fontSize: 35, fontWeight: FontWeight.bold
                 ),),
               ],
             ),
           ):

                 Expanded(
                   child: ListView(children: <Widget>[
                     SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
                      sortAscending: isAscending,
                       sortColumnIndex: sortColumnIndex,
                     columns: getColumns,
                     rows: _getDataTableRows,
                     ),

    ),
  ],
                   ),
                 ),
       ],
     ),
    );
  }

  List<DataColumn> get getColumns => [
      DataColumn(
      label: const Text(AppConstant.base),
      onSort: onSort,
     ),
      const DataColumn(
        label: Text(AppConstant.quote),
      ),
    const DataColumn(
      label: Text(AppConstant.type),
    ),
    DataColumn(
      label: const Text(AppConstant.lastPrice),
      onSort: onSort,
    ),
    DataColumn(
      label: const Text(AppConstant.volume),
      onSort: onSort,
    ),
  ];


  List<DataRow> get _getDataTableRows => dataList
      .map((product) => DataRow(
    cells: [
      DataCell(Align(alignment: Alignment.centerLeft, child: Text(product.base + '/' + product.quote))),
      DataCell(Text(product.quote)),
      DataCell(Text(product.type)),
      DataCell(Align(alignment: Alignment.centerRight, child: Text('\$${product.lastPrice}'))),
      DataCell(Align(alignment: Alignment.centerRight, child: Text(product.volume.toString().toKBMFormat())))
    ],
  ))
      .toList();

  List<List_data> get getSpotList => allProducts
      .where((listData) => listData.type.toUpperCase() == AppConstant.spot).toList();

  List<List_data> get getFuturesList => allProducts
      .where((listData) => listData.type.toUpperCase() == AppConstant.futures).toList();

  void get _sortPriceAscen => dataList.sort(
      (price1, price2) => price2.lastPrice.compareTo(price1.lastPrice)
  );

  void get _sortPriceDesc => dataList.sort(
      (price1, price2) => price1.lastPrice.compareTo(price2.lastPrice),
  );

  void get _sortBQTAscen => dataList.sort(
      (values1 ,values2) =>
      (values1.base + values1.quote + values1.type).toString().toLowerCase().
      compareTo(
          (values2.base + values2.quote + values2.type).toString().toLowerCase(),
      ),
  );

  void get _sortBQTDesc => dataList.sort(
        (values1 ,values2) =>
        (values2.base + values2.quote + values2.type).toString().toLowerCase().
        compareTo(
          (values1.base + values1.quote + values1.type).toString().toLowerCase(),
        ),
  );

  void get _sortVolumeAscen =>
      dataList.sort((volume1, volume2) => volume2.volume.compareTo(volume1.volume));

  void get _sortVolumeDesc =>
      dataList.sort((volume1, volume2) => volume1.volume.compareTo(volume2.volume));


  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 3) {
      ascending ? _sortPriceAscen : _sortPriceDesc;
    } else if (columnIndex == 0) {
      ascending ? _sortBQTAscen : _sortBQTDesc;
    } else if (columnIndex == 4){
      ascending ? _sortVolumeAscen : _sortVolumeDesc;
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  List<List_data> get getCurrentList => _selectedTabIndex == 1 ?
      dataList = getSpotList :
      _selectedTabIndex == 2 ?
          dataList = getFuturesList : dataList = allProducts;

  void onSearchOnChanged(String value) {
    if (value.isEmpty){
      dataList = getCurrentList;
      onSearch = dataList;
    }
    if (noSearch) {
      dataList = getCurrentList;
      noSearch = false;
      onSearch = dataList;
    } else {
      dataList = getCurrentList;
      onSearch = dataList;
    }



    onSearch = dataList.where((element) {
      final base = element.base.toLowerCase();
      final type = element.type.toLowerCase();
      final lastPrice = element.lastPrice.toString().toLowerCase();
      final volume = element.volume.toString().toKBMFormat().toLowerCase();
      return base.contains(value) ||
          type.contains(value) ||
          lastPrice.contains(value) ||
          volume.contains(value);
    }).toList();

    (onSearch.isNotEmpty)
        ? dataList = onSearch
        : noSearch = true;


    setState(() {

    });
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }

    return Colors.transparent;
  }

}
