class ArticleTreeItemEntity {
  int visible;
  List<ArticleTreeItemEntity> children;
  String name;
  bool userControlSetTop;
  int id;
  int courseId;
  int parentChapterId;
  int order;

  ArticleTreeItemEntity.fromJson(Map<String, dynamic> json)
      : visible = json['visible'],
        children = List<ArticleTreeItemEntity>.from(
            json["children"].map((it) => ArticleTreeItemEntity.fromJson(it))),
        name = json['name'],
        userControlSetTop = json['userControlSetTop'],
        id = json['id'],
        courseId = json['courseId'],
        parentChapterId = json['parentChapterId'],
        order = json['order'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visible'] = this.visible;
    data['children'] =
        children != null ? children.map((v) => v.toJson()).toList() : null;
    data['name'] = this.name;
    data['userControlSetTop'] = this.userControlSetTop;
    data['id'] = this.id;
    data['courseId'] = this.courseId;
    data['parentChapterId'] = this.parentChapterId;
    data['order'] = this.order;
    return data;
  }
}
