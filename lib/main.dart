import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String Parameter = "";
  String routeName = "";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      //latest
      routes: <String, WidgetBuilder>{
        MyHomePage.routeName: (context) =>
            MyHomePage(title: "Flutter Uni Link Demo", currentRoute: routeName),
      },

      onGenerateRoute: (RouteSettings settings) {
        var page;
        routeName = settings.name;

        switch (routeName) {
          case DealPage.routeName:
            page = DealPage(
              settings.arguments,
            );
            return MaterialPageRoute(builder: (context) => page);
            break;
          case "/deal/":
            page = DealDetailPage(
              settings.arguments,
            );
            return MaterialPageRoute(builder: (context) => page);
            break;

          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('No path for ${settings.name}'),
                ),
              ),
            );
        }
      },

      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String routeName = "/";
  String currentRoute;

  MyHomePage({Key key, this.title, this.currentRoute}) : super(key: key);

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
      });
      //the link enter in broswer or select in app
      print('initial link: $initialLink');
    } on PlatformException {
      initialLink = 'Failed to get initial link.';

      // Handle exception by warning the user their action did not succeed

    }

    _sub = getLinksStream().listen((String link) {
      print("sub $_sub");
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    //when link is not null then check for parameter
    if (initialLink != null) checkParameter(initialLink);
  }

  checkParameter(String link) {
    //to get parameter like /123
    String parameter = "", page = "";
    var str = link.split('/');
    if (str.length == 4)
      page = str[3].trim();
    else if (str.length == 5) {
      parameter = str[4].trim();
      page = str[3].trim();
    }

    if (page == "deals" || page == "deal") {
      Navigator.of(context).pushNamed('/deal', arguments: parameter);
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
  static const String routeName = "/deal";

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

  //the function to go to detail page
  directDetailPage(String parameter) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushNamed('/deal/', arguments: parameter);
    });
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
            RaisedButton(
              onPressed: () => directDetailPage(widget.parameter),
              child: Text("Detail"),
            )
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
