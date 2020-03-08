import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermagic8balldemo1/response_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic 8 Ball',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.blue,
      ),
      home: Magic8BallPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Magic8BallPage extends StatefulWidget {
  Magic8BallPage({Key key, this.title}) : super(key: key);

  final String title;
  static final String defaultMessage = "MAGIC 8 BALL";

  @override
  _Magic8BallPageState createState() => _Magic8BallPageState();
}

class _Magic8BallPageState extends State<Magic8BallPage> {
  String message;
  ResponseApi api;
  ShakeDetector detector;

  @override
  void initState() {
    api = ResponseApi();
    message = Magic8BallPage.defaultMessage;

    detector = ShakeDetector.autoStart(
        onPhoneShake: () {
          newMessage();
        },
        shakeThresholdGravity: 1.5);

    super.initState();
  }

  void newMessage() async {
    String newMessage = await api.fetchAnswer();
    setState(() {
      message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: OverflowBox(
            maxWidth: double.maxFinite,
            child: Material(
                type: MaterialType.circle,
                color: Colors.black,
                clipBehavior: Clip.antiAlias,
                elevation: 30,
                child: InkWell(
                    onTap: newMessage,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [Colors.white54, Colors.transparent],
                            stops: [0.05, 1],
                            radius: 0.75,
                            center: FractionalOffset(1/4, 1/4)
                          )
                        ),
                        child: SizedBox(
                          width: 500,
                          height: 500,
                        )))),
          ),
        ),
        IgnorePointer(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Text(message.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.iBMPlexMono(
                    textStyle: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(color: Colors.white))),
          )),
        )
      ],
    ));
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }
}
