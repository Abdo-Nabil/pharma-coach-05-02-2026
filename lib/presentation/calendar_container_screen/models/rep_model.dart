class RepModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;

  const RepModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'first_name': this.firstName,
      'last_name': this.lastName,
      'phone': this.phone,
    };
  }

  factory RepModel.fromMap(Map<String, dynamic> map) {
    return RepModel(
      id: map['id'] as int,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      phone: map['phone'] as String,
    );
  }
}

class TinyRepModel {
  final int id;
  final String username;

  const TinyRepModel({
    required this.id,
    required this.username,
  });

  factory TinyRepModel.fromMap(Map<String, dynamic> map) {
    return TinyRepModel(
      id: map['id'] as int,
      username: map['username'] as String,
    );
  }
}
