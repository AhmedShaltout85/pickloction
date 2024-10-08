import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickloction/repositories/locations_repos.dart';
class LocationsListItems extends StatefulWidget {
  const LocationsListItems({Key? key}) : super(key: key);

  @override
  State<LocationsListItems> createState() => _LocationsListItemsState();
}

class _LocationsListItemsState extends State<LocationsListItems> {
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
    return Expanded(
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
                            Clipboard.setData(
                                ClipboardData(text: data[index]['address']));

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
    );
  }
}