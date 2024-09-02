//import 'package:flutter/cupertino.dart';
import 'package:billing/services/meeting_db.dart';
import 'package:billing/view/meeting_report.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Meeting extends StatefulWidget {
  const Meeting({super.key});

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
//variables for inserting record into database
 final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _businessController = TextEditingController();
  final MeetingDb _dbHelper = MeetingDb();

  @override
  void dispose() {
    // TODO: implement dispose
     _nameController.dispose();
    _mobileController.dispose();
    _businessController.dispose();
    super.dispose();
  }

  

  //get address from gps location
  /**   }
      if (place.postalCode != null && place.postalCode!.isNotEmpty) {
        address += '${place.postalCode}, ';
      }
      if (place.country != null && place.country!.isNotEmpty) {
        address += place.country!;
      }

      // Remove any trailing comma and space
      if (address.endsWith(', ')) {
        address = address.substring(0, address.length - 2);
      }

      return address;
    } else {
      return 'Address not found';
    }
  } catch (e) {
    print('Error occurred while fetching address: $e');
    return 'Error occurred while fetching address';
  }
}*/

 double? lat;

  double? long;

  String address = "";
  
  Future<String> getLatLong() async {
  Position position = await _determinePosition();
  print("Position: $position");

  lat = position.latitude;
  long = position.longitude;

  return await getAddress(lat!, long!);
}


  //For convert lat long to address
 Future<String> getAddress(double lat, double long) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      String street = place.street ?? 'Unknown street';
      String subLocality = place.subLocality ?? '';
      String locality = place.locality ?? '';
      String postalCode = place.postalCode ?? '';
      String country = place.country ?? '';

      // Construct the address string
      String address = '$street, $subLocality, $locality, $postalCode, $country';

      // Remove any leading or trailing commas and spaces
      address = address.replaceAll(RegExp(r',\s*,'), ',').trim();
      if (address.endsWith(',')) {
        address = address.substring(0, address.length - 1);
      }

      print("Constructed Address: $address");
      return address;
    } else {
      return 'Address not found';
    }
  } catch (e) {
    print('Error occurred while fetching address: $e');
    return 'Error occurred while fetching address';
  }
}





Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // Define location settings
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // Set the desired accuracy
    distanceFilter: 10, // Minimum distance (in meters) between location updates
    timeLimit: Duration(seconds: 60), // Timeout for obtaining location
  );

  return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
}
  

  //new method
  



  Future<void> _saveMeeting() async {
  if (_nameController.text.isNotEmpty &&
      _mobileController.text.isNotEmpty &&
      _businessController.text.isNotEmpty) {

    String address = await getLatLong();

    Map<String, dynamic> meeting = {
      'name': _nameController.text,
      'mobile': _mobileController.text,
      'business': _businessController.text,
      'location': address, // Use the obtained address here
    };

    await _dbHelper.insertMeeting(meeting);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Meeting saved successfully!'),
    ));

    _nameController.clear();
    _mobileController.clear();
    _businessController.clear();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please fill all fields'),
    ));
  }
}
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('Meeting'),backgroundColor: Theme.of(context).colorScheme.inversePrimary, ),
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name label and text field in a row
                      Row(
                        children: [
                          Container(
                            width: 100, // Adjust width as needed
                            child:const Text(
                              'Name',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Mobile label and text field in a row
                      Row(
                        children: [
                          Container(
                            width: 100, // Adjust width as needed
                            child: Text(
                              'Mobile',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _mobileController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Business label and text field in a row
                      Row(
                        children: [
                          Container(
                            width: 100, // Adjust width as needed
                            child: Text(
                              'Business',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _businessController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Save button with decoration and hover effect
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return const Color.fromARGB(255, 231, 176, 241); // Hover color
                                }
                                return const Color.fromARGB(255, 231, 176, 241); // Regular color
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11.0), // Border radius
                              ),
                            ),
                          ),
                          onPressed: () {
                            _saveMeeting();                            // Handle save button press
                          },
                          child: Text('Save'),
                        ),
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return const Color.fromARGB(255, 165, 220, 240); // Hover color
                                }
                                return const Color.fromARGB(255, 158, 204, 229); // Regular color
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11.0), // Border radius
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MeetingReport()),
                               );                           // Handle save button press
                          },
                          child: Text('Get Meeting Reports'),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}