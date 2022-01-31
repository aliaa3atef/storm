class UsersChatModel {

  String name;
  String uid;
  String image;


  UsersChatModel(this.name, this.uid, this.image);

  UsersChatModel.fromJson(Map<String, dynamic> json)
  {
    name= json['name'];
    uid= json['uid'];
    image= json['image'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'uid':uid,
      'image': image,
    };
  }

}

