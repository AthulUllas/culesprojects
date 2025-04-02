import 'package:culesprojects/controller/addcategorycontroller.dart';
import 'package:culesprojects/views/pages/webviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Projectspage extends ConsumerWidget {
  const Projectspage({
    super.key,
    required this.appBarTitle,
    required this.projectsLength,
  });

  final String appBarTitle;
  final int projectsLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        shape: Border(bottom: BorderSide(color: Colors.red, width: 0.1)),
        centerTitle: true,
      ),
      body: services.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(child: Text('No projects found'));
          }
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewPage(
                            webViewUrl: services[index].details[index]['url'],
                          ),
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
                  child: Center(
                    child: Text(
                      services[index].details[index]['name'],
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text("Text : $error")),
        loading: () => Center(child: CircularProgressIndicator()),
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
