import 'package:flutter/material.dart';

class UserNotification {
  final String id;
  final DateTime timeOfDay;
  bool hasNotification;

  UserNotification(this.id, this.timeOfDay, this.hasNotification);

  void updateNotificationStatus(bool status){
    this.hasNotification = status;
  }

  bool equals(UserNotification otherNotification){
    return (this.id == otherNotification.id && this.timeOfDay == otherNotification.timeOfDay);
  }
}