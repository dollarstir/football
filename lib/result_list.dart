import 'package:flutter/material.dart';
import './resultitem.dart';
import 'package:web_scraper/web_scraper.dart';
class ResultList extends StatefulWidget {
  final String search;

  const ResultList({Key key, this.search}) : super(key: key);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {
  bool loaded = false;
  List<ResultItem> resultList = List();

  String etsyUrl = 'http://www.hesgoal.com';
  String pageEtension = '/leagues/11/Football_News';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final webScraper = WebScraper(etsyUrl);
    print(webScraper.getPageContent());
    if (await webScraper.loadWebPage(
        '$pageEtension${widget.search.trim().replaceAll(' ', '%20')}')) {
      List<Map<String, dynamic>> images = webScraper.getElement(
          'div.file browse_file > div.icon > a > img',
          ['src']);
      List<Map<String, dynamic>> descriptions = webScraper.getElement(
          'div.file browse_file > div.desc > p.link > a', ['title']);
      List<Map<String, dynamic>> etsyPrices =
          webScraper.getElement('div.file browse_file > div.desc > p.link > a', ['href']);
      List<Map<String, dynamic>> urls = webScraper.getElement(
          'div.file browse_file > div.desc > p.link > a',
          ['href', 'title']);

      images.forEach((image) {
        int i = images.indexOf(image);
        resultList.add(
          ResultItem(
            image: images[i]['attributes']['src'],
            description: descriptions[i]['title'].toString().trim(),
            url: urls[i]['attributes']['href'],
            price: etsyPrices[i]['title'],
          ),
        );
      });
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (loaded)
            ? ListView(
                physics: BouncingScrollPhysics(),
                children: resultList.getRange(0, 5).toList(),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}