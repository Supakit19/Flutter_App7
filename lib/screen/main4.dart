import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_Route.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Main1 extends StatefulWidget {
  const Main1({super.key});

  @override
  State<Main1> createState() => _Main1State();
}

class _Main1State extends State<Main1> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  String _latLngDisplay = ""; // สำหรับแสดงค่า Latitude และ Longitude
  double _iconOffsetY = 0; // สำหรับการเลื่อนไอคอน'
  double _boxOffsetY = 0; // สำหรับการเลื่อนกล่องข้อความ
  final Set<Marker> _markers = {};
  final List<LatLng> _savedPositions = []; // สำหรับเก็บพิกัดที่บันทึก
  double _lastDistance = 0; // สำหรับเก็บระยะทางล่าสุด
  final Set<Polyline> _polylines = {}; // สำหรับเก็บ Polyline
  String TextPrize = ''; // สำหรับเก็บข้อความที่จะแสดง
  double Prize = 0; // สำหรับเก็บค่าจัดส่งเอาค่าไปคำนวน
  String _addressDisplay = ""; // สำหรับแสดงที่อยู่
  double _containerOpacity = 1.0; // ค่าความโปร่งใสเริ่มต้นของ Container

  // หมุด seven
  LatLng Seven = const LatLng(0, 0);

  AssetMapBitmap SevenIcon = AssetMapBitmap(
    'assets/images/marker_icon.png',
    width: 25,
    height: 25,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // เรียกใช้ฟังก์ชันเพื่อขอพิกัดปัจจุบัน
    _addMarkers(); // เรียกใช้ฟังก์ชันเพิ่ม markers
  }

  void SetSeven() {
    setState(() {
      Seven = _currentPosition;
    });
  }

  void HandleSubmit() {
    _saveCurrentPosition(); // เรียกใช้ฟังก์ชันบันทึกพิกัดปัจจุบัน
    _getDirections(); // เรียกใช้ฟังก์ชันเพื่อวาดเส้นทาง
    CheckDistance();
  }

  void HandleSetSeven() {
    SetSeven();
    _addMarkers();
  }

  void CheckDistance() {
    if (_lastDistance > 0 && _lastDistance <= 1000) {
      print('Free Shipping!'); // แสดงข้อความว่าสินค้ามีการจัดส่งฟรี
      setState(() {
        TextPrize = 'Free Shipping!'; // แสดงข้อความว่าสินค้ามีการจัดส่งฟรี
        Prize = 0; // กำหนดค่าจัดส่งเป็น 0
      });
    }

    if (_lastDistance > 1000 && _lastDistance <= 5000) {
      print('Shipping Fee: 50 Baht'); // แสดงค่าค่าจัดส่ง 50 บาท
      setState(() {
        TextPrize =
            'Shipping Fee: 100 Baht'; // แสดงข้อความว่าสินค้ามีการจัดส่งฟรี
        Prize = 100; // กำหนดค่าจัดส่งเป็น 100
      });
    }

    if (_lastDistance > 5000) {
      setState(() {
        TextPrize =
            'Shipping Fee: 200 Baht'; // แสดงข้อความว่าสินค้ามีการจัดส่งฟรี
        Prize = 200; // กำหนดค่าจัดส่งเป็น 200
      });
    }
  }

  // ฟังก์ชันเพิ่ม markers
  void _addMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('Seven'),
        position: Seven,
        infoWindow:
            const InfoWindow(title: 'Home', snippet: 'Capital of Thailand'),
        icon: SevenIcon,
      ),
    );
  }

  // ฟังก์ชันสำหรับบันทึกพิกัดปัจจุบัน
  void _saveCurrentPosition() {
    setState(() {
      _savedPositions.add(_currentPosition); // เพิ่มพิกัดปัจจุบันลงในลิสต์
      if (_savedPositions.length >= 2) {
        _lastDistance = _calculateDistance(_savedPositions.last);
        print(
            "Distance to last saved position: ${_lastDistance.toStringAsFixed(2)} meters");
      }
    });
  }

  double _calculateDistance(LatLng position) {
    return Geolocator.distanceBetween(
      Seven.latitude,
      Seven.longitude,
      position.latitude,
      position.longitude,
    );
  }

  Future<void> _getDirections() async {
    // เปลี่ยนค่า _currentPosition เป็นตำแหน่งที่ผู้ใช้กด
    final LatLng destinationPosition = _currentPosition;

    // API Key ของ Google Maps
    const ApiKey = 'AIzaSyDdlrYf7eKH5CyMlnpP09HCDVSK7JOCzAg';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${Seven.latitude},${Seven.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&mode=driving&key=$ApiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final polyline = routes[0]['overview_polyline']['points'];
        _addPolyline(polyline);
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  void _addPolyline(String polyline) {
    final points = _decodePolyline(polyline);
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.green[700]!,
        width: 4,
      ));
    });
  }

  Future<void> _getAddressFromLatLng() async {
    const apiKey =
        'AIzaSyDdlrYf7eKH5CyMlnpP09HCDVSK7JOCzAg'; // เปลี่ยนเป็น API Key ของคุณ
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_currentPosition.latitude},${_currentPosition.longitude}&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        setState(() {
          _addressDisplay = data['results'][0]['formatted_address'];
        });
      } else {
        setState(() {
          _addressDisplay = 'ไม่พบที่อยู่';
        });
      }
    } else {
      setState(() {
        _addressDisplay = 'ไม่สามารถเรียกข้อมูลที่อยู่ได้';
      });
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _latLngDisplay =
          "Lat: ${position.latitude}, Lng: ${position.longitude}"; // แสดงค่าเริ่มต้น
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentPosition = position.target;
      _latLngDisplay =
          "Lat: ${position.target.latitude}, Lng: ${position.target.longitude}"; // อัปเดตค่าพิกัด
      _iconOffsetY = 25; // ย้ายไอคอนขึ้นน้อยลง
      _boxOffsetY = 25; // ย้ายกล่องข้อความขึ้นน้อยลง

      // ปรับค่าความโปร่งใสของ Container ตามตำแหน่ง Y
      _containerOpacity =
          position.target.latitude > 0 ? 0.0 : 1.0; // ควบคุมความโปร่งใส
    });
  }

  void _onCameraIdle() {
    // กลับไอคอนลงมาที่ตำแหน่งเดิมเมื่อกล้องหยุดเคลื่อนที่
    _getAddressFromLatLng(); // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูลที่อยู่
    setState(() {
      _iconOffsetY = 0;
      _boxOffsetY = 0;
      _containerOpacity = 1.0; // กลับค่าความโปร่งใส
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 70 - _iconOffsetY,
            left: MediaQuery.of(context).size.width / 2 - 12.5,
            child: const Icon(
              Icons.location_on,
              size: 25,
              color: Color.fromARGB(255, 182, 34, 23),
            ),
          ),
          // ใช้ Stack เพื่อรวม Opacity และ Positioned
          Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                270 -
                _boxOffsetY, // ปรับตำแหน่งของ Container ที่นี่
            left: MediaQuery.of(context).size.width / 2 -
                145, // ปรับตำแหน่งของ Container ที่นี่
            child: Opacity(
              opacity: _containerOpacity,
              child: Container(
                width: 290,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _latLngDisplay,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        HandleSubmit();
                        Navigator.pushNamed(context, AppRouter.main3,
                            arguments: {
                              'address': _addressDisplay,
                            });
                      },
                      child: const Text('แสดงเส้นทาง'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _latLngDisplay, // แสดงค่าพิกัด
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Distance to last saved position: ${_lastDistance.toStringAsFixed(2)} meters', // แสดงระยะทาง
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Prize : $TextPrize', // แสดงราคาจัดส่ง
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  _addressDisplay, // แสดงที่อยู่
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:
                      HandleSetSeven, // เรียกใช้ฟังก์ชันเพื่อบันทึกตำแหน่ง
                  child: const Text('เซ็ทจุดเซเว่น'),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
