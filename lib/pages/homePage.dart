import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
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
                        path: Routes.detail+"/111",
                        queryParameters: {'name': '张三', 'gender': '男'})
                    .toString());
              },
              child: Text('Go detail'))
        ],
      ),
    );
  }
}
