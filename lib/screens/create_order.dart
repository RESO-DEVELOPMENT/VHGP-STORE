import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/widgets/address/area_response.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  List<CategoryModel> listCategory = [];

  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool valid = false;
  bool validImage = true;
  bool isLoading = false;
  late Cart cartController;
  List<Area> areaList = [];
  String area = "";
  String cluster = "";
  String building = "";
  String enteredAddress = "";

  void initState() {
    cartController = context.read<AppProvider>().cart;
    context.read<AppProvider>().isSubmit = false;
    context.read<AppProvider>().getAreaList();
    context.read<AppProvider>().getAddress();
    super.initState();
    context.read<AppProvider>().getAreaList().then((area) {
      setState(() {
        areaList = area;
      });
    });
  }

  void hanldeSubmit(String storeId) {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    if (_image != null) {
      var bytes = File(_image!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      // img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        validImage = true;

        // Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thông tin vận chuyển',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Form(
            key: CreateOrderScreen._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) => buildAreaPicker(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Khu vực',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              " *",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(area),
                              Text(context
                                  .read<AppProvider>()
                                  .areaController
                                  .text),
                              const Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    if (context
                        .read<AppProvider>()
                        .clusterOfBuildingController
                        .text
                        .isEmpty)
                      {
                        context.read<AppProvider>().changeCluster(0),
                        setState(() {
                          cluster = context
                              .read<AppProvider>()
                              .clusterOfBuildingController
                              .text;
                        })
                      },
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => buildClusterPicker(),
                    ),
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Cụm tòa nhà',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              " *",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(context
                                  .read<AppProvider>()
                                  .clusterOfBuildingController
                                  .text),
                              const Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      context.read<AppProvider>().isSubmit &&
                              context
                                  .read<AppProvider>()
                                  .areaController
                                  .text
                                  .isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: const Text(
                                "Vui lòng chọn cụm tòa nhà",
                                style: TextStyle(
                                    color: Color.fromRGBO(217, 48, 37, 1)),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    if (context
                        .read<AppProvider>()
                        .buildingController
                        .text
                        .isEmpty)
                      {
                        context.read<AppProvider>().changeBuilding(0),
                        setState(() {
                          building = context
                              .read<AppProvider>()
                              .buildingController
                              .text;
                        })
                      },
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => buildBuildingPicker(),
                    ),
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Building(Tòa nhà)',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              " *",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(context
                                  .read<AppProvider>()
                                  .buildingController
                                  .text),
                              const Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      context.read<AppProvider>().isSubmit &&
                              context
                                  .read<AppProvider>()
                                  .buildingController
                                  .text
                                  .isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: const Text(
                                "Vui lòng chọn tòa nhà",
                                style: TextStyle(
                                    color: Color.fromRGBO(217, 48, 37, 1)),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Tên người nhận',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " *",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller:
                          context.read<AppProvider>().userNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 8),
                      ),
                    ),
                    context.read<AppProvider>().isSubmit &&
                            context
                                .read<AppProvider>()
                                .userNameController
                                .text
                                .isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: const Text(
                              "Vui lòng nhập tên người nhận",
                              style: TextStyle(
                                  color: Color.fromRGBO(217, 48, 37, 1)),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Số điện thoại nhận hàng',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " *",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: context.read<AppProvider>().phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 8),
                      ),
                    ),
                    context.read<AppProvider>().isSubmit &&
                            context
                                .read<AppProvider>()
                                .phoneController
                                .text
                                .isEmpty
                        ? const Text(
                            "Vui lòng nhập số điện thoại",
                            style: TextStyle(
                                color: Color.fromRGBO(217, 48, 37, 1)),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                context.read<AppProvider>().createAddress().then((value) {
                  if (value != -1) {
                    // print('aaaaaaaaaaaaaaaaaaa');
                    // print(context.read<AppProvider>().enteredBuildingId);
                    // print(context.read<AppProvider>().userNameController.text);
                    // print(context.read<AppProvider>().phoneController.text);
                    context.read<AppProvider>().cartScreenBill = true;
                    Navigator.pushReplacementNamed(context, '/cart');
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                          Color.fromARGB(243, 255, 85, 76),
                          Color.fromARGB(255, 249, 136, 36)
                        ])),
                child: const Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: "SF Bold",
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildAreaPicker() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 180,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 64,
        onSelectedItemChanged: (value) => {
          context
              .read<AppProvider>()
              .changeArea(context.read<AppProvider>().area[value].id),
          setState(() {
            area = context.read<AppProvider>().areaController.text;
          }),
        },
        children: context
            .read<AppProvider>()
            .area
            .map(
              (e) => Center(
                child: Text(e.name),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildClusterPicker() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 180,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 64,
        onSelectedItemChanged: (value) => {
          context.read<AppProvider>().changeCluster(
              context.read<AppProvider>().areaById.listCluster[value].id),
          setState(() {
            cluster =
                context.read<AppProvider>().clusterOfBuildingController.text;
          })
        },
        //context.read<AppProvider>().changeCluster(value),
        children: context
            .read<AppProvider>()
            .areaById
            .listCluster
            .map(
              (e) => Center(
                child: Text(e.name),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildBuildingPicker() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 180,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        itemExtent: 64,
        onSelectedItemChanged: (value) => {
          context.read<AppProvider>().changeBuilding(context
              .read<AppProvider>()
              .areaById
              .listCluster[context.read<AppProvider>().indexCluster]
              .listBuilding[value]
              .id),
          setState(() {
            building = context.read<AppProvider>().buildingController.text;
          })
        },
        children: context
            .read<AppProvider>()
            .areaById
            .listCluster[context.read<AppProvider>().indexCluster]
            .listBuilding
            .map(
              (e) => Center(
                child: Text(e.name),
              ),
            )
            .toList(),
      ),
    );
  }
}
