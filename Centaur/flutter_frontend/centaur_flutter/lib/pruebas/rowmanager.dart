import 'package:flutter/material.dart';

void main() {
  runApp(RowManager());
}

class RowManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Manage TextFields Example')),
        body: TextFieldManager(),
      ),
    );
  }
}

class TextFieldManager extends StatefulWidget {
  @override
  _TextFieldManagerState createState() => _TextFieldManagerState();
}

class _TextFieldManagerState extends State<TextFieldManager> {
  List<Widget> textFields = [buildTextField()];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final Widget item = textFields.removeAt(oldIndex);
                textFields.insert(newIndex, item);
              });
            },
            children: textFields
                .asMap()
                .map((index, item) => MapEntry(
                      index,
                      ListTile(
                        key: Key('$index'), // Unique key for each ListTile
                        title: item, // Use item (TextField) directly
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              textFields.removeAt(index); // Delete the TextField at index
                            });
                          },
                        ),
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              textFields.insert(1, buildTextField()); // Add a new TextField at a specific position
            });
          },
          child: Text('Add TextField'),
        ),
      ],
    );
  }

  static Widget buildTextField() {
    return TextField(
      decoration: InputDecoration(hintText: 'Enter something'),
    );
  }
}


