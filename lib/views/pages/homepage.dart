import 'package:culesprojects/controller/addcategorycontroller.dart';
import 'package:culesprojects/views/pages/projectspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addCategoryTextfieldController = TextEditingController();
    final addProjectTextfieldController = TextEditingController();
    final projectUrlTextfieldController = TextEditingController();
    final superUser = Supabase.instance.client.auth.currentUser!.email;
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset("assets/images/unicule logo.png", scale: 6),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Colors.black, width: 0.1)),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12.0),
        //     child: IconButton(
        //       onPressed: () {
        //         ref.read(servicesProvider.notifier).fetchServices();
        //       },
        //       icon: Icon(Icons.refresh, size: 28),
        //     ),
        //   ),
        // ],
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
                            ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red, width: 0.3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          services[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: IconButton(
                            onPressed: () {
                              if (superUser == "culesapp1@gmail.com") {
                                ref
                                    .read(servicesProvider.notifier)
                                    .deleteService(services[index].id);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    margin: EdgeInsets.only(
                                      bottom: 50,
                                      right: 20,
                                      left: 20,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      "Users cannot access it",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    duration: Duration(milliseconds: 100),
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      ],
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
          if (superUser == "culesapp1@gmail.com") {
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
                backgroundColor: Colors.red,
                margin: EdgeInsets.only(bottom: 50, right: 20, left: 20),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "Users cannot access it",
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(milliseconds: 100),
                showCloseIcon: true,
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
