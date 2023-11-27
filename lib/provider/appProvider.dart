import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/models/addressModel.dart';
import 'package:store_app/models/billOfLanding.dart';
import 'package:store_app/models/createAddressModel.dart';
import 'package:store_app/models/orderCartResponseModel.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/models/storeModel.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/widgets/address/area_by_id_response.dart';
import 'package:store_app/widgets/address/area_response.dart';
import 'package:store_app/widgets/screen/responseUtil.dart';
import 'package:collection/collection.dart';

class AppProvider with ChangeNotifier {
  String userId = "";
  String supplierId = "";
  String uid = "";
  String name = "";
  String avatar = "";
  int countOrder = 0;
  int countOrderMode3 = 0;
  String deliveryTimeMode3 = "";
  late var deliveryFee = 0;
  List<OrderModel> orderListMode1 = [];
  List<OrderModel> orderListMode3 = [];
  late StoreModel storeModel = StoreModel();
  bool status = false;
  late Cart cart = Cart(orderDetail: [], total: 0);
  int modeID = 1;
  var areaName = "";
  int quantity = 0;
  var optionTimeList = [];
  late String deliveryTime = "Chọn khung giờ";
  var deliveryCode = "Fail";
  var isCheck = false;
  var servicesFee = 10000;
  final TextEditingController noteController = TextEditingController();
  var isLoading = false;
  var cartScreenBill = false;
  late List<Address> addressList = [];
  late String building = '';
  late String enteredBuildingId = '';
  late List<Area> area = [];
  late AreaById areaById;
  final TextEditingController areaController = TextEditingController();
  final TextEditingController clusterOfBuildingController =
      TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController enteredAddress = TextEditingController();
  static const baseURL = 'https://api.vhgp.net/api/v1';
  static const BUILDING = "account-building";
  var indexCluster = 0;
  bool isSubmit = false;

  late BillOfLanding billOfLanding;

  Future<int> createAddress() async {
    isSubmit = true;

    if (userNameController.text.isEmpty ||
        phoneController.text.length != 10 ||
        buildingController.text.isEmpty) {
      notifyListeners();
      return -1;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = prefs.getString("user") ?? '';
    UserModel user = UserModel(id: "", name: "", roleId: "", imageUrl: "");
    if (strUser != '') {
      user = userFromJson(strUser);
    }

    String buildingId = areaById.listCluster[indexCluster].listBuilding
        .firstWhere((element) => element.name == buildingController.text)
        .id;

    CreateAddress address = CreateAddress(
        accountId: user.id,
        buildingId: buildingId,
        isDefault: 0,
        soDienThoai: phoneController.text,
        name: userNameController.text);

    // ResponseUtil.postMapping(ApiServices.BUILDING, createAddressToJson(address))
    //     .then((value) {
    var response = await http.post(
      Uri.parse('${baseURL}/${BUILDING}'),
    );
    notifyListeners();
    if (response.statusCode == 500) return 500;
    getAddress();

    isSubmit = true;
    notifyListeners();
    return 200;
  }

  void changeBuilding(dynamic value) {
    if (buildingController.text.isEmpty) {
      buildingController.text =
          areaById.listCluster[indexCluster].listBuilding.first.name;
      building = areaById.listCluster[indexCluster].listBuilding.first.name;
      enteredBuildingId =
          areaById.listCluster[indexCluster].listBuilding.first.id;
      notifyListeners();
      return;
    }
    buildingController.text = areaById.listCluster[indexCluster].listBuilding
        .firstWhere((building) => building.id == value.toString())
        .name;
    building = areaById.listCluster[indexCluster].listBuilding
        .firstWhere((building) => building.id == value.toString())
        .name;
    enteredBuildingId = value.toString();

    notifyListeners();
  }

  void changeCluster(dynamic value) {
    if (clusterOfBuildingController.text.isEmpty) {
      clusterOfBuildingController.text = areaById.listCluster.first.name;
      indexCluster = 0;
      notifyListeners();
      return;
    }
    clusterOfBuildingController.text = areaById.listCluster
        .firstWhere((cluster) => cluster.id == value.toString())
        .name;
    indexCluster = areaById.listCluster
        .indexWhere((cluster) => cluster.id == value.toString());

    buildingController.clear();
    notifyListeners();
  }

  void changeArea(dynamic value) {
    value = value.toString();

    if (areaController.text.isEmpty) {
      areaController.text = area.first.name;
      notifyListeners();
      return;
    }

    areaController.text =
        area.firstWhere((area) => area.id == value.toString()).name;
    getAreaById(value);

    clusterOfBuildingController.clear();
    buildingController.clear();
    notifyListeners();
  }

  // Future<void> getAreaList() async {
  //   isLoading = true;
  //   // Map<String, String> queryParams = {'pageIndex': '1', 'pageSize': '99'};
  //   // ResponseUtil.getMapping(path: ApiServices.AREA, queryParams: queryParams)
  //   //     .then((value) {
  //   //   print(value.body);

  //   var response = await http.get(
  //     Uri.parse(
  //         '${ApiServices.baseURL}/${ApiServices.AREA}?pageIndex=${1}&pageSize=${100}'),
  //   );
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     final body = responseData['data'];
  //     final status = responseData['status'];
  //     if (areaController.text.isEmpty && body.isNotEmpty) {
  //       areaController.text = body[1]['name'];
  //     }
  //     getAreaById(2);
  //   } else if (response.statusCode == 404) {
  //     area = [];
  //   }

  //   isLoading = false;

  //   if (areaController.text == '') {
  //     areaController.text = area[0].name;
  //   }
  //   getAreaById(2);
  //   notifyListeners();
  // }

  // void init() {
  //   getAreaList();
  //   getAreaById(area[0].id.toString());
  // }

  // Future<void> init() async {
  //   try {
  //     await getAreaList();
  //   } catch (error) {
  //     print('Error initializing data: $error');
  //   }
  // }

  Future<List<Area>> getAreaList() async {
    isLoading = true;
    try {
      var response = await http.get(
        Uri.parse(
            '${ApiServices.baseURL}/${ApiServices.AREA}?pageIndex=${1}&pageSize=${100}'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          area = responseData.map((item) => Area.fromJson(item)).toList();

          if (area.isNotEmpty) {
            areaController.text = area[0].name;
          }
        }
        if (area.isNotEmpty) {
          await getAreaById((area[0].id));
        }
      } else if (response.statusCode == 404) {
        area = [];
      }
      isLoading = false;
      if (area.isNotEmpty && areaController.text.isEmpty) {
        areaController.text = area[0].name;
      }
      notifyListeners();
      return area;
    } catch (error) {
      print('Error fetching area list: $error');
      throw ("");
    }
  }

  Future<void> getAreaById(String id) async {
    isLoading = true;
    try {
      var response = await http.get(
        Uri.parse(
          '${ApiServices.baseURL}/${ApiServices.AREA_BY_ID}?areaId=$id&pageIndex=1&pageSize=100',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // print('Response Data: $responseData');
        areaById = AreaById.fromJson(responseData);
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error fetching area by ID: $error');
      throw error;
    }
  }

  // Future<void> getAreaById(String id) async {
  //   isLoading = true;
  //   try {
  //     var response = await http.get(
  //       Uri.parse(
  //         '${ApiServices.baseURL}/${ApiServices.AREA_BY_ID}?areaId=$id',
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       print('Response Data: $responseData');
  //       areaById = AreaById.fromJson(responseData);

  //       isLoading = false;
  //       notifyListeners();
  //     } else {}
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }
  // }

  Future<int> setIsDefault(String id) async {
    ResponseUtil.putIsDefaultMapping(
            '${ApiServices.BUILDING}/address-default', id)
        .then((value) {
      if (value.status == 500) return 500;
      getAddress();
      notifyListeners();
    });

    return 200;
  }

  Future<int> getBuilding(String id) async {
    ResponseUtil.putIsDefaultMapping(
            '${ApiServices.BUILDING}/address-default', id)
        .then((value) {
      if (value.status == 500) return 500;
      getAddress();
      notifyListeners();
    });

    return 200;
  }

  Future<void> getAddress() async {
    print('Get adress');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String strUser = prefs.getString("user") ?? '';
    UserModel user = UserModel(id: "", name: "", roleId: "", imageUrl: "");
    if (strUser != '') {
      user = userFromJson(strUser);
    }

    isLoading = true;
    Map<String, String> queryParams = {
      'pageIndex': '1',
      'pageSize': '99',
      'AccountId': strUser
    };

    var response = await http.get(
      Uri.parse(
          '${ApiServices.baseURL}/${ApiServices.BUILDING}?pageIndex=${1}&pageSize=${100}&AccountId=${userId}'),
    );
    // await ResponseUtil.getMapping(
    //         path: ApiServices.BUILDING, queryParams: queryParams)
    //     .then((value) {
    if (response.statusCode == 200) {
      addressList = addressFromJson(response.body);
      print("building");
      Address? defaultAddress =
          addressList.firstWhereOrNull((element) => element.isDefault == 1);

      if (defaultAddress == null) {
        defaultAddress = addressList.first;
      }

      building = defaultAddress.buildingName;

      cart.fullName = defaultAddress.name;
      cart.buildingName = defaultAddress.buildingName;
      cart.buildingId = defaultAddress.buildingId;
      cart.phoneNumber = defaultAddress.soDienThoai;
      areaName = defaultAddress.areaName;
      isLoading = false;

      notifyListeners();
    }
  }

  static const SUPPLIER = "suppliers";
  Future<void> submitOrder(billOfLanding) async {
    supplierId = userId;

    final String url =
        '${ApiServices.baseURL}/${ApiServices.SUPPLIER}/$supplierId/billOfLanding';

    // Create a Map for the request data
    Map<String, dynamic> requestData = {
      "phoneNumber": billOfLanding.phoneNumber,
      "total": billOfLanding.total,
      "buildingId": billOfLanding.buildingId,
      "note": billOfLanding.note,
      "fullName": billOfLanding.fullName,
      "deliveryTimeId": billOfLanding.deliveryTimeId
    };

    // Convert the data to JSON
    String jsonBody = json.encode(requestData);

    // Send the HTTP POST request with the 'Content-Type' header set to 'application/json'
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    print(response.body);

    if (response.statusCode == 200) {
      status = true;
    }
    notifyListeners();
  }

  void createNote() {
    cart.note = noteController.text;
    noteController.clear();
    notifyListeners();
  }

  void changeQuantity(String productId) {
    for (var orderProduct in cart.orderDetail) {
      if (orderProduct.productId == productId) {
        orderProduct.quantity = quantity.toString();
        break;
      }
    }
    getTotal();
    notifyListeners();
  }

  void deleteProduct(String productId) {
    for (var orderProduct in cart.orderDetail) {
      if (orderProduct.productId == productId) {
        cart.orderDetail.remove(orderProduct);
        break;
      }
    }
    getTotal();
    notifyListeners();
  }

  void setCheck() {
    isCheck = !isCheck;
    isCheck ? cart.total += servicesFee : cart.total -= servicesFee;
    notifyListeners();
  }

  void initOptionTime() {
    // check mode 2 sau 20h ko giao
    // mode 3 giao binh thuopg time = 0
    deliveryTime = "Chọn khung giờ";
    print("initOptionTime");
    optionTimeList.clear();
    int time = DateTime.now().hour;

    if (time <= 20) {
      while (true) {
        int nextTime = time + 2;
        String dateTime = "$time:00- $nextTime:00";
        optionTimeList.add(dateTime);
        time = nextTime;
        if (time >= 20) {
          return;
        }
      }
    }
    print(optionTimeList.length);
  }

  void subtract() {
    quantity -= 1;
    print(quantity);
    notifyListeners();
  }

  void add() {
    quantity += 1;
    notifyListeners();
  }

  void changeOptionTime(int index) {
    deliveryTime = optionTimeList[index];
    notifyListeners();
  }

  Future<void> addProduct(
      dynamic product, bool isCartScreen, BuildContext context) async {
    double totalQuantity = 0;
    if (isCartScreen) {
      for (var orderProduct in cart.orderDetail) {
        if (orderProduct.productId == product.productId) {
          orderProduct.quantity =
              (int.parse(orderProduct.quantity) + 1).toString();
          break;
        }
      }
      getTotal();
      return;
    }

    if (cart.storeId != null && product.storeId != cart.storeId) {
      await showErrorAlertDialog(context);

      cart.orderDetail.clear();
    }
    if (cart.orderDetail.isEmpty) {
      cart.storeName = product.storeName;
      cart.storeId = product.storeId;
      cart.orderDetail.add(OrderDetail(
          price: product.pricePerPack,
          productId: product.id,
          productName: product.name,
          imageUrl: product.image,
          quantity: 1.toString()));
    } else {
      bool isUpdate = false;
      bool isRun = true;
      for (var orderProduct in cart.orderDetail) {
        try {
          if (product.maximumQuantity.toString() != '0') {
            double _packNetWeight = product.packNetWeight.toDouble() ?? 0;
            totalQuantity = int.parse(orderProduct.quantity) * _packNetWeight;

            totalQuantity += product.packNetWeight;

            if (totalQuantity > product.maximumQuantity) {
              showErrorMaximumQuantityAlertDialog(context);
              return;
            }
          }
        } catch (e) {
          print('catch' + e.toString());
        }
        if (orderProduct.productId == product.id) {
          print("set quan tity");
          orderProduct.quantity =
              (int.parse(orderProduct.quantity) + 1).toString();
          isUpdate = true;
          break;
        }
      }
      if (!isUpdate) {
        print("!isUpdate");
        print(!isUpdate);
        cart.orderDetail.add(OrderDetail(
            price: product.pricePerPack,
            productId: product.id,
            productName: product.name,
            imageUrl: product.image,
            quantity: 1.toString()));
      }
    }
    notifyListeners();
  }

  Future<String?> showErrorMaximumQuantityAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/error.png",
                      width: 300, fit: BoxFit.cover),
                  const Text(
                    "Oops...!",
                    style: TextStyle(
                        color: Color.fromRGBO(237, 55, 116, 1),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Bạn đã vượt quá số lượng cho phép.",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(237, 55, 116, 1),
                                Color.fromRGBO(237, 55, 116, 1),
                              ])),
                      child: const Text(
                        'Đóng',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "SF Bold",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> showErrorAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/delete-cart.jpg",
                      width: 300, fit: BoxFit.cover),
                  const Text(
                    "Bạn muốn đặt món ở cửa hàng này?",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Nhưng những món bạn đã chọn từ cửa hàng trước sẽ bị xóa khỏi giỏ hàng nhé.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(170, 178, 189, 1),
                                  Color.fromRGBO(209, 208, 208, 1),
                                ])),
                        child: const Text(
                          'Trở lại',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "SF Bold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(237, 55, 116, 1),
                                  Color.fromRGBO(237, 55, 116, 1),
                                ])),
                        child: const Text(
                          'Tiếp tục',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "SF Bold",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void getTotal() {
    cart.note = '';
    cart.total = 0;
    for (var orderProduct in cart.orderDetail) {
      cart.total += orderProduct.price * int.parse(orderProduct.quantity);
    }
    notifyListeners();
  }

  void setStatus(bool bool) {
    status = bool;
    notifyListeners();
  }

  void setCountOrder(int count) {
    countOrder = count;
    notifyListeners();
  }

  void setCountOrderMode3(int count) {
    countOrderMode3 = count;
    notifyListeners();
  }

  void setOrderListMode1(List<OrderModel> order) {
    orderListMode1 = order;
    notifyListeners();
  }

  void setOrderListMode3(List<OrderModel> order) {
    orderListMode3 = order;
    notifyListeners();
  }

  void setStoreModel(StoreModel store) {
    storeModel = store;
    notifyListeners();
  }

  void setAvatar(img) {
    avatar = img;
    notifyListeners();
  }

  // void setIsLogout() {
  //   status = false;
  //   notifyListeners();
  // }

  void setUserLogin(id) {
    userId = id;
    notifyListeners();
  }

  void setUid(id) {
    uid = id;
    notifyListeners();
  }

  void setName(storeName) {
    name = storeName;
    notifyListeners();
  }

  void showUpdateQuantity(String productId) {
    quantity = int.parse(cart.orderDetail
        .firstWhere(
          (element) => element.productId == productId,
          orElse: () =>
              OrderDetail(productId: 'productId', quantity: '0', price: 1),
        )
        .quantity);
    getTotal();
    notifyListeners();
  }

  bool get getStatus => status;
  String get getUserId => userId;
  String get getAvatar => avatar;
  String get getUid => uid;
  String get getName => name;
  int get getCountOrder => countOrder;
  int get getCountOrderMode3 => countOrderMode3;
  List<OrderModel> get getOrderListMode3 => orderListMode3;
  StoreModel get getStoreModel => storeModel;
}
