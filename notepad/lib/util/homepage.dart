import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  Box? notepad;
  @override
  void initState() {
    // TODO: implement initState
    notepad = Hive.box('notepad');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textcontroller = TextEditingController();
    TextEditingController updatecontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HIVE TODO NOTEPAD",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(hintText: "write something ....."),
              controller: textcontroller,
            ),
          ),
          SizedBox(
            width: 400,
            child: ElevatedButton(
                onPressed: () {
                  print(textcontroller.text);
                  try {
                    final userinput = textcontroller.text;
                    notepad!.add(userinput);
                    Fluttertoast.showToast(msg: "Data added successfully!");
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Add Data",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Hive.box('notepad').listenable(),
                builder: (context, box, widget) {
                  return ListView.builder(
                    itemCount: notepad!.keys.toList().length,
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(notepad!.getAt(index).toString()),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    notepad!.delete(index);
                                    Fluttertoast.showToast(
                                        msg: "Delete successfully");
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return Dialog(
                                            child: Container(
                                              height: 200,
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "write something ....."),
                                                    controller:
                                                        updatecontroller,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          final updatetext =
                                                              updatecontroller;
                                                          notepad!.putAt(index,
                                                              updatetext);
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "data updated successfully");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("update")),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.edit),
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
    ;
  }
}
