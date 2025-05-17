import 'package:culesprojects/controller/addprojectscontroller.dart';
import 'package:culesprojects/utils/alertbox.dart';
import 'package:culesprojects/utils/colors.dart';
import 'package:culesprojects/utils/snackbar.dart';
import 'package:culesprojects/views/pages/webviewpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:quickalert/models/quickalert_type.dart';

class Projectspage extends ConsumerWidget {
  const Projectspage({
    super.key,
    required this.appBarTitle,
    required this.projectId,
    required this.projectDetailsLength,
    required this.isSuperUser,
  });

  final String appBarTitle;
  final String projectId;
  final int projectDetailsLength;
  final bool isSuperUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(detailsProvider.notifier).setServiceId(projectId);
    final detailsState = ref.watch(detailsProvider);
    final addProjectTextController = TextEditingController();
    final addProjectUrlTextController = TextEditingController();
    final colors = Colours();
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        shape: Border(
          bottom: BorderSide(color: colors.primaryColor, width: 0.1),
        ),
        centerTitle: true,
      ),
      body: detailsState.when(
        data: (details) {
          if (details.isEmpty) {
            return Center(child: Text('No projects found'));
          }
          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => WebViewPage(
                            webViewUrl: Uri.parse(details[index]['url']),
                            appBarTitle: details[index]['name'],
                          ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primaryColor, width: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          details[index]['name'],
                          style: TextStyle(
                            color: colors.primaryTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: IconButton(
                          onPressed:
                              isSuperUser
                                  ? () {
                                    alertBox(
                                      context,
                                      QuickAlertType.warning,
                                      () {
                                        ref
                                            .read(detailsProvider.notifier)
                                            .removeDetail({
                                              'name': details[index]['name'],
                                              'url': details[index]['url'],
                                            });
                                        Navigator.of(context).pop();
                                      },
                                      () {
                                        Navigator.pop(context);
                                      },
                                      "Delete the project ?",
                                    );
                                  }
                                  : null,
                          icon: Icon(EvaIcons.trash, size: 26),
                        ),
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
          if (isSuperUser) {
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
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Text(
                                    "Enter your project details",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colors.primaryColor,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: addProjectTextController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Project Name",
                                      hintStyle: TextStyle(
                                        color: colors.textFieldHintColor,
                                      ),
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
                                      color: colors.primaryColor,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: addProjectUrlTextController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          "Enter the web URL of the project",
                                      hintStyle: TextStyle(
                                        color: colors.textFieldHintColor,
                                      ),
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
                                  color: colors.doneButtonColor,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (addProjectUrlTextController.text
                                        .isUrl()) {
                                      if (addProjectTextController
                                              .text
                                              .isNotEmpty &&
                                          addProjectUrlTextController
                                              .text
                                              .isNotEmpty) {
                                        ref
                                            .read(detailsProvider.notifier)
                                            .addDetail({
                                              'name':
                                                  addProjectTextController.text,
                                              'url':
                                                  addProjectUrlTextController
                                                      .text,
                                            });
                                        addProjectTextController.clear();
                                        addProjectUrlTextController.clear();
                                        Navigator.pop(context);
                                      } else {
                                        snackBar(
                                          "Textfield empty !!!",
                                          context,
                                        );
                                      }
                                    } else {
                                      snackBar("Not a valid URL", context);
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
          } else {
            snackBar("Users cannot access it", context);
          }
        },
        child: Icon(EvaIcons.plus),
      ),
    );
  }
}
