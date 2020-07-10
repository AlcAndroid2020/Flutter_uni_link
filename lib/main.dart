import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String Parameter="";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String,WidgetBuilder>{
        '/':(BuildContext context)=>MyHomePage(title: 'Flutter Uni Link Demo'),
        '/Deal':(BuildContext context)=>DealPage(''),
        '/Detail':(BuildContext context)=>DealDetailPage(''),


      },
onGenerateRoute: (RouteSettings settings){

      final List<String> pathElements = settings.name.split('/');
      if (pathElements[0] != '') {
        return null;
      }
      if (pathElements[1] == 'Detail') {
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => DealDetailPage(pathElements[2]),
        );
      }
      return null;
    },

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String initialLink, linktext;
  StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    initUniLinks();
  }

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      setState(() {
        linktext = initialLink;

        // if(initialLink!=null)
        // checkParameter(initialLink);
      });

      print('initial link: $initialLink');

      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      initialLink = 'Failed to get initial link.';

      // Handle exception by warning the user their action did not succeed
      // return?
    }

    _sub = getLinksStream().listen((String link) {
      print("sub $_sub");

      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

   if (initialLink != null) checkParameter(initialLink);
  }

  checkParameter(String link) {
    String parameter = "", page = "";
    var str = link.split('/');
    if (str.length == 4) page = str[3].trim();
    else  if (str.length == 5)
    {parameter = str[4].trim();
      page = str[3].trim();
    }

    if (page == "deals"||page=="deal") {


  //    Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => DealPage(parameter)));

   Navigator.of(context).pushNamed('/Deal');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You come from $initialLink',
            ),
            RaisedButton(
              child: Text("Deals"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DealPage("")));


              },
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DealPage extends StatefulWidget {
  String parameter;

  DealPage(this.parameter);

  @override
  _DealPageState createState() => _DealPageState();
}

class _DealPageState extends State<DealPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.parameter != "") directDetailPage(widget.parameter);
  }

  directDetailPage(String parameter) {

 //Navigator.of(context).push(MaterialPageRoute(
   // builder: (BuildContext context) => DealDetailPage(parameter)));
    Navigator.of(context).pushNamed('/Detail/$parameter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deal Page"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            Text("Deal page"),
          ],
        ),
      ),
    );
  }
}

class DealDetailPage extends StatefulWidget {
  String parameter;

  DealDetailPage(this.parameter);

  @override
  _DealDetailPageState createState() => _DealDetailPageState();
}

class _DealDetailPageState extends State<DealDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deal Detail Page"),

      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Deal ${widget.parameter}"),
          ],
        ),
      ),
    );
  }
}
