import 'package:flutter/material.dart';
import 'package:network_proxy/utilities/constants.dart';
import 'package:network_proxy/ui/mobile/encro/result_page.dart';
import 'package:network_proxy/ui/mobile/encro/error_page.dart';
import 'package:network_proxy/utilities/rsa_brain.dart';
import 'package:network_proxy/widgets/appbar_icon_button.dart';
import 'package:network_proxy/widgets/editor_screen_template.dart';
import 'package:sizer/sizer.dart';

late RSABrain _myRsaBrain;

class MessageInputPage extends StatefulWidget {
  MessageInputPage({required rsaBrain}) {
    _myRsaBrain = rsaBrain;
  }

  @override
  _MessageInputPageState createState() => _MessageInputPageState();
}

class _MessageInputPageState extends State<MessageInputPage> {
  TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        toolbarHeight: 10.h,
        leading: AppBarIconButton(
          padding: EdgeInsets.only(left: 7.w),
          icon: Icons.arrow_back_ios,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          kMessageInputPageTitle,
          style: kSimpleTextStyle,
        ),
        actions: [
          AppBarIconButton(
            padding: EdgeInsets.only(right: 7.w),
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              String? secretMessage = _myRsaBrain.encryptTheSetterMessage(
                  (messageController.text.trim().length > kMaxTextFieldLength)
                      ? messageController.text
                          .trim()
                          .substring(0, kMaxTextFieldLength)
                      : messageController.text.trim());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (secretMessage != null)
                      ? ResultPage(
                          message: secretMessage,
                          title: kEncryptResultPageTitle,
                          alert: kEncryptResultAlertTitle,
                        )
                      : ErrorPage(
                          title: kEncryptErrorTitle,
                          description: kEncryptErrorDescription,
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: EditorScreenTemplate(
        controller: messageController,
        maxLength: kMaxTextFieldLength,
      ),
    );
  }
}
