import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:pickloction/repositories/locations_repos.dart';

class LocationsMap extends StatefulWidget {
  late Future futureLocationsList;
  int id = 0;

  LocationsMap({
    Key? key,
    required this.futureLocationsList,
    required this.id,
  }) : super(key: key);

  @override
  State<LocationsMap> createState() => _LocationsMapState();
}

class _LocationsMapState extends State<LocationsMap> {
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: OpenStreetMapSearchAndPick(
        buttonTextStyle:
            const TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
        buttonColor: Colors.blue,
        buttonText: 'Set Current Location',
        onPicked: (pickedData) async {
          debugPrint(pickedData.latLong.latitude.toString());
          debugPrint(pickedData.latLong.longitude.toString());
          debugPrint(pickedData.address.toString());
          debugPrint(pickedData.addressName);
          debugPrint("before update: " + widget.id.toString());

          //CALL API TO UPDATE LOCATION
          await LocationsRepos.updateLocations(
            widget.id,
            pickedData.latLong.latitude.toString(),
            pickedData.latLong.longitude.toString(),
          );
          debugPrint("after update: " + widget.id.toString());
          setState(() {
            widget.futureLocationsList = LocationsRepos.fetchLocationsList();
          });
          // Retrieve the copied text from the clipboard
          ClipboardData? data = await Clipboard.getData('text/plain');
          // Paste the text into the TextField
          if (data != null && data.text != null) {
            debugPrint("Pasted text: ${data.text}");
            debugPrint(data.text);
          }
        },
        locationPinText: "Pick Location",
      ),
    );
  }
}
