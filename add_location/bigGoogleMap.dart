import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zone/Tager/Presentation/add_location/locationCubit/location_cubit.dart';


class CustomLargeGoogleMap extends StatelessWidget {
  const CustomLargeGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        var cubit = LocationCubit.get(context);

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                cubit.position != null
                    ? GoogleMap(
                  markers: cubit.markers,
                  onTap: cubit.onMapTapped,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: cubit.getCurrentCameraPosition(),
                  onMapCreated: (GoogleMapController controller) {
                    cubit.controller.complete(controller);
                  },
                )
                    : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
                cubit.markers.isNotEmpty?Container(
                  margin: const EdgeInsets.fromLTRB(20, 30, 8, 0),
                  child: FloatingActionButton(
                    heroTag: "MapTag",
                    backgroundColor: Colors.green.withOpacity(0.6),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                ):Container(),
              ],
            ),
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: cubit.goToMyCurrentLocation,
              child: const Icon(
                Icons.place_outlined,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );

  }

}
