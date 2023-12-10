import 'package:permission_handler/permission_handler.dart';

void callForPermissions() async{
  await Permission.accessMediaLocation;
  await Permission.mediaLibrary;
  await Permission.storage;
  await Permission.audio;
  await Permission.speech;
}

int getSeconds (int time){
  return time%60;
}

int getMinutes(int time){
  return (time/60).toInt();
}