class LocationModel {
  final int? id;
  final String name;
  final String address;
  final String type;

  const LocationModel({
    this.id,
    required this.name,
    required this.address,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'address': this.address,
      'type': this.type,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
    );
  }
}
