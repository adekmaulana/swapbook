class BaseResponse {
  Meta? meta;
  dynamic data;

  BaseResponse({this.meta, this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta,
      'data': data,
    };
  }
}

class Meta {
  int? code;
  String? status;
  List<String>? messages;
  List<Validations>? validations;
  DateTime? responseDate;

  Meta({
    this.code,
    this.status,
    this.messages,
    this.validations,
    this.responseDate,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      code: json['code'],
      status: json['status'],
      messages: json['messages'] != null && json['messages'].isNotEmpty
          ? json['messages'].cast<String>()
          : null,
      validations: json['validations'] != null && json['validations'].isNotEmpty
          ? json['validations']
              .entries
              .map<Validations>(
                (entry) => Validations(
                  field: entry.key,
                  message: entry.value.cast<String>(),
                ),
              )
              .toList()
          : null,
      responseDate: json['response_date'] != null
          ? DateTime.parse(json['response_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'messages': messages,
      'validations': validations?.map((e) => e.toJson()).toList(),
      'response_date': responseDate?.toIso8601String(),
    };
  }
}

class Validations {
  String? field;
  List<String>? message;

  Validations({this.field, this.message});

  factory Validations.fromJson(Map<String, dynamic> json) {
    return Validations(
      field: json['field'],
      message: json['messages'] != null && json['messages'].isNotEmpty
          ? json['messages'].cast<String>()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'messages': message,
    };
  }
}
