import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:zone/Tager/core/const/consts.dart';
import 'package:zone/Tager/core/const/dioHelper.dart';

import '../../../core/const/LocationHelper.dart';
import '../../../core/const/exeption.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());


  Position? position;
  LatLng? newPosition;
  String? city;
  String? address;
  final Completer<GoogleMapController> controller = Completer();
  Set<Marker> markers = {};

  Future<void> getCurrentLocation(context)async{
    emit(LocationLoading());
    await LocationHelper.getCurrentLocation(context);
    position = await Geolocator.getCurrentPosition().whenComplete((){
     emit(LocationSuccess());
    });
  }
setAddress(address){
    this.address=address;
    emit(AddAdress());
}

  setCity(city){
    this.city=city;
    emit(AddCity());
  }
  
  sendLocation(){
    emit(SendLoading());
    DioHelper.postData(
      url: "add_location",
      data: {
        "lat":"${position?.latitude??newPosition?.latitude}",
        "long":"${position?.longitude ?? newPosition?.longitude}",
        "place":city,
        "address":address
      },
    ).then((value) => emit(SendSuccess())).catchError((error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      print(errorMessage);

      emit(SendError());
    });
  }
  CameraPosition getCurrentCameraPosition(){
    final CameraPosition currentCameraPosition = CameraPosition(
        bearing: 0,
        zoom: 17,
        tilt: 0,
        target: LatLng(position!.latitude,position!.longitude)
    );
    return currentCameraPosition;
  }


  Future<void> goToMyCurrentLocation() async{

    emit(LocationLoading());
    final GoogleMapController controler = await controller.future;
    markers={};
    controler.animateCamera(CameraUpdate.newCameraPosition(getCurrentCameraPosition())).then((value) =>  emit(LocationSuccess()));

  }

  void onMapTapped(LatLng tappedLocation) async {
    final GoogleMapController controler = await controller.future;

    // Update the camera position
    controler.animateCamera(CameraUpdate.newLatLng(tappedLocation));
    newPosition=tappedLocation;
    if(markers.isEmpty){
      markers.add(Marker(markerId: const MarkerId("1"),position: tappedLocation));
    }else{
      markers={};
      markers.add(Marker(markerId: const MarkerId("1"),position: tappedLocation));
    }
    emit(MarkerUpdate());

    // Optionally, update the state to trigger a rebuild with the new location


  }

  static LocationCubit get(context)=>BlocProvider.of<LocationCubit>(context);
}
