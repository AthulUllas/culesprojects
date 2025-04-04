import 'package:culesprojects/controller/addcategorycontroller.dart';
import 'package:culesprojects/features/authentication/authpage.dart';
import 'package:culesprojects/views/pages/projectspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key, required this.isSuperUser});

  final bool isSuperUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addCategoryTextfieldController = TextEditingController();
    final addProjectTextfieldController = TextEditingController();
    final projectUrlTextfieldController = TextEditingController();
    final newCategoryNameTextfieldController = TextEditingController();
    // final superUser = Supabase.instance.client.auth.currentUser!.email;
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset("assets/images/unicule logo.png", scale: 6),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Colors.black, width: 0.1)),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 12.0),
          //   child: IconButton(
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             title: Text("Sign Out"),
          //             content: Text("Are you sure you want to Logout ?"),
          //             actions: [
          //               TextButton(
          //                 onPressed: () {
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: Text("Cancel"),
          //               ),
          //               TextButton(
          //                 onPressed: () {
          //                   final supaBase = Supabase.instance.client;
          //                   supaBase.auth.signOut();
          //                   Navigator.pushAndRemoveUntil(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => Authpage(),
          //                     ),
          //                     (route) => false,
          //                   );
          //                 },
          //                 child: Text("OK"),
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //     icon: Icon(Icons.logout_rounded, size: 28),
          //   ),
          // ),
        ],
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
                      border: Border.all(color: Colors.red, width: 0.3),
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
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Confirm"),
                                                content: Text(
                                                  "Are you Sure you want to delete ?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      ref
                                                          .read(
                                                            servicesProvider
                                                                .notifier,
                                                          )
                                                          .deleteService(
                                                            services[index].id,
                                                          );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Text("OK"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        : null,
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed:
                                    isSuperUser
                                        ? () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Edit"),
                                                content: Container(
                                                  margin: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.red,
                                                      width: 0.2,
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
                                                      border: InputBorder.none,
                                                      hintText: "Category name",
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                            left: 12,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      ref
                                                          .read(
                                                            servicesProvider
                                                                .notifier,
                                                          )
                                                          .updateServiceName(
                                                            id:
                                                                services[index]
                                                                    .id,
                                                            newName:
                                                                newCategoryNameTextfieldController
                                                                    .text,
                                                          );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Text("OK"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        : null,
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 96.0),
                            child: Text(
                              services[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
                                      color: Colors.red,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: addCategoryTextfieldController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Category name",
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
                                    controller: addProjectTextfieldController,
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
                                    controller: projectUrlTextfieldController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your project URL here",
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                              bottom: 50,
                                              left: 20,
                                              right: 20,
                                            ),
                                            content: Text(
                                              "Textfield empty !!!",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                            showCloseIcon: true,
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.only(
                                            bottom:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets.bottom,
                                            left: 20,
                                            right: 20,
                                          ),
                                          content: Text(
                                            "Not a valid URL",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          duration: Duration(seconds: 3),
                                          showCloseIcon: true,
                                        ),
                                      );
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red,
                showCloseIcon: true,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 50, right: 20, left: 20),
                content: Text(
                  "Users cannot access this",
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
