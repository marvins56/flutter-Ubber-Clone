import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubberapp/AllWidgets/Divider.dart';
import 'package:ubberapp/Assistants/assistantMethods.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controllerGooglemap = Completer();
  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scafoldkey = new GlobalKey<ScaffoldState>();

//get current position of user
  double BottomPaddingOfMap = 0;
  late Position currentPosition;
  var geoLocator = Geolocator();
  //Get users current location
  void LocatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    //get lat and lomgitudes from position
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    // Move camera as position changes
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address = await AssistantMethods.searchCordinateAddress(position);
    print("this is your address :: " + address);
  }

//google maps

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: scafoldkey,
        title: Text('UBER RIDER APP'),
      ),
      drawer: Container(
        width: 255.0,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/user_icon.png",
                        height: 65.0,
                        width: 65.0,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "profile name",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            "Visit profile",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(
                height: 12.0,
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "history",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Visit profile",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "About",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: BottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            //Show current location
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGooglemap.complete(controller);
              newGoogleMapController = controller;
              //on ma creation
              setState(() {
                BottomPaddingOfMap = 300.0;
              });
              //update user location
              LocatePosition();
            },
          ),

          //hamburger button
          // Positioned(
          //   top: 45.0,
          //   left: 22.0,
          //   child: GestureDetector(
          //     onTap: () {
          //       scafoldkey.currentState?.openDrawer();
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(
          //           22.0,
          //         ),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black54,
          //             blurRadius: 6.0,
          //             spreadRadius: 0.5,
          //             offset: Offset(0.7, 0.7),
          //           ),
          //         ],
          //       ),
          //       child: CircleAvatar(
          //         backgroundColor: Colors.white,
          //         child: Icon(
          //           Icons.menu,
          //           color: Colors.black,
          //         ),
          //         radius: 20.0,
          //       ),
          //     ),
          //   ),
          // ),

          // Positioned(
          //   left: 0.0,
          //   right: 0.0,
          //   bottom: 0.0,
          //   child: Container(
          //     height: 300.0,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(18.0),
          //         topRight: Radius.circular(18.0),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black,
          //           blurRadius: 16.0,
          //           spreadRadius: 0.5,
          //           offset: Offset(0.7, 0.7),
          //         ),
          //       ],
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //           horizontal: 24.0, vertical: 18.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: 6.0,
          //           ),
          //           Text(
          //             "hey there",
          //             style: TextStyle(fontSize: 12.0),
          //           ),
          //           Text(
          //             "Where To",
          //             style:
          //                 TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
          //           ),
          //           SizedBox(
          //             height: 6.0,
          //           ),
          //           Container(
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(
          //                 5.0,
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black54,
          //                   blurRadius: 6.0,
          //                   spreadRadius: 0.5,
          //                   offset: Offset(0.7, 0.7),
          //                 ),
          //               ],
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(12.0),
          //               child: Row(
          //                 children: [
          //                   Icon(
          //                     Icons.search,
          //                     color: Colors.blueAccent,
          //                   ),
          //                   SizedBox(
          //                     height: 10.0,
          //                   ),
          //                   Text("Search destination .."),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 24.0,
          //           ),
          //           Row(
          //             children: [
          //               Icon(
          //                 Icons.work,
          //                 color: Colors.grey,
          //               ),
          //               SizedBox(
          //                 height: 10.0,
          //               ),
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     "Add Work ",
          //                   ),
          //                   SizedBox(
          //                     height: 14.0,
          //                   ),
          //                   Text(
          //                     "Add Work address",
          //                     style: TextStyle(
          //                         color: Colors.black54, fontSize: 12.0),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //           SizedBox(
          //             height: 10.0,
          //           ),
          //           DividerWidget(),
          //           SizedBox(
          //             height: 16.0,
          //           ),
          //           Row(
          //             children: [
          //               Icon(
          //                 Icons.home,
          //                 color: Colors.grey,
          //               ),
          //               SizedBox(
          //                 height: 10.0,
          //               ),
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     "Add Home ",
          //                   ),
          //                   SizedBox(
          //                     height: 14.0,
          //                   ),
          //                   Text(
          //                     "Add Work address",
          //                     style: TextStyle(
          //                         color: Colors.black54, fontSize: 12.0),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
