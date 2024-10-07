import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:pickloction/repositories/locations_repos.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: FutureBuilder(
                future: futureLocationsList,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                child: Card(
                                  margin: const EdgeInsetsDirectional.all(10.0),
                                  elevation: 2.0,
                                  child: ListTile(
                                    title: Text("${data[index]['address']}"),
                                    subtitle: Text(
                                        "${data[index]['latitude']}, ${data[index]['longitude']}"),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      radius: 23,
                                      child: Text("${data[index]['id']}"),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  debugPrint("${data[index]['id']}");
                                  //CALL API TO UPDATE LOCATION
                                  id = data[index]['id'];
                                  //copy to clipboard
                                  Clipboard.setData(ClipboardData(
                                      text: data[index]['address']));

                                  // Show a SnackBar to notify the user that the text is copied
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blueAccent,
                                      content: Text(
                                        'Text copied to clipboard!',
                                        style: TextStyle(color: Colors.white),
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

                //CALL API TO UPDATE LOCATION
                await LocationsRepos.updateLocations(
                  id,
                  pickedData.latLong.latitude.toString(),
                  pickedData.latLong.longitude.toString(),
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
                  debugPrint(data.text);
                }
              },
              locationPinText: "Pick Location",
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PullToRefreshPage(),
//     );
//   }
// }

// class PullToRefreshPage extends StatefulWidget {
//   @override
//   _PullToRefreshPageState createState() => _PullToRefreshPageState();
// }

// class _PullToRefreshPageState extends State<PullToRefreshPage> {
//   List<String> _items = ["Item 1", "Item 2", "Item 3"];

//   // Method to simulate data fetching
//   Future<void> _refreshData() async {
//     await Future.delayed(Duration(seconds: 2)); // Simulate network delay
//     setState(() {
//       // Add a new item to the list
//       _items.add("Item ${_items.length + 1}");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Pull to Refresh Example')),
//       body: RefreshIndicator(
//         onRefresh: _refreshData, // This method is called when pulled
//         child: ListView.builder(
//           itemCount: _items.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(_items[index]),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
