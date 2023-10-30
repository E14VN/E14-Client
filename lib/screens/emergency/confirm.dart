import 'package:e14_client/screens/emergency/emergency.dart';
import 'package:flutter/material.dart';

class EmergencyConfirm extends StatefulWidget {
  const EmergencyConfirm({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyConfirmState();
}

class _EmergencyConfirmState extends State<EmergencyConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Theme.of(context).colorScheme.error,
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 6),
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onError))),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emergency_rounded,
                                size: 52,
                                color: Theme.of(context).colorScheme.onError),
                            const SizedBox(height: 20),
                            Text("Xác nhận báo cháy",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    fontSize: 32)),
                            Text("Trượt thanh bên dưới để xác nhận báo cháy.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.onError)),
                            const SizedBox(height: 50),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .errorContainer,
                                        borderRadius:
                                            BorderRadius.circular(6969)),
                                    child: Dismissible(
                                        onDismissed: (_) => Navigator.of(
                                                context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const EmergencyDashboard())),
                                        behavior: HitTestBehavior.deferToChild,
                                        direction: DismissDirection.startToEnd,
                                        key: UniqueKey(),
                                        child: Row(children: [
                                          Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6969),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onErrorContainer),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .all(5),
                                                      child: Icon(
                                                          Icons
                                                              .chevron_right_rounded,
                                                          size: 40,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onError))))
                                        ]))))
                          ]))),
            ])));
  }
}
