// ignore_for_file: use_build_context_synchronously

import 'package:hive_flutter/adapters.dart';
import 'package:sil1/hive_provider.dart';
import 'package:sil1/models/check_model.dart';
import 'package:flutter/material.dart';
import 'package:sil1/constant.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CheckModelAdapter());
  await Hive.openBox<CheckModel>('modelVerisi');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HiveProvider>(
          create: (context) => HiveProvider(),
        )
      ],
      child: const MaterialApp(
        title: 'Flutter Hello World',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<CheckModel> _allTask = [];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var data = Provider.of<HiveProvider>(context, listen: false);
    checkList = await data.getData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var hiveData = Provider.of<HiveProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Demo')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: checkList.length,
                itemBuilder: (context, index) {
                  print(index);
                  return Dismissible(
                    key: UniqueKey(),
                    background: _deleteMethod(),
                    confirmDismiss: (direction) {
                      return _buildShowDialog(context, index, hiveData);
                    },
                    onDismissed: (direction) {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(checkList[index].name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _textEditingController,
              obscureText: false,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Kayıt Ekle',
                labelStyle: TextStyle(color: Colors.red),
                border: InputBorder.none,
                fillColor: Colors.white,
                focusColor: Colors.grey,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_textEditingController.text.isNotEmpty) {
                        CheckModel yeniEkle = CheckModel.create(
                            name: _textEditingController.text);
                        checkList.add(yeniEkle);

                        hiveData.addData(yeniEkle);
                      }
                    },
                    child: const Text('Ekle'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _deleteMethod() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
            size: 21,
          ),
        ],
      ),
    );
  }

  Future<bool?> _buildShowDialog(
      BuildContext context, int index, HiveProvider data) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '${listem[index]} kaydını silmek istediğinizden emin misini ?',
            style: const TextStyle(fontSize: 21),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //  data.removeData(index);
                Navigator.pop(context);
              },
              child: const Text('Evet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hayır'),
            ),
          ],
        );
      },
    );
  }
}
