import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  int _getIndex(String location) {
    if (location == Routes.home) return 0;
    if (location == Routes.map) return 1;
    if (location == Routes.users) return 2;
    if (location == Routes.finance) return 3;
    if (location == Routes.settings) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.map);
        break;
      case 2:
        context.go(Routes.users);
        break;
      case 3:
        context.go(Routes.finance);
        break;
      case 4:
        context.go(Routes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _getIndex(location),
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
