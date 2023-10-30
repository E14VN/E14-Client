import 'package:animations/animations.dart';
import 'report_fire.dart';
import 'zoning/zoning.dart';
import 'package:flutter/material.dart';

ValueNotifier<int> selectedIndex = ValueNotifier<int>(1);
int preSelectedIndex = 1;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, _, __) => Scaffold(
            appBar: AppBar(title: const Text("E14"), centerTitle: true),
            body: PageTransitionSwitcher(
                reverse: selectedIndex.value > preSelectedIndex,
                transitionBuilder: (Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation) {
                  return SharedAxisTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child);
                },
                child: [
                  Container(),
                  const ReportFire(),
                  Zoning()
                ][selectedIndex.value]),
            bottomNavigationBar: NavigationBar(
                selectedIndex: selectedIndex.value,
                onDestinationSelected: (newIndex) => {
                      preSelectedIndex = selectedIndex.value,
                      selectedIndex.value = newIndex
                    },
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: "Người thân"),
                  NavigationDestination(
                      icon: Icon(Icons.local_fire_department_outlined),
                      selectedIcon: Icon(Icons.local_fire_department),
                      label: "Báo cháy"),
                  NavigationDestination(
                      icon: Icon(Icons.location_searching),
                      selectedIcon: Icon(Icons.my_location),
                      label: "Khoanh vùng")
                ])));
  }
}
