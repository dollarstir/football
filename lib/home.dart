import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football/web.dart';
import './searchbar.dart';
import './result_item.dart';
import './result_list.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  _MyHomePageState state = _MyHomePageState();
  @override
  _MyHomePageState createState() => state;
}

class _MyHomePageState extends State<HomeScreen> {
  List<String> titleList;
  List<String> titleList1;
  List<String> titleList2;
  var mylink;

  @override
  void initState() {
    super.initState();
    initChaptersTitleScrap();
  }

  Future getlink()async {
    var box = Hive.box('football');

    var ll =   box.get('link');
    var lo = ll.toString(); 
    var url = 'https://football.dollarstir.tk/';
    var response = await http.post(url,
    body: {'link':lo},
    );
    var res = jsonDecode(response.body);
    print(res);

 box.put('vidlink', res.toString());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Scrapping'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 56),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   'Scrapped data is: ',
              //   style: TextStyle(fontSize: 22, color: Colors.indigo),
              // ),
              SizedBox(
                height: 10,
              ),

              ListView.builder(
                  shrinkWrap: true,
                  itemCount: titleList.length,
                  itemBuilder: (BuildContext context, index) {
                    if ( titleList != null ){
                      return Container(
                      child: Column(
                        children: [
                          Image(
                            image: NetworkImage(
                              titleList[index],
                            ),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Text(titleList1[index]),
                          Text(titleList2[index]),
                          GestureDetector(
                            onTap: ()async{
                              var box  = Hive.box('football');
                              
                              var mm = box.put("link",titleList2[index] );
                              print(box.get("link"));
                              
                              print(titleList2[index]);
                              getlink();

                              Route route =
                          MaterialPageRoute(builder: (c) => Myweb());
                      Navigator.push(context, route);


                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .19,
                              width: double.infinity,
                              color: Colors.teal,
                              child: Text("CLick"),
                            ),
                          ),
                        ],
                      ),
                    );
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  })
              // if (titleList != null)
              //   for (final title1 in titleList1)
              //     Padding(padding: EdgeInsets.all(4.0),
              //     child: Text(title1),
              //     ),
              //   for (final title in titleList)
              //     Padding(
              //       padding: const EdgeInsets.all(4.0),
              //       child: Image(
              //         image: NetworkImage(title),width: MediaQuery.of(context).size.width * 0.1,height: MediaQuery.of(context).size.height * 0.1,

              //       ),
              //     )}

              // else
              //   CircularProgressIndicator(),

              // Expanded(child:
              //     for (final title1 in titleList1) {
              //       Padding(padding: EdgeInsets.all(4.0),
              //       child: Text(title1),
              //       ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void initChaptersTitleScrap() async {
    final rawUrl = 'http://www.hesgoal.com/leagues/11/Football_News';
    final webScraper = WebScraper('http://www.hesgoal.com');
    final endpoint = rawUrl.replaceAll(r'http://www.hesgoal.com', '');
    if (await webScraper.loadWebPage(endpoint)) {
      final titleElements =
          webScraper.getElement('div.icon > a > img', ['src']);
      print(titleElements);

      final titleElements1 =
          webScraper.getElement('div.desc > p.link', ['title']);
      print(titleElements1);

      final titleElements2 = webScraper.getElement('p.link > a', ['href']);
      print(titleElements2);
      final titleList = <String>[];
      final titleList1 = <String>[];
      final titleList2 = <String>[];

      titleElements1.forEach((el) {
        final title1 = el["title"];
        int i = titleElements1.indexOf(el);
        var ko = (titleElements1[i]['title'].toString());
        titleList1.add(ko);
      });

      titleElements2.forEach((elo) {
        final title2 = elo["title"];
        int i = titleElements2.indexOf(elo);
        var kon = (titleElements2[i]['attributes']['href']);
        titleList2.add(kon);
      });

      titleElements.forEach((element) {
        final title = element['title'];

        int i = titleElements.indexOf(element);
        var koo = (titleElements[i]['attributes']['src']);
        titleList.add('$koo');
      });
      print(titleList);
      print(titleList1);
      print(titleList2);
      if (mounted)
        setState(() {
          this.titleList = titleList;
          this.titleList1 = titleList1;
          this.titleList2 = titleList2;
        });
    } else {
      print('Cannot load url');
    }
  }
}
