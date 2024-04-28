import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// - 关于
class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    bool isCN = Localizations.localeOf(context) == const Locale.fromSubtags(languageCode: 'zh');

    return Scaffold(
        appBar: AppBar(title: Text(localizations.about, style: const TextStyle(fontSize: 16)), centerTitle: true),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Stream HTTP抓包工具", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(isCN ? "全平台抓包软件" : "Full platform capture HTTP(S) traffic software")),
            const SizedBox(height: 10),
            const Text("V1.1.0"),
            // 
            ListTile(
                title: Text(localizations.feedback),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  launchUrl(Uri.parse("https://github.com/lucoo01/streamhttp/issues"),
                      mode: LaunchMode.externalApplication);
                }),
            ListTile(
                title: Text(isCN ? "下载地址" : "Download"),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  launchUrl(Uri.parse("https://github.com/lucoo01/streamhttp/releases"),
                      mode: LaunchMode.externalApplication);
                }),
            ListTile(
                title: Text(isCN ? "用户协议" : "User Agreement"),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  launchUrl(Uri.parse("https://www.gitschool.cn/streamhttpagreement"),
                      mode: LaunchMode.externalApplication);
                }),
            ListTile(
                title: Text(isCN ? "隐私协议" : "Privacy Agreement"),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  launchUrl(Uri.parse("https://www.gitschool.cn/streamhttppolicy"),
                      mode: LaunchMode.externalApplication);
                })
          ],
        ));
  }
}
