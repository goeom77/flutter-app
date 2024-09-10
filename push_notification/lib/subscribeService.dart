import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SubscribeService {
  String? currentUserId = 'anonymousdeviceId';
  Stream<SSEModel>? currentSSEStream;
  final notification = FlutterLocalNotificationsPlugin();

  Future<void> subscribeToSse() async {
    print('_subscribeToSse--SUBSCRIBING TO SSE---');

    SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: 'https://chaduck-back-dev.duckdns.org/api/v1/push-alarm/subscribe?userId=$currentUserId',
      header: {
        "Content-Type": "text/event-stream",
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
      },
    ).listen(
            (SSEModel event) {
          final jsonData = jsonDecode(event.data!);
          switch (event.event) {
            case "init":
              break;
            case "alarm":
            case "notification":
            default:
            handlePushNotification(
              jsonData['title'],
              jsonData['content'],
              jsonData['pushAlarmType'],
            );
            break;
          }
        });
  }

  Future<void> unsubscribeFromSse(String userIdToUnsubscribe) async {
    // front stream 제거
    if (currentSSEStream != null) {
      await currentSSEStream!.drain();
      currentSSEStream = null;
    }
    // back 알람 대상 stream 제거
    var url = Uri.parse('https://chaduck-back-dev.duckdns.org/api/v1/push-alarm/unsubscribe?userId=$userIdToUnsubscribe');
    await http.post(url, headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  Future<void> updateUserId(String newUserId) async {
    if (newUserId == currentUserId) {
      // userId가 동일한 경우 취소
      return;
    }
    // 기존 SSE 연결 해제
    SSEClient.unsubscribeFromSSE();
    print("기존 userId($currentUserId)로부터 SSE 연결을 해제했습니다.");
    // 새로운 userId로 업데이트
    currentUserId = newUserId;
    // 새로운 userId로 SSE 재연결
    await subscribeToSse();
    print("새로운 userId($newUserId)로 SSE 연결을 설정했습니다.");
  }

  Future<void> showNotification(String title,String message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await notification.show(
      0, // 알림 ID (고유해야 함)
      title, // 알림 제목
      message, // 알림 내용
      notificationDetails,
      payload: 'item x',
    );
  }

  Future<void> showNotificationWithButton(String title, String message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // Add the actions to the notification
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'action_id',
          'Open App',
          // This is the action when button is pressed
          titleColor: Colors.blue,
          // If you want to use a custom icon, set it here
          // icon: 'your_icon',
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await notification.show(
      0, // 알림 ID
      '알림 제목',
      '알림 내용',
      notificationDetails,
      payload: 'your_payload', // Click action payload
    );
  }

  Future<void> showImgNotification(String title, String message) async {
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

    //networkImg 사용
    String url = message;
    final http.Response response = await http.get(Uri.parse(url));
    final Directory directory = await getTemporaryDirectory();
    final String name = "${directory.path}/${url.split('/').last}.png";
    final File file = File(name);
    await file.writeAsBytes(response.bodyBytes);
    String filePath = file.path;

    NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        attachments: [
          DarwinNotificationAttachment(filePath)
        ],
      ),
      android: AndroidNotificationDetails(
        'send.type.channelId',
        'send.type.channelName',
        channelDescription: 'send.type.channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
        ),
      ),
    );
    await notification.show(
        13, title, message, notificationDetails,
        payload: 'item x');
  }

  void handlePushNotification(String title, String content, String pushAlarmType) {
    if (pushAlarmType == "텍스트") {
      showNotification(title, content);
    } else if (pushAlarmType == "이미지") {
      showImgNotification(title, content);
    } else if (pushAlarmType == "버튼") {
      showNotificationWithButton(title, content);
    }
  }

}