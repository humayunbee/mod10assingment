import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ListItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editable List"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].title),
            subtitle: Text(items[index].description),
            onLongPress: () {
              _showEditDeleteDialog(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem() async {
    final result = await showDialog<ListItem>(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog();
      },
    );

    if (result != null) {
      setState(() {
        items.add(result);
      });
    }
  }

  void _showEditDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit or Delete?"),
          actions: <Widget>[
            TextButton(
              child: Text("Edit"),
              onPressed: () {
                _showEditDialog(index);
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteItem(index);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int index) async {
    final result = await showDialog<ListItem>(
      context: context,
      builder: (BuildContext context) {
        return EditItemDialog(items[index]);
      },
    );

    if (result != null) {
      setState(() {
        items[index] = result;
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    Navigator.pop(context);
  }
}

class ListItem {
  final String title;
  final String description;

  ListItem(this.title, this.description);
}

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Add"),
          onPressed: () {
            final title = titleController.text;
            final description = descriptionController.text;
            if (title.isNotEmpty && description.isNotEmpty) {
              Navigator.pop(context, ListItem(title, description));
            }
          },
        ),
      ],
    );
  }
}

class EditItemDialog extends StatefulWidget {
  final ListItem item;

  EditItemDialog(this.item);

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  _EditItemDialogState()
      : titleController = TextEditingController(),
        descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    descriptionController.text = widget.item.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Save"),
          onPressed: () {
            final title = titleController.text;
            final description = descriptionController.text;
            if (title.isNotEmpty && description.isNotEmpty) {
              Navigator.pop(context, ListItem(title, description));
            }
          },
        ),
      ],
    );
  }
}
