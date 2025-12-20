class PostLoginUserResp {
  String? status;
  int? statusCode;
  String? message;
  Data? data;

  PostLoginUserResp({this.status, this.statusCode, this.message, this.data});

  PostLoginUserResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status;
    }
    if (statusCode != null) {
      data['statusCode'] = statusCode;
    }
    if (message != null) {
      data['message'] = message;
    }
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

enum UserType { dm, nsm }

extension UserTypeX on UserType {
  /// API / storage value
  String get value {
    switch (this) {
      case UserType.dm:
        return 'DM';
      case UserType.nsm:
        return 'NSM';
    }
  }

  /// Strict parsing (throws on invalid input)
  static UserType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'DM':
        return UserType.dm;
      case 'NSM':
        return UserType.nsm;
      default:
        throw ArgumentError('Invalid UserType: $value');
    }
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? authToken;
  UserType? userType;
  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.authToken,
    this.userType,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authToken = json['authToken'];
    userType = json['user_type'] != null
        ? UserTypeX.fromString(json['user_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (firstName != null) {
      data['first_name'] = firstName;
    }
    if (lastName != null) {
      data['last_name'] = lastName;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (emailVerifiedAt != null) {
      data['email_verified_at'] = emailVerifiedAt;
    }
    if (createdAt != null) {
      data['created_at'] = createdAt;
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt;
    }
    if (authToken != null) {
      data['authToken'] = authToken;
    }
    if (userType != null) {
      data['user_type'] = userType?.value;
    }
    return data;
  }
}
