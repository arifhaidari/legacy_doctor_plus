import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:get_it/get_it.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

GetIt getIt = GetIt.instance;

setupGetIt() {
  getIt.registerSingleton<GlobalSingleton>(GlobalSingleton());
  getIt.registerSingleton<GlobalProvider>(GlobalProvider.init());
}

Future<void> detailPad() async {
  String command = "tel:0093784999906";
  // launch(command);
  print('inside the detailPad');
  if (await urlLauncher.canLaunch(command)) {
    print("url launch $command");
    await urlLauncher.launch(command);
  } else {
    print(' could not launch $command');
  }
}
