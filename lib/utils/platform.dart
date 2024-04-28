import 'dart:io';

class Platforms {
  /// - 判断是否是桌面端
  static bool isDesktop() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// - 判断是否是移动端
  static bool isMobile() {
    return Platform.isAndroid || Platform.isIOS;
  }


  /// - 判断是否是安卓
  static bool isAndroid() {
    return Platform.isAndroid;
  }


  /// - 判断是否是IOS
  static bool isIOS() {
    return Platform.isIOS;
  }

  /// - 判断是否是 Windows
  static bool isWindows() {
    return Platform.isWindows;
  }

  /// - 判断是否是 MacOS
  static bool isMacOS() {
    return Platform.isMacOS;
  }

  /// - 判断是否是 Linux
  static bool isLinux() {
    return Platform.isLinux;
  }


}
