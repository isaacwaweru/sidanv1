class HouseService{
  String id;
  String type;
  String name;
  String icon;

  HouseService({this.id,this.type, this.name, this.icon});

  HouseService.fromMap(Map<String, dynamic> data){
    id = data['id'];
    type = data['type'];
    name = data['name'];
    icon = data['icon'];
  }

}