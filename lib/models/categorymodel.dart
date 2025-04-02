class Service {
  final String id;
  final String name;
  final List<Map<String, dynamic>> details;

  Service({required this.id, required this.name, required this.details});

  // Convert from Supabase JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      details: List<Map<String, dynamic>>.from(json['details']),
    );
  }

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'details': details};
  }
}
