class TabModel {
  final String id;
  String title;
  String url;
  bool isLoading;

  TabModel({
    required this.id,
    required this.title,
    required this.url,
    this.isLoading = false,
  });

  TabModel copyWith({
    String? id,
    String? title,
    String? url,
    bool? isLoading,
  }) {
    return TabModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
