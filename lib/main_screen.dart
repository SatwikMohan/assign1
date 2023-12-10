import 'dart:io';

import 'package:assignment/functions.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SpeechToText _speechToText = SpeechToText();
  RecorderController controller = RecorderController();
  bool _speechEnabled = false;
  int time = 0;
  String _lastWords = "ew";
  String text = "Start Speaking ....";
  String displayText = "";
  int f= 0;

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      text = "Listening ...";
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      text = "Start Speaking ....";
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords += result.recognizedWords;
      print(_lastWords);
      if(_lastWords.length<(MediaQuery.of(context).size.width/3).toInt()){
        displayText = _lastWords;
      }else{
        if(f==0){
          displayText+="...";
        }
        f=1;
      }
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
    controller = RecorderController()
      ..updateFrequency = const Duration(milliseconds: 100)
      ..normalizationFactor = Platform.isAndroid ? 60 : 40;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(' Audiofy ',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Center(
              child: Text(' ${getMinutes(time)} : ${getSeconds(time)} ',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width/3,
              height: 20,
              child: Text(_lastWords,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/6,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () async{
              final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
              _startListening();
              controller.record(path: appDocumentsDir.path+"/audiofy.m4a");

            },
                icon: Icon(Icons.mic,color: Colors.white,size: 50,),
            ),
          ),
          AudioWaveforms(
              size: Size(MediaQuery.of(context).size.width, 30.0),
              recorderController: controller,
              enableGesture: true,
              waveStyle: WaveStyle(
                backgroundColor: Colors.white,
                showDurationLabel: true,
                spacing: 8.0,
                showBottom: false,
                extendWaveform: true,
                showMiddleLine: false,
              ),
          ),
          SizedBox(height: 160,),
    GestureDetector(
    onHorizontalDragUpdate: (details) {
    // Note: Sensitivity is integer used when you don't want to mess up vertical drag
    int sensitivity = 8;
    if (details.delta.dx > sensitivity) {
    // Right Swipe
      _stopListening();
      controller.stop();
    } else if(details.delta.dx < -sensitivity){
    //Left Swipe
    }
    },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Press Mic To start listening',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
          Text('Swipe Right to stop and Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
        ],
      ),
    ),
        ],
      ),
    );
  }
}
