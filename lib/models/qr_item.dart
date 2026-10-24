
class QRItem {
  final String id;
  final String data;
  final String title;
  final DateTime createdAt;
  final bool isSaved;

  const QRItem({
    required this.id,
    required this.data,
    required this.title,
    required this.createdAt,
    this.isSaved = false,
  });

  QRItem copyWith({
    String? id,
    String? data,
    String? title,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return QRItem(
      id: id ?? this.id,
      data: data ?? this.data,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }

  factory QRItem.fromJson(Map<String, dynamic> json) {
    return QRItem(
      id: json['id'] as String,
      data: json['data'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }
}
/* 
class QRItem {
  final String id;
  final String data;
  final String title;
  final DateTime createdAt;
  final bool isSaved;

  const QRItem({
    required this.id,
    required this.data,
    required this.title,
    required this.createdAt,
    this.isSaved = false,
  });

  QRItem copyWith({
    String? id,
    String? data,
    String? title,
    DateTime? createdAt,
    bool? isSaved,
  }) {
    return QRItem(
      id: id ?? this.id,
      data: data ?? this.data,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }

  factory QRItem.fromJson(Map<String, dynamic> json) {
    return QRItem(
      id: json['id'] as String,
      data: json['data'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }
}
 */