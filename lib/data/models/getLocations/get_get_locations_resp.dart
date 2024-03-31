class GetGetLocationsResp {
  String? status;
  int? statusCode;
  String? message;
  LocationData? data; // Marked as nullable

  GetGetLocationsResp({
     this.status,
     this.statusCode,
     this.message,
    this.data,

    // Nullable
  });

  factory GetGetLocationsResp.fromJson(Map<String, dynamic> json) {
    return GetGetLocationsResp(
      status: json['status'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? LocationData.fromJson(json['data']) : null,
    );
  }
}

class LocationData {
  int currentPage;
  List<Location> data;
  int lastPage;
  String firstPageUrl;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  int total;

  LocationData({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.firstPageUrl,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.total,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      currentPage: json['current_page'] ?? 0,
      data: List<Location>.from(json['data'].map((x) => Location.fromJson(x))),
      lastPage: json['last_page'] ?? 0,
      firstPageUrl: json['first_page_url'] ?? '',
      lastPageUrl: json['last_page_url'] ?? '',
      nextPageUrl: json['next_page_url'] ?? '',
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class Location {
  int id;
  String createdAt;
  String updatedAt;
  String name;
  String address;
  String type;

  Location({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.address,
    required this.type,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
