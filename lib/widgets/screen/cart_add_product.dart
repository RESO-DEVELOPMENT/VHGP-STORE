import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/provider/appProvider.dart';

class CartAddProduct extends StatefulWidget {
  const CartAddProduct(
      {Key? key, required this.product, required this.isCartScreen})
      : super(key: key);
  final dynamic product;
  final bool isCartScreen;

  @override
  State<CartAddProduct> createState() => _CartAddProductState();
}

class _CartAddProductState extends State<CartAddProduct> {
  late Cart cartController;

  @override
  void initState() {
    cartController = context.read<AppProvider>().cart;
    // cartController.quantity = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        height: 35,
        // width: 120,
        child: context.read<AppProvider>().quantity != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => context.read<AppProvider>().subtract(),
                      icon: const Icon(
                        Icons.remove,
                        size: 15,
                        color: Colors.blue,
                      )),
                  Text(context.read<AppProvider>().quantity.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      context.read<AppProvider>().add();
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 15,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 170, 76, .2),
                ),
                onPressed: () => context.read<AppProvider>().add(),
                child: const Text(
                  'Thêm',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 170, 76, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
