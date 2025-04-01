import 'package:culesprojects/views/pages/webviewpage.dart';
import 'package:flutter/material.dart';

class Projectspage extends StatelessWidget {
  const Projectspage({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    final projectList = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        shape: Border(bottom: BorderSide(color: Colors.red, width: 0.1)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => WebViewPage(webViewUrl: projectList[index]),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.3),
                color: const Color.fromARGB(255, 246, 219, 216),
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              height: 100,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
