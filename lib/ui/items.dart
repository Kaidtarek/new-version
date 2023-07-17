import 'package:flutter/material.dart';
import 'package:kafil/screens/material_item_screen.dart';



bool get = true;

class MyItems extends StatefulWidget {
  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  List<Item> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Event",
          style: TextStyle(color: Colors.teal, fontSize: 30),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newItem = await showDialog<Item>(
            context: context,
            builder: (BuildContext context) => ItemDialog(),
          );
          if (newItem != null) {
            setState(() {
              itemList.add(newItem);
            });
          }
        },
        child: Image.asset('assets/add_item.png'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext Context) {
                      return MaterialScreen(
                          titleController: itemList[index].name);
                    }));
                  },
                  icon: Icon(itemList[index].iconData),
                  iconSize: 40,
                  color: itemList[index].color,
                ),
                SizedBox(height: 5),
                Text(
                  itemList[index].name,
                  style: TextStyle(
                    color: itemList[index].color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ItemDialog extends StatefulWidget {
  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final TextEditingController itemNameController = TextEditingController();
  IconData selectedIcon = Icons.add;
  Color selectedColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('نشاط جديد'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(labelText: 'اسم النشاط'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('اختر ايقونة النشاط:'),
                IconButton(
                  onPressed: () async {
                    var icon = await showDialog<IconData>(
                      context: context,
                      builder: (BuildContext context) => IconPickerDialog(),
                    );
                    if (icon != null) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    }
                  },
                  icon: Icon(selectedIcon),
                  iconSize: 40,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('اختر اللون:'),
                IconButton(
                  onPressed: () async {
                    var color = await showDialog<Color>(
                      context: context,
                      builder: (BuildContext context) => ColorPickerDialog(),
                    );
                    if (color != null) {
                      setState(() {
                        selectedColor = color;
                      });
                    }
                  },
                  icon: Icon(Icons.color_lens),
                  color: selectedColor,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('الغاء', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            String itemName = itemNameController.text;
            Navigator.pop(
              context,
              Item(itemName, selectedIcon, selectedColor),
            );
          },
          child: Text('خفظ'),
        ),
      ],
    );
  }
}

class IconPickerDialog extends StatelessWidget {
  final List<IconData> icons = [
    Icons.shopping_basket_outlined,
    Icons.dark_mode_outlined,
    Icons.mosque_outlined,
    Icons.checkroom_outlined,
    Icons.holiday_village,
    Icons.add_box,
    Icons.school,
    Icons.home,
    Icons.attach_money,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('اختر الأيقونة'),
      content: SingleChildScrollView(
        child: Wrap(
          children: [
            for (var iconData in icons)
              IconButton(
                icon: Icon(iconData),
                onPressed: () {
                  Navigator.pop(context, iconData);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  @override
  final List<Color> MyColors = [
    Colors.black,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.pinkAccent,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.lime,
    Colors.red,
    Colors.pink,
    Colors.pinkAccent,
    Color.fromARGB(255, 224, 0, 205),
    Color.fromARGB(255, 62, 123, 9),
    Colors.cyan,
  ];
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('اختر اللون'),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          children: [
            for (var color in MyColors)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, color);
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final IconData iconData;
  final Color color;

  Item(this.name, this.iconData, this.color);
}
