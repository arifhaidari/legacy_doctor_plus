import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/pages/chat/stream/audioRecorder.dart';
import 'package:doctor_app/pages/medicalRecord.dart';
import 'package:doctor_app/pages/print/generateDocument.dart';
import 'package:doctor_app/res/string.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:file/local.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/model/chat/chat_list_model.dart';
import 'package:doctor_app/model/chat/chat_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/chatTextfield.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/color.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'full_screen_image.dart';

const String PUSHER_APP_ID = "903343";
const String PUSHER_APP_KEY = "4cb4028f2ae5f863e78e";
const String PUSHER_APP_SECRET = "9bb744943a590b29be92";
const String PUSHER_APP_CLUSTER = "ap2";

const String MESSAGE_CHAT_TYPE = 'text';
const String VOICE_CHAT_TYPE = 'voice';
const String FILE_CHAT_TYPE = 'file';

class chatScreen extends StatefulWidget {
  final int doctorId;
  // final String doctorId;
  final String doctorName;
  final int patientId;
  // final String patientId;
  final String title;

  const chatScreen({Key key, this.doctorId, this.doctorName, this.patientId, this.title})
      : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  ChatListModel chatListModel = ChatListModel.init();
  List<ChatModel> chats = [];

  bool loading = true;
  TextEditingController _controller = TextEditingController();

  PusherOptions options;
  Pusher pusher;
  Channel channel;
  PusherOptions pusherOptions;

  String channelName = 'my-channel';
  String eventName = 'my-event';

  int userId;
  // String userId;
  String doctorImageUrl;
  String userImageUrl;

  File sendFile;
  FlutterAudioRecorder recorder;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  ScrollController _scrollController = ScrollController();
  AudioRecorderStream _audioRecorderStream = AudioRecorderStream();

  Directory _externalDocumentsDirectory;
  Directory _appSupportDirectory;
  ChatModel responseModel;

  @override
  void initState() {
    super.initState();

    pusherInit();
    getAllPreviousMessages();
  }

  pusherInit() async {
    String tempString1 = await UserModel.getUserId;
    userId = int.parse(tempString1);
    options = PusherOptions(
      cluster: PUSHER_APP_CLUSTER,
    );
    pusher = await Pusher.init(PUSHER_APP_KEY, options);

    Pusher.connect(onConnectionStateChange: (ConnectionStateChange state) async {
      print(state.currentState);
      if (state.currentState == "CONNECTED") {
        channel = await Pusher.subscribe(channelName);

        channel.bind(eventName, (Event e) {
          print(e.event);
          print(e.data);

          if (jsonDecode(e.data) is Map) {
            ChatModel newChat = ChatModel.fromJson(jsonDecode(e.data));
            newChat.date = DateTime.now().toString().substring(0, 19);
            if (newChat.userId == userId &&
                newChat.pateintId == widget.patientId &&
                newChat.doctorId == widget.doctorId &&
                chats.firstWhere((chat) => chat.chatID == newChat.chatID, orElse: () => null) ==
                    null) chats.insert(0, newChat);
            if (mounted) setState(() {});

            print("Max ${_scrollController.position.maxScrollExtent}");
            print("Min ${_scrollController.position.minScrollExtent}");
            _scrollToBottom();
          }
        });
      }
    }, onError: (ConnectionError error) {
      print(error.message);
      if (!mounted) return;
      CustomSnackBar.SnackBar_3Error(_scaffoldKey,
          title: error.message, leadingIcon: Icons.error_outline);
    });
  }

  getAllPreviousMessages() async {
    String tempString = await UserModel.getUserId;
    userId = int.parse(tempString);

    g_inChatUIUserId = userId.toString();
    g_inChatUIPatientId = widget.patientId.toString();
    g_inChatUIDoctorId = widget.doctorId.toString();
    userImageUrl = USER_IMAGE_URL; //+ (await UserModel.getUserPic);
    var response = await API(showSnackbarForError: true, context: context, scaffold: _scaffoldKey)
        .post(url: GET_ALL_PREVIOUS_MESSAGES_URL, body: {
      'user_id': userId,
      'doctor_id': widget.doctorId,
      'pateint_id': widget.patientId,
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldKey, context, btnFun: getAllPreviousMessages);
      return;
    }

    setState(() {
      loading = false;
    });

    if (response is Response) {
      chats = [];
      if (response.data is List)
        response.data.forEach((json) {
          chats.add(ChatModel.fromJson(json));
        });
//        chatListModel.updateFromJson(response.data);

      if (mounted) setState(() {});
//

//        print("Max ${_scrollController.position.maxScrollExtent}");
//        print("Min ${_scrollController.position.minScrollExtent}");
      _scrollToBottom();
    }
  }

  _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 600), () {
//      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _scrollController.jumpTo(0);
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    g_inChatUIPatientId = null;
    g_inChatUIUserId = null;
    g_inChatUIDoctorId = null;
    channel?.unbind(eventName);
    Pusher?.unsubscribe(channelName);
    Pusher?.disconnect();
    audioPlayer?.dispose();
    recorder?.stop();
    _audioRecorderStream?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffE5DDD5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          hight: size1.longestSide * 0.15666178,
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          leadingIcon: _leading(),
//          trailingIcon: _trailing(),
          centerWigets: _logo(),
        ),
      ),
      body: loading
          ? Center(
              child: Loading(),
            )
          : _body(),
    );
  }

  _body() {
    String date;
    String prevoiusDate;
    chats.forEach((chat) {
      int index = chats.indexOf(chat);
      chat.showDateBelow = false;
      chat.showDateAbove = false;

      if (index == chats.length - 1) {
        chat.showDateAbove = true;
        chat.displayDate = chat.date;
        print("Above ${chat.date}");
      } else {
        if (date == null) {
          print(">>>Date is null $index");
          date = chat?.date?.substring(0, 10);
          prevoiusDate = chat?.date?.substring(0, 10);
        } else {
          date = chat?.date?.substring(0, 10);
        }

        if (date != prevoiusDate) {
          print("Below $date $prevoiusDate");
          chat.displayDate = prevoiusDate;

          /// THIS IS MOST IMPORTANT WE ARE CHANGING THE DATE SO BE CAREFUL
          prevoiusDate = date;
          chat.showDateBelow = true;
        }
      }

      print("Index $index ${chat.showDateAbove} ${chat.showDateBelow} ${chat.date}");
    });
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: size.convert(context, 60)),
            child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                reverse: true,
                itemCount: chats?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  ChatModel chatMessage = chats[index];
                  // bool isDateAbove = true;
                  // bool isDateBelow = true;
                  // if (date == null) date = chatMessage?.date?.substring(0, 10);

                  // isDateBelow = date == chatMessage?.date?.substring(0, 10);

                  // if (index == chats.length - 1) isDateAbove = false;
                  // if (isDateBelow)
                  //   prevoiusDate = chatMessage?.date?.substring(0, 10);
                  // date = chatMessage?.date?.substring(0, 10);
                  if (chatMessage.whoSend == "user") {
                    return Column(
                      children: <Widget>[
                        _date(
                            chatMessage?.displayDate?.substring(0, 10), chatMessage.showDateAbove),
                        _message(chatMessage, false),
                        _date(
                            chatMessage?.displayDate?.substring(0, 10), chatMessage.showDateBelow),
                      ],
                    );
                  } else if (chatMessage.whoSend == "doctor") {
                    return Column(
                      children: <Widget>[
                        _date(
                            chatMessage?.displayDate?.substring(0, 10), chatMessage.showDateAbove),
                        _message(chatMessage, true),
                        _date(
                            chatMessage?.displayDate?.substring(0, 10), chatMessage.showDateBelow),
                      ],
                    );
                  } else
                    return Container();
                })),
        bottomWidget(),
      ],
    );
  }

  Widget _date(String date, bool condition) {
    return condition
        ? Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFE0F1FA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  )
                ],
                borderRadius: BorderRadius.circular(200),
              ),
              child: Text(
                date != null ? DateFormat.yMMMd().format(DateTime.parse(date)) : "",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "LatoRegular",
                  fontSize: size.convert(context, 14),
                ),
              ),
            ),
          )
        : SizedBox();
  }

  _logo() {
    return Container(
      padding: EdgeInsets.only(bottom: size.convert(context, 5)),
      child: Text(
        "${widget.title ?? ""} ${widget.doctorName ?? ""}",
        style: TextStyle(
            fontFamily: "LatoRegular", fontSize: size.convert(context, 14), color: appBarIconColor),
      ),
    );
  }

  _trailing() {
    return Container(
        padding: EdgeInsets.only(bottom: size.convert(context, 5)),
        child: InkWell(
          onTap: detailPad,
          child: Transform.rotate(
            angle: 180 * math.pi / 165,
            child: Icon(
              IcoFontIcons.uiCall,
              color: appBarIconColor,
            ),
          ),
//          child: Image.asset(
//            "assets/icons/phone.png",
//            color: appBarIconColor,
//          ),
        ));
  }

  _leading() {
    return Container(
      padding: EdgeInsets.only(bottom: size.convert(context, 5)),
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop();
          print("pop call");
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  String convertSecondToMinSec(int second) {
    int hours = second ~/ 3600;
    int remainder = second - hours * 3600;
    int mins = remainder ~/ 60;
    remainder = remainder - mins * 60;
    int secs = remainder;

    return "${"$mins".padLeft(2, '0')}:${"$secs".padLeft(2, '0')}";
  }

  bottomWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        //padding: EdgeInsets.symmetric(horizontal: size.convert(context, 13)),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: size.convert(context, 10), horizontal: size.convertWidth(context, 10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder<int>(
                  stream: _audioRecorderStream.stream,
                  builder: (context, snapshot) {
                    if (_currentStatus == RecordingStatus.Unset)
                      return GestureDetector(
                        onTap: () => _settingModalBottomSheet(),
                        child: sendFile != null
                            ? _fileWidget()
                            : SvgPicture.asset(
                                "assets/icons/Group_1851.svg",
                                width: size.convert(context, 28),
                                height: size.convert(context, 28),
                              ),
                      );
                    if (!snapshot.hasData) return SizedBox();

                    if (snapshot.data is int) return Text(convertSecondToMinSec(snapshot.data));
                    return SizedBox();
                  }),
//              SizedBox(
//                width: size.convert(context, 10),
//              ),
              _currentStatus == RecordingStatus.Unset
                  ? GestureDetector(
                      onTap: _startAudioRecorder,
                      child: SvgPicture.asset(
                        "assets/icons/mic.svg",
//           width: size.convert(context, 24),
                        height: size.convert(context, 22),
                      ),
                    )
                  : GestureDetector(
                      onTap: _stopAudioRecorder,
                      child: Icon(
                        Icons.stop,
                        color: buttonColor,
                        size: 24,
                      ),
                    ),
//              SizedBox(
//                width: size.convert(context, 10),
//              ),
              chatTextfield(
                w: MediaQuery.of(context).orientation == Orientation.landscape
                    ? size.convertWidth(context, 330)
                    : size.convertWidth(context, 260),
                h: size.convert(context, 40),
                hints: "Type a message...",
                controller: _controller,
                onSubmit: (val) {},
              ),
              InkWell(
                onTap: () {
                  if (_currentStatus == RecordingStatus.Unset) {
                    if (sendFile == null && _controller.text.trim() == "") {
                      return;
                    }
                    ChatModel chat = ChatModel();
                    chat.message = _controller.text;
                    chat.systemFile = sendFile;

                    chat.userId = userId;
                    chat.doctorId = widget.doctorId;
                    chat.pateintId = widget.patientId;
                    chat.from = userId;
                    chat.whoSend = "user";
                    chat.to = widget.doctorId;
                    chat.date = DateTime.now().toString();
                    chats.insert(0, chat);

                    setState(() {
                      chat.loading = true;
                      chat.failed = false;
                    });

                    _scrollToBottom();
                    if (sendFile == null) {
                      chat.type = MESSAGE_CHAT_TYPE;
                      if (chat.message.trim() != "") sendMessageToServer(chat);
                    } else {
                      chat.type = FILE_CHAT_TYPE;
                      sendFileToServer(chat);
                    }

                    _controller.text = "";
                    sendFile = null;
                  } else {
                    _stopAudioRecorderAndSendItToServer();
                  }
                },
                child: Icon(
                  Icons.send,
                  color: buttonColor,
                  size: 34,
                ),
              ),
//              Container(
//                //padding: EdgeInsets.only(bottom: 20),
//                child: IconButton(
//                  onPressed: ()
//                  {
//                    ChatModel chat = ChatModel();
//                    chat.message = _controller.text;
//                    chat.systemFile = sendFile;
//
//                    chat.userId = userId;
//                    chat.doctorId = widget.doctorId;
//                    chat.from = userId;
//                    chat.to = widget.doctorId;
//                    chats.insert(0,chat);
//
//                    setState(() {
//                      chat.loading = true;
//                      chat.failed = false;
//                    });
//
//                    _scrollToBottom();
//                    if (sendFile == null) {
//                      chat.type = MESSAGE_CHAT_TYPE;
//                      sendMessageToServer(chat);
//                    } else {
//                      chat.type = FILE_CHAT_TYPE;
//                      sendFileToServer(chat);
//                    }
//
//                    _controller.text = "";
//                    sendFile = null;
//                  },
//                  icon: Icon(
//                    Icons.send,
//                    color: buttonColor,
//                    size: size.convertWidth(context, 30),
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fileWidget() {
    int fileBelongTo = checkDoc(sendFile.path);

    return SizedBox(
      width: size.convert(context, 28),
      height: size.convert(context, 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: fileBelongTo == DOC_IS_IMAGE
            ? Image.file(
                sendFile,
                fit: BoxFit.cover,
                semanticLabel: "Image",
              )
            : Image.asset(
                assetForDoc(fileBelongTo),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  _message(ChatModel chat, bool received) {
    return GestureDetector(
      onLongPress: received
          ? null
          : () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: size.convert(context, size.convert(context, 157)),
                        width: size.convertWidth(context, 334),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: size.convert(context, 26),
                            ),
                            Text(
                              "Delete Message!",
                              style: TextStyle(
                                fontSize: size.convert(context, 14),
                                fontFamily: "LatoBold",
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: size.convert(context, 18),
                            ),
                            Text(
                              "Are you sure to delete this message?",
                              style: TextStyle(
                                color: portionColor,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                            ),
                            SizedBox(
                              height: size.convert(context, 24),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        getIt<GlobalSingleton>().navigationKey.currentState.pop();
                                        deleteChatMessage(chat);
                                      },
                                      child: Container(
                                        width: size.convertWidth(context, 87),
                                        height: size.convert(context, 35),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(size.convert(context, 5)),
                                            border: Border.all(width: 1, color: buttonColor)),
                                        child: Center(
                                          child: Text(
                                            TranslationBase.of(context).yes,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: size.convert(context, 12),
                                              fontFamily: "LatoRegular",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.convertWidth(context, 26),
                                  ),
                                  Container(
                                    child: InkWell(
                                      onTap: () {
                                        getIt<GlobalSingleton>().navigationKey.currentState.pop();
                                      },
                                      child: Container(
                                        width: size.convertWidth(context, 87),
                                        height: size.convert(context, 35),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(size.convert(context, 5)),
                                            border: Border.all(width: 1, color: buttonColor)),
                                        child: Center(
                                          child: Text(
                                            TranslationBase.of(context).no,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: size.convert(context, 12),
                                              fontFamily: "LatoRegular",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
      child: Row(
        mainAxisAlignment: received ? MainAxisAlignment.start : MainAxisAlignment.end,

        /// for change screen these properties need to change
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10), vertical: 2),
            padding: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
                color: received ? Colors.white : Color(0xffDCF8C6),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  )
                ]),
            child: Container(
              padding: const EdgeInsets.only(bottom: 3),
              constraints: BoxConstraints(minWidth: 50, maxWidth: size.convert(context, 275)),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 15),
                    child: chat.type == MESSAGE_CHAT_TYPE
                        ? Text(
                            chat?.message ?? "",
                            style: TextStyle(
                                fontSize: size.convert(context, 16),
                                fontFamily: "LatoRegular",
                                color: Colors.black),
                          )
                        : chat.type == FILE_CHAT_TYPE
                            ? _serverFile(chat)
                            : chat.type == VOICE_CHAT_TYPE
                                ? chat.isVoicePlay == -1
                                    ? IconButton(
                                        onPressed: () {
                                          _playAudio(chat);
                                        },
                                        icon: Icon(Icons.play_circle_outline),
                                      )
                                    : chat.isVoicePlay == 0
                                        ? SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: FittedBox(child: Loading()),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  _stopAudio(chat);
                                                },
                                                icon: Icon(Icons.stop),
                                              ),
                                              Container(
                                                width: 15,
                                                height: 1,
                                                color: portionColor,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              StreamBuilder(
                                                  stream: audioPlayer.onAudioPositionChanged,
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData)
                                                      return SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Loading(),
                                                        ),
                                                      );
                                                    var duration = snapshot.data;
                                                    if (duration is Duration) {
                                                      int second = duration.inSeconds;
                                                      return Text(convertSecondToMinSec(second));
                                                    }
                                                    return SizedBox();
                                                  })
                                            ],
                                          )
                                : Text("This type is not supported"),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: chat.deleteFailed
                        ? IconButton(
                            onPressed: () {
                              deleteChatMessage(chat);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.red[700],
                              size: 24,
                            ),
                          )
                        : chat.failed
                            ? IconButton(
                                onPressed: () {
                                  resendChat(chat);
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.red[700],
                                  size: 24,
                                ),
                              )
                            : chat.loading
                                ? Container(
                                    height: size.convert(context, 15),
                                    width: size.convert(context, 15),
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent, shape: BoxShape.circle),
                                    child: FittedBox(
                                      child: Loading(),
                                    ))
                                : chat?.date == null
                                    ? SizedBox()
                                    : Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        //margin: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "${DateFormat('HH:mm').format(DateTime.parse(chat.date))}",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontFamily: "LatoRegular"),
                                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serverFile(ChatModel chat) {
    int fileBelongTo = checkDoc(chat?.file ?? "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        fileBelongTo == DOC_IS_IMAGE
            ? GestureDetector(
                onTap: () {
                  getIt<GlobalSingleton>().navigationKey.currentState.push(MaterialPageRoute(
                      builder: (context) => FullScreenImage(url: CHAT_FILE_URL + chat.file)));
                },
                child: Container(
                  width: size.convert(context, 260),
                  height: size.convert(context, 200),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      CHAT_FILE_URL + chat.file,
                      semanticLabel: "Image",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _printDoc(chat);
                },
                child: Container(
                  width: size.convert(context, 100),
                  height: size.convert(context, 100),
                  child: Image.asset(
                    assetForDoc(fileBelongTo),
                  ),
                ),
              ),
        SizedBox(
          height: 5,
        ),
        Text(
          chat?.message ?? "",
          style: TextStyle(
              fontSize: size.convert(context, 16), fontFamily: "LatoRegular", color: Colors.black),
        )
      ],
    );
  }

  _printDoc(ChatModel model) async {
    print("Print call");
    int fileBelongTo = checkDoc(model.file);
    String documentUrl = CHAT_FILE_URL + model.file;

    if (fileBelongTo == DOC_IS_IMAGE)
      try {
        final bool result = await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async =>
                (await generateDocumentImage(PdfPageFormat.a4, documentUrl)).save());
      } catch (e) {
        print(e);
        CustomSnackBar.SnackBar_3Error(_scaffoldKey,
            title: "Error $e", leadingIcon: Icons.error_outline);
      }
    else if (fileBelongTo == DOC_IS_PDF || fileBelongTo == DOC_IS_DOC) {
      var knockDir;
      try {
        if (Platform.isIOS) {
          print("IOS");
          await _requestAppSupportDirectory();
          knockDir = await new Directory('${_appSupportDirectory.path}/doctorapp')
              .create(recursive: true)
              .catchError((err) {
            print(err);
          });
          print(knockDir);
//          File file = new File('${knockDir.path}/file.pdf');
//          print(file);
//          var raf = file.openSync(mode: FileMode.write);
//          print("raf ${raf.path}");
//          raf.writeFromSync(dta);
//          if (raf.toString().isNotEmpty) {
//            showSubmitRequestSnackBar(
//                context, "File Saved Successfully", raf.path, file);
//          } else {}
//          await raf.close();
//           await raf1.close();
        } else {
          await _requestExternalStorageDirectory();
          knockDir = await new Directory('${_externalDocumentsDirectory.path}/doctorapp')
              .create(recursive: true)
              .catchError((err) {
            print(err);
          });
          print(knockDir);
          PermissionStatus permissionResult =
              await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

          if (permissionResult == PermissionStatus.granted) {
//              File file = new File('${knockDir.path}/$fname');
//              print(file);
//              var raf = file.openSync(mode: FileMode.write);
//              print("raf ${raf.path}");
//              raf.writeFromSync(dta);
//              if (raf.toString().isNotEmpty) {
//                await OpenFile.open(raf.path).catchError((err) {
//                  print(err);
//                });
//              } else {
//              }
//              await raf.close();

          } else {
            await _getPermission();
            _printDoc(model);
          }
        }
//        String extension = model.documents[0].substring(model.documents[0].lastIndexOf('.') + 1).toLowerCase();

        Response response = await Dio().download(documentUrl, '${knockDir.path}/file.pdf');

        print(response.statusCode);
        if (response.statusCode == 200) {
          File pdf = File('${knockDir.path}/file.pdf');
          final bool result = await Printing.layoutPdf(onLayout: (_) => pdf.readAsBytesSync());
        }
      } catch (e) {
        print(e);
        CustomSnackBar.SnackBar_3Error(_scaffoldKey,
            title: "Error $e", leadingIcon: Icons.error_outline);
      }
    }
  }

  _getPermission() async {
    return await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  _requestAppSupportDirectory() async {
    _appSupportDirectory = await getApplicationSupportDirectory();
    print(_appSupportDirectory.path);
  }

  _requestExternalStorageDirectory() async {
    _externalDocumentsDirectory = await getExternalStorageDirectory();
    print(_externalDocumentsDirectory.path);
  }

  resendChat(ChatModel chat) {
    if (chat.type == MESSAGE_CHAT_TYPE) {
      sendMessageToServer(chat);
    } else if (chat.type == FILE_CHAT_TYPE)
      sendFileToServer(chat);
    else if (chat.type == VOICE_CHAT_TYPE) sendAudioToServer(chat);
  }

  sendMessageToServer(ChatModel chat) async {
    if (chat.message == null) {
      return;
    }
    setState(() {
      chat.loading = true;
      chat.failed = false;
    });

    Map body = {
      'user_id': userId,
      'doctor_id': widget.doctorId,
      'message': chat.message,
      'pateint_id': widget.patientId,
    };
    print(body.toString());

    var response = await API(showSnackbarForError: false, context: context, scaffold: _scaffoldKey)
        .post(url: SEND_MESSAGE_URL, body: body);

    setState(() {
      chat.loading = false;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        chat.failed = true;
      });
      return;
    }

    if (response is Response) {
      responseModel = null;
      responseModel = ChatModel.fromJson(response.data);
      getAllPreviousMessages();
      chat.chatID = responseModel.chatID;
      if (chats.firstWhere((cht) => cht.chatID == chat.chatID, orElse: () => null) == null) {
      } else {
        chats.remove(chat);
      }
      setState(() {
        chat.failed = false;
        chat.date = responseModel.date;
      });
    } else {
      setState(() {
        chat.failed = true;
      });
    }
  }

  deleteChatMessage(ChatModel chat) async {
    setState(() {
      chat.loading = true;
      chat.deleteFailed = false;
    });

    var response = await API(showSnackbarForError: false, context: context, scaffold: _scaffoldKey)
        .get(url: DELETE_CHAT_URL + chat.chatID.toString());

    setState(() {
      chat.loading = false;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        chat.deleteFailed = true;
      });
      return;
    }

    if (response is Response) {
      chats.removeWhere((cht) => cht.chatID == chat.chatID);
    } else {
      setState(() {
        chat.deleteFailed = true;
      });
    }
  }

  sendFileToServer(ChatModel chat) async {
    if (chat.systemFile == null) {
      return;
    }
//    ChatModel chat = ChatModel(message: caption,systemFile: file);
    setState(() {
      chat.loading = true;
      chat.failed = false;
    });

    FormData form = FormData.fromMap({
      'user_id': userId,
      'doctor_id': widget.doctorId,
      'pateint_id': widget.patientId,
      'file': await MultipartFile.fromFile(chat.systemFile.path),
      'caption': chat.message
    });

    var response = await API(
            showSnackbarForError: false,
            context: context,
            uploadProgressCallback: (val) {
              setState(() {
                chat.uploadProgressValue = val;
              });
            },
            scaffold: _scaffoldKey)
        .post(url: SEND_FILE_URL, body: form);

    setState(() {
      chat.loading = false;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        chat.failed = true;
      });
      return;
    }

    if (response is Response) {
      ChatModel responseModel = ChatModel.fromJson(response.data);
      getAllPreviousMessages();
      chat.chatID = responseModel.chatID;
      chat.file = responseModel.file;
      if (chats.firstWhere((cht) => cht.chatID == chat.chatID, orElse: () => null) == null) {
      } else {
        chats.remove(chat);
      }
      setState(() {
        chat.failed = false;
      });
    } else {
      setState(() {
        chat.failed = true;
      });
    }
  }

  sendAudioToServer(ChatModel chat) async {
    if (chat.systemFile == null) {
      return;
    }
//    ChatModel chat = ChatModel(message: caption,systemFile: file);

    setState(() {
      chats.insert(0, chat);
      chat.loading = true;
      chat.failed = false;
    });

    _scrollToBottom();

    print("Sending audio to server");

    FormData form = FormData.fromMap({
      'user_id': userId,
      'doctor_id': widget.doctorId,
      'pateint_id': widget.patientId,
      'voice': await MultipartFile.fromFile(chat.systemFile.path)
    });

    var response = await API(
            showSnackbarForError: false,
            context: context,
            uploadProgressCallback: (val) {
              setState(() {
                chat.uploadProgressValue = val;
              });
            },
            scaffold: _scaffoldKey)
        .post(url: SEND_VOICE_URL, body: form);

    setState(() {
      chat.loading = false;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        chat.failed = true;
      });
      return;
    }

    if (response is Response) {
      ChatModel responseModel = ChatModel.fromJson(response.data);
      getAllPreviousMessages();
      chat.chatID = responseModel.chatID;
      chat.voice = responseModel.voice;
      if (chats.firstWhere((cht) => cht.chatID == chat.chatID, orElse: () => null) == null) {
      } else {
        chats.remove(chat);
      }
      setState(() {
        chat.failed = false;
      });
    } else {
      setState(() {
        chat.failed = true;
      });
    }
  }

  Future<void> _startAudioRecorder() async {
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      String customPath = '/Doctor_App_Audio';
      Directory appDocDirectory;
      if (Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = await getExternalStorageDirectory();
      }
      customPath =
          appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

      recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.AAC);
      await recorder.initialized;
      await recorder.start();

      var current = await recorder.current(channel: 0);

      _audioRecorderStream.dispatch(StartRec());

      setState(() {
        _currentStatus = current.status;
      });
    }
  }

  Future<void> _stopAudioRecorder() async {
    await recorder.stop();
    _audioRecorderStream.dispatch(StopRec());
    setState(() {
      _currentStatus = RecordingStatus.Unset;
    });
  }

  Future<void> _stopAudioRecorderAndSendItToServer() async {
    Recording recording = await recorder.stop();
    _audioRecorderStream.dispatch(StopRec());
    File file = LocalFileSystem().file(recording.path);
    setState(() {
      _currentStatus = RecordingStatus.Unset;
    });

    ChatModel chat = ChatModel();
    chat.type = VOICE_CHAT_TYPE;
    chat.systemFile = file;
    chat.userId = userId;
    chat.doctorId = widget.doctorId;
    chat.pateintId = widget.patientId;
    chat.from = userId;
    chat.to = widget.doctorId;
    chat.whoSend = "user";
    sendAudioToServer(chat);
  }

  AudioPlayer audioPlayer;

  ///Audio play
  _playAudio(ChatModel chat) async {
    print("Audio player ${chat.voice} ${chat.isVoicePlay}");

    chats.forEach((val) {
      val.isVoicePlay = -1;
    });
    try {
      await audioPlayer?.stop();
    } catch (e) {
      print(e);
    }
    await audioPlayer?.dispose();
    setState(() {});
    if (chat.voice != null && chat.isVoicePlay == -1) {
      print("********Stating");
//      audioPlayer.onDurationChanged.listen(onData);
//      audioPlayer.getDuration();
      audioPlayer = AudioPlayer();
//      audioPlayer.onNotificationPlayerStateChanged
//          .listen((AudioPlayerState state) {
//        print("********State Changed $state");
//
//
//        if (state == AudioPlayerState.COMPLETED) {
//          setState(() {
//            chat.isVoicePlay = false;
//            audioPlayer.dispose();
//          });
//        }
//      });

      audioPlayer.onPlayerStateChanged.listen((state) {
        print("**********Audio player $state");
        if (state == AudioPlayerState.PLAYING) {
          chat.isVoicePlay = 1;
        }
        if (state == AudioPlayerState.COMPLETED) {
          setState(() {
            chat.isVoicePlay = -1;
            audioPlayer.dispose();
          });
        }
      });

      await audioPlayer.play(
        CHAT_VOICE_URL + chat.voice,
        isLocal: false,
      );
      setState(() {
        chat.isVoicePlay = 0;
      });
    }
  }

  _stopAudio(ChatModel chat) async {
    if (chat.isVoicePlay != -1) {
      await audioPlayer.stop();
      audioPlayer.dispose();
      setState(() {
        chat.isVoicePlay = -1;
      });
    }
  }

  _settingModalBottomSheet() {
    print("Bottom sheet");
    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            horizontal: size.convert(context, 22), vertical: size.convert(context, 16)),
        height: size.convert(context, 170),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Add File",
                      style: TextStyle(
                          fontSize: size.convert(context, 10),
                          fontFamily: "LatoRegular",
                          color: portionColor),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        getIt<GlobalSingleton>().navigationKey.currentState.pop(context),
                    icon: Icon(Icons.clear),
                    iconSize: size.convert(context, 20),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Take a Photo");
                _onImageButtonPressed(ImageSource.camera);
                getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: size.convert(context, 10)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: SvgPicture.asset(
                        "assets/icons/image.svg",
                        color: buttonColor,
                        height: size.convert(context, 15),
                        width: size.convert(context, 14),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: size.convert(context, 12),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          TranslationBase.of(context).takeAPhoto,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Upload from gallery");
                getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                _onImageButtonPressed(ImageSource.gallery);
              },
              child: Container(
                margin: EdgeInsets.only(top: size.convert(context, 10)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: SvgPicture.asset(
                        "assets/icons/file-alt.svg",
                        color: buttonColor,
                        height: size.convert(context, 15),
                        width: size.convert(context, 14),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: size.convert(context, 12),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          TranslationBase.of(context).uploadFromGallery,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Upload file");
                getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
                _uploadfile();
              },
              child: Container(
                margin: EdgeInsets.only(top: size.convert(context, 10)),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: SvgPicture.asset(
                        "assets/icons/ui-image.svg",
                        color: buttonColor,
                        height: size.convert(context, 15),
                        width: size.convert(context, 14),
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: size.convert(context, 12),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          TranslationBase.of(context).uploadFiles,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "LatoRegular",
                            fontSize: size.convert(context, 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _onImageButtonPressed(ImageSource sourceFile) async {
    print("Some thing happen");
    try {
      File imageFile1 = await ImagePicker.pickImage(
        source: sourceFile,
      );

      setState(() {
        sendFile = imageFile1;
      });
    } catch (e) {
      print("Error " + e.toString());
    }
  }

  _uploadfile() async {
    try {
      File _file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ["pdf"]);

      String extension = _file.path.substring(_file.path.lastIndexOf(".") + 1);

      print("File Extensin $extension");
      if (!(wordExtension.contains(extension) || extension == pdfExtension)) {
        CustomSnackBar.SnackBar_3Error(_scaffoldKey,
            title: "Only PDF, DOC, DOCX files are suppoerted", leadingIcon: Icons.error_outline);
        return;
      }

      setState(() {
        sendFile = _file;
      });
    } catch (e) {
      print("File Upload Error " + e.toString());
    }
  }
}
