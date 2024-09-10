import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:push_notification/subscribeService.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SubscribeService subscribeService = SubscribeService();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Plus Example'),
        elevation: 4,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(flex: 2),
          Text(
            'Active connection types:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          ListView(
            shrinkWrap: true,
            children: List.generate(
                _connectionStatus.length,
                    (index) => Center(
                  child: Text(
                    _connectionStatus[index].toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Future<void> showNotification() async {
    //showId : 고유한 ID 값 사용
    //channelName : 앱 설정 > 알림에 보여지는 네임
    //channelDescription : 해당 채널에 대한 설명
    //importance, priority : 중요도를 설정하는 부분으로 아래와 같이 중요도를 높혀서 전송을 해야지만 Foreground에서 노출이 가능함.
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await notification.show(
        1, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  Future<void> timeScheduleNotification()async{
    tz.TZDateTime schedule = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 5));//현시간에서 5분뒤 알람
    tz.TZDateTime schedule2 = tz.TZDateTime.now(tz.local); //매일 동일한 시간에 알람

    // await notification.zonedSchedule(
    //   1,
    //   'title',
    //   'body',
    //   schedule,
    //   // details,
    //   uiLocalNotificationDateInterpretation:
    //   UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: null,
    // );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

}