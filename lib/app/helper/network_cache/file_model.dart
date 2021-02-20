/// Data model that will be used when storing into application file for file operation.
///
/// `time`: is the duration when the data is expired.
///
/// `data`: the content that will be stored in file.
class FileModel {
  DateTime time;
  String data;

  FileModel({this.time, this.data});

  FileModel.fromJson(Map<String, dynamic> json) {
    time = DateTime.parse(json['time']);
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time.toString();
    data['data'] = this.data;
    return data;
  }
}
