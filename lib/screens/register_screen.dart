import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_imaginemos_app/BLoC/auth/auth_service.dart';

import 'package:to_imaginemos_app/providers/login_form_provider.dart';


import 'package:to_imaginemos_app/ui/input_decorations.dart';
import 'package:to_imaginemos_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox( height: 10 ),
                    Text('Registrate', style: Theme.of(context).textTheme.headlineMedium ),
                    SizedBox( height: 30 ),
                    
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm()
                    )
                    

                  ],
                )
              ),

              SizedBox( height: 50 ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'), 
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all( Colors.indigo.withOpacity(0.1)),
                  shape: WidgetStateProperty.all( StadiumBorder() )
                ),
                child: Text('¿Ya tienes una cuenta?', style: TextStyle( fontSize: 18, color: Colors.black87 ),)
              ),
              SizedBox( height: 50 ),
            ],
          ),
        )
      )
   );
  }
}


class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    
      child: Column(
        children: [
          
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'contrata@aAndres.com ;)',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_rounded
            ),
            onChanged: ( value ) => loginForm.email = value,
            validator: ( value ) {
    
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);
                
                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no luce como un correo';
    
            },
          ),
    
          SizedBox( height: 30 ),
    
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '********',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline
            ),
            onChanged: ( value ) => loginForm.password = value,
            validator: ( value ) {
    
                return ( value != null && value.length >= 6 ) 
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';                                    
                
            },
          ),
    
          SizedBox( height: 30 ),
    
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading ? null : () async {
              
              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthService>(context, listen: false);
              
              if( !loginForm.isValidForm() ) return;
              loginForm.isLoading = true;
              final String? errorMessage = await authService.createUser(loginForm.email, loginForm.password);
              if ( errorMessage == null ) {
                Navigator.pushReplacementNamed(context, 'home');
              } else {
                //print( errorMessage );
                loginForm.isLoading = false;
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading 
                  ? 'Espere'
                  : 'Crear cuenta',
                style: TextStyle( color: Colors.white ),
              )
            )
          )
    
        ],
      ),
    );
  }
}