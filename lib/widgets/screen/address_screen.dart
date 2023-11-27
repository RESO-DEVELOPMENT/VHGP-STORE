import 'package:flutter/material.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widgets/screen/information_card.dart';

class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late Cart cartController;

  @override
  void initState() {
    cartController = context.read<AppProvider>().cart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chọn địa chỉ nhận hàng',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => context
                            .read<AppProvider>()
                            .addressList
                            .length !=
                        index
                    ? InformationCard(
                        address: context.read<AppProvider>().addressList[index])
                    : Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                // );
                              },
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16))),
                              child: Text(
                                'Thêm mới',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                itemCount: context.read<AppProvider>().addressList.length + 1,
                separatorBuilder: (BuildContext context, int index) =>
                    const Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Divider(
                    color: Colors.black12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
