import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_test/utils/shareStorage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../store/index.dart';

class LangSwitch extends ConsumerStatefulWidget {
  bool iconRender;

  LangSwitch({super.key, this.iconRender = false});

  @override
  ConsumerState<LangSwitch> createState() => _LangSwitch();
}

class LanCls {
  String k;
  String v;

  LanCls(this.k, this.v);
}

class _LangSwitch extends ConsumerState<LangSwitch> {

  final List<LanCls> languages = [
    LanCls("en", "English"),
    LanCls("zh", "中文"),
  ];
  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  Future<void> _loadLang() async {
    final savedLang = ShareStorage.get('locale');
    if (savedLang != null) {
      ref.read(localeProvider.notifier).state = Locale(savedLang);
    }
  }
  /*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLang();
    });
  }*/
  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    return widget.iconRender
        ? GestureDetector(
            onTapDown: (details) async {
              final selected = await showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                color: const Color(0xFF001F3F),
                items: languages.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.k,
                    child: Text(
                      entry.v,
                      style: TextStyle(
                        color: entry.k == currentLocale.languageCode
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                  );
                }).toList(),
              );
              _switchLang(selected);
            },
            child: Image.asset('assets/images/lang.png', width: 24, height: 24),
          )
        : DropdownButton<String>(
            dropdownColor: Color(0xFF001F3F),
            value: currentLocale.languageCode,
            items: languages.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.k,
                child: Text(entry.v, style: TextStyle(color: Colors.red)),
              );
            }).toList(),
            onChanged: _switchLang,
          );
  }

  _switchLang(String? val) {
    if (val != null) {
      final newLocale = Locale(val);
      ref.read(localeProvider.notifier).state = newLocale;
      context.setLocale(newLocale);
      ShareStorage.set('locale', val);
    }
  }
}
