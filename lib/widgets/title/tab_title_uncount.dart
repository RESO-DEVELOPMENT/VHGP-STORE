import 'package:flutter/material.dart';
import 'package:store_app/widgets/screen/screen_utils.dart';

class TabTitleUnCount extends StatelessWidget {
  final String? title;
  final String? actionText;
  final VoidCallback? seeAll;
  final double? padding;

  const TabTitleUnCount(
      {super.key, this.title, this.seeAll, this.actionText, this.padding = 16});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
          padding!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (seeAll != null)
            TextButton(
              onPressed: seeAll,
              child: Text(
                actionText!,
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}
