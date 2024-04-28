import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const kMainColor = Color(0xFF1D252C);
const kSecondaryColor = Color(0xFF3E444A);
const kErrorColor = Color(0xFFC55C5C);
const kEncryptButtonForeground = Color(0xFFEBEBEB);
const kEncryptButtonBackground = Color(0xFF858585);
const kDecryptButtonForeground = Color(0xFF1D252C);
const kDecryptButtonBackground = Color(0xFFCCCCCC);

const kPublicKeyTitle = '你的公钥';
const kPublicKeyInputPageTitle = '接收人的公钥';
const kMessageInputPageTitle = '信息';
const kErrorPageTitle = '错误';
const kPublicKeyAlertTitle = '公钥已经复制!';
const kEncryptButtonTitle = '加密';
const kDecryptButtonTitle = '解密';
const kEncryptErrorTitle = '无效的公钥';
const kEncryptErrorDescription =
    "请输入接收人当前的公钥.";
const kDecryptErrorTitle = "这不是你的消息";
const kDecryptErrorDescription =
    '请提供您当前的发件人公钥。';
const kEncryptResultPageTitle = '加密结果';
const kEncryptResultAlertTitle = '加密结果已复制！';
const kDecryptResultPageTitle = '解密结果';
const kDecryptResultAlertTitle = '解密结果已复制！';
const kSadSmiley = ':(';
const kMaxTextFieldLength = 245;

final kBigTextStyle = TextStyle(
  fontSize: 28.sp,
  fontWeight: FontWeight.bold,
);

final kPublicKeyDataTextStyle = TextStyle(
  fontSize: 18.sp,
  color: kEncryptButtonBackground,
);

final kSimpleTextStyle = TextStyle(
  fontSize: 18.sp,
);

final kSnackBarTextStyle = TextStyle(
  fontSize: 11.0.sp,
  color: kEncryptButtonForeground,
);
