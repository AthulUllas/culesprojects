import 'package:culesprojects/controller/addcategorycontroller.dart';
import 'package:culesprojects/utils/alertbox.dart';
import 'package:culesprojects/utils/colors.dart';
import 'package:culesprojects/utils/snackbar.dart';
import 'package:culesprojects/views/pages/projectspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:quickalert/models/quickalert_type.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key, required this.isSuperUser});

  final bool isSuperUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addCategoryTextfieldController = TextEditingController();
    final addProjectTextfieldController = TextEditingController();
    final projectUrlTextfieldController = TextEditingController();
    final newCategoryNameTextfieldController = TextEditingController();
    final services = ref.watch(servicesProvider);
    final colors = Colours();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset("assets/images/unicule logo.png", scale: 6),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(color: colors.primaryTextColor, width: 0.1),
        ),
      ),
      body: services.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(child: Text("No data available"));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                final projectId = services[index].id;
                final projectDetailsLength = services[index].details.length;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Projectspage(
                              appBarTitle: services[index].name,
                              projectId: projectId,
                              projectDetailsLength: projectDetailsLength,
                              isSuperUser: isSuperUser,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colors.primaryColor,
                        width: 0.3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed:
                                    isSuperUser
                                        ? () {
                                          alertBox(
                                            context,
                                            QuickAlertType.warning,
                                            () {
                                              ref
                                                  .read(
                                                    servicesProvider.notifier,
                                                  )
                                                  .deleteService(
                                                    services[index].id,
                                                  );
                                              Navigator.of(context).pop();
                                            },
                                            () {
                                              Navigator.pop(context);
                                            },
                                            "Delete the category ?",
                                          );
                                        }
                                        : null,
                                icon: Icon(EvaIcons.trash),
                              ),
                              IconButton(
                                onPressed:
                                    isSuperUser
                                        ? () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom:
                                                      MediaQuery.of(
                                                        context,
                                                      ).viewInsets.bottom,
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.3,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 24.0,
                                                                    top: 24,
                                                                  ),
                                                              child: Text(
                                                                "Change category name",
                                                                style: TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets.all(
                                                                      24,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color:
                                                                        colors
                                                                            .primaryColor,
                                                                    width: 0.5,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                                child: TextField(
                                                                  controller:
                                                                      newCategoryNameTextfieldController,
                                                                  decoration: InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Category name",
                                                                    hintStyle:
                                                                        TextStyle(
                                                                          color:
                                                                              colors.textFieldHintColor,
                                                                        ),
                                                                    contentPadding:
                                                                        EdgeInsets.only(
                                                                          left:
                                                                              12,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 16.0,
                                                              ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                                child: Container(
                                                                  height: 50,
                                                                  width: 110,
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        colors
                                                                            .doneButtonColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    border: Border.all(
                                                                      color:
                                                                          colors
                                                                              .primaryTextColor,
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Cancel",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  ref
                                                                      .read(
                                                                        servicesProvider
                                                                            .notifier,
                                                                      )
                                                                      .updateServiceName(
                                                                        id:
                                                                            services[index].id,
                                                                        newName:
                                                                            newCategoryNameTextfieldController.text,
                                                                      );
                                                                  snackBar(
                                                                    "Name changed",
                                                                    context,
                                                                  );
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop();
                                                                },
                                                                child: Container(
                                                                  height: 50,
                                                                  width: 110,
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        colors
                                                                            .okButtonColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    border: Border.all(
                                                                      color:
                                                                          colors
                                                                              .primaryTextColor,
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "OK",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                        : null,
                                icon: Icon(EvaIcons.edit),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 96.0),
                            child: Text(
                              services[index].name,
                              style: TextStyle(
                                color: colors.primaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error : $error")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
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
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Text(
                                    "Enter your category details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
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
                                    controller: addCategoryTextfieldController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Category name",
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
                                    controller: addProjectTextfieldController,
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
                                    controller: projectUrlTextfieldController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your project URL here",
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
                                    color: colors.primaryTextColor,
                                    width: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (projectUrlTextfieldController.text
                                        .isUrl()) {
                                      if (addCategoryTextfieldController
                                              .text
                                              .isNotEmpty &&
                                          addProjectTextfieldController
                                              .text
                                              .isNotEmpty &&
                                          projectUrlTextfieldController
                                              .text
                                              .isNotEmpty) {
                                        ref
                                            .read(servicesProvider.notifier)
                                            .addService(
                                              addCategoryTextfieldController
                                                  .text,
                                              [
                                                {
                                                  "name":
                                                      addProjectTextfieldController
                                                          .text,
                                                  "url":
                                                      projectUrlTextfieldController
                                                          .text,
                                                },
                                              ],
                                            );
                                        addCategoryTextfieldController.clear();
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
            snackBar("Users cannot access", context);
          }
        },
        child: Icon(EvaIcons.plus),
      ),
    );
  }
}
