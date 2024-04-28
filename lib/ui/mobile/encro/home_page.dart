import 'package:flutter/material.dart';
import 'package:network_proxy/ui/mobile/encro/decrypt_input_page.dart';
import 'package:network_proxy/ui/mobile/encro/public_key_input_page.dart';
import 'package:network_proxy/utilities/rsa_brain.dart';
import 'package:sizer/sizer.dart';
import 'package:network_proxy/utilities/constants.dart';
import 'package:network_proxy/widgets/copy_icon_button.dart';
import 'package:network_proxy/widgets/navigation_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RSABrain _myRsaBrain = RSABrain();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('加密/解密工具',
          style: TextStyle(fontSize: 16)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 在此处添加返回按钮的操作
              Navigator.of(context).pop();
            },
          ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            right: 7.0.w,
            left: 7.0.w,
            top: 4.0.h,
            bottom: 5.0.h,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 3.0.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        kPublicKeyTitle,
                        style: kBigTextStyle,
                      ),
                    ),
                    CopyIconButton(
                      clipboardDataText:
                          _myRsaBrain.getOwnPublicKey().toString(),
                      alertText: kPublicKeyAlertTitle,
                      iconSize: 23.5.sp,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: Text(
                      _myRsaBrain.getOwnPublicKey().toString(),
                      textAlign: TextAlign.justify,
                      style: kPublicKeyDataTextStyle,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: Column(
                  children: [
                    NavigationButton(
                      foreground: kEncryptButtonForeground,
                      background: kEncryptButtonBackground,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PublicKeyInputPage(
                              rsaBrain: _myRsaBrain,
                            ),
                          ),
                        );
                      },
                      text: kEncryptButtonTitle,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    NavigationButton(
                      foreground: kDecryptButtonForeground,
                      background: kDecryptButtonBackground,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DecryptInputPage(
                              rsaBrain: _myRsaBrain,
                            ),
                          ),
                        );
                      },
                      text: kDecryptButtonTitle,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
