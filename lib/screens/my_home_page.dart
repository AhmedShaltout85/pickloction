// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:pickloction/repositories/locations_repos.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  List data = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future futureLocationsList;
  int id = 0;
  @override
  void initState() {
    super.initState();
    debugPrintStack(label: "from init: ");
    futureLocationsList = LocationsRepos.fetchLocationsList();
    LocationsRepos.fetchLocationsList()
        .then((v) => debugPrint("from init:  " + v[0]['address']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          //CALL API TO UPDATE LOCATION
          debugPrint("update button clicked: LIST IS UPDATED");
          setState(() {
            futureLocationsList = LocationsRepos.fetchLocationsList();
          });
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: FutureBuilder(
                  future: futureLocationsList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      widget.data = snapshot.data;
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  child: Card(
                                    margin:
                                        const EdgeInsetsDirectional.all(10.0),
                                    elevation: 2.0,
                                    child: ListTile(
                                      title: Text(
                                          "${widget.data[index]['address']}"),
                                      subtitle: Text(
                                          "${widget.data[index]['latitude']}, ${widget.data[index]['longitude']}"),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blueAccent,
                                        radius: 23,
                                        child:
                                            Text("${widget.data[index]['id']}"),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    debugPrint("${widget.data[index]['id']}");
                                    //CALL API TO UPDATE LOCATION
                                    id = widget.data[index]['id'];
                                    //copy to clipboard
                                    Clipboard.setData(ClipboardData(
                                        text: widget.data[index]['address']));

                                    // Show a SnackBar to notify the user that the text is copied
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.black26,
                                        content: Center(
                                          child: Text(
                                            'Text copied to clipboard!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          });
                    } else {
                      return const CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      );
                    }
                  },
                ),
              ),
            ),
            Expanded(
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
                  debugPrint("before update: " + id.toString());

                  if (widget.data.isEmpty) {
                    debugPrint("data is empty");
                  } else {
                   await LocationsRepos.updateLocations(
                      id,
                      pickedData.latLong.latitude.toString(),
                      pickedData.latLong.longitude.toString(),
                      pickedData.addressName,
                    );
                    debugPrint("after update: " + id.toString());
                    setState(() {
                      futureLocationsList = LocationsRepos.fetchLocationsList();
                    });
                    // Retrieve the copied text from the clipboard
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    // Paste the text into the TextField
                    if (data != null && data.text != null) {
                      debugPrint("Pasted text: ${data.text}");
                    }
                  }
                  //tost message not working
                },
                //CALL API TO UPDATE LOCATION

                locationPinText: "Pick Location",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
