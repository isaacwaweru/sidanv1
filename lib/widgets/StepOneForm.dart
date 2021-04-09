import 'package:dinas/models/AppState.dart';
import 'package:dinas/pages/agent/AgentSignUpStepTwo.dart';
import 'package:dinas/redux/actions.dart';
import 'package:dinas/widgets/DefaultButton.dart';
import 'package:dinas/widgets/DefaultTextField.dart';
import 'package:dinas/widgets/SnackWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Services {
  final int id;
  final String name;

  Services({
    this.id,
    this.name,
  });
}

class StepOneForm extends StatefulWidget {
  _StepOneFormState createState() => _StepOneFormState();
}

class _StepOneFormState extends State<StepOneForm> {
  final _stepOneKey = GlobalKey<FormState>();

  String first_name;
  String last_name;
  String email;
  String location;
  bool locationSet = false;

  // select box
  static List<Services> _animals = [
    Services(id: 1, name: "House Chores"),
    Services(id: 2, name: "Garden Work"),
    Services(id: 3, name: "Home Chores"),
    Services(id: 4, name: "Cleaning"),
  ];
  final _items = _animals
      .map((animal) => MultiSelectItem<Services>(animal, animal.name))
      .toList();
  List<Services> _selectedAnimals = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  // end of selectbox variables

  @override
  void initState() {
    _selectedAnimals = _animals;
    super.initState();
  }

  getUserCurrentLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: "AIzaSyBH4FrgjqOR68RHVS6hfHVet7XpQrhWwcc",   // Put YOUR OWN KEY here.
          onPlacePicked: (result) {

            setState((){
              location = result.name;
              locationSet = true;
            });
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(-33.8567844, 151.213108),
          useCurrentLocation: true,
        ),
      ),
    );

  }

  FormOneSubmit() {
    if(first_name.isNotEmpty && last_name.isNotEmpty && email.isNotEmpty && location.isNotEmpty){
      var data = {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'location': location,
        "services": _selectedAnimals.map((e) => e.name).toList()
      };
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FormOne(data));

      print(data);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgentSignUpStepTwo()),
      );
    }else{
      errorSnackBar("Fields Cannot Be Empty");
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Form(
          key: _stepOneKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: DefaultTextField(
                      keyboard: TextInputType.name,
                      changed: (newValue) {
                        setState(() {
                          first_name = newValue;
                        });
                      },
                      label: "First Name",
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: DefaultTextField(
                      keyboard: TextInputType.name,
                      changed: (newValue) {
                        setState(() {
                          last_name = newValue;
                        });
                      },
                      label: "Last Name",
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: DefaultTextField(
                      keyboard: TextInputType.emailAddress,
                      changed: (newValue) {
                        setState(() {
                          email = newValue;
                        });
                      },
                      label: "Email",
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          locationSet ?
                          Text(location, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)) :
                          Text("Pick Location ...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
                          FlatButton(
                            onPressed: getUserCurrentLocation,
                            child: Icon(Icons.location_on_outlined, color: Theme.of(context).buttonColor, size: 30,)
                          )
                        ]
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: MultiSelectChipField(
                  scroll: false,
                  items: _items,
                  title: Text(
                    "Services You Offer",
                    style: TextStyle(color: Colors.white),
                  ),
                  headerColor: Theme.of(context).backgroundColor,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.8),
                  ),
                  selectedChipColor: Theme.of(context).buttonColor,
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold),
                  onTap: (values) {
                    _selectedAnimals = values;
                  },
                ),
              ),
              DefaultButton(
                press: () {
                  FormOneSubmit();
                },
                text: "Continue",
              )
            ],
          ),
        );
      },
    );
  }
}
