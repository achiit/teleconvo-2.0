import 'package:teleconvo/services/navigation_management.dart';
import 'package:teleconvo/widgets/Button_properties.dart';

import '../auth/registration_screen.dart';
import '../auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  _WelcomeScreenState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton("81d8a6a94161c11dc96a4d3ae70975d82e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handlecommand(command.data));
  }
  void _handlecommand( Map<String,dynamic> command){
    switch(command["command"]){
      case "take me to register page":
        Navigation.pushNamedAndReplace(context, RegistrationScreen.id);
        break;
      case "take me to login page":
        Navigation.pushNamedAndReplace(context, LoginScreen.id);
        break;
      default:
        debugPrint("Unknown Command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeleConvo'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset("assets/images/logo.png"),
                    ButtonProperties(
                      colour: Colors.lightBlueAccent,
                      label: 'Log In',
                      onpressed: (){
                        Navigation.pushNamedAndReplace(context, LoginScreen.id);
                      },
                    ),
                    ButtonProperties(
                        colour: Colors.blueAccent,
                        onpressed: (){
                          Navigation.pushNamedAndReplace(context, RegistrationScreen.id);
                        },
                        label: 'Register'
                    )
                  ]
              ),
            )
        )
    );
  }
}
