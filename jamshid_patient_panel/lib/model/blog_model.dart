class BlogModel {
  // String postId;
  // String categoryId;
  int postId;
  int categoryId;
  String postTitle;
  String postBody;
  String postImg;
  // String postView;
  // String status;
  int postView;
  int status;
  String date;

  BlogModel(
      {this.postId,
      this.categoryId,
      this.postTitle,
      this.postBody,
      this.postImg,
      this.postView,
      this.status,
      this.date});

  BlogModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    categoryId = json['category_id'];
    postTitle = json['post_title'];
    postBody = json['post_body'];
    postImg = json['post_img'];
    postView = json['post_view'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['category_id'] = this.categoryId;
    data['post_title'] = this.postTitle;
    data['post_body'] = this.postBody;
    data['post_img'] = this.postImg;
    data['post_view'] = this.postView;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
