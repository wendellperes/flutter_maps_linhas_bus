// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geocode/geocode.dart';
//
// class mapPage extends StatefulWidget {
//   @override
//   _mapPageState createState() => _mapPageState();
// }
//
// class _mapPageState extends State<mapPage> {
//   GoogleMapController mapController;
//   double minhaLatitude;
//   double minhaLongitude;
//   // SharedPreferences _sharedPreferences;
//
//   final TextEditingController origemcontroller = TextEditingController();
//   final TextEditingController destinocontroller = TextEditingController();
//
//   Position posicao;
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition();
//   }
//   getDadosEnderecos() async {
//     posicao = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       minhaLatitude = posicao.latitude;
//       minhaLongitude = posicao.longitude;
//     });
//     print("${posicao}");
//     GeoCode geoCode = GeoCode();
//
//     if (minhaLongitude != null ){
//       try {
//         var coordinates = await geoCode.reverseGeocoding(
//             latitude: minhaLatitude,
//             longitude: minhaLongitude
//         );
//
//         print("endereço: ${coordinates}");
//       } catch (e) {
//         print('error de conversao de endereço${e}');
//       }
//     }
//   }
//
//   void _onMapCreated(GoogleMapController controller){
//     mapController = controller;
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _determinePosition();
//     getDadosEnderecos();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text('Maps Integration'),
//         actions: [
//           IconButton(
//               onPressed: (){
//                 getDadosEnderecos();
//               },
//               icon: Icon(Icons.add)
//           )
//         ],
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//         Positioned(
//           top: 0,
//           right: 0,
//           left: 0,
//           child: Container(
//             height: 120,
//             color: Colors.blue,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       child: Text('Origem'),
//                       margin: EdgeInsets.only(right: 10),
//                     ),
//                     Expanded(
//                         child: TextFormField(
//                           controller: origemcontroller,
//                           decoration: InputDecoration(
//                             hintText: 'Avenida Silva',
//
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       child: Text('Destino'),
//                       margin: EdgeInsets.only(right: 10),
//                     ),
//                     Expanded(
//                         child: TextFormField(
//                           controller: destinocontroller,
//                           decoration: InputDecoration(
//                             hintText: 'Avenida Silva',
//
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 120,
//           right: 0,
//           left: 0,
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             child: minhaLatitude != null ? GoogleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(minhaLatitude, minhaLongitude),
//                 zoom: 17.0
//               ),
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               zoomGesturesEnabled: true,
//               zoomControlsEnabled: true,
//             ) : Container(),
//           )
//         ),
//         ],
//       ),
//     );
//   }
// }
