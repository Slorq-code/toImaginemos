import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_imaginemos_app/BLoC/auth/auth_bloc.dart';
import 'package:to_imaginemos_app/screens/note_screen.dart';
import 'package:to_imaginemos_app/screens/screens.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();




FirebaseOptions firebaseOptions = FirebaseOptions(
  
  // Clave API para autenticar las solicitudes del cliente a Firebase.
  apiKey: 'AIzaSyAdhDn_2v5Yr4LfSrTeUNo_g6piS74vmH8',
  
  // Identificador único de la aplicación en Firebase, específico para la plataforma Android.
  appId: '1:319211347055:android:025404d955d15bd182419a',
  
  // Identificador del remitente utilizado para enviar mensajes de Firebase Cloud Messaging (FCM).
  messagingSenderId: '319211347055',
  
  // Identificador único del proyecto de Firebase, utilizado para vincular la aplicación con el proyecto.
  projectId: 'toimaginemos',
  
  // URL del bucket de almacenamiento de Firebase, utilizado para almacenar archivos y datos de la aplicación.
  storageBucket: 'toimaginemos.firebasestorage.app',
);






  await Firebase.initializeApp(options: firebaseOptions);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
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