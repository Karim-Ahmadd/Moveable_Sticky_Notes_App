import 'package:flutter/material.dart';
//import 'package:project2/stickynote.dart';
import 'moveablestickynote.dart';
import "apiCall.dart" as api;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Moveable Sticky Notes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _load = false;
  static const Map<String, Color> colorMap = <String, Color>{
    'green': Colors.green,
    'yellow': Colors.yellow,
    'red': Colors.red
  };

  List<Widget> stickyNotes = [];

  String noteColor = 'green';
  final TextEditingController taskTextController = TextEditingController();

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Connection Error')));
      }
    });
  }

  void deleteStickyNote(int id) async {
    await api.deleteStickyNote(update, id);
    setState(() {
      updateStickyNotes();
    });
  }

  void updateStickyNotePos(int id, double x, double y) async {
    await api.updateStickyNotesPos(update, id, x, y);
  }

  void updateStickyNotes() async {
    stickyNotes.clear();
    final jsonResponse = await api.getStickyNotes(update);

    for (var row in jsonResponse) {
      MoveableStickyNote m = MoveableStickyNote(
          key: UniqueKey(),
          id: int.parse(row['ID']),
          color: colorMap[row['color']] as Color,
          xRatio: double.parse(row['xPositionRatio']),
          yRatio: double.parse(row["yPositionRatio"]),
          fRemoveNote: deleteStickyNote,
          updateStickyNotePos: updateStickyNotePos,
          child: Text(row['text']));

      stickyNotes.add(m);
    }
  }

  @override
  void initState() {
    super.initState();
    updateStickyNotes();
  }

  void updateColor(String c) {
    noteColor = c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: !_load
                  ? null
                  : () {
                      setState(() {
                        _load = false; //show progress bar
                        updateStickyNotes();
                      });
                    },
              icon: const Icon(Icons.refresh))
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: !_load
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()))
          : Center(child: Stack(children: stickyNotes)),
      bottomNavigationBar: BottomPostForm(
          taskTextController: taskTextController, fUpdateColor: updateColor),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() async {
              await api.insertStickyNote(
                  update, taskTextController.text, noteColor);
              updateStickyNotes();
            });
          },
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class BottomPostForm extends StatelessWidget {
  const BottomPostForm(
      {super.key,
      required this.taskTextController,
      required this.fUpdateColor});
  final Function(String) fUpdateColor;
  final TextEditingController taskTextController;
  static const Map<String, String> priorityMap = <String, String>{
    'Low': "green",
    'Medium': "yellow",
    'High': "red"
  };

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Row(
          children: [
            SizedBox(
                width: 130,
                child: TextField(
                    controller: taskTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Task',
                    ))),
            const SizedBox(width: 20),
            const Text("Priority:"),
            const SizedBox(width: 10),
            DropdownMenu(
                onSelected: (value) {
                  fUpdateColor(value as String);
                },
                initialSelection: "green",
                dropdownMenuEntries: priorityMap.entries
                    .map<DropdownMenuEntry<String>>(
                        (e) => DropdownMenuEntry(value: e.value, label: e.key))
                    .toList())
          ],
        )));
  }
}
