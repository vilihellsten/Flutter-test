import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_test/firebase_options.dart';
import 'package:flutter_ui_test/views/todo_list_view.dart';
import 'package:provider/provider.dart';
import 'data/db_helper.dart';
import 'data/todo_list_manager.dart';
import 'views/camera/take_picture_sreen.dart';
import 'views/input_view.dart';
import 'views/mainview.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // lue

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  //await DatabaseHelper.instance.init(); //lue, tämä pois ja voitselaimella

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
        create: (context) {
          var model = TodoListManager(); // lue
          model.init();
          return model;
        },
        child: MyApp(camera: firstCamera)),
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    final providers = [EmailAuthProvider()];

    void onSignedIn(BuildContext context) {
      Navigator.pushReplacementNamed(context, '/todolist');
    }

    return MaterialApp(
      title: appTitle,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/todolist',
      routes: {
        '/main': (context) => MainView(),
        '/todolist': (context) => TodoListView(),
        "/input": (context) => InputView(),
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                // Put any new user logic here
                onSignedIn(context);
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                onSignedIn(context);
              }),
            ],
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
        "/camera": (context) {
          return TakePictureScreen(camera: camera);
        },
      },
    );
  }
}
