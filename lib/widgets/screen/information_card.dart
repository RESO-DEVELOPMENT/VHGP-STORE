import 'package:flutter/material.dart';
import 'package:store_app/models/addressModel.dart';
import 'package:store_app/models/cartModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:provider/provider.dart';

class InformationCard extends StatefulWidget {
  const InformationCard({
    Key? key,
    required this.address,
  }) : super(key: key);

  final Address address;

  @override
  State<InformationCard> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  late Cart cartController;

  @override
  void initState() {
    cartController = context.read<AppProvider>().cart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDefault = widget.address.isDefault;
    return GestureDetector(
      onTap: () => setState(() {
        isDefault = 1;
        context
            .read<AppProvider>()
            .setIsDefault(widget.address.accountBuildId.toString());
      }),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                  value: 1,
                  groupValue: isDefault,
                  onChanged: (value) {
                    isDefault = 1;
                    context
                        .read<AppProvider>()
                        .setIsDefault(widget.address.accountBuildId.toString());
                    context.read<AppProvider>().getAddress();
                  }),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: widget.address.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                            text: ' | ',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextSpan(
                            text: widget.address.soDienThoai,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: Text(
                      '${widget.address.buildingName}, ${widget.address.areaName} Vinhomes GP',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  widget.address.isDefault == 1
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue)),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                'Mặc định',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
