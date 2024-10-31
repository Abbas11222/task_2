class User{
  int? _id;
  String? _qoute;
  String? _author;

  User(this._qoute,this._author);

  get qoute=>_qoute;
  get author=>_author;
  get id => _id;

  User.map(dynamic obj){
    _id=obj['id'];
    _author=obj['author'];
    _qoute=obj['qoute'];
  }

  Map<String,dynamic> toMap(){
    var map= Map<String,dynamic>();
    map['qoute']=_qoute;
    map['author']=_author;
    if(id!=null){
      map['id']=_id;
    }
    return map;
  }

  User.fromMap(Map<String,dynamic> map){
    _id=map['id'];
    _qoute=map['qoute'];
    _author=map['author'];
  }

}