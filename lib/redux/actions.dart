
import 'package:dinas/models/CartItem.dart';

class FormOne{
  var payload;
  FormOne(this.payload);
}

class FormTwo{
  var payload;
  FormTwo(this.payload);
}

class AddOrder{
  final CartItem cartItem;

  AddOrder(this.cartItem);
}

class RemoveOrder{
  final String id;
  RemoveOrder(this.id);
}

class RemoveSingleOrder{
  final String id;
  RemoveSingleOrder(this.id);
}

class ClearCart{
  ClearCart();
}

class Customer{
  var payload;
  Customer(this.payload);
}

class House{
  var payload;
  House(this.payload);
}
class Home{
  var payload;
  Home(this.payload);
}
