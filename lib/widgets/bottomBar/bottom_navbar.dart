import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';

enum TabItem { home, product, menu, transaction, account }

const Map<TabItem, String> tabName = {
  TabItem.home: 'Đơn hàng',
  TabItem.product: 'Sản phẩm',
  TabItem.menu: 'Thực đơn',
  TabItem.transaction: 'Lịch sử',
  TabItem.account: 'Tài khoản',
};

const Map<TabItem, IconData> tabIcon = {
  TabItem.home: Icons.shopping_bag_outlined,
  TabItem.product: Icons.fastfood,
  TabItem.menu: Icons.list_alt_sharp,
  TabItem.transaction: Icons.history,
  TabItem.account: Icons.account_circle,
};

class BottomNavbar extends StatefulWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  BottomNavbar({required this.currentTab, required this.onSelectTab});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: const [
              Color.fromARGB(243, 255, 85, 76),
              Color.fromARGB(255, 249, 136, 36),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        child: Icon(
          tabIcon[tabItem],
          color: Colors.white, // Màu của biểu tượng
        ),
      ),
      label: tabName[tabItem] ?? "", // Sử dụng tên từ tabName
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType
          .fixed, // Để các nút cố định và không di chuyển
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: const Color.fromARGB(255, 249, 136, 36),
      unselectedItemColor: Colors.grey,
      items: [
        _buildItem(TabItem.home),
        _buildItem(TabItem.product),
        _buildItem(TabItem.menu),
        _buildItem(TabItem.transaction),
        _buildItem(TabItem.account),
      ],
      currentIndex: widget.currentTab.index,
      onTap: (index) => widget.onSelectTab(TabItem.values[index]),
    );
  }
}
