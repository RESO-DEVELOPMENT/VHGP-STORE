import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/widgets/menuTab/order_tab.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String storeId;
  HomeScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isLoading = true;
  late bool _isLoadingMore = false;
  late bool isListFull = false;
  late int page = 1;

  late List<ProductModel> listProduct = [];

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    List<OrderModel> orderListMode3 = [];
    List<OrderModel> orderListMode1 = [];
    super.initState();
    var storeId = context.read<AppProvider>().getUserId;
    ApiServices.getListOrderByMode(storeId, "3", 1, 100).then((res) => {
          if (res != null)
            {
              orderListMode3 = res,
              if (orderListMode3.isNotEmpty)
                {
                  context.read<AppProvider>().setOrderListMode3(orderListMode3),
                  context
                      .read<AppProvider>()
                      .setCountOrderMode3(orderListMode3.length)
                }
              else
                {
                  context.read<AppProvider>().setOrderListMode3([]),
                  context.read<AppProvider>().setCountOrderMode3(0)
                }
            }
          else
            {context.read<AppProvider>().setOrderListMode3([])}
        });

    ApiServices.getListOrderByMode(storeId, "1", 1, 100).then((res) => {
          if (res != null)
            {
              orderListMode1 = res,
              if (orderListMode1.isNotEmpty)
                {
                  context.read<AppProvider>().setOrderListMode1(orderListMode1),
                  context
                      .read<AppProvider>()
                      .setCountOrder(orderListMode1.length)
                }
              else
                {
                  context.read<AppProvider>().setOrderListMode1([]),
                  context.read<AppProvider>().setCountOrder(0)
                }
            }
          else
            {context.read<AppProvider>().setOrderListMode1([])}
        });
  }

  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(
            // icon: Icon(Icons.cloud_outlined),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3),
                  width: 85,
                  child: Text(
                    "Hiện tại",
                    textAlign: TextAlign.center,
                  ),
                ),
                if (context.read<AppProvider>().getCountOrder > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 15,
                      width: 15,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 93, 82),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        context.read<AppProvider>().getCountOrder.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            // text: "Hiện tại",
          ),
          Tab(
            // icon: Icon(Icons.beach_access_sharp),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3),
                  width: 85,
                  child: Text(
                    "Đang giao",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Tab(
            // icon: Icon(Icons.brightness_5_sharp),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 3, right: 5),
                  width: 85,
                  child: Text(
                    "Đặt trước",
                    textAlign: TextAlign.center,
                  ),
                ),
                if (context.read<AppProvider>().getOrderListMode3.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 15,
                      width: 15,
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 243, 93, 82),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        context
                            .read<AppProvider>()
                            .getCountOrderMode3
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      var storeId = context.read<AppProvider>().getUserId;
      return DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                // backgroundColor: Color.fromARGB(255, 255, 255, 255),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(243, 255, 85, 76),
                          Color.fromARGB(255, 249, 136, 36),
                        ]),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "Đơn hàng",
                  style: TextStyle(
                      color: MaterialColors.white, fontFamily: "SF Bold"),
                ),
                bottom: PreferredSize(
                  preferredSize: _tabBar.preferredSize,
                  child: ColoredBox(color: Colors.white, child: _tabBar),
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: <Widget>[
                      OrderTab(storeId: storeId, tab: 1),
                      OrderTab(storeId: storeId, tab: 2),
                      OrderTab(storeId: storeId, tab: 3),
                    ],
                  ),
                  Positioned(
                    right: 15,
                    bottom: 15,
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: const [
                            Color.fromARGB(243, 255, 85, 76),
                            Color.fromARGB(255, 249, 136, 36),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.black),
                            padding: EdgeInsets.all(0),
                            elevation:
                                0, // Remove button elevation if not needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors
                                .transparent, 
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                              Padding(padding: EdgeInsets.all(3)),
                              Text(
                                "Tạo vận đơn",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "SF Bold",
                                    fontSize: 17),
                              ),
                            ],
                          ),
                          onPressed: () => {
                                Navigator.pushNamed(context, '/cart')
                                    .then((_) => setState(() {
                                          isLoading = true;
                                          _isLoadingMore = false;
                                          page = 1;
                                          listProduct = [];
                                          ApiServices.getListProduct(
                                                  widget.storeId, 1, 8)
                                              .then((value) => {
                                                    if (value != null)
                                                      {
                                                        setState(() {
                                                          listProduct = value;
                                                          isLoading = false;
                                                          _isLoadingMore =
                                                              false;
                                                          isListFull = false;
                                                          page++;
                                                        }),
                                                      }
                                                  });
                                        }))
                              }),
                    ),
                  ),
                ],
              )));
    });
  }
}
