import 'VideoData.dart';

class VideoListPojo {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  List<VideoData> data;
  int count;
  int code;

  VideoListPojo(
      {this.total,
      this.perPage,
      this.currentPage,
      this.lastPage,
      this.data,
      this.count,
      this.code});

  VideoListPojo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = new List<VideoData>();
      json['data'].forEach((v) {
        data.add(new VideoData.fromJson(v));
      });
    }
    count = json['count'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['code'] = this.code;
    return data;
  }
}
