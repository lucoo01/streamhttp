/**
 * Author: Ambika Dulal
 * profile: https://github.com/ambikadulal
 */

import 'package:flutter/material.dart';

Color orangeColors = const Color(0xff311183);
Color orangeLightColors = const Color(0xff311183);

class SignupThreePage extends StatefulWidget {
  static const String path = "lib/src/pages/login/signup3.dart";

  const SignupThreePage({super.key});

  @override
  _SignupThreePageState createState() => _SignupThreePageState();
}

class _SignupThreePageState extends State<SignupThreePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColors, // 设置透明背景
        elevation: 0, // 移除 AppBar 阴影
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            const HeaderContainer("Stream HTTP抓包工具"),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _textInput(hint: "用户名", icon: Icons.person),
                    // _textInput(hint: "Email", icon: Icons.email),
                    _textInput(hint: "手机号", icon: Icons.call),
                    _textInput(hint: "密码", icon: Icons.vpn_key),
                    Expanded(
                      child: Center(
                        child: ButtonWidget(
                          btnText: "注册",
                          onClick: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                            text: "已经有Stream HTTP抓包工具账号 ? ",
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: "登录",
                            style: TextStyle(color: Colors.white70)),
                      ]),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

class HeaderContainer extends StatelessWidget {
  final String text;

  const HeaderContainer(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius:
          const BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Image.asset(
              "assets/icon.png",
              height: 100,
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final Function onClick;

  const ButtonWidget({super.key, required this.btnText, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.centerLeft,
              begin: Alignment.centerRight),
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          btnText,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
