part of 'location_cubit.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {}


class MarkerUpdate extends LocationState {}

class AddCity extends LocationState {}

class AddAdress extends LocationState {}

class SendLoading extends LocationState {}

class SendSuccess extends LocationState {}

class SendError extends LocationState {}
class GetUserDataLoading extends LocationState {}

class GetUserDataSuccess extends LocationState {}

class GetUserDataError extends LocationState {}
