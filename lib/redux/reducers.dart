import 'package:dinas/models/AppState.dart';
import 'package:dinas/models/CartItem.dart';
import 'actions.dart';

AppState reducer(AppState state, dynamic action){


  if(action is FormOne){
    state.form1 = action.payload;
  }
  else if(action is FormTwo){
    state.form2 = action.payload;
  }else if(action is AddOrder){
    return addCartItem(state.orders, action);
  }else if(action is Customer){
    state.customer = action.payload;
  }else if(action is Home){
    state.homeservices = action.payload;
  }else if(action is House){
    state.houseservices = action.payload;
  }else if(action is RemoveOrder){
    return removeCartItem(state.orders, action);
  }else if(action is RemoveSingleOrder){
    return removeSingleCartItem(state.orders,action);
  }else if(action is ClearCart){
    return clearCart(state.orders);
  }

  return state;
}

AppState addCartItem(Map<String,CartItem> items, AddOrder action){
  print(items);
  CartItem item = action.cartItem;
  if(items.containsKey(item.id)){
    items.update(
      item.id,
          (old) => CartItem(
        id: old.id,
        title: old.title,
        price: old.price,
        quantity: old.quantity + 1,
      ),
    );
  }else{
    items.putIfAbsent(
      item.id,
          () => CartItem(id: item.id, title: item.title, price: item.price, quantity: 1),
    );
  }
  return AppState(orders: items);
}

AppState removeSingleCartItem(Map<String, CartItem> items, RemoveSingleOrder action){
  if (!items.containsKey(action.id)) return AppState(orders: items);

  if (items[action.id].quantity > 1) {
    items.update(
        action.id,
            (old) => CartItem(
            id: old.id,
            title: old.title,
            price: old.price,
            quantity: old.quantity - 1));
  }
  return AppState(orders: items);
}

AppState removeCartItem(Map<String,CartItem> items, RemoveOrder action){
  items.remove(action.id);
  print(items);
  return AppState(orders: items);
}

AppState clearCart(Map<String, CartItem> items){
  items = {};
  return AppState(orders: items);
}