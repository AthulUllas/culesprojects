import 'package:culesprojects/controller/addcategorycontroller.dart';
import 'package:culesprojects/views/pages/webviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Projectspage extends ConsumerWidget {
  const Projectspage({
    super.key,
    required this.appBarTitle,
    required this.projectId,
    required this.projectDetailsLength,
  });

  final String appBarTitle;
  final String projectId;
  final int projectDetailsLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider);
    final addProjectTextController = TextEditingController();
    final addProjectUrlTextController = TextEditingController();
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
            itemCount: projectDetailsLength,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewPage(
                            webViewUrl: services[index].details[index]['url'],
                            appBarTitle: services[index].details[index]['name'],
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
                  child: Row(
                    children: [
                      Text(
                        services[index].details[index]['name'],
                        style: TextStyle(color: Colors.amber),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(servicesProvider.notifier)
                              .removeDetailFromService(services[index].id, {
                                "name": services[index].details[index]['name'],
                                "url": services[index].details[index]['url'],
                              });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
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
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: addProjectTextController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Project Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.only(left: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: addProjectUrlTextController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Project Url",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    contentPadding: EdgeInsets.only(left: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (addProjectTextController
                                          .text
                                          .isNotEmpty &&
                                      addProjectUrlTextController
                                          .text
                                          .isNotEmpty) {
                                    ref
                                        .read(servicesProvider.notifier)
                                        .addDetailToService(projectId, {
                                          "name": addProjectTextController.text,
                                          "url":
                                              addProjectUrlTextController.text,
                                        });
                                  }
                                },
                                icon: Icon(Icons.done),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
