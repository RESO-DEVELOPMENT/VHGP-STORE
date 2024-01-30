import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/routes.dart';

class DeliveryWidget extends StatelessWidget {
  DeliveryWidget({
    Key? key,
    required this.cartController,
    required this.isHome,
  }) : super(key: key);

  late Cart cartController;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    cartController = context.read<AppProvider>().cart;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // const Text('Giao đến'),
        GestureDetector(
            child: Container(
              height: isHome ? 40 : 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: isHome
                    ? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16)
                    : const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 250, 159, 56),
                            Color(0xfff7892b)
                          ],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      context.read<AppProvider>().building,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => {
                  context.read<AppProvider>().getAreaList(),
                  context.read<AppProvider>().getAddress(),
                  Navigator.pushReplacementNamed(context, '/create-order'),
                })
      ],
    );
  }
}
