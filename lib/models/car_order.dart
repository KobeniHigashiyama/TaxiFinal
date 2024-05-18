import 'dart:convert';

import 'package:cars/models/place.dart';
import 'package:cars/widgets/car_status.dart';

class CarOrder {
  DateTime? startDate;
  DateTime? endDate;
  int? lengthSec;
  Place? from;
  List<Place>? route;
  CarOrderStatus status;
  String? comment;
  String? driverName;
  String? passName;
  String? id;
  String? passId;
  String? oneId;
  String? driverId;
  bool? isCarFree;
  int? arriveTime;
  int? backTime;

  CarOrder({
    this.startDate,
    this.endDate,
    this.lengthSec,
    this.driverName,
    this.passName,
    this.route,
    this.from,
    this.comment,
    required this.status,
    this.id,
    this.oneId,
    this.passId,
    this.driverId,
    this.isCarFree,
    this.arriveTime,
    this.backTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'lengthSec': lengthSec,
      'driverName': driverName,
      'from': from?.toJson(),
      'route': jsonEncode(route?.map((place) => place.toJson()).toList()),
      'comment': comment,
      'status': status.name,
      'passName': passName,
      'id': id,
      'passId': passId,
      'driverId': driverId,
      'arriveTime': arriveTime,
      'backTime': backTime,
      'oneId': oneId,
    };
  }

  factory CarOrder.fromJson(Map<String, dynamic> json) {
    return CarOrder(
      status: CarOrderStatus.values.firstWhere((s) => s.name == json['status'],
          orElse: () =>
              CarOrderStatus.empty // Элегантная обработка неожиданных статусов
          ),
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] ?? 0),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate'] ?? 0),
      lengthSec: json['lengthSec'],
      driverName: json['driverName'],
      passName: json['passName'],
      route: jsonDecode(json['route'] ?? '[]')
          .map<Place>((data) => Place.fromJson(data))
          .toList(),
      from: json['from'] != null
          ? Place.fromJson(jsonDecode(json['from']))
          : null,
      comment: json['comment'],
      id: json['id'],
      passId: json['passId'],
      driverId: json['driverId'],
      arriveTime: json['arriveTime'],
      backTime: json['backTime'],
    );
  }
}

enum CarOrderStatus {
  empty,
  active,
  waiting,
  planned,
}
