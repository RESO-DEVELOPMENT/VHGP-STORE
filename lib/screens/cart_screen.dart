import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constants/Variable.dart';
import 'package:store_app/models/billOfLanding.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:intl/intl.dart';
import 'package:store_app/widgets/color/colors.dart';
import 'package:store_app/widgets/screen/cart_add_product.dart';
import 'package:store_app/widgets/screen/font_awesome_flutter.dart';
import 'package:store_app/widgets/screen/user_info.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String deliveryMode = "Giao nhanh 30 phút";
  late Cart cartController;
  final AppProvider controller = AppProvider();

  final String deliveryMode2 = "GIAO HÀNG TRONG NGÀY";
  final NumberFormat viCurrency = NumberFormat('#,##0 ₫', 'vi_VN');
  String enteredAddress = "Giao đến đâu";
  bool cartScreenBill = false;
  bool isCheckedMoney = false;
  final TextEditingController moneyInputController = TextEditingController();
  final TextEditingController noteInputController = TextEditingController();
  double totalMoney = 0;
  int paymentType = 0;

  @override
  void initState() {
    controller.getAddress();
    cartController = context.read<AppProvider>().cart;
    if (context.read<AppProvider>().cartScreenBill) {
      enteredAddress = context.read<AppProvider>().buildingController.text +
          ", " +
          context.read<AppProvider>().areaController.text;
      cartScreenBill = true;
    } else {
      context.read<AppProvider>().userNameController.text = "";
      context.read<AppProvider>().phoneController.text = "";
      context.read<AppProvider>().buildingController.text = "";
      context.read<AppProvider>().clusterOfBuildingController.text = "";
      context.read<AppProvider>().areaController.text = "";
    }
    context.read<AppProvider>().cartScreenBill = false;
    context.read<AppProvider>().quantity = 0;
    if (context.read<AppProvider>().modeID == 2) {
      deliveryMode = deliveryMode2;
      context.read<AppProvider>().initOptionTime();
    } else if (context.read<AppProvider>().modeID == 3) {
      context.read<AppProvider>().initOptionTime();
      deliveryMode = context.read<AppProvider>().deliveryTimeMode3;
    } else {
      context.read<AppProvider>().deliveryTime =
          "${dateFormat.format(DateTime.now().add(const Duration(minutes: 20)))} - ${dateFormat.format(DateTime.now().add(const Duration(minutes: 30)))}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "SF Bold",
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(243, 255, 85, 76),
                  Color.fromARGB(255, 249, 136, 36)
                ]),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Giao đến',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              final appProvider = context.read<AppProvider>();
                              appProvider.getAreaList();
                              appProvider.getAddress();
                              if (!cartScreenBill) {
                                Navigator.pushReplacementNamed(
                                    context, '/create-order');
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white),
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 5),
                                      child: Row(
                                        children: [
                                          ShaderMask(
                                            shaderCallback: (Rect bounds) {
                                              return const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 250, 159, 56),
                                                  Color(0xfff7892b)
                                                ],
                                              ).createShader(bounds);
                                            },
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            enteredAddress,
                                            style: cartScreenBill
                                                ? const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  )
                                                : const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Được giao từ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              GestureDetector(
                                child: Text(
                                  '${context.read<AppProvider>().storeModel.name}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Hinh thuc giao hang
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hình thức giao hàng',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              Text(deliveryMode,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 25, 139, 29),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Thong tin nguoi nhan
                          if (cartScreenBill)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tên người nhận:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                          '${context.read<AppProvider>().userNameController.text}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Số điện thoại:',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                          '${context.read<AppProvider>().phoneController.text}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          const SizedBox(
                            height: 30,
                          ),

                          //Ghi chu
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                child: TextField(
                                  controller: noteInputController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Chi tiết đơn hàng ...',
                                    prefixIcon: const Icon(Icons.note),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        noteInputController.clear();
                                      },
                                    ),
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Thu ho
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Thu tiền hộ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Checkbox(
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                                value: isCheckedMoney,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedMoney = value ?? false;
                                    if (isCheckedMoney) {
                                      paymentType = 0;
                                      _showPopupDialog();
                                    } else {
                                      paymentType = 2;
                                      moneyInput = "0₫";
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, size: 22),
                                onPressed: () {
                                  setState(() {
                                    _showPopupDialog();
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/images/moneys.png",
                              height: 20,
                            ),
                            const Text(
                              'Tiền mặt',
                              style: TextStyle(fontSize: 18),
                            ),
                            const ImageIcon(
                              AssetImage("assets/images/arrow_user.png"),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "SF Bold"),
                            ),
                            Text(
                              moneyInput ?? "0₫",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (context
                                      .read<AppProvider>()
                                      .buildingController
                                      .text !=
                                  "" &&
                              noteInputController.text != "" &&
                              moneyInputController.text != "") {
                            builderConfirmOrder(context);
                          } else {
                            showMissingFieldsDialog(context);
                          }
                        },
                        child: Container(
                          child: Text(
                            'Tạo đơn',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "SF Bold"),
                          ),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                                  Color.fromARGB(243, 255, 85, 76),
                                  Color.fromARGB(255, 249, 136, 36)
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMissingFieldsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Missing Fields",
            style: TextStyle(
              fontFamily: "SF Bold",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            "Please fill in all the necessary fields before proceeding.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String? moneyInput = "0₫";
  void _showPopupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thu tiền hộ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nhập số tiền (VD: 10.000₫)',
                ),
                controller: moneyInputController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  moneyInput = moneyInputController.text;
                  double? myMoneyStateVariable =
                      double.tryParse(moneyInput ?? "");
                  if (myMoneyStateVariable != null) {
                    // viCurrency.format(myMoneyStateVariable);
                    moneyInputController.text =
                        myMoneyStateVariable.floor().toString();
                    moneyInput = viCurrency.format(myMoneyStateVariable);
                    totalMoney = myMoneyStateVariable;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  _buildOrderProductDetail() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartController.orderDetail.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'x${context.read<AppProvider>().cart.orderDetail[index].quantity}',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.read<AppProvider>().cart.orderDetail[index].productName}',
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: TextButton(
                            onPressed: () {
                              context.read<AppProvider>().showUpdateQuantity(
                                  context
                                      .read<AppProvider>()
                                      .cart
                                      .orderDetail[index]
                                      .productId);
                              _showUpdateProduct(
                                  context,
                                  context
                                      .read<AppProvider>()
                                      .cart
                                      .orderDetail[index]);
                            },
                            child: const Text('Chỉnh sửa',
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ]),
                ),
              ),
              Text(
                viCurrency.format(cartController.orderDetail[index].price),
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildInformation(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              UserInformation(
                cartController: cartController,
                label: 'Tên người nhận',
                value: context.read<AppProvider>().cart.fullName ?? '',
                faIcon: FontAwesomeIcons.solidUser,
              ),
              UserInformation(
                cartController: cartController,
                label: 'Số điện thoại',
                value: context.read<AppProvider>().cart.phoneNumber ?? '',
                faIcon: FontAwesomeIcons.phone,
              ),
              InkWell(
                onTap: () => _showWarning(context),
                child: UserInformation(
                  cartController: cartController,
                  label: 'Lưu ý',
                  value: context.read<AppProvider>().cart.note ?? '',
                  faIcon: FontAwesomeIcons.clipboard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildeDelivery(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: context.read<AppProvider>().isCheck,
                  onChanged: (bool? value) {
                    context.read<AppProvider>().setCheck();
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hỏa tốc',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Text(
                          'Đơn hàng của bạn đang được ưu tiên để tài xế giao sớm nhất.',
                          style: TextStyle(fontSize: 15))
                    ],
                  ),
                ),
              ],
            ),
            Text(viCurrency.format(context.read<AppProvider>().servicesFee),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Future<String?> _showUpdateProduct(BuildContext context, dynamic product) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Text(
            "Cập nhật giỏ hàng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.productName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(82, 182, 91, 1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      viCurrency.format(product.price),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(82, 182, 91, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2,
                    child: CartAddProduct(
                      product: product,
                      isCartScreen: true,
                    ),
                  )
                ],
              )),
          actions: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  if (context.read<AppProvider>().quantity >= 1) {
                    context
                        .read<AppProvider>()
                        .changeQuantity(product.productId);
                  } else {
                    context
                        .read<AppProvider>()
                        .deleteProduct(product.productId);
                  }

                  Navigator.of(context).pop();
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
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: context.read<AppProvider>().quantity >= 1
                                ? [
                                    primary,
                                    primary2,
                                  ]
                                : [
                                    Color.fromRGBO(237, 55, 116, 1),
                                    Color.fromRGBO(237, 55, 116, 1),
                                  ])),
                    child: context.read<AppProvider>().quantity >= 1
                        ? const Text(
                            'Cập nhật giỏ hàng',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "SF Bold",
                            ),
                          )
                        : const Text(
                            'Hủy',
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
        );
      },
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  Future<String?> _showWarning(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Text("Lưu ý đặc biệt"),
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: context.read<AppProvider>().noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                  ),
                ),
              )),
          actions: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  context.read<AppProvider>().createNote();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                            primary,
                            primary2,
                          ])),
                  child: const Text(
                    'Xác nhận',
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
        );
      },
    );
  }

  Future<String?> showAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/successful.gif",
                    width: 300, fit: BoxFit.cover),
                const Text("Đặt hàng thành công",
                    style: TextStyle(fontSize: 25)),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const Text("Mã đơn hàng của bạn là ",
                //           style: TextStyle(
                //             fontSize: 15,
                //           )),
                //       Text(context.read<AppProvider>().deliveryCode,
                //           style: const TextStyle(
                //             fontSize: 15,
                //           )),
                //     ],
                //   ),
                // ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Bạn có thể theo dõi đơn hàng của mình.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
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
        );
      },
    );
  }

  Future<String?> builderConfirmOrder(BuildContext parentContext) {
    // int _start = 10;
    return showDialog<String>(
      context: parentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          Future.delayed(const Duration(seconds: 1), () {
            // setState(() {
            //   --_start;
            // });
            // if (_start == 0) {
            //   Navigator.pop(context);
            //   context
            //       .read<AppProvider>()
            //       .submitOrder(BillOfLanding(
            //           context.read<AppProvider>().phoneController.text,
            //           totalMoney,
            //           context.read<AppProvider>().enteredBuildingId,
            //           noteInputController.text,
            //           context.read<AppProvider>().userNameController.text,
            //           "1"))
            //       .then((value) {
            //     if (!context.read<AppProvider>().isLoading) {
            //       if (context.read<AppProvider>().status == 200) {
            //         showAlertDialog(parentContext);
            //       } else {
            //         showErrorAlertDialog(parentContext);
            //       }
            //     }
            //   });
            // }
          });
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child:
                          // Text("Đơn hàng sẽ được gửi đi trong\n$_start giây...",
                          Text("Xác nhận đơn hàng",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "SF Bold")),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Giao đến: ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SF Bold"),
                        ),
                        Expanded(
                          child: Text(
                              '${context.read<AppProvider>().buildingController.text}, ${context.read<AppProvider>().areaController.text}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Người nhận: ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "SF Bold"),
                        ),
                        Expanded(
                          child: Text(
                              '${context.read<AppProvider>().userNameController.text}, ${context.read<AppProvider>().phoneController.text}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Tổng tiền đơn hàng: ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "SF Bold")),
                        Text(moneyInput ?? "",
                            style: const TextStyle(fontSize: 16))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Trở lại',
                          style:
                              TextStyle(fontSize: 15, fontFamily: "SF Bold")),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await context
                              .read<AppProvider>()
                              .submitOrder(BillOfLanding(
                                  context
                                      .read<AppProvider>()
                                      .phoneController
                                      .text,
                                  totalMoney,
                                  context.read<AppProvider>().enteredBuildingId,
                                  noteInputController.text,
                                  context
                                      .read<AppProvider>()
                                      .userNameController
                                      .text,
                                  "1",
                                  paymentType))
                              .then((value) {
                            if (!context.read<AppProvider>().isLoading) {
                              if (context.read<AppProvider>().status) {
                                showAlertDialog(parentContext);
                                context.read<AppProvider>().status = false;
                              } else {
                                showErrorAlertDialog(parentContext);
                              }
                            }
                          });
                        },
                        child: const Text('Tiếp tục',
                            style:
                                TextStyle(fontSize: 15, fontFamily: "SF Bold")),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<String?> showOptionTimesEmptyAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/error.png",
                        width: 250, fit: BoxFit.cover),
                    const Text(
                      "Oops...!",
                      style: TextStyle(
                          color: Color.fromRGBO(237, 55, 116, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Không có khung giờ phụ hợp. Vui lòng thử lại sau.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "SF Bold"),
                    ),
                  ],
                ),
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
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                      "Đã xảy ra lỗi gì đó. Vui lòng thử lại sau.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
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

  Widget buildTimePickerPicker() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 180,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 64,
        onSelectedItemChanged: (value) =>
            context.read<AppProvider>().changeOptionTime(value),
        children: context
            .read<AppProvider>()
            .optionTimeList
            .map(
              (e) => Center(
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
