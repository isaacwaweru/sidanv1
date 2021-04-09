class HomeService{
  String id;
  String type;
  String name;
  String icon;

  HomeService({this.id,this.type, this.name, this.icon});

  HomeService.fromMap(Map<String, dynamic> data){
    id = data['id'];
   type = data['title'];
   name = data['name'];
   icon = data['icon'];
  }

}