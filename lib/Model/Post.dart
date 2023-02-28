class Post {
  final String user;
  final String image;
  final String detail;
  final DateTime createDate;

  Post(this.user, this.image, this.detail, this.createDate);

  Post.fromJson(Map<String, dynamic> json) 
      : user = json['Username'],
        image = json['Image_Acc'], 
        detail = json['Detail_Post'],
        createDate = json['Create_DateTime_Post'];

  Map<String, dynamic> toJson() => {
        'name': user,
        'image': image,
        'detail' : detail,
        'createDate' : createDate,
      };
}