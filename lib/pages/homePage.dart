import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_test/hooks/useStore.dart';
import 'package:flutter_all_test/store/index.dart';
import 'package:flutter_all_test/widgets/langSwitch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../api/http.dart';
import '../models/req/banner_entity.dart';
import '../router/routes.dart';
import '../extensions/customColors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch(ref, settingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'hello'.tr(),
          style: TextStyle(color: context.primary),
        ),
        actions: [LangSwitch()],
      ),
      body: Column(
        children: [
          Text("Home"),
          TextButton(
              onPressed: () {
                context.push(Routes.test);
              },
              child: Text('Go test')),
          TextButton(
              onPressed: () {
                context.push(Uri(
                    path: Routes.detail + "/111",
                    queryParameters: {'name': '张三', 'gender': '男'}).toString());
              },
              child: Text('Go detail')),
          Row(
            children: [
              ...[Icons.settings, Icons.light_mode, Icons.dark_mode]
                  .asMap()
                  .entries
                  .map((entry) {
                final i = entry.key;
                final icon = entry.value;
                return IconButton(
                  onPressed: () async {
                    dispatch.toggleTheme(i);
                  },
                  icon: Icon(icon),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  ({String device, String poem}) dInfo = getDevice();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final http = Http();
  List<BannerItem> banner = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    print("device ${getDevice()}");
    _getBanner();
  }

  _getBanner() async {
    /*const jsonStr = '''
  {
    "banners": [
      {
        "id": "1756981340644",
        "link": null,
        "sort": 1,
        "type": "remote",
        "title": "",
        "imgUrl": "http://transient.online/static/mediaLg/2025/09/04/dh1-1756981760277.png",
        "subTitle": "寥廓东湖..."
      },
      {
        "id": "1756981935974",
        "link": null,
        "sort": 2,
        "type": "remote",
        "title": "东湖樱园",
        "imgUrl": "http://transient.online/static/mediaLg/2025/09/04/dh2.pic-1756981955828.jpg",
        "subTitle": "走进武汉东湖磨山樱花园..."
      },
      {
        "id": "1756982034841",
        "link": null,
        "sort": 0,
        "type": "local",
        "title": "东湖",
        "imgUrl": "http://transient.online/static/mediaLg/2025/09/04/dh3.pic-1756982046725.jpg",
        "subTitle": "东湖，又称裹脚湖..."
      }
    ],
    "version": "1.1.0"
  }
  ''';
    final entity=bannerEntityFromJson(jsonStr);*/
    final res1 = await http.get<Map<String, dynamic>>("/home/banner",
        queryParameters: {"page": 1});
    // final list=bannerEntityFromJson(res1.data?["data"]);
    final rr = BannerEntity.fromJson(res1.data?["data"]);
    setState(() {
      banner = rr.banners ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.title} ${widget.dInfo.device}"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          /*banner.isEmpty
              ? const Center(child: CircularProgressIndicator()) // 加载中
              : SizedBox(
            height: 200, // 固定高度
            child: PageView.builder(
              itemCount: banner.length,
              controller: PageController(viewportFraction: 0.95),
              itemBuilder: (context, index) {
                final item = banner[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 图片
                        if (item.imgUrl != null)
                          Image.network(
                            item.imgUrl!,
                            fit: BoxFit.cover,
                          ),
                        // 底部文字遮罩
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subTitle ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )*/
        ],
      ),
      floatingActionButton: TextButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}

({String device, String poem}) getDevice() {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return (device: "Android", poem: "事必专任，乃可责成。力无他分，乃能就绪。");
    case TargetPlatform.iOS:
      return (device: "iOS", poem: "惧则思，思则通微，惧则慎，慎则不败。");
    case TargetPlatform.macOS:
      return (device: "macOS", poem: "");
    case TargetPlatform.windows:
      return (device: "Windows", poem: "");
    case TargetPlatform.linux:
      return (device: "Linux", poem: "");
    case TargetPlatform.fuchsia:
      return (device: "Fuchsia", poem: "");
    case TargetPlatform.ohos:
      return (device: "Harmony", poem: "察而后谋，谋而后动，深思远虑，计无不中。");
    default:
      return (device: "未知平台", poem: "");
  }
}
