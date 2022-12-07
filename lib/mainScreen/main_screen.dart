import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../mapScreen/map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? id;
  Position? currentPosition;
  late Position updatedPosition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = grnarateId();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      currentPosition = await getCurrentLocation();
      await postDriverLocation();
      print(currentPosition!.latitude.toString());
      print(currentPosition!.longitude.toString());
    });
  }

  bool online = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () { 
                  addDriverdata();
                },
                child: const Text(
                  'Add Driver to database',
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
              child: const Text('Go to map'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(online ? 'online' : 'offline'),
              onPressed: () {
                setState(() {
                  online = true;
                  online == true ? updatePosition() : '';
                });
              },
            ),
            ElevatedButton(
              child: Text(online ? 'offline' : 'online'),
              onPressed: () {
                setState(() {
                  online = false;
                  // online == false ? " " : updatePosition();
                  online == false ? "" : updatePosition();
                  online == false ? deleteDriver() : '';
                });
              },
            )
          ],
        ),
      )),
    );
  }

  updatePosition() {
    // final periodicTimer =
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      updatedPosition = await Geolocator.getCurrentPosition();
      postUpdatedLocation();
    });
  }

  postUpdatedLocation() {
    Map location = {
      'id': id,
      'latitude': updatedPosition.latitude.toString(),
      'longitude': updatedPosition.longitude.toString(),
    };
    DatabaseReference locRef =
        FirebaseDatabase.instance.ref().child('location');
    locRef.child('locationId').update({
      'id': '1',
      'latitude': updatedPosition.latitude.toString(),
      'longitude': updatedPosition.longitude.toString(),
    });
    print('working');
  }

  deleteDriver() {
    DatabaseReference locRef =
        FirebaseDatabase.instance.ref().child('location');
    locRef.child('locationId').remove();
  }

  postDriverLocation() {
    Map location = {
      'id':id ,
      'latitude': currentPosition!.latitude.toString(),
      'longitude': currentPosition!.longitude.toString(),
    };
    DatabaseReference locRef =
        FirebaseDatabase.instance.ref().child('location');
    locRef.child('$id').set(location);
  }

  addDriverToDatabase() {
    Map driverMap = {
      "id": '2',
      "name": "Rahul",
      "email": "rahul@gmail.com",
      "prone": "40315601447",
    };

    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child('drivers');
    driversRef.child('driversId').set(driverMap);
  }

  int grnarateId() {
    var rng = Random();

    var otp = (rng.nextInt(5000) + 1001);
    print(otp);
    return otp;
  }

  addDriverdata() async {
    final dio = Dio();

    try {
      var response = await dio.post(
          'https://driverapp-a6e21-default-rtdb.firebaseio.com/driverProfile.json',
          data: jsonEncode({
            "id": '10',
            "name": "Tharun",
            "email": "tarun@gmail.com",
            "prone": "40315601447",
          }));

      log(response.data);
    } catch (e) {
      if (e is DioError) {
        print(e.toString());
      }
      return null;
    }
  }

// final shouldStop = true; //No more tick-tock now! Please

// if (shouldStop) {
//   timer.cancel();
// }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location servises are disabled');
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
