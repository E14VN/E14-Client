import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/credentials.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("E14"), centerTitle: true),
        body: ChangeNotifierProvider(
            create: (_) => RegisterRequest(),
            builder: (context, _) => Consumer<RegisterRequest>(
                builder: (context, registerRequest, _) =>
                    PhoneInputPage(registerRequest: registerRequest))));
  }
}

class PhoneInputPage extends StatefulWidget {
  final RegisterRequest registerRequest;
  const PhoneInputPage({super.key, required this.registerRequest});

  @override
  State<StatefulWidget> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  late TextEditingController phoneNumberController, verifyCodeController;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController()
      ..addListener(() => setState(() {}));
    verifyCodeController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
    verifyCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        const Text("Bắt đầu",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        FunnyInput(
            controller: phoneNumberController,
            center: false,
            hintText: "Số điện thoại",
            leftWigets: [
              const SizedBox(width: 12),
              ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SvgPicture.string(
                      '<svg viewBox="-15 -10 30 20"><path fill="#DA251d" d="M-20-15h40v30h-40z"/><g id="b" transform="translate(0 -6)"><path id="a" fill="#FF0" transform="rotate(18)" d="M0 0v6h4"/><use xlink:href="#a" transform="scale(-1 1)"/></g><g id="c" transform="rotate(72)"><use xlink:href="#b"/><use xlink:href="#b" transform="rotate(72)"/></g><use xlink:href="#c" transform="scale(-1 1)"/></svg>')),
              const SizedBox(width: 10),
              const Text("+84",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 30, child: VerticalDivider(thickness: 2)),
              const SizedBox(width: 10)
            ],
            enabled: !widget.registerRequest.sentRegisterRequest ||
                !widget.registerRequest.lockPhoneNumber,
            limitLength: 11,
            format: RegExp("[0-9]"),
            hintLetterSpacing: 1,
            textLetterSpacing: 1,
            fontSize: 20),
        widget.registerRequest.lockPhoneNumber
            ? FunnyInput(
                controller: verifyCodeController,
                center: true,
                hintText: "Mã xác thực",
                enabled: widget.registerRequest.lockPhoneNumber,
                limitLength: 6,
                format: RegExp("[0-9]"),
                hintLetterSpacing: 1,
                textLetterSpacing: 10,
                fontSize: 20)
            : Container()
      ]),
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: widget.registerRequest.lockPhoneNumber
                  ? FilledButton(
                      onPressed: verifyCodeController.text.length == 6
                          ? () => widget.registerRequest.sendVerifyRequest(
                              context,
                              phoneNumberController.text,
                              verifyCodeController.text)
                          : null,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hoàn thành",
                                style: TextStyle(fontWeight: FontWeight.w700))
                          ]))
                  : FilledButton(
                      onPressed: phoneNumberController.text.length >= 9 &&
                              !widget.registerRequest.sentRegisterRequest
                          ? () => widget.registerRequest
                              .sendRegisterRequest(phoneNumberController.text)
                          : null,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Tiếp tục",
                                style: TextStyle(fontWeight: FontWeight.w700))
                          ]))))
    ]);
  }
}

class FunnyInput extends StatelessWidget {
  final bool enabled, center;
  final String hintText;
  final List<Widget>? leftWigets;
  final TextEditingController controller;
  final int limitLength;
  final RegExp format;
  final double hintLetterSpacing, textLetterSpacing, fontSize;

  const FunnyInput(
      {super.key,
      required this.controller,
      required this.hintText,
      this.leftWigets,
      required this.enabled,
      required this.limitLength,
      required this.format,
      required this.hintLetterSpacing,
      required this.textLetterSpacing,
      required this.fontSize,
      required this.center});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              ...leftWigets ?? [Container()],
              Expanded(
                  child: TextField(
                      enabled: enabled,
                      autofocus: true,
                      controller: controller,
                      textAlign: center ? TextAlign.center : TextAlign.start,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(limitLength),
                        FilteringTextInputFormatter.allow(format)
                      ],
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                          letterSpacing: textLetterSpacing),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 11),
                          hintStyle:
                              TextStyle(letterSpacing: hintLetterSpacing),
                          hintText: hintText,
                          border: InputBorder.none)))
            ])));
  }
}
