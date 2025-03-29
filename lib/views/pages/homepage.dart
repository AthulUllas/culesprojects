import 'package:culesprojects/controller/addcategorycontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = ref.watch(listNotifierProvider);
    final categoryListNotifier = ref.read(listNotifierProvider.notifier);
    final addCategoryTextfieldController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/unicule logo.png", scale: 6),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Colors.black, width: 0.1)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: () {
                categoryListNotifier.loadData();
              },
              icon: Icon(Icons.refresh, size: 28),
            ),
          ),
        ],
      ),
      body: categoryList.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Text("Error: $e"),
        data:
            (categoryList) =>
                categoryList.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(
                          "No items",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: categoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 0.3,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categoryList[index],
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
                                        categoryListNotifier.deleteItem(
                                          categoryList[index],
                                        );
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
                    ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
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
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Text(
                                  "Enter your category name",
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
                                  if (addCategoryTextfieldController
                                      .text
                                      .isNotEmpty) {
                                    categoryListNotifier.addItem(
                                      addCategoryTextfieldController.text,
                                    );
                                    addCategoryTextfieldController.clear();
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
