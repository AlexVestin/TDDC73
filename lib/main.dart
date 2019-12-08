import 'package:flutter/material.dart';
import 'package:flutter_app/Repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_format/date_format.dart';

// https://medium.com/@alfianlosari/building-github-flutter-app-part-1-trending-repositories-list-f48683ac9bef
// https://flutter.dev/docs/cookbook/networking/fetch-data
// https://medium.com/nonstopio/flutter-future-builder-with-list-view-builder-d7212314e8c9

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Github trending stuff'),
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
  Future<List<Repo>> repos;
  Repo selectedRep;
  int pageIndex = 0;
  String selectedLanguage = "all";
  bool fetching = false;


  Future<String> license;
  Future<String> nrBranches;
  Future<String> nrCommits;



  Future<String> fetchNrBranches() async {

    final url = Uri.https('api.github.com', 'repos/${selectedRep.userName}/${selectedRep.title}/branches', {
      'per_page': "1"
    });
    final response = await http.get(url);

    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // https://stackoverflow.com/questions/33242631/github-api-get-the-number-of-branches-of-a-repo-without-listing-all-its-branch
      //List sp = response.headers["Link"].split("page=");
      //print(sp[sp.length - 1].split("<"));
      if(!response.headers.containsKey("Link")) {
        return "1";
      }

      //print(response.headers["Link"]);
      return "more than one branch";
    } else {
      return "not null but still error";
    }
  }

  Future<String> fetchLicense() async {

    final url = Uri.https('api.github.com', 'repos/${selectedRep.userName}/${selectedRep.title}/license');
    final response = await http.get(url);

    print("status?");
    print(response.statusCode);

    if (response.statusCode == 200) {
      return json.decode(response.body)["license"]["name"];
    } else {
      return "No license found";
    }
  }


  Future<String> fetchNrCommits() async {
    final url = Uri.https('api.github.com', '/repos/${selectedRep.userName}/${selectedRep.title}/stats/contributors');
    final response = await http.get(url);

    print(response.statusCode);
    if (response.statusCode == 200) {
      int total = 0;
      List contributors =json.decode(response.body);
      for(int i = 0; i < contributors.length; i++) {
        total += contributors[i]["total"] + 1;
      }

      return total.toString();
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<Repo>> fetchRepos() async {
    fetching = true;
    final lastWeek = DateTime.now().subtract(Duration(days: 7));
    final formatted = formatDate(lastWeek, [yyyy, '-', mm, '-', dd]);

    final String lang = selectedLanguage == "all" ? "" : "language:$selectedLanguage";

    final url = Uri.https('api.github.com', '/search/repositories', {
      'q': 'created:>$formatted $lang',
      'language': 'python',
      'order': 'desc',
      'page': '0',
      'per_page': '25',
      'sort': 'stars'
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body);
      fetching = false;
      return Repo.fromJson(jsonRes["items"]);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    repos = fetchRepos();
  }

  @override
  Widget build(BuildContext context) {
    String selectedTitle = (selectedRep != null) ? selectedRep.title : "";
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomSheet: (
          FlatButton (
          child:  DropdownButton<String>(
            hint: Text("language"),
            value: selectedLanguage,
            onChanged: (String value) {
              setState(() {

                selectedLanguage = value;
                repos = fetchRepos();
              });
            },
            items: <String>["all", "python", "php", "javascript", "C", "rust"]
                .map<DropdownMenuItem<String>>((String value) {
              return (DropdownMenuItem<String>(
                  value: value, child: Text("$value")));
            }).toList(),
          )
        )

        ),

        body: Container(
            child: (pageIndex == 0)
                ? Column(
                    children: <Widget>[

                      Expanded(
                          child:
                        FutureBuilder<List<Repo>>(
                          future: repos,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && !fetching) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (listContext, index) {
                                  Repo repo = snapshot.data[index];
                                  String stars = repo.stars.toString();

                                  String forks = repo.forks.toString();


                                  String description = repo.description != null ? repo.description : "No description provided";



                                  return GestureDetector(
                                      onTap: () => setState(() {
                                            selectedRep = repo;
                                            nrBranches = fetchNrBranches();
                                            nrCommits = fetchNrCommits();
                                            license = fetchLicense();

                                            pageIndex = 1;
                                            print("set");
                                          }),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(repo.title),
                                          subtitle: Text(description),
                                          trailing: Container(
                                              alignment: Alignment.topLeft,
                                              width: 100,
                                              height: 100,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Stars: $stars'),
                                                  Text('Followers: $forks'),
                                                ],
                                              )),
                                          isThreeLine: true,
                                        ),
                                      ));
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Container(
                                  width: 100,
                                  height: 100,
                                  child: Text("oopsie woopsie"));// ${snapshot.error}
                            }

                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      )
                    ],
                  )
                : Container(
                    child: Column(
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "back",
                          style: TextStyle(
                            color: Colors.grey[100],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.album),
                              title: Text(selectedTitle),
                              subtitle: Text(selectedRep.description != null ? selectedRep.description : " No description"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Stargazers:"),
                                Text(selectedRep.stars.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("forks:"),
                                Text(selectedRep.forks.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Watchers:"),
                                Text(selectedRep.watchers.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("branches:"),
                                FutureBuilder(
                                      future: nrBranches,
                                      builder: (context, snapshot) {
                                          return Text( snapshot.hasData ? snapshot.data : "Loading");
                                      }
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("commits:"),
                                FutureBuilder(
                                    future: nrCommits,
                                    builder: (context, snapshot) {
                                      return Text( snapshot.hasData ? snapshot.data : "Loading");
                                    }
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("license:"),
                                FutureBuilder(
                                    future: license,
                                    builder: (context, snapshot) {
                                      return Text( snapshot.hasData ? snapshot.data : "Loading");
                                    }
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ))));
  }
}
