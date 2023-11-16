import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zone/Tager/Presentation/add_location/bigGoogleMap.dart';
import 'package:zone/Tager/Presentation/add_location/locationCubit/location_cubit.dart';
import 'package:zone/Tager/Presentation/add_location/smallGoogleMap.dart';

import '../../core/Navigation/navigation.dart';
import '../../core/const/LocationHelper.dart';
import '../../core/const/Styles.dart';
import '../../core/widget/Button.dart';
import 'package:geolocator/geolocator.dart';

class AddLocation extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xffBF953F),
                  Colors.black,
                  Colors.black,
                  Colors.black
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.centerStart),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/img_constraction.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: GradientText(
                      'MBAG',
                      style: Styles.textStyleTitle50,
                      gradientDirection: GradientDirection.ttb,
                      colors: const [Color(0xffEEBB49), Color(0xffD9D9D9)],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GradientText(
                    'For trading',
                    style: Styles.textStyleTitle24,
                    colors: const [Color(0xffEEBB49), Color(0xffD9D9D9)],
                    gradientDirection: GradientDirection.ttb,
                    // gradientType: GradientType.linear,
                  ),
                  const SizedBox(
                    height: 10.0,
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Add Your location',
                            style: Styles.textStyleTitle24.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 0),
                            child: Text(
                              'Please, add the location that you want  client connect you in it',
                              textAlign: TextAlign.center,
                              style: Styles.textStyleTitle18.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigato(context, const CustomLargeGoogleMap());
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.amber,
                            size: 42,
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Text(
                            "Set on Map",
                            style: Styles.textStyleTitle20.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              15.0), // Adjust the value for the desired rounding
                          child: const CustomGoogleMap()),
                    ),
                    Text(
                      'Location you added',
                      style: Styles.textStyleTitle24.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    BlocBuilder<LocationCubit, LocationState>(
                      builder: (context, state) {
                        var cubit = LocationCubit.get(context);
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: 'Enter City Ex. Giza',
                                        hintStyle: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 24),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter City';
                                        }
                                        return null; // Return null for valid input
                                      },
                                      onSaved: (value) {
                                        cubit.setCity(value);
                                      },
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintStyle: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 24),
                                        hintText:
                                            'Enter address Ex. 23 ahmed street at 4 distract',
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter address';
                                        }
                                        return null; // Return null for valid input
                                      },
                                      onSaved: (value) {
                                        cubit.setAddress(value);
                                      },
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors
                                                .amber, // Adjust color as needed
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            state is SendLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.amber,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Button(
                                      textButton: 'Save Location',
                                      funcation: () {
                                        if (formKey.currentState!.validate()) {
                                          // If the form is valid, save the input value
                                          formKey.currentState!.save();
                                          cubit.sendLocation();
                                        }
                                      },
                                    ),
                                  )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
