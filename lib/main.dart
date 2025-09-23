import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_test/router/index.dart';
import 'package:flutter_all_test/styles/theme.dart';
import 'package:flutter_all_test/utils/shareStorage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lifecycle/lifecycleEventHandler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ShareStorage.init(); // 初始化存储
  // 尝试读取用户上次选择的语言
  // final savedLocale=ShareStorage.get<String>('locale');

  runApp(ProviderScope(
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('zh')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      // startLocale: savedLocale != null ? Locale(savedLocale) : null,
      saveLocale: true,
      child: MyApp(),
    ),
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () {
          final locale = context.locale.toString();
          print(locale);

          // Get lang code only if not using country code.
          final platformLocale = Platform.localeName.split("_")[0];
          if(platformLocale != locale) {
            // Select device lang or English if not supported.
            final supportedLocale = getSuppLangOrEn(platformLocale);
            context.setLocale(Locale(supportedLocale));
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(...); // 别忘了移除 observer
    super.dispose();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print("lang ${Localizations.localeOf(context)}");
    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router,
      title: 'Transient',
    );
  }
}
/// 返回支持的语言，如果不支持就返回 'en'
String getSuppLangOrEn(String langCode) {
  const supported = ['en', 'zh']; // 你自己定义支持的语言列表
  return supported.contains(langCode) ? langCode : 'en';
}
