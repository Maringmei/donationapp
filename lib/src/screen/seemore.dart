import 'package:flutter/material.dart';

class Seemore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('See More ListView Example')),
        body: MyListView(),
      ),
    );
  }
}

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  int initialItemCount = 10;

  List<String> dataItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
    'Item 11',
    'Item 12',
    'Item 13',
    'Item 14',
    'Item 15',
    'Item 16',
    'Item 17',
    'Item 18',
    'Item 19',
    'Item 20',
    'Item 21',
    'Item 22',
    'Item 23',
    'Item 24',
    'Item 25',
    'Item 26',
    'Item 27',
    'Item 28',
    'Item 29',
    'Item 30',
    'Item 31',
    'Item 32',
    'Item 33',
    'Item 34',
    'Item 35',
    'Item 36',
    'Item 37',
    'Item 38',
    'Item 39',
    'Item 40',
    'Item 41',
    'Item 42',
    'Item 43',
    'Item 44',
    'Item 45',
    'Item 46',
    'Item 47',
    'Item 48',
    'Item 49',
    'Item 50',
    'Item 51',
    'Item 62',
    'Item 63',
    'Item 64',
    'Item 65',
    'Item 66',
    'Item 67',
    'Item 68',
    'Item 69',
    'Item 70',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: initialItemCount,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataItems[index]),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              initialItemCount += 10;
            });
          },
          child: Text('See More'),
        ),
      ],
    );
  }
}