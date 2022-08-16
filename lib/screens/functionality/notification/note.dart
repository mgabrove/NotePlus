class Note{
  String id;
  final String note;
  final double long;
  final double lat;

  Note({
    this.id = '',
    required this.note,
    required this.lat,
    required this.long
  });

  getNote() {
    return note;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'note': note,
    'long' : long,
    'lat': lat
  };

  static Note fromJson(Map<String, dynamic> json) => Note(
      id: json['id'],
      note: json['note'],
      lat: json['lat'],
      long: json['long']
  );
}