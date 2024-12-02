import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_imaginemos_app/screens/note_screen.dart';
import 'package:to_imaginemos_app/screens/screens.dart';
import 'package:to_imaginemos_app/services/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyAdhDn_2v5Yr4LfSrTeUNo_g6piS74vmH8', // apiKey del archivo google-services.json
    appId: '1:319211347055:android:025404d955d15bd182419a', // appId del archivo google-services.json
    messagingSenderId: '319211347055', // project_number (senderId) del archivo google-services.json
    projectId: 'toimaginemos', // projectId del archivo google-services.json
    storageBucket: 'toimaginemos.firebasestorage.app', // storageBucket del archivo google-services.json
  );

  // Inicializa Firebase usando las opciones proporcionadas
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()), // Proveedor para AuthService
        // Otros proveedores si los necesitas
      ],
      child: MyApp(),
    ),
  );
}

class AppState extends StatelessWidget {
  const AppState({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
        //ChangeNotifierProvider(create: ( _ ) => ProductsService() ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'home'    : ( _ ) => HomeScreen(),
        'login'   : ( _ ) => LoginScreen(),
        'register': ( _ ) => RegisterScreen(),
        'note'    : ( _ ) => NoteScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}