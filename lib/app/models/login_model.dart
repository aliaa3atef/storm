class LoginModel {

  String name;
  String phone;
  String email;
  String uid;
  String image;
  String cover;
  String bio;
  bool isEmailVarified;

  LoginModel(this.name, this.phone, this.email, this.uid, this.image,
      this.cover, this.bio, this.isEmailVarified);

  LoginModel.fromJson(Map<String, dynamic> json)
  {
    name= json['name'];
    phone= json['phone'];
    email= json['email'] ;
    uid= json['uid'];
    image= json['image'];
    cover= json['cover'] ;
    bio= json['bio'];
    isEmailVarified = json['isEmailVarified'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'phone':phone,
      'email':email,
      'uid':uid,
      'isEmailVarified' : isEmailVarified,
    'image': image,
    'cover':cover ,
    'bio':bio,
    };
  }

}

