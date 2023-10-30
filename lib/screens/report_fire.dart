import 'package:e14_client/screens/emergency/confirm.dart';
import 'package:flutter/material.dart';

class ReportFire extends StatelessWidget {
  const ReportFire({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EmergencyConfirm()));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.error),
                  child: SizedBox(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Icon(Icons.emergency_share_outlined,
                            size: 45,
                            color: Theme.of(context).colorScheme.onError),
                        const SizedBox(height: 10),
                        Text("Báo cháy",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 30))
                      ])))),
          const SizedBox(height: 50),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                          leading: Icon(Icons.warning_rounded,
                              color: Theme.of(context).colorScheme.error),
                          title: const Text("Điều 42 Nghị định 144/2021/NĐ-CP"),
                          subtitle: const Text.rich(
                              TextSpan(text: "Hành vi ", children: [
                            TextSpan(
                                text: "báo cháy giả ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: "thể bị xử phạt hành chính từ "),
                            TextSpan(
                                text: "4 triệu đồng đến 6 triệu đồng.",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]))))))
        ]));
  }
}
