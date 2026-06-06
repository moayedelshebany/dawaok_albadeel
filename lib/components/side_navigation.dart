import 'package:flutter/material.dart';

class SideNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isExpanded = true),
      onExit: (_) => setState(() => _isExpanded = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: _isExpanded ? 220 : 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A), // لون أزرق غامق ملكي
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // أيقونة شعار أو تعبيرية
            Icon(
              _isExpanded ? Icons.medical_services : Icons.local_hospital,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: NavigationRail(
                extended: _isExpanded,
                backgroundColor: Colors.transparent,
                selectedIconTheme: const IconThemeData(color: Colors.white),
                unselectedIconTheme: const IconThemeData(color: Colors.white54),
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  color: Colors.white54,
                ),
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: widget.onDestinationSelected,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_rounded),
                    label: Text("الرئيسية"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search_rounded),
                    label: Text("البحث الذكي"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_rounded),
                    label: Text("المفضلة"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.info_rounded),
                    label: Text("عن التطبيق"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
