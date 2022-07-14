
import 'dart:async';

import 'package:flutter/material.dart';


class AudioRecorderEvent {}
class StartRec extends AudioRecorderEvent {}
class StopRec extends AudioRecorderEvent {}

class AudioRecorderStream extends ChangeNotifier{
  StreamController<int> _stream = StreamController<int>();

  Timer timer;
  int second;
  disposeStream(){
    _stream.close();
  }

  Stream<int> get stream => _stream.stream;

  dispatch(AudioRecorderEvent event){
    if(event is StartRec){
      second = 0;
      _stream.add(second);
      notifyListeners();
      timer = Timer.periodic(Duration(seconds: 1),(val){
        _stream.add(++second);
        notifyListeners();
      });
    }else if(event is StopRec){
      timer.cancel();
    }
  }

}