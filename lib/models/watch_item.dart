import 'package:isar_community/isar.dart';

import 'enums.dart';

part 'watch_item.g.dart';

@collection
class WatchItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @enumerated
  late ItemType type;

  @Index()
  late String title;

  int? year;

  List<String> genres = [];

  @enumerated
  @Index()
  late WatchStatus status;

  double? rating;

  String? posterPath;

  String? notes;

  int? progressCurrent;

  int? progressTotal;

  @Index()
  late DateTime dateAdded;

  DateTime? dateCompleted;

  WatchItem();

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type.name,
      'title': title,
      'year': year,
      'genres': genres,
      'status': status.name,
      'rating': rating,
      'notes': notes,
      'progressCurrent': progressCurrent,
      'progressTotal': progressTotal,
      'dateAdded': dateAdded.toIso8601String(),
      'dateCompleted': dateCompleted?.toIso8601String(),
    };
  }

  factory WatchItem.fromJson(Map<String, dynamic> json) {
    final item = WatchItem()
      ..uuid = json['uuid'] as String
      ..type = ItemType.values.byName(json['type'] as String)
      ..title = json['title'] as String
      ..year = json['year'] as int?
      ..genres =
          (json['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          []
      ..status = WatchStatus.values.byName(json['status'] as String)
      ..rating = (json['rating'] as num?)?.toDouble()
      ..notes = json['notes'] as String?
      ..progressCurrent = json['progressCurrent'] as int?
      ..progressTotal = json['progressTotal'] as int?
      ..dateAdded = DateTime.parse(json['dateAdded'] as String);

    if (json['dateCompleted'] != null) {
      item.dateCompleted = DateTime.parse(json['dateCompleted'] as String);
    }

    return item;
  }
}
