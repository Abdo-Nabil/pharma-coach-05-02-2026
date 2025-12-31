class DistrictManagerModel {
  final int id;
  final String username;

  DistrictManagerModel({
    required this.id,
    required this.username,
  });

  factory DistrictManagerModel.fromMap(Map<String, dynamic> map) {
    return DistrictManagerModel(
      id: map['id'] as int,
      username: map['username'] as String,
    );
  }
}
