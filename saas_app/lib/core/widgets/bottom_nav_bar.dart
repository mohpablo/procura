import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        items: items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(item.icon),
                ),
                label: item.label,
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(item.activeIcon ?? item.icon),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  BottomNavItem({required this.icon, this.activeIcon, required this.label});
}

// Buyer Navigation Items
List<BottomNavItem> buyerNavItems = [
  BottomNavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  ),
  BottomNavItem(
    icon: Icons.shopping_bag_outlined,
    activeIcon: Icons.shopping_bag,
    label: 'Products',
  ),
  BottomNavItem(
    icon: Icons.shopping_cart_outlined,
    activeIcon: Icons.shopping_cart,
    label: 'Cart',
  ),
  BottomNavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    label: 'Orders',
  ),
  BottomNavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
  ),
];

// Supplier Navigation Items
List<BottomNavItem> supplierNavItems = [
  BottomNavItem(
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard,
    label: 'Dashboard',
  ),
  BottomNavItem(
    icon: Icons.inventory_2_outlined,
    activeIcon: Icons.inventory_2,
    label: 'Products',
  ),
  BottomNavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    label: 'Orders',
  ),
  BottomNavItem(
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
    label: 'Notifications',
  ),
  BottomNavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
  ),
];
