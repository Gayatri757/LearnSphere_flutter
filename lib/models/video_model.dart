class VideoModel {
  final int id;
  final String title;
  final String teacher;
  final String description;
  final String youtubeUrl;
  final String thumbnail;
  final String duration;

  VideoModel({
    required this.id,
    required this.title,
    required this.teacher,
    required this.description,
    required this.youtubeUrl,
    required this.thumbnail,
    required this.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      teacher: json['teacher'],
      description: json['description'],
      youtubeUrl: json['youtube_url'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
    );
  }
}
