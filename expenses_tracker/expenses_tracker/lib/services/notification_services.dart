import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expenses_tracker/utils/const.dart';
import 'package:expenses_tracker/screens/transaction_screen.dart';


class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basicnotifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupkey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    // await AwesomeNotifications().isNotificationAllowed().then(
    //   (isAllowed) async {
    //     if (!isAllowed) {
    //       await AwesomeNotifications().requestPermissionToSendNotifications();
    //     }
    //   },
    // );

    // AwesomeNotifications().createdStream.listen((notification) {
    //       debugPrint('onNotificationCreatedMethod');

    // });
    
  }

 
  }
