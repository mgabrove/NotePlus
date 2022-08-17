class Group{
  String id;
  String name;

  Group({
    this.id = '',
    required this.name,
  });

  String getName() {
    return this.name;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static Group fromJson(Map<String, dynamic> json) => Group(
      id: json['id'],
      name: json['name'],
  );
}