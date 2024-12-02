import 'package:flutter/material.dart';
import 'moveablestickynote.dart';

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
  Color noteColor = Colors.green;
  List<Widget> stickyNotes = [];
  final TextEditingController taskTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    stickyNotes = [
      MoveableStickyNote(
          key: UniqueKey(),
          color: noteColor,
          fRemoveNote: removeStickyNote,
          child: const Text("Type your Task below, Add it, then Move it"))
    ];
  }

  void updateColor(Color c) {
    noteColor = c;
  }

  void addStickyNote() {
    if (taskTextController.text.isNotEmpty) {
      setState(() {
        stickyNotes.add(MoveableStickyNote(
            key: UniqueKey(),
            color: noteColor,
            fRemoveNote: removeStickyNote,
            child: Text(taskTextController.text)));
        taskTextController.clear();
      });
    }
  }

  void removeStickyNote(int targetId) {
    setState(() {
      stickyNotes
          .removeWhere((item) => (item as MoveableStickyNote).id == targetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(child: Stack(children: stickyNotes)),
      bottomNavigationBar: BottomPostForm(
          taskTextController: taskTextController, fUpdateColor: updateColor),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addStickyNote();
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
  final Function(Color) fUpdateColor;
  final TextEditingController taskTextController;
  static const Map<String, Color> priorityMap = <String, Color>{
    'Low': Colors.green,
    'Medium': Colors.yellow,
    'High': Colors.red
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
                  fUpdateColor(value as Color);
                },
                initialSelection: Colors.green,
                dropdownMenuEntries: priorityMap.entries
                    .map<DropdownMenuEntry<Color>>(
                        (e) => DropdownMenuEntry(value: e.value, label: e.key))
                    .toList())
          ],
        )));
  }
}
